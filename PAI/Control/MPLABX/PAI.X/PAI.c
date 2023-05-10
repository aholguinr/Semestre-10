#include<xc.h>
#define _XTAL_FREQ 1000000
#include "LibLCDXC8.h"
#include "string.h"
#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF


char Estados=0;
char EstadosPrev=0;
char a=0;
char b=0;
char c=0;
char d=0; //Motor apagado
double DutyI, DutyF,Duty, DeltaDuty,DutyF2;
void main(void){
    
    //Configuraciones de pines
    ADCON1=15;
    TRISD=0;
    LATD=0;
    TRISB=0b11111111;
    
            

    CCP1CON=0b00001100; //Implementación PWM
    CCP2CON=0b00001100; //Implementación PWM 
    //PR2=124;            //PWM de 1kHz
    PR2=249;
    CCPR1L=0;           
    CCPR2L=0;           //Duty inicial de 0
    T2CON=0b00000000;   //Postscaler 1:1, Off, Prescaler 1;
    TMR2=0;             //Prescaler TMR2
    TMR2ON=1;           //Prender TMR2 
    
    TRISC1=0;           //Salida PWM2
    TRISC2=0;           //Salida PWM1 enable LM293D
    
    
    
    //Interrupciones
    
    
    /*
    T1CON=0b10100001;   //TMR1 config
    TMR1=3036;          //TMR1 precarga
    TMR1IF=0;           //TMR1 flag  
    TMR1IE=1;           //TMR1 enable 
    */
    INT0IF=0;
    INT0IE=1;
    
    INT1IF=0;
    INT1IE=1;
    INT2IF=0;
    INT2IE=1;
    RBPU=1;
    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos        
            
 
    
    a=!RB0; //Energia motor
    
    d=!RB3; //OP
    
    ConfiguraLCD(4);
    InicializaLCD();
    
    __delay_ms(500);
    
    while(1){
        
        a=!RB0;
        
        d=!RB3;
        
 
        switch(Estados){
            
            case 0:
                LATD=0;
                Mensaje_LCD_Var_Mensaje20x4("Cortadora UN","Espere un momento","UNAL","2023-1");
                Estados=1;
                __delay_ms(2000);
                break;
                
            case 1:
                
                RD0=0;
                RD1=0;
                CCPR1L=0;
                c=0;
                if(Estados!=EstadosPrev){    
                Mensaje_LCD_Var_Mensaje20x4(" ","Revise la conexion a ","los motores","  ");
                }
                EstadosPrev=1;
                if(a==0){Estados=1;break;}//Motor desconectado
                else{Estados=2;break;} //Pasar a Motor OFF
                
                break;
            case 2:
 
                RD0=1;
                RD1=0;
                b=1;
                c=0;
                CCPR1L=0;
                if(Estados!=EstadosPrev){    
                Mensaje_LCD_Var_Mensaje20x4("Motor OFF","  ","Active el pulsador","para ajustarlo");
                }
                
                EstadosPrev=2;
                if(a==0){Estados=1;break;}//Motor desconectado
                if(d==1){Estados=3;b=0;break;}//Pasar a OP
                else{Estados=2;break;}
                break;
                
            case 3:
                RD1=0;
                
                Duty=1;
                CCPR1L=0;
                if(a==0){Estados=1;break;}//Motor desconectado
                //if(a==0){Estados=2;break;}
                if(Estados!=EstadosPrev){    
                Mensaje_LCD_Var_Mensaje20x4("Seleccione un %","de operacion:"," ","0%");
                }
                
                EstadosPrev=3;
                if(b==1){Estados=2;b=0;break;}//Apagar motor
                if(c==1){Estados=4;c=0;break;}//Prender motor
                break;
                
            case 4:
                RD1=1;
                CCPR1L=Duty*PR2;
                if(Estados!=EstadosPrev){    
                Mensaje_LCD_Var_Mensaje20x4("Motor prendido","Operacion:"," ","0%");
                }
                
                EstadosPrev=4;
                //CCPR2L=Duty*PR2;
                if(a==0){Estados=1;break;}//Motor desconectado
                if(b==1){Estados=2;b=0;break;}//Apagar motor
                //if(b==0){Estados=2;break;}
                break;
                
            default:
                Estados=0;
            break;
                
            
        }
        
        
    }    
}

void interrupt ISR(void){
    
    
    if(INT0IF==1){ //Apagar motor

        a=0;
        INT0IF=0;
    }
    
    if(INT1IF==1){ //Apagar motor

        b=1;
        INT1IF=0;
    }
    
    
    if(INT2IF==1){ //Prender motor

        c=1;
        INT2IF=0;
    }
    

    
    /*
    if(RBIF==1){
        RBIF=0;
    }
    
    if(TMR0IF==1){
        TMR0=34286;
		TMR0IF=0;
	}*/

}