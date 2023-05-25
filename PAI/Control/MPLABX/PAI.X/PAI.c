#include<xc.h>
#define _XTAL_FREQ 4000000
#include "LibLCDXC8.h"
#include "string.h"
#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF


char Estados=0;
char EstadosPrev=0;
char a=0;
char b=0;
char c=0;
char d=0; //Motor apagado
double DutyI, DutyF,Duty, DeltaDuty,DutyF2;
int Vals24[] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,3,3,4,4,4,5,5,5,6,6,7,7,8,8,9,10,10,11,12,12,13,14,14,15,16,17,18,19,19,20,21,22,23,24,25,26,27,28,30,31,32,33,34,35,37,38,39,41,42,43,45,46,47,49,50,52,53,55,56,58,59,61,62,64,66,67,69,71,72,74,76,77,79,81,83,84,86,88,90,91,93,95,97,99,100,102,104,106,108,110,111,113,115,117,119,121,123,124,126,128,130,132,134,136,138,139,141,143,145,147,149,150,152,154,156,158,159,161,163,165,166,168,170,172,173,175,177,178,180,182,183,185,187,188,190,191,193,194,196,197,199,200,202,203,204,206,207,208,210,211,212,214,215,216,217,218,219,221,222,223,224,225,226,227,228,229,230,230,231,232,233,234,235,235,236,237,237,238,239,239,240,241,241,242,242,243,243,244,244,244,245,245,245,246,246,246,247,247,247,247,248,248,248,248,248,248,248,249,249,249,249,249,249,249,249,249,249,249,249,249,249,249,249};
//251 puntos
int len = sizeof(Vals24) / sizeof(int);
//101 posiciones que generan el perfil suavizado a 24v. El tiempo depende del delay entre ellos
// El voltaje depende de una constante 0-1 que multiplique estos valores
unsigned int Conversion(unsigned char);
void imprimir_porcentaje(void);
void Iniciar_Perfil_Vel(void);
double ValAn_PWM=0;
double Val_PWM=0;
char Val_PWM_LCD=0;
char Val_PWM_LCD_prev=0;
unsigned int ts=20; //250 saltos, T=5s
void main(void){
    IRCF2=1;            //Config para 4MHz
    IRCF1=1;            //Config para 4MHz
    IRCF0=0;            //Config para 4MHz
    
    
    //Configuraciones de pines
    ADCON0=0b00000001;
    ADCON1=13;
    ADCON2=0b10001000;
    TRISD=0;
    LATD=0;
    TRISB=0b11111111;
    
    CCP1CON=0b00001100; //Implementación PWM
    CCP2CON=0b00001100; //Implementación PWM 
    //PR2=124;            //PWM de 1kHz
    
    PR2=249;           //PWM de 1kHz
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
    
    
    RCIE=1;
    RCIF=0;
    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos        

    
    a=!RB0; //Energia motor
    
    ConfiguraLCD(4);
    InicializaLCD();
    
    __delay_ms(500);
    //Mensaje_LCD_Var_Mensaje20x4("Cortadora UN","Espere un momento","UNAL","2023-1");
    Mensaje_LCD_Var_Mensaje20x4("Co","Espere un momento","UNAL","2023-1");
    __delay_ms(5000);
    
 
    while(1){
        
        a=!RB0;
        ValAn_PWM=Conversion(0);
        Val_PWM=ValAn_PWM*100/1024;
        
        switch(Estados){
            
            case 0: //Inicio de programa
                LATD=0;
                Mensaje_LCD_Var_Mensaje20x4("Cortadora UN","Espere un momento","UNAL","2023-1");
                Estados=1;
                
                CCPR1L=0;
                __delay_ms(2000);
                break;
                
            case 1: //Activar conexión de motores
                
                RD0=1;
                RD1=1;
                //RD1=0;
                CCPR1L=0;
                c=0;
                if(Estados!=EstadosPrev){    
                    Mensaje_LCD_Var_Mensaje20x4(" ","Revise la conexion a ","los motores","  ");
                }
                EstadosPrev=1;
                if(a==0){Estados=1;break;}//Motor desconectado
                else{Estados=2;break;} //Pasar a Motor OFF
                
                break;
            case 2: //Motores conectados, a la espera de apagado o OP
 
                RD0=0;
                RD1=0;
                //RD1=0;
                b=1;
                c=0;
                CCPR1L=0;
                if(Estados!=EstadosPrev){    
                Mensaje_LCD_Var_Mensaje20x4("Motor OFF","  ","Active el pulsador","para ajustarlo");
                }
                
                EstadosPrev=2;
                if(a==0){Estados=1;break;}//Motor desconectado
                if(d==1){Estados=3;b=0;Val_PWM_LCD_prev=0;break;}//Pasar a OP
                else{Estados=2;break;}
                break;
                
            case 3: //Seleccionar punto de operacion
                //RD1=0;
                if(b==1){Estados=2;b=0;break;}//Apagar motor
                
                RD0=1;
                RD1=1;
                d=0;
                CCPR1L=0;
                if(a==0){Estados=1;break;}//Motor desconectado
                
                if(Estados!=EstadosPrev){    
                    Mensaje_LCD_Var_Mensaje20x4("Seleccione un %","de operacion:"," ","    ");
                }
                
                Val_PWM_LCD=Val_PWM;
                
                if(Val_PWM_LCD_prev!=Val_PWM_LCD){
                    imprimir_porcentaje(); 
                }
                Val_PWM_LCD_prev=Val_PWM_LCD;
                
                
                EstadosPrev=3;
                
                if(c==1){Estados=4;c=0;break;}//Prender motor
                break;
                
            case 4: //Se activa punto de operación
                //RD1=1;
                if(a==0){Estados=1;break;}//Motor desconectado
                if(b==1){Estados=2;b=0;break;}//Apagar motor
                Duty=Val_PWM/100;
                //CCPR1L=Duty*PR2;

                if(Estados!=EstadosPrev){   
                //Iniciar_Perfil_Vel();
                //CCPR1L=Duty*PR2;
                //CCPR1L=Vals24[100];
                
                Mensaje_LCD_Var_Mensaje20x4("  ","Prendiendo Motor"," ","Espere un momento");
    
                int i;
                for (i = 0; i < len; i++) {
                    if(b==1||a==0){break;}
                    CCPR1L = Vals24[i]*Duty;   // asignar el siguiente valor del arreglo al registro CCPR1L
                    __delay_ms(ts);   // esperar un tiempo definido en ms
                }
                
                if(a==0){Estados=1;break;}//Motor desconectado
                if(b==1){Estados=2;b=0;break;}//Apagar motor
                
                //CCPR1L = Vals24[100];
                Mensaje_LCD_Var_Mensaje20x4("Motor prendido","Operacion:"," ","    ");
                imprimir_porcentaje();
                }
                
                EstadosPrev=4;
                
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

        if(Estados==2){
            d=1;
        }else if (Estados==3){
            c=1;
        }
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

unsigned int Conversion(unsigned char canal){
    ADCON0=(ADCON0 & 0b00000011) | (canal<<2);
    GO=1;   //bsf ADCON0,1   GO en 1, conversi?n en progreso 
    while(GO==1);    
    return ADRES; //ADRES almacena en 16 bits el resultado an?logo
}

void imprimir_porcentaje(void){
    /*DireccionaLCD(0xC0+20+8);
    MensajeLCD_Var("    ");
    DireccionaLCD(0xC0+20+8); */
    
    DireccionaLCD(0xC0+4);
    MensajeLCD_Var("    ");
    DireccionaLCD(0xC0+4);
    
    if(Val_PWM>99){
    EscribeLCD_n8(100,3);
    }else if (Val_PWM<=10){
        EscribeLCD_n8(Val_PWM_LCD,1);
    }else{
        EscribeLCD_n8(Val_PWM_LCD,2);
    }
    EscribeLCD_c('%');
}

void Iniciar_Perfil_Vel(void){

}