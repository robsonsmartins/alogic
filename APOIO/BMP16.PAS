Program BMP16;

{Este Programa abre um BMP16 e exibe em 640X350}
{Uso de CorCorrect e Funá∆o da BIOS para PutPixel}

{
        Formato BMP:
Byte 18 e 19: Largura em Pixels    Ex: Byte19 Byte18
Byte 22 e 23: Altura em Pixels           00    01     = 01H Pixel
Byte 54 a 56 - B,G,R da Cor 0
Byte 58 a 60 - B,G,R da Cor 1
Byte 62 a 64 - B,G,R da Cor 2
Byte 66 a 68 - B,G,R da Cor 3
Byte 70 a 72 - B,G,R da Cor 4
Byte 74 a 76 - B,G,R da Cor 5
Byte 78 a 80 - B,G,R da Cor 6
Byte 82 a 84 - B,G,R da Cor 7
Byte 86 a 88 - B,G,R da Cor 8
Byte 90 a 92 - B,G,R da Cor 9
Byte 94 a 96 - B,G,R da Cor 10
Byte 98 a 100 - B,G,R da Cor 11
Byte 102 a 104 - B,G,R da Cor 12
Byte 106 a 108 - B,G,R da Cor 13
Byte 110 a 112 - B,G,R da Cor 14
Byte 114 a 116 - B,G,R da Cor 15
Byte 118 - Inicio do BMP (Cada 1/2 Byte Ç a cor de um Pixel)
}

Uses Crt,Graph;

Var F:File of Char;
    Chs:Char;
    NameFil:String;
    ContToFor:Integer;
    Xz,Yz:Word;
    Gd,Gm:Integer;

Function DecToHex(Bw:Byte):String;

{Entrada: Word = Decimal de 0 a 255}
{Sa°da: String = Hexadecimal de 00 a FF}

Const
     HexChars:Array[0..15] Of Char = '0123456789ABCDEF';

Begin
     DecToHex:=HexChars[(Bw And $F0)Shr 1]+HexChars[Bw And $F];
End;

Function HexToDec(S:String):Word;

{Entrada: String = Hexadecimal de 0000 a FFFF}
{Saida: Word = Decimal de 0 a 65535}

Var ContHex:Word;

Function Hex(W:Word):String;

Const
     HexChars:Array[0..15] Of Char = '0123456789ABCDEF';

Begin
     Hex:=HexChars[(Hi(W)) Shr 4]+HexChars[(Hi(W)) And $F]+HexChars[(Lo(W)) Shr 4]+
          HexChars[(Lo(W)) And $F];
End;

Begin
     For ContHex:=0 To $FFFF Do If Hex(ContHex)=S Then Break;
     HexToDec:=ContHex;
End;

Procedure Pixel (XValC:Word;YValC:Word;CorPix:Byte;VPageAt:Byte);

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

Function CorCorrect(NibbleID:Byte;ByteCor:Byte):Byte;

Var CorOrig:Byte;

Begin
     If NibbleID=1 Then CorOrig:=(ByteCor And $F0) Shr 4
     Else CorOrig:=ByteCor And $F;

     If CorOrig=7 Then CorCorrect:=8
     Else If CorOrig=8 Then CorCorrect:=7
     Else If CorOrig=12 Then CorCorrect:=9
     Else If CorOrig=9 Then CorCorrect:=12
     Else If CorOrig=4 Then CorCorrect:=1
     Else If CorOrig=1 Then CorCorrect:=4
     Else If CorOrig=14 Then CorCorrect:=11
     Else If CorOrig=11 Then CorCorrect:=14
     Else If CorOrig=3 Then CorCorrect:=6
     Else If CorOrig=6 Then CorCorrect:=3
     Else CorCorrect:=CorOrig;
End;

Begin
     Clrscr;
     Writeln ('Digite o nome do BMP sem extens∆o:');
     Readln (NameFil);
     Assign (F,NameFil+'.BMP');
     Reset (F);

     Gd := Detect;
     InitGraph(Gd, Gm, 'C:\TP\BGI');
     If GraphResult <> grOk then Halt(1);
     SetGraphMode(1);

     For ContToFor:=0 To 117 Do Read (F,Chs);

     SetActivePage(1);
     SetVisualPage(0);

     Xz:=0; Yz:=349;  {640X350}
     SetFillStyle (1,0);
     Bar (0,0,639,349);
     Repeat
           Read (F,Chs);
           If (Ord(Chs) And $F0) Shr 4 <> 0 Then    {Cor a excluir = 3}
              Pixel (Xz,Yz,CorCorrect(1,Ord(Chs)),1);
           If Xz<639 Then Xz:=Xz+1
           Else Begin
                Xz:=0;
                Yz:=Yz-1;
           End;
           If (Ord(Chs) And $F) <> 0 Then   {Cor a excluir = 3}
              Pixel (Xz,Yz,CorCorrect(0,Ord(Chs)),1);
           If Xz<639 Then Xz:=Xz+1
           Else Begin
                Xz:=0;
                Yz:=Yz-1;
           End;
     Until (Eof(F)) Or ((Yz=0) And (Xz=0));

     SetVisualPage(1);
     SetActivePage(0);
     Readln;
End.