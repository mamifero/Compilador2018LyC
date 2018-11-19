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
e 	 DD 	 ? 
f 	 DD 	 ? 
g 	 DB 	 30 dup(?), '$'  
_9 	 DD 	 9  
_57.100000 	 DD 	 57.100000  
_9.000000 	 DD 	 9.000000  
_0.900000 	 DD 	 0.900000  
_-9 	 DD 	 -9  
_-429.100000 	 DD 	 -429.100000  
_-0.900000 	 DD 	 -0.900000  
_2 	 DD 	 2  
_9.600000 	 DD 	 9.600000  
_"Esta en la lista" 	 DB 	 ""Esta en la lista"" , '$', 13 dup(?) 
_"un else" 	 DB 	 ""un else"" , '$', 22 dup(?) 
_"" 	 DB 	 """" , '$', 29 dup(?) 
_"soy una cadena@" 	 DB 	 ""soy una cadena@"" , '$', 14 dup(?) 
_"soy una cade%na para salida" 	 DB 	 ""soy una cade%na para salida"" , '$', 2 dup(?) 
.CODE 

MOV AX, @DATA 

MOV DS,AX 

MOV R1,9
MOV const1,R1
MOV R1,-858993472.000000
MOV const2,R1
MOV R1,0.000000
MOV const3,R1
MOV R1,-858993472.000000
MOV const4,R1
MOV R1,-9
MOV const1,R1
MOV R1,-1717986944.000000
MOV const2,R1
MOV R1,-9
MOV const3,R1
MOV R1,-858993472.000000
MOV const4,R1
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
CMP b,a
jbe _etiq47 
MOV R1,9
MOV const1,R1
CMP a,b
je _etiq63 
MOV R1,d
MUL R1,2
MOV @aux3,R1
MOV R1,@aux3
MOV a,R1
GetFloat b,6  
jmp _etiq48
GetInteger c 
MOV R1,b
ADD R1,2
MOV @aux4,R1
CMP @aux4,a
jb _etiq79 
CMP d,a
jbe _etiq84 
CMP 1,0
jmp _etiq89
CMP 1,1
jne _etiq101 
MOV R1,d
MUL R1,2
MOV @aux5,R1
MOV R1,@aux5
MOV d,R1
DisplayFloat d,6  
jmp _etiq66
CMP a,858993472.000000
je _etiq128 
MOV R1,b
ADD R1,d
MOV @aux6,R1
MOV R1,@aux6
DIV R1,b
MOV @aux7,R1
CMP a,@aux7
je _etiq128 
MOV R1,b
MUL R1,d
MOV @aux8,R1
CMP a,@aux8
je _etiq128 
CMP 1,0
jmp _etiq132
CMP 1,1
jne _etiq139 
displayString "Esta en la lista" 
jmp _etiq142
displayString "un else" 
displayString "" 
MOV R1,"soy una cadena@"
MOV g,R1
displayString "soy una cade%na para salida" 
getString g 
displayString g 
