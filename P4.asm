include P4_M.asm
.186
.model small
;--------------------------------------
; STACK SEGMENT
;--------------------------------------
.stack
;--------------------------------------
; DATA SEGMENT
;--------------------------------------
.data
;--------------------------------------
;-------------- CONSTANT --------------
;--------------------------------------
;------------ PRINT BLOCKS ------------
ln      db "$"
hMsg    db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0ah, 0dh, "FACULTAD DE INGENIERA", 0ah, 0dh, "CIENCIAS Y SISTEMA", 0ah, 0dh, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 0ah, 0dh, "NOMBRE: SERGIO FERNANDO OTZOY GONZALEZ", 0ah, 0dh, "CARNET: 201602782", 0ah, 0dh, "SECCION: A$"
optMsg  db "    1) INICIAR JUEGO", 0ah, 0dh, "    2) CARGAR JUEGO", 0ah, 0dh, "    3) SALIR", 0ah, 0dh, 0ah, 0dh, "INGRESE UN VALOR[1/2/3]: $"
trnMsg1 db "    TURNO NEGRAS N : $"
trnMsg2 db "    TURNO BLANCAS B : $"
svAsMsg db "    INGRESE NOMBRE PARA GUARDAR: $"
loadMsg db "    INGRESE NOMBRE PARA CARGAR: $"
svRsMsg db "    -- !JUEGO GUARDADO CON EXITO", 0ADH," --$"
coinEr1 db "    -- MOVIMIENTO ILEGAL: SUICIDIO --$"
coinEr2 db "    -- MOVIMIENTO ILEGAL: KO --$"
coinEr3 db "    -- MOVIMIENTO ILEGAL: POSICION OCUPADA --$"
fileEr1 db "    -- NO SE PUDO CREAR EL ARCHIVO --$"
fileEr2 db "    -- NO SE PUDO ESCRIBIR EN EL ARCHIVO --$"
fileEr3 db "    -- NO SE PUDO CERRAR EL ARCHIVO --$"
fileEr4 db "    -- NO SE PUDO ABRIR EL ARCHIVO --$"
fileEr5 db "    -- NO SE PUDO LEER EL ARCHIVO --$"
fileSc1 db "    -- !JUEGO CARGADO CON EXITO", 0ADH," --$"
fileSc2 db "    -- REPORTE GENERADO EXITOSAMENTE --$"
html1   db    "<!DOCTYPE html>", 0ah, 0dh
        db    "<html lang=", 22H, "en", 22H, ">", 0ah, 0dh
        db    "<head>", 0ah, 0dh
        db    "    <meta charset=", 22H, "UTF-8", 22H, ">", 0ah, 0dh
        db    "    <meta name=", 22H, "viewport", 22H, " content=", 22H, "width=device-width, initial-scale=1.0", 22H, ">", 0ah, 0dh
        db    "    <style>", 0ah, 0dh
        db    "        .tablero { height: 500px; width: 500px; background-color: #F8DC88; display: flex; justify-content: center; align-items: center; }", 0ah, 0dh
        db    "       .tablero div div { height: 50px; width: 50px; border: solid; border-width: 0.1px; }", 0ah, 0dh
        db    "       .negro1 { fill: black; height: 50px; width: 50px; margin-top: -25px; margin-left: -25px; position: absolute; }", 0ah, 0dh
        db    "       .blanco1 { fill: white; height: 50px; width: 50px; margin-top: -25px; margin-left: -25px; position: absolute; }", 0ah, 0dh
        db    "       .square { height: 50px; width: 50px; margin-top: -18px; margin-left: -27px; position: absolute; fill: rgba(0, 0, 0, 0); stroke: black; stroke-width: 2; }", 0ah, 0dh
        db    "       .cirque_out { fill: rgba(0, 0, 0, 0); stroke: black; stroke-width: 2px; height: 50px; width: 50px; margin-top: -24px; margin-left: -24px; position: absolute; }", 0ah, 0dh
        db    "       .triangle { fill: rgba(0, 0, 0, 0); stroke: black; stroke-width: 2px; height: 50px; width: 50px; margin-top: -35px; margin-left: -28px; position: absolute; }", 0ah, 0dh
        db    "       .negro2 { fill: black; height: 50px; width: 50px; margin-top: -25px; margin-left: 25px; position: absolute; }", 0ah, 0dh
        db    "       .blanco2 { fill: white; height: 50px; width: 50px; margin-top: -25px; margin-left: 25px; position: absolute; }", 0ah, 0dh
        db    "       .square1 { height: 50px; width: 50px; margin-top: -18px; margin-left: 23px; position: absolute; fill: rgba(0, 0, 0, 0); stroke: black; stroke-width: 2; }", 0ah, 0dh
        db    "       .cirque_out1 { fill: rgba(0, 0, 0, 0); stroke: black; stroke-width: 2px; height: 50px; width: 50px; margin-top: -24px; margin-left: 26px; position: absolute; }", 0ah, 0dh
        db    "       .triangle1 { fill: rgba(0, 0, 0, 0); stroke: black; stroke-width: 2px; height: 50px; width: 50px; margin-top: -35px; margin-left: 22px; position: absolute; }", 0ah, 0dh
        db    "       .top { position: absolute; margin-top: -55px; margin-left: -5px; font-size: 15px; font-weight: bold; }", 0ah, 0dh
        db    "       .top-left { position: absolute; margin-top: -55px; margin-left: 48px; font-size: 15px; font-weight: bold; }", 0ah, 0dh
        db    "       .left {position: absolute; margin-top: -10px;margin-left: -55px;font-size: 15px;font-weight: bold; }", 0ah, 0dh
        db    "    </style>", 0ah, 0dh
        db    "    <title>Juego</title>", 0ah, 0dh
        db    "</head>", 0ah, 0dh
        db    "<body>",0ah, 0dh
        db    "<div class=", 22H, "tablero", 22H, ">",0ah, 0dh,"$"

