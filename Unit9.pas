unit Unit9;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, REST.Json,
  REST.Response.Adapter,
  FMX.ScrollBox, FMX.Memo, uLkJSON, uUsuario, uIde, uDestinatario;

type
  TForm9 = class(TForm)
    btTOKEN: TButton;
    FIdHTTPConexao: TIdHTTP;
    Memo1: TMemo;
    btEmitirnota: TButton;
    BtDownload: TButton;
    IdHTTP: TIdHTTP;
    OpenDialog1: TOpenDialog;
    procedure btTOKENClick(Sender: TObject);
    procedure btEmitirnotaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function Aspa(TextoX: String): String;
    procedure AddHeader(chave, Value: string; aIdHTTPConexao: TIdHTTP);
    procedure GerarHeader(aIdHTTPConexao: TIdHTTP);
    procedure ConfigHTTP(aIdHTTPConexao: TIdHTTP);
    procedure Clear(aIdHTTPConexao: TIdHTTP);
    procedure donwloadNota(link: string);
    { Private declarations }
  public
    { Public declarations }
    FToken: string;
    procedure gettoken;
    procedure emitirNota;
  end;

var
  Form9: TForm9;
  Url: string;
  Usuario: Tusuario;
  Ide : Tide;
  Destinatario : Tdestinatario;

implementation

uses
  System.Json;

{$R *.fmx}

procedure TForm9.btTOKENClick(Sender: TObject);
begin
  gettoken;
end;

procedure TForm9.btEmitirnotaClick(Sender: TObject);
begin
  emitirNota;
end;

procedure TForm9.gettoken;
var
  aArg: TStringList;
  JsonStreamEnvio: TStringList;
  JsonStreamRetorno: TStringStream;
  Jsonteste: TStringStream;
  js: TJSONObject;
  jslkJSON: TlkJSONobject;
  Retorno, Json: string;
  retornoBoolean:boolean;
begin
  JsonStreamRetorno := TStringStream.Create('');
  // JsonStreamEnvio   :=   TStringList.Create();
  Jsonteste := TStringStream.Create('');

  FIdHTTPConexao.Request.ContentType := '';
  FIdHTTPConexao.Response.Clear;
  FIdHTTPConexao.Request.CustomHeaders.Clear;

  Usuario.email := 'homologa@geniusnt.com';
  Usuario.username := 'homologa';
  Usuario.password := '1';

  js := Tjson.objectToJsonObject(Usuario);

  Memo1.Lines.Add(js.ToString);
  Jsonteste.WriteString(js.ToString);

  FIdHTTPConexao.Request.CustomHeaders.AddValue('Content-Type',
    'application/json');

  try // geniusnuvens.com.br
    FIdHTTPConexao.Post(Url + '/auth/token', Jsonteste, JsonStreamRetorno);

  finally

    jslkJSON := TlkJSON.ParseText(JsonStreamRetorno.DataString) as TlkJSONobject;
    retornoBoolean := jslkJSON.getBoolean('error');

    //usando para teste
    Retorno := JsonStreamRetorno.DataString;//ShowMessage(retorno);
    Memo1.Lines.Add(Retorno);
    //usando para teste
    if retornoboolean then
    begin
      Memo1.Lines.Add('=====================================');
      retorno := jslkJSON.getstring('message');
      Memo1.Lines.Add('Mensagem : '+ retorno);
    end else
    begin
      Memo1.Lines.Add('=====================================');
      Memo1.Lines.Add(Retorno);
    // ShowMessage(FToken );
      FToken := jslkJSON.getstring('access_token');   // <-Guarda esse token para as demais requisi��es
    end;

  end;

end;

function TForm9.Aspa(TextoX: String): String;
begin
  Result := chr(39) + TextoX + chr(39);
end;

procedure TForm9.AddHeader(chave: string; Value: string;
  aIdHTTPConexao: TIdHTTP);
begin
  with aIdHTTPConexao.Request.CustomHeaders do
  begin
    Add(chave + ':' + Value);
  end;
end;

{ Tusuario }


procedure TForm9.GerarHeader(aIdHTTPConexao: TIdHTTP);
var
  lIdHTTPConexao: TIdHTTP;
begin
  if FToken <> '' then
  begin
    if aIdHTTPConexao = nil then
    begin
      lIdHTTPConexao := FIdHTTPConexao;
    end
    else
    begin
      lIdHTTPConexao := aIdHTTPConexao;
    end;
    lIdHTTPConexao.Request.CustomHeaders.Clear;

    AddHeader('Content-Type', 'application/json', lIdHTTPConexao);
    AddHeader('cache-control', 'no-cache', lIdHTTPConexao);
  end;
end;

procedure TForm9.ConfigHTTP(aIdHTTPConexao: TIdHTTP);
var
  lIdHTTPConexao: TIdHTTP;
