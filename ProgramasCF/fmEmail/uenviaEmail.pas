unit uEnviaEmail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, ADODB,
  IdTCPClient, IdMessageClient, IdSMTP, IdIOHandler, IdIOHandlerSocket,
  IdSSLOpenSSL, IdMessage, f, funcsql, Buttons, ExtCtrls, uHash;

type
  TfmEnviaEmail = class(TForm)
    IdSMTP: TIdSMTP;
    Memo1: TMemo;
    socket: TIdSSLIOHandlerSocket;
    idMsg: TIdMessage;
    Panel1: TPanel;
    Bevel1: TBevel;
    procedure IdSMTPStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
    procedure socketStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
    function enviarEmailGmail(dadosConexao:THash; uo, destinatario, assunto, anexo:String; corpoMsg:Tstringlist; titulo,pesSender:String):boolean;
    function getMailDestino(uo:String; var Texto:TstringList; var user, pass:String):String;
    procedure FormClose(Sender: TObject;var Action: TCloseAction);
    function enviarEmailGmail2(uo, assunto, titulo, pesSender:String; anexos, corpoMsg, destinatarios: Tstringlist):boolean;
    procedure FormCreate(Sender: TObject);
    function getDadoParamCon(nmParam:integer):String;
    procedure IdSMTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdSMTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEnviaEmail: TfmEnviaEmail;
  DADOS_EMAIL:THash;

implementation

uses uDestinoEmail, uMain, {uDm, } msg;
{$R *.dfm}

function TfmEnviaEmail.getMailDestino(uo:String;  var texto:TstringList; var user, pass:String):String;
var
   str:String;
   i:integer;
   textoAnterior:TstringList;
begin
   textoAnterior := TStringList.Create();

   textoAnterior.AddStrings(Texto);

   application.CreateForm(TfmDestEmail, fmDestEmail);

   if  Texto = nil then
      texto:= TStringlist.Create();

   fmDestEmail.ShowModal;
   str := '';
   if (fmDestEmail.ModalResult = MROK) then
   begin
      str := fmDestEmail.lbEmail.Caption;

      if pos('@', str) = 0 then
         str := '';

      user := fmDestEmail.edConta.Text;
      pass := fmDestEmail.edSenha.Text;
   end
   else
      str := '';

   if (texto <> nil) then
   begin
      texto.Clear();

      for i:=0 to fmDestEmail.mmCorpoEmail.Lines.Count -1 do
         texto.Add(fmDestEmail.mmCorpoEmail.Lines[i]);

      for i:=0 to textoAnterior.Count - 1 do
         texto.Add(textoAnterior[i]);
   end;
   textoAnterior.Free();

   Result := str;

   fmDestEmail.Free();
   fmDestEmail := nil;
end;

procedure TfmEnviaEmail.IdSMTPStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
begin
   memo1.Lines.Add(AStatusText);
end;

procedure TfmEnviaEmail.socketStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
begin
   memo1.Lines.Add(AStatusText);
end;

function TfmEnviaEmail.enviarEmailGmail2(uo, assunto, titulo, pesSender:String; anexos, corpoMsg, destinatarios: Tstringlist):boolean;
var
  i:integer;
  dest, user, pass, nmRemetente:String;
begin
   f.gravaLog('TfmEnviaEmail.enviarEmailGmail2()');

