/*
 * File:   PAI.c
 * Author: andre
 *
 * Created on 15 de abril de 2023, 06:41 PM
 */

#include<xc.h>
#include<stdlib.h>
#include <math.h>
#define _XTAL_FREQ 1000000
#include "LibLCDXC8.h"
#pragma config FOSC=INTOSC_EC
#pragma config WDT=OFF
#pragma config LVP=OFF

char operacion[]="    ";
char pacman[]={6,9,18,20,18,9,6,0}; 
char pacman2[]={6,9,17,23,17,9,6,0}; 
char cereza[]={6,4,14,31,31,23,14,0}; 
char barco[]={4,6,7,6,4,31,14,0}; 
char cont=0;
char borrar=0;
char limpiar=0;
char Cambio=0;
char digitar=0;
char activado=0;
char reset=0;
void interrupt ISR(void);
void ModuloOperacion(void);
char ControlError(char);
void OpTeclado(char, char);

void main(void){
    ADCON1 = 15;
    TRISD=0;
    LATD=1;
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
    ConfiguraLCD(4);    //4 bits LCD
    InicializaLCD();    //Iniciar el LCD

    GuardarASCII(64,pacman);
    GuardarASCII(72,pacman2);
    GuardarASCII(80,cereza);
    GuardarASCII(88,barco);

    
    if(POR==0) {
        MensajeLCD_Var("Reset POR",9);
        POR=1;
        while(activado==0){
            __delay_ms(500);
            DireccionaLCD(192);
            EscribeLCD_c(0);
            EscribeLCD_c(2);
            EscribeLCD_c(3); 
            __delay_ms(500);
            DireccionaLCD(192);
            EscribeLCD_c(1); 
            EscribeLCD_c(2);
            EscribeLCD_c(3); 
        }
    }
    else {
        MensajeLCD_Var("Reset MCLRE",11);
        while(activado==0);
    }

    
    
    BorraLCD();
    
    while(1) {
    
        if(Cambio==1){
            if(limpiar==1){
                BorraLCD();
                char i;
                for(i=1;i<4;i++){
                   operacion[i]=' '; 
                }
                limpiar=0;
            }
            
            if(borrar==1){
               DireccionaLCD(127+cont); 
               EscribeLCD_c(operacion[cont]);
               DireccionaLCD(127+cont); 
               cont--;
               borrar=0; 
               Cambio=0;
            }
            
            if(digitar==1){
                EscribeLCD_c(operacion[cont-1]);
                digitar=0;
                Cambio=0;               
            }
            
            if(cont==4||(cont==3&&operacion[1]=='!')){
                ModuloOperacion();
                cont=0;
                limpiar=1;
                Cambio=0;
            } 
        }
    }
}

void interrupt ISR(void){
    
if(RBIF==1){
        if(PORTB!=0b11110000){
            LATB=0b11111110;
            if(RB4==0) {
                if(RA0==0)OpTeclado(2, '+');
                else OpTeclado(2, '^');
            }
            else if(RB5==0){
                if(RA0==0) OpTeclado(2, '-');
                else OpTeclado(2, '!');
                
            }
            else if(RB6==0) OpTeclado(2, 'x');
            else if(RB7==0) OpTeclado(2, '/');
            else{
                LATB=0b11111101;
                if(RB4==0) OpTeclado(3, '=');
                else if(RB5==0) OpTeclado(1, '9');
                else if(RB6==0) OpTeclado(1, '6');
                else if(RB7==0) OpTeclado(1, '3');
                else{
                    LATB=0b11111011;
                    if(RB4==0) OpTeclado(1, '0');
                    else if(RB5==0) OpTeclado(1, '8');
                    else if(RB6==0) OpTeclado(1, '5');
                    else if(RB7==0) OpTeclado(1, '2');
                    else{
                        LATB=0b11110111;
                        if(RB4==0) OpTeclado(4,' ');
                        else if(RB5==0) OpTeclado(1, '7');
                        else if(RB6==0) OpTeclado(1, '4');
                        else if(RB7==0) OpTeclado(1, '1');
                    }
                }
            }
            LATB=0b11110000;
            activado=1;
            TMR0=26473;
        }
        RBIF=0;
    }
    
    if(TMR1IF==1){
		TMR1=3036;
		TMR1IF=0;
        LATD0=LATD0^1;
	}

   if(TMR0IF==1){
		TMR0=26473;
		TMR0IF=0;
        SLEEP();
	}    
}

void OpTeclado(char c, char A){
    Cambio=ControlError(c);
    if(Cambio==1){
        if(A==' ') {borrar=1;cont--;operacion[cont]=A;}
        else 
        digitar=1;    
        operacion[cont]=A; 
        cont++;
    }
}

void ModuloOperacion(void){
    char num1;
    char num2;
    
    double Res;
    
    num1=operacion[0]-48;
    num2=operacion[2]-48;

    
    DireccionaLCD(192);
    
    if(operacion[1]=='+'){
            Res= num1+num2; 
        if(Res<10){
            EscribeLCD_n8(Res,1);
        }else{
            EscribeLCD_n8(Res,2);
          }
      //Display
    }else if(operacion[1]=='-'){
      Res= num1-num2;    
      if(Res>=0)EscribeLCD_n8(Res,1);
      else if(Res<0){Res=abs(Res);
      EscribeLCD_c('-');
      EscribeLCD_n8(Res,1);
      } 
    }else if(operacion[1]=='x'){
       Res= num1*num2;  
      if(Res<10){
          EscribeLCD_n8(Res,1);
      }else{
          EscribeLCD_n8(Res,2);
      }
    }else if(operacion[1]=='/'){
        if(num2==0&&num1==0){
        MensajeLCD_Var("Indeterminado",13);
        return;
        }else if(num2==0){
        MensajeLCD_Var("Infinito",8);
        return;
        }else{
            double n1;
            double n2;    
            n1=num1;
            n2=num2;
            Res= n1/n2; 
            
            if(num1%num2==0){
                EscribeLCD_n8(Res,1);
            } else{
                EscribeLCD_2Decimales(Res);
            }
        }   
    }else if(operacion[1]=='^'){
        unsigned long ResL;
        unsigned long n1L;
        char i;
        char b=0;
        long var=1;
        
        if(num1==0&& num2==0){
            MensajeLCD_Var("Indeterminado",13);
            return;
        }else if(num1==0){
            EscribeLCD_n8(0,1);
            return;
        }else if(num2==0){
            EscribeLCD_n8(1,1);
            return;
        }else{
            n1L=num1;  
            ResL=1;
            for(i=0;i<num2;i++){ 
               ResL=ResL*n1L; 
            }

            while(ResL>=var){
                var*=10;
                b+=1;
                if(b==9) break;
            }
            EscribeLCD_n32(ResL,b);
        }
        
    }else if(operacion[1]=='!'){
        unsigned long ResL;
        char b=0;
        long var=1;
        ResL=1;
        long i;
        if(num1<2){
            EscribeLCD_n8(1,1);
        }else{
            for (i=1;i<=num1;i++){
                ResL*=i;
            }
            while(ResL>=var){
                var*=10;
                b+=1;
                if(b==9) break;
            }
            EscribeLCD_n32(ResL,b);
        }
    }
}

char ControlError(char A){
    switch(A){
        case 1: if(cont==0||(cont==2&& operacion[1]!='!')) return 1; //caso de número
                else return 0;
        case 2: if(cont==1) return 1; //caso de operación
                else return 0;
        case 3: if(cont==3) return 1; //caso de =
                else if(cont==2 && operacion[1]=='!') return 1;
                else return 0;
        case 4: if(cont>0)return 1;  //caso de borrar
                else return 0;
        default: return 0;
    }
    return 0;
}