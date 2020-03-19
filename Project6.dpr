program Project6;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit9 in 'Unit9.pas' {Form9},
  uUsuario in 'uUsuario.pas',
  uIde in 'uIde.pas',
  uDestinatario in 'uDestinatario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.
