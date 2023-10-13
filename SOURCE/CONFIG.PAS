{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compilaá∆o}

{****************************************************************************}

Program Configurador;

{****************************************************************************}
{

        Programa para configurar o Software Principal do Analisador L¢gico

                 "Os PEP Legais" - LAO - 4oR -Eletrìnica


}
{****************************************************************************}

{       CrÇditos:
                  Luiz Eduardo    - N¯19
                  Marcos Paulo    - N¯23
                  Rafael Abolafio - N¯26
                  Robson Martins  - N¯30

                  4¯R - Eletrìnica - 1997

              Liceu de Artes e Of°cios de S∆o Paulo

              Prof: Marco Antìnio Togniazzolo
}
{****************************************************************************}

Uses Crt,Dos,PEPUnit;
{Units a serem usadas}

{****************************************************************************}

Function Hex2Dec(H:String):Word;
{Entrada: String = Hexadecimal de 000 a FFF}
{Sa°da: Word = Decimal de 0 a 4095}

Var WordValue:Word; {Word que varia de 0 a 4095}
    HexV:String; {Valor em hexadecimal}

Begin
     WordValue:=0;
Repeat
     HexV:=DecToHex(WordValue,True);
     Delete(HexV,1,1);
     If H=HexV Then Break;
     WordValue:=WordValue+1;
Until WordValue>$FFF;
     If WordValue>$FFF Then Hex2Dec:=0
     Else Hex2Dec:=WordValue;
End;

{****************************************************************************}

Procedure ApagaTela;
{Apaga a tela}

Begin
     Window (1,1,80,25);
     TextColor (LightGray);
     TextBackGround (Black);
     Clrscr;
End;

{****************************************************************************}

Procedure Fim;
{Finaliza o programa}

Begin
     ApagaTela;
     Writeln;
     Halt(0);
End;

{****************************************************************************}

Procedure Win1;
{Tela inicial do programa}

Var Tecla:Char; {Armazena o caracter lido do teclado}
    PosStat:Integer; {Utilizada para apagar lihas da tela}

Begin
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (8,'PROGRAMA DE CONFIGURAÄ«O');
     CenterTxt (9,'DO');
     CenterTxt (10,'ANALISADOR L‡GICO');
     TextColor (White);
     CenterTxt (13,'"Os PEP Legais"');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter para Continuar ou Esc para Sair');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

Repeat
      Tecla:=Readkey;
      If Tecla=#27 Then Fim;
Until Tecla=#13;

     Window (1,1,80,25);
     Textcolor (Black);
     TextBackground (White);
     For PosStat:=2 To 60 Do Begin
         Gotoxy (PosStat,24);
         Write (' ');
     End;
End;

{****************************************************************************}

Procedure Win2;
{Telas de Configuraá‰es}

Var Tecla:Char; {Armazena o caracter lido do teclado}
    PosStat:Integer; {Utilizada para apagar linhas da tela}
    Ender:Word; {Endereáo da LPT}
    VerifIntFace:Byte; {Constante de Verificaá∆o de Interface}
    VerifDC:Byte; {Constante de SyncOff para DC}
    F:Text; {Representa o arquivo de configuraá∆o}
    Io:Integer; {Resultado da £ltima operaá∆o de I/O}

Procedure AutoDetect;
{Realiza a detecá∆o da porta na qual a Interface est† conectada}

Var PP:Integer; {Utilizada para apagar linhas da tela}
    Tec:Char; {Armazena o caracter lido do teclado}
    EndOk:Boolean; {Indica endereáo correto}
    EndLst:Text; {Representa a lista de endereáos para detecá∆o}
    EndStr:String; {Endereáo em formato String}

Procedure ErroArq;
{Mensagem de Erro: Falta PEPLEG.DAT}

Begin
        ClrScr;
        TextColor (Blue);
        Writeln ('Config do Analisador L¢gico - Mensagem de Erro');
        Writeln;
        TextColor (LightRed);
        Writeln ('N∆o existe o arquivo "PEPLEG.DAT"');
        Writeln ('neste diret¢rio!');
        Writeln;
        Writeln ('Verifique qual o diret¢rio corrente!');
        Writeln ('Ap¢s isso, execute novamente este programa.');
        TextColor (LightGray);
        Writeln;
        Writeln ('Caso n∆o consiga solucionar este problema,');
        Writeln ('entre em contato com:');
        Writeln;
        Textcolor (White);
        Writeln ('"Os PEP Legais" - LAO - 4oR Eletrìnica');
        Textcolor (LightGray);
        Writeln;
        Halt(2);
End;