circle  db    "<circle cx=" , 22H, "25" , 22H, " cy=" , 22H, "25" , 22H, " r=" , 22H, "20" , 22H, " />",0ah, 0dh,"</svg>$"
htmlN1  db    "<svg class=" , 22H, "negro1" , 22H, ">",0ah, 0dh,"$"
htmlB1  db    "<svg class=" , 22H, "blanco1" , 22H, ">",0ah, 0dh,"$"
divo    db    "<div>",0ah, 0dh,"$"
divc    db    "</div>",0ah, 0dh,"$"
pltter1 db    "<p class=", 22H, "top", 22H, "> </p>",0ah, 0dh,"$"
pltter2 db    "<p class=", 22H, "top-left", 22H, "> </p>",0ah, 0dh,"$"
pnmber1 db    "<p class=", 22H, "left", 22H, "> </p>",0ah, 0dh,"$"
htmlN2  db    "<svg class=" , 22H, "negro2" , 22H, ">",0ah, 0dh,"$"
htmlB2  db    "<svg class=" , 22H, "blanco2" , 22H, ">",0ah, 0dh,"$"
htmlend db    "</body></html>",0ah, 0dh,"$"
RepName db    "rep .html", 00h
RepCte  db    'a'

;------------ BOARD PRINT -------------
STREET  db 0BAH, "   $"
AVENUE  db " ", 0CDH," $"
SPCS3   db "   $"
SPCS2   db "  $"
SPCS1   db " $"
;------------ CMP BLOCKS -------------
PASSrw db "pass$"
EXITrw db "exit$"
SHOWrw db "show$"
SAVErw db "save$"
PLAYWD  db "1$"
LOADWD  db "2$"
EXITWD  db "3$"
;--------------------------------------
;--------------- VOLATILE -------------
;--------------------------------------
LOGICM      db 64 DUP(20H)     ;ARREGLO DE 64 POSICIONES QUE SIMULAN UNA MATRIZ DE 2X2
LOGICM1     db 64 DUP(20H)     ;ARREGLO DE 64 POSICIONES QUE SIMULAN UNA MATRIZ DE 2X2, SERVIRÁ PARA ALMACENAR ÁREA CAPTURADA
LOGICM2     db 65 DUP(20H)     ;COPIA EXACTA DEL ARREGLO LOGICM QUE ESTARÁ DOS JUGADA ATRÁS PARA VALIDAR EL KO
POS         db 64 DUP(0)       ;ARREGLO AUXILIAR QUE SERVIRÁ PARA ALMACENAR POSICIONES
LIB         db 64 DUP(0)       ;ARREGLO AUXILIAR QUE SERVIRÁ PARA ALMACENAR LIBERTADES
ctPOS       db ?               ;CONTADOR DE FICHAS ALOJADAS  
ctAVNE      db 38h             ;CARACTER DE '8' 
ctLTTR      db 41h             ;CARACTER DE 'A'
actTurn     db 1H              ;0 BLANCAS, 1 NEGRAS, SERVIRÁ PARA DETERMINAR EL TURNO ACTUAL
ctPASS      db 0H              ;CONTADOR PARA EL NÚMERO DE VECES QUE SE UTILIZA PASS
coinOption  db 6  DUP('$') ;ALOJARÁ LA OPCIÓN QUE EL USUARIO INGRESE MIENTRAS ESTÉ JUGANDO
optionMsg   db 6  DUP('$') ;ALOJARÁ LA OPCIÓN QUE EL USUARIO INGRESE EN EL MENÚ PRINCIPAL
fileBuffer  db 66 DUP('$') ;ALOJARÁ EL CONTENIDO DEL ARCHIVO
fileName    db 50 DUP('$')  ;ALOJARÁ EL NOMBRE DEL ARCHIVO
fileHandlerVar dw ?            ;
date        db "00/00/0000 - $"
time        db "00:00:00$"
ctRep1      db ?
ctRep2      db ?
;--------------------------------------
; CODE SEGMENT
;--------------------------------------
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
        JE Load    
        compareStr optionMsg, EXITWD
        JE Exit
        JMP MainMenu
    Play:
        CMP actTurn, 01H                        ;DETERMINA DE QUIÉN ES EL TURNO
        JNE _printWhite                         ;NO ES IGUAL A 1,
        printStr trnMsg1                        ;ES IGUAL A 1, ENTONCES ES EL TURNO DE LAS NEGRAS
        JMP _play1                              ;SIGUE EL CURSO DE LA SECCIÓN PLAY
        _printWhite:
            printStr trnMsg2                    ;ENTONCES ES EL TURNO DE LAS BLANCAS
        _play1:
            flushStr coinOption, SIZEOF coinOption, 00H
            getLine coinOption                  ;RECUPERA LA OPCIÓN DEL USUARIO
            XOR AX, AX                          ;LIMPIA EL ACUMULADOR
            CMP coinOption[0], 'a'          
            JB _upper                           ;CODIGO ASCII ES MENOR A 'a'
            CMP coinOption[0], 'h'          
            JBE _digit                          ;CODIGO ASCII ES MENOR O IGUAL A 'h'
            JMP _play2                          ;CODIGO ASCII ES MAYOR A 'h'
        _upper:
            CMP coinOption[0], 'A'
            JB _play2                           ;CODIGO ASCII ES MENOR A 'A'
            CMP coinOption[0], 'H'
            JA _play2                           ;CODIGO ASCII ES MAYOR A 'H'
            ADD coinOption[0], 20H              ;SUMA CODIGO 32 para lograr una minúscula
        _digit:
            CMP coinOption[1], '1'
            JB _play2                           ;CODIGO ASCII ES MENOR A '1'
            CMP coinOption[1], '8'
            JBE _play3                          ;CODIGO ASCII ES MENOR O IGUAL A '8'
        _play2:
            toLower coinOption
            compareStr coinOption, PASSrw
            JE Pass
            compareStr coinOption, SAVErw
            JE Save
            compareStr coinOption, EXITrw
            JE ExitPlay
            compareStr coinOption, SHOWrw
            JE Reporte
            JMP Play
        _play3:
            SUB coinOption[0], 61H              ;OBTIENE UN ÍNDICE DE COLUMNA, BASE 0 => coinOption[0] <- coinOption[0] - 61H
            MOV AL, 38H                         ;MUEVE UN OCHO ASCII AL ACUMULADOR-L, (PARA LUEGO MULTIPLICARLO) => AL <- 38H
            SUB AL, coinOption[1]               ;OBTIENE UN ÍNDICE DE FILA, BASE 0 => AL <- AL - coinOption[1]
            XOR AH, AH                          ;LIMPIA AH
            SHL AX, 3                           ;MULTIPLICA POR OCHO
            ADD AL, coinOption[0]               ;SUMA LA COLUMNA
            XOR BH, BH                          ;LIMPIA EL INDICE BASE SUPERIOR
            MOV BX, AX                          ;MUEVE EL RESULTADO A UN REGISTRO BASE
            ;----- VERIFICA SI LA POSICIÓN GENERARÍA UNA CAPTURA -----
            ;----- BUSCA UNA FICHA ENEMIGA ----
            flushStr POS, 64, 00H               ;LIMPIA EL ARREGLO DE POSICIONES
            flushStr LIB, 64, 00H               ;LIMPIA EL ARREGLO DE LIBERTADES
            flushStr ctPOS, 1, 00h              ;LIMPIA EL CONTADOR DE POSICIONES
            .IF (actTurn == 01H)
                ;TURNO DE NEGRAS
                MOV AH, 'B' 
            .ELSE
                MOV AH, 'N'
            .ENDIF
            .IF (BX > 7)                 
                ;SI ES MENOR A 8 NO VERIFICARÁ HACIA ARRIBA
                .IF (LOGICM[BX - 8] == AH)
                    MOV CL, BL
                    SUB CL, 08H
                    MOV POS, CL                 ;ALOJA LA POSICIÓN EN DÓNDE SE ENCONTRÓ A UN ENEMIGO
                    INC ctPOS                   ;AUMENTA EL CONTDOR DE POSICIONES ALOJADAS
                .ENDIF
            .ENDIF
            .IF (BX < 56)                       
                ;SI ES MAYOR O IGUAL A 56 NO VERIFCARÁ HACIA ABAJO
                .IF (LOGICM[BX + 8] == AH)
                    MOV CL, BL
                    ADD CL, 08H
                    MOV POS[1], CL
                    INC ctPOS
                .ENDIF
            .ENDIF
            .IF (BX != 7 && BX != 15 && BX != 23 && BX != 31 && BX != 39 && BX != 47 && BX != 55 && BX != 63)
                ;SI ES UN LATERAL IZQUIERDO NO VERIFICARÁ HACIA LA IZQUIERDA
                .IF (LOGICM[BX + 1] == AH)
                    MOV CL, BL
                    ADD CL, 01H
                    MOV POS[2], CL
                    INT ctPOS
                .ENDIF
            .ENDIF
            .IF (BX != 0 && BX != 8 && BX != 16 && BX != 24 && BX != 32 && BX != 40 && BX != 48 && BX != 56)
                ;SI ES UN LATERAL DERECHO NO VERIFICARÁ HACIA LA DERECHA
                .IF (LOGICM[BX - 1] == AH)
                    MOV CL, BL
                    SUB CL, 01H
                    MOV POS[3], CL
                    INC ctPOS
                .ENDIF
            .ENDIF
            ;----- RECUPERAR FORMACION
            XOR SI, SI
            MOV CX, CX
            XOR DI, DI
            ;CAMBIA A BUSCAR FICHAS AMIGAS
            .IF (AH == 'B')
                MOV AH, 'N' 
            .ELSE
                MOV AH, 'B'
            .ENDIF
            .WHILE( SI != ctPOS)
                ;RECUPERA LA FORMACIÓN
                MOV CL, POS[SI]
                .IF (CX > 7)                 
                    ;SI ES MENOR A 8 NO VERIFICARÁ HACIA ARRIBA
                    .IF (LOGICM[CX - 8] == AH)
                        MOV AL, CL
                        SUB AL, 08H
                        PUSH AL                         ;GUARDA LA POSICION 
                        CALL posExist
                        .IF (AL == 00H)
                            POP AL                         ;RECUPERA EL VALOR ALOJADO EN AL
                            MOV DI, ctPOS                   ;
                            MOV POS[DI], AL                 ;ALOJA LA POSICIÓN EN DÓNDE SE ENCONTRÓ A UN AMIGO
                            INC ctPOS                       ;AUMENTA EL CONTDOR DE POSICIONES ALOJADAS
                        .ENDIF
                    .ENDIF
                .ENDIF
                .IF (CX < 56)                       
                    ;SI ES MAYOR O IGUAL A 56 NO VERIFCARÁ HACIA ABAJO
                    .IF (LOGICM[CX + 8] == AH)
                        MOV AL, CL
                        ADD AL, 08H
                        PUSH AL                         ;GUARDA LA POSICION 
                        CALL posExist
                        .IF (AL == 00H)
                            POP AL                         ;RECUPERA EL VALOR ALOJADO EN AL
                            MOV DI, ctPOS                   ;
                            MOV POS[DI], AL                 ;ALOJA LA POSICIÓN EN DÓNDE SE ENCONTRÓ A UN AMIGO
                            INC ctPOS                       ;AUMENTA EL CONTDOR DE POSICIONES ALOJADAS
                        .ENDIF
                    .ENDIF
                .ENDIF
                .IF (CX != 7 && CX != 15 && CX != 23 && CX != 31 && CX != 39 && CX != 47 && CX != 55 && CX != 63)
                    ;SI ES UN LATERAL IZQUIERDO NO VERIFICARÁ HACIA LA IZQUIERDA
                    .IF (LOGICM[CX + 1] == AH)
                        MOV AL, CL
                        ADD AL, 01H
                        PUSH AL                         ;GUARDA LA POSICION 
                        CALL posExist
                        .IF (AL == 00H)
                            POP AL                         ;RECUPERA EL VALOR ALOJADO EN AL
                            MOV DI, ctPOS                   ;
                            MOV POS[DI], AL                 ;ALOJA LA POSICIÓN EN DÓNDE SE ENCONTRÓ A UN AMIGO
                            INC ctPOS                       ;AUMENTA EL CONTDOR DE POSICIONES ALOJADAS
                        .ENDIF
                    .ENDIF
                .ENDIF
                .IF (CX != 0 && CX != 8 && CX != 16 && CX != 24 && CX != 32 && CX != 40 && CX != 48 && CX != 56)
                    ;SI ES UN LATERAL DERECHO NO VERIFICARÁ HACIA LA DERECHA
                    .IF (LOGICM[CX - 1] == AH)
                        MOV AL, CL
                        SUB AL, 01H
                        PUSH AL                         ;GUARDA LA POSICION 
                        CALL posExist
                        .IF (AL == 00H)
                            POP AL                         ;RECUPERA EL VALOR ALOJADO EN AL
                            MOV DI, ctPOS                   ;
                            MOV POS[DI], AL                 ;ALOJA LA POSICIÓN EN DÓNDE SE ENCONTRÓ A UN AMIGO
                            INC ctPOS                       ;AUMENTA EL CONTDOR DE POSICIONES ALOJADAS
                        .ENDIF
                    .ENDIF
                .ENDIF
                ;------ CONTARÁ LIBERTADES
                .IF (CX > 7)                 
                    ;SI ES MENOR A 8 NO VERIFICARÁ HACIA ARRIBA
                    .IF (LOGICM[CX - 8] == 20H)
                        INC LIB[SI]
                    .ENDIF
                .ENDIF
                .IF (CX < 56)                       
                    ;SI ES MAYOR O IGUAL A 56 NO VERIFCARÁ HACIA ABAJO
                    .IF (LOGICM[CX + 8] == 20H)
                        INC LIB[SI]
                    .ENDIF
                .ENDIF
                .IF (CX != 7 && CX != 15 && CX != 23 && CX != 31 && CX != 39 && CX != 47 && CX != 55 && CX != 63)
                    ;SI ES UN LATERAL IZQUIERDO NO VERIFICARÁ HACIA LA IZQUIERDA
                    .IF (LOGICM[CX + 1] == 20H)
                        INC LIB[SI]
                    .ENDIF
                .ENDIF
                .IF (CX != 0 && CX != 8 && CX != 16 && CX != 24 && CX != 32 && CX != 40 && CX != 58 && CX != 66)
                    ;SI ES UN LATERAL DERECHO NO VERIFICARÁ HACIA LA DERECHA
                    .IF (LOGICM[CX - 1] == 20H)
                        INC LIB[SI]
                    .ENDIF
                .ENDIF
                DEC CX
            .ENDW
            CMP LOGICM[BX], 20H                 ;COMPARA SI LA POSICION ES IGUAL A UN ESPACIO
            JE _play4                           ;ES UN ESPACIO DISPONIBLE
            printStrln coinEr3                  ;INFORMA AL USUARIO QUE ESA POSICIÓN YA ESTÁ OCUPADA
            JMP Play                            ;REGRESA AL FLUJO DE PLAY
        _play4:
            CMP actTurn, 01H                    ;¿TURNO?
            JNE _playwhite                      ;TURNO DE BLANCAS
            MOV LOGICM[BX], 4EH                 ;GUARDA FICHA NEGRA
            DEC actTurn                         ;ASIGNA TURNO A BLANCA
            JMP BoardPrint                      ;IMPRIME TABLERO
        _playwhite:
            MOV LOGICM[BX], 42H                 ;GUARDA FICHA BLANCA
            INC actTurn                         ;ASIGNA TURNO A NEGRA
    BoardPrint:
        XOR SI, SI
        _loopBoardPrint:
            CMP ctAVNE, 30H
            JE _stopBoardPrint                  ;TERMINA EL LOOP
            printChar ctAVNE
            printStr SPCS2                      ;IMPRIME DOS ESPACIOS (AH CAMBIÓ)
            printChar LOGICM[SI]                ;IMPRIME EL CARACTER ALMACENADO EN LA MATRIZ
            INC SI                              ;INCREMENTA EL REGISTRO INDICE
            XOR CX, CX
            MOV CX, 07H
            _loopAvenuePrint:
                printStr AVENUE                 ;IMPRIME EL CARACTER QUE SEPARADOR HORIZONTAL
                printChar LOGICM[SI]            ;IMPRIME EL CARACTER ALMACENADO EN LA MATRIZ
                INC SI                          ;INCREMENTA EL REGISTRO INDICE
                LOOP _loopAvenuePrint
            printStrln ln                       ;IMRPIME UNA NUEVA LINEA
            printStr SPCS3                      ;IMPRIME TRES ESPACIOS
            XOR CX, CX                          ;INICIALIZA EL REGISTRO DE CONTEO
            MOV CX, 08H             
            CMP ctAVNE, 31H                     ;DETERMINA SI ctAVNE ES IGUAL A '1'
            JE _loopFootBoard                   ;ES IGUAL A '1', NO DEBE IMPRIMIR LOS SEPARADORES VERTICALES
            _loopStreetPrint:       
                printStr STREET                 ;IMPRIME LOS SEPARADORES VERTICALES
                LOOP _loopStreetPrint
            JMP _loopDecAVNE                    ;SE MUEVE A LA SIG INSTRUCCION
            _loopFootBoard:             
                printChar ctLTTR                ;IMPRIME A, B, C, D, E, F, G o H
                printStr SPCS3                  ;IMPRIME TRES ESPACIOS
                INC ctLTTR                      ;AUMENTA LA VARIABLE QUE ALMACENA EL CODIGO ASCII DE LAS LETRAS
                LOOP _loopFootBoard
            _loopDecAVNE:               
                printStrln ln                   ;IMPRIME UNA NUEVA LINEA
                DEC ctAVNE                      ;DECREMENTA EL CONTADOR DE FILAS
                JMP _loopBoardPrint             ;SALTA A LA SIG INSTRUCCIÓN
        _stopBoardPrint:
            MOV ctAVNE, 38h                     ;REINICIA LA VARIABLE QUE CONTROLA EL CONTADOR DE FILAS
            MOV ctLTTR, 41h                     ;REINICIA LA VARIABLE QUE CONTROLA EL CODIGO ASCII DE LAS LSETRAS (VER _loopFootBoard)
            JMP Play                            ;REGRESA AL CICLO DE PLAY
    Pass:
        INC ctPASS                              ;INCREMENTA EL CONTADOR
        CMP ctPASS, 02H
        JNE _passTurn
        flushStr LOGICM, SIZEOF LOGICM, 20H     ;LIMPIA EL ARREGLO LÓGICO DE POSICIONES
        MOV actTurn, 01H                        ;ESTABLECE EL TURNO PARA LAS NEGRAS
        MOV ctPASS, 00H                         ;LIMPIA EL VALOR DE ctPASS
        JMP Header
        _passTurn:
            CMP actTurn, 01H
            JNE _whiteTurn
            DEC actTurn                         ;DISMINUYE actTurn, ESO HARÁ QUE SEA EL TURNO DE LAS BLANCAS
            JMP Play                            ;REGRESA A LA SECCIÓN DE JUEGO
        _whiteTurn:
            INC actTurn                         ;INCREMENTA actTurn, ESO HARÁ QUE SEA EL TURNO DE LAS NEGRAS
            JMP Play                            ;REGRESA A LA SECCIÓN DE JUEGO
    Save:
        XOR SI, SI                              ;LIMPIA EL INDICE
        XOR CX, CX                              ;LIMPIA EL CONTEO
        MOV CX, 0040H                           ;INICIALIZA EL CONTEO (64)
        MOV AL, actTurn                         ;ALOJA EL TURNO ACTUAL
        ADD AL, 30H                             ;CONVIERTE EL NUMERO EN UN CÓDIGO ASCII RECONOCIBLE
        MOV fileBuffer, AL                      ;ALMACENA EL CODIGO ASCII
        _loopCreateBuffer:          
            MOV AL, LOGICM[SI]                  ;MUEVE EL VALOR DE LOGICM AL ACUMULADOR
            MOV fileBuffer[SI+0001H], AL        ;MUEVE EL ACUMULADOR AL BUFFER DE CONTENIDO DE ARCHIVO
            INC SI                              ;INCREMENTA EL INDICE
            LOOP _loopCreateBuffer
        printStrln svAsMsg                      ;SOLICITA EL NOMBRE DEL ARCHIVO
        flushStr fileName, SIZEOF fileName, 00H
        getLine fileName                        ;RECUPERA EL NOMBRE DEL ARCHIVO
        createFile fileName                     ;CREA EL ARCHIVO
        JC _err1ToPlay                          ;EXISTIÓ UN ERROR
        MOV fileHandlerVar, AX                  ;ALMACENA EL HANDLER
        writeFile fileHandlerVar, fileBuffer, 41H ;ESCRIBE EN EL ARCHIVO
        JC _err2ToPlay                          ;EXISTIÓ UN ERROR
        printStrln svRsMsg                      ;ARCHIVO CORRRECTAMENTE ESCRITO
        closeFile fileHandlerVar                ;CIERRA EL ARCHIVO
        JMP Play                                ;REGRESA AL FLUJO DEL JUEGO
        _err1ToPlay:                        
            printStrln fileEr1                  ;NO SE PUDO CREAR EL ARCHIVO
            JMP Play                            ;REGRESA AL FLUJO DEL JUEGO
        _err2ToPlay:
            printStrln fileEr2                  ;NO SE PUDO ESCRIBIR EN EL ARCHIVO
            closeFile fileHandlerVar            ;INTENTA CERRAR EL ARCHIVO
            JMP Play                            ;REGRESA AL FLUJO DEL JUEGO
    Load:
        printStrln loadMsg                      ;INFORMA AL USUARIO QUE INGRESE EL NOMBRE DEL ARCHIVO
        flushStr fileName, SIZEOF fileName, 00H ;LIMPIA LA CADENA EN LA QUE SE ALMACENARÁ EL NOMBRE DEL ARCHIVO
        getLine fileName                        ;RECUPERA EL NOMBRE DEL ARCHIVO
        openFile fileName, fileHandlerVar       ;INTENTA ABRIR EL ARCHIVO 
        JC _loadErr4                            ;NO PUDO ABRIR EL ARCHIVO
        MOV fileHandlerVar, AX                  ;ALMACENA EL HANDLER DEL ARCHIVO
        readFile fileHandlerVar, fileBuffer, 41h ;LEE EL CONTENIDO DEL ARCHIVO Y LO ALMACENA EN EL BUFFER
        JC _loadErr5                            ;NO PUDO LEER EL ARCHIVO
        closeFile fileHandlerVar                ;CIERRA EL ARCHIVO
        printStrln fileSc1                      ;INFORMA AL USUARIO QUE EL PROCESO FUE EXITOSO
        XOR SI, SI                              ;LIMPIA EL REGISTRO INDICE
        XOR CX, CX                              ;LIMPIA EL REGISTRO DE CONTEO
        XOR CX, 0040h
        MOV AL, fileBuffer                      ;MUEVE EL PRIMER VALOR DEL BUFFER AL ACUMULADOR
        SUB AL, 30H                             ;CONVIERTE EL SIMBOLO ASCII A UN NUMERO
        MOV actTurn, AL                         ;ALOJA EL TURNO EN EL QUE SE QUEDÓ EL JUEGO
        _loadGame:                              
            MOV AL, fileBuffer[SI + 0001H]      ;MUEVE EL CONTENIDO DEL BUFFER AL ACUMULADOR
            MOV LOGICM[SI], AL                  ;MUEVE EL CONTENIDO DEL ACUMULADOR A LA MATRIZ LOGICA
            INC SI                              ;AUMENTA EL REGISTRO INDICE
            LOOP _loadGame                      ;LOOP
        JMP Play                                ;TERMINA EL PROCESO Y SALTA A Play
        _loadErr4:                      
            printStrln fileEr4                  ;INFORMA AL USUARIO QUE OCURRIÓ UN ERROR AL INTENTAR ABRIR EL ARCHIVO
            JMP MainMenu
        _loadErr5:
            printStrln fileEr5                  ;INFORMA LA USUARIO QUE OCURRIÓ UN ERRROR AL INTENTAR LEER EL ARCHIVO
            closeFile fileHandlerVar            ;INTENTA CERRAR EL ARCHIVO
            JMP MainMenu
    ExitPlay:
        flushStr LOGICM, SIZEOF LOGICM, 20H ;LIMPIA EL ARREGLO LÓGICO DE POSICIONES
        MOV actTurn, 01H                ;ESTABLECE EL TURNO PARA LAS NEGRAS
        MOV ctPASS, 00H              ;LIMPIA EL VALOR DE ctPASS
        CALL genRep
        JMP Header
    Reporte:
        CALL genRep
        JMP Play
    Exit:
        MOV AX, 4C00H
        INT 21H
