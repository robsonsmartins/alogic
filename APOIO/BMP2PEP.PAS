Program BMP16ToPEP16;

{Este Programa converte um arquivo .BMP para um arquivo .PEP}

Uses Crt,Graph;

Var F:File Of Char;
    G:File Of Char;
    Chs,CorArq,NumCorArq:Char;
    CorAtual,CorID:Byte;
    NumCor:Longint;
    NameFil:String;
    ContToFor:Integer;

Function CorCorrect(CorOrig:Byte):Byte;

Begin
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
     Assign (G,NameFil+'.PEP');
     Rewrite (G);

     For ContToFor:=0 To 118 Do Read (F,Chs);
     CorAtual:=(Ord(Chs) And $F0) Shr 4;
     NumCor:=1;

     Repeat
           CorID:=(Ord(Chs) And $F);
           If CorID=CorAtual Then NumCor:=Numcor+1
           Else Begin
                NumCorArq:=Chr((NumCor And $FF0000) Shr 16);
                Write (G,NumCorArq);
                NumCorArq:=Chr((NumCor And $00FF00) Shr 8);
                Write (G,NumCorArq);
                NumCorArq:=Chr(NumCor And $0000FF);
                Write (G,NumCorArq);
                CorArq:=Chr(CorCorrect(CorAtual));
                Write (G,CorArq);
                CorAtual:=CorID;
                NumCor:=1;
           End;
           If Eof(F) Then Begin
              NumCorArq:=Chr((NumCor And $FF0000) Shr 16);
              Write (G,NumCorArq);
              NumCorArq:=Chr((NumCor And $00FF00) Shr 8);
              Write (G,NumCorArq);
              NumCorArq:=Chr(NumCor And $0000FF);
              Write (G,NumCorArq);
              CorArq:=Chr(CorCorrect(CorAtual));
              Write (G,CorArq);
              Break;
           End;
           Read (F,Chs);
           Gotoxy (10,10);
           Write ((FilePos(F)/FileSize(F))*100:3:0,' % Complete ');
           Write (' - ',FilePos(F),' de ',FileSize(F),' Bytes');
           CorID:=(Ord(Chs) And $F0) Shr 4;
           If CorID=CorAtual Then NumCor:=Numcor+1
           Else Begin
                NumCorArq:=Chr((NumCor And $FF0000) Shr 16);
                Write (G,NumCorArq);
                NumCorArq:=Chr((NumCor And $00FF00) Shr 8);
                Write (G,NumCorArq);
                NumCorArq:=Chr(NumCor And $0000FF);
                Write (G,NumCorArq);
                CorArq:=Chr(CorCorrect(CorAtual));
                Write (G,CorArq);
                CorAtual:=CorID;
                NumCor:=1;
           End;
     Until CorID<>CorAtual;
     Close (F);
     Close (G);
End.