Begin
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PP:=2 To 60 Do Begin
         Gotoxy (PP,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (8,'Conecte a Interface na porta a ser');
     CenterTxt (9,'utilizada e acione sua alimentaá∆o.');
     CenterTxt (11,'Desconecte agora todos os perifÇricos');
     CenterTxt (12,'normalmente conectados nas Portas LPT');
     CenterTxt (13,'(Como Impressoras, ZipDrive ou outros).');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter quando estiver pronto');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      Tec:=Readkey;
Until Tec=#13;

     Assign (EndLst,'PEPLEG.DAT');
{$I-}
     Reset (EndLst);
{$I+}
     If IoResult<>0 Then ErroArq;

     Ender:=$378;
     EndOk:=False;

Repeat
     Readln(EndLst,EndStr);
     Port[Hex2Dec(EndStr)]:=$22; {0010 0010 - Reset/RD/ClrSync}
     Delay (600);

     Port[Hex2Dec(EndStr)]:=$22; {0010 0010 - Reset/RD/ClrSync}
     If (Port[Hex2Dec(EndStr)] And $20) Shr 5 = 0 Then Begin
        Ender:=Hex2Dec(EndStr); EndOk:=True;
     End;
     Port[Hex2Dec(EndStr)]:=$00; {Desliga a Porta Paralela}
Until (Eof(EndLst)) Or (EndOk);

     Close(EndLst);
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PP:=2 To 60 Do Begin
         Gotoxy (PP,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     If EndOk Then CenterTxt (10,'Interface encontrada em '+
                                  DecToHex(Ender,True)+'H')
     Else  Begin
           CenterTxt (9,'A Interface n∆o foi encontrada!');
           CenterTxt (11,'Utilizando o endereáo Default: 378H');
     End;
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter para continuar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      Tec:=Readkey;
Until Tec=#13;
End;

Procedure Espec;
{O Usu†rio deve especificar o endereáo da porta}

Var PQ:Integer; {Utilizada para apagar linhas da tela}
    EndHex:String; {Endereáo em Hexadecimal}

Function UpStr(StrIn:String):String;
{Converte String [a..f] em mai£sculas}

Var Copint:Integer; {Varia de 1 atÇ o n£mero de caracteres de StrIn}
    US:String; {Resultado de UpString}

Begin
     US:='';
     For Copint:=1 To Length(StrIn) Do Begin
         If Copy(StrIn,Copint,1)='a' Then US:=US+'A'
         Else If Copy(StrIn,Copint,1)='b' Then US:=US+'B'
         Else If Copy(StrIn,Copint,1)='c' Then US:=US+'C'
         Else If Copy(StrIn,Copint,1)='d' Then US:=US+'D'
         Else If Copy(StrIn,Copint,1)='e' Then US:=US+'E'
         Else If Copy(StrIn,Copint,1)='f' Then US:=US+'F'
         Else US:=US+Copy(StrIn,Copint,1);
     End;
     UpStr:=US;
End;

Begin
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PQ:=2 To 60 Do Begin
         Gotoxy (PQ,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (9,'Digite o endereáo da porta a ser utilizada');
     CenterTxt (10,'com a Interface do Analisador L¢gico:');
     CenterTxt (11,'(Em Hexadecimal)');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Endereáos V†lidos: 200H a 3FFH');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     TextColor (Yellow);
     TextBackGround (Cyan);
Repeat
     CenterTxt (13,'                                              ');
     CenterTxt (13,'');
     Readln (EndHex);
     Ender:=Hex2Dec(UpStr(EndHex));
Until (Ender>=$200) And (Ender<=$3FF);
End;

Begin
     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (9,'Deseja que o Config detecte automaticamente');
     CenterTxt (10,'a porta na qual a Interface est†');
     CenterTxt (11,'conectada?');
     TextColor (Yellow);
     CenterTxt (13,'(S)im ou (N)∆o');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Escolha a opá∆o: S ou N');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      Tecla:=Readkey;
      Tecla:=Upcase(Tecla);
      If Tecla='S' Then AutoDetect
      Else If Tecla='N' Then Espec;
Until (Tecla='S') Or (Tecla='N');

     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PosStat:=2 To 60 Do Begin
         Gotoxy (PosStat,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (8,'Deseja desabilitar a Detecá∆o da Interface?');
     TextColor (Yellow);
     CenterTxt (10,'(S)im ou (N)∆o');
     Textcolor (White);
     CenterTxt (12,'(Esta opá∆o s¢ Ç recomendada para realizaá∆o');
     CenterTxt (13,'de diagn¢sticos na Interface,');
     CenterTxt (14,'por usu†rios avanáados)');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Escolha a opá∆o: S ou N');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     VerifIntFace:=1;
Repeat
      Tecla:=Readkey;
      Tecla:=Upcase(Tecla);
Until (Tecla='S') Or (Tecla='N');
     If Tecla='S' Then VerifIntFace:=0;

     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PosStat:=2 To 60 Do Begin
         Gotoxy (PosStat,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (7,'Deseja desabilitar o desligamento');
     CenterTxt (8,'do Sincronismo para CC?');
     TextColor (Yellow);
     CenterTxt (10,'(S)im ou (N)∆o');
     Textcolor (White);
     CenterTxt (12,'(Esta opá∆o s¢ Ç recomendada para realizaá∆o');
     CenterTxt (13,'de diagn¢sticos na Interface,');
     CenterTxt (14,'por usu†rios avanáados)');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Escolha a opá∆o: S ou N');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     VerifDC:=1;
Repeat
      Tecla:=Readkey;
      Tecla:=Upcase(Tecla);
Until (Tecla='S') Or (Tecla='N');
     If Tecla='S' Then VerifDC:=0;

     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PosStat:=2 To 60 Do Begin
         Gotoxy (PosStat,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (60,10,White,Cyan);
     CenterWin (60,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (8,'As configuraá‰es foram completadas com sucesso!');
     CenterTxt (10,'Pressione Esc para sair sem salvar as alteraá‰es');
     CenterTxt (11,'ou Pressione Enter para sair e salvar as alteraá‰es');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Escolha a opá∆o: Esc ou Enter');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      Tecla:=Readkey;
Until (Tecla=#13) Or (Tecla=#27);
     If Tecla=#27 Then Fim;
     Assign (F,'ALogic.Cfg');

Repeat
{$I-}
     Rewrite (F);
{$I+}
     Io:=IoResult;
     If Io<>0 Then Begin
        Window(1,1,80,25);
        TextColor (Yellow);
        TextBackGround(Cyan);
        CenterTxt (13,'Disco est† protegido contra gravaá∆o!');
        CenterTxt (14,'Retire a proteá∆o e pressione Enter');
        CenterTxt (15,'ou pressione Esc para Cancelar');
        Window (1,25,1,25);
        TextBackground(Black);
        TextColor(Black);
        Clrscr;

Repeat
      Tecla:=Readkey;
Until (Tecla=#13) Or (Tecla=#27);
     End;
Until (Io=0) Or (Tecla=#27);
     If Tecla<>#27 Then Begin
        Writeln (F,Ender,' ',VerifIntFace,' ',VerifDC);
        Close (F);
     End;
     Fim;
End;

{****************************************************************************}

Procedure VerifArq;
{Verifica a existància de ALogic.Cfg}

Var G:File Of Char; {Representa o arquivo ALOGIC.CFG}

Procedure MensErro;
{Mensagem de Erro: N∆o existe ALOGIC.CFG}

Begin
        ClrScr;
        TextColor (Blue);
        Writeln ('Config do Analisador L¢gico - Mensagem de Erro');
        Writeln;
        TextColor (LightRed);
        Writeln ('N∆o existe o arquivo "ALOGIC.CFG"');
        Writeln ('neste diret¢rio!');
        Writeln;
        Writeln ('Verifique qual o diret¢rio corrente!');
        Writeln ('Ap¢s isso, execute novamente este programa.');
        TextColor (LightGray);
        Writeln;
        Writeln ('Caso n∆o consiga solucionar este problema,');
        Writeln ('entre em contato com:');
        Writeln;
        Textcolor (White);
        Writeln ('"Os PEP Legais" - LAO - 4oR Eletrìnica');
        Textcolor (LightGray);
        Writeln;
        Halt(2);
End;

Begin
     Assign (G,'ALogic.Cfg');
{$I-}
     Reset (G);
{$I+}
     If IoResult <> 0 Then MensErro;
     Close (G);
End;

{****************************************************************************}

Begin
     VerifArq;
     Tela('Analisador L¢gico');
     Win1;
     Win2;
End.

{****************************************************************************}
{
        * Formato do arquivo ALOGIC.CFG *

Record 0 = Endereáo Base da Porta Paralela (em decimal)
Record 1:
         0 se a Detecá∆o Autom†tica estiver desabilitada
         1 se a Detecá∆o Autom†tica estiver habilitada
Record 2:
         0 se o Desligamento do Sincronismo para CC estiver desabilitado
         1 se o Desligamento do Sincronismo para CC estiver habilitado

}
{****************************************************************************}
