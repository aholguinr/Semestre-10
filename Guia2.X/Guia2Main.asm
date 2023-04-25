include P18f4550.inc
    
CONFIG FOSC=EC_EC
CONFIG WDT=OFF
    
SetUp
    clrf TRISD
    clrf LATD
    ;goto Loop2
    
Loop
    movlw b'00000001'
    movwf LATD
    clrf LATD
    goto Loop
    
Loop2
    ;Negro
    movlw b'00000000'
    movwf LATD
    ;Azul
    movlw b'00000100'
    movwf LATD
    ;Cyan
    movlw b'00000110'
    movwf LATD
    ;Verde
    movlw b'00000010'
    movwf LATD
    ;Amarillo
    movlw b'00000011'
    movwf LATD
    ;Blanco
    movlw b'00000111'
    movwf LATD
    ;Magenta
    movlw b'00000101'
    movwf LATD
    ;Rojo
    movlw b'00000001'
    movwf LATD
    goto Loop2
    
end