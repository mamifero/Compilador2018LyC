flex between.l
pause
bison -dyv between.y
pause
gcc lex.yy.c y.tab.c -o TPFinal.exe
pause
TPFinal.exe Prueba.txt
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause
