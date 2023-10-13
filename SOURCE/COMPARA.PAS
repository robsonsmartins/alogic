{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compilaá∆o}

{****************************************************************************}

Program Comparador;

{****************************************************************************}

{
                Comparador de Formas de Onda

                       "Os PEP Legais"

                          Vers∆o 1.0
}

{****************************************************************************}

{       CrÇditos:
                  Luiz Eduardo    - N¯19
                  Marcos Paulo    - N¯23
                  Rafael Abolafio - N¯26
                  Robson Martins  - N¯30

                  4¯R - Eletrìnica - 1997

              Liceu de Artes e Of°cios de S∆o Paulo

              Prof: Marco Antìnio Togniazzolo
}
{****************************************************************************}
{
        Comparador de Formas de Onda:
                             Plota na tela um ou dois conjuntos de 8 formas
                             Realiza Operaá‰es L¢gicas entre formas
                             Exporta imagem para .BMP
                             Vers∆o 1.0 - 1997

        Software for MS-DOS, Escrito no compilador Turbo Pascal 7.0

        Requisitos M°nimos do Sistema:

                   IBM PC XT/AT ou Compat°vel (Recomenda-se 486)
                   640KB de RAM ou mais (Recomenda-se 4MB)
                   Monitor EGA ou superior (Recomenda-se VGA Color)
                   Disk Drive de 1,44MB
                   Hard Disk com pelo menos 1MB livres
}
{****************************************************************************}

Uses Crt,Dos,Graph,PEPUnit;
{Units a serem usadas}

{****************************************************************************}

Var
   Hr,M,S,S100:Word; {Vari†veis para contar Tempo}
   Timea:Real; {Vari†vel para contar Tempo}
   Ap:Integer; {Indica a p†gina de v°deo ativa}
   NameArq1,NameArq2:String; {Recebem os nomes dos arquivos que ser∆o lidos}
   Arq1,Arq2:File of Char; {Representam os arquivos .OSC}
   Arq2Habil:Boolean; {Indica se haver† um segundo arquivo}
   Desc1,DescA1,DescB1,DescC1,DescD1,DescE1,DescF1,DescG1,DescH1,
   Desc2,DescA2,DescB2,DescC2,DescD2,DescE2,DescF2,DescG2,DescH2:String;
   {Armazenam as descriá‰es}
   A1,B1,C1,D1,E1,F1,G1,H1,
   A2,B2,C2,D2,E2,F2,G2,H2:Boolean; {Indicam se o canal est† On ou Off}
   Escala1,Escala2:String[5]; {Indica a Escala}
   Dado1,Dado2,DadoSalva: Array [0..511] Of Char;
   {Armazenam os dados dos arquivos}
   X,Y:Integer; {Coordenadas X e Y}
   Tecla:Char; {Armazena a tecla pressionada}
   PutBMP:Boolean; {Determina OK para grav. do BMP}
   BMPWr:Boolean; {Determina se ser† Gravado um BMP}
   NameBMP:String; {Nome do arquivo BMP}
   ArqBMP:File of Char; {Vari†vel que representa BMP}
   FilTog:Boolean; {Determina se TogFileName foi pressionado}
   DT1,DT2:DateTime; {Armazena a data e hora dos arquivos .OSC}
   Iniciar:Boolean; {Verifica se o usu†rio deseja escolher novos .OSC}
   Oper:String; {Define a operaá∆o a ser realizada com as formas de onda}
   Help:Boolean; {Indica se pressionado Help}
   ZoomHabil:Boolean; {Determina que foi pressionado Zoom}
   Fator:Integer; {Fator de Zoom (1,2,5 ou 10)}

{****************************************************************************}

Label Inicio; {Permite que o usu†rio escolha novos arquivos .OSC}

{****************************************************************************}

Procedure VerifArq;
{Verifica a presenáa dos arquivos necess†rios para a execuá∆o do programa}

Function ArqPres(NomeArqP:String):Boolean;
{Verifica a presenáa do arquivo NomeArqP}

Var FPres:File Of Char; {Representa o arquivo a ser testado}

Begin
     Assign (FPres,NomeArqP);
{$I-}
     Reset (FPres);
{$I+}
     If IOResult <> 0 Then ArqPres:=False
     Else Begin
          ArqPres:=True;
          Close (FPres);
     End;
End;

Procedure MensErroArq(NameArqF:String);
{Mensagem de Erro: N∆o existe o arquivo NameArqF}

Begin
     ClrScr;
     TextColor (Blue);
     Writeln ('Comparador do Analisador L¢gico - Mensagem de Erro');
     Writeln;
     TextColor (LightRed);
     Writeln ('N∆o existe o arquivo "',NameArqF,'"');
     Writeln ('neste diret¢rio!');
     Writeln;
     Writeln ('Verifique qual o diret¢rio corrente!');
     Writeln ('Ap¢s isso, execute novamente este programa.');
     TextColor (LightGray);
     Writeln;
     Writeln ('Caso n∆o consiga solucionar este problema,');
     Writeln ('entre em contato com:');
     Writeln;
     Textcolor (White);
     Writeln ('"Os PEP Legais" - LAO - 4oR Eletrìnica');
     Textcolor (LightGray);
     Writeln;
     Halt(2);
End;

Begin
     If Not ArqPres('CONFIG.EXE') Then MensErroArq('CONFIG.EXE');
     If Not ArqPres('ALOGIC.EXE') Then MensErroArq('ALOGIC.EXE');
     If Not ArqPres('ALOGIC.CFG') Then MensErroArq('ALOGIC.CFG');
     If Not ArqPres('EGAVGA.BGI') Then MensErroArq('EGAVGA.BGI');
     If Not ArqPres('LITT.CHR') Then MensErroArq('LITT.CHR');
     If Not ArqPres('APRES2.PEP') Then MensErroArq('APRES2.PEP');
     If Not ArqPres('APRES4.PEP') Then MensErroArq('APRES4.PEP');
     If Not ArqPres('APRES5.PEP') Then MensErroArq('APRES5.PEP');
     If Not ArqPres('BITMAP.PAL') Then MensErroArq('BITMAP.PAL');
End;

{****************************************************************************}

Procedure Apres;
{Exibe as telas de apresentaá∆o do programa}

Var ApresTec:Char; {Armazena o valor da tecla press. durante apresentaá∆o}
    TempoDelay:Longint; {Delay para a £ltima apresentaá∆o}

Begin
     Ap:=1;
     SetActivePage(0);
     SetTextStyle (SmallFont,HorizDir,4);
     SetTextJustify (CenterText,CenterText);
     SetColor (White);
     OutTextxy (320,175,'Carregando Tela de Apresentacao. Aguarde...');
     SetActivePage(1);
     ApresTec:=ViewPEP('APRES5.PEP',1,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(1);
        SetActivePage(0);
        Ap:=0;
        SetFillStyle(0,0);
        Bar(0,0,639,349);
     End;
     ApresTec:=ViewPEP('APRES2.PEP',Ap,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(0);
        SetActivePage(1);
        Ap:=1;
        SetFillStyle(0,0);
        Bar(0,0,639,349);
     End;
     ApresTec:=ViewPEP('APRES4.PEP',Ap,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(1);
        SetActivePage(0);
        Ap:=0;
        SetFillStyle(0,0);
        Bar(0,0,639,349);
     End;
     For TempoDelay:=0 To 500000 Do Begin
         If Keypressed Then ApresTec:=Readkey;
         If (ApresTec=#13) Or (ApresTec=#27) Then Break;
     End;
     CloseGraph;
End;

{****************************************************************************}

Procedure FimProg;
{Termina a execuá∆o do programa}

Begin
     Window(1,1,80,25);
     TextColor(LightGray);
     TextBackGround(Black);
     ClrScr;
     Writeln;
     Halt(0);
End;

{****************************************************************************}

Procedure Win1;
{Primeira tela do software}
{Apresentaá∆o}

Var TecDo:Char; {Armazena o valor da tecla pressionada}

Begin
     Tela('Comparador de Formas-de-Onda');
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (8,'Comparador');
     CenterTxt (9,'de');
     CenterTxt (10,'Formas de Onda');
     TextColor (White);
     CenterTxt (13,'"Os PEP Legais"');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter para Continuar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      TecDo:=Readkey;
Until TecDo=#13;
End;

{****************************************************************************}

Procedure Win2;
{segunda tela do software}
{Là 1o Arquivo .OSC}

Var PP:Integer; {Coordenada X = utilizada para apagar as linhas da tela}
    IoErr:Integer; {Armazena o £ltimo resultado da operaá∆o de I/O}
    FileOk:Boolean; {Arquivo Correto se True}
    Chj:Char; {Utilizado para armazenar o caracter lido do arquivo .OSC}
    PEPStr:String; {String 'PEP'}
    PEPOk:Boolean; {Arquivo correto se houver 'PEP' nos 3 primeiros bytes}

Begin
     FileOk:=False;
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
     CenterTxt (7,'Digite o nome do primeiro arquivo');
     CenterTxt (8,'a ser visualizado');
     CenterTxt (9,'(com caminho completo, se necess†rio e');
     CenterTxt (10,'sem extens∆o - Extens∆o padr∆o: .OSC):');
     CenterTxt (14,'Pressione somente Enter para Cancelar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite o nome do arquivo sem extens∆o / Enter: Cancela');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     TextColor (Yellow);
     TextBackGround(Cyan);
     Window (1,1,80,25);
Repeat
     CenterTxt (12,'                                            ');
     Gotoxy (30,12);
     Readln (NameArq1);
     If NameArq1='' Then FimProg;
     Assign (Arq1,NameArq1+'.OSC');
{$I-}
     Reset (Arq1);
{$I+}
     IoErr:=IoResult;
     If (IoErr <>0) Then Begin
        CenterTxt (12,'Houve um erro na abertura do arquivo!');
        Sound (1000);
        Delay (100);
        Nosound;
        Delay (1000);
        CenterTxt (12,'                                            ');
     End
     Else Begin
          Read (Arq1,Chj);
          PEPStr:=Chj;
          Read (Arq1,Chj);
          PEPStr:=PEPStr+Chj;
          Read (Arq1,Chj);
          PEPStr:=PEPStr+Chj;
          If PEPStr='PEP' Then PEPOk:=True
          Else PEPOk:=False;
          Reset(Arq1);
          If (FileSize(Arq1)=614) And (PEPOk) Then FileOk:=True
          Else Begin
                CenterTxt (12,'O formato do arquivo n∆o Ç v†lido!');
                Sound (1000);
                Delay (100);
                Nosound;
                Delay (1000);
                CenterTxt (12,'                                            ');
          End;
     End;
Until FileOk;
End;

{****************************************************************************}

Procedure Win3;
{Terceira tela do programa}
{Là 2o Arquivo .OSC}

Var PP:Integer; {Coordenada X = utilizada para apagar as linhas da tela}
    IoErr:Integer; {Armazena o £ltimo resultado da operaá∆o de I/O}
    FileOk:Boolean; {Arquivo Correto se True}
    Chj:Char; {Utilizado para armazenar o caracter lido do arquivo .OSC}
    PEPStr:String; {String 'PEP'}
    PEPOk:Boolean; {Arquivo correto se houver 'PEP' nos 3 primeiros bytes}

Begin
     FileOk:=False;
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
     CenterTxt (7,'Digite o nome do segundo arquivo');
     CenterTxt (8,'a ser visualizado');
     CenterTxt (9,'(com caminho completo, se necess†rio e');
     CenterTxt (10,'sem extens∆o - Extens∆o padr∆o: .OSC):');
     CenterTxt (14,'Pressione somente Enter');
     CenterTxt (15,'para visualizar um s¢ arquivo');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write('Digite o nome do arquivo sem extens∆o / Enter: Cancela');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     TextColor (Yellow);
     TextBackGround(Cyan);
     Window (1,1,80,25);
Repeat
     CenterTxt (12,'                                            ');
     Gotoxy (30,12);
     Readln (NameArq2);
     If NameArq2='' Then Begin
        Arq2Habil:=False;
        Break;
     End;
     Assign (Arq2,NameArq2+'.OSC');
{$I-}
     Reset (Arq2);
{$I+}
     IoErr:=IoResult;
     If (IoErr <>0) Then Begin
        CenterTxt (12,'Houve um erro na abertura do arquivo!');
        Sound (1000);
        Delay (100);
        Nosound;
        Delay (1000);
        CenterTxt (12,'                                            ');
     End
     Else Begin
          Read (Arq2,Chj);
          PEPStr:=Chj;
          Read (Arq2,Chj);
          PEPStr:=PEPStr+Chj;
          Read (Arq2,Chj);
          PEPStr:=PEPStr+Chj;
          If PEPStr='PEP' Then PEPOk:=True
          Else PEPOk:=False;
          Reset(Arq2);
          If (FileSize(Arq2)=614) And (PEPOk) Then FileOk:=True
          Else Begin
                CenterTxt (12,'O formato do arquivo n∆o Ç v†lido!');
                Sound (1000);
                Delay (100);
                Nosound;
                Delay (1000);
                CenterTxt (12,'                                            ');
          End;
     End;
     Arq2Habil:=True;
Until FileOk;
End;

{****************************************************************************}

Procedure LeArqs;
{Là os arquivos .OSC}

Var Cht:Char; {Armazena o caracter lido do arquivos}
    PP:Integer; {Cursor de leitura dos arquivos}
    TimeF1,TimeF2:Longint; {Armazenam Data/Hora dos arquivos}

Begin
     GetFTime(Arq1,TimeF1);
     UnpackTime(TimeF1,DT1);
     Desc1:=''; DescA1:=''; DescB1:=''; DescC1:=''; DescD1:=''; DescE1:='';
     DescF1:=''; DescG1:=''; DescH1:='';
     For PP:=0 To 2 Do Read(Arq1,Cht);
     For PP:=3 To 12 Do Begin
         Read(Arq1,Cht);
         Desc1:=Desc1+Cht;
     End;
     For PP:=13 To 22 Do Begin
         Read(Arq1,Cht);
         DescA1:=DescA1+Cht;
     End;
     For PP:=23 To 32 Do Begin
         Read(Arq1,Cht);
         DescB1:=DescB1+Cht;
     End;
     For PP:=33 To 42 Do Begin
         Read(Arq1,Cht);
         DescC1:=DescC1+Cht;
     End;
     For PP:=43 To 52 Do Begin
         Read(Arq1,Cht);
         DescD1:=DescD1+Cht;
     End;
     For PP:=53 To 62 Do Begin
         Read(Arq1,Cht);
         DescE1:=DescE1+Cht;
     End;
     For PP:=63 To 72 Do Begin
         Read(Arq1,Cht);
         DescF1:=DescF1+Cht;
     End;
     For PP:=73 To 82 Do Begin
         Read(Arq1,Cht);
         DescG1:=DescG1+Cht;
     End;
     For PP:=83 To 92 Do Begin
         Read(Arq1,Cht);
         DescH1:=DescH1+Cht;
     End;

     Read(Arq1,Cht);
     If Ord(Cht)=0 Then A1:=False
     Else A1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then B1:=False
     Else B1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then C1:=False
     Else C1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then D1:=False
     Else D1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then E1:=False
     Else E1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then F1:=False
     Else F1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then G1:=False
     Else G1:=True;
     Read(Arq1,Cht);
     If Ord(Cht)=0 Then H1:=False
     Else H1:=True;

     Read(Arq1,Cht);
     If Ord(Cht)=0 Then Escala1:='    1'
     Else If Ord(Cht)=1 Then Escala1:='   10'
     Else If Ord(Cht)=2 Then Escala1:='  100'
     Else If Ord(Cht)=3 Then Escala1:=' 1000'
     Else If Ord(Cht)=4 Then Escala1:='10000'
     Else If Ord(Cht)=5 Then Escala1:='  EXT';

     For PP:=102 To 613 Do Begin
         Read(Arq1,Cht);
         Dado1[PP-102]:=Cht;
     End;
     Close(Arq1);

   If Arq2Habil Then Begin
     GetFTime(Arq2,TimeF2);
     UnpackTime(TimeF2,DT2);
     Desc2:=''; DescA2:=''; DescB2:=''; DescC2:=''; DescD2:=''; DescE2:='';
     DescF2:=''; DescG2:=''; DescH2:='';
     For PP:=0 To 2 Do Read(Arq2,Cht);
     For PP:=3 To 12 Do Begin
         Read(Arq2,Cht);
         Desc2:=Desc2+Cht;
     End;
     For PP:=13 To 22 Do Begin
         Read(Arq2,Cht);
         DescA2:=DescA2+Cht;
     End;
     For PP:=23 To 32 Do Begin
         Read(Arq2,Cht);
         DescB2:=DescB2+Cht;
     End;
     For PP:=33 To 42 Do Begin
         Read(Arq2,Cht);
         DescC2:=DescC2+Cht;
     End;
     For PP:=43 To 52 Do Begin
         Read(Arq2,Cht);
         DescD2:=DescD2+Cht;
     End;
     For PP:=53 To 62 Do Begin
         Read(Arq2,Cht);
         DescE2:=DescE2+Cht;
     End;
     For PP:=63 To 72 Do Begin
         Read(Arq2,Cht);
         DescF2:=DescF2+Cht;
     End;
     For PP:=73 To 82 Do Begin
         Read(Arq2,Cht);
         DescG2:=DescG2+Cht;
     End;
     For PP:=83 To 92 Do Begin
         Read(Arq2,Cht);
         DescH2:=DescH2+Cht;
     End;

     Read(Arq2,Cht);
     If Ord(Cht)=0 Then A2:=False
     Else A2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then B2:=False
     Else B2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then C2:=False
     Else C2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then D2:=False
     Else D2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then E2:=False
     Else E2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then F2:=False
     Else F2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then G2:=False
     Else G2:=True;
     Read(Arq2,Cht);
     If Ord(Cht)=0 Then H2:=False
     Else H2:=True;

     Read(Arq2,Cht);
     If Ord(Cht)=0 Then Escala2:='    1'
     Else If Ord(Cht)=1 Then Escala2:='   10'
     Else If Ord(Cht)=2 Then Escala2:='  100'
     Else If Ord(Cht)=3 Then Escala2:=' 1000'
     Else If Ord(Cht)=4 Then Escala2:='10000'
     Else If Ord(Cht)=5 Then Escala2:='  EXT';

     For PP:=102 To 613 Do Begin
         Read(Arq2,Cht);
         Dado2[PP-102]:=Cht;
     End;
     Close(Arq2);
   End;
End;

{****************************************************************************}

Procedure GravaBMP;
{Grava a tela como um BMP}

Var BMPSim,BMPOk:Boolean; {Verificam se Ç desejado gravar em BMP}
    ArqPAL:File of Char; {Representa o arquivo de Palette BitMap}
    BitDado:Char; {Armazena o caracter lido do arquivo de Palette}
    ContBy:Integer; {Cursor no arquivo BMP}

Procedure WinBMP1;
{Tela de apresentaá∆o - Utilit†rio de Exportaá∆o para BMP}

Var Tc:Char; {Armazena o caracter lido do teclado}

Begin
     BMPSim:=False;
     Tela('Comparador de Formas-de-Onda');
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackGround (Cyan);
     CenterTxt (9,'Utilit†rio de Exportaá∆o');
     CenterTxt (10,'para BitMap');
     Textcolor(White);
     CenterTxt (14,'"Os PEP Legais"');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write('Pressione Enter para continuar ou Esc para cancelar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
     Tc:=Readkey;
     If Tc=#13 Then BMPSim:=True;
Until (Tc=#27) Or (Tc=#13);

End;

Procedure Win2BMP;
{ Utilit†rio de Exportaá∆o para BMP - recolhe o nome de arquivo}

Var PP:Integer; {Coordenada X: utilizada para apagar linhas na tela}
    IoErr:Integer; {Armazena o resultado da £ltima operaá∆o de I/O}
    NameOk:Boolean; {Informa se o nome-de-arquivo est† correto}
    TpT:Char; {Armazena o caracter lido do teclado}

Procedure Jaexiste;
{J† existe um arquivo .BMP com o mesmo nome}

Var Pl:Integer; {Coordenada X: utilizada para apagar linhas na tela}

Begin
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For Pl:=2 To 60 Do Begin
         Gotoxy (Pl,24);
         Write (' ');
     End;
     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackGround (Cyan);
     CenterTxt (9,'O arquivo j† existe!');
     CenterTxt (12,'Substituir? (S,N)');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write('Escolha a opá∆o: S ou N');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
End;

Begin
     BMPOk:=False;
     PutBMP:=False;
Repeat
Repeat
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
     CenterTxt (7,'Digite o nome do arquivo BitMap');
     CenterTxt (8,'a ser gravado');
     CenterTxt (9,'(com caminho completo, se necess†rio e');
     CenterTxt (10,'sem extens∆o - Extens∆o padr∆o: .BMP):');
     CenterTxt (14,'Pressione somente Enter');
     CenterTxt (15,'para cancelar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write('Digite o nome do arquivo sem extens∆o / Enter: Cancela');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     TextColor (Yellow);
     TextBackGround(Cyan);
     Window (1,1,80,25);

     NameOk:=False;
     CenterTxt (12,'                                            ');
     Gotoxy (30,12);
     Readln (NameBMP);
     If NameBMP='' Then Begin
        Break;
     End;
     Assign (ArqBMP,NameBMP+'.BMP');
{$I-}
     Reset(ArqBMP);
{$I+}
     IoErr:=IoResult;
     If IoErr=0 Then Begin
        Jaexiste;
Repeat
      TpT:=Readkey;
      Tpt:=Upcase(TpT);
Until (Tpt='S') Or (Tpt='N');
        If Tpt='S' Then NameOk:=True;
     End
     Else NameOk:=True;
Until NameOk;

     If Not NameOk Then Begin
        Break;
     End;

{$I-}
     Rewrite (ArqBMP);
{$I+}
     IoErr:=IoResult;
     If IoErr <>0 Then Begin
        CenterTxt (12,'Houve um erro na gravaá∆o do arquivo!');
        Sound (1000);
        Delay (100);
        Nosound;
        Delay (1000);
        CenterTxt (12,'                                            ');
     End
     Else BMPOk:=True;
Until BMPOk;
End;

Begin
     CloseGraph;
     WinBMP1;
     If BMPSim Then Begin
          Win2BMP;
          If BMPOk Then Begin
             Assign (ArqPAL,'BITMAP.PAL');
             Reset (ArqPAL);
             For ContBy:=0 To 117 Do Begin
                 Read (ArqPAL,BitDado);
                 Write (ArqBMP,BitDado);
             End;
             Close (ArqPAL);
             PutBMP:=True;
          End;
     End;
     BMPWr:=False;
     ModoGrafico;
     SetActivePage(1);
     SetVisualPage(0);
     Ap:=1;
End;

{****************************************************************************}

Procedure TogFName;
{Mostra uma janela com os nomes de arquivo e data/hora dos arquivos}

Var DiaStr,MesStr,AnoStr,HoraStr,MinStr,SegStr:String; {Armazenam Data/Hora
                                                       dos arquivos}
    TEnt:Char; {Armazena o caracter lido do teclado}

Function UpStr(Strg:String):String;
{Converte uma String em caracteres mai£sculos}

Var ChSt:String; {String de 1 caracter lida de Strg}
    CSint:Integer; {Conta de 1 atÇ o n£mero da caracteres de Strg}
    StrUp:String; {String de letras mai£sculas}

Function Upc(SCh:String):Char;
{Converte String em Char}

Var SetChar:Char; {Valor Char}
    SetByte:Byte; {Valor Byte}
    SetStr:String; {Valor String}

Begin
     For SetByte:=0 To 255 Do Begin
         SetStr:=Chr(SetByte);
         If SCh=SetStr Then Break;
     End;
     Upc:=Chr(SetByte);
End;

Begin
     StrUp:='';
     For CSint:=1 To Length(Strg) Do Begin
         ChSt:=Copy (Strg,CSint,1);
         StrUp:=StrUp+Upcase(Upc(ChSt));
     End;
     UpStr:=StrUp;
End;

Procedure DataHora(DV1:DateTime);
{ObtÇm data/hora dos arquivos .OSC}

Begin
     Str(DV1.Day,DiaStr);
     If Length(DiaStr)=1 Then DiaStr:='0'+DiaStr;
     Str(DV1.Month,MesStr);
     If Length(MesStr)=1 Then MesStr:='0'+MesStr;
     Str(DV1.Year,AnoStr);
     If Length(AnoStr)=1 Then AnoStr:='0'+AnoStr;
     Str(DV1.Hour,HoraStr);
     If Length(HoraStr)=1 Then HoraStr:='0'+HoraStr;
     Str(DV1.Min,MinStr);
     If Length(MinStr)=1 Then MinStr:='0'+MinStr;
     Str(DV1.Sec,SegStr);
     If Length(SegStr)=1 Then SegStr:='0'+SegStr;
End;

Begin
     If Ap=1 Then Begin
        SetActivePage(0);
        SetVisualPage(0);
     End
     Else Begin
          SetActivePage(1);
          SetVisualPage(1);
     End;
     SetTextJustify(CenterText,CenterText);
     SetTextStyle(SmallFont,HorizDir,4);
     SetFillStyle(1,Black);
     Bar (130,105,530,265);
     SetFillStyle(1,White);
     Bar (120,95,520,255);
     SetColor(LightGray);
     SetLineStyle(0,1,3);
     Line (120,95,120,255);
     Line (520,95,520,255);
     Line (120,95,520,95);
     Line (120,255,520,255);
     SetLineStyle (0,0,0);
     SetFillStyle(1,Blue);
     Bar (122,97,518,110);
     SetColor(Black);
     Line (119,94,119,256);
     Line (521,94,521,256);
     Line (119,94,521,94);
     Line (119,256,521,256);
     SetColor (White);
     OutTextXy (320,103,'Informacao de Arquivos');
     SetFillStyle(1,LightRed);
     Bar (135,125,155,135);
     SetColor(Black);
     SetTextJustify(LeftText,CenterText);
     OutTextxy(165,130,UpStr(NameArq1)+'.OSC');
     DataHora(DT1);
     OutTextxy(165,150,'Data e Hora da ultima modificacao: '+DiaStr+'/'+
               MesStr+'/'+AnoStr+'  '+HoraStr+':'+MinStr+':'+SegStr);

     If Arq2Habil Then Begin
        SetFillStyle(1,LightGreen);
        Bar (135,177,155,187);
        OutTextxy(165,182,UpStr(NameArq2)+'.OSC ');
        DataHora(DT2);
        OutTextxy(165,202,'Data e Hora da ultima modificacao: '+DiaStr+'/'+
                  MesStr+'/'+AnoStr+'  '+HoraStr+':'+MinStr+':'+SegStr);
     End;

     SetTextJustify (CenterText,CenterText);
     OutTextxy(320,240,'Pressione Enter para fechar esta Janela');

Repeat
      TEnt:=Readkey;
Until TEnt=#13;

     If Ap=1 Then Begin
        SetActivePage(1);
        SetVisualPage(0);
     End
     Else Begin
          SetActivePage(0);
          SetVisualPage(1);
     End;
     FilTog:=False;
End;

{****************************************************************************}

Procedure ModoPlot;
{Alterna o modo normal e operaá‰es l¢gicas}

Begin
     If Oper='NORMAL' Then Oper:='AND'
     Else If Oper='AND' Then Oper:='OR'
     Else If Oper='OR' Then Oper:='XOR'
     Else If Oper='XOR' Then Oper:='NORMAL';
End;

{****************************************************************************}

Procedure VerifTecla;
{Verifica que tecla foi pressionada}

Procedure VerifASCII;
{Verifica teclas extendidas}

Var TecASC:Char; {Caracter lido do teclado - teclas extendidas}

Begin
     TecASC:=Readkey;
     If TecASC=#59 Then Help:=True {F1}
     Else If TecASC=#60 Then ZoomHabil:=True {F2}
     Else If TecASC=#61 Then FilTog:=True {F3}
     Else If TecASC=#62 Then Iniciar:=True {F4}
     Else If (TecASC=#63) And (Arq2Habil)
             And (Escala1=Escala2) Then ModoPlot {F5}
     Else If TecASC=#64 Then BMPWr:=True; {F6}
End;

Begin
     Tecla:=Readkey;
     If Tecla=#27 Then Begin {Esc}
        CloseGraph;
        FimProg;
     End
     Else If Tecla=#0 Then VerifASCII;
End;

{****************************************************************************}

Procedure IndicEscala;
{Indica a escala horizontal}

Var FatorStr:String; {Fator de zoom horizontal}

Begin
     SetFillStyle(0,0);
     Bar(110,15,310,25);
     SetColor(LightRed);
     SetTextJustify (LeftText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     OutTextXy (3+TextWidth('Escala Horizontal: '),20, Escala1+' uS/div');
     SetColor(White);
     Str(Fator:2,FatorStr);
     OutTextxy (265,20,'Zoom:'+FatorStr);

     If Arq2Habil Then Begin
        SetColor(LightGreen);
        OutTextXy (3+TextWidth('Escala Horizontal: '+Escala1+' uS/div'),20,
                   ' '+Escala2+' uS/div');
     End;
End;

{****************************************************************************}

Procedure MostraDesc;
{Mostra as descriá‰es do conj. e das formas de onda}

Begin
     SetColor(LightRed);
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     OutTextXy (385,20,Desc1);
     OutTextXy (33,50,DescA1);
     OutTextXy (33,90,DescB1);
     OutTextXy (33,130,DescC1);
     OutTextXy (33,170,DescD1);
     OutTextXy (33,210,DescE1);
     OutTextXy (33,250,DescF1);
     OutTextXy (33,290,DescG1);
     OutTextXy (33,330,DescH1);

     If Arq2Habil Then Begin
        SetColor(LightGreen);
        OutTextXy (455,20,Desc2);
        OutTextXy (33,60,DescA2);
        OutTextXy (33,100,DescB2);
        OutTextXy (33,140,DescC2);
        OutTextXy (33,180,DescD2);
        OutTextXy (33,220,DescE2);
        OutTextXy (33,260,DescF2);
        OutTextXy (33,300,DescG2);
        OutTextXy (33,340,DescH2);
     End;
End;

{****************************************************************************}

Procedure TelaPrinc;
{Desenha a tela principal do programa}

Begin
     {T°tulo}
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (Smallfont,HorizDir,5);
     SetFillStyle (1,Blue);
     Bar (0,0,639,12);
     OutTextxy (320,4,'Comparador de Formas de Onda');

     {Grid}
     SetColor(DarkGray);
     X:=64;
     Repeat
           Line (X,29,X,349);
           X:=X+2;
     Until X>574;
     Setcolor(LightGray);
     X:=64;
     Repeat
           Line (X,29,X,349);
           X:=X+10;
     Until X>574;

     {Linhas Horizontais}
     SetColor(White);
     Y:=29;
     Repeat
           Line (3,Y,635,Y);
           Y:=Y+40;
     Until Y>349;

     {Linhas Verticais}
     Setcolor(White);
     Line (3,29,3,349);
     Line (63,29,63,349);
     Line (575,29,575,349);
     Line (635,29,635,349);

     If Keypressed Then VerifTecla;

     {Nomes dos canais}
     SetTextStyle (SmallFont,HorizDir,6);
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     OutTextXy (33,36,'A');
     OutTextXy (33,76,'B');
     OutTextXy (33,116,'C');
     OutTextXy (33,156,'D');
     OutTextXy (33,196,'E');
     OutTextXy (33,236,'F');
     OutTextXy (33,276,'G');
     OutTextXy (33,316,'H');

     {Indicador de escala horizontal , Help e Descriá‰es}
     SetColor (White);
     SetTextJustify (LeftText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     OutTextXy (3,20,'Escala Horizontal: ');
     SetTextJustify (RightText,CenterText);
     OutTextxy (639,20,'Pressione F1 para Ajuda ');
     IndicEscala;
     MostraDesc;

     If Keypressed Then VerifTecla;

     {Nomes dos Frequenc°metros dos Canais}
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,2);
     Y:=35;
     Repeat
           OutTextXy (605,Y,'Frequencia');
           Y:=Y+40;
     Until Y>315;
     SetTextStyle (SmallFont,HorizDir,4);
     Y:=63;
     Repeat
           OutTextXy (605,Y,'KHz');
           Y:=Y+40;
     Until Y>345;
End;

{****************************************************************************}

Procedure Plotar;
{Plota as formas de onda na tela}

Var CorP:Integer; {Cor do Pixel}
    YPlota:Integer; {Coordenada Y para plotagem}
    CanalByte:Integer; {Canal a ser plotado}

Procedure Plota1;
{Plota a 1a Forma-de-onda}

Var IndDado:Integer; {Index do Array Dado}
    NVezes:Integer;  {N£mero de vezes a se repetir o mesmo dado (no Zoom)}

Begin
        For IndDado:=1 To Round(510/Fator) Do Begin
            For NVezes:=1 To Fator Do Begin

                PutPixel ((NVezes-Fator)+(IndDado*Fator)+64,
                          (((Ord(Dado1[IndDado]) And Eleva(2,CanalByte))
                          Shr CanalByte) Xor 1)*32+YPlota+3,CorP);

                PutPixel ((NVezes-Fator)+(IndDado*Fator)+64,
                          (((Ord(Dado1[IndDado]) And Eleva(2,CanalByte))
                          Shr CanalByte) Xor 1)*34+YPlota+2,CorP);

                If Keypressed Then VerifTecla;
            End;
        End;
End;

Procedure Plota2;
{Plota a 2a Forma-de-onda}

Var IndDado:Integer; {Index do Array Dado}
    NVezes:Integer; {N£mero de vezes a se repetir o mesmo dado (no Zoom)}

Begin
        For IndDado:=1 To Round(510/Fator) Do Begin
            For NVezes:=1 To Fator Do Begin

                PutPixel ((NVezes-Fator)+(IndDado*Fator)+64,
                          (((Ord(Dado2[IndDado]) And Eleva(2,CanalByte))
                          Shr CanalByte) Xor 1)*26+YPlota+6,CorP);

                PutPixel ((NVezes-Fator)+(IndDado*Fator)+64,
                          (((Ord(Dado2[IndDado]) And Eleva(2,CanalByte))
                          Shr CanalByte) Xor 1)*28+YPlota+5,CorP);

                If Keypressed Then VerifTecla;
            End;
        End;
End;

Begin
     If Oper='NORMAL' Then CorP:=LightRed
     Else CorP:=Yellow;
     If A1 Then Begin
        YPlota:=30;
        CanalByte:=0;
        Plota1;
     End;
     If B1 Then Begin
        CanalByte:=1;
        YPlota:=70;
        Plota1;
     End;
     If C1 Then Begin
        YPlota:=110;
        CanalByte:=2;
        Plota1;
     End;
     If D1 Then Begin
        CanalByte:=3;
        YPlota:=150;
        Plota1;
     End;
     If E1 Then Begin
        YPlota:=190;
        CanalByte:=4;
        Plota1;
     End;
     If F1 Then Begin
        YPlota:=230;
        CanalByte:=5;
        Plota1;
     End;
     If G1 Then Begin
        YPlota:=270;
        CanalByte:=6;
        Plota1;
     End;
     If H1 Then Begin
        CanalByte:=7;
        YPlota:=310;
        Plota1;
     End;

   If (Arq2Habil) And (Oper='NORMAL') Then Begin
     CorP:=LightGreen;
     If A2 Then Begin
        YPlota:=30;
        CanalByte:=0;
        Plota2;
     End;
     If B2 Then Begin
        CanalByte:=1;
        YPlota:=70;
        Plota2;
     End;
     If C2 Then Begin
        YPlota:=110;
        CanalByte:=2;
        Plota2;
     End;
     If D2 Then Begin
        CanalByte:=3;
        YPlota:=150;
        Plota2;
     End;
     If E2 Then Begin
        YPlota:=190;
        CanalByte:=4;
        Plota2;
     End;
     If F2 Then Begin
        YPlota:=230;
        CanalByte:=5;
        Plota2;
     End;
     If G2 Then Begin
        YPlota:=270;
        CanalByte:=6;
        Plota2;
     End;
     If H2 Then Begin
        CanalByte:=7;
        YPlota:=310;
        Plota2;
     End;
   End;
End;

{****************************************************************************}

Procedure IndicaFreq (NumForm:Integer;
                      FA:Real;FB:Real;FC:Real;FD:Real;FE:Real;FF:Real;FG:Real;
                      FH:Real);
{Mostra os valores de frequància dos canais ativos
  FA a FH = Valores medidos pelo frequenc°metro
  NumForm = 1 ou 2 forma(s)-de-onda}

Var Valor:String; {Frequància convertida em String}
    CorP:Integer; {Cor do frequenc°metro}

Begin
   If Oper='NORMAL' Then CorP:=LightRed
   Else CorP:=Yellow;
   If NumForm=1 Then Begin
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor (CorP);
     If A1=True Then Begin
        Str (FA:8:3,Valor);
        OutTextXy (605,45,Valor);
     End;
     If B1=True Then Begin
        Str (FB:8:3,Valor);
        OutTextXy (605,85,Valor);
     End;
     If C1=True Then Begin
        Str (FC:8:3,Valor);
        OutTextXy (605,125,Valor);
     End;
     If D1=True Then Begin
        Str (FD:8:3,Valor);
        OutTextXy (605,165,Valor);
     End;
     If E1=True Then Begin
        Str (FE:8:3,Valor);
        OutTextXy (605,205,Valor);
     End;
     If F1=True Then Begin
        Str (FF:8:3,Valor);
        OutTextXy (605,245,Valor);
     End;
     If G1=True Then Begin
        Str (FG:8:3,Valor);
        OutTextXy (605,285,Valor);
     End;
     If H1=True Then Begin
        Str (FH:8:3,Valor);
        OutTextXy (605,325,Valor);
     End;

     If Keypressed Then VerifTecla;

   End
   Else If (NumForm=2) And (Oper='NORMAL') Then Begin
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor (LightGreen);
     If A2=True Then Begin
        Str (FA:8:3,Valor);
        OutTextXy (605,54,Valor);
     End;
     If B2=True Then Begin
        Str (FB:8:3,Valor);
        OutTextXy (605,94,Valor);
     End;
     If C2=True Then Begin
        Str (FC:8:3,Valor);
        OutTextXy (605,134,Valor);
     End;
     If D2=True Then Begin
        Str (FD:8:3,Valor);
        OutTextXy (605,174,Valor);
     End;
     If E2=True Then Begin
        Str (FE:8:3,Valor);
        OutTextXy (605,214,Valor);
     End;
     If F2=True Then Begin
        Str (FF:8:3,Valor);
        OutTextXy (605,254,Valor);
     End;
     If G2=True Then Begin
        Str (FG:8:3,Valor);
        OutTextXy (605,294,Valor);
     End;
     If H2=True Then Begin
        Str (FH:8:3,Valor);
        OutTextXy (605,334,Valor);
     End;
   End;
End;

{****************************************************************************}

Procedure Frequenc;
{Calcula as frequàncias dos canais}

Var FrA,FrB,FrC,FrD,FrE,FrF,FrG,FrH:Real; {Armazenam os valores de frequància}
    Pontos:Integer; {Pontos em mesmo estado l¢gico (Hi ou Lo)}
    Dc:Boolean; {Indica Tens∆o Cont°nua Constante}
    IndDado:Integer; {Index do Array Dado}
    Escala:Real; {Escala Horizontal}
    Cod:Integer; {Indica o resultado da convers∆o Freq => String}

Function Eleva2 (Base:Integer;Expoente:Integer):Integer;
{Eleva uma Base a um Expoente
 Verifica se alguma tecla foi pressionada}

Var Vezes:Integer; {N£mero de vezes que a base deve ser multiplicada}
    ValorExp:Integer; {Resultado da operaá∆o}

Begin
     ValorExp:=1;
     If Expoente=0 Then Eleva2:=1
     Else Begin
          For Vezes:=1 To Expoente Do ValorExp:=ValorExp*Base;
          Eleva2:=ValorExp;
     End;

     If Keypressed Then VerifTecla;

End;

Procedure MedeFreq1 (CanBit:Integer);
{Mede a frequància dos canais da 1a forma-de-onda
  CanBit = Indica qual o canal}

Begin
     IndDado:=0;
     Pontos:=0;
     Dc:=False;
Repeat
      IndDado:=IndDado+1;
Until ((Ord(Dado1[IndDado]) And Eleva2(2,CanBit)) Shr CanBit =1)
       Or (IndDado=511);

Repeat
      IndDado:=IndDado+1;
Until ((Ord(Dado1[IndDado]) And Eleva2(2,CanBit)) Shr CanBit =0)
       Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

Repeat
      IndDado:=IndDado+1;
      Pontos:=Pontos+1;
Until ((Ord(Dado1[IndDado]) And Eleva2(2,Canbit)) Shr CanBit =1)
       Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

Repeat
      IndDado:=IndDado+1;
      Pontos:=Pontos+1;
Until ((Ord(Dado1[IndDado]) And Eleva2(2,CanBit)) Shr CanBit =0)
       Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

End;

Procedure MedeFreq2 (CanBit:Integer);
{Mede a frequància dos canais da 2a forma-de-onda
  CanBit = Indica qual o canal}

Begin
     IndDado:=0;
     Pontos:=0;
     Dc:=False;
Repeat
      IndDado:=IndDado+1;
Until ((Ord(Dado2[IndDado]) And Eleva2(2,CanBit)) Shr CanBit =1)
       Or (IndDado=511);

Repeat
      IndDado:=IndDado+1;
Until ((Ord(Dado2[IndDado]) And Eleva2(2,CanBit)) Shr CanBit =0)
       Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

Repeat
      IndDado:=IndDado+1;
      Pontos:=Pontos+1;
Until ((Ord(Dado2[IndDado]) And Eleva2(2,Canbit)) Shr CanBit =1)
       Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

Repeat
      IndDado:=IndDado+1;
      Pontos:=Pontos+1;
Until ((Ord(Dado2[IndDado]) And Eleva2(2,CanBit)) Shr CanBit =0)
       Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

End;

Begin
     Val(Escala1,Escala,Cod);
     MedeFreq1 (0);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrA:= 0
     Else FrA:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (1);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrB:= 0
     Else FrB:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (2);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrC:= 0
     Else FrC:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (3);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrD:= 0
     Else FrD:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (4);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrE:= 0
     Else FrE:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (5);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrF:= 0
     Else FrF:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (6);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrG:= 0
     Else FrG:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq1 (7);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrH:= 0
     Else FrH:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     IndicaFreq (1,FrA,FrB,FrC,FrD,FrE,FrF,FrG,FrH);

     If Keypressed Then VerifTecla;

  If Arq2Habil Then Begin
     Val(Escala2,Escala,Cod);
     MedeFreq2 (0);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrA:= 0
     Else FrA:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (1);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrB:= 0
     Else FrB:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (2);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrC:= 0
     Else FrC:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (3);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrD:= 0
     Else FrD:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (4);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrE:= 0
     Else FrE:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (5);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrF:= 0
     Else FrF:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (6);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrG:= 0
     Else FrG:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq2 (7);
     If Cod <> 0 Then Dc:=True;
     If Dc Then FrH:= 0
     Else FrH:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;
  End;

     IndicaFreq (2,FrA,FrB,FrC,FrD,FrE,FrF,FrG,FrH);
End;

{****************************************************************************}

Procedure GetTela;
{Là a tela e grava no BMP}

Var CorBy,Meio1,Meio2:Word; {Cor do pixel lido da tela e os nibbles que o
                             representam}
    PixByte:Char; {Caracter a ser gravado no arquivo BMP}
    BlueDt:Boolean; {Indica a cor azul: utilizada na correá∆o de cores}

Procedure CorCorrect;
{Correá∆o de cores para a palette do BMP}

Begin
     If CorBy=7 Then CorBy:=0
     Else If CorBy=12 Then CorBy:=8
     Else If CorBy=0 Then CorBy:=7
     Else If (CorBy=15) And (BlueDt=False) Then CorBy:=0
     Else If CorBy=10 Then CorBy:=6
     Else If CorBy=8 Then CorBy:=3
     Else If CorBy=14 Then CorBy:=10;
End;

Procedure Porcento;
{Indica o progresso da gravaá∆o em %}

Var Porc,Pa,Pb,Pc,Pd:Extended; {Utilizadas no c†lculo do percentual}
    PorcStr:String; {Percentual em formato String}

Begin
     Pa:=Y-349;
     Pb:=Pa*(-640);
     Pc:=Pb+1+X;
     Pd:=640*350;
     Porc:=(Pc/Pd)*100;
     If Porc-Trunc(Porc)<0.001 Then Begin
        Str(Porc:3:0,PorcStr);
        SetActivePage(0);
        Bar(220,160,270,180);
        OutTextXy(320,170,PorcStr+' % Concluido ');
        If PorcStr='100' Then Begin
           OutTextxy(320,220,'Operacao concluida com sucesso!');
           Delay(1500);
        End;
        SetActivePage(1);
     End;
End;

Begin
     X:=0; Y:=349;
     BlueDt:=False;
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     SetActivePage(0);
     SetTextStyle (Smallfont,HorizDir,5);
     SetFillStyle (1,Cyan);
     Bar (0,0,639,349);
     SetFillStyle (1,Blue);
     Bar (0,0,639,12);
     OutTextxy (320,4,'Comparador de Formas de Onda');
     SetColor(Yellow);
     SetTextStyle(SmallFont,HorizDir,7);
     OutTextXy(320,100,'Exportando para BitMap. Aguarde...');
     SetActivePage(1);
     SetFillStyle(1,Cyan);

Repeat
     PorCento;
     CorBy:=GetPixel(X,Y);
     If CorBy=1 Then BlueDt:=True;
     CorCorrect;
     Meio1:=CorBy;
     X:=X+1;
     CorBy:=GetPixel(X,Y);
     If CorBy=1 Then BlueDt:=True;
     CorCorrect;
     Meio2:=CorBy;
     X:=X+1;
     PixByte:=Chr((Meio1 Shl 4) Or (Meio2));
     Write (ArqBMP,PixByte);
     If X=640 Then Begin
        X:=0;
        Y:=Y-1;
     End;
Until (X=638) And (Y=0);
     CorBy:=GetPixel(X,Y);
     CorCorrect;
     Meio1:=CorBy;
     X:=X+1;
     CorBy:=GetPixel(X,Y);
     CorCorrect;
     Meio2:=CorBy;
     X:=X+1;
     PorCento;
     PixByte:=Chr((Meio1 Shl 4) Or (Meio2));
     Write (ArqBMP,PixByte);
     Close(ArqBMP);
     PutBMP:=False;
     SetActivePage(0);
     SetFillStyle(0,0);
     Bar(0,0,639,349);
     SetActivePage(1);
End;

{****************************************************************************}

Procedure AlteraPlot;
{Altera o modo de Plotagem Normal ou operaá∆o}

Var PSal:Integer; {Index do Array DadoSalva}

Begin
     If Oper<>'NORMAL' Then Begin
        For PSal:=0 To 511 Do Begin
            If Oper='AND' Then Begin
               Dado1[PSal]:=Chr((Ord(DadoSalva[PSal])) And (Ord(Dado2[PSal])));
            End
            Else If Oper='OR' Then Begin
               Dado1[PSal]:=Chr(Ord(DadoSalva[PSal]) Or Ord(Dado2[PSal]));
            End
            Else If Oper='XOR' Then Begin
               Dado1[PSal]:=Chr(Ord(DadoSalva[PSal]) Xor Ord(Dado2[PSal]));
            End;
        End;
     End
     Else Begin
        For PSal:=0 To 511 Do Begin
            Dado1[PSal]:=DadoSalva[PSal];
        End;
     End;
     SetFillStyle(0,0);
     Bar(0,30,639,349);
End;

{****************************************************************************}

Procedure Operation;
{Mostra o modo atual: Normal ou operaá∆o}

Begin
     SetFillStyle(0,0);
     SetColor(Yellow);
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     Bar (310,15,350,25);
     OutTextXy (330,20,Oper);
End;

{****************************************************************************}

Procedure Ajuda;
{Mostra a Ajuda}

Var PPPT:Char; {Armazena o caracter lido do teclado}

Begin
     If Ap=1 Then Begin
        SetActivePage(0);
        Ap:=0;
     End
     Else Begin
          SetActivePage(1);
          Ap:=1;
     End;
     SetTextJustify(CenterText,CenterText);
     SetTextStyle(SmallFont,HorizDir,4);
     SetFillStyle(1,Black);
     Bar (130,105,530,265);
     SetFillStyle(1,White);
     Bar (120,95,520,255);
     SetColor(LightGray);
     SetLineStyle(0,1,3);
     Line (120,95,120,255);
     Line (520,95,520,255);
     Line (120,95,520,95);
     Line (120,255,520,255);
     SetLineStyle (0,0,0);
     SetFillStyle(1,Blue);
     Bar (122,97,518,110);
     SetColor(Black);
     Line (119,94,119,256);
     Line (521,94,521,256);
     Line (119,94,521,94);
     Line (119,256,521,256);
     SetColor (White);
     OutTextXy (320,103,'Ajuda do Comparador de Formas de Onda');
     SetColor(Magenta);
     SetTextStyle (SmallFont,HorizDir,5);
     OutTextxy(320,120,'Os PEP Legais');
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor(Black);
     OutTextxy(320,140,'Esc = Sai do Programa');
     OutTextxy(320,152,'F1 = Ajuda');
     OutTextxy(320,164,'F2 = Zoom (1, 2, 5, 10)');
     OutTextxy(320,176,'F3 = Informacao de Arquivos');
     OutTextxy(320,188,'F4 = Retorna ao Menu Inicial');
     OutTextxy(320,200,'F5 = Alterna o Modo (Normal, AND, OR, XOR)');
     OutTextxy(320,212,'F6 = Exporta para BitMap');
     OutTextxy(320,240,'Pressione Enter para Fechar esta Janela');

Repeat
      PPPT:=Readkey;
Until PPPT=#13;

     Help:=False;
     If Ap=1 Then Begin
        SetActivePage(0);
        Ap:=0;
     End
     Else Begin
          SetActivePage(1);
          Ap:=1;
     End;
End;

{****************************************************************************}

Procedure Zoom;
{Realiza o zoom de 1X, 2X, 5X ou 10X}

Var EscaInt1,EscaInt2:Real; {Armazenam a escala horizontal em formato real}
    Code:Integer; {Resultado da convers∆o Escala => Real}
    CharUlt:String; {Èltimo caracter da convers∆o Real => Escala}

Procedure Conj1;
{Zoom para 1a forma-de-onda}

Begin
     Val(Escala1,EscaInt1,Code);
     If Code <> 0 Then EscaInt1:=1;
     If Fator=1 Then Begin
        EscaInt1:=EscaInt1/2;
     End
     Else If Fator=2 Then Begin
          EscaInt1:=(EscaInt1*2)/5;
     End
     Else If Fator=5 Then Begin
          EscaInt1:=(EscaInt1*5)/10;
     End
     Else If Fator=10 Then Begin
          EscaInt1:=EscaInt1*10;
     End;

     If Escala1='  EXT' Then Escala1:='  EXT'
     Else Str(EscaInt1:5:1,Escala1);

     CharUlt:=Copy(Escala1,Length(Escala1),1);
     If CharUlt='.' Then Delete(Escala1,Length(Escala1),1);
     CharUlt:=Copy(Escala1,Length(Escala1)-1,2);
     If CharUlt='.0' Then Delete(Escala1,Length(Escala1)-1,2);
End;

Procedure Conj2;
{Zoom para a 2a forma-de-onda}

Begin
     Val(Escala2,EscaInt2,Code);
     If Code <> 0 Then EscaInt2:=1;
     If Fator=1 Then Begin
        EscaInt2:=EscaInt2/2;
     End
     Else If Fator=2 Then Begin
          EscaInt2:=(EscaInt2*2)/5;
     End
     Else If Fator=5 Then Begin
          EscaInt2:=(EscaInt2*5)/10;
     End
     Else If Fator=10 Then Begin
          EscaInt2:=EscaInt2*10;
     End;

     If Escala2='  EXT' Then Escala2:='  EXT'
     Else Str(EscaInt2:5:1,Escala2);

     CharUlt:=Copy(Escala2,Length(Escala2),1);
     If CharUlt='.' Then Delete(Escala2,Length(Escala2),1);
     CharUlt:=Copy(Escala2,Length(Escala2)-1,2);
     If CharUlt='.0' Then Delete(Escala2,Length(Escala2)-1,2);
End;

Begin
     Conj1;
     If Arq2Habil Then Conj2;

     If Fator=1 Then Fator:=2
     Else If Fator=2 Then Fator:=5
     Else If Fator=5 Then Fator:=10
     Else If Fator=10 Then Fator:=1;

     ZoomHabil:=False;
End;

{****************************************************************************}

Procedure InitDefault;
{Inicia as vari†veis}

Begin
     Iniciar:=False;
     Help:=False;
     BMPWr:=False;
     FilTog:=False;
     PutBMP:=False;
     Oper:='NORMAL';
     Fator:=1;
End;

{****************************************************************************}

Begin
     VerifArq;
     ModoGrafico;
     Apres;
Inicio:
     Win1;
     Win2;
     Win3;
     LeArqs;
     For X:=0 To 511 Do Begin
         DadoSalva[X]:=Dado1[X];
     End;
     InitDefault;
     ModoGrafico;
     SetActivePage(1);
     SetVisualPage(0);
     Ap:=1;
Repeat
     If ZoomHabil Then Zoom;
     If BMPWr Then GravaBMP;
     If FilTog Then TogFName;
     If Help Then Ajuda;
     If Iniciar Then Begin
        CloseGraph;
        Goto Inicio;
     End;
     Delay(10);
     AlteraPlot;
     TelaPrinc;
     Plotar;
     Frequenc;
     Operation;
     If PutBMP Then GetTela;
     If Ap=1 Then Begin
        SetActivePage(0);
        SetVisualPage(1);
        Ap:=0;
     End
     Else Begin
        SetActivePage(1);
        SetVisualPage(0);
        Ap:=1;
     End;
     Delay(10);
     If Keypressed Then VerifTecla;
Until Tecla=#27;
     CloseGraph;
     FimProg;
End.

{****************************************************************************}
{
        * Estrutura do arquivo .OSC *

Bytes 0 a 2 = 'PEP'
Bytes 3 a 12 = Descriá∆o do Conjunto
Bytes 13 a 22 = Descriá∆o do Canal A
Bytes 23 a 32 = Descriá∆o do Canal B
Bytes 33 a 42 = Descriá∆o do Canal C
Bytes 43 a 52 = Descriá∆o do Canal D
Bytes 53 a 62 = Descriá∆o do Canal E
Bytes 63 a 72 = Descriá∆o do Canal F
Bytes 73 a 82 = Descriá∆o do Canal G
Bytes 83 a 92 = Descriá∆o do Canal H
Byte 93 = 00H se Canal A = OFF / 01H se Canal A = ON
Byte 94 = 00H se Canal B = OFF / 01H se Canal B = ON
Byte 95 = 00H se Canal C = OFF / 01H se Canal C = ON
Byte 96 = 00H se Canal D = OFF / 01H se Canal D = ON
Byte 97 = 00H se Canal E = OFF / 01H se Canal E = ON
Byte 98 = 00H se Canal F = OFF / 01H se Canal F = ON
Byte 99 = 00H se Canal G = OFF / 01H se Canal G = ON
Byte 100 = 00H se Canal H = OFF / 01H se Canal H = ON
Byte 101 = Escala Horizontal:
           00H = 1uS/div
           01H = 10uS/div
           02H = 100uS/div
           03H = 1.000uS/div
           04H = 10.000uS/div
           05H = Externo
Bytes 102 a 613 = Dados (0 a 511)

}
{****************************************************************************}
{
        * Estrutura do arquivo .BMP *

Bytes 0 a 17 = Identificadores do BitMap
Bytes 18 e 19 = Largura em Pixels
Byte 22 e 23 = Altura em Pixels
Byte 54 a 56 = B,G,R da Cor 0 - Palette
Byte 58 a 60 = B,G,R da Cor 1 - Palette
Byte 62 a 64 = B,G,R da Cor 2 - Palette
Byte 66 a 68 = B,G,R da Cor 3 - Palette
Byte 70 a 72 = B,G,R da Cor 4 - Palette
Byte 74 a 76 = B,G,R da Cor 5 - Palette
Byte 78 a 80 = B,G,R da Cor 6 - Palette
Byte 82 a 84 = B,G,R da Cor 7 - Palette
Byte 86 a 88 = B,G,R da Cor 8 - Palette
Byte 90 a 92 = B,G,R da Cor 9 - Palette
Byte 94 a 96 = B,G,R da Cor 10 - Palette
Byte 98 a 100 = B,G,R da Cor 11 - Palette
Byte 102 a 104 = B,G,R da Cor 12 - Palette
Byte 106 a 108 = B,G,R da Cor 13 - Palette
Byte 110 a 112 = B,G,R da Cor 14 - Palette
Byte 114 a 116 = B,G,R da Cor 15 - Palette
Byte 118 = Inicio do BMP (Cada 1/2 Byte Ç a cor de um Pixel)

}
{****************************************************************************}
