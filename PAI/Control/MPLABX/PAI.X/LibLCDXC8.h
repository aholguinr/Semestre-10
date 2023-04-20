/* 
 * File:   LibLCDXC8.h
 * Author: Robin
 *
 * Created on 2 de septiembre de 2018, 08:15 PM
 */

#ifndef LIBLCDXC8_H
#define	LIBLCDXC8_H

#ifdef	__cplusplus
extern "C" {
#endif




#ifdef	__cplusplus
}
#endif
#include<xc.h>
#ifndef _XTAL_FREQ
#define _XTAL_FREQ 10000000
#endif
#ifndef Datos
#define Datos LATD	//El puerto de conexi�n de los datos el cual se puede cambiar
#endif
#ifndef RS
#define RS LATD2	//Los pines de control al LCD los cuales se
#endif
#ifndef E
#define E LATD3	//pueden cambiar
#endif

unsigned char interfaz=8;

void ConfiguraLCD(unsigned char);
void RetardoLCD(unsigned char);
void EnviaDato(unsigned char);
void InicializaLCD(void);
void HabilitaLCD(void);
void BorraLCD(void);
void EscribeLCD_c(unsigned char);
void EscribeLCD_n8(unsigned char, unsigned char);
void MensajeLCD_Var(char[],char);
void DireccionaLCD(unsigned char);
void EscribeLCD_n32(unsigned long, unsigned char);
void EscribeLCD_2Decimales(double);
void GuardarASCII(unsigned char,char[]);

void ConfiguraLCD(unsigned char a){
	if(a==4 | a ==8)
		interfaz=a;	
}
void EnviaDato(unsigned char a){
	if(interfaz==4){
		Datos=(Datos & 0b00001111) | (a & 0b11110000);
		HabilitaLCD();
		RetardoLCD(1);
		Datos=(Datos & 0b00001111) | (a<<4);
		//HabilitaLCD();
		//RetardoLCD(1);
	}else if(interfaz==8){
		Datos=a;
	}	
}
void InicializaLCD(void){
//Funci�n que inicializa el LCD caracteres
	RS=0;
	if(interfaz==4)
		Datos=(Datos & 0b00001111) | 0x30;
	else	
		Datos=0x3F;
	HabilitaLCD();
	RetardoLCD(1);
	if(interfaz==4)
		Datos=(Datos & 0b00001111) | 0x30;
	else	
		Datos=0x3F;
	HabilitaLCD();
	RetardoLCD(3);
	if(interfaz==4)
		Datos=(Datos & 0b00001111) | 0x30;
	else	
		Datos=0x3F;
	HabilitaLCD();
	RetardoLCD(4);
	if(interfaz==4){
		Datos=(Datos & 0b00001111) | 0x20;
		HabilitaLCD();
		RetardoLCD(4);
		EnviaDato(0x2F);
		HabilitaLCD();
		RetardoLCD(4);
	}
	BorraLCD();
	EnviaDato(0xF);
	HabilitaLCD();
	RetardoLCD(4);	
}

void HabilitaLCD(void){
//Funci�n que genera los pulsos de habilitaci�n al LCD 	
	E=1;
	__delay_us(40);
    //Delay1TCY();
	E=0;
}

void BorraLCD(void){
//Funci�n que borra toda la pantalla	
	RS=0;
	EnviaDato(0x01);
	HabilitaLCD();
	RetardoLCD(2);
}

void EscribeLCD_c(unsigned char a){
//Funci�n que escribe un caracter en la pantalla
//a es un valor en codigo ascii
//Ejemplo EscribeLCD_c('A');
	RS=1;
	EnviaDato(a);
	HabilitaLCD();
	RetardoLCD(4);
}

void EscribeLCD_n8(unsigned char a,unsigned char b){
//Funci�n que escribe un n�mero positivo de 8 bits en la pantalla
//a es el n�mero a escribir, el cual debe estar en el rango de 0 a 255
//b es el n�mero de digitos que se desea mostrar empezando desde las unidades
//Ejemplo EscribeLCD_n8(204,3);	
    unsigned char centena,decena,unidad;
	RS=1;
	switch(b){
		case 1: unidad=a%10;
				EnviaDato(unidad+48);
				HabilitaLCD();
				RetardoLCD(4);
				break;
		case 2:	decena=(a%100)/10;
				unidad=a%10;
				EnviaDato(decena+48);
				HabilitaLCD();
				RetardoLCD(4);
				EnviaDato(unidad+48);
				HabilitaLCD();
				RetardoLCD(4);
				break;
		case 3: centena=a/100;
				decena=(a%100)/10;
				unidad=a%10;
				EnviaDato(centena+48);
				HabilitaLCD();
				RetardoLCD(4);
				EnviaDato(decena+48);
				HabilitaLCD();
				RetardoLCD(4);
				EnviaDato(unidad+48);
				HabilitaLCD();
				RetardoLCD(4);
				break;
		default: break;
	}
}

void EscribeLCD_n32(unsigned long a, unsigned char b){
//Funci�n que escribe un n�mero positivo de 32 bits en la pantalla
//a es el n�mero a escribir, el cual debe estar en el rango de 0 a 999999999
//para que sea de forma adecuada.
//b es el n�mero de digitos que se desea mostrar empezando desde las unidades	
    unsigned char decena,unidad;
	unsigned int centena,millar;
    unsigned long diezmil,cienmil,millon,diezmillon,cienmillon;
    RS=1;
    
	switch(b){
		case 1: unidad=a%10;
                EscribeLCD_c(unidad+48);
				break;
		case 2:	decena=(a%100)/10;
				unidad=a%10;
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
		case 3: centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
		case 4: millar=(a%10000)/1000;
                centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(millar+48);
				EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
		case 5: diezmil=(a%100000)/10000;
                millar=(a%10000)/1000;
                centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(diezmil+48);
                EscribeLCD_c(millar+48);
				EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
                
        case 6: cienmil=(a%1000000)/100000;
                diezmil=(a%100000)/10000;
                millar=(a%10000)/1000;
                centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(cienmil+48);
                EscribeLCD_c(diezmil+48);
                EscribeLCD_c(millar+48);
				EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
            
        case 7: millon=(a%10000000)/1000000;  
                cienmil=(a%1000000)/100000;
                diezmil=(a%100000)/10000;
                millar=(a%10000)/1000;
                centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(millon+48);
                EscribeLCD_c(cienmil+48);
                EscribeLCD_c(diezmil+48);
                EscribeLCD_c(millar+48);
				EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
            
            
        case 8: diezmillon=(a%100000000)/10000000;  
                millon=(a%10000000)/1000000;  
                cienmil=(a%1000000)/100000;
                diezmil=(a%100000)/10000;
                millar=(a%10000)/1000;
                centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(diezmillon+48);
                EscribeLCD_c(millon+48);
                EscribeLCD_c(cienmil+48);
                EscribeLCD_c(diezmil+48);
                EscribeLCD_c(millar+48);
				EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
            
        case 9: cienmillon=(a%1000000000)/100000000;
                diezmillon=(a%100000000)/10000000;  
                millon=(a%10000000)/1000000;  
                cienmil=(a%1000000)/100000;
                diezmil=(a%100000)/10000;
                millar=(a%10000)/1000;
                centena=(a%1000)/100;
                decena=(a%100)/10;
				unidad=a%10;
                EscribeLCD_c(cienmillon+48);
                EscribeLCD_c(diezmillon+48);
                EscribeLCD_c(millon+48);
                EscribeLCD_c(cienmil+48);
                EscribeLCD_c(diezmil+48);
                EscribeLCD_c(millar+48);
				EscribeLCD_c(centena+48);
				EscribeLCD_c(decena+48);
                EscribeLCD_c(unidad+48);
				break;
            
            
		default: break;
	}	
}


void EscribeLCD_d(double num, unsigned char digi, unsigned char digd){
	
}
void MensajeLCD_Var(char a[],char cont){
    int i; 
    for(i=0;i<(cont);i++){
        EscribeLCD_c(a[i]);
    }  
}

void DireccionaLCD(unsigned char a){
//Funci�n que ubica el cursor en una posici�n especificada
//a debe ser una direcci�n de 8 bits valida de la DDRAM o la CGRAM	
	RS=0;
	EnviaDato(a);
	HabilitaLCD();
	RetardoLCD(4);
}
	
void RetardoLCD(unsigned char a){
	switch(a){
		case 1: __delay_ms(15);
                //Delay100TCYx(38); //Retardo de mas de 15 ms
				break;
		case 2: __delay_ms(1);
                __delay_us(640);
                //Delay10TCYx(41); //Retardo de mas de 1.64 ms
				break;
		case 3: __delay_us(100);
                //Delay10TCYx(3);	//Retardo de mas de 100 us
				break;
		case 4: __delay_us(40);
                //Delay10TCYx(1); //Retardo de mas de 40 us
				break;
		default:
				break;
	}
}


void EscribeLCD_2Decimales(double a){
    int num;
    char decimalesP;
    char unidad;
    unidad=a;
    num=(a*100);
    decimalesP=num%100;
	EscribeLCD_n8(unidad,1);
    EscribeLCD_c('.');
    EscribeLCD_n8(decimalesP,2);
}

void GuardarASCII(unsigned char cgram,char arreglo[]){
    unsigned char i;
    DireccionaLCD(cgram);
    for(i=0;i<8;i++){
        EscribeLCD_c(arreglo[i]);
    }
    DireccionaLCD(128);
}


#endif	/* LIBLCDXC8_H */





