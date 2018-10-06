flex tpgrupo9.l
pause
bison -dyv tpgrupo9.y
pause
gcc lex.yy.c y.tab.c -o tpgrupo9.exe
pause
tpgrupo9.exe Prueba.txt
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause
