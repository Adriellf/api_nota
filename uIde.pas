unit uIde;

interface
 type
  Tide = class
  private
    Fdhsaient: String;
    Ftpemis: integer;
    Findpres: integer;
    Ftpamb: integer;
    Ftpimp: integer;
    procedure Setdhsaient(const Value: String);
    procedure Setindpres(const Value: integer);
    procedure Settpamb(const Value: integer);
    procedure Settpimp(const Value: integer);
    procedure Settpemis(const Value: integer);


  public
    property tpimp: integer read Ftpimp write Settpimp;
    property tpemis: integer read Ftpemis write Settpemis;
    property dhsaient: String read Fdhsaient write Setdhsaient;
    property tpamb: integer read Ftpamb write Settpamb;
    property indpres: integer read Findpres write Setindpres;

  end;

 var
  Ide:Tide;
implementation

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

end.
