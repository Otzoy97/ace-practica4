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

LOGICM  db 64 DUP(2)

ctAVNE  db 38h ;CARACTER DE '8' 
ctLTTR  db 41h ;CARACTER DE 'A'
ptLGCM  db 0   ;PUNTERO PARA RECORRER LOGICM

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
        CMP actTurn, 01H                ;DETERMINA DE QUIÉN ES EL TURNO
        JNE _printWhite                 ;NO ES IGUAL A 1,
        printStr trnMsg1                ;ES IGUAL A 1, ENTONCES ES EL TURNO DE LAS NEGRAS
        JMP _play1                      ;SIGUE EL CURSO DE LA SECCIÓN PLAY
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
        JA _play2                       ;CODIGO ASCII ES MAYOR A 'h'
    _upper:
        CMP coinOption[0], 41H
        JB _play2                       ;CODIGO ASCII ES MENOR A 'A'
        CMP coinOption[0], 48H
        JA _play2                       ;CODIGO ASCII ES MAYOR A 'H'
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
    _play3:
        SUB coinOption[0], 41H      ;OBTIENE UN ÍNDICE DE COLUMNA, BASE 0 => coinOption[0] <- coinOption[0] - 41H
        MOV AL, 38H                 ;MUEVE UN OCHO ASCII AL ACUMULADOR-L, (PARA LUEGO MULTIPLICARLO) => AL <- 38H
        SUB AL, coinOption[1]       ;OBTIENE UN ÍNDICE DE FILA, BASE 0 => AL <- AL - coinOption[1]
        XOR BL, BL
        MOV BL, 08H
        MOV BL, 08H
        MUL BL                      ;MULTIPLICA POR OCHO (EL NÚMERO DE COLUMNAS) 
        ADD AL, coinOption[0]       ;SUMA LA COLUMNA
        MOV BX, AX                  ;MUEVE EL RESULTADO A UN REGISTRO BASE
        CMP actTurn, 01H
        JE _playwhite
        MOV LOGICM[BX], 01H
        DEC actTurn
        JMP BoardPrint
    _playwhite:
        MOV LOGICM[BX], 00H
        INC actTurn
    BoardPrint:
        XOR SI, SI
        .WHILE ctAVNE != 30H
            MOV AH, 02H
            XOR DX, DX                  ;LIMPIA EL REGISTRO DX
            MOV DL, ctAVNE
            INT 21H                     ;IMPRIME EL CARACTER ALMACENADO EN CTAVNE
            printStr SPCS2              ;IMPRIME DOS ESPACIOS (AH CAMBIÓ)
            .IF(LOGICM[SI] == 01H) 
                printStr blackC
            .ELSEIF (LOGICM[SI] == 00H)
                printStr whiteC
            .ELSE 
                printStr SPCS1
            .ENDIF
            INC SI
            XOR BX, BX
            MOV BX, 07H
            .WHILE (BX != 0)
                printStr AVENUE         ;IPRIME UNA AVENIDA (AH CAMBIÓ)
                .IF(LOGICM[SI] == 01H)
                    printStr blackC
                .ELSEIF (LOGICM[SI] == 00H)
                    printStr whiteC
                .ELSE 
                    printStr SPCS1
                .ENDIF
                INC SI
                DEC BX
            .ENDW
            printStrln ln               ;IMPRIME UN SALTO DE LÍNEA, (AH CAMBIÓ)
            printStr SPCS3              ;IMPRIME 3 ESPACIOS, (AH, CAMBIÓ)
            XOR BX, BX
            MOV BX, 08H
            .IF (ctAVNE != 31H)
                .WHILE BX != 0
                    printStr STREET     ;IMPRIME LAS CALLES
                    DEC BX
                .ENDW
            .ELSE
                .WHILE BX != 0
                    MOV AH, 02H
                    XOR DX, DX          ;LIMPIA EL REGISTRO DX 
                    MOV DL, ctLTTR
                    INT 21H             ;IMPRIME EL CARACTER ALMACENADO EN CTAVNE
                    printStr SPCS3
                    INC ctLTTR          ;AUMENTA EL CONTADOR
                    DEC BX
                .ENDW
            .ENDIF
            printStrln ln               ;IMPRIME UN SALTO DE LÍNEA, (AH CAMBIÓ)
            DEC ctAVNE
        .ENDW
        MOV ctAVNE, 38h                 ;REINICIA LAS VARIABLES UTILIZADAS....
        MOV ctLTTR, 41h                 ;...COMO CONTADORES
        MOV ptLGCM, 0
        JMP Play
    Exit:
        MOV AX, 4C00H
        XOR AL, AL
        INT 21H
main endp
end main