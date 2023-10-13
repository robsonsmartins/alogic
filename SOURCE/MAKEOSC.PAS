{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compila‡Æo}

{****************************************************************************}

Program Faz_Osc;

{****************************************************************************}

{
                  Make OSC - Produz .OSC padrÆo

                       "Os PEP Legais"

                          VersÆo 1.0
}

{****************************************************************************}

{       Cr‚ditos:
                  Luiz Eduardo    - Nø19
                  Marcos Paulo    - Nø23
                  Rafael Abolafio - Nø26
                  Robson Martins  - Nø30

                  4øR - Eletr“nica - 1997

              Liceu de Artes e Of¡cios de SÆo Paulo

              Prof: Marco Ant“nio Togniazzolo
}
{****************************************************************************}
{
        Make OSC:
                             Produz arquivos .OSC, dados:
                             Frequˆncia, Escala e Duty Cycle
                             VersÆo 1.0 - 1997

        Software for MS-DOS, Escrito no compilador Turbo Pascal 7.0

        Requisitos M¡nimos do Sistema:

                   IBM PC XT/AT ou Compat¡vel
                   640KB de RAM ou mais
                   Monitor EGA ou superior
                   Disk Drive de 1,44MB
                   Hard Disk com pelo menos 1MB livres
}
{****************************************************************************}

Uses Crt,Dos,PEPUnit;
{Units a serem utilizadas}

{****************************************************************************}

Var Freq: Real; {Frequˆncia}
    Duty: Integer; {Duty Cycle}
    Escala: Integer; {Escala Horizontal}
    HiT,LoT: Integer; {Tempo dos Estados de Alto e Baixo}
    ForVar: Integer; {Vari vel de contador para loops For}
    CurPont: Integer; {Posi‡Æo corrente da forma-de-onda}
    HiStat, LoStat: Byte; {Estados de Alto e Baixo}
    CanStat: Byte; {Status do Canal}
    Desc: String; {Descri‡Æo do conjunto de formas-de-onda}
    DescCan: String; {Descri‡Æo de cada canal}
    Tecd: Char; {Armazena a Tecla Pressionada}
    TempA,TempB,TempC,TempD,TempE,TempF,TempG,TempH: File Of Byte;
        {Representam os Arquivos tempor rios}

{****************************************************************************}

Procedure FatalError;
{Indica Erro de R/W}

Begin
     Window(1,1,80,25);
     TextBackGround(Black);
     Clrscr;
     TextColor (Blue);
     Writeln ('Make OSC do Analisador L¢gico - Mensagem de Erro');
     Writeln;
     TextColor (LightRed);
     Writeln ('Ocorreu um Erro Fatal de Leitura/Grava‡Æo na unidade corrente');
     Writeln;
     Writeln ('Execute um utilit rio de repara‡Æo de discos.');
     Writeln ('Ap¢s isso, execute novamente este programa.');
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

{****************************************************************************}

Function OrdConv (OrdStr:String): Char;
{Transforma String em Char}

Var OrdInt:Byte; {Varia de 0 a 255 e ‚ convertido em char}

Begin
     For OrdInt:=0 To 255 Do Begin
         If OrdStr=Chr(OrdInt) Then Break;
     End;

     If OrdInt=255 Then OrdInt:=0;
     OrdConv:=UpCase(Chr(OrdInt));
End;

{****************************************************************************}

Procedure Formula;
{C lculo do n£mero de pontos a ser plotados}

Begin
   If CanStat=1 Then Begin
     If Freq<1 Then Begin
        If Duty=100 Then Begin
           HiT:=512;
           LoT:=0;
        End
        Else Begin
             HiT:=0;
             LoT:=512;
        End;
     End
     Else Begin
          HiT:=Round (((1/Freq)*(Duty/100))/((Escala/10)/1000000));
          LoT:=Round (((1/Freq)*((100-Duty)/100))/((Escala/10)/1000000));
     End;
     CurPont:=0;
     If (HiT=0) And (LoT=0) Then Begin
        HiT:=1;
        LoT:=1;
     End;
   End;
End;

{****************************************************************************}

Procedure Corrige(Ca:Char);
{Corrige os arquivos, acrescentando ao fim um byte FFH}

Var ByteCorr:Byte; {Byte de corre‡Æo}

Begin
     ByteCorr:=$FF;
     If Ca='A' Then Write(TempA,ByteCorr)
     Else If Ca='B' Then Write(TempB,ByteCorr)
     Else If Ca='C' Then Write(TempC,ByteCorr)
     Else If Ca='D' Then Write(TempD,ByteCorr)
     Else If Ca='E' Then Write(TempE,ByteCorr)
     Else If Ca='F' Then Write(TempF,ByteCorr)
     Else If Ca='G' Then Write(TempG,ByteCorr)
     Else If Ca='H' Then Write(TempH,ByteCorr);
End;

{****************************************************************************}

Procedure CanalATmp;
{Cria TMP para o canal A}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempA,'CANALA.TMP');
{$I-}
     Rewrite (TempA);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempA, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempA, ByteChar);
     End;

     Write (TempA, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempA,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempA,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempA,ByteChar);
       End;
  End;
     Corrige('A');
     Close (TempA);
End;

{****************************************************************************}

Procedure CanalBTmp;
{Cria TMP para o canal B}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempB,'CANALB.TMP');
{$I-}
     Rewrite (TempB);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempB, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempB, ByteChar);
     End;

     Write (TempB, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempB,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempB,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempB,ByteChar);
       End;
  End;
     Corrige('B');
     Close (TempB);
End;

{****************************************************************************}

Procedure CanalCTmp;
{Cria TMP para o canal C}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempC,'CANALC.TMP');
{$I-}
     Rewrite (TempC);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempC, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempC, ByteChar);
     End;

     Write (TempC, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempC,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempC,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempC,ByteChar);
       End;
  End;
     Corrige('C');
     Close (TempC);
End;

{****************************************************************************}

Procedure CanalDTmp;
{Cria TMP para o canal D}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempD,'CANALD.TMP');
{$I-}
     Rewrite (TempD);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempD, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempD, ByteChar);
     End;

     Write (TempD, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempD,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempD,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempD,ByteChar);
       End;
  End;
     Corrige('D');
     Close (TempD);
End;

{****************************************************************************}

Procedure CanalETmp;
{Cria TMP para o canal E}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempE,'CANALE.TMP');
{$I-}
     Rewrite (TempE);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempE, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempE, ByteChar);
     End;

     Write (TempE, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempE,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempE,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempE,ByteChar);
       End;
  End;
     Corrige('E');
     Close (TempE);
End;

{****************************************************************************}

Procedure CanalFTmp;
{Cria TMP para o canal F}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempF,'CANALF.TMP');
{$I-}
     Rewrite (TempF);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempF, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempF, ByteChar);
     End;

     Write (TempF, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempF,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempF,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempF,ByteChar);
       End;
  End;
     Corrige('F');
     Close (TempF);
End;

{****************************************************************************}

Procedure CanalGTmp;
{Cria TMP para o canal G}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempG,'CANALG.TMP');
{$I-}
     Rewrite (TempG);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempG, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempG, ByteChar);
     End;

     Write (TempG, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempG,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempG,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempG,ByteChar);
       End;
  End;
     Corrige('G');
     Close (TempG);
End;

{****************************************************************************}

Procedure CanalHTmp;
{Cria TMP para o canal H}

Var ByteChar:Byte; {Byte gravado no arquivo TMP}
    ForJK: Integer; {Endere‡a a descri‡Æo}

Begin
     Assign (TempH,'CANALH.TMP');
{$I-}
     Rewrite (TempH);
{$I+}
     If IoResult<>0 Then FatalError;

     If Length(Desc) > 10 Then Desc:=Copy(Desc,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(Desc,ForJK,1)));
         Write (TempH, ByteChar);
     End;

     If Length(DescCan) > 10 Then DescCan:=Copy(DescCan,1,10);

     For ForJK:=1 To 10 Do Begin
         ByteChar:=Ord(OrdConv(Copy(DescCan,ForJK,1)));
         Write (TempH, ByteChar);
     End;

     Write (TempH, CanStat);

  If CanStat=1 Then Begin
Repeat
   If HiT <> 0 Then Begin
     For ForVar:=1 To HiT Do Begin
         Write (TempH,HiStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;

     If CurPont=511 Then Break;

   If LoT <> 0 Then Begin
     For ForVar:=1 To LoT Do Begin
         Write (TempH,LoStat);
         If CurPont=511 Then Break;
         CurPont:=CurPont+1;
     End;
   End;
Until CurPont=511;
  End
  Else Begin
       ByteChar:=0;
       For ForVar:=21 To 532 Do Begin
           Write (TempH,ByteChar);
       End;
  End;
     Corrige('H');
     Close (TempH);
End;

{****************************************************************************}

Procedure ApagaTela;
{Apaga a tela corrente}

Begin
     Window(1,1,80,25);
     TextColor(LightGray);
     TextBackGround(Black);
     Clrscr;
End;

{****************************************************************************}

Procedure Fim;
{Finaliza a execu‡Æo do programa}

Begin
     ApagaTela;
     Writeln;
     Halt(0);
End;

{****************************************************************************}

Procedure Win1;
{Tela Inicial do Programa - Apresenta‡Æo}

Var Tecla:Char; {Caracter lido do teclado}

Begin
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (9,'Programa para produ‡Æo de');
     CenterTxt (10,'Arquivos do Analisador L¢gico (.OSC)');
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

End;

{****************************************************************************}

Procedure Win2;
{Recolhe Descri‡Æo do Conjunto de Formas-de-onda}

Var PP:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'Digite a Descri‡Æo do Conjunto de');
     CenterTxt (10,'Formas de Onda:');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('M ximo de caracteres utilizados: 10');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
     GotoXy (35,12);
     Readln (Desc);
End;

{****************************************************************************}

Procedure Win3(Cn:Char);
{Recolhe o Estado do canal Cn: ON ou OFF}

Var PP:Integer; {Utilizado para apagar linhas da tela}
    Tecla:Char; {Caracter lido do teclado}

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
     CenterTxt (10,'O Canal '+Cn+' estar  ativado (S,N)?');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione S ou N');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

Repeat
      Tecla:=UpCase(Readkey);
Until (Tecla='S') Or (Tecla='N');

     If Tecla='S' Then CanStat:=1
     Else CanStat:=0;
End;

{****************************************************************************}

Procedure Win4(Cn:Char);
{Recolhe a descri‡Æo do canal Cn}

Var PP:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'Digite a Descri‡Æo do Canal '+Cn+':');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('M ximo de caracteres utilizados: 10');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
     GotoXy (35,12);
     Readln (DescCan);
End;

{****************************************************************************}

Procedure Win5(Cn:Char);
{Recolhe a frequˆncia do canal Cn}

Var PP:Integer; {Utilizado para apagar linhas da tela}
    FrStr:String; {Frequˆncia em formato String}
    Code:Integer; {Resultado da conversÆo String => Integer}

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
     CenterTxt (9,'Digite a Frequˆncia em Hz para o Canal '+Cn+':');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Digite um valor Real (de 0 a 10MHz)');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
Repeat
     CenterTxt (12,'                                    ');
     GotoXy (35,12);
     Readln (FrStr);
     Val(FrStr,Freq,Code);
     If (Code<>0) Or (Freq>10e6) Then Begin
        Sound(1000);
        Delay(400);
        Nosound;
     End;
Until (Code=0) And (Freq<=10e6);
End;

{****************************************************************************}

Procedure Win6(Cn:Char);
{Recolhe o Duty Cycle do canal Cn}

Var PP:Integer;  {Utilizado para apagar linhas da tela}
    DCStr:String; {Duty Cycle em formato String}
    Code:Integer; {Resultado da conversÆo String => Integer}

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
     CenterTxt (9,'Digite o Duty Cycle em % para o Canal '+Cn+':');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Digite um valor Inteiro (de 0 a 100%)');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
Repeat
     CenterTxt (12,'                                    ');
     GotoXy (35,12);
     Readln (DCStr);
     Val(DCStr,Duty,Code);
     If (Code<>0) Or (Duty>100) Then Begin
        Sound(1000);
        Delay(400);
        Nosound;
     End;
Until (Code=0) And (Duty<=100);
End;

{****************************************************************************}

Procedure Win7;
{Recolhe a Escala Horizontal}

