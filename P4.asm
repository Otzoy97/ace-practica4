include P4_M.asm
.model small
;--------------------------------------
; SEGMENTO DE PILA
;--------------------------------------
.stack
;--------------------------------------
; SEGMENTO DE DATO
;--------------------------------------
.data
    fileNameStr db 50 DUP('$')
    coinOption  db 5  DUP('$')
    optionMsg   db 5  DUP('$')
    ;handlerIn dw ?
    ;bufferInfo db 200 dup('$')
;--------------------------------------
ln      db "$"
hMsg    db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0ah, 0dh, "FACULTAD DE INGENIERA", 0ah, 0dh, "CIENCIAS Y SISTEMA", 0ah, 0dh, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 0ah, 0dh, "NOMBRE: SERGIO FERNANDO OTZOY GONZALEZ", 0ah, 0dh, "CARNET: 201602782", 0ah, 0dh, "SECCION: A$"
optMsg  db "    1) INICIAR JUEGO", 0ah, 0dh, "    2) CARGAR JUEGO", 0ah, 0dh, "    3) SALIR", 0ah, 0dh, 0ah, 0dh, "INGRESE UN VALOR[1/2/3]: $"
trnMsg1 db "TURNO NEGRAS N : $"
trnMsg2 db "TURNO BLANCAS B : $"

svAsMsg db "INGRESE NOMBRE PARA GUARDAR: $"
svRsMsg db "!JUEGO GUARDADO CON EXITO¡ $"

STREET  db 0BAH, "   $"
AVENUE  db " ", 0CDH," $"
SPCS3   db "   $"
SPCS2   db "  $"
SPCS1   db " $"

LOGICM  db 64 DUP(20H)

ctAVNE  db 38h ;CARACTER DE '8' 
ctLTTR  db 41h ;CARACTER DE 'A'

blackC  db "N$" ;'N'
whiteC  db "B$" ;'B'

actTurn db 1H ;0 BLANCAS, 1 NEGRAS
ctPASS  db 0H ;CONTADOR PARA EL NÚMERO DE VECES QUE SE UTILIZA PASS

boolV   db 1H ;VAR BOOLEANA QUE ME SERVIRÁ PARA RECUPERAR VALORES

PASSrw db "pass$"
EXITrw db "exit$"
SHOWrw db "show$"
SAVErw db "save$"


PLAYWD  db "1$"
LOADWD  db "2$"
EXITWD  db "3$"

