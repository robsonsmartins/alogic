{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compila‡Æo}

{****************************************************************************}

Unit PEPUnit;

{****************************************************************************}
{
        Analisador L¢gico - "Os PEP Legais"

        Cr‚ditos:
                  Luiz Eduardo    - Nø19
                  Marcos Paulo    - Nø23
                  Rafael Abolafio - Nø26
                  Robson Martins  - Nø30

                  4øR - Eletr“nica - 1997

              Liceu de Artes e Of¡cios de SÆo Paulo

              Prof: Marco Ant“nio Togniazzolo
}
{****************************************************************************}

{Unit com as Fun‡äes e Rotinas mais utilizadas pelo PEPSoftware}

{****************************************************************************}

Interface
{Declara‡Æo das Rotinas e Fun‡äes desta Unit}

{Rotinas para Interface com Usu rio - Modo Texto}

Procedure CenterTxt (YCoord:Integer;TextoStr:String);
Procedure RightTxt (YCoord:Integer;TextoStr:String);
Procedure ApagaWin;
Procedure CenterWin (XSize:Integer;YSize:Integer;TxtCol:Integer;BkCol:Integer);
Procedure AmpliaWin (XSizemax:Integer;YSizemax:Integer;FC:Integer;BC:Integer);
Procedure Tela (Titulo:String);

{Rotinas e Fun‡äes para Modo Gr fico (640 X 350 X 16)}

Procedure ModoGrafico;
Function ViewPEP (NameFil:String;PagAt:Byte;CorExclu:Byte;HabilTecla:Boolean):
                 Char;

{Fun‡äes Matem ticas}

Function Eleva (Base:Integer;Expoente:Integer):Integer;
Function DecToHex(W:Word;DefW:Boolean):String;
Function HexToDec(HS:String):Word;

{****************************************************************************}

Implementation
{Implementa‡Æo das Fun‡äes e Rotinas}

Uses Crt, Dos, Graph;
{Units a serem utilizadas}

{****************************************************************************}

Procedure CenterTxt (YCoord:Integer;TextoStr:String);
{Centraliza uma String em uma linha determinada
  YCoord = Linha
  TextoStr = Texto a ser centralizado}

Begin
     Window (1,1,80,25);
     Gotoxy(Round((80-Length(TextoStr))/2),YCoord);
     Write (TextoStr);
End;

{****************************************************************************}

Procedure RightTxt (YCoord:Integer;TextoStr:String);
{Alinha a direita uma String em uma linha determinada
  YCoord = Linha
  TextoStr = Texto a ser centralizado}

Begin
     Window (1,1,80,25);
     Gotoxy(80-Length(TextoStr),YCoord);
     Write (TextoStr);
End;

{****************************************************************************}

Procedure ApagaWin;
{Apaga a janela}

Var XPos,YPos:Integer; {Posi‡Æo atual do cursor (X e Y)}

Begin
     Window (1,2,80,25);
     TextColor(LightGray);
     TextBackGround(Black);
     For YPos:=1 To 22 Do Begin
         For XPos:=1 To 80 Do Begin
             Gotoxy (XPos,YPos);
             Write (#176);
         End;
     End;
End;

{****************************************************************************}

Procedure CenterWin (XSize:Integer;YSize:Integer;TxtCol:Integer;BkCol:Integer);
{Produz uma Janela no centro da tela
  XSize,YSize = Dimensäes da janela
  TxtCol = Cor do texto
  BkCol = Cor do fundo}

Var X1,X2,Y1,Y2:Integer; {Coordenadas da janela}
    XP,YP:Integer; {Utilizadas pelo contador para movimentar o cursor}

Begin
     X1:=Round((80-XSize)/2);
     X2:=Round((80-XSize)/2+XSize);
     Y1:=Round((23-YSize)/2);
     Y2:=Round((23-YSize)/2+YSize);

     Window (1,1,80,25);
     Window (X1,Y1,X2,Y2);
     TextColor (TxtCol);
     TextBackground (BkCol);
     Clrscr;

     Window (1,1,80,25);
     GotoXy (X1+1,Y1); Write (#201);
     Gotoxy (X2-1,Y1); Write (#187);
     Gotoxy (X1+1,Y2); Write (#200);
     Gotoxy (X2-1,Y2); Write (#188);

     For XP:=X1+2 To X2-2 Do Begin
         Gotoxy (XP,Y1); Write (#205);
         Gotoxy (XP,Y2); Write (#205);
     End;

     For YP:=Y1+1 To Y2-1 Do Begin
         Gotoxy (X1+1,YP); Write (#186);
         Gotoxy (X2-1,YP); Write (#186);
     End;

     TextColor (Black);
     TextBackGround (Black);
     For XP:=X1+2 To X2+1 Do Begin
         Gotoxy (XP,Y2+1); Write (#223);
     End;

     For YP:=Y1+1 To Y2 Do Begin
         Gotoxy (X2+1,YP); Write (#219);
         Gotoxy (X2+2,YP); Write (#219);
     End;

     Gotoxy (X2+2,Y2+1); Write (#220);
End;

{****************************************************************************}

Procedure AmpliaWin (XSizemax:Integer;YSizemax:Integer;FC:Integer;BC:Integer);
{Produz o efeito de amplia‡Æo da janela
  XSizemax,YSizemax = Tamanho m ximo da janela
  FC = Cor do texto
  BC = Cor do fundo}

Var XSz,YSz:Integer; {Utilizadas para variar o tamanho da jenela}
    SzMax:Real; {Rela‡Æo de aspecto m xima}

Begin
     SzMax:=YSizemax/XSizemax;
     For XSz:=3 To XSizeMax Do Begin
         YSz:=Round(SzMax*XSz);
         CenterWin (XSz,YSz,FC,BC);
         Delay (1);
     End;
End;

{****************************************************************************}

Procedure Tela (Titulo:String);
{Tela Principal - Modo Texto
  Titulo: Texto a ser exibido na barra de t¡tulo}

Const Dias : Array [0..6] Of String[9] =
  ('Domingo','Segunda','Ter‡a',
   'Quarta','Quinta','Sexta',
   'S bado');                      {Dias da semana}

Var Ano,Mes,Dia,Diasem:Word;    {Vari veis que armazenam a data atual}
    AnoStr,MesStr,DiaStr:String; {Aramazenam ano, mˆs e dia como strings}

Begin
     {Fundo}
     ApagaWin;

     {T¡tulo}
     Window (1,1,80,1);
     TextColor(White);
     TextBackGround (Blue);
     Clrscr;
     CenterTxt (1,Titulo);

     {Linha de Status}
     Window (1,24,80,24);
     Textcolor (Black);
     TextBackGround (White);
     Clrscr;

     {Data Atual}
     TextColor (Red);
     GetDate (Ano,Mes,Dia,DiaSem);
     Window (1,1,80,25);
     Str (Ano:4,AnoStr);
     Str (Mes:2,MesStr);
     Str (Dia:2,DiaStr);
     RightTxt (24,Dias[DiaSem]+', '+DiaStr+'/'+MesStr+'/'+AnoStr);

     {Janela Central}
     Delay (500);
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
End;

{****************************************************************************}

Procedure ModoGrafico;
{Inicia o modo Gr fico}

Var Gd,Gm:Integer;  {GraphicDriver e GraphicMode: usadas pelo InitGraph}

Procedure MensErro;
{Mensagem de Erro: NÆo foi poss¡vel iniciar Modo Gr fico}

Begin
        ClrScr;
        TextColor (Blue);
        Writeln ('Analisador L¢gico - Mensagem de Erro');
        Writeln;
        TextColor (LightRed);
        Writeln ('Houve um erro na inicializa‡Æo do modo Gr fico!');
        Writeln ('Verifique se os drivers gr ficos estÆo presentes');
        Writeln ('no mesmo diret¢rio do PEPSoftware!');
        TextColor (LightGray);
        Writeln;
        Writeln ('Caso nÆo consiga solucionar este problema,');
        Writeln ('entre em contato com:');
        Writeln;
        Textcolor (White);
        Writeln ('"Os PEP Legais" - LAO - 4oR Eletr“nica');
        Textcolor (LightGray);
        Writeln;
        Halt(2);
End;

Begin
     Gd:=Detect;
     InitGraph(Gd, Gm, '');
     If GraphResult <> GrOk Then MensErro;
     SetGraphMode (1); {640 X 350}
End;

{****************************************************************************}

Function ViewPEP(NameFil:String;PagAt:Byte;CorExclu:Byte;HabilTecla:Boolean):
                 Char;
{Visualiza um .PEP especificado (NameFil) na P g. de V¡deo especificada
(PageAt), excluindo uma cor determinada (CorExclu)
HabilTecla = Habilita verifica‡Æo de pressionamento de tecla durante a carga
             do .PEP
Retorna o valor da Tecla pressionada (Char)}

Var FPep:File; {Representa o arquivo .PEP a ser lido}
    Chs:Char; {Armazena o caracter lido do arquivo}
    ContToFor,ForMax:Longint; {Utilizadas pelo contador que movimenta o cursor}
    M1:Longint; { Armazenam                        }
    M2:Word;    { o n£mero de pixels para cada cor }
    M3:Byte;    { lido do arquivo .PEP             }
    Xz,Yz:Word; {Armazenam a posi‡Æo do cursor na tela}
    TecPep:Char; {Armazena o caracter da tecla lida durante a carga do .PEP}
    Buf:Array [1..40] Of Char; {Buffer de leitura do arquivo}
    IndBuf:Word; {Index do Buffer}
    NumRead:Word; {Retorna o n£mero de bytes lidos do arquivo}

Procedure Pixel (XValC:Word;YValC:Word;CorPix:Byte;VPageAt:Byte);
{Produz um Pixel na tela
  XValC,YValC = coordenadas
  CorPix = cor do pixel
  VPageAt = p gina de v¡deo}

Begin
     Asm
        Mov AH, 0CH
        Mov Al,(CorPix)
        Mov CX,(XValC)
        Mov DX,(YValC)
        Mov BH,(VPageAt)
        Int 10H
     End;
End;

Begin
     Assign (FPep,NameFil);
     Reset (FPep,1);

     Xz:=0; Yz:=349;  {640X350}
     TecPep:=#0;
     SetActivePage(PagAt);
     SetFillStyle (1,CorExclu);
     Bar (0,0,639,349);

Repeat
     BlockRead(FPep, Buf, SizeOf(Buf), NumRead);
     IndBuf:=1;
Repeat
     Chs:=Buf[IndBuf];
     M1:=Ord(Chs)*$10000;
     Chs:=Buf[IndBuf+1];
     M2:=Ord(Chs)*$100;
     Chs:=Buf[IndBuf+2];
     M3:=Ord(Chs);
     ForMax:=M1 Or M2 Or M3;
     Chs:=Buf[IndBuf+3];
     For ContToFor:=1 To ForMax Do Begin
         If Ord(Chs) <> CorExclu Then
            Pixel (Xz,Yz,Ord(Chs),PagAt);
         If Keypressed Then Begin
            TecPep:=Readkey;
            If ((TecPep=#27) Or (TecPep=#13)) And (HabilTecla) Then Begin
               ViewPEP:=#27;
               Exit;
            End;
         End;
         If Xz<639 Then Xz:=Xz+1
         Else Begin
              Xz:=0;
              Yz:=Yz-1;
         End;
     End;
     IndBuf:=IndBuf+4;
Until (IndBuf=41) Or (Eof(FPep));
Until Eof(FPep);
      ViewPEP:=TecPep;
      Close (FPep);
End;

{****************************************************************************}

Function Eleva (Base:Integer;Expoente:Integer):Integer;
{Eleva uma Base a um Expoente
Retorna o valor de Base elevado a Expoente}

Var Vezes:Integer;  {N£mero de vezes que a base deve ser multiplicada}
    ValorExp:Integer; {Valor da base elevada ao expoente}

Begin
     ValorExp:=1;
     If Expoente=0 Then Eleva:=1
     Else Begin
          For Vezes:=1 To Expoente Do ValorExp:=ValorExp*Base;
          Eleva:=ValorExp;
     End;
End;

{****************************************************************************}

Function DecToHex(W:Word;DefW:Boolean):String;
{Entrada: Word/Byte = Decimal de 0 a 65535}
{Sa¡da: String = Hexadecimal de 0000 a FFFF ou 00 a FF
  DefW = Define se a sa¡da vai a FFFF ou FF
         0 = 00H a FFH
         1 = 0000H a FFFFH }

Const
     HexChars:Array[0..15] Of Char = '0123456789ABCDEF'; {Caracteres Hexa}

Begin
     If DefW Then DecToHex:=HexChars[(Hi(W)) Shr 4]+HexChars[(Hi(W)) And $F]+
               HexChars[(Lo(W)) Shr 4]+HexChars[(Lo(W)) And $F]
     Else DecToHex:=HexChars[(Lo(W)) Shr 4]+HexChars[(Lo(W)) And $F];
End;

{****************************************************************************}

Function HexToDec(HS:String):Word;
{Entrada: Hexadecimal = String de 0000 a FFFF}
{Sa¡da: Decimal = Word de 0 a 65535}

Var WordHex:Word; {Valor que varia at‚ que seu hexadecimal seja igual a HS}

Begin
     For WordHex:=0 To $FFFF Do Begin
         If DecToHex(WordHex,True)=HS Then Break;
     End;
     HexToDec:=WordHex;
End;

{****************************************************************************}

End.