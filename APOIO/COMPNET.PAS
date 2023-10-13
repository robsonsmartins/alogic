Uses Crt;

Var F1,F2,F3:Text;
    NetName1,NetName2,Dado1,Dado2,Dado3,F1N,F2N,F3N:String;

Label Fim;

Begin

     Writeln ('Digite o Nome do 1o Arquivo .NET:');
     Readln (F1N);
     Writeln ('Digite o Nome do 2o Arquivo .NET:');
     Readln (F2N);
     Writeln ('Digite o Nome Arquivo de sa°da:');
     Readln (F3N);
     Assign (F1,F1N+'.Net');
     Assign (F2,F2N+'.Net');
     Assign (F3,F3N);
     Rewrite(F3);
     Reset (F1);
     Reset (F2);
     clrscr;
{Le o NetName do 1o Arquivo}
Repeat
Repeat                           {Acha '('}
      Readln(F1,Dado1);
Until (Dado1='(') Or (Eof(F1));
      If EoF(F1) Then Goto Fim;
       Readln (F1,NetName1);
       Dado3:='**************************************************************';
       Writeln (F3,Dado3);
       Dado3:='';
       Writeln (F3,Dado3);
       Dado3:=F1N+'.NET: '+NetName1;
       Writeln (F3,Dado3);      {Grava NomeArq1 e NetName1}
       Dado3:='';
       Writeln (F3,Dado3);
       Gotoxy (2,2); WriteLn ('Net do arquivo ',F1N,'.NET: ',Netname1,'     ');
{Le o Dado do 1o Arquivo}
Repeat
       Readln (F1,Dado1);
{Le o NetName do 2o Arquivo}
Repeat
Repeat
      Readln (F2,Dado2);
      If Eof(F2) Then Reset(F2);
Until (Dado2='(') Or (Eof(F2));
      Readln (F2,NetName2);
{Procura o Dado no 2o Arquivo}
Repeat
      Readln (F2,Dado2);
Until (Dado2=Dado1) Or (Dado2=')') Or (Eof(F2));
Until Dado2<>')';
       If Eof(F2) Then Reset(F2);
       If Dado1=')' Then Begin
          Dado3:='N∆o encontrado Net correspondente em '+F2N+'.NET!';
          Writeln (F3,Dado3);
          Dado3:='';
          Writeln (F3,Dado3);
       End;
Until (Dado2=Dado1) Or (Eof(F1));
      If Eof(F1) Then Goto Fim;
      Dado3:=F2N+'.NET: '+NetName2;
      Writeln (F3,Dado3);
      Dado3:='';
      Writeln (F3,Dado3);
      Reset(F1);
      Reset(F2);
      Gotoxy (2,4); WriteLn ('Net do arquivo ',F2N,'.NET: ',Netname2,'     ');
Repeat
      Readln(F1,Dado1);
Until Dado1=NetName1;

Repeat
Repeat
      Readln(F2,Dado2);
Until Dado2=NetName2;
      Readln(F1,Dado1); {AtÇ ')' f1 ou Eof}
      Gotoxy (2,8); WriteLn ('Conex∆o: ',Dado1,'   ');
      If Dado1=')' Then Break;
Repeat
      Readln(F2,Dado2);
      Gotoxy (2,10); WriteLn ('Conex∆o: ',Dado2,'  ');
Until (Dado2=Dado1) Or (Dado2=')');
      If Dado2=')' Then Begin
         Dado3:='N∆o Encontrado no arquivo '+F2N+'.NET:  '+Dado1;
         Writeln (F3,Dado3);
      End
      Else If Dado2=Dado1 Then Begin
           Writeln (F3,Dado1);
      End;
      Reset(F2);
Until Dado1=')';
Until Eof(F1);
Fim:
      Close(F1);
      Close(F2);
      Close(F3);
      Writeln;
      Writeln;
End.
