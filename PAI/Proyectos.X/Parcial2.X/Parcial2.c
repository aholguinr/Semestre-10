/*
 * File:   Parcial2.c
 * Author: andre
 *
 * Created on 1 de febrero de 2022, 11:19 AM
 */


/*
PARCIAL 2 MICROCONTROLADORES
Andrés Holguín Restrepo
C.C. 1000794275
*/

#include <xc.h>

#define _XTAL_FREQ 1000000
#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF

unsigned char canal;
unsigned int Van;

unsigned char Recibir(void);
void Transmitir(unsigned char);
void TransmitirMensaje (char*);
void TransmitirNumero(unsigned int);
unsigned char Conversion(unsigned char canal);



void main(void) {

    TRISA=1;            //Puerto A de entrada
    TRISE=1;            //Puerto E de entrada
    
    ADCON0=0b00000001;  //Habilitar funciónes analógicas
    ADCON1=7;          //Habilitar funciones analógicas desde AN0 a AN7
    ADCON2=0b00001000;  //Justificado a la izquierda para solo tomar los 8 bits más significativos
                        // Tad=2, F_clk/2 Porque F_clk es menor a 2.5MHz
    TXSTA=0b00100100;   //Transmisión encendida, alta velocidad asincrónica
    RCSTA=0b10010000;   //Puerto serial habilitado     
    BAUDCON=0b00001000; // Rx y Tx no invertido, 16 bits Br. 
    SPBRG=25;           //9600 bps 
    
    
    __delay_ms(200);    //Delay inicial para empezar a funcionar el programa
    
    while(1){
        
        
        canal=Recibir()-48;
        
        if(canal<8&&canal>=0){
            Van=Conversion(canal);
            TransmitirNumero(Van);
        }else{
            TransmitirMensaje("ERROR");
        }

        while(tmr1IF==0);
        
    }
}


unsigned char Recibir(void){
    while(RCIF==0);
    return RCREG;
}

void Transmitir(unsigned char BufferT){
    while(TRMT==0);
    TXREG=BufferT;
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

unsigned char Conversion(unsigned char canal){
    ADCON0=(ADCON0 & 0b00000011) | (canal<<2);
    GO=1;   //bsf ADCON0,1
    while(GO==1);
    return ADRESH; //Retorna solo el registro de la izqueirda
}