main endp

getDate PROC
	MOV AH, 04H
	INT 1AH
	MOV BX, OFFSET DATE
	MOV AL, DL
	CALL toASCII
	INC BX
	MOV AL, DH	
	CALL toASCII
	INC BX
	MOV AL, CH
	CALL toASCII
	MOV AL, CL
	CALL toASCII
	RET
getDate ENDP

getTime PROC
	MOV AH, 02H
	INT 1AH
	MOV BX, OFFSET TIME
	MOV AL, CH
	CALL toASCII
	INC BX
	MOV AL, CL
	CALL toASCII
	INC BX
	MOV AL, DH
	CALL toASCII
	RET
getTime ENDP

toASCII PROC
	PUSH AX
	SHR AX, 4
	AND AX, 0FH
	ADD AX, '0'
	MOV [BX], AL
	INC BX
	POP AX
	AND AX, 0FH
	ADD AX, '0'
	MOV [BX], AL
	INC BX
	RET
toASCII ENDP

genRep PROC
    MOV AL, RepCte                          ;MUEVE AL ACUMULADOR LA LETRA DE REPORTE
    .IF (AL > 'z')
        MOV AL, 'a'
        MOV RepCte, AL
    .ENDIF
    MOV RepName[3], AL                       ;COMPONE EL NOMBRE DEL REPORTE
    createFile RepName                       ;CREA EL ARCHIVO
    MOV fileHandlerVar, AX                   ;ALMACENA EL HANDLER
    ;------------------ IMPRESION DEL ENCABEZADO ------------------
    MOV BX, OFFSET html1                     ;ALMACENA LA DIRECCIÓN DEL ARREGLO EN BASE 
    CALL contarRep                           ;LLAMA EL PROCEDIMIENTO PARA CONTAR EL TAMAÑO DEL ARREGLO
    writeFile fileHandlerVar, html1, SI      ;ESCRIBE EL HEADER DEL REPORTE
    ;------------------ IMPRESION DEL TABLERO ------------------
    MOV AL, 01H
    MOV ctRep1, AL                          ;INICIALIZA EL CONTADOR
    flushStr coinOption, SIZEOF coinOption, 00H
    .WHILE (ctRep1 < 8 )
        ;------------------ IMPRESION DE APERTURA DIV ------------------
        MOV BX, OFFSET divo
        CALL contarRep
        writeFile fileHandlerVar, divo, SI  ;ESCRIBE UN DIV
        ;------------------ IMPRESION DE PARRAFO CON LETRA ------------------
        MOV AL, ctRep1
        MOV pltter1[15], AL                ;ALOJA LA LETRA DE COLUMNA
        ADD pltter1[15], 40H                ;CONVIERTE A ASCII
        MOV BX, OFFSET pltter1              
        CALL contarRep
        writeFile fileHandlerVar, pltter1, SI 
        .IF (ctRep1 == 7)
            ;------------------ IMPRESION DE PARRAFO CON LETRA EN LA ÚLTIMA COLUMNA ------------------
            MOV AL, ctRep1
            MOV pltter2[20], AL             ;ALOJA LA LETRA DE COLUMNA
            ADD pltter2[20], 41H                ;CONVIERTE A ASCII
            MOV BX, OFFSET pltter2              
            CALL contarRep
            writeFile fileHandlerVar, pltter2, SI 
        .ENDIF
        MOV AL, 08H
        MOV ctRep2, AL
        .WHILE (ctRep2 > 0)
            .IF (ctRep2 != 1)
                ;------------------ IMPRESION DE APERTURA DIV ------------------
                MOV BX, OFFSET divo
                CALL contarRep
                writeFile fileHandlerVar, divo, SI 
            .ENDIF
            ;------------------ IMPRESION DE PARRAFO CON NUMERO ------------------
            .IF (ctRep1 == 1)
                MOV AL, ctRep2
                MOV pnmber1[16], AL             
                ADD pnmber1[16], '0'                
                MOV BX, OFFSET pnmber1              
                CALL contarRep
                writeFile fileHandlerVar, pnmber1, SI 
            .ENDIF
            ;------------------ IMPRESION DE SVG ------------------
            .IF (ctRep1 != 7)
                ;-- COLUMNA
                MOV AL, ctRep1                  
                SUB AL, 01
                MOV coinOption[0], AL
                ;-- FILA    
                MOV AL, 08H
                SUB AL, ctRep2
                ;-- ACCESO POR MAPEO
                XOR AH, AH
                SHL AX, 3
                ADD AL, coinOption[0]
                MOV BX, AX
                .IF LOGICM[BX] == 'B'
                    ;-----
                    MOV BX, OFFSET htmlB1
                    CALL contarRep
                    writeFile fileHandlerVar, htmlB1, SI
                    ;-----
                    MOV BX, OFFSET circle
                    CALL contarRep
                    writeFile fileHandlerVar, circle, SI
                .ELSEIF LOGICM[BX] == 'N'
                    ;-----
                    MOV BX, OFFSET htmlN1
                    CALL contarRep
                    writeFile fileHandlerVar, htmlN1, SI
                    ;-----
                    MOV BX, OFFSET circle
                    CALL contarRep
                    writeFile fileHandlerVar, circle, SI
                .ENDIF
            .ELSE
                ;-- COLUMNA
                MOV AL, ctRep1                  
                SUB AL, 01
                MOV coinOption[0], AL
                ;-- FILA    
                MOV AL, 08H
                SUB AL, ctRep2
                ;-- ACCESO POR MAPEO
                XOR AH, AH
                SHL AX, 3
                ADD AL, coinOption[0]
                MOV BX, AX
                .IF LOGICM[BX] == 'B'
                    ;-----
                    MOV BX, OFFSET htmlB1
                    CALL contarRep
                    writeFile fileHandlerVar, htmlB1, SI
                    ;-----
                    MOV BX, OFFSET circle
                    CALL contarRep
                    writeFile fileHandlerVar, circle, SI
                .ELSEIF LOGICM[BX] == 'N'
                    ;-----
                    MOV BX, OFFSET htmlN1
                    CALL contarRep
                    writeFile fileHandlerVar, htmlN1, SI
                    ;-----
                    MOV BX, OFFSET circle
                    CALL contarRep
                    writeFile fileHandlerVar, circle, SI
                .ENDIF
                ;-- COLUMNA
                MOV AL, ctRep1    
                MOV coinOption[0], AL
                ;-- FILA    
                MOV AL, 08H
                SUB AL, ctRep2
                ;-- ACCESO POR MAPEO
                XOR AH, AH
                SHL AX, 3
                ADD AL, coinOption[0]
                MOV BX, AX
                .IF LOGICM[BX] == 'B'
                    ;-----
                    MOV BX, OFFSET htmlB2
                    CALL contarRep
                    writeFile fileHandlerVar, htmlB2, SI
                    ;-----
                    MOV BX, OFFSET circle
                    CALL contarRep
                    writeFile fileHandlerVar, circle, SI
                .ELSEIF LOGICM[BX] == 'N'
                    ;-----
                    MOV BX, OFFSET htmlN2
                    CALL contarRep
                    writeFile fileHandlerVar, htmlN2, SI
                    ;-----
                    MOV BX, OFFSET circle
                    CALL contarRep
                    writeFile fileHandlerVar, circle, SI
                .ENDIF
            .ENDIF
            .IF (ctRep2 != 1)
                ;------------------ IMPRESION DE CERRADURA DIV ------------------
                MOV BX, OFFSET divc
                CALL contarRep
                writeFile fileHandlerVar, divc, SI
            .ENDIF
            DEC ctRep2
        .ENDW
        ;------------------ IMPRESION DE CERRADURA DIV ------------------
        MOV BX, OFFSET divc
        CALL contarRep
        writeFile fileHandlerVar, divc, SI
        INC ctRep1
    .ENDW
    ;------------------ IMPRESION DE CERRADURA DIV ------------------
    MOV BX, OFFSET divc
    CALL contarRep
    writeFile fileHandlerVar, divc, SI
    ;------------------ IMPRESION DE APERTURA DIV ------------------
    MOV BX, OFFSET divo
    CALL contarRep
    writeFile fileHandlerVar, divo, SI  ;ESCRIBE UN DIV
    ;------------------ IMPRESION DE FECHA DIV ------------------
    CALL getDate
    CALL getTime
    MOV BX, OFFSET date
    CALL contarRep
    writeFile fileHandlerVar, date, SI
    MOV BX, OFFSET time
    CALL contarRep
    writeFile fileHandlerVar, time, SI
    ;------------------ IMPRESION DE CERRADURA DIV ------------------
    MOV BX, OFFSET divc
    CALL contarRep
    writeFile fileHandlerVar, divc, SI
    ;------------------ IMPRESION DE CERRADURA HTML ------------------
    MOV BX, OFFSET htmlend
    CALL contarRep
    writeFile fileHandlerVar, htmlend, SI
    ;------------------ CERRAR ARCHIVO ------------------
    closeFile fileHandlerVar
    printStrln fileSc2
    INC RepCte
    RET
genRep ENDP

contarRep PROC
    XOR SI, SI
    MOV AL, '$'
    .WHILE ( [BX + SI] != AL)
        INC SI
    .ENDW
    RET
contarRep ENDP

posExist PROC
LOCAL cteARR:BYTE, ptPOS:BYTE
    MOV cteARR, ctPOS         ;INICIALIZA EL CONTADOR
    MOV ptPOS, AL             ;INICIALIZA EL CONTADOR
    XOR DI, DI
    .WHILE (DI != cteARR)
        .IF (POS[DI] == ptPOS)
            MOV AL, 01H
            JMP _posExistExit
            .BREAK
        .ENDIF
        INC DI
    .ENDW
    MOV AL, 00H
    _posExistExit:
        XOR DI, DI
        RET
posExist PROC

end main