.code
main proc
    Header:
        printStrln ln
        printStrln hMsg
    MainMenu:
        printStrln ln
        printStr optMsg
        flushStr optionMsg, SIZEOF optionMsg, 00H
        getLine optionMsg
        compareStr optionMsg, PLAYWD
        JE Play
        compareStr optionMsg, LOADWD
        JE Exit    
        compareStr optionMsg, EXITWD
        JE Exit
        JMP MainMenu
    Play:
        CMP actTurn, 01H                    ;DETERMINA DE QUIÉN ES EL TURNO
        JNE _printWhite                     ;NO ES IGUAL A 1,
        printStr trnMsg1                    ;ES IGUAL A 1, ENTONCES ES EL TURNO DE LAS NEGRAS
        JMP _play1                          ;SIGUE EL CURSO DE LA SECCIÓN PLAY
        _printWhite:
            printStr trnMsg2                ;ENTONCES ES EL TURNO DE LAS BLANCAS
        _play1:
            flushStr coinOption, SIZEOF coinOption, 00H
            getLine coinOption              ;RECUPERA LA OPCIÓN DEL USUARIO
            XOR AX, AX                      ;LIMPIA EL ACUMULADOR
            CMP coinOption[0], 61H          
            JB _upper                       ;CODIGO ASCII ES MENOR A 'a'
            CMP coinOption[0], 68H          
            JBE _digit                      ;CODIGO ASCII ES MENOR O IGUAL A 'h'
            JMP _play2                      ;CODIGO ASCII ES MAYOR A 'h'
        _upper:
            CMP coinOption[0], 41H
            JB _play2                       ;CODIGO ASCII ES MENOR A 'A'
            CMP coinOption[0], 48H
            JA _play2                       ;CODIGO ASCII ES MAYOR A 'H'
            ADD coinOption[0], 20H          ;SUMA CODIGO 32h para lograr una minúscula
        _digit:
            CMP coinOption[1], 31H
            JB _play2                       ;CODIGO ASCII ES MENOR A '1'
            CMP coinOption[1], 38H
            JBE _play3                      ;CODIGO ASCII ES MENOR O IGUAL A '8'
        _play2:
            toLower coinOption
            compareStr coinOption, PASSrw
            JE Pass
            compareStr coinOption, SHOWrw
            JE Show
            compareStr coinOption, SAVErw
            JE Save
            compareStr cointOption, EXITrw
            JE Exit
            JMP Play
        _play3:
            SUB coinOption[0], 61H      ;OBTIENE UN ÍNDICE DE COLUMNA, BASE 0 => coinOption[0] <- coinOption[0] - 61H
            MOV AL, 38H                 ;MUEVE UN OCHO ASCII AL ACUMULADOR-L, (PARA LUEGO MULTIPLICARLO) => AL <- 38H
            SUB AL, coinOption[1]       ;OBTIENE UN ÍNDICE DE FILA, BASE 0 => AL <- AL - coinOption[1]
            XOR BL, BL
            MOV BL, 08H
            MUL BL                      ;MULTIPLICA POR OCHO (EL NÚMERO DE COLUMNAS) 
            ADD AL, coinOption[0]       ;SUMA LA COLUMNA
            MOV BX, AX                  ;MUEVE EL RESULTADO A UN REGISTRO BASE
            CMP actTurn, 01H            ;¿TURNO?
            JE _playwhite               ;TURNO DE BLANCAS
            MOV LOGICM[BX], 4EH         ;GUARDA FICHA NEGRA
            DEC actTurn                 ;ASIGNA TURNO A BLANCA
            JMP BoardPrint              ;IMPRIME TABLERO
        _playwhite:
            MOV LOGICM[BX], 42H         ;GUARDA FICHA BLANCA
            INC actTurn                 ;ASIGNA TURNO A NEGRA
    BoardPrint:
        XOR SI, SI
        _loopBoardPrint:
            CMP ctAVNE, 30H
            JE _stopBoardPrint          ;TERMINA EL LOOP
            printChar ctAVNE
            printStr SPCS2              ;IMPRIME DOS ESPACIOS (AH CAMBIÓ)
            printChar LOGICM[SI]        ;IMPRIME EL CARACTER ALMACENADO EN LA MATRIZ
            INC SI                      ;INCREMENTA EL REGISTRO INDICE
            XOR CX, CX
            MOV CX, 07H
            _loopAvenuePrint:
                printStr AVENUE         ;IMPRIME EL CARACTER QUE SEPARADOR HORIZONTAL
                printChar LOGICM[SI]    ;IMPRIME EL CARACTER ALMACENADO EN LA MATRIZ
                INC SI                  ;INCREMENTA EL REGISTRO INDICE
                LOOP _loopAvenuePrint
            printStrln ln               ;IMRPIME UNA NUEVA LINEA
            printStr SPCS3              ;IMPRIME TRES ESPACIOS
            XOR CX, CX                  ;INICIALIZA EL REGISTRO DE CONTEO
            MOV CX, 08H             
            CMP ctAVNE, 31H             ;DETERMINA SI ctAVNE ES IGUAL A '1'
            JE _loopFootBoard           ;ES IGUAL A '1', NO DEBE IMPRIMIR LOS SEPARADORES VERTICALES
            _loopStreetPrint:       
                printStr STREET         ;IMPRIME LOS SEPARADORES VERTICALES
                LOOP _loopStreetPrint
            JMP _loopDecAVNE            ;SE MUEVE A LA SIG INSTRUCCION
            _loopFootBoard:             
                prinChar ctLTTR         ;IMPRIME A, B, C, D, E, F, G o H
                printStr SPCS3          ;IMPRIME TRES ESPACIOS
                INC ctLTTR              ;AUMENTA LA VARIABLE QUE ALMACENA EL CODIGO ASCII DE LAS LETRAS
                LOOP _loopFootBoard
            _loopDecAVNE:               
                printStrln ln           ;IMPRIME UNA NUEVA LINEA
                DEC ctAVNE              ;DECREMENTA EL CONTADOR DE FILAS
                JMP _loopBoardPrint     ;SALTA A LA SIG INSTRUCCIÓN
        _stopBoardPrint:
            MOV ctAVNE, 38h             ;REINICIA LA VARIABLE QUE CONTROLA EL CONTADOR DE FILAS
            MOV ctLTTR, 41h             ;REINICIA LA VARIABLE QUE CONTROLA EL CODIGO ASCII DE LAS LSETRAS (VER _loopFootBoard)
            JMP Play                    ;REGRESA AL CICLO DE PLAY
    Exit:
        MOV AX, 4C00H
        XOR AL, AL
        INT 21H
main endp
end main