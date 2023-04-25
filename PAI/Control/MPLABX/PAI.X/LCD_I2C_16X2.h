    #ifndef LCD_I2C_16X2_H
    #define	LCD_I2C_16X2_H

    // P7 P6 P5 P4 P3 P2 P1 P0 (PCF8574)
    // D7 D6 D5 D4 K  E  RW RS (LCD16X2)   

    // RS: REGISTER SELECT
    // RS = 0 (IR:Instruccion Register) - Registro para configuracion de pantalla
    // RS = 1 (DR:Data Register)        - Registro para acceder alas memorias RAM ROM

    #define PCF8574_ADDRESS 0x4E //0b01001110
    //#define PCF8574_ADDRESS 0x40 //0b01000000 

    #define  PIN_RS    0x01
    #define  PIN_RW    0x02
    #define  PIN_EN    0x04
    #define  BACKLIGHT 0x08

    //Todos estos valores los saco del datasheet del controlador ST7920
    #define DISPLAY_CLEAR   0x01 //0b00000001 - 2ms
    #define MODE_4_BITS     0x20 //0b00100000 - 37us
    #define DISPLAY_ON      0x0C //0b00001100 - 37us
    #define ENTRY_MODE_SET  0x06 //0b00000110 - 37us
    #define RETURN_HOME     0x02 //0b00000010 - 1.52ms

    // RS: REGISTER SELECT
    // RS = 0 (IR:Instruccion Register) - Registro para configuracion de pantalla
    // RS = 1 (DR:Data Register)        - Registro para acceder alas memorias RAM ROM

    void PCF8574_Write(uint8_t byte);
    void LCD_I2C_WriteData(uint8_t data);
    void LCD_I2C_WriteCommand(uint8_t command);
    void LCD_I2C_Init(void);
    void LCD_I2C_ClearText(void);
    void LCD_I2C_WriteText(uint8_t row, uint8_t col, char* string);


    
void PCF8574_Write(uint8_t byte){
    I2C_Start();
    I2C_Master_Wait();
    I2C_Master_Write(PCF8574_ADDRESS);
    I2C_Master_Wait();
    I2C_Master_Write(byte);
    I2C_Master_Wait();
    I2C_Stop();
    I2C_Master_Wait(); 
}

//Enviar un byte de comando al controlador hitachi HD44780
void LCD_I2C_WriteCommand(uint8_t command){ 
    uint8_t highnibble;
    uint8_t lownibble;
    
    highnibble = (command & 0xF0) | BACKLIGHT;
    lownibble  = (uint8_t)(((command & 0x0F)<<4)| BACKLIGHT);
    
    PCF8574_Write(highnibble | PIN_EN); //habilito EN 
    __delay_us(20);
    PCF8574_Write(highnibble); //deshabilito EN
    __delay_us(20);

    PCF8574_Write(lownibble | PIN_EN); //habilito EN 
    __delay_us(20);
    PCF8574_Write(lownibble); //deshabilito EN
    __delay_us(20);
}

//Enviar un byte de datos al controlador hitachi HD44780
void LCD_I2C_WriteData(uint8_t data){ 
    uint8_t highnibble;
    uint8_t lownibble;
    //backligth siempre activado
    highnibble = (data & 0xF0) | BACKLIGHT;
    lownibble  = (uint8_t)(((data & 0x0F)<<4)| BACKLIGHT);
    
    PCF8574_Write(highnibble | PIN_EN | PIN_RS); //habilito EN 
    __delay_us(20);
    PCF8574_Write(highnibble | PIN_RS); //deshabilito EN
    __delay_us(20);

  
    PCF8574_Write(lownibble | PIN_EN | PIN_RS); //habilito EN 
    __delay_us(20);
    PCF8574_Write(lownibble | PIN_RS); //deshabilito EN
    __delay_us(20);
}

