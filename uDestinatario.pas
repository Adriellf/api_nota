unit uDestinatario;

interface

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
implementation

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
