
#include<xc.h>
#include<stdlib.h>
#include <math.h>
#define _XTAL_FREQ 8000000
#include "LibLCDXC8.h"

#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF


void interrupt ISR(void);
unsigned char Recibir(void);
void LecturaEntrada(unsigned char);
void Transmitir(unsigned char);
unsigned int Conversion(unsigned char);
void TransmitirMensaje (char*);
void TransmitirNumero(unsigned int);
void Duty(double,double);
unsigned char Caso;
double VanX,VanY;

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
    TMR2=0;             //Prescaler TMR2
    TMR2ON=1;           //Prender TMR2
    
    PR2=124;            //PWM de 1kHz
    CCPR1L=0;           
    
    TRISB=0b11110000;            //Puerto B entrada y salidas
    LATB=0;             //Puerto B en 0
    
    TRISD=0;            //Puerto D salida
    LATD=0;             //Puerto D en 0
        
    TRISE0=1;           //E0 de entrada
    TRISE1=1;           //E1 de entrada
    
    TRISA3=0;
    LATA3=0;
        
    TRISC2=0;
    
    
    T0CON=0b10000101;   //TMR1 config
    TMR0=34286;          //TMR1 precarga
    TMR0IF=0;           //TMR1 flag  
    TMR0IE=1;          //TMR1 enable  
    
    RCIE=1;
    RCIF=0;
    
    GIE=1;              //Activar interrupciones globales
    PEIE=1;             //Activar interrupciones de perifericos 
    
    __delay_ms(500);
    ConfiguraLCD(4);    //4 bits LCD
    InicializaLCD();    //Iniciar el LCD
    MensajeLCD_Var("Micros 2021-2");
    DireccionaLCD(0xC0);
    MensajeLCD_Var("Proyecto Carro");
    __delay_ms(2000);
    BorraLCD();
    
    while(1){

        VanX=Conversion(0);
        VanX=1023-VanX-516;//-516  En x
        VanY=Conversion(1);
        VanY=1023-VanY-526;//-526  En Y

        __delay_ms(175);
        Duty(VanY,VanX);
        
    }
    
}

void interrupt ISR(void){
    if(RCIF==1){
        Caso=Recibir();
        LecturaEntrada(Caso);
        RCIF=0;
    }
    
    if(RBIF==1){
        if(RB7==0){
            Transmitir('A');
            BorraLCD();
            __delay_ms(10);
            MensajeLCD_Var("Se detiene");
            __delay_ms(200);

        }else if (RB6==0){
            Transmitir('a');
            BorraLCD();
            __delay_ms(10);
            MensajeLCD_Var("Se enciende");
            __delay_ms(200);
            
        }
        RBIF=0;
    }

    if(TMR0IF==1){
        TMR0=34286;
		TMR0IF=0;
        
        //Añadir funciones de LCD
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

void Duty(double V,double X){
    
    if(X>0){
        X=X/507;
    }else{
        X=X/515;
    }

    if (X>=0.9){
        Transmitir('x');
        BorraLCD();
        
    }else if(X>=0.5){
        Transmitir('v');
        
    }else if(X<=-0.9){
        Transmitir('X');
        BorraLCD();
        
    }else if(X<=-0.5){
        Transmitir('V');
        
    }else if(V>=0){
        V=V/497;
        if(V<0.4){
            Transmitir('b');
            
        }else if (V<0.46){
            Transmitir('c');
            
        }else if (V<0.52){
            Transmitir('d');
            
        }else if (V<0.58){
            Transmitir('e');
            
        }else if (V<0.64){
            Transmitir('f');
            
        }else if (V<0.70){
            Transmitir('g');
            
        }else if (V<0.76){
            Transmitir('h');
            
        }else if (V<0.82){
            Transmitir('i');
            
        }else if (V<0.88){
            Transmitir('j');
            
        }else if (V<0.94){
            Transmitir('k');
            
        }else {
            Transmitir('m');
            
        }
    } else{
        V=V/525;
        if(V>-0.4){
            Transmitir('B');
            
        }else if (V>-0.46){
            Transmitir('C');
            
        }else if (V>-0.52){
            Transmitir('D');
            
        }else if (V>-0.58){
            Transmitir('E');
            
        }else if (V>-0.64){
            Transmitir('F');
            
        }else if (V>-0.70){
            Transmitir('G');
            
        }else if (V>-0.76){
            Transmitir('H');
            
        }else if (V>-0.82){
            Transmitir('I');
            
        }else if (V>-0.88){
            Transmitir('J');
 
        }else if (V>-0.94){
            Transmitir('K');
            
        }else {
            Transmitir('M');
            
        }
    }
}

void LecturaEntrada(unsigned char entrada){

    switch(entrada){
        case 'r':
            LATD0=1;
            LATD1=1;
            CCPR1L=PR2;
            break;
            
        case 'R':
            LATD0=0;
            LATD1=0;
            CCPR1L=0;
            break;
         
        case 's':
            LATD0=1;
            LATD1=0;
            CCPR1L=0.7*PR2;
            break;
            
        case 'S':
            LATD0=0;
            LATD1=1;
            CCPR1L=0.7*PR2;
            break;
           
        default:
            break;
        
    }
    
}


