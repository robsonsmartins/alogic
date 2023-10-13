{$A-,B-,D-,E+,F-,G-,I+,L-,N+,Q-,R-,S+,X+,V+}
{Diretivas de compila‡Æo}

{****************************************************************************}

Program Install;

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

{Programa de Instala‡Æo do PEP Software para Analisador L¢gico}
{INSTALL.SET - Arquivo com o Setup Files do Install}

{****************************************************************************}

Uses Crt,Dos,PEPUnit;
{Units a serem utilizadas}

{****************************************************************************}

Var SetupFile: Text; {Representa o arquivo de SetUp}
    ArqOrig, ArqDest, DriveDest, DirOrig, DirDest: String;  {Nomes de arquivo,
                                                    diret¢rio e drive}
    Drives: Array [1..26] Of Byte; {Armazena os Drives dispon¡veis no sistema}

{****************************************************************************}

Procedure ApagaTela;
{Apaga a tela atual}

Begin
     Window(1,1,80,25);
     TextColor(LightGray);
     TextBackGround(Black);
     Clrscr;
End;

{****************************************************************************}

Procedure OpenSetup;
{Abre o arquivo de configura‡Æo INSTALL.SET}

Procedure MensErro;
{Mensagem de Erro - NÆo foi encontrado INSTALL.SET}

Begin
     ApagaTela;
     TextColor (Blue);
     Writeln ('Analisador L¢gico - Mensagem de Erro');
     Writeln;
     TextColor (LightRed);
     Writeln ('NÆo existe o arquivo "INSTALL.SET"');
     Writeln ('neste disco de instala‡Æo!');
     Writeln;
     Writeln ('Adquira uma nova c¢pia do Software!');
     TextColor (LightGray);
     Writeln;
     Writeln ('Entre em contato com:');
     Writeln;
     Textcolor (White);
     Writeln ('"Os PEP Legais" - LAO - 4oR Eletr“nica');
     Textcolor (LightGray);
     Writeln;
     Halt(2);
End;

Begin
     Assign (SetupFile,'INSTALL.SET');
{$I-}
     Reset (SetupFile);
{$I+}
     If IoResult <> 0 Then MensErro;
End;

{****************************************************************************}

Procedure LeSetup;
{Lˆ uma Linha do arquivo INSTALL.SET}

Var ContSet:Integer; {N£mero de caracteres do nome-de-arquivo a ser copiado}

Begin
     If Eof(SetupFile) Then ArqDest:=''
     Else Begin
          Readln (SetupFile,ArqDest);
          ArqOrig:='';
          For ContSet:=1 To Length(ArqDest)-1 Do Begin
              ArqOrig:=ArqOrig+Copy(ArqDest,ContSet,1);
          End;
          ArqOrig:=ArqOrig+'_';
     End;
End;

{****************************************************************************}

Procedure MensCancela;
{Mensagem se for cancelada a Instala‡Æo}

Begin
     ApagaTela;
     Writeln;
     Writeln ('O Software para o Analisador L¢gico nÆo foi instalado!');
     Writeln ('Execute novamente o INSTALL!');
     Writeln;
     Halt(0);
End;

{****************************************************************************}

Procedure Win1;
{Tela inicial do programa - Apresenta‡Æo}

Var Tecla:Char; {Caracter lido do teclado}

Begin
     Window (1,1,80,25);
     TextColor (Yellow);
     TextBackground (Cyan);
     CenterTxt (9,'PROGRAMA DE INSTALA€ÇO DO');
     CenterTxt (10,'SOFTWARE PARA O ANALISADOR LàGICO');
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
      If Tecla=#27 Then MensCancela;
Until Tecla=#13;

End;

{****************************************************************************}

Procedure DetectDrives;
{Detecta as unidades v lidas >= 1MB Livre}

Var DrCont: Integer; {Conta o n£mero de drives do sistema}
    DriveTrue: Boolean; {Drive correto (>=1MB livre)}

Procedure MensNoDiskSpace;
{Mensagem de Erro: NÆo h  unidades com pelo menos 1MB Livres}

Begin
     ApagaTela;
     Writeln;
     Writeln ('NÆo existe nenhuma Unidade de Disco com pelo Menos 1MB Livres');
     Writeln;
     Write ('Libere espa‡o em uma das Unidades');
     Writeln (' e execute novamente o INSTALL.');
     Writeln;
     Halt(0);
End;

Begin
     For DrCont:=1 To 2 Do Drives[DrCont]:=0;
     For DrCont:=3 To 26 Do Begin
         If DiskFree(DrCont) < 1024*1000 Then Drives[DrCont]:=0
         Else Drives[DrCont]:=1;
     End;
     DriveTrue:=False;

     For DrCont:=1 To 26 Do Begin
         If Drives[DrCont]=1 Then Begin
            DriveTrue:=True;
            Break;
         End;
     End;

     If Not DriveTrue Then MensNoDiskSpace;
End;

{****************************************************************************}

Procedure Win2;
{Tela de determina‡Æo do drive de destino}

Var Tecla:Char; {Caracter lido do teclado}
    PP:Integer; {Utilizado para apagar linhas da tela}
    DrOk:Boolean; {Indica Drive correto}
    DrCont:Integer; {Conta o n£mero de drives do sistema}
    Tec:Char; {Caracter lido do teclado}

Function DriveVal:String;
{Verifica os Drives existentes no Sistema e Atribui uma String para cada}

Var DrStr:String; {Drive em formato String}
    DrCont:Integer; {Conta os drives existentes no sistema}

Begin
     DrStr:='';
     For DrCont:=1 To 26 Do Begin
         If Drives[DrCont]=1 Then DrStr:=DrStr+Chr(DrCont+64)+': ';
     End;
     DriveVal:=DrStr;
End;

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
     CenterTxt (9,'Digite o Drive de Destino: (Default = C:)');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Drives V lidos: ',DriveVal,' / Esc: Cancela');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
     CenterTxt(12,'C:');
     DrOk:=True;
     Tec:='C';
Repeat
Repeat
      Tecla:=Readkey;
      Tecla:=Upcase(Tecla);
      If Tecla=#27 Then MensCancela;
      If Tecla=#8 Then Tecla:=#0;
      If Tecla=#13 Then Break;
      CenterTxt (12,Tecla+':');
      For DrCont:=1 To 26 Do Begin
          If Drives[Ord(Tecla)-64]=1 Then Begin
             DrOk:=True;
             Tec:=Tecla;
             Break;
          End
          Else DrOk:=False;
      End;
