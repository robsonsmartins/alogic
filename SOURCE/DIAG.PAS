{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compila��o}

{****************************************************************************}

Program Diagnostico;

{****************************************************************************}
{

  Verifica a presen�a da Interface nos endere�os especificados em PEPLEG.DAT

                 "Os PEP Legais" - LAO - 4oR -Eletr�nica


}
{****************************************************************************}

{       Cr�ditos:
                  Luiz Eduardo    - N�19
                  Marcos Paulo    - N�23
                  Rafael Abolafio - N�26
                  Robson Martins  - N�30

                  4�R - Eletr�nica - 1997

              Liceu de Artes e Of�cios de S�o Paulo

              Prof: Marco Ant�nio Togniazzolo
}
{****************************************************************************}

Uses Crt,PEPUnit;
{Units a serem utilizadas}

{****************************************************************************}

Var Porta:Word; {Endere�o da porta LPT}
    Dat:Text; {Arquivo DAT}
    Ender:String; {Endere�o em Hexadecimal (String)}

{Declara��o das vari�veis globais}

{****************************************************************************}

Function LeProx:Word;
{L� o pr�ximo endere�o contido em PEPLEG.DAT}

Var DadStr:String; {Endere�o lido do arquivo PEPLEG.DAT}

Begin
     If Not Eof(Dat) Then Begin
        Readln (Dat,DadStr);
        LeProx:=HexToDec('0'+DadStr);
        Ender:=DadStr;
     End
     Else LeProx:=$378;
End;

{****************************************************************************}

Function Testa(P:Word):Boolean;
{Testa se a Interface est� presente na Porta P}

Var Ts:Boolean; {True se a Interface est� presente}

Begin
     Ts:=False;
     Port[P]:=$22; {0010 0010 - Reset/RD/ClrSync}
     Delay (600);

     Port[P]:=$22; {0010 0010 - Reset/RD/ClrSync}
     If (Port[P] And $20) Shr 5 = 0 Then Ts:=True;
     Testa:=Ts;
     Port[P]:=$00; {Desliga a Porta Paralela}
End;

{****************************************************************************}

Procedure Fim;
{Finaliza o Programa}

Begin
     Writeln ('A Interface est� conectada corretamente!');
     Writeln ('Encontrada no endere�o: ',Ender,' H');
     Writeln;
     Close (Dat);
     Halt(0);
End;

{****************************************************************************}

Procedure MensErro;
{Indica Erro se n�o existir PEPLEG.DAT}

Begin
     Writeln;
     Writeln ('Arquivo PEPLEG.DAT n�o encontrado!');
     Writeln;
     Writeln ('Verifique se o arquivo existe no diret�rio corrente.');
     Writeln ('Caso n�o consiga solucionar o problema, entre em contato com:');
     Writeln;
     Writeln ('"OS PEP LEGAIS" 4o R - Eletr�nica - LAO - 1997');
     Writeln;
     Halt(2);
End;

{****************************************************************************}

Begin
     Assign (Dat,'PEPLEG.DAT');
{$I-}
     Reset (Dat);
{$I+}
     If IoResult<>0 Then MensErro;
     Writeln;
     Writeln ('"OS PEP LEGAIS"');
     Writeln;
     Writeln ('Certifique-se de que a Interface est� conectada e alimentada!');
     Writeln;
     Writeln ('Pressione Enter quando estiver pronto...');
Repeat
Until Readkey=#13;
     Writeln;
     Writeln ('Verificando a Interface...');
     Writeln;
Repeat
     If Testa(LeProx) Then Fim;
Until Eof(Dat);
     Writeln ('A Interface n�o foi detectada pelo DIAG!');
     Writeln;
     Writeln ('Verifique as conex�es e a alimenta��o da Interface.');
     Writeln ('Caso n�o consiga solucionar o problema, entre em contato com:');
     Writeln;
     Writeln ('"OS PEP LEGAIS" 4o R - Eletr�nica - LAO - 1997');
     Writeln;
     Close (Dat);
End.

{****************************************************************************}
{
        * Formato do arquivo PEPLEG.DAT *

Linhas = Endere�os utilizados pela detec��o da Interface (em Hexadecimal)

}
{****************************************************************************}
