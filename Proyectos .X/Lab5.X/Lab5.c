/*
 * File:   Lab5.c
 * Author: andre
 *
 * Created on 13 de enero de 2022, 09:03 PM
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
void ColorRGB(double);
double calcularTemperatura(double,char);
void imprimirTemperatura(long,char);
unsigned int Conversion(unsigned char);
void Transmitir(unsigned char);
void TransmitirMensaje (char*);
void TransmitirNumero(unsigned int);
void TransmitirGeneral(unsigned int,char);
unsigned char Recibir(void);

double Van0,Van1,VoltAn1;
unsigned int TempCelsius,TempAn0;
char LecturaDS;
char grados[]={8,20,8,0,0,0,0,0}; 

void main(void) {
    
    ADCON0=0b00000001;  //Habilitar funciónes analógicas
    ADCON1=13;          //Función análoga A0 y A1
    ADCON2=0b10001000;  //  F_clk/2 Porque F_clk es menor a 2.5MHz

    TXSTA=0b00100100;   //Transmisión encendida, alta velocidad asincrónica
    RCSTA=0b10000000;   //Puerto serial habilitado     
    BAUDCON=0b00001000; // Rx y Tx no invertido, 16 bits Br. 
    SPBRG=25;           //9600 bps 
    //SYNC(bit 4 de TXSTA)=0, BRG16(3 de BAUDCON)=1, BRGH (2 de TXSTA)=1 Ec SPBRG= ((Fosc/Baud_rate)/4)-1
    
    TRISB=0;            //Puerto B salida
    LATB=0;             //Puerto B en 0
    
    TRISD=0;            //Puerto D salida
    LATD=0;             //Puerto D en 0
        
    TRISE0=1;           //E0 de entrada
    TRISE1=1;           //E1 de entrada

    T1CON=0b10100001;   //TMR1 config
    TMR1=3036;          //TMR1 precarga
    TMR1IF=0;           //TMR1 flag  
    TMR1IE=1;           //TMR1 enable  
    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos  

    
    __delay_ms(500);
    ConfiguraLCD(4);    //4 bits LCD
    InicializaLCD();    //Iniciar el LCD
    GuardarASCII(64,grados); // Guardar el °
    MensajeLCD_Var("Micros 2021-2");
    DireccionaLCD(0xC0);
    MensajeLCD_Var("Lab 5");
    __delay_ms(2000);
    BorraLCD();
    while(1){
        Van0=Conversion(0);
        Van1=Conversion(1);
        VoltAn1=Van1*5/1024;
        if(VoltAn1>=2.5){
            LATD0=1;
        }else{
            LATD0=0;
        }
        
        TempCelsius=20+25*Van0/512;
        LecturaDS=RE1+(RE0<<1);
        TempAn0=calcularTemperatura(Van0,LecturaDS);
        TransmitirGeneral(TempAn0,LecturaDS);
        
        ColorRGB(TempCelsius);
        
        BorraLCD();
        imprimirTemperatura(TempAn0,LecturaDS);
        DireccionaLCD(0xC0);
        EscribeLCD_2Decimales(VoltAn1);
        MensajeLCD_Var(" V");
        __delay_ms(1000);     
    }
}


void interrupt ISR(void){
    
    if(RBIF==1){
    }
    
    if(TMR1IF==1){
        TMR1=3036;
		TMR1IF=0;
        LATD1=LATD1^1;
	}

}

double calcularTemperatura(double Van0, char caso){
   double temperatura;
   double temperaturaC=20+15*Van0/512;
   
   switch(caso){
       case 0:
           temperatura=temperaturaC;
           break; 
       case 1:
           temperatura=temperaturaC+273.15;
           break;
       case 2:
           temperatura=temperaturaC*(9/5)+491.67;
           break;
       case 3:
           temperatura=temperaturaC*(9/5)+32;
           break;
       default: break;
   }
    return temperatura;
}

void imprimirTemperatura(long T, char caso){
    MensajeLCD_Var("T=");
    if(T<10){
          EscribeLCD_n8(T,1);
    }else if(T<100){
          EscribeLCD_n8(T,2);
    }else {
          EscribeLCD_n32(T,3);
        }
   switch(caso){
       case 0:
           EscribeLCD_c(' ');
           EscribeLCD_c(0);
           EscribeLCD_c('C');
           break; 
       case 1:
           EscribeLCD_c(' ');
           EscribeLCD_c('K');
           break;
       case 2:
           EscribeLCD_c(' ');
           EscribeLCD_c(0);
           EscribeLCD_c('R');
           break;
       case 3:
           EscribeLCD_c(' ');
           EscribeLCD_c(0);
           EscribeLCD_c('F');
           break;
       default: break;
   }
}

void ColorRGB(double Temp){
    if(Temp<20){
        LATB=0; //Negro
    }else if(Temp<23){
        LATB=5; //Magenta
    }else if(Temp<26){
        LATB=1; //Azul 
    }else if(Temp<29){
        LATB=3; //Cyan
    }else if(Temp<32){
        LATB=2; //Verde
    }else if(Temp<35){
        LATB=6; //Amarillo
    }else if(Temp<38){
        LATB=4; //Rojo
    }else
        LATB=7; //Blanco  
}

unsigned int Conversion(unsigned char canal){
    ADCON0=(ADCON0 & 0b00000011) | (canal<<2);
    GO=1;   //bsf ADCON0,1   GO en 1, conversión en progreso 
    while(GO==1);    
    return ADRES; //ADRES almacena en 16 bits el resultado análogo
}


unsigned char Recibir(void){
    while(RCIF==0); //RCIF ->Interrupcion de recepción de dato por el EUSART
    return RCREG;
}

void Transmitir(unsigned char BufferT){
    while(TRMT==0); //Indicador del registro de desplazamiento. Si está en 0, está lleno.
    TXREG=BufferT;  //Registro de transmisión
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

void TransmitirGeneral(unsigned int b, char caso){
    
    TransmitirMensaje("T=");
    TransmitirNumero(b);
    
switch(caso){
       case 0:
           TransmitirMensaje(" grados Celsius\n");
           break; 
       case 1:
           TransmitirMensaje(" grados Kelvin\n");
           break;
       case 2:
           TransmitirMensaje(" grados Rankine\n");
           break;
       case 3:
           TransmitirMensaje(" grados Fahrenheit\n");
           break;
       default: break;
   }
    
}