Var PP:Integer; {Utilizado para apagar linhas da tela}
    Tecla:Char; {Caracter lido do teclado}

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
     CenterTxt (8,'Escolha a Escala Horizontal:');
     CenterTxt (10,'A = 1 uS/div     ');
     CenterTxt (11,'B = 10 uS/div    ');
     CenterTxt (12,'C = 100 uS/div   ');
     CenterTxt (13,'D = 1.000 uS/div ');
     CenterTxt (14,'E = 10.000 uS/div');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione a tecla correspondente');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

Repeat
      Tecla:=UpCase(Readkey);
Until (Tecla='A') Or (Tecla='B') Or (Tecla='C') Or (Tecla='D') Or (Tecla='E');

     If Tecla='A' Then Escala:=1
     Else If Tecla='B' Then Escala:=10
     Else If Tecla='C' Then Escala:=100
     Else If Tecla='D' Then Escala:=1000
     Else If Tecla='E' Then Escala:=10000;
End;

{****************************************************************************}

Procedure Win9;
{Tela Final do Programa}

Var PP:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (8,'Arquivo .OSC gravado com sucesso!');
     CenterTxt (10,'Pressione ESC para sair ou');
     CenterTxt (11,'ENTER para produzir mais um arquivo .OSC');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione ESC ou ENTER');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
End;

{****************************************************************************}

Procedure Recolhe(Can:Char);
{Recolhe os dados de cada canal Can}

Begin
     DescCan:='';
     Freq:=0;
     Duty:=0;
     If Can='A' Then Begin
        Win2;
        Win7;
     End;
     Win3(Can);
     If CanStat=1 Then Begin
        Win4(Can);
        Win5(Can);
        Win6(Can);
     End;
End;

{****************************************************************************}

Procedure FazOsc;
{Grava no formato .OSC}

Var NomeOsc: String; {Nome do arquivo .OSC}
    OscF,A,B,C,D,E,F,G,H:File Of Byte; {Arquivos .OSC e TMPs}
    Dad, DA,DB,DC,DD,DE,DF,DG,DH:Byte; {Dados lidos dos arquivos}
    CoF:Integer; {Cursor do arquivo}

Procedure Win8;
{Recolhe o nome do arquivo a ser gravado}

Var PP:Integer; {Utilizado para apagar linhas da tela}
    Tecla:Char; {Caracter lido do teclado}
    Io:Integer; {Resultado da £ltima opera‡Æo de I/O}

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
     CenterTxt (7,'Digite o Nome do Arquivo .OSC a ser gravado');
     CenterTxt (8,'(Com caminho completo, se necess rio');
     CenterTxt (9,'e sem extensÆo):');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Digite o Nome do Arquivo .OSC');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
Repeat
Repeat
     CenterTxt (13,'                                      ');
     CenterTxt (14,'                                      ');
     CenterTxt (11,'                                      ');
     GotoXy (25,11);
     Readln (NomeOsc);
     Assign (OscF, NomeOsc+'.OSC');
{$I-}
     Reset (OscF);
{$I+}
     Io:=IoResult;
     If Io=0 Then Begin
        CenterTxt (13,'O arquivo especificado j  existe!');
        CenterTxt (14,'Substituir (S,N)?');
Repeat
        Tecla:=Upcase(Readkey);
Until (Tecla='S') Or (Tecla='N');
        If Tecla='S' Then Break;
     End;
Until Io<>0;
{$I-}
     If Io=0 Then Close (OscF);
     Rewrite (OscF);
{$I+}
     Io:=IoResult;
     If Io<>0 Then Begin
        Sound(1000);
        Delay(400);
        Nosound;
     End;
Until Io=0;
End;

Procedure OpenFiles;
{Abre os arquivos TMP}

Begin
     Assign (A,'CANALA.TMP');
{$I-}
     Reset (A);
     If IoResult<>0 Then FatalError;
     Assign (B,'CANALB.TMP');
     Reset (B);
     If IoResult<>0 Then FatalError;
     Assign (C,'CANALC.TMP');
     Reset (C);
     If IoResult<>0 Then FatalError;
     Assign (D,'CANALD.TMP');
     Reset (D);
     If IoResult<>0 Then FatalError;
     Assign (E,'CANALE.TMP');
     Reset (E);
     If IoResult<>0 Then FatalError;
     Assign (F,'CANALF.TMP');
     Reset (F);
     If IoResult<>0 Then FatalError;
     Assign (G,'CANALG.TMP');
     Reset (G);
     If IoResult<>0 Then FatalError;
     Assign (H,'CANALH.TMP');
     Reset (H);
     If IoResult<>0 Then FatalError;
{$I+}
End;

