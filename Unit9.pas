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
  FMX.ScrollBox, FMX.Memo, uLkJSON;

type
  Tusuario = Class
  private
    Femail: string;
    Fpassword: string;
    Fusername: string;
    procedure Setemail(const Value: string);
    procedure Setpassword(const Value: string);
    procedure Setusername(const Value: string);

  public
    property username: string read Fusername write Setusername;
    property email: string read Femail write Setemail;
    property password: string read Fpassword write Setpassword;
  End;

type
  Tide = class
  private
    Fdhsaient: String;
    Findpres: integer;
    Ftpamb: integer;
    Ftpemis: integer;
    Ftpimp: integer;
    procedure Setdhsaient(const Value: String);
    procedure Setindpres(const Value: integer);
    procedure Settpamb(const Value: integer);
    procedure Settpimp(const Value: integer);
    procedure Settpemis(const Value: integer);

  public
    property tpimp: integer read Ftpimp write Settpimp;
    property ttpemis: integer read Ftpemis write Settpemis;
    property dhsaient: String read Fdhsaient write Setdhsaient;
    property tpamb: integer read Ftpamb write Settpamb;
    property indpres: integer read Findpres write Setindpres;

  end;

type
 Tdestinatario = class
   private
    Femail: string;
    Fcpf: string;
    procedure Setcpf(const Value: string);
    procedure Setemail(const Value: string);
   public
    property email : string read Femail write Setemail;
    property cpf : string read Fcpf write Setcpf;
 end;

  TArrayide = array of Tide;

  TRespide = class
  private
    Frespide: TArrayide;
    procedure Setrespide(const Value: TArrayide);
  published
    property respide: TArrayide read Frespide write Setrespide;
  end;

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
  dados: Tusuario;
  Retorno, Json: string;
begin
  JsonStreamRetorno := TStringStream.Create('');
  // JsonStreamEnvio   :=   TStringList.Create();
  Jsonteste := TStringStream.Create('');
  dados := Tusuario.Create;

  FIdHTTPConexao.Request.ContentType := '';
  FIdHTTPConexao.Response.Clear;
  FIdHTTPConexao.Request.CustomHeaders.Clear;

  dados.email := 'homologa@geniusnt.com';
  dados.username := 'homologa';
  dados.password := '1';

  js := Tjson.objectToJsonObject(dados);

  Memo1.Lines.Add(js.ToString);
  Jsonteste.WriteString(js.ToString);

  FIdHTTPConexao.Request.CustomHeaders.AddValue('Content-Type',
    'application/json');

  try // geniusnuvens.com.br
    FIdHTTPConexao.Post(Url + '/auth/token', Jsonteste, JsonStreamRetorno);

    Retorno := JsonStreamRetorno.DataString;
  finally
    Memo1.Lines.Add('=====================================');
    Memo1.Lines.Add(Retorno);
    jslkJSON := TlkJSON.ParseText(JsonStreamRetorno.DataString)
      as TlkJSONobject;
    FToken := jslkJSON.getstring('access_token');

    // <-Guada esse token para as demais requisições
    // ShowMessage(FToken );
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

procedure Tusuario.Setemail(const Value: string);
begin
  Femail := Value;
end;

procedure Tusuario.Setpassword(const Value: string);
begin
  Fpassword := Value;
end;

procedure Tusuario.Setusername(const Value: string);
begin
  Fusername := Value;
end;

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
          ShowMessage('Danfe não encontrado!');
      end;
    end;
  finally
    FreeAndNil(arquivo);
  end;
end;

procedure TForm9.emitirNota;
var
  dados: Tide;
  destinatario : Tdestinatario;
  arrayjson: TRespide;
  JsonStreamRetorno: TStringStream;
  Jsonteste: TStringStream;
  Retorno, Ajson, xmlNota: string;
  js,jsdest: TJSONObject;
  jslkJSON: TlkJSONobject;
begin
  dados := Tide.Create;
  dados.Findpres := 1;
  dados.Ftpamb := 2;
  dados.Ftpemis := 1;
  dados.tpimp := 4;

  destinatario := Tdestinatario.Create;
  destinatario.Femail:='analise@geniusnt.com';
  destinatario.Fcpf:='85931956522';



  js := Tjson.objectToJsonObject(dados);
  jsdest:= Tjson.objectToJsonObject(destinatario);

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
    try
      FIdHTTPConexao.Post(Url + '/api/vendas/779/nfces', Jsonteste,
        JsonStreamRetorno);
    except
      on E: EIdHttpProtocolException do
      begin
        if E.ErrorCode = 404 then
          ShowMessage('Danfe não encontrado!');
        exit
      end;

    end;

  finally
    Retorno := JsonStreamRetorno.DataString;
    Memo1.Lines.Add('=====================================');
    Memo1.Lines.Add(FIdHTTPConexao.ResponseCode.ToString);
    Memo1.Lines.Add(Retorno);

    jslkJSON := TlkJSON.ParseText(JsonStreamRetorno.DataString)
      as TlkJSONobject;

    xmlNota := jslkJSON.getstring('xml_url');
    Memo1.Lines.Add('xmlNota: '+xmlNota);
    Memo1.Lines.Add('=====================================');
    //if xmlNota <> '' then   donwloadNota(xmlNota);
  end;

end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  Url := 'http://192.168.0.34:8000';
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
{ Tide }

procedure Tide.Setdhsaient(const Value: String);
begin
  Fdhsaient := Value;
end;

procedure Tide.Setindpres(const Value: integer);
begin
  Findpres := Value;
end;

procedure Tide.Settpamb(const Value: integer);
begin
  Ftpamb := Value;
end;

procedure Tide.Settpimp(const Value: integer);
begin
  Ftpimp := Value;
end;

procedure Tide.Settpemis(const Value: integer);
begin
  Ftpemis := Value;
end;

{ TRespide }

procedure TRespide.Setrespide(const Value: TArrayide);
begin
  Frespide := Value;
end;

{ Tdestinatario }

procedure Tdestinatario.Setcpf(const Value: string);
begin
  Fcpf := Value;
end;

procedure Tdestinatario.Setemail(const Value: string);
begin
  Femail := Value;
end;

end.
