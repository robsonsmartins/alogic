Program ViewPEP16;

{Este programa visualiza um arquivo .PEP}

Uses Crt,Graph;

Var F:File of Char;
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
     Reset (F);

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
     Read (F,Chs);
     M1:=Ord(Chs)*$10000;
     Read (F,Chs);
     M2:=Ord(Chs)*$100;
     Read (F,Chs);
     M3:=Ord(Chs);
     ForMax:=M1 Or M2 Or M3;
     Read (F,Chs);

     For ContToFor:=1 To ForMax Do Begin
         If Ord(Chs) <> 0 Then    {Cor a excluir = 3}
            Pixel (Xz,Yz,Ord(Chs),1);
         If Xz<639 Then Xz:=Xz+1
         Else Begin
              Xz:=0;
              Yz:=Yz-1;
         End;
     End;
Until Eof(F);
     SetVisualPage (1);
     Readln;
End.