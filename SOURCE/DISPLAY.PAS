{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compilaá∆o}

{****************************************************************************}

Program Display;

{****************************************************************************}
{
        Analisador L¢gico - "Os PEP Legais"

        CrÇditos:
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
                   Display - Visualizador de dados BIN/HEX/DEC;
                             Para sincronismo externo

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

Uses Crt,Graph,Dos,PEPUnit;
{Units a serem utilizadas}

{****************************************************************************}

Var
    Tecla:Char; {Armazena Tecla lida}
    Ap:Integer; {P†gina de v°deo ativa}
    Ga,Dw,St,Help,TOut:Boolean; {Definem as funá‰es chamadas pelo teclado}
    TimeOut:Integer; {Tempo de espera pela Interface}
    TOt: Array [1..4] Of Char; {Recolhe o valor de TimeOut}
    HabilVerif:Boolean; {Habilitaá∆o da verificaá∆o da Presenáa da Interface}
    P1,P2:Word; {Endereáo da porta (Dados/Controle)}
    IndDado:Integer; {Indica a posiá∆o do dado}
    Dado:Array [0..511] Of Byte; {Armazena os dados lidos}
    Cur:Integer; {Define o cursor}

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
     Writeln ('PEPDisplay - Mensagem de Erro');
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
     If Not ArqPres('ALOGIC.CFG') Then MensErroArq('ALOGIC.CFG');
     If Not ArqPres('CONFIG.EXE') Then MensErroArq('CONFIG.EXE');
     If Not ArqPres('EGAVGA.BGI') Then MensErroArq('EGAVGA.BGI');
     If Not ArqPres('LITT.CHR') Then MensErroArq('LITT.CHR');
     If Not ArqPres('APRES2.PEP') Then MensErroArq('APRES2.PEP');
     If Not ArqPres('APRES4.PEP') Then MensErroArq('APRES2.PEP');
     If Not ArqPres('APRES6.PEP') Then MensErroArq('APRES2.PEP');
End;

{****************************************************************************}

Procedure AbreCfg;
{Abre o arquivo ALogic.Cfg}

Var HV,HS:Byte; {Habilita Verificaá∆o e Habilita desligamento de Sync}
    Cfg:Text; {Representa o arquivo de configuraá∆o}

Begin
     Assign (Cfg,'ALogic.Cfg');
     Reset (Cfg);
     Readln (Cfg,P1,HV,HS);
     P2:=P1;

     If HV=1 Then HabilVerif:=True
     Else HabilVerif:=False;
     Close (Cfg);
End;

{****************************************************************************}

Procedure Apres;
{Exibe as telas de apresentaá∆o do programa}

Var ApresTec:Char; {Valor da tecla pressionada durante a apresentaá∆o}
    TempoDelay:Longint; {Delay dado ap¢s a £ltima apresentaá∆o}

Begin
     SetActivePage(0);
     SetVisualPage(0);
     SetTextStyle (SmallFont,HorizDir,4);
     SetTextJustify (CenterText,CenterText);
     SetColor (White);
     OutTextxy (320,175,'Carregando Tela de Apresentacao. Aguarde...');
     SetActivePage(1);
     Ap:=1;
     ApresTec:=ViewPEP('APRES6.PEP',1,0,True);
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
     ApresTec:=ViewPEP('APRES4.PEP',Ap,0,True);
     If ApresTec<>#27 Then Begin
        SetVisualPage(1);
        SetActivePage(0);
        Ap:=0;
     End;
     For TempoDelay:=0 To 500000 Do Begin
         If Keypressed Then ApresTec:=Readkey;
         If (ApresTec=#13) Or (ApresTec=#27) Then Break;
     End;
     SetActivePage(1);
     ClearDevice;
     SetActivePage(0);
     ClearDevice;
     SetVisualPage(0);
     SetActivePage(1);
     Ap:=1;
End;

{****************************************************************************}

Procedure FimProg;
{Finaliza o programa}

Begin
     TextColor (LightGray);
     TextBackGround (Black);
     Clrscr;
     Writeln;
     Port[P1]:=$00; {Desliga a Porta Paralela}
     Halt(0);
End;

{****************************************************************************}

Procedure Ajuda;
{Tela de ajuda dos comandos}

Begin
     SetFillStyle(1,0);
     Bar (130,110,530,260);
     SetFillStyle(1,15);
     Bar (120,100,520,250);
     SetLineStyle(0,1,0);
     SetColor(8);
     Rectangle (120,100,520,250);
     SetLineStyle(0,1,0);
     SetFillStyle (1,1);
     Bar (121,101,519,114);
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     OutTextxy (320,107,'Ajuda do PEPDisplay');
     SetColor (Black);
     OutTextxy (320,130,'ESC = Sai do Programa');
     OutTextxy (320,142,'F1 = Ajuda');
     OutTextxy (320,154,'F2 = Altera o valor do Time Out');
     OutTextxy (320,166,'F3 = Inicia a Aquisicao de Dados');
     OutTextxy (320,178,'F4 = Importa Dados de Arquivo .OSC');
     OutTextxy (320,190,'F5 = Grava Dados em Arquivo');
     OutTextxy (320,202,'Setas de Direcao = Movem o Cursor');
     OutTextxy (320,230,'Pressione ENTER para fechar esta janela');

Repeat
Until Readkey=#13;
     Help:=False;
End;

{****************************************************************************}

Procedure AltTO;
{Altera o Time Out}

Var CTout:Integer; {Valor do Time Out}
    Tec:Char; {Caracter lido do teclado}
    Code:Integer; {Resultado da convers∆o String => Integer}
    TOStr:String; {Time Out em formato String}

Begin
     SetFillStyle(1,0);
     Bar (130,110,530,260);
     SetFillStyle(1,15);
     Bar (120,100,520,250);
     SetLineStyle(0,1,0);
     SetColor(8);
     Rectangle (120,100,520,250);
     SetLineStyle(0,1,0);
     SetFillStyle (1,1);
     Bar (121,101,519,114);
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     OutTextxy (320,107,'Alteracao do valor do TIME OUT');
     SetColor (Black);
     OutTextxy (320,150,'Digite o valor do Time Out (10 a 9999ms):');
     SetTextStyle (SmallFont,HorizDir,6);
     Str(TimeOut:0,TOStr);
     If Length(TOStr)=2 Then TOStr:='00'+TOStr
     Else If Length(TOStr)=3 Then TOStr:='0'+TOStr;
     OutTextxy (310,200,ToStr+' mS');
     SetFillStyle (1,15);
     CTout:=1;

Repeat
Repeat
Repeat
      Tec:=Readkey;
Until (Tec='0') Or (Tec='1') Or (Tec='2') Or (Tec='3') Or (Tec='4') Or
      (Tec='5') Or (Tec='6') Or (Tec='7') Or (Tec='8') Or (Tec='9') Or
      (Tec=#13);
      If Tec<>#13 Then Begin
         TOt[CTout]:=Tec;
         If CTout=1 Then Begin
            Bar (275,195,283,210);
            OutTextxy (310,200,Tec+'      ');
         End
         Else If CTout=2 Then Begin
            Bar (283,195,292,210);
            OutTextxy (310,200,' '+Tec+'     ');
         End
         Else If CTout=3 Then Begin
            Bar (293,195,303,210);
            OutTextxy (310,200,'  '+Tec+'    ');
         End
         Else If CTout=4 Then Begin
            Bar (303,195,313,210);
            OutTextxy (310,200,'   '+Tec+'   ');
         End;
         CTout:=CTout+1;
         If CTout=5 Then CTout:=1;
      End;
Until (Tec=#13);
     Val(Tot[1]+Tot[2]+Tot[3]+Tot[4],TimeOut,Code);
Until (TimeOut>=10) And (TimeOut<=9999);
     TOut:=False;
End;

{****************************************************************************}

Procedure VerifIntface;
{Verifica se a Interface est† conectada corretamente ao Microcomputador}

Procedure MensErro;
{Mensagem de Erro: A Interface n∆o foi detectada}

Begin
     SetFillStyle(1,0);
     Bar (130,110,530,260);
     SetFillStyle(1,15);
     Bar (120,100,520,250);
     SetLineStyle(0,1,0);
     SetColor(8);
     Rectangle (120,100,520,250);
     SetLineStyle(0,1,0);
     SetFillStyle (1,1);
     Bar (121,101,519,114);
     SetTextStyle (SmallFont,HorizDir,4);
     SetColor (White);
     SetTextJustify (CenterText,CenterText);
     OutTextxy (320,107,'Erro ao comunicar com Interface');
     SetColor (Red);
     SetTextStyle (SmallFont,HorizDir,5);
     OutTextxy (320,140,'A Interface nao foi encontrada pelo PEPDisplay!');
     SetColor (Black);
     SetTextStyle (SmallFont,HorizDir,4);
     OutTextxy (320,170,'Verifique as conexoes e a alimentacao do Interface.');
     OutTextxy (320,190,'Caso nao consiga solucionar o problema,');
     OutTextxy (320,200,'entre em contato com:');
     SetColor (Blue);
     OutTextxy (320,220,'OS PEP LEGAIS - 4o R - Eletronica - LAO - 1997');
     SetColor (Black);
     OutTextxy (320,240,'Pressione ENTER para fechar esta janela');
     SetColor (White);
     SetTextJustify (LeftText,CenterText);
     SetFillStyle (1,8);
     Bar (15,320,200,335);
     OutTextxy (20,325,'Erro na comunicacao!');
Repeat
Until Readkey=#13;
End;

Begin
     If HabilVerif Then Begin
        Port[P2]:=$22; {0010 0010 - Reset/RD/ClrSync}
        Delay(10);
        If (Port[P2] And $20) Shr 5 = 1 Then MensErro;
     End;
End;

{****************************************************************************}

Procedure CursorRight;
{Move o cursor para Direita}

Begin
     If Cur<511 Then Cur:=Cur+1
     Else Cur:=0;
End;

{****************************************************************************}

Procedure CursorLeft;
{Move o cursor para Esquerda}

Begin
     If Cur>0 Then Cur:=Cur-1
     Else Cur:=511;
End;

{****************************************************************************}

Procedure CursorDown;
{Move o cursor para Baixo}

Begin
     If Cur<480 Then Cur:=Cur+32
     Else Cur:=Cur+32-512;
End;

{****************************************************************************}

Procedure CursorUp;
{Move o cursor para Cima}

Begin
     If Cur>31 Then Cur:=Cur-32
     Else Cur:=Cur-32+512;
End;

{****************************************************************************}

Procedure VerifTecla;
{Verifica se alguma tecla foi pressionada}

Procedure VerifASCII;
{Verifica teclas extendidas}

Var TecASC:Char; {Armazena o caracter lido do teclado - teclas extendidas}

Begin
     TecASC:=Readkey;
     If TecASC=#59 Then Help:=True {F1}
     Else If TecASC=#60 Then TOut:=True {F2}
     Else If TecASC=#61 Then St:=True {F3}
     Else If TecASC=#77 Then CursorRight {Right Arrow}
     Else If TecASC=#75 Then CursorLeft {Left Arrow}
     Else If TecASC=#80 Then CursorDown {Down Arrow}
     Else If TecASC=#72 Then CursorUp {Up Arrow}
     Else If TecASC=#62 Then Dw:=True {F4}
     Else If TecASC=#63 Then Ga:=True; {F5}
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

Procedure WriteDados;
{Permite a gravaá∆o dos dados pela Interface}

Var Hr,M,S,S100:Word; {Armazenam hora/minuto/segundo/centÇsimo atuais}
    Timea:Real; {Tempo em segundos}
    Vezes:Integer; {N£mero de pulsos para atualizaá∆o da escala p/ Ext}

Begin
     Port[P2]:=$22; {0010 0010 - Reset/ClrSync/RD}
     VerifIntface;
     Port[P2]:=$A3; {1010 0011 - WR/ClrSync}
     For Vezes:=1 To 5 Do Begin
         Port[P2]:=$A3 Xor $4;
         Port[P2]:=$A3;
     End;
     Port[P2]:=$B3; {1011 0011 - WR - Start}
     Port[P2]:=$B1;  {1011 0001 - WR /PresetSync}
     GetTime (Hr,M,S,S100);
     Timea:=(S100+S*100+M*6E3+Hr*360E3)*10;

Repeat
      If Keypressed Then VerifTecla;  {Aguarda resposta atÇ Time Out}
      GetTime (Hr,M,S,S100);
Until ((Port[P2] And $20) Shr 5 = 1) Or
      ((S100+S*100+M*6E3+Hr*360E3)*10-Timea >= TimeOut);
End;

{****************************************************************************}

Procedure ReadDados;
{Là os dados a partir da Interface}

Begin
     Port[P2]:=$32; {0011 0010 - RD/Reset}
     Port[P2]:=$33; {0011 0011 - RD}

     For IndDado:=0 To 511 Do Begin
         Port[P2]:=$3B; {0011 1011 - RD/ClkRD}
         Port[P2]:=$33; {0011 0011 - RD}
         Port[P1]:=$FF;
         Dado[IndDado]:=Port[P1];
         Port[P2]:=$33;
         Delay (1);
         If Keypressed Then VerifTecla;
         End;
End;

{****************************************************************************}

Procedure Start;
{Inicia a aquisiá∆o de dados}

Begin
     SetColor (White);
     SetTextJustify (LeftText,CenterText);
     SetFillStyle (1,8);
     Bar (15,320,200,335);
     OutTextxy (20,325,'Comunicando com a Interface...');
     WriteDados;
     ReadDados;
     St:=False;
End;

{****************************************************************************}

Procedure DownLoad;
{Carrega um arquivo .OSC}

Procedure Win1;
{Tela de Apresentaá∆o - Utilit†rio de Importaá∆o de .OSC}

Begin
     Tela('Display - Importaá∆o de .OSC');
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (8,'Utilit†rio de Importaá∆o');
     CenterTxt (9,'de');
     CenterTxt (10,'Arquivos de Forma-de-Onda');
     TextColor (White);
     CenterTxt (13,'"Os PEP Legais"');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter para Continuar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
Until Readkey=#13;
End;


Procedure Win2;
{Utilit†rio de Importaá∆o de .OSC - Recolhe o nome de arquivo}

Var PP:Integer; {Utilizado para apagar linhas da tela}
    IoErr:Integer; {Resultado da £ltima operaá∆o de I/O}
    FileOk:Boolean; {Indica Arquivo correto}
    Chj:Char; {Caracter lido do arquivo}
    PEPStr:String; {String 'PEP'}
    PEPOk:Boolean; {String 'PEP' est† presente}
    Arq:File Of Char; {Representa o arquivo .OSC}
    NameArq:String; {Nome do arquivo .OSC}

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
     CenterTxt (7,'Digite o nome do arquivo');
     CenterTxt (8,'a ser importado');
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
     Readln (NameArq);
     If NameArq='' Then Exit;
     Assign (Arq,NameArq+'.OSC');
{$I-}
     Reset (Arq);
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
          Read (Arq,Chj);
          PEPStr:=Chj;
          Read (Arq,Chj);
          PEPStr:=PEPStr+Chj;
          Read (Arq,Chj);
          PEPStr:=PEPStr+Chj;
          If PEPStr='PEP' Then PEPOk:=True
          Else PEPOk:=False;
          Reset(Arq);
          If (FileSize(Arq)=614) And (PEPOk) Then FileOk:=True
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
     For PP:=0 To 101 Do Read(Arq,Chj);

     For PP:=102 To 613 Do Begin
         Read(Arq,Chj);
         Dado[PP-102]:=Ord(Chj);
     End;
     Close(Arq);
End;

Begin
     CloseGraph;
     Win1;
     Win2;
     ModoGrafico;
     Dw:=False;
End;

{****************************************************************************}

Procedure GravaArq;
{Salva dados como arquivo .OSC , .BIN ou .HEX}

Procedure GravaOSC;
{Grava .OSC}

Var SobreGrava:Boolean; {Indica se o arquivo deve ser substitu°do}
    Io:Boolean; {Resultado da £ltima operaá∆o de I/O}
    OffCan,OnCan,DadoLido:Char; {Canal Off/On; Dado lido do array Dado}
    DadoEsc:Byte; {Escala horizontal}
    Tecdo:Char; {Caracter lido do teclado}
    PP,RR:Integer; {Utilizados para apagar as descriá‰es}
    Arq:File Of Char; {Representa o arquivo a ser gravado}
    NameArq:String; {Nome do arquivo a ser gravado}
    Descr:Array [1..10,0..8] Of Char; {Descriá‰es}

Label DigitNovam; {O usu†rio dever† digitar novamente}
Label EscOutNome; {Escolher outro nome-de-arquivo}

Procedure Jaexiste;
{J† existe um arquivo com o mesmo nome}

Var Teclado:Char; {Caracter lido do teclado}
    PQ:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'O arquivo j† existe!');
     CenterTxt (14,'(S)im ou (N)∆o');
     TextColor (White);
     CenterTxt (12,'Substituir o arquivo existente?');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Escolha a opá∆o: S ou N');
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
{Erro de I/O}

Var PQ:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'Houve um erro na Gravaá∆o');
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
Until Readkey=#13;
End;

Procedure Gravacao;
{Gravaá∆o do Arquivo .OSC}

Var PTec:Char; {Caracter lido do teclado}
    Num,Num2:Integer; {Endereáam as descriá‰es}
    PQ:Integer;  {Utilizado para apagar linhas da tela}

Procedure Descricao (YValue:Integer);
{Recolhe as descriá‰es para o .OSC
  YValue = Qual Descriá∆o}

Var Cont:Integer; {N£mero do caracter da descriá∆o}
    X1,Y1:Integer; {Coordenadas X e Y atuais}

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
     CenterTxt (5,'Digite a Descriá∆o para o Conjunto de Formas de Onda:');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite as Descriá‰es - M†ximo 10 Caracteres cada');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
     Window (1,1,80,25);
     Gotoxy (35,7);
     Descricao (0);
     TextColor (White);
     TextBackGround (Cyan);
     CenterTxt (9,'Digite a Descriá∆o para cada Canal:');
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

     {Descriá‰es: Bytes 3 a 92}
     For Num2:=0 To 8 Do Begin
         For Num:=1 To 10 Do Write (Arq,Descr[Num,Num2]);
     End;

     {Status dos canais: Bytes 93 a 100}
     OnCan:=Chr(1);
     OffCan:=Chr(0);
     Write (Arq,OnCan);
     Write (Arq,OnCan);
     Write (Arq,OnCan);
     Write (Arq,OnCan);
     Write (Arq,OnCan);
     Write (Arq,OnCan);
     Write (Arq,OnCan);
     Write (Arq,OnCan);

     {Escala Horizontal: Byte 101}
     DadoEsc:=5;
     OnCan:=Chr(DadoEsc);
     Write (Arq,OnCan);

     {Dados 512 Bytes: Bytes 102 a 614}
     For Num:=0 To 511 Do Begin
         DadoLido:=Chr(Dado[Num]);
         Write (Arq,DadoLido);
     End;
End;

Begin
     For RR:=0 To 8 Do Begin
         For PP:=1 To 10 Do Descr[PP,RR]:=#0;
     End;

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
     CenterTxt (9,'(com caminho completo, se necess†rio e');
     CenterTxt (10,'sem extens∆o - Extens∆o padr∆o: .OSC):');
     CenterTxt (15,'Pressione somente Enter para Cancelar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite o nome do arquivo sem extens∆o / Enter: Cancela');
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
End;

Procedure GravaBIN;
{Grava .BIN}

Var SobreGrava:Boolean; {Indica se o arquivo deve ser substitu°do}
    Io:Boolean; {Resultado da £ltima operaá∆o de I/O}
    DadoLido:Char; {Dado lido do array Dado}
    DadoEsc:Byte; {Escala horizontal}
    Tecdo:Char; {Caracter lido do teclado}
    PP:Integer; {Utilizado para apagar linhas da tela}
    Arq:File Of Char; {Representa o arquivo a ser gravado}
    NameArq:String; {Nome do arquivo a ser gravado}

Label DigitNovam; {O usu†rio dever† digitar novamente}
Label EscOutNome; {Escolher outro nome-de-arquivo}

Procedure Jaexiste;
{J† existe um arquivo com o mesmo nome}

Var Teclado:Char; {Caracter lido do teclado}
    PQ:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'O arquivo j† existe!');
     CenterTxt (14,'(S)im ou (N)∆o');
     TextColor (White);
     CenterTxt (12,'Substituir o arquivo existente?');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Escolha a opá∆o: S ou N');
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
{Erro de I/O}

Var PQ:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'Houve um erro na Gravaá∆o');
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
Until Readkey=#13;
End;

Procedure Gravacao;
{Gravaá∆o do Arquivo .BIN}

Var PTec:Char; {Caracter lido do teclado}
    Num,Num2:Integer; {Fazem a contagem dos records gravados}
    PQ:Integer;  {Utilizado para apagar linhas da tela}

Begin
     {Dados 512 Bytes: Bytes 0 a 511}
     For Num:=0 To 511 Do Begin
         DadoLido:=Chr(Dado[Num]);
         Write (Arq,DadoLido);
     End;
End;

Begin
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
     CenterTxt (9,'(com caminho completo, se necess†rio e');
     CenterTxt (10,'sem extens∆o - Extens∆o padr∆o: .BIN):');
     CenterTxt (15,'Pressione somente Enter para Cancelar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite o nome do arquivo sem extens∆o / Enter: Cancela');
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
     Assign (Arq,NameArq+'.BIN');
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
End;

Procedure GravaHEX;
{Grava .HEX}

Var SobreGrava:Boolean; {Indica se o arquivo deve ser substitu°do}
    Io:Boolean; {Resultado da £ltima operaá∆o de I/O}
    NumHex,DadoHex,DadoLido:String; {Valor lido do array dado em hex}
    DadoEsc:Byte; {Escala horizontal}
    Tecdo:Char; {Caracter lido do teclado}
    PP:Integer; {Utilizado para apagar linhas da tela}
    Arq:Text; {Representa o arquivo a ser gravado}
    NameArq:String; {Nome do arquivo a ser gravado}

Label DigitNovam; {O usu†rio dever† digitar novamente}
Label EscOutNome; {Escolher outro nome-de-arquivo}

Procedure Jaexiste;
{J† existe um arquivo com o mesmo nome}

Var Teclado:Char; {Caracter lido do teclado}
    PQ:Integer; {Utilizado para apagar linhas da tela}

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
     CenterTxt (9,'O arquivo j† existe!');
     CenterTxt (14,'(S)im ou (N)∆o');
     TextColor (White);
     CenterTxt (12,'Substituir o arquivo existente?');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Escolha a opá∆o: S ou N');
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
{Erro de I/O}

Var PQ:Integer; {Utilizado para apagar lihas da tela}

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
     CenterTxt (9,'Houve um erro na Gravaá∆o');
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
Until Readkey=#13;
End;

Procedure Gravacao;
{Gravaá∆o do Arquivo .HEX}

Var PTec:Char; {Caracter lido do teclado}
    Num,Num2:Integer; {Fazem a contagem dos records gravados}
    PQ:Integer;  {Utilizado para apagar linhas da tela}

Begin
     For Num:=0 To 511 Do Begin
         DadoLido:=' - ';
         DadoHex:=DecToHex(Dado[Num],False);
         NumHex:=DecToHex(Num,True);
         Writeln (Arq,NumHex,DadoLido,DadoHex);
     End;
End;

Begin
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
     CenterTxt (9,'(com caminho completo, se necess†rio e');
     CenterTxt (10,'sem extens∆o - Extens∆o padr∆o: .HEX):');
     CenterTxt (15,'Pressione somente Enter para Cancelar');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Digite o nome do arquivo sem extens∆o / Enter: Cancela');
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
     Assign (Arq,NameArq+'.HEX');
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
End;

Procedure Win1;
{Tela de apresentaá∆o - Utilit†rio de Gravaá∆o .OSC/.BIN/.HEX}

Begin
     Tela('Display - Gravaá∆o de Arquivos');
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (8,'Utilit†rio de Gravaá∆o');
     CenterTxt (9,'de');
     CenterTxt (10,'Arquivos de Forma-de-Onda');
     TextColor (White);
     CenterTxt (13,'"Os PEP Legais"');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Pressione Enter para Continuar');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
Until Readkey=#13;
End;

Procedure Win2;
{Utilit†rio de Gravaá∆o .OSC/.BIN/.HEX - Escolha do formato}

Var PP:Integer; {Utilizado para apagar linhas da tela}
    TecE:Char; {Caracter lido do teclado}

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
     CenterTxt (7,'Escolha o formato do arquivo');
     CenterTxt (8,'a ser gravado');
     CenterTxt (10,'1. Arquivo de forma-de-onda (.OSC)');
     CenterTxt (11,'2. Arquivo bin†rio de dados (.BIN)');
     CenterTxt (12,'3. Arquivo texto de dados   (.HEX)');
     CenterTxt (13,'4. Cancelar a operaá∆o            ');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24);
     Write ('Pressione 1, 2, 3 ou 4');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
Repeat
      TecE:=Readkey;
Until (TecE='1') Or (TecE='2') Or (TecE='3') Or (TecE='4');
      If TecE='1' Then GravaOSC
      Else If TecE='2' Then GravaBIN
      Else If TecE='3' Then GravaHEX
      Else Exit;
End;

Begin
     CloseGraph;
     Win1;
     Win2;
     Window(1,1,80,25);
     TextColor(LightGray);
     TextBackGround(Black);
     ModoGrafico;
     Ga:=False;
End;

{****************************************************************************}

Procedure Displ (XCent:Integer; YCent:Integer; XMed:Integer; Numb:Integer;
                 CorDisp:Integer; CorBord:Integer);
{Faz um display de tamanho especificado (XMed), na posiá∆o especificada
 (XCent,YCent), mostrando um d°gito especificado (Numb), com cor de LED
 (CorDisp) e cor de borda (CorBord) especificados}

{Decodificador DEC(Hex)/7Segmentos}

Var XX,YY:Integer; {Centro do display}

Procedure D;
{Segmento D}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent-Round((16/25)*XX),YCent+Round((23/30)*YY),
              XCent+Round((11/25)*XX),YCent+Round((23/30)*YY));
End;

Procedure A;
{Segmento A}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent-Round((13/25)*XX),YCent-Round((23/30)*YY),
              XCent+Round((14/25)*XX),YCent-Round((23/30)*YY));
End;

Procedure G;
{Segmento G}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent-Round((14/25)*XX),YCent,XCent+Round((12/25)*XX),YCent);
End;

Procedure F;
{Segmento F}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent-Round((16/25)*XX),YCent-Round((22/30)*YY),
              XCent-Round((17/25)*XX),YCent-Round((2/30)*YY));
End;

Procedure E;
{Segmento E}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent-Round((17/25)*XX),YCent+Round((2/30)*YY),
              XCent-Round((18/25)*XX),YCent+Round((22/30)*YY));
End;

Procedure B;
{Segmento B}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent+Round((17/25)*XX),YCent-Round((22/30)*YY),
              XCent+Round((16/25)*XX),YCent-Round((2/30)*YY));
End;

Procedure C;
{Segmento C}

Begin
     If Keypressed Then VerifTecla;
        Line (XCent+Round((16/25)*XX),YCent+Round((2/30)*YY),
              XCent+Round((14/25)*XX),YCent+Round((22/30)*YY));
End;

Begin
     SetColor (CorBord);
     SetLineStyle (0,1,1);
     XX:=Round(XMed/2);
     YY:=Round(XX*1.2);
     Rectangle (XCent-Round(1.4*XX),YCent-Round(1.4*YY),XCent+Round(1.4*XX),
                YCent+Round(1.4*YY));
     SetFillStyle (1,0);
     Bar (XCent-Round(1.4*XX)+1,YCent-Round(1.4*YY)+1,XCent+Round(1.4*XX)-1,
          YCent+Round(1.4*YY)-1);
     SetColor (CorDisp);
     If Numb=0 Then Begin
        A; B; C; D; E; F;
     End;
     If Numb=1 Then Begin
        B; C;
     End;
     If Numb=2 Then Begin
        A; B; D; E; G;
     End;
     If Numb=3 Then Begin
        A; B; C; D; G;
     End;
     If Numb=4 Then Begin
        B; C; F; G;
     End;
     If Numb=5 Then Begin
        A; C; D; F; G;
     End;
     If Numb=6 Then Begin
        A; C; D; E; F; G;
     End;
     If Numb=7 Then Begin
        A; B; C;
     End;
     If Numb=8 Then Begin
        A; B; C; D; E; F; G;
     End;
     If Numb=9 Then Begin
        A; B; C; D; F; G;
     End;
     If Numb=10 Then Begin
        A; B; C; E; F; G;
     End;
     If Numb=11 Then Begin
        C; D; E; F; G;
     End;
     If Numb=12 Then Begin
        A; D; E; F;
     End;
     If Numb=13 Then Begin
        B; C; D; E; G;
     End;
     If Numb=14 Then Begin
        A; D; E; F; G;
     End;
     If Numb=15 Then Begin
        A; E; F; G;
     End;
End;

{****************************************************************************}

Procedure TelaPrinc;
{Mostra a tela principal, atualizando os displays}

Var XDis,YDis:Integer; {Coordenadas dos displays}
    CorDs:Integer; {Cores dos displays}

Begin
     SetFillStyle (1,8);
     Bar (10,10,630,340);
     SetLineStyle (0,1,1);
     SetColor (White);
     Rectangle (10,10,630,340);
     Line (10,25,630,25);
     SetFillStyle (1,1);
     Bar (11,11,629,24);
     SetTextStyle (SmallFont, HorizDir,5);
     SetTextJustify (CenterText,CenterText);
     OutTextxy(320,15,'Display - Os PEP Legais');

     SetColor (White);
     SetTextStyle (SmallFont, HorizDir,4);
     SetTextJustify (LeftText,CenterText);
     OutTextxy(50,38,'TIME OUT:');
     Displ (45,55,10,Trunc(TimeOut/1000),LightGreen,0);
     Displ (59,55,10,Trunc(TimeOut/100)-Trunc(TimeOut/1000)*10,LightGreen,0);
     Displ (73,55,10,Trunc(TimeOut/10)-(Trunc(TimeOut/100)-
            Trunc(TimeOut/1000)*10)*10-Trunc(TimeOut/1000)*100,LightGreen,0);
     Displ (87,55,10,TimeOut-(Trunc(TimeOut/10)-(Trunc(TimeOut/100)-
            Trunc(TimeOut/1000)*10)*10-Trunc(TimeOut/1000)*100)*10-
            (Trunc(TimeOut/100)-Trunc(TimeOut/1000)*10)*100-
            Trunc(TimeOut/1000)*1000,LightGreen,0);
     SetColor (White);
     OutTextxy(100,55,'mS');

     OutTextxy(150,38,'POSICAO DO DADO:');
     Displ (135,55,10,Trunc(Cur/256),LightGreen,0);
     Displ (149,55,10,Trunc(((Cur/256-Trunc(Cur/256))*256)/16),LightGreen,0);
     Displ (163,55,10,Trunc(((((Cur/256-Trunc(Cur/256))*256)/16)-
            Trunc(((Cur/256-Trunc(Cur/256))*256)/16))*16),LightGreen,0);
     SetColor (White);
     OutTextxy (175,55,'HEX');
     Displ (210,55,10,Trunc(Cur/100),LightGreen,0);
     Displ (224,55,10,Trunc(Cur/10)-Trunc(Cur/100)*10,LightGreen,0);
     Displ (238,55,10,Cur-(Trunc(Cur/10)-Trunc(Cur/100)*10)*10-
            Trunc(Cur/100)*100,LightGreen,0);
     SetColor (White);
     OutTextxy (250,55,'DEC');

     OutTextxy (350,38,'VALOR DO DADO:');
     Displ (286,55,10,Trunc(Dado[Cur]/100),LightGreen,0);
     Displ (300,55,10,Trunc(Dado[Cur]/10)-Trunc(Dado[Cur]/100)*10,
            LightGreen,0);
     Displ (314,55,10,Dado[Cur]-(Trunc(Dado[Cur]/10)-Trunc(Dado[Cur]/100)*10)
            *10-Trunc(Dado[Cur]/100)*100,LightGreen,0);
     SetColor (White);
     OutTextxy (330,55,'DEC');
     Displ (365,55,10,(Dado[Cur] And $80) Shr 7,LightGreen,0);
     Displ (379,55,10,(Dado[Cur] And $40) Shr 6,LightGreen,0);
     Displ (393,55,10,(Dado[Cur] And $20) Shr 5,LightGreen,0);
     Displ (407,55,10,(Dado[Cur] And $10) Shr 4,LightGreen,0);
     Displ (421,55,10,(Dado[Cur] And $08) Shr 3,LightGreen,0);
     Displ (435,55,10,(Dado[Cur] And $04) Shr 2,LightGreen,0);
     Displ (449,55,10,(Dado[Cur] And $02) Shr 1,LightGreen,0);
     Displ (463,55,10,(Dado[Cur] And $01),LightGreen,0);
     SetColor (White);
     OutTextxy (478,55,'BIN');
     OutTextxy (20,80,'Pressione F1 para Ajuda');
     OutTextxy (520,55,'Sincr: Externo');
     Rectangle (20,30,620,70);
     Line (120,30,120,70);
     Line (270,30,270,70);
     Line (510,30,510,70);

     IndDado:=0;
     YDis:=100;
Repeat
     XDis:=22;
Repeat
      If IndDado=Cur Then CorDs:=LightBlue
      Else CorDs:=LightRed;
      Displ (XDis,YDis,6,((Dado[IndDado] And $F0) Shr 4),CorDs,0);
      Displ (XDis+8,YDis,6,(Dado[IndDado] And $0F),CorDs,0);
      XDis:=XDis+19;

      IndDado:=IndDado+1;
Until ((XDis-22)/19)>=32;
      YDis:=YDis+14;
Until ((YDis-100)/14)>=16;

     SetColor (7);
     XDis:=16;
Repeat
     If Keypressed Then VerifTecla;
      Line (XDis,93,XDis,316);
      XDis:=XDis+19;
Until XDis>630;
      YDis:=92;
Repeat
     If Keypressed Then VerifTecla;
      Line (16,YDis,624,YDis);
      YDis:=YDis+14;
Until YDis>317;

     SetColor (White);
     SetTextJustify (LeftText,CenterText);
     SetFillStyle (1,8);
     Bar (15,320,200,335);
     OutTextxy (20,325,'Em Repouso                    ');
End;

{****************************************************************************}

Begin
     VerifArq;
     AbreCfg;
     ModoGrafico;
     Ap:=0;
     TimeOut:=10;
     Tot[1]:='0'; Tot[2]:='0'; Tot[3]:='1'; Tot[4]:='0';
     Cur:=0;
     Apres;

Repeat
     If Help Then Ajuda;
     If TOut Then AltTO;
     If St Then Start;
     If Dw Then DownLoad;
     If Ga Then GravaArq;
     If Ap=0 Then Begin
        SetVisualPage(0);
        SetActivePage(1);
        Ap:=1;
     End
     Else Begin
        SetVisualPage(1);
        SetActivePage(0);
        Ap:=0;
     End;
     Delay(10);
     TelaPrinc;
     If Ap=1 Then SetVisualPage(1)
     Else SetVisualPage(0);
     If Keypressed Then VerifTecla;
Until Tecla=#27;
     CloseGraph;
     FimProg;
End.

{****************************************************************************}
{
        * Formato do arquivo .BIN *

Bytes 0 a 511 = ASCII dos Dados

}
{****************************************************************************}
{
        * Formato do arquivo .HEX *

Coluna 1 = Posiá∆o do Dado (em Hexadecimal)
Coluna 2 = Valor do Dado (em Hexadecimal)

}
{****************************************************************************}
