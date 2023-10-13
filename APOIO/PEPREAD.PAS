Program ViewPEP16;

{Este programa visualiza um arquivo .PEP}

Uses Crt,Graph;

Var F:File;
    Chs:Char;
    NameFil:String;
    ContToFor,ForMax:Longint;
    M1:Longint;
    M2:Word;
    M3:Byte;
    Xz,Yz:Word;
    Gd,Gm:Integer;
    PorCento:String;
    ByteAtual:Longint;
    NumRead:Word;
    Buf:Array [1..60000] Of Char;
    IndBuf:Word;

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

Begin
     Clrscr;
     Writeln ('Digite o nome do PEP sem extens∆o:');
     Readln (NameFil);
     Assign (F,NameFil+'.PEP');
     Reset (F,1);

     Gd := Detect;
     InitGraph(Gd, Gm, 'C:\TP\BGI');
     If GraphResult <> grOk then Halt(1);
     SetGraphMode(1);

     SetActivePage(1);
     Xz:=0; Yz:=349;  {640X350}
     SetFillStyle (1,0);
     Bar (0,0,639,349);
     ByteAtual:=0;

Repeat
     BlockRead(F, Buf, SizeOf(Buf), NumRead);
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
         If Ord(Chs) <> 0 Then    {Cor a excluir = 3}
            Pixel (Xz,Yz,Ord(Chs),1);
         If Xz<639 Then Xz:=Xz+1
         Else Begin
              Xz:=0;
              Yz:=Yz-1;
         End;
     End;
     IndBuf:=IndBuf+4;
Until IndBuf=60001;
Until Eof(F);
     SetVisualPage (1);
     Readln;
End.