void LCD_I2C_Init(void){

    I2C_Master_Init(100000);
    
    PCF8574_Write(0x00);
    __delay_ms(1000);

    //MANDO 3 VECES ESTE DATO
    PCF8574_Write(0x30); 
    __delay_us(20);
    PCF8574_Write(0x34);    
    __delay_us(20);
    PCF8574_Write(0x30);     
    __delay_ms(5);
    
    PCF8574_Write(0x30); 
    __delay_us(20);
    PCF8574_Write(0x34);   
    __delay_us(20);
    PCF8574_Write(0x30);

    __delay_ms(5);
    
    PCF8574_Write(0x30);
    __delay_us(20);
    PCF8574_Write(0x34);  
    __delay_us(20);
    PCF8574_Write(0x30);
    
    __delay_us(250);
    
    
    PCF8574_Write(0x20);  
    __delay_us(20);
    PCF8574_Write(0x24);  
    __delay_us(20);
    PCF8574_Write(0x20); 
    
    __delay_us(75);

    PCF8574_Write(0x20);  
    __delay_us(20);
    PCF8574_Write(0x24);  
    __delay_us(20);
    PCF8574_Write(0x20); 
    
    __delay_us(75);
    
    PCF8574_Write(0x80);  
    __delay_us(20);
    PCF8574_Write(0x84);  
    __delay_us(20);
    PCF8574_Write(0x80); 
    
    __delay_us(75); 
    
    
    PCF8574_Write(0x00); 
    __delay_us(20);
    PCF8574_Write(0x04); 
    __delay_us(20);
    PCF8574_Write(0x00); 
    
     __delay_us(75);
 
    
    PCF8574_Write(0xC0); 
    __delay_us(20);
    PCF8574_Write(0xC4); 
    __delay_us(20);
    PCF8574_Write(0xC0); 
    
     __delay_us(75);
 
    
    PCF8574_Write(0x00); 
    __delay_us(20);
    PCF8574_Write(0x04); 
    __delay_us(20);
    PCF8574_Write(0x00);

     __delay_us(75);
 
    
    PCF8574_Write(0x10); 
    __delay_us(20);
    PCF8574_Write(0x14);  
    __delay_us(20);
    PCF8574_Write(0x10); 
    
     __delay_ms(2);
 
      
    
    PCF8574_Write(0x00); 
    __delay_us(02);
    PCF8574_Write(0x04);   
    __delay_us(20);
    PCF8574_Write(0x00); 
     
     __delay_us(75);
 
    PCF8574_Write(0x60); 
    __delay_us(02);
    PCF8574_Write(0x64);
    __delay_us(20);
    PCF8574_Write(0x60);

     __delay_us(75);
   
    PCF8574_Write(0x00); 
    __delay_us(20);
    PCF8574_Write(0x04); 
    __delay_us(20);
    PCF8574_Write(0x00);
    
    __delay_us(75);
    
    PCF8574_Write(0x20); 
    __delay_us(20);
    PCF8574_Write(0x24); 
    __delay_us(20);
    PCF8574_Write(0x20);
    
    __delay_us(75);
    
    LCD_I2C_ClearText();  
}

// Limpiar el texto de la pantalla
void LCD_I2C_ClearText(){
  LCD_I2C_WriteCommand(DISPLAY_CLEAR);
  __delay_ms(5);
}

//TEXTO
void LCD_I2C_WriteText(uint8_t row, uint8_t col, char* string){
    //row -> 0,1,2,3        col -> 0,1,2,3,4,5,6,7
    switch (row) {
        case 0: col = col + 0x80;break; // operacion para agregar ala fila 0 su columna "x"
        case 1: col = col + 0xC0;break; // operacion para agregar ala fila 1 su columna "x"
        case 2: col = col + 0x94;break; // operacion para agregar ala fila 2 su columna "x"
        case 3: col = col + 0xD4;break; // operacion para agregar ala fila 3 su columna "x"
        default:col = col + 0x80;break; // fila 0 si ingresa un valor que no es del 0 al 3
    }

    LCD_I2C_WriteCommand(col);
    //Funcion para mandar strings sin saber el tama?o de la cadena
    //while(*string != '\0')
    while (*string)
        LCD_I2C_WriteData(*string++);
}
    

    #endif	/* LCD_I2C_16X2_H */

