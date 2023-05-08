#include<xc.h>
#define _XTAL_FREQ 1000000
#include "LibLCDXC8.h"
#include "string.h"
#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF


char Estados=0;
char a=0;
char b=0;
char c=0;
char d=0; //Motor apagado

void main(void){
    
    //Configuraciones de pines
    ADCON1=15;
    TRISD=0;
    LATD=0;
    TRISB=0b11111111;
    
            

    CCP1CON=0b00001100; //Implementación PWM
    CCP2CON=0b00001100; //Implementación PWM 
    PR2=124;            //PWM de 1kHz
    CCPR1L=0;           
    CCPR2L=0;           //Duty inicial de 0
    
    TRISC1=0;           //Salida PWM2
    TRISC2=0;           //Salida PWM1 enable LM293D
    
    //Interrupciones
    /*
    INT0IF=0;
    INT0IE=1;
    
    INT1IF=0;
    INT1IE=1;
    INT2IF=0;
    INT2IE=1;
    RBPU=1;*/
    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos        
            
 
    
    a=!RB0;
    b=!RB1;
    c=!RB2;
    d=!RB3;
    
    ConfiguraLCD(4);
    InicializaLCD();
    
    __delay_ms(500);
    
    while(1){
        
        a=!RB0;
        b=!RB1;
        c=RB2;
        d=!RB3;
        
 
        switch(Estados){
            
            case 0:
                Mensaje_LCD_Var_Mensaje20x4("Cortadora UN","Espere un momento","UNAL","2023-1");
                LATD=0;
                __delay_ms(2000);
                Estados=1;
                break;
                
            case 1:
                Mensaje_LCD_Var_Mensaje20x4(" ","Revise la conexion a ","los motores","  ");
                
                RD0=0;
                if(a==0){Estados=1;break;}//Motor desconectado
                else{Estados=2;break;} //Pasar a Motor OFF
                
                break;
            case 2:
                Mensaje_LCD_Var_Mensaje20x4("Motor OFF","  ","Active el pulsador","para ajustarlo");
 
                RD0=1;
                if(a==0){Estados=1;break;}//Motor desconectado
                if(d==1){Estados=3;break;}//Pasar a OP
                else{Estados=2;break;}
                break;
                
            case 3:
                Mensaje_LCD_Var_Mensaje20x4("Seleccione un %","de operacion:"," ","0%");
                
                
                if(a==0){Estados=1;break;}//Motor desconectado
                //if(a==0){Estados=2;break;}
                if(b==1){Estados=2;break;}//Apagar motor
                if(c==1){Estados=4;break;}//Prender motor
                break;
                
            case 4:
                Mensaje_LCD_Var_Mensaje20x4("Motor prendido","Operacion:"," ","0%");
                
                if(a==0){Estados=1;break;}//Motor desconectado
                if(b==1){Estados=2;break;}//Apagar motor
                //if(b==0){Estados=2;break;}
                break;
                
            default:
                Estados=0;
            break;
                
            
        }
        
        
    }    
}

void interrupt ISR(void){
    
    /*
    if(INT1IF==1){ //Apagar motor

        b=!RB1;
        INT1IF=0;
    }
    
    if(INT2IF==1){ //Prender motor

        c=RB2;
        INT2IF=0;
    }*/
    

    
    /*
    if(RBIF==1){
        RBIF=0;
    }
    
    if(TMR0IF==1){
        TMR0=34286;
		TMR0IF=0;
	}*/

}