/*
 * File:   Lab6.c
 * Author: andre
 *
 * Created on 22 de enero de 2022, 03:34 PM
 */

#include<xc.h>
#include<stdlib.h>
#include <math.h>
#define _XTAL_FREQ 1000000
#include "LibLCDXC8.h"

#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF


void interrupt ISR(void);
void Recibir(void);
void Transmitir(unsigned char);
unsigned char DatoRecibido;
unsigned char precision;
char arreglo[];
unsigned char N, n,En;
void LecturaEntrada(unsigned char);
unsigned int Conversion(unsigned char);
void TransmitirMensaje (char*);
void TransmitirNumero(unsigned int);


double Van0, DutyI, DutyF,Duty, DeltaDuty,DutyF2;
char TiempoA,CasoGiro,Activado, IdaYvuelta;
unsigned int delay;


void main(void) {
    TRISD=0;            //Puerto D salida
    LATD=0;             //Puerto D en 0
    TRISC1=0;           //Salida PWM2
    TRISC2=0;           //Salida PWM1 enable LM293D
    TRISE0=0;           //Input 2 LM293D
    TRISE1=0;           //Input 1 LM293D
    LATE=0b0;           //Salida puerto E en 0.          

    //ADCON0=0b00000001;  //Habilitar funciónes analógicas
    ADCON1=15;          //Deshabilita pines análogos
    //ADCON2=0b10001000;  //  F_clk/2 Porque F_clk es menor a 2.5MHz
    
    PR2=249;            //PWM de 1kHz
    CCPR1L=0;           //Duty inicial de 0
    
    T2CON=0b00000000;   //Postscaler 1:1, Off, Prescaler 1;
    CCP1CON=0b00001100; //Implementación PWM
    TMR2=0;             //Prescaler TMR2
    TMR2ON=1;           //Prender TMR2       
    
    TXSTA=0b00100100;   //Transmisión encendida, alta velocidad asincrónica
    RCSTA=0b10010000;   //Puerto serial habilitado     
    BAUDCON=0b00001000; // Rx y Tx no invertido, 16 bits Br. 
    SPBRG=25;           //9600 bps 
    //SYNC(bit 4 de TXSTA)=0, BRG16(3 de BAUDCON)=1, BRGH (2 de TXSTA)=1 Ec SPBRG= ((Fosc/Baud_rate)/4)-1

    T1CON=0b10100001;   //TMR1 config
    TMR1=3036;          //TMR1 precarga
    TMR1IF=0;           //TMR1 flag  
    TMR1IE=1;           //TMR1 enable  
               
    RCIF=0;             //Recepción de un dato
    RCIE=0;             //RC enable

    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos  
    
    RBIF=0;             
    RBIE=1;  
    
    Activado=0;
    N=0;
    DutyF=0;
    DutyI=0;
    Duty=0;
    IdaYvuelta=0;
    CasoGiro=0;
    precision=1;
    TiempoA=4;
    
    
    __delay_ms(500);
    ConfiguraLCD(4);    //4 bits LCD
    InicializaLCD();    //Iniciar el LCD
    MensajeLCD_Var("Micros 2021-2");
    DireccionaLCD(0xC0);
    MensajeLCD_Var("Lab 6");
    __delay_ms(2000);
    
    
    BorraLCD();
    
    while(1){
        while(Duty!=DutyF){
            N=TiempoA*precision;
            DeltaDuty=(DutyF-DutyI)/N;
            for(n=0;n<N;n++){
                if(n==(N-1)){
                        Duty=DutyF;
                        DutyI=DutyF;
                    if(IdaYvuelta==1){
                        DutyF=DutyF2;
                        IdaYvuelta=0;
                        if(CasoGiro==1){
                            if(LATE1==1&&LATE0==0){
                                LATE=0b01;
                            }else{
                                LATE=0b10;
                            }
                            CasoGiro=0;
                        }
                    }
                    TransmitirMensaje("\nTerminó. \n");
                }else{
                    Duty+=DeltaDuty; 
                }
                CCPR1L=Duty*PR2;
                __delay_ms(1000);
            } 
        }
    }
}

void interrupt ISR(void){
    if(RCIF==1){
        Recibir();
        RCIF=0;
    }
    
    if(RBIF==1){
        if(RB7==0){
            if(Activado==1){
            RCIE=0;    
            LATE=0b0;
            Activado=0;
            }else{
                RCIE=1; 
                Activado=1;
                LATE=0b10;
                DutyI=0;
                Duty=0;
                DutyF=0;
                DutyF2=0;
                IdaYvuelta=0;
                CasoGiro=0;
                N=0;
                CCPR1L=Duty*PR2;
            }  
        }
        RBIF=0;
    }
    if(TMR1IF==1){
        TMR1=3036;
		TMR1IF=0;
        LATD1=LATD1^1;
	}
}

void Recibir(void){
    while(RCIF==0); //RCIF ->Interrupcion de recepción de dato por el EUSART
    Transmitir(RCREG);
    if(Activado==1) LecturaEntrada(RCREG);
}




void Transmitir(unsigned char BufferT){
    while(TRMT==0); //Indicador del registro de desplazamiento. Si está en 0, está lleno.
    TXREG=BufferT;  //Registro de transmisión
}

