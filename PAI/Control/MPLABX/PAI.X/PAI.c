
#include<xc.h>
#include<stdlib.h>
#include <math.h>
//#define _XTAL_FREQ 8000000L
#include "I2C.h"   

#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF

void main(void){
    /*ADCON1 = 15;
    TRISD=0;
    LATD=0b11111111;
    TRISB=0b11110000;
    LATB=0b00000000;
    TRISA0=1;
    T1CON=0b10100001;   //TMR1 config
    T0CON=0b10000101;   //TMR0 config
    TMR1=3036;          //TMR1 precarga
    TMR1IF=0;           //TMR1 flag  
    TMR1IE=1;           //TMR1 enable  
    RBPU=0;             //RB PULL UP
    RBIF=0;             //RB flag
    RBIE=1;             //RB config
    TMR0=26473;         //TMR0 precarga
    TMR0IF=0;           //TMR0 flag        
    TMR0IE=1;           //TMR0 enable 
    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos
    __delay_ms(500);

    while(1) {

    }*/
    
    
    ADCON1 = 0x0F;    //todos los pines del PORTA como digitales
    OSCCON = 0x72;    //oscilador interno a 8MHz

    LCD_I2C_Init(); 
    LCD_I2C_WriteText(0,0,"PIC18F2550/4550 ");      
    LCD_I2C_WriteText(1,0,"  LCD 16x2 20x4 ");
    //LCD_I2C_WriteText(2,0,"PROBANDO DISPLAY LCD");
    //LCD_I2C_WriteText(3,0,"20X4 DISPLAY LCD LCD");
    __delay_ms(2000);
    //LCD_I2C_ClearText();
      
    while(1){
        
    }
    
}
    