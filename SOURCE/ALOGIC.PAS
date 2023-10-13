{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compila‡Æo}

{****************************************************************************}

Program Analisador_Logico;

{****************************************************************************}
{
        Analisador L¢gico - "Os PEP Legais"

        Cr‚ditos:
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
        Software Principal - Visualizador de formas de onda;
                             Frequenc¡metro;
                             Gravador de arquivos .OSC
        VersÆo 1.0 - 1997

        Software for MS-DOS, Escrito no compilador Turbo Pascal 7.0

        Requisitos M¡nimos do Sistema:

                   IBM PC XT/AT ou Compat¡vel (Recomenda-se 486)
                   640KB de RAM ou mais (Recomenda-se 4MB)
                   Monitor EGA ou superior (Recomenda-se VGA Color)
                   Disk Drive de 1,44MB
                   Hard Disk com pelo menos 1MB livres
}
{****************************************************************************}

Uses Crt,Graph,Dos,PEPUnit;
{Units a serem utilizadas}

{****************************************************************************}

Var
{Declara‡Æo das vari veis}

   X,Y:Integer; {Deteriminam as coord. X e Y}
   A,B,C,D,E,F,G,H:Boolean; {Status dos canais (On/Off)}
   Escala:Real; {Armazena o valor da escala horizontal}
   CanalSync:Char; {Armazena qual o canal base de Sync}
   StatusPort:Byte; {Armazena o valor atual da LPT de Controle}
   Dado:Array [0..511] Of Byte; {Armazena os dados da leitura}
   IndDado:Integer; {Vari vel para indicar a posi‡Æo do Array Dado}
   Hr,M,S,S100:Word; {Vari veis para contar Tempo}
   Timea:Real; {Vari vel para contar Tempo}
   Ap:Integer; {Indica a p gina de v¡deo ativa}
   Pausa:Boolean; {Indica estado de pausa}
   Zoom:Boolean; {Indica estado de zoom}
   Ajuda:Boolean; {Indica chamada de Ajuda}
   NameArq:String; {Recebe o nome do arquivo .OSC que ser  gravado}
   Descr:Array [1..10,0..8] Of Char; {Armazena as descri‡äes dos canais e do
                                      conjunto de formas de onda}
   Arq:File of Char; {Representa o arquivo .OSC}
   Fator,FimPonto:Integer; {Determinam o fator de zoom}
   Cfg:Text; {Arquivo de configura‡Æo}
   P1:Word; {LPT de Dados}
   P2:Word; {LPT de Controle}
   HabilVerif:Boolean; {Habilita a verifica‡Æo da presen‡a da Interface}
   HabilSyncOff:Boolean; {Habilita o desligamento do Sync para C.C.}

{****************************************************************************}

Const HabilAtuEscSync=True;
{Habilita atualiza‡Æo da escala/sincronismo - p/ reset de escala/canal base
de Sync}

{****************************************************************************}

Procedure AbreCfg;
{Abre o arquivo Oscilos.Cfg}

Var HV,HS:Byte; {Armazenam os bytes de configura‡Æo lidos de Oscilos.Cfg}

Procedure MensErro;
{Indica Erro de falta de arquivo: ALOGIC.CFG}

Begin
        ClrScr;
        TextColor (Blue);
        Writeln ('Analisador L¢gico - Mensagem de Erro');
        Writeln;
        TextColor (LightRed);
        Writeln ('NÆo existe o arquivo "ALOGIC.CFG"');
        Writeln ('neste diret¢rio!');
        Writeln;
        Writeln ('Verifique qual o diret¢rio corrente!');
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

Begin
     Assign (Cfg,'Alogic.Cfg');
{$I-}
     Reset (Cfg);
{$I+}
     If Ioresult<>0 Then MensErro;
     Readln (Cfg,P1,HV,HS);
     P2:=P1;

     If HV=1 Then HabilVerif:=True
     Else HabilVerif:=False;

     If HS=1 Then HabilSyncOff:=True
     Else HabilSyncOff:=False;

     Close (Cfg);
End;

{****************************************************************************}

Procedure VerifArq;
{Verifica a presen‡a dos arquivos necess rios para a execu‡Æo do programa}

Function ArqPres(NomeArqP:String):Boolean;
{Verifica se o arquivo NomeArqP est  presente}

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
{Mensagem de Erro: Falta o arquivo NameArqF}

Begin
     ClrScr;
     TextColor (Blue);
     Writeln ('Analisador L¢gico - Mensagem de Erro');
     Writeln;
     TextColor (LightRed);
     Writeln ('NÆo existe o arquivo "',NameArqF,'"');
     Writeln ('neste diret¢rio!');
     Writeln;
     Writeln ('Verifique qual o diret¢rio corrente!');
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

Begin
     If Not ArqPres('CONFIG.EXE') Then MensErroArq('CONFIG.EXE');
     If Not ArqPres('EGAVGA.BGI') Then MensErroArq('EGAVGA.BGI');
     If Not ArqPres('LITT.CHR') Then MensErroArq('LITT.CHR');
     If Not ArqPres('APRES1.PEP') Then MensErroArq('APRES1.PEP');
     If Not ArqPres('APRES2.PEP') Then MensErroArq('APRES2.PEP');
     If Not ArqPres('APRES3.PEP') Then MensErroArq('APRES3.PEP');
     If Not ArqPres('APRES4.PEP') Then MensErroArq('APRES4.PEP');
End;

{****************************************************************************}

Procedure Apres;
{Exibe as telas de apresenta‡Æo do programa}

Var ApresTec:Char; {Tecla lida durante a apresenta‡Æo}
    TempoDelay:Longint; {Delay dado ap¢s a £ltima tela de apresenta‡Æo}

Begin
     SetActivePage(0);
     SetTextStyle (SmallFont,HorizDir,4);
     SetTextJustify (CenterText,CenterText);
     SetColor (White);
     OutTextxy (320,175,'Carregando Tela de Apresentacao. Aguarde...');
     SetActivePage(1);
     ApresTec:=ViewPEP('APRES1.PEP',1,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(1);
        SetActivePage(0);
        Ap:=0;
     End;
     ApresTec:=ViewPEP('APRES2.PEP',Ap,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(0);
        SetActivePage(1);
        Ap:=1;
     End;
     ApresTec:=ViewPEP('APRES3.PEP',Ap,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(1);
        SetActivePage(0);
        Ap:=0;
     End;
     ApresTec:=ViewPEP('APRES4.PEP',Ap,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(0);
        SetActivePage(1);
        Ap:=1;
     End;
     For TempoDelay:=0 To 500000 Do Begin
         If Keypressed Then ApresTec:=Readkey;
         If (ApresTec=#13) Or (ApresTec=#27) Then Break;
     End;
     SetActivePage(1);
     ClearDevice;
     SetActivePage(0);
     ClearDevice;
     SetTextStyle (SmallFont,HorizDir,4);
     SetTextJustify (CenterText,CenterText);
     SetColor (White);
     OutTextxy (320,175,'Carregando Tela Principal. Aguarde...');
     SetVisualPage(0);
     SetActivePage(1);
     Ap:=1;
End;

{****************************************************************************}

Procedure IndicCanal (Canal:Char;Estado:Boolean);
{Seta os canais para ON ou OFF
  Canal = Qual o canal
  Estado = 1:ON ou 0:OFF}

Begin
     Canal:=Upcase(Canal);
     SetFillStyle (0,0);
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);

     If Canal='A' Then Begin
        If Estado=True Then Begin
           A:=True;
           Bar (4,50,62,68);
           SetColor (LightGreen);
           OutTextXy (33,58,'ON');
        End
        Else Begin
             A:=False;
             Bar (4,50,62,68);
             SetColor (LightRed);
             OutTextXy (33,58,'OFF');
        End;
     End
     Else If Canal='B' Then Begin
          If Estado=True Then Begin
             B:=True;
             Bar (4,90,62,108);
             SetColor (LightGreen);
             OutTextXy (33,98,'ON');
          End
          Else Begin
               B:=False;
               Bar (4,90,62,108);
               SetColor (LightRed);
               OutTextXy (33,98,'OFF');
          End;
     End
     Else If Canal='C' Then Begin
          If Estado=True Then Begin
             C:=True;
             Bar (4,130,62,148);
             SetColor (LightGreen);
             OutTextXy (33,138,'ON');
          End
          Else Begin
               C:=False;
               Bar (4,130,62,148);
               SetColor (LightRed);
               OutTextXy (33,138,'OFF');
          End;
     End
     Else If Canal='D' Then Begin
          If Estado=True Then Begin
             D:=True;
             Bar (4,170,62,188);
             SetColor (LightGreen);
             OutTextXy (33,178,'ON');
          End
          Else Begin
               D:=False;
               Bar (4,170,62,188);
               SetColor (LightRed);
               OutTextXy (33,178,'OFF');
          End;
     End
     Else If Canal='E' Then Begin
          If Estado=True Then Begin
             E:=True;
             Bar (4,210,62,228);
             SetColor (LightGreen);
             OutTextXy (33,218,'ON');
          End
          Else Begin
               E:=False;
               Bar (4,210,62,228);
               SetColor (LightRed);
               OutTextXy (33,218,'OFF');
          End;
     End
     Else If Canal='F' Then Begin
          If Estado=True Then Begin
             F:=True;
             Bar (4,250,62,268);
             SetColor (LightGreen);
             OutTextXy (33,258,'ON');
          End
          Else Begin
               F:=False;
               Bar (4,250,62,268);
               SetColor (LightRed);
               OutTextXy (33,258,'OFF');
          End;
     End
     Else If Canal='G' Then Begin
          If Estado=True Then Begin
             G:=True;
             Bar (4,290,62,308);
             SetColor (LightGreen);
             OutTextXy (33,298,'ON');
          End
          Else Begin
               G:=False;
               Bar (4,290,62,308);
               SetColor (LightRed);
               OutTextXy (33,298,'OFF');
          End;
     End
     Else If Canal='H' Then Begin
          If Estado=True Then Begin
             H:=True;
             Bar (4,330,62,348);
             SetColor (LightGreen);
             OutTextXy (33,338,'ON');
          End
          Else Begin
               H:=False;
               Bar (4,330,62,348);
               SetColor (LightRed);
               OutTextXy (33,338,'OFF');
          End;
     End;
End;

{****************************************************************************}

Procedure IndicaFreq (FA:Real;FB:Real;FC:Real;FD:Real;FE:Real;FF:Real;FG:Real;
                     FH:Real);
{Mostra os valores de frequˆncia dos canais ativos
   FA a FH = Valores calculados pelo frequenc¡metro}

Var Valor:String; {Armazena o valor da frequˆncia em string}

Begin
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor (Cyan);
     SetFillStyle (0,0);
     Y:=40;
     Repeat
           Bar (576,Y,634,Y+20);
           Y:=Y+40;
     Until Y>320;
     If A=True Then Begin
        Str (FA:8:3,Valor);
        OutTextXy (605,50,Valor);
     End;
     If B=True Then Begin
        Str (FB:8:3,Valor);
        OutTextXy (605,90,Valor);
     End;
     If C=True Then Begin
        Str (FC:8:3,Valor);
        OutTextXy (605,130,Valor);
     End;
     If D=True Then Begin
        Str (FD:8:3,Valor);
        OutTextXy (605,170,Valor);
     End;
     If E=True Then Begin
        Str (FE:8:3,Valor);
        OutTextXy (605,210,Valor);
     End;
     If F=True Then Begin
        Str (FF:8:3,Valor);
        OutTextXy (605,250,Valor);
     End;
     If G=True Then Begin
        Str (FG:8:3,Valor);
        OutTextXy (605,290,Valor);
     End;
     If H=True Then Begin
        Str (FH:8:3,Valor);
        OutTextXy (605,330,Valor);
     End;
End;

{****************************************************************************}

Procedure IndicEscala;
{Indica a escala atual de varredura horizontal}

Var ValEscala:String; {Armazena o valor da escala em string}
    ValFator:String; {Armazena o fator de multiplica‡Æo em string}

Begin
     SetColor (Cyan);
     SetTextJustify (LeftText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     If Round(Escala*Fator)=100000 Then Begin
        Str (Fator:2,ValFator);
        ValEscala:='EXT/'+ValFator;
     End
     Else Str (Escala:7:1,ValEscala);
     SetFillStyle(0,0);
     Bar (TextWidth('Escala Horizontal: '),15,
          3+TextWidth('Escala Horizontal:  ')+40,25);
     OutTextXy (3+TextWidth('Escala Horizontal: '),20,ValEscala);
End;

{****************************************************************************}

Procedure IndicSync;
{Indica o Canal Base de Sync}

Begin
     SetColor (Cyan);
     SetTextJustify (LeftText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     SetFillStyle(0,0);
     Bar (200+TextWidth('-  Canal base de Sincronismo: '),15,
          200+TextWidth('-  Canal base de Sincronismo: ')+5,25);
     OutTextxy (200+TextWidth('-  Canal base de Sincronismo: '),20,CanalSync);
End;

{****************************************************************************}

Procedure IndicZoom;
{Indica o valor do Zoom}

Var FtStr:String; {Armazena o fator de multiplica‡Æo em string}

Begin
      SetFillStyle(0,0);
      SetTextStyle (SmallFont,HorizDir,4);
      SetTextJustify (RightText,CenterText);
      SetColor (White);
      Bar (639-TextWidth('              Pressione F1 para Ajuda '),15,
           639-TextWidth('  Pressione F1 para Ajuda '),25);
      Str (Fator:1,FtStr);
      OutTextxy (639-TextWidth('         Pressione F1 para Ajuda '),20,
                '-  Zoom: ');
      SetColor (Cyan);
      OutTextxy (639-TextWidth('       Pressione F1 para Ajuda '),
                 20,FtStr);
End;

{****************************************************************************}

Procedure MudaSync;
{Altera o canal base de Sync}

Begin
     Port[P2]:=StatusPort Xor $40;
     Port[P2]:=StatusPort;
     If CanalSync='H' Then CanalSync:='A'
     Else If CanalSync='A' Then CanalSync:='B'
     Else If CanalSync='B' Then CanalSync:='C'
     Else If CanalSync='C' Then CanalSync:='D'
     Else If CanalSync='D' Then CanalSync:='E'
     Else If CanalSync='E' Then CanalSync:='F'
     Else If CanalSync='F' Then CanalSync:='G'
     Else If CanalSync='G' Then CanalSync:='H';
     IndicSync;
End;

{****************************************************************************}

Procedure MudaEscala;
{Muda a escala de uS/div}

Var FatEsc:Real; {Armazena a escala * fator}

Begin
     Port[P2]:=StatusPort Xor $4;
     Port[P2]:=StatusPort;
     FatEsc:=Escala*Fator;
     If FatEsc=100e3 Then Escala:=Escala/100e3
     Else Escala:=Escala*10;
     IndicEscala;
End;

{****************************************************************************}

Procedure DivEscala;
{Zoom X1, X2, X5 ou X10}

Begin
     If Fator=1 Then Begin
        Fator:=2;
        Escala:=(Escala/2);
        FimPonto:=Round(FimPonto/2);
     End
     Else If Fator=2 Then Begin
          Fator:=5;
          Escala:=((Escala*2)/5);
          FimPonto:=Round((FimPonto*2)/5);
     End
     Else If Fator=5 Then Begin
          Fator:=10;
          Escala:=((Escala*5)/10);
          FimPonto:=Round((FimPonto*5)/10);
     End
     Else Begin
          Fator:=1;
          Escala:=Escala*10;
          FimPonto:=510;
     End;
     IndicZoom;
     IndicEscala;
     Zoom:=False;
End;

{****************************************************************************}

Procedure FimProg;
{Finaliza a execu‡Æo do Programa}

Begin
     CloseGraph;
     Textcolor (LightGray);
     TextBackGround (Black);
     Writeln;
     Port[P1]:=$00; {Desliga a Porta Paralela}
     Halt(0);
End;

{****************************************************************************}

Procedure GravaArq;
{Grava as formas de onda em um arquivo .OSC}

Var SobreGrava:Boolean; {Verifica se sobreescreve o arquivo}
    Io:Boolean; {Retorna o resultado da opera‡Æo de I/O}
    OffCan,OnCan, {Status dos canais (On/Off)}
    DadoLido:Char; {Dado lido da Interface em formato Char}
    DadoEsc:Byte; {Representa o valor da escala}
    Tecdo:Char; {Armazena caracter lido do teclado}
    PP:Integer; {Utilizada pelo contador For para apagar as linhas da tela}

Label DigitNovam; {Digitar novamente o nome-de-arquivo}
Label EscOutNome; {Escolher outro nome-de-arquivo}

Procedure Jaexiste;
{J  existe um arquivo .OSC com o mesmo nome}

Var Teclado:Char; {Armazena caracter lido do teclado}
    PQ:Integer;  {Utilizada pelo contador For para apagar as linhas da tela}

Begin
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PQ:=2 To 60 Do Begin
         Gotoxy (PQ,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackGround (Cyan);
     CenterTxt (9,'O arquivo j  existe!');
     CenterTxt (14,'(S)im ou (N)Æo');
     TextColor (White);
     CenterTxt (12,'Substituir o arquivo existente?');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Escolha a op‡Æo: S ou N');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     Sobregrava:=False;
Repeat
     Teclado:=Readkey;
     Teclado:=Upcase(Teclado);
Until (Teclado='S') Or (Teclado='N');
     If Teclado='S' Then Sobregrava:=True
     Else Sobregrava:=False;
End;

Procedure ErroIO;
{Mensagem: Erro de I/O}

Var PQ:Integer;  {Utilizada pelo contador For para apagar as linhas da tela}

Begin
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PQ:=2 To 60 Do Begin
         Gotoxy (PQ,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (50,10,White,Cyan);
     CenterWin (50,10,White,Cyan);
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackGround (Cyan);
     CenterTxt (9,'Houve um erro na Grava‡Æo');
     CenterTxt (10,'do Arquivo!');
     TextColor (White);
     CenterTxt (12,'Pressione Enter para Continuar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Pressione Enter para Continuar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      TecDo:=Readkey;
Until TecDo=#13;
End;

Procedure Gravacao;
{Grava‡Æo do arquivo .OSC}

Var PTec:Char; {Armazena caracter lido do teclado}
    Num,Num2:Integer; {Representam coordenadas no array de descri‡äes}
    PQ:Integer;  {Utilizada pelo contador For para apagar as linhas da tela}

Procedure Descricao (YValue:Integer);
{Permite o recolhimento de descri‡Æo
         YValue = Numero da descri‡Æo}

Var Cont:Integer; {N£mero do caracter a ser escrito no array de descri‡Æo}
    X1,Y1:Integer; {Armazenam posi‡Æo atual do cursor}

Begin
     TextColor (Yellow);
     TextBackGround (Cyan);
     X1:=WhereX; Y1:=WhereY;
     Cont:=1;
Repeat
         PTec:=Readkey;
         PTec:=Upcase(PTec);
         If PTec=#13 Then Break;
         If (PTec=#8) And (Cont>1) Then Begin
            Cont:=Cont-1;
            Descr[Cont,YValue]:=#0;
            X1:=X1-1;
            GotoXy (X1,Y1);
            Write (' ');
            GotoXy (X1,Y1);
          End;
          If PTec<>#8 Then Begin
              Descr[Cont,YValue]:=PTec;
              Write (PTec);
              X1:=X1+1;
              Cont:=Cont+1;
         End;
         If Cont=11 Then Begin
            Repeat
                  PTec:=Readkey;
            Until (PTec=#13) Or (PTec=#8);
            If PTec=#8 Then Begin
               Cont:=Cont-1;
               Descr[Cont,YValue]:=#0;
               X1:=X1-1;
               GotoXy (X1,Y1);
               Write (' ');
               GotoXy (X1,Y1);
            End;
         End;
Until Cont>10;
End;

Begin
     Window (1,1,80,25);
     TextBackground (White);
     TextColor (Black);
     For PQ:=2 To 60 Do Begin
         Gotoxy (PQ,24);
         Write (' ');
     End;

     ApagaWin;
     AmpliaWin (60,15,White,Cyan);
     CenterWin (60,15,White,Cyan);
     Window (1,1,80,25);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (5,'Digite a Descri‡Æo para o Conjunto de Formas de Onda:');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite as Descri‡äes - M ximo 10 Caracteres cada');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     Window (1,1,80,25);
     Gotoxy (35,7);
     Descricao (0);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (9,'Digite a Descri‡Æo para cada Canal:');
     CenterTxt (11,'A = '+'          ');
     CenterTxt (12,'B = '+'          ');
     CenterTxt (13,'C = '+'          ');
     CenterTxt (14,'D = '+'          ');
     CenterTxt (15,'E = '+'          ');
     CenterTxt (16,'F = '+'          ');
     CenterTxt (17,'G = '+'          ');
     CenterTxt (18,'H = '+'          ');
     For Num:=1 To 8 Do Begin
         GotoXy (38,Num+10);
         Descricao (Num);
     End;

     {Identificador do arquivo: Bytes 0 a 2}
     OnCan:='P';
     Write (Arq,OnCan);
     OnCan:='E';
     Write (Arq,OnCan);
     OnCan:='P';
     Write (Arq,OnCan);

     {Descri‡äes: Bytes 3 a 92}
     For Num2:=0 To 8 Do Begin
         For Num:=1 To 10 Do Write (Arq,Descr[Num,Num2]);
     End;

     {Status dos canais: Bytes 93 a 100}
     OnCan:=Chr(1);
     OffCan:=Chr(0);
     If A Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If B Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If C Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If D Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If E Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If F Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If G Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);
     If H Then Write (Arq,OnCan)
     Else Write (Arq,OffCan);

     {Escala Horizontal: Byte 101}
     If Escala*Fator=1 Then DadoEsc:=0
     Else If Escala*Fator=10 Then DadoEsc:=1
     Else If Escala*Fator=100 Then DadoEsc:=2
     Else If Escala*Fator=1000 Then DadoEsc:=3
     Else If Escala*Fator=10000 Then DadoEsc:=4
     Else If Escala*Fator=100e3 Then DadoEsc:=5;
     OnCan:=Chr(DadoEsc);
     Write (Arq,OnCan);

     {Dados - 512 Bytes: Bytes 102 a 614}
     For Num:=0 To 511 Do Begin
         DadoLido:=Chr(Dado[Num]);
         Write (Arq,DadoLido);
     End;
End;

Begin
     CloseGraph;
     Tela('Analisador L¢gico');
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (9,'Utilit rio de Grava‡Æo');
     CenterTxt (10,'de Arquivos do');
     CenterTxt (11,'Analisador L¢gico');
     TextColor (White);
     CenterTxt (14,'"Os PEP Legais"');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter para Continuar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      TecDo:=Readkey;
Until TecDo=#13;

Repeat

EscOutNome:
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
     CenterTxt (8,'Digite o nome do arquivo a ser gravado');
     CenterTxt (9,'(com caminho completo, se necess rio e');
     CenterTxt (10,'sem extensÆo - ExtensÆo padrÆo: .OSC):');
     CenterTxt (15,'Pressione somente Enter para Cancelar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite o nome do arquivo sem extensÆo / Enter: Cancela');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

DigitNovam:
     Io:=False;
     SobreGrava:=True;
     TextColor (Yellow);
     TextBackGround (Cyan);
     CenterTxt (12,'                                              ');
     Gotoxy (25,12);
     Readln (NameArq);
     If NameArq = '' Then Break;
     Assign (Arq,NameArq+'.OSC');
{$I-}
     Reset(Arq);
{$I+}
     If IoResult = 0 Then Jaexiste;
     If Not Sobregrava Then Goto EscOutNome;
{$I-}
     Rewrite (Arq);
{$I+}
     If IoResult <> 0 Then ErroIO
     Else Io:=True;
Until Io;

     If Io Then Begin
        Gravacao;
        Close (Arq);
     End;
     ModoGrafico;
     SetColor(White);
     SetTextStyle (SmallFont,HorizDir,5);
     SetTextJustify (CenterText,CenterText);
     OutTextxy(319,160,'Pressione F5 para retornar a Tela Principal...');
     OutTextxy(319,190,
     'Pressione F6 para retornar ao Utilit rio de Gravacao de Arquivos...');
End;

{****************************************************************************}

Procedure Pausar;
{Paralisa a tela em uso}

Var Tec:Char; {Armazena caracter lido do teclado}

Begin
      If Ap=1 Then Begin
         Ap:=0;
         SetActivepage(0);
      End
      Else Begin
           Ap:=1;
           SetActivePage(1);
      End;
      Bar (610-TextWidth('              Pressione F1 para Ajuda '),15,
           639-TextWidth('  Pressione F1 para Ajuda '),25);
      SetFillStyle(0,0);
      SetTextStyle (SmallFont,HorizDir,4);
      SetTextJustify (RightText,CenterText);
      SetColor (LightRed);
      OutTextxy (639-TextWidth('      Pressione F1 para Ajuda '),20,'Pausado');
Repeat
      If Keypressed Then Begin
         Tec:=Readkey;
         If Tec=#0 Then Begin
            Tec:=Readkey;
            If Tec=#63 Then Break {F5}
            Else If Tec=#64 Then GravaArq; {F6}
         End;
      End;
Until Pausa=False; {Nunca acontecer }
      Pausa:=False;
      SetFillStyle (0,0);
      Bar (639-TextWidth('  Pressione F1 para Ajuda ')-80,15,
           639-TextWidth('  Pressione F1 para Ajuda '),25);
      If Ap=1 Then Begin
         Ap:=0;
         SetActivepage(0);
         SetVisualPage(1);
      End
      Else Begin
           Ap:=1;
           SetActivePage(1);
           SetVisualPage(0);
      End;
End;

{****************************************************************************}

Procedure Help;
{Mostra a tela de ajuda}

Var TecHelp:Char; {Armazena caracter lido do teclado}

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
     OutTextXy (320,103,'Ajuda do Analisador L¢gico');
     SetColor(Magenta);
     SetTextStyle (SmallFont,HorizDir,5);
     OutTextxy(320,120,'Os PEP Legais');
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor(Black);
     OutTextxy(320,140,'Esc = Sai do Programa');
     OutTextxy(320,152,'A,B,C,D,E,F,G,H = Liga/Desliga Canal');
     OutTextxy(320,164,'F1 = Ajuda');
     OutTextxy(320,176,'F2 = Seleciona a Escala Horizontal (uS/Div)');
     OutTextxy(320,188,'F3 = Zoom Horizontal (1, 2, 5, 10)');
     OutTextxy(320,200,'F4 = Seleciona o Canal Base de Sincronismo');
     OutTextxy(320,212,'F5 = Paralisa a Tela Atual');
     OutTextxy(320,224,'F6 = Salva Formas de Onda em Arquivo');
     SetColor(Red);
     OutTextxy(320,240,'Pressione Enter para Fechar esta Janela');

Repeat
      TecHelp:=Readkey;
Until TecHelp=#13;

     If Ap=1 Then Begin
        SetActivePage(0);
        Ap:=0;
     End
     Else Begin
          SetActivePage(1);
          Ap:=1;
     End;

     Ajuda:=False;
End;

{****************************************************************************}

Procedure VerifTecla;
{Verifica qual Tecla foi pressionada}

Var Tecla:Char; {Armazena caracter lido do teclado}

Procedure VerifASCII;
{Verifica teclas extendidas}

Begin
     Tecla:=Readkey;
     If Tecla=#59 Then Ajuda:=True {F1}
     Else If Tecla=#60 Then MudaEscala {F2}
     Else If Tecla=#61 Then Zoom:=True {F3}
     Else If Tecla=#62 Then MudaSync {F4}
     Else If Tecla=#63 Then Pausa:=True {F5}
                                         {GravaArq = F6}
End;

Begin
     Tecla:=Readkey;
     Tecla:=Upcase(Tecla);
     If Tecla=#27 Then FimProg {Esc}
     Else If Tecla='A' Then Begin
          If A Then IndicCanal('A',False)
          Else IndicCanal ('A',True);
     End
     Else If Tecla='B' Then Begin
          If B Then IndicCanal('B',False)
          Else IndicCanal ('B',True);
     End
     Else If Tecla='C' Then Begin
          If C Then IndicCanal('C',False)
          Else IndicCanal ('C',True);
     End
     Else If Tecla='D' Then Begin
          If D Then IndicCanal('D',False)
          Else IndicCanal ('D',True);
     End
     Else If Tecla='E' Then Begin
          If E Then IndicCanal('E',False)
          Else IndicCanal ('E',True);
     End
     Else If Tecla='F' Then Begin
          If F Then IndicCanal('F',False)
          Else IndicCanal ('F',True);
     End
     Else If Tecla='G' Then Begin
          If G Then IndicCanal('G',False)
          Else IndicCanal ('G',True);
     End
     Else If Tecla='H' Then Begin
          If H Then IndicCanal('H',False)
          Else IndicCanal ('H',True);
     End
     Else If Tecla=#0 Then VerifASCII;
End;

{****************************************************************************}

Procedure TelaPrinc;
{Desenha a tela principal do programa}

Begin
     {T¡tulo}
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     SetTextStyle (Smallfont,HorizDir,5);
     SetFillStyle (1,Blue);
     Bar (0,0,639,12);
     OutTextxy (320,4,'Analisador L¢gico');

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

     {Nomes dos canais}
     SetTextStyle (SmallFont,HorizDir,7);
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     OutTextXy (33,40,'A');
     OutTextXy (33,80,'B');
     OutTextXy (33,120,'C');
     OutTextXy (33,160,'D');
     OutTextXy (33,200,'E');
     OutTextXy (33,240,'F');
     OutTextXy (33,280,'G');
     OutTextXy (33,320,'H');

     {Status dos Canais}
     IndicCanal ('A',A);
     IndicCanal ('B',B);
     IndicCanal ('C',C);
     IndicCanal ('D',D);
     IndicCanal ('E',E);
     IndicCanal ('F',F);
     IndicCanal ('G',G);
     IndicCanal ('H',H);

     If Keypressed Then VerifTecla;

     {Nomes dos Frequenc¡metros dos Canais}
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

     {Indicador de escala horizontal / Zoom e Canal de Sync / e Help}
     SetColor (White);
     SetTextJustify (LeftText,CenterText);
     SetTextStyle (SmallFont,HorizDir,4);
     OutTextXy (3,20,'Escala Horizontal: ');
     OutTextxy (TextWidth('Escala Horizontal:   ')+40,20,'uS/div');
     OutTextxy (200,20,'- Canal base de Sincronismo: ');
     SetTextJustify (RightText,CenterText);
     OutTextxy (639,20,'Pressione F1 para Ajuda ');
     IndicEscala;
     IndicSync;
End;

{****************************************************************************}

Procedure VerifIntface;
{Verifica se a Interface est  conectada corretamente ao Microcomputador}

Procedure MensErro;
{Mensagem de Erro: Interface nÆo detectada}

Begin
        Port[P1]:=$00; {Desliga a Porta Paralela}
        CloseGraph;
        TextBackGround (Black);
        ClrScr;
        TextColor (Blue);
        Writeln ('Analisador L¢gico - Mensagem de Erro');
        Writeln;
        TextColor (LightRed);
        Writeln ('A Interface nÆo est  conectada corretamente!');
        Writeln ('Verifique as conexäes e a alimenta‡Æo da Interface!');
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

Begin
     If HabilVerif Then Begin
        Port[P2]:=$22; {0010 0010 - Reset/RD/ClrSync}
        Delay(10);
        If (Port[P2] And $20) Shr 5 = 1 Then MensErro; {Fim=1 > Erro}
     End;
End;

{****************************************************************************}

Procedure AtualizaEscSync;
{Atualiza a escala/canal base de sync para reset de escala simultƒneo ao}
{reset do endere‡ador}

Var EscAt:Integer; {Escala a ser modificada}
    Vezes:Integer; {N£mero de pulsos enviados para atualizar escala/sync}

Procedure AlteraPortEsc;
{Produz um pulso no SelHoriz}

Begin
     Port[P2]:=StatusPort Xor $4; {SelHoriz}
     Port[P2]:=StatusPort;
End;

Procedure AlteraPortSync;
{Produz um pulso no SelSync}

Begin
     Port[P2]:=StatusPort Xor $40; {SelSync}
     Port[P2]:=StatusPort;
End;

Begin
     EscAt:=Round(Escala*Fator);
     If EscAt=10 Then AlteraPortEsc
     Else If EscAt=100 Then Begin
          For Vezes:=1 To 2 Do AlteraPortEsc;
     End
     Else If EscAt=1000 Then Begin
          For Vezes:=1 To 3 Do AlteraPortEsc;
     End
     Else If EscAt=10000 Then Begin
          For Vezes:=1 To 4 Do AlteraPortEsc;
     End
     Else If EscAt=100e3 Then Begin
          For Vezes:=1 To 5 Do AlteraPortEsc;
     End;

     If CanalSync='B' Then AlteraPortSync
     Else If CanalSync='C' Then Begin
          For Vezes:=1 To 2 Do AlteraPortSync;
     End
     Else If CanalSync='D' Then Begin
          For Vezes:=1 To 3 Do AlteraPortSync;
     End
     Else If CanalSync='E' Then Begin
          For Vezes:=1 To 4 Do AlteraPortSync;
     End
     Else If CanalSync='F' Then Begin
          For Vezes:=1 To 5 Do AlteraPortSync;
     End
     Else If CanalSync='G' Then Begin
          For Vezes:=1 To 6 Do AlteraPortSync;
     End
     Else If CanalSync='H' Then Begin
          For Vezes:=1 To 7 Do AlteraPortSync;
     End;
End;

{****************************************************************************}

Procedure WriteDados;
{Permite a grava‡Æo das formas de onda pela Interface}

Begin
     Port[P2]:=$22; {0010 0010 - Reset/ClrSync/RD}
     VerifIntface;
     Port[P2]:=$A3; {1010 0011 - WR/ClrSync}
     StatusPort:=$A3;
     If HabilAtuEscSync Then AtualizaEscSync;
     StatusPort:=$B3;
     Port[P2]:=$B3; {1011 0011 - WR - Start}
     GetTime (Hr,M,S,S100);
     Timea:=S100+S*100+M*6E3+Hr*360E3;

Repeat
      If Keypressed Then VerifTecla;
      GetTime (Hr,M,S,S100);                    {Aguarda resposta at‚ 600mS}
      If ((S100+S*100+M*6E3+Hr*360E3)-Timea > 60) And (HabilSyncOff) Then Begin
         Port[P2]:=$B1;  {1011 0001 - WR /PresetSync}
         StatusPort:=$B1;               {Se nÆo h  resposta, desliga Sync}
      End;
Until ((Port[P2] And $20) Shr 5 = 1) Or
      ((S100+S*100+M*6E3+Hr*360E3)-Timea > 100); {Espera o sinal Fim at‚ 1s}

End;

{****************************************************************************}

Procedure ReadDados;
{Lˆ os dados a partir da Interface}

Begin
     VerifIntface;
     Port[P2]:=$32; {0011 0010 - RD/Reset}
     Port[P2]:=$33; {0011 0011 - RD}
     StatusPort:=$33;

     For IndDado:=0 To 511 Do Begin
         Port[P2]:=$3B; {0011 1011 - RD/ClkRD}
         Port[P2]:=$33; {0011 0011 - RD}
         Port[P1]:=$FF;
         Dado[IndDado]:=Port[P1];
         Port[P2]:=StatusPort;
         Delay (1);
         If Keypressed Then VerifTecla;
         End;
End;

{****************************************************************************}

Procedure MostraDados;
{Plota na Tela as Formas de Onda dos canais ativos}

Var YPlota:Integer; {Coordenada Y da forma-de-onda a ser plotada}
    CanalByte:Integer; {Identifica qual canal a ser plotado}

Procedure Plota;
{Plota as formas-de-onda na tela}

Var Ct:Integer; {N£mero de vezes que se repetir  a plotagem do dado}

Begin
        For IndDado:=1 To FimPonto Do Begin
            For Ct:=1 To Fator Do Begin

                PutPixel ((Ct-Fator)+(IndDado*Fator)+64,
                      (((Dado[IndDado] And Eleva(2,CanalByte))
                      Shr CanalByte) Xor 1)*32+YPlota+3,LightGreen);

                PutPixel ((Ct-Fator)+(IndDado*Fator)+64,
                      (((Dado[IndDado] And Eleva(2,CanalByte))
                      Shr CanalByte) Xor 1)*34+YPlota+2,LightGreen);

                If Keypressed Then VerifTecla;
            End;
        End;
End;

Begin
     If A Then Begin
        YPlota:=30;
        CanalByte:=0;
        Plota;
     End;
     If B Then Begin
        CanalByte:=1;
        YPlota:=70;
        Plota;
     End;
     If C Then Begin
        YPlota:=110;
        CanalByte:=2;
        Plota;
     End;
     If D Then Begin
        CanalByte:=3;
        YPlota:=150;
        Plota;
     End;
     If E Then Begin
        YPlota:=190;
        CanalByte:=4;
        Plota;
     End;
     If F Then Begin
        YPlota:=230;
        CanalByte:=5;
        Plota;
     End;
     If G Then Begin
        YPlota:=270;
        CanalByte:=6;
        Plota;
     End;
     If H Then Begin
        CanalByte:=7;
        YPlota:=310;
        Plota;
     End;
End;

{****************************************************************************}

Procedure Frequenc;
{Calcula as frequˆncias dos canais}

Var FrA,FrB,FrC,FrD,FrE,FrF,FrG,FrH:Real; {Armazenam as frequˆncias dos canais}
    Pontos:Integer; {N£mero de pontos em um estado l¢gico}
    Dc:Boolean; {Identifica sinal cont¡nuo constante}

Procedure MedeFreq (CanBit:Integer);
{Medidor de Frequˆncia
  CanBit = Indica qual o canal}

Begin
     IndDado:=0;
     Pontos:=0;
     Dc:=False;
Repeat
      IndDado:=IndDado+1;
Until ((Dado[IndDado] And Eleva(2,CanBit)) Shr CanBit =1) Or (IndDado=511);

Repeat
      IndDado:=IndDado+1;
Until ((Dado[IndDado] And Eleva(2,CanBit)) Shr CanBit =0) Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

      If Keypressed Then VerifTecla;

Repeat
      IndDado:=IndDado+1;
      Pontos:=Pontos+1;
Until ((Dado[IndDado] And Eleva(2,Canbit)) Shr CanBit =1) Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

Repeat
      IndDado:=IndDado+1;
      Pontos:=Pontos+1;
Until ((Dado[IndDado] And Eleva(2,CanBit)) Shr CanBit =0) Or (IndDado=511);
      If IndDado>=511 Then Dc:=True;

End;

Begin
     MedeFreq (0);
     If Dc Then FrA:= 0
     Else FrA:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (1);
     If Dc Then FrB:= 0
     Else FrB:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (2);
     If Dc Then FrC:= 0
     Else FrC:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (3);
     If Dc Then FrD:= 0
     Else FrD:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (4);
     If Dc Then FrE:= 0
     Else FrE:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (5);
     If Dc Then FrF:= 0
     Else FrF:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (6);
     If Dc Then FrG:= 0
     Else FrG:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     MedeFreq (7);
     If Dc Then FrH:= 0
     Else FrH:=(1/(Pontos*(Escala*1e-7))/1e3)/Fator;

     IndicaFreq (FrA,FrB,FrC,FrD,FrE,FrF,FrG,FrH);
End;

{****************************************************************************}

Procedure InitDefault;
{Seta as vari veis para o Default}

Begin
     {Status inicial dos canais: True}
     A:=True; B:=True; C:=True; D:=True; E:=True; F:=True; G:=True; H:=True;
     {Escala inicial: 1uS/div}
     Escala:=1;
     FimPonto:=510;
     Fator:=1;
     {Canal Base de Sync inicial: Canal A}
     CanalSync:='A';
     {Seta P gina de V¡deo Ativa como 1 e visual como 0}
     SetActivePage(1);
     SetVisualPage(0);
     Ap:=1;
End;

{****************************************************************************}

Begin
     AbreCfg;
     VerifArq;
     Clrscr;
     Port[P2]:=$22; {0010 0010 - Reset/RD/ClrSync}
     ModoGrafico;
     VerifIntface;
     InitDefault;
     Apres;

Repeat
     If Zoom Then DivEscala;
     If Ajuda Then Help;
     If Pausa Then Pausar;
     Delay(10);
     SetFillStyle(0,0);
     Bar (0,30,639,349);
     TelaPrinc;
     WriteDados;
     ReadDados;
     MostraDados;
     Frequenc;
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
     IndicZoom;
Until IndDado=1000; {IndDado=1000 ‚ imposs¡vel de ocorrer}
End.

{****************************************************************************}
{
        * Estrutura dos arquivos .PEP *

Bytes 0 a 2 = Quantidade de pixels da cor indicada no pr¢ximo Byte
Byte 3 = Cor do pixel

(Repete-se essa sequˆncia at‚ o final do arquivo)

}
{****************************************************************************}
