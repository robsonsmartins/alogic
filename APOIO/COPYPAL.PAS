Uses crt;

Var inp,out:File of Char;
    Ch:Char;
    Cont:Integer;

Begin
Assign (inp,'oscilos.bmp');
Assign (out,'palette.bmp');
Reset(inp);
Rewrite(out);
For cont:=0 To 117 Do Begin
    read(inp,ch);
    Write (out,ch);
End;
End.