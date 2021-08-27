LIST	P=18F4520
#include <P18F4520.INC>

ORG	0x0000
R2 EQU 0xf0
R3 EQU 0xf1

BACK: MOVLW 0x5
MOVWF R3

AGAIN: MOVLW 0x1
MOVWF R2

HERE: NOP
NOP
DECF R2, F
BNZ HERE
DECF R3, F
BNZ AGAIN
RETURN
END
