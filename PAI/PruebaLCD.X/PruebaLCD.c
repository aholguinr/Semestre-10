#include<xc.h>
#define _XTAL_FREQ 8000000
#include "LibLCDXC8.h"
#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF
void main(void){
    IRCF1=1;          //Config para 8MHz
    IRCF0=1;          //Config para 8MHz
    TRISD=0;
    LATD=0;
    RD0=0;
    __delay_ms(1000);
    RD1=1;
    ConfiguraLCD(4);
    InicializaLCD();
    __delay_ms(1000);
    RD1=0;
    //MensajeLCD_Var("Hola mundo");
    EscribeLCD_c('H');
    EscribeLCD_c('o');
    EscribeLCD_c('l');
    EscribeLCD_c('a');
    EscribeLCD_c(' ');
    EscribeLCD_c('m');
    EscribeLCD_c('u');
    EscribeLCD_c('n');
    EscribeLCD_c('d');
    EscribeLCD_c('o');    
    DireccionaLCD(0xC0);
    EscribeLCD_c('7');
    EscribeLCD_c(';');
    while(1){
    RD1=1;
    }    
}