begin
  if aIdHTTPConexao = nil then
  begin
    lIdHTTPConexao := FIdHTTPConexao;
  end
  else
  begin
    lIdHTTPConexao := aIdHTTPConexao;
  end;
  with lIdHTTPConexao do
  begin
    ProtocolVersion := pv1_1;
    Request.Clear;
    Request.CustomHeaders.Clear;
    Request.BasicAuthentication := False;
    Request.Accept := 'application/json';
    // Request.ContentType := 'application/json';
    Request.AcceptCharSet := 'UTF-8';
    ProxyParams.BasicAuthentication := False;
  end;
end;

procedure TForm9.donwloadNota(link: string);
var
  arquivo: TMemoryStream;
begin
  arquivo := TMemoryStream.Create;
  try
    try
      IdHTTP.Get(link, arquivo);

      arquivo.SaveToFile('C:\Adriel\adriekkk.xml');

      // ShowMessage('O arquivo foi salvo no caminho: C:\Adriel\adriekkk.xml');
      Memo1.Lines.LoadFromFile('C:\Adriel\adriekkk.xml');

    except
      on E: EIdHttpProtocolException do
      begin
        if E.ErrorCode = 404 then
          ShowMessage('Danfe n�o encontrado!');
      end;
    end;
  finally
    FreeAndNil(arquivo);
  end;
end;

procedure TForm9.emitirNota;
var
  JsonStreamRetorno: TStringStream;
  Jsonteste: TStringStream;
  Retorno, Ajson, xmlNota: string;
  js,jsdest: TJSONObject;
  jslkJSON: TlkJSONobject;
  retornoBoolean :boolean;
begin

  Ide.indpres := 1;
  Ide.tpamb := 2;
  Ide.tpemis := 9; //1 teste
  Ide.tpimp := 4;

  Destinatario.email:='adriellf@live.com';
  Destinatario.cpf:='02912738580';//cpf aleatorio


  js := Tjson.objectToJsonObject(ide);
  jsdest:= Tjson.objectToJsonObject(Destinatario);

  // tem a forma correta de fazer mas a empresa quer assim para n�o perder tempo
  Ajson := '{"ide":' + js.ToString +',"dest":'+jsdest.ToJSON+ '}';

  JsonStreamRetorno := TStringStream.Create('');
  Jsonteste := TStringStream.Create('');
  Jsonteste.WriteString(Ajson);

  Memo1.Lines.Add('=====================================');
  Memo1.Lines.Add(Ajson);

  FIdHTTPConexao.Request.ContentType := '';
  FIdHTTPConexao.Response.Clear;
  FIdHTTPConexao.Request.CustomHeaders.Clear;
  FIdHTTPConexao.Request.CustomHeaders.AddValue('Content-Type',
    'application/json');
  FIdHTTPConexao.Request.CustomHeaders.AddValue('Authorization',
    'bearer ' + FToken);

  try

      FIdHTTPConexao.Post(Url + '/api/vendas/779/nfces', Jsonteste,JsonStreamRetorno);
  finally

      jslkJSON := TlkJSON.ParseText(JsonStreamRetorno.DataString) as TlkJSONobject;
      retornoBoolean := jslkJSON.getBoolean('error');

      if retornoboolean then
      begin
        Memo1.Lines.Add('=====================================');
        retorno := jslkJSON.getstring('message');
        Memo1.Lines.Add('Mensagem : '+ retorno);
      end else
      begin
        xmlNota := jslkJSON.getstring('xml_url');
        Memo1.Lines.Add('xmlNota : '+xmlNota);
      end;
     { if retorno = 'true' then
      begin
        Memo1.Lines.Add('=====================================');
        Memo1.Lines.Add('entrou: '+ retorno);
      end else
      begin
        jslkJSON := TlkJSON.ParseText(JsonStreamRetorno.DataString) as TlkJSONobject;
        Retorno := JsonStreamRetorno.DataString;
        Memo1.Lines.Add('=====================================');
        Memo1.Lines.Add(FIdHTTPConexao.ResponseCode.ToString);
        Memo1.Lines.Add(Retorno);
      end;  }

  {  if false then
    begin
      jslkJSON := TlkJSON.ParseText(JsonStreamRetorno.DataString) as TlkJSONobject;
      xmlNota := jslkJSON.getstring('xml_url');
      Memo1.Lines.Add('xmlNota: '+xmlNota);
      Memo1.Lines.Add('=====================================');
      //if xmlNota <> '' then   donwloadNota(xmlNota);
    end; }
  end;

end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  Url := 'http://192.168.0.34:8000';
  Usuario:= Tusuario.Create;
  Ide := Tide.Create;
  Destinatario := Tdestinatario.Create;
end;

procedure TForm9.Clear(aIdHTTPConexao: TIdHTTP);
var
  lIdHTTPConexao: TIdHTTP;
begin
  if aIdHTTPConexao = nil then
  begin
    lIdHTTPConexao := FIdHTTPConexao;
  end
  else
  begin
    lIdHTTPConexao := aIdHTTPConexao;
  end;
  FIdHTTPConexao.Request.Clear;
end;

end.
