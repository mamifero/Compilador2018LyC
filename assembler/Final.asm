include macros2.asm 
include number.asm 
.MODEL LARGE ; Modelo de memoria. 
.386 ; Tipo de procesador. 
.STACK 200h ;Bytes en el Stack. 

.DATA 

MAXTEXTSIZE EQU 30
a 	 DD 	 ? 
b 	 DD 	 ? 
c 	 DD 	 ? 
d 	 DD 	 ? 
h 	 DD 	 ? 
i 	 DD 	 ? 
j 	 DD 	 ? 
e 	 DD 	 ? 
f 	 DD 	 ? 
g 	 DB 	 30 dup(?), '$'  
_assemblerconst1 	 DD 	 9  
_assemblerconst2 	 DD 	 57.100000  
_assemblerconst3 	 DD 	 9.000000  
_assemblerconst4 	 DD 	 0.900000  
_assemblerconst5 	 DD 	 -9  
_assemblerconst6 	 DD 	 -429.100000  
_assemblerconst7 	 DD 	 -0.900000  
_assemblerconst8 	 DD 	 2  
_assemblerconst9 	 DD 	 9.600000  
_assemblerconst10 	 DB 	 "Esta en la lista" , '$', 13 dup(?) 
_assemblerconst11 	 DB 	 "un else" , '$', 22 dup(?) 
_assemblerconst12 	 DB 	 "" , '$', 29 dup(?) 
_assemblerconst13 	 DB 	 "soy una cadena@" , '$', 14 dup(?) 
_assemblerconst14 	 DB 	 "soy una cade%na para salida" , '$', 2 dup(?) 
@aux0 	 DD 	 ? 
@aux1 	 DD 	 ? 
@aux2 	 DD 	 ? 
@aux3 	 DD 	 ? 
@aux4 	 DD 	 ? 
@aux5 	 DD 	 ? 
@aux6 	 DD 	 ? 
@aux7 	 DD 	 ? 
@aux8 	 DD 	 ? 
_comp1 	 DD 	 1  
_comp0 	 DD 	 0  

 .CODE 
	;***STRLEN***
	STRLEN PROC
	             mov bx,0
	      STRL:
	            cmp BYTE PTR [SI+BX],"$"
	            je STREND
	            inc BX
	            jmp STRL
	      STREND:
		    ret
	STRLEN ENDP 

	;***COPIAR***
	COPIAR PROC
		call STRLEN  ;***STRLEN***
	    	cmp bx,MAXTEXTSIZE
	    	jle COPIARSIZEOK
	    	mov bx,MAXTEXTSIZE
	    COPIARSIZEOK:
	    	mov cx,bx ; la copia se hace de ’CX’ caracteres
	    	cld ; cld es para que la copia se realice hacia adelante
	    	rep movsb ; copia la cadea
	    	mov al,"$" ; carácter terminador
	    	mov BYTE PTR [DI],al
		ret
	COPIAR ENDP

Start:  
MOV AX, @DATA 
MOV DS,AX 
MOV ES,AX 
FILD _assemblerconst1 
FISTP c 
FLD _assemblerconst2 
FSTP a 
FLD _assemblerconst3 
FSTP b 
FLD _assemblerconst4 
FSTP d 
FILD _assemblerconst5 
FISTP e 
FLD _assemblerconst6 
FSTP h 
FLD _assemblerconst5 
FSTP i 
FLD _assemblerconst7 
FSTP j 
FLD _assemblerconst4 
FSTP b 
FLD a 
FLD b 
FADD 
FSTP @aux0 
FLD @aux0 
FSTP a 
FLD a 
FLD b 
FADD 
FSTP @aux0 
FLD @aux0 
FSTP d 
FLD e 
FILD f 
FMUL 
FSTP @aux0 
FLD @aux0 
FSTP d 
FLD b 
FLD a 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jbe _etiq50 
FILD _assemblerconst1 
FISTP c 
_etiq50: 
_etiq51: 
FLD a 
FLD b 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq66 
FLD d 
FILD _assemblerconst8 
FMUL 
FSTP @aux0 
FLD @aux0 
FSTP a 
GetFloat b,6  
jmp _etiq51
_etiq66: 
GetInteger c 
_etiq69: 
FLD b 
FILD _assemblerconst8 
FADD 
FSTP @aux0 
FLD a 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jb _etiq82 
FLD d 
FLD a 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jbe _etiq87 
_etiq82: 
FILD _comp1 
FILD _comp0 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jmp _etiq92
_etiq87: 
FILD _comp1 
FILD _comp1 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
_etiq92: 
jne _etiq104 
FLD d 
FILD _assemblerconst8 
FMUL 
FSTP @aux0 
FLD @aux0 
FSTP d 
DisplayFloat d,3  
newLine 
jmp _etiq69
_etiq104: 
FLD a 
FLD _assemblerconst9 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq131 
FLD b 
FLD d 
FADD 
FSTP @aux0 
FLD @aux0 
FLD b 
FDIV 
FSTP @aux0 
FLD a 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq131 
FLD b 
FLD d 
FMUL 
FSTP @aux0 
FLD a 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq131 
FILD _comp1 
FILD _comp0 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jmp _etiq135
_etiq131: 
FILD _comp1 
FILD _comp1 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
_etiq135: 
jne _etiq142 
displayString _assemblerconst10 
newLine 
jmp _etiq145
_etiq142: 
displayString _assemblerconst11 
newLine 
_etiq145: 
displayString _assemblerconst12 
newLine 
MOV si, OFFSET _assemblerconst13
MOV di,OFFSET g 
CALL COPIAR 
displayString _assemblerconst14 
newLine 
getString g 
displayString g 
newLine 
 MOV ax, 4C00h
 INT 21h
end Start 
