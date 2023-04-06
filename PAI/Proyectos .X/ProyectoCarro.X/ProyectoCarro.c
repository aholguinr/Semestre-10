
#include<xc.h>
#include<stdlib.h>
#include <math.h>
#define _XTAL_FREQ 8000000
#include "LibLCDXC8.h"

#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF

void interrupt ISR(void);
unsigned char   Recibir(void);
void Transmitir(unsigned char);
unsigned char DatoRecibido;
unsigned int Conversion(unsigned char);
void TransmitirMensaje (char*);
void TransmitirNumero(unsigned int);
void LecturaEntrada(unsigned char);
unsigned char Caso, activado;
double Van0,Van1,Van2,Duty;


void main(void){
    IRCF1=1;          //Config para 8MHz
    IRCF0=1;          //Config para 8MHz
    

    ADCON0=0b00000001;  //Habilitar funciónes analógicas
    ADCON1=12;          //Función análoga A0 y A1 A2
    ADCON2=0b10001000;  //  F_clk/2 Porque F_clk es menor a 2.5MHz

    TXSTA=0b00100100;   //Transmisión encendida, alta velocidad asincrónica
    RCSTA=0b10010000;   //Puerto serial habilitado     
    BAUDCON=0b00001000; // Rx y Tx no invertido, 16 bits Br. 
    SPBRG=207;           //9600 bps 
    //SYNC(bit 4 de TXSTA)=0, BRG16(3 de BAUDCON)=1, BRGH (2 de TXSTA)=1 Ec SPBRG= ((Fosc/Baud_rate)/4)-1
    

    T2CON=0b00000011;   //Postscaler 1:1, Off, Prescaler 16;
    CCP1CON=0b00001100; //Implementación PWM
    CCP2CON=0b00001100; //Implementación PWM
    TMR2=0;             //Prescaler TMR2
    TMR2ON=1;           //Prender TMR2
    
    
    PR2=124;            //PWM de 1kHz
    CCPR1L=0;           
    CCPR2L=0;           //Duty inicial de 0
    
    TRISD=0;            //Puerto D salida
    LATD=0b1010001;             

    
    TRISB=0;            //Puerto B salida
    LATB=0;             //Puerto B en 0
    

    TRISE0=1;           //E0 de entrada
    TRISE1=1;           //E1 de entrada

    T0CON=0b10000101;   //TMR1 config
    TMR0=34286;          //TMR1 precarga
    TMR0IF=0;           //TMR1 flag  
    TMR0IE=1;          //TMR1 enable  
    RCIE=1;
    RCIF=0;
    
    TRISC1=0;           //Salida PWM2
    TRISC2=0;           //Salida PWM1 enable LM293D
    

    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos 
    
    activado=1;
    while(1){
        Van0=Conversion(0)*5/1024;
        Van1=Conversion(1)*5/1024;
        __delay_ms(175); 
         if(Van0<0.5&&Van1<0.5){
            Transmitir('r');           
        }else if(Van0<0.5){
            Transmitir('s');
        }else if (Van1<0.5){
            Transmitir('S');
        }else {
            Transmitir('R'); 
        }
    }
    
    
}

void interrupt ISR(void){
    
    
    if(RCIF==1){
        Caso=Recibir();
        LecturaEntrada(Caso);
        RCIF=0;
    }
    
    if(RBIF==1){
        RBIF=0;
    }
    
    if(TMR0IF==1){
        TMR0=34286;
		TMR0IF=0;
	}

}

unsigned char Recibir(void){
    while(RCIF==0);
    return RCREG;
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

    if(activado==1||entrada=='a'){
        
    switch(entrada){
        case 'a':
            Duty=0;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            activado=1;

            break;
        case 'A':
            Duty=0;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b00000010;
            activado=0;
            break;
        case 'b':
            Duty=0;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
            
        case 'B':
            Duty=0;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'c':
            Duty=0.40;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'C':
            Duty=0.40;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'd':
           Duty=0.46;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'D':
           Duty=0.46;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
            
        case 'e':
            Duty=0.52;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'E':
           Duty=0.52;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'f':
           Duty=0.58;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'F':
           Duty=0.58;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'g':
            Duty=0.64;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'G':
            Duty=0.64;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'h':
            Duty=0.70;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'H':
            Duty=0.70;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'i':
            Duty=0.76;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;            
        case 'I':
            Duty=0.76;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'j':
            Duty=0.82;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'J':
            Duty=0.82;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'k':
            Duty=0.88;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'K':
            Duty=0.88;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
        case 'l':
            Duty=0.94;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
            
        case 'L':
            Duty=0.94;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
            
        case 'm':
            Duty=1;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10100001;
            break;
        case 'M':
            Duty=1;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01010001;
            break;
            
        case 'x':
            Duty=1;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b10010001;
            break;   
            
        case 'X':
            Duty=1;
            CCPR1L=Duty*PR2;
            CCPR2L=Duty*PR2;
            LATD=0b01100001;
            break;    
            
        case 'v':
            
            Duty=1;
            CCPR1L=Duty*PR2;
            CCPR2L=0;
            LATD=0b10010001;
            break; 
            
        case 'V':
            Duty=1;
            CCPR1L=0;
            CCPR2L=Duty*PR2;
            LATD=0b01100001;
            break;    
            

        default:
            break;
        
        }
    } 
}