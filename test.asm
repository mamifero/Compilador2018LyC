holaMOV R1,9
MOV const1,R1
MOV R1,57.099998
MOV const2,R1
MOV R1,9.000000
MOV const3,R1
MOV R1,0.900000
MOV const4,R1
MOV R1,-9
MOV const1,R1
MOV R1,-429.100006
MOV const2,R1
MOV R1,-9
MOV const3,R1
MOV R1,-0.900000
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
BLE 47
MOV R1,9
MOV const1,R1
CMP a,b
BEQ 59
MOV R1,d
MUL R1,2
MOV @aux3,R1
MOV R1,@aux3
MOV d,R1
BI 47
MOV R1,b
ADD R1,2
MOV @aux4,R1
CMP @aux4,a
BLT 71
CMP d,a
BLE 76
CMP 1,0
BI 79
CMP 1,1
BNE 88
MOV R1,d
MUL R1,2
MOV @aux5,R1
MOV R1,@aux5
MOV d,R1
BI 59
CMP a,9.600000
BEQ 114
MOV R1,b
ADD R1,d
MOV @aux6,R1
MOV R1,@aux6
DIV R1,b
MOV @aux7,R1
CMP a,@aux7
BEQ 114
MOV R1,b
MUL R1,d
MOV @aux8,R1
CMP a,@aux8
BEQ 114
CMP 1,0
BI 117
CMP 1,1
BNE 123
BI 125
MOV R1,"soy una cadena@"
MOV g,R1
