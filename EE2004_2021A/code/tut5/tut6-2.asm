LIST P=18F4520 ; directive to define processor
#include <P18F4520.INC>; CPU specific variable definitions

;--------------------
;Configuration bits definitions
;
CONFIG OSC = XT
CONFIG WDT = OFF
CONFIG LVP = OFF
;--------------------
;Variable definitions
;
CBLOCK 0x000
DELAY_H
DELAY_L
ENDC
;------------
;Reset vector
;
ORG 0x0000 ; code origin, program starts from here
goto Main

; Start of main program
Main: movlw 0x0F
movwf ADCON1
clrf TRISD ; set Port D direction “output”
clrf PORTD

MainLoop: movlw 0x06 ; id = 6680
movwf PORTD
movlw 0x06
movwf PORTD
movlw 0x08
movwf PORTD
movlw 0x00
movwf PORTD
call Delay
bra MainLoop

;..........................
Delay: movlw 0x02
movwf DELAY_H

LOP_1: movlw 0x02
movwf DELAY_L

LOP_2: decf DELAY_L, F
bnz LOP_2
decf DELAY_H, F
bnz LOP_1
return

END ; End of program