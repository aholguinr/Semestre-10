/* Microchip Technology Inc. and its subsidiaries.  You may use this software 
 * and any derivatives exclusively with Microchip products. 
 * 
 * THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER 
 * EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED 
 * WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A 
 * PARTICULAR PURPOSE, OR ITS INTERACTION WITH MICROCHIP PRODUCTS, COMBINATION 
 * WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION. 
 *
 * IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
 * INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND 
 * WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS 
 * BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE.  TO THE 
 * FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS 
 * IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF 
 * ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 *
 * MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF THESE 
 * TERMS. 
 */

/* 
 * File:   
 * Author: 
 * Comments:
 * Revision history: 
 */

// This is a guard condition so that contents of this file are not included
// more than once.  
#ifndef XC_HEADER_TEMPLATE_H
#define	XC_HEADER_TEMPLATE_H

 

// TODO Insert appropriate #include <>

// TODO Insert C++ class definitions if appropriate

// TODO Insert declarations

// Comment a function and leverage automatic documentation with slash star star
/**
    <p><b>Function prototype:</b></p>
  
    <p><b>Summary:</b></p>

    <p><b>Description:</b></p>

    <p><b>Precondition:</b></p>

    <p><b>Parameters:</b></p>

    <p><b>Returns:</b></p>

    <p><b>Example:</b></p>
    <code>
 
    </code>

    <p><b>Remarks:</b></p>
 */
// TODO Insert declarations or function prototypes (right here) to leverage 
// live documentation

#ifdef	__cplusplus
extern "C" {
#endif /* __cplusplus */

    // TODO If C++ is being used, regular C code needs function names to have C 
    // linkage so the functions can be used by the c code. 

#ifdef	__cplusplus
}
#endif /* __cplusplus */

#endif	/* XC_HEADER_TEMPLATE_H */


#include <xc.h> // include processor files - each processor file is guarded. 
#include <stdint.h>


#define _XTAL_FREQ 8000000L
#define PIN_IN   1
#define PIN_OUT  0

void I2C_Master_Init(uint32_t clock);
void I2C_Master_Wait(void);
void I2C_Start(void);
void I2C_Stop(void);
void I2C_Repeated_Start(void);
void I2C_Master_Write(uint8_t dato);
uint8_t I2C_Master_Read(uint8_t ACK);



void I2C_Master_Init(uint32_t clock){
    TRISBbits.RB0 = PIN_IN;    
    TRISBbits.RB1 = PIN_IN;
    SSPSTATbits.SMP = 1;       // Frecuencia de operacion Standard velocidad 100kHz-1Mhz
    SSPCON1bits.SSPEN = 1;     // habilito los pines para I2C
    SSPCON1bits.SSPM = 0b1000; // modo maestro i2c
    // FORMULA DE DATASHEET: CLOCK = Fosc/(4*(SSPADD+1)) 
    //despejamos SSPADD
    SSPADD = (uint8_t)((_XTAL_FREQ/(4.0*clock))-1);
    SSPCON2=0x00;             //clareo el registro que tiene las configuraciones del I2C    
}

//Garantizar que la situacion para poder continuar con la escritura o lectura de datos este presente y correcta
//mientras el buffer esta lleno esperar hasta q se vacie y bits 0-5 del registro SSPCON2
//mientras esta leyendo esperar para que escriba bit 3 del registro SSPSTAT
void I2C_Master_Wait(void){  
    while( (SSPCON2 & 0b00011111) || (SSPSTAT & 0b00000100) );
}

void I2C_Start(void){
    I2C_Master_Wait();
    SSPCON2bits.SEN = 1; //mando la condicion de start
}

void I2C_Stop(void){
    I2C_Master_Wait();
    SSPCON2bits.PEN = 1; //mando la condicion de stop
}

void I2C_Repeated_Start(void){
    I2C_Master_Wait();
    SSPCON2bits.RSEN = 1; //mando la condicion de repetir start   
}

void I2C_Master_Write(uint8_t dato){
    I2C_Master_Wait();
    SSPBUF = dato;      //cargamos el dato en el buffer para enviar
}

uint8_t I2C_Master_Read(uint8_t ACK){
    uint8_t dato;
    I2C_Master_Wait();
    SSPCON2bits.RCEN = 1; //habilito la recepcion de datos
    I2C_Master_Wait();
    dato = SSPBUF;         //leo el dato de SSPBUF
    I2C_Master_Wait();
    //el que MANDA el ACK es el que RECIBE el dato
    //el maestro esta mandando ACK
    //el ACK es para indicarle si el dato llego o no llego, como el maestro recibio el dato tiene que indicar como lo recibio
    SSPCON2bits.ACKDT = (ACK)?0:1; //bit de acknowledge //condicional?TRUE:FALSE; 
    //si a=1 -> ACKDT = 0 (Acknowledge)    RECONOCIMIENTO    - EL DATO LLEGO CON EXITO
    //si a=0 -> ACKDT = 1 (No Acknowledge) NO RECONOCIMIENTO - EL DATO LLEGO CON PROBLEMAS
    
    //Y AHORA RECIEN ENVIAMOS EL ACK CON ACKEN
    SSPCON2bits.ACKEN = 1; //transmite el bit de dato de ACKDT 
    return dato;   
}