Until DrOk;
      If (Tecla=#13) And Not (DrOk) Then Begin
         Sound(1000);
         Delay(200);
         Nosound;
      End;
Until (Tecla=#13) And (DrOk);
      DriveDest:=Tec;
End;

{****************************************************************************}

Procedure MensErroRead;
{Mensagem de Erro - Falha na leitura}

Begin
     ApagaTela;
     TextColor (Blue);
     Writeln ('Analisador L¢gico - Mensagem de Erro');
     Writeln;
     TextColor (LightRed);
     Writeln ('Houve um erro de leitura');
     Writeln ('neste Disco de Instala‡Æo!');
     Writeln;
     Writeln ('Adquira uma nova c¢pia do Software!');
     TextColor (LightGray);
     Writeln;
     Writeln ('Entre em contato com:');
     Writeln;
     Textcolor (White);
     Writeln ('"Os PEP Legais" - LAO - 4oR Eletr“nica');
     Textcolor (LightGray);
     Writeln;
     Halt(2);
End;

{****************************************************************************}

Procedure MensErroWrite;
{Mensagem de Erro - Falha na Grava‡Æo}

Begin
     ApagaTela;
     TextColor (Blue);
     Writeln ('Analisador L¢gico - Mensagem de Erro');
     Writeln;
     TextColor (LightRed);
     Writeln ('Houve um Erro Fatal de Grava‡Æo');
     Writeln ('no Disco de Destino!');
     Writeln;
     Writeln ('Execute um Utilit rio de Reparo de Disco');
     Writeln ('para solucionar este problema!');
     TextColor (LightGray);
     Writeln;
     Writeln ('Caso nÆo resolva este problema,');
     Writeln ('entre em contato com:');
     Writeln;
     Textcolor (White);
     Writeln ('"Os PEP Legais" - LAO - 4oR Eletr“nica');
     Textcolor (LightGray);
     Writeln;
     Halt(2);
End;

{****************************************************************************}

Procedure Win3;
{Tela de determina‡Æo de diret¢rio de destino}

Var Tecla:Char; {Caracter lido do teclado}
    PP:Integer; {Utilizado para apagar linhas da tela}
    Io:Integer; {Resultado da £ltima opera‡Æo de I/O}
    DirExiste:Boolean; {Diret¢rio existe}

Procedure Confirma;
{Confirma se o Diret¢rio ser  substituido}

Begin
      Sound (1000);
      Delay(200);
      Nosound;
      TextColor (White);
      CenterTxt (13,'                                           ');
      CenterTxt (14,'                                           ');
      CenterTxt(13,'J  existe um diret¢rio com o mesmo nome!');
      CenterTxt(14,'Sobrescreve o diret¢rio (S,N)?');
      TextColor(Yellow);
Repeat
      Tecla:=UpCase(Readkey);
Until (Tecla='S') Or (Tecla='N');
      If Tecla='N' Then Io:=1;
End;

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
     CenterTxt (8,'Digite o Diret¢rio de Destino:');
     CenterTxt (9,'(Default = \PEPLEG)');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Digite o nome do diret¢rio / "!": Cancela');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;

     Window (1,1,80,25);
     TextBackGround(LightCyan);
     TextColor (Yellow);
Repeat
      CenterTxt (11,'                                           ');
      CenterTxt (13,'                                           ');
      CenterTxt (14,'                                           ');
      Gotoxy (36,11);
      Write(DriveDest+':\');
      Readln (DirDest);
      If DirDest='!' Then MensCancela;
      If DirDest='' Then Begin
         GotoXy(39,11);
         Write('PEPLEG');
         TextColor (White);
         CenterTxt(13,'Confirma o diret¢rio acima indicado (S,N)?');
         TextColor(Yellow);
Repeat
      Tecla:=UpCase(Readkey);
Until (Tecla='S') Or (Tecla='N');
         If Tecla='S' Then DirDest:='PEPLEG'
         Else DirDest:=':';
      End;
      GetDir(0,DirOrig);
      DirExiste:=True;
{$I-}
      ChDir(DriveDest+':\'+DirDest);
{$I+}
      Io:=IoResult;
      If Io<>0 Then DirExiste:=False;
      Io:=0;
      If DirExiste Then Confirma;
{$I-}
      ChDir(DirOrig);
{$I+}
      If IoResult<>0 Then MensErroRead;

   If Not DirExiste Then Begin
{$I-}
      MkDir(DriveDest+':\'+DirDest);
{$I+}
      Io:=IoResult;
      If Io<>0 Then Begin
         Sound (1000);
         Delay(200);
         Nosound;
      End;
   End;
Until Io = 0;
End;

{****************************************************************************}

Procedure Win4;
{Tela de c¢pia dos arquivos}

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
     CenterTxt (9,'Copiando Arquivos para o Destino...');
     Textcolor (Black);
     TextBackGround (White);
     Gotoxy (2,24); Write ('Aguarde!');
     Window (1,25,1,25);
     TextBackground(Black);
     Clrscr;
End;

{****************************************************************************}

Procedure Copia;
{Copia um arquivo de origem para um arquivo de destino}

Procedure Copiador;
{Efetua a leitura do arquivo de origem e a grava‡Æo do arquivo de destino}

Var FromF, ToF: File; {Arquivos de origem/destino}
    NumRead, NumWritten: Word; {N£mero de bytes lidos/escritos}
    Buf: Array[1..4096] Of Char; {Buffer de leitura}

Begin
     Assign(FromF, ArqOrig);
{$I-}
     Reset(FromF, 1);
{$I+}
     If IoResult<>0 Then MensErroRead;
     Assign(ToF, DriveDest+':\'+DirDest+'\'+ArqDest);
{$I-}
     Rewrite(ToF, 1);
{$I+}
     If IoResult<>0 Then MensErroWrite;
Repeat
{$I-}
     BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
{$I+}
     If Ioresult<>0 Then MensErroRead;
{$I-}
     BlockWrite(ToF, Buf, NumRead, NumWritten);
{$I+}
     If Ioresult<>0 Then MensErroWrite;
Until (NumRead = 0) Or (NumWritten <> NumRead);
     Close(FromF);
     Close(ToF);
End;

Begin
Repeat
     LeSetup;
     If ArqDest='' Then Break;
     Window (1,1,80,25);
     TextColor(Yellow);
     TextBackGround(LightCyan);
     CenterTxt(11,'                                             ');
     CenterTxt(12,'                                             ');
     CenterTxt(11,'De: '+ArqOrig);
     CenterTxt(12,'Para: '+DriveDest+':\'+DirDest+'\'+ArqDest);
     Window (1,25,1,25);
     TextColor(Black);
     TextBackground(Black);
     Clrscr;
     Copiador;
Until ArqDest='';
End;

{****************************************************************************}

Procedure Fim;
{Tela final do programa}

Begin
     ApagaTela;
     Writeln;
     Writeln ('O PEP Software para Analisador L¢gico');
     Writeln ('foi instalado com sucesso!');
     Writeln;
     Writeln ('Para executar o Software, digite no aviso de comando:');
     Writeln (DriveDest+': [ENTER]');
     Writeln ('CD\'+DirDest+' [ENTER]');
     Writeln;
     Writeln ('DIAG    [ENTER] (Realiza um teste na Interface)');
     Writeln ('CONFIG  [ENTER] (Configura o Analisador L¢gico)');
     Writeln ('ALOGIC  [ENTER] (Analisador L¢gico)');
     Writeln ('DISPLAY [ENTER] (Mostra dados adquiridos pela Interface)');
     Writeln ('COMPARA [ENTER] (Comparador de formas-de-onda)');
     Writeln ('MAKEOSC [ENTER] (Produz formas-de-onda padrÆo)');
     Writeln;
     Halt(0);
End;

{****************************************************************************}

Begin
     OpenSetup;
     ApagaTela;
     Tela('Analisador L¢gico');
     Win1;
     DetectDrives;
     Win2;
     Win3;
     Win4;
     Copia;
     Close (SetupFile);
     Fim;
End.

{****************************************************************************}
{
        * Estrutura do arquivo INSTALL.SET *

Linhas = Nomes dos arquivos de destino da instala‡Æo

}
{****************************************************************************}