Procedure CloseFiles;
{Fecha os arquivos TMP}

Begin
{$I-}
     Close (A);
     Erase (A);
     If IoResult<>0 Then FatalError;
     Close (B);
     Erase (B);
     If IoResult<>0 Then FatalError;
     Close (C);
     Erase (C);
     If IoResult<>0 Then FatalError;
     Close (D);
     Erase (D);
     If IoResult<>0 Then FatalError;
     Close (E);
     Erase (E);
     If IoResult<>0 Then FatalError;
     Close (F);
     Erase (F);
     If IoResult<>0 Then FatalError;
     Close (G);
     Erase (G);
     If IoResult<>0 Then FatalError;
     Close (H);
     Erase (H);
     If IoResult<>0 Then FatalError;
     Close (OscF);
     If IoResult<>0 Then FatalError;
{$I+}
End;

Begin
     Win8;
     Dad:=Ord('P');
     Write (OscF,Dad);
     Dad:=Ord('E');
     Write (OscF,Dad);
     Dad:=Ord('P');
     Write (OscF,Dad);
     OpenFiles;
     For CoF:=0 To 9 Do Begin
         Read (A, Dad);
         Read (B, Dad);
         Read (C, Dad);
         Read (D, Dad);
         Read (E, Dad);
         Read (F, Dad);
         Read (G, Dad);
         Read (H, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (A, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (B, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (C, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (D, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (E, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (F, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (G, Dad);
         Write (OscF,Dad);
     End;
     For CoF:=10 To 19 Do Begin
         Read (H, Dad);
         Write (OscF,Dad);
     End;
     Read (A, Dad);
     Write (OscF,Dad);
     Read (B, Dad);
     Write (OscF,Dad);
     Read (C, Dad);
     Write (OscF,Dad);
     Read (D, Dad);
     Write (OscF,Dad);
     Read (E, Dad);
     Write (OscF,Dad);
     Read (F, Dad);
     Write (OscF,Dad);
     Read (G, Dad);
     Write (OscF,Dad);
     Read (H, Dad);
     Write (OscF,Dad);

     If Escala=1 Then Dad:=0
     Else If Escala=10 Then Dad:=1
     Else If Escala=100 Then Dad:=2
     Else If Escala=1000 Then Dad:=3
     Else If Escala=10000 Then Dad:=4;

     Write (OscF,Dad);

     For CoF:=21 To 532 Do Begin
         Read (A, DA);
         Read (B, DB);
         Read (C, DC);
         Read (D, DD);
         Read (E, DE);
         Read (F, DF);
         Read (G, DG);
         Read (H, DH);
         Dad:=(DH*128) Or (DG*64) Or (DF*32) Or (DE*16) Or (DD*8) Or (DC*4) Or
              (DB*2) Or DA;
         Write (OscF,Dad);
     End;
     CloseFiles;
End;

{****************************************************************************}

Begin
Repeat
     ApagaTela;
     Tela('Produtor de Arquivos .OSC');
     Win1;
     HiStat:=1;
     LoStat:=0;
     Recolhe ('A');
     Formula;
     CanalATmp;
     Recolhe ('B');
     Formula;
     CanalBTmp;
     Recolhe ('C');
     Formula;
     CanalCTmp;
     Recolhe ('D');
     Formula;
     CanalDTmp;
     Recolhe ('E');
     Formula;
     CanalETmp;
     Recolhe ('F');
     Formula;
     CanalFTmp;
     Recolhe ('G');
     Formula;
     CanalGTmp;
     Recolhe ('H');
     Formula;
     CanalHTmp;
     FazOsc;
     Win9;
Repeat
      Tecd:=Readkey;
Until (Tecd=#27) Or (Tecd=#13);
Until Tecd=#27;
     Fim;
End.

{****************************************************************************}
{
    * Formato dos arquivos TMP: *

Byte 0: Descri‡Æo do Conjunto
Byte 10: Descri‡Æo do Canal
Byte 20: Estado do Canal (0 - OFF ou 1 - ON)
Byte 21 a Byte 532: Dados (Bits)

}
{****************************************************************************}
