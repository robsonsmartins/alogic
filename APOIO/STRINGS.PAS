Uses Crt;

Var F1:File Of Char;
    F2:Text;
    F1N,F2N:String;
    Dado:Char;

Label Fim;

Begin
    Writeln ('Digite o nome do .PAS:');
    Readln (F1N);
    Writeln ('Digite o nome do arquivo de sa¡da .STR');
    Readln (F2N);
    Assign (F1,F1N+'.PAS');
    Assign (F2,F2N+'.STR');
    Reset (F1);
    Rewrite (F2);
Repeat
Repeat
      Read (F1,Dado);
Until (Dado=Chr(39)) Or (EoF(F1));
      If EoF(F1) Then Goto Fim;
      Write (F2,Dado);
Repeat
      Read (F1,Dado);
      Write (F2,Dado);
Until (Dado=Chr(39)) Or (Eof(F1));
      Dado:=' ';
      Writeln (F2,Dado);
      If EoF(F1) Then Goto Fim;
Until Eof(F1);

Fim:
    Close (F1);
    Close (F2);
End.