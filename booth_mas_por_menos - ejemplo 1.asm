variableA: 0b0
Q: 0b01010101
Q_1: 0b0
M: 0b10010101
Count:0x8

INI_LOOP: 
	MOV ACC, count 	;Carga la direccion de Count
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de Count a ACC
	JZ FIN_LOOP		;Salta al final del código 
	JMP PROC		;Salta al procedimiento de multiplicación

PROC: 
	MOV ACC, Q		;Carga la direccion de Q
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de Q a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0X01		;Carga 1 a ACC
	AND ACC, A		;Realiza AND entre Q y 1, para ver el valor del LSB
	JZ CASOS_0		;Salta si el LSB es 0
	MOV ACC, Q_1		;Carga la direccion de Q_1
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de Q-1 a ACC
	JZ RESTAR		;Salta al proceso de restar pues es el caso 10
	JMP CORR		;Salta al proceso de corrimiento pues es el caso 11

CASOS_0: 
	MOV ACC, Q_1		;Carga la direccion de Q_1
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de Q-1 a ACC
	JZ CORR			;Salta al proceso de corrimiento pues es 00
	JMP SUMAR		;Salta al proceso de suma, pues es el caso 01

RESTAR:
REV_M:		
	MOV ACC, M		;Carga la direccion de M
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de M a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0b10000000	;Carga 10000000 a ACC
	AND ACC, A		;Identifica si M es negativo o positivo
	JZ R_MPOS		;Salta al proceso de resta si M es positivo

R_MNEG:
	MOV ACC, [DPTR]		;Mueve el contenido de M a ACC
	INV ACC			;Hace complemento a 1
	MOV A, ACC		;Mueve el complemento a 1 de M al registro A
	MOV ACC, 0X01		;Carga 1 a ACC
	ADD ACC, A		;Hace complemento a 2 de M
	MOV A, ACC		;Mueve el complemento a 2 de M al registro A
	MOV ACC, 0b10000000	;Carga 10000000 a ACC
	ADD ACC, A		;Cambia el signo de M
	MOV A, ACC		;Mueve el resultado al registro A
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC
	ADD ACC, A		;Realiza la resta variableA - M
	MOV [DPTR], ACC		;Actualiza el valor de variableA tras la resta
	JMP CORR		;Salta al corrimiento de bits

R_MPOS:
	MOV ACC, M		;Carga la direccion de M
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de M a ACC
	INV ACC			;Hace complemento a 1
	MOV A, ACC		;Mueve el complemento a 1 de M al registro A
	MOV ACC, 0X01		;Carga 1 a ACC
	ADD ACC, A		;Hace complemento a 2 de M
	MOV A, ACC		;Mueve el complemento a 2 de M al registro A
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC
	ADD ACC, A		;Realiza la resta variableA - M
	MOV [DPTR], ACC		;Actualiza el valor de variableA tras la resta
	JMP CORR		;Salta al corrimiento de bits

SUMAR:	
REV_M:		
	MOV ACC, M		;Carga la direccion de M
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de M a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0b10000000	;Carga 10000000 a ACC
	AND ACC, A		;Identifica si M es negativo o positivo
	JZ S_MPOS		;Salta al proceso de resta si M es positivo
	
S_MNEG: 
	MOV ACC, M		;Carga la direccion de M
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de M a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0b10000000	;Carga 10000000 a ACC
	ADD ACC, A		;Cambia el signo de M
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC
	ADD ACC, A		;Realiza la suma variableA + M
	MOV [DPTR], ACC		;Actualiza el valor de variableA
	JMP CORR		;Salta al corrimiento de bits

S_MPOS:
	MOV ACC, M		;Carga la direccion de M
	MOV DPTR, ACC		;Mueve la direccion al DPTR
	MOV ACC, [DPTR]		;Mueve el contenido de M a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC
	ADD ACC, A		;Realiza la suma variableA + M
	MOV [DPTR], ACC		;Actualiza el valor de variableA
	JMP CORR		;Salta al corrimiento de bits

CORR:
Q_Q_1: 
	MOV ACC, Q		;Carga la direccion de Q
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de Q a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0x01		;Carga 1 a ACC
	AND ACC, A		;Realiza AND para saber el valor del LSB de Q
	MOV A, ACC		;Mueve el LSB al registro A
	MOV ACC, Q_1		;Carga la direccion de Q_1
	MOV DPTR, ACC		;Mueve la direccion al DPTR
 	MOV ACC, A		;Mueve el LSB de Q a ACC
	MOV [DPTR], ACC		;Guarda el LSB de Q a en Q_1

A_Q: 	
	MOV ACC, variableA		;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de VARIABLEA a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0x01		;Carga 1 a ACC
	AND ACC, A		;Realiza AND para obtener el valor del LSB de VARIABLEA
	JZ COR_Q0		;Si el LSB es 0, salta al corrimiento de bits para ese caso

COR_Q1: 
	MOV ACC, Q		;Carga la direccion de Q
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de Q a ACC 
	RSH ACC, 0x01 		;Mueve los bits una posición hacia la derecha
	MOV A, ACC		;Mueve el resultado al registro A
	MOV ACC, 0b10000000	;Carga 10000000 en ACC
	ADD ACC, A		;Del resultado del corrimiento, cambia el MSB a 1 
	MOV [DPTR], ACC		;Guarda el resultado del corrimiento en Q 
	JMP COR_A		;Salta al corrimiento de A

COR_Q0: 
	MOV ACC, Q		;Carga la direccion de Q
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de Q a ACC 
	RSH ACC, 0x01		;Realiza el corrimiento de bits una posición a la derecha
	MOV [DPTR], ACC		;Guarda el resultado del corrimiento en Q 
	JMP COR_A		;Salta al corrimiento de A

COR_A: 
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC 
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, 0b10000000	;Carga 10000000 a ACC
	AND ACC, A		;Realiza AND para consultar el valor del MSB de variableA
	JZ COR_A0		;Si es 0, salta al corrimiento para ese caso

COR_A1: 
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC 
	RSH ACC, 0x01 		;Mueve los bits una posición a la derecha
	MOV A, ACC		;Mueve el resultado del corrimiento al registro A
	MOV ACC, 0b10000000	;Carga 10000000 a ACC
	ADD ACC, A		;Al resultado del corrimiento le cambia el MSB a 1
	MOV [DPTR], ACC		;Guarda el resultado final en variableA
	JMP ACTU_CO		;Salta a la actualización del valor de count

COR_A0: 
	MOV ACC, variableA	;Carga la direccion de variableA
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de variableA a ACC 
	RSH ACC, 0x01		;Mueve los bits una posición a la derecha
	MOV [DPTR], ACC		;Guarda el resultado final en variableA
	JMP ACTU_CO		;Salta a la actualización del valor de count

ACTU_CO: 
	MOV ACC, 0xFF		;Carga -1 a ACC
	MOV A, ACC		;Mueve lo que hay en ACC al registro A
	MOV ACC, count		;Carga la direccion de count 
	MOV DPTR, ACC		;Mueve la direccion al DPTR 
	MOV ACC, [DPTR]		;Mueve el contenido de count a ACC 
	ADD ACC, A		;Hace la resta count - 1
	MOV [DPTR], ACC		;Guarda el resultado de la resta en count otra vez
	JMP INI_LOOP		;Salta al inicio del loop

FIN_LOOP: 
	HLT			;Fin del código