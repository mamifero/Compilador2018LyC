include macros2.asm 
include number.asm 
.MODEL LARGE ; Modelo de memoria. 
.386 ; Tipo de procesador. 
.STACK 200h ;Bytes en el Stack. 

.DATA 

MAXTEXTSIZE EQU 30
g 	 DB 	 30 dup(?), '$'  
_assemblerconst1 	 DB 	 "HOLA MUNDO" , '$', 19 dup(?) 
_assemblerconst2 	 DB 	 "soy una cadena@" , '$', 14 dup(?) 
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
displayString _assemblerconst1 
newLine 
MOV si, OFFSET _assemblerconst2
MOV di,OFFSET g 
CALL COPIAR 
displayString g 
newLine 
 MOV ax, 4C00h
 INT 21h
end Start 
