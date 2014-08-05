unit jsonquery;

interface

uses
  classes,sysutils,DB,DBClient,dialogs,superobject,httpsend;

type
  TJSONQuery = class(TCustomClientDataSet)
  private
    FURL: string;
    FAuthor: string;
    procedure resetState;
    function MemoryStreamToString(M: TMemoryStream): string;
    procedure JSONToData(AData: string);
    procedure SetAuthor(const Value: string);
  published
    property URL: string read FURL write FURL;
    property CommandText;
    property Author: string read FAuthor write SetAuthor;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure Open;
    procedure Execute;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tigor Manurung',[TJSONQuery]);
end;

{ TJSONQuery }

constructor TJSONQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAuthor := 'Tigor Mangatur Manurung';
end;

destructor TJSONQuery.Destroy;
begin
  inherited;
end;

procedure TJSONQuery.Execute;
begin
  Open;
end;

procedure TJSONQuery.JSONToData(AData: string);
var
  o,ARecord,item: ISuperObject;
  iCol,iRow: integer;
begin
  resetState;
  o := so(AData);
  if (o = nil) or (trim(AData) = '') then
    exit;
  iCol := 0;
  Close;
  for item in o['column'] do
  begin
    FieldDefs.Add(item.AsString,ftString,40);
    inc(iCol,1);
  end;
  CreateDataSet;
  iCol := 0;
  iRow := 1;
  for ARecord in o['records'] do
  begin
    iCol := 0;
    Append;
    for item in ARecord do
    begin
      FieldByName(FieldDefs[iCol].Name).AsString := item.AsString;
      Inc(iCol,1);
    end;
    Post;
      Inc(iRow,1);
  end;
end;

function TJSONQuery.MemoryStreamToString(M: TMemoryStream): string;
begin
  M.Seek(0,soFromBeginning);
  SetString(Result, PAnsiChar(M.Memory), M.Size);
end;

procedure TJSONQuery.Open;
var
  AStream: TMemoryStream;
  sData: string;
begin
  if FURL = '' then
    raise Exception.Create('Alamat web service harus diisi!');
  if CommandText = '' then
    raise Exception.Create('Command text harus diisi!');

  AStream := TMemoryStream.Create;
  try
    HttpPostURL(FURL,Format('sql=%s',[self.CommandText]),AStream);
    sData := MemoryStreamToString(AStream);
    JSONToData(sData);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TJSONQuery.resetState;
begin
  FieldDefs.Clear;
end;

procedure TJSONQuery.SetAuthor(const Value: string);
begin
//  FAuthor := Value;
end;

end.
