include macros2.asm 
include number.asm 
.MODEL LARGE ; Modelo de memoria. 
.386 ; Tipo de procesador. 
.STACK 200h ;Bytes en el Stack. 

.DATA 

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

 .CODE 
Start:  
MOV AX, @DATA 
MOV DS,AX 
MOV R1,_assemblerconst1
MOV c,R1
MOV R1,_assemblerconst2
MOV a,R1
MOV R1,_assemblerconst3
MOV b,R1
MOV R1,_assemblerconst4
MOV d,R1
MOV R1,_assemblerconst5
MOV e,R1
MOV R1,_assemblerconst6
MOV h,R1
MOV R1,_assemblerconst5
MOV i,R1
MOV R1,_assemblerconst7
MOV j,R1
MOV R1,_assemblerconst4
MOV b,R1
MOV R1,a
ADD R1,b
MOV @aux0,R1
MOV R1,@aux0
MOV a,R1
MOV R1,a
ADD R1,b
MOV @aux1,R1
MOV R1,@aux1
MOV d,R1
MOV R1,e
MUL R1,f
MOV @aux2,R1
MOV R1,@aux2
MOV d,R1
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jbe _etiq50 
MOV R1,_assemblerconst1
MOV c,R1
_etiq50: 
_etiq51: 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq66 
MOV R1,d
MUL R1,_assemblerconst8
MOV @aux3,R1
MOV R1,@aux3
MOV a,R1
jmp _etiq51
_etiq66: 
_etiq69: 
MOV R1,b
ADD R1,_assemblerconst8
MOV @aux4,R1
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jb _etiq82 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jbe _etiq87 
_etiq82: 
FILD 1 
FILD 0 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jmp _etiq92
_etiq87: 
FILD 1 
FILD 1 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
_etiq92: 
jne _etiq104 
MOV R1,d
MUL R1,_assemblerconst8
MOV @aux5,R1
MOV R1,@aux5
MOV d,R1
jmp _etiq69
_etiq104: 
FLD _assemblerconst9 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq131 
MOV R1,b
ADD R1,d
MOV @aux6,R1
MOV R1,@aux6
DIV R1,b
MOV @aux7,R1
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq131 
MOV R1,b
MUL R1,d
MOV @aux8,R1
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
je _etiq131 
FILD 1 
FILD 0 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
jmp _etiq135
_etiq131: 
FILD 1 
FILD 1 
fxch 
fcomp 
ffree St(0) 
fstsw ax 
sahf 
_etiq135: 
jne _etiq142 
displayString _assemblerconst10 
jmp _etiq145
_etiq142: 
displayString _assemblerconst11 
_etiq145: 
displayString _assemblerconst12 
MOV R1,_assemblerconst13
MOV g,R1
displayString _assemblerconst14 
end Start 