// se nao tiver destinatario abre a janela para pegar
   if (destinatarios.Count = 0)  then
      dest :=  getMailDestino(uo, corpoMsg, user, pass);

   if (dest <> '') then
      destinatarios.Add(dest);

   if (destinatarios.Count > 0) then
   begin
      screen.Cursor := crHourGlass;

      if  (user <> '') then
      begin
         IdSMTP.Username := user;
         IdSMTP.Password := pass;
      end
      else
      begin
         IdSMTP.Username := DADOS_EMAIL.getValor('user'); //  dm.getParamBD('comum.emailUser', '0');
         IdSMTP.Password := DADOS_EMAIL.getValor('password'); //  dm.getParamBD('comum.emailpassword', '0');
      end;

      fmEnviaEmail.memo1.Lines.add('E-mail');
      fmEnviaEmail.panel1.Caption := titulo;
      fmEnviaEmail.Refresh();


      if (pos('@', nmRemetente) = 0 ) then
         nmRemetente := DADOS_EMAIL.getValor('RemetenteNome');   //  dm.getEmail(uo);

      fmEnviaEmail.Memo1.Lines.add('Remetente: ' + nmRemetente );

      with fmEnviaEmail.idMsg do
      begin
         Create(nil);
         if (corpoMsg <> nil) then
            for i:=0 to corpoMsg.Count -1 do
               Body.Add(corpoMsg[i]);

         From.Address := nmRemetente;
         From.Name := nmRemetente;
         fmEnviaEmail.idMsg.ReplyTo.EMailAddresses := nmRemetente;


         for i:=0 to destinatarios.Count-1 do
         begin
            fmEnviaEmail.memo1.Lines.add('Destinat�rio:' + destinatarios[i]);
            Recipients.Add;
            Recipients.Items[i].Address := destinatarios[i];
            Recipients.Items[i].Name := destinatarios[i];
         end;

         Subject := assunto
      end;

      if (anexos <> nil) then
      begin
         Memo1.Lines.add('Adicionando anexos...');

         for i:=0 to anexos.count -1 do
         begin
            f.gravaLog( anexos [i]);
            TIdAttachment.create(fmEnviaEmail.idMsg.MessageParts, TFileName(anexos[i]));
         end;
      end;

      try
         fmEnviaEmail.idsmtp.Connect();
         fmEnviaEmail.idsmtp.Send(fmEnviaEmail.idMsg);
         fmEnviaEmail.Memo1.Lines.add('');
         fmEnviaEmail.Memo1.Lines.add('Enviando email...');
         fmEnviaEmail.Memo1.Lines.add('');
         fmEnviaEmail.idsmtp.Disconnect;
         sleep(500);
         result := true;

      except
         on e:Exception do
         begin
            sleep(500);
            msg.msgErro('   Ocorreu um erro ao enviar o e-mail, o erro foi:   ' +#13+#13+  e.message);
            result := false;
         end;
      end;
    end
    else
    begin
       msg.msgErro('O endere�o � inv�lido ou n�o foi preenchido. ');
       result := false;
    end;
end;

procedure TfmEnviaEmail.FormClose(Sender: TObject;var Action: TCloseAction);
begin
//   action := caFree;
end;   

function TfmEnviaEmail.enviarEmailGmail(dadosConexao:THash; uo, destinatario, assunto, anexo: String; corpoMsg: Tstringlist; titulo, pesSender:String ):boolean;
var
  destinatarios, anexos:TStringList;
begin
   f.gravaLog('TfmEnviaEmail.enviarEmailGmail()');

   uEnviaEmail.DADOS_EMAIL := dadosConexao;

   anexos := TSTringList.Create();

   destinatarios := TStringList.Create();

   if (Trim(destinatario) <> '') then
      destinatarios.Add(destinatario);

   if (anexo <> '') then
      anexos.add(anexo);

   result := enviarEmailGmail2(uo, assunto, titulo, pesSender, anexos, corpoMsg, destinatarios);
   anexos.free();
end;

procedure TfmEnviaEmail.FormCreate(Sender: TObject);
begin
   DADOS_EMAIL := THash.Create();
end;

function TfmEnviaEmail.getDadoParamCon(nmParam: integer): String;
begin
   case nmParam of
   0:result := '';
   else
      result:= '';
   end;
end;

procedure TfmEnviaEmail.IdSMTPWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
   screen.Cursor := -11;
end;

procedure TfmEnviaEmail.IdSMTPWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
   screen.Cursor := 0;
end;

end.
