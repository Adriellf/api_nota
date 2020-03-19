unit uUsuario;

interface
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
    property email: string  read Femail write Setemail;
    property password: string read Fpassword write Setpassword;
  End;


implementation

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

end.