unsigned int Conversion(unsigned char canal){
    ADCON0=(ADCON0 & 0b00000011) | (canal<<2);
    GO=1;   //bsf ADCON0,1   GO en 1, conversión en progreso 
    while(GO==1);    
    return ADRES; //ADRES almacena en 16 bits el resultado análogo
}


void TransmitirMensaje (char* a){
    while(*a != '\0'){
        Transmitir(*a);
        a++;
    }
}



void TransmitirNumero(unsigned int a){
	
    unsigned char decena,unidad;
	unsigned int centena;
    int var=1;
    char b=0;
    while(a>=var){
        var*=10;
        b+=1;
    }
    
	switch(b){
		case 1: unidad=a%10;
                Transmitir(unidad+48);
				break;
		case 2:	decena=(a%100)/10;
				unidad=a%10;
				Transmitir(decena+48);
                Transmitir(unidad+48);
				break;
		case 3: centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                Transmitir(centena+48);
				Transmitir(decena+48);
                Transmitir(unidad+48);
				break;

		default: break;
	}	
}

void LecturaEntrada(unsigned char entrada){
    
    switch(entrada){
        case 'a':
            DutyI=DutyF;
            DutyF=0;
            break;
        case 'A':
            DutyI=DutyF;
            DutyF=0;
            
            break;
        case 'b':
            DutyI=DutyF;
            DutyF=0.1;
            break;
            
        case 'B':
            DutyI=DutyF;
            DutyF=0.1;
            break;
            
        case 'c':
            DutyI=DutyF;
            DutyF=0.2;
            break;
            
        case 'C':
            DutyI=DutyF;
            DutyF=0.2;
            break;
            
        case 'd':
            DutyI=DutyF;
            DutyF=0.3;
            break;
        case 'D':
            DutyI=DutyF;
            DutyF=0.3;
            break;
            
        case 'e':
            DutyI=DutyF;
            DutyF=0.4;
            break;
            
        case 'E':
            DutyI=DutyF;
            DutyF=0.4;
            break;
            
        case 'f':
            DutyI=DutyF;
            DutyF=0.5;
            break;
            
        case 'F':
            DutyI=DutyF;
            DutyF=0.5;
            break;
        case 'g':
            DutyI=DutyF;
            DutyF=0.6;
            break;
            
        case 'G':
            DutyI=DutyF;
            DutyF=0.6;
            break;
            
        case 'h':
            DutyI=DutyF;
            DutyF=0.7;
            break;
            
        case 'H':
            DutyI=DutyF;
            DutyF=0.7;
            break;
            
        case 'i':
            DutyI=DutyF;
            DutyF=0.8;
            break;            
        case 'I':
            DutyI=DutyF;
            DutyF=0.8;
            break;
            
        case 'j':
            DutyI=DutyF;
            DutyF=0.9;
            break;
            
        case 'J':
            DutyI=DutyF;
            DutyF=0.9;
            break;
            
        case 'k':
            DutyI=DutyF;
            DutyF=1;
            break;
            
        case 'K':
            DutyI=DutyF;
            DutyF=1;
            break;
        case 'l':
            //ir a 0, y volver a donde estaba
            DutyF2=DutyF;
            DutyF=0;
            IdaYvuelta=1;
            break;
            
        case 'L':
            //ir a 0, y volver a donde estaba
            DutyF2=DutyF;
            DutyF=0;
            IdaYvuelta=1;
            break;
            
        case 'm':
            DutyF=DutyI*0.5;
            break;
            
        case 'M':
            DutyF=DutyI*0.5;
            break;
            
            
        case 'n':
            if(DutyI<=0.5) DutyF=DutyI*2;
            break;            
        case 'N':
            if(DutyI<=0.5) DutyF=DutyI*2;
            break;
            
            
        case 'w':
            //Horario
            
            if(LATE1==1&&LATE0==0){
                break;
            }else if(LATE1==0&&LATE0==1&&DutyF!=0){
                DutyF2=DutyF;
                DutyF=0;
                IdaYvuelta=1;
                CasoGiro=1;
                break;
            }else{
                LATE=0b10;
                break;
            }
        case 'W':
            //Horario
            if(LATE1==1&&LATE0==0){
                break;
            }else if(LATE1==0&&LATE0==1&&DutyF!=0){
                DutyF2=DutyF;
                DutyF=0;
                IdaYvuelta=1;
                CasoGiro=1;
                break;
            }else{
                LATE=0b10;
                break;
            }
            
        case 'x':
            //Antihorario
            if(LATE1==0&&LATE0==1){
                break;
            }else if(LATE1==1&&LATE0==0&&DutyF!=0){
                DutyF2=DutyF;
                DutyF=0;
                IdaYvuelta=1;
                CasoGiro=1;
                break;
            }else{
                LATE=0b01;
                break;
            }
  
        case 'X':
            //Antihorario
            if(LATE1==0&&LATE0==1){
                break;
            }else if(LATE1==1&&LATE0==0&&DutyF!=0){
                DutyF2=DutyF;
                DutyF=0;
                IdaYvuelta=1;
                CasoGiro=1;
                break;
            }else{
                LATE=0b01;
                break;
            }    
            
        case 'y':
            TiempoA=4;
            break;
            
            
        case 'Y':
            TiempoA=4;
            break;
            
        case 'z':
            TiempoA=10;
            break;
            
        case 'Z':
            TiempoA=10;
            break;

        default:
            break;
        
    }
}