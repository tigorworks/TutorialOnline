unit DA1Class;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,httpsend, udm,RegExpr,fpjson,Clipbrd,QueryExecutor;

type
  TDA1 = class;

  { TDA1 }

  { TItemVal }

  TItemVal = class
    Sec,ID,Caption: string;
    p,j: integer;
    constructor Create(ASec,AID,ACaption: string ; Ap,Aj: integer);
  end;

  { TDA1Executor }

  TDA1Executor = class(TThread)
  private
    FID,FIDParent: string;
    FExecutor,FTemp: TQueryList;
    FName: string;
    FDA1: TDA1;
    procedure syncExecutor;
  public
    constructor Create(AID,AIDParent:String ;var AExecutor: TQueryList);
    destructor Destroy;override;
    property Name: string read FName write FName;
  protected
    procedure Execute; override;
  end;

  TDA1 = class
  private
    FID,FIDParent: string;
    FQueryExecutor: TQueryList;
    FThreadList: TList;
    function GetUrlData(AUrl: string): string;
    function getBaseRegex(AText,AExpression: string ; var outReg: TRegExpr): boolean;
    function SimpleRegEx(AText,AExpression: string): string;
    procedure getData(Ap,Agp: string;ASec: integer=0);
    function getLastRegData(AText,AExpression: string): string;
    function getRegIndex(AText,AExpression: string ; AIndex: integer): string;
    procedure SaveRegion(AID,AName,AParent,AGrandParent: string);
    procedure SaveCount(AID,AParent,APr,AJk: string);

    //spesific parse
    function getLabel(s: string): string;
  public
    property ID: string read FID write FID;
    property IDParent: string read FIDParent write FIDParent;
    property ThreadList: TList read FThreadList write FThreadList;
    constructor Create;
    destructor Destroy;override;
    procedure ImportData;
  end;

var
  _QueryExecutor: TQueryList;

const
  URL_DA1 = 'http://pilpres2014.kpu.go.id/da1.php';

  table_pattern = '<table.*?>(.*?)</table>';
  tr_pattern = '<tr.*?>(.*?)</tr>';
  td_pattern = '<td.*?>(.*?)</td>';

implementation

{ TDA1Executor }

procedure TDA1Executor.syncExecutor;
begin
  FExecutor := FTemp;
end;

constructor TDA1Executor.Create(AID,AIDParent:String ;var AExecutor: TQueryList);
begin
  inherited Create(True);
  FreeOnTerminate:=True;
  FID:=AID;
  FIDParent:=AIDParent;
  FTemp := AExecutor;
  Synchronize(@syncExecutor);
  FDA1 := TDA1.Create;
  FDA1.ID:=AID;
  FDA1.IDParent:=AIDParent;
end;

destructor TDA1Executor.Destroy;
begin
  FreeAndNil(FDA1);
  inherited;
end;

procedure TDA1Executor.Execute;
var
  s: string;
begin
  try
  	 FDA1.ImportData;
  except

  end;
end;

{ TItemVal }

constructor TItemVal.Create(ASec, AID, ACaption: string ; Ap,Aj: integer);
begin
  Sec:=ASec;
  ID:=AID;
  Caption:=ACaption;
  p := Ap;
  j := Aj;
end;

{ TDA1 }

function TDA1.getLabel(s: string): string;
var
  sTemp: string;
begin
  sTemp := StringReplace(SimpleRegEx(s,'[?>].*.[?=<]'),'<','',[rfReplaceAll]);
  sTemp := StringReplace(sTemp,'>','',[rfReplaceAll]);
  Result := Trim(sTemp);
end;

constructor TDA1.Create;
begin
  FThreadList := TList.Create;
  FQueryExecutor := _QueryExecutor;
end;

destructor TDA1.Destroy;
begin
  FreeAndNil(FThreadList);
end;

function TDA1.GetUrlData(AUrl: string): string;
var
  slData: TStringList;
begin
  slData := TStringList.Create;
  try
    HttpGetText(AUrl,slData);
    result := slData.Text;
  finally
    FreeAndNil(slData);
  end;
end;

function TDA1.getBaseRegex(AText, AExpression: string; var outReg: TRegExpr
  ): boolean;
begin
  Result := False;
  outReg.Expression:=AExpression;
  Result := outReg.Exec(AText);
end;

function TDA1.SimpleRegEx(AText, AExpression: string): string;
var
  o: TRegExpr;
begin
  o := TRegExpr.Create;
  try
    if getBaseRegex(AText,AExpression,o) then
    begin
       Result := o.Match[0];
    end;
  finally
    FreeAndNil(o);
  end;
end;

procedure TDA1.getData(Ap, Agp: string;ASec: integer);

function getId(s: string): string;
begin
  result := StringReplace(SimpleRegEx(s,'[?"].*.[?="]'),'"','',[rfReplaceAll]);
end;

var
  sUri,sData,s: string;
  o: TJSONObject;
  a: TJSONArray;
  oReg: TRegExpr;
  sTable,sRow,sJk,sPr: string;
  i: integer;
  AThread: TDA1Executor;
begin
  oReg := TRegExpr.Create;
  try
    try
      sUri:=Format('%s?cmd=select&grandparent=%s&parent=%s',[URL_DA1,AGp,Ap]);

      sData:='';

      //get data from server
      while Trim(sData) = '' do
      begin
        try
        	 sData:=GetUrlData(sUri);
        except
        end;
      end;

      if getBaseRegex(sData,'<option.\svalue=\s*"[^"]*".\s*[^"]*>',oReg) then
        begin
          repeat
            s := oReg.Match[0];
            SaveRegion(getId(s),getLabel(s),Ap,AGp);

            //jika data provinsi, maka buat thread sejumlah provinsi
            if Ap = '' then
            begin
              AThread := TDA1Executor.Create(getId(s),ap,FQueryExecutor);
              AThread.Name:=getLabel(s);
              AThread.Resume;
              FThreadList.Add(AThread);
            end
            else
        	    getData(getId(s),Ap,ASec+1);

          until oReg.ExecNext = false;
        end
      else
      begin
        if Pos('Rincian Jumlah Perolehan Suara Pasangan Calon Presiden dan Wakil Presiden',sData) > 0 then
        begin
          sTable:=getLastRegData(sData,table_pattern);

          //prabowo
          sRow:=getRegIndex(sTable,tr_pattern,3);
          sPr:=getLastRegData(sRow,td_pattern);

          //jokowi
          sRow:=getRegIndex(sTable,tr_pattern,4);
          sJk:=getLastRegData(sRow,td_pattern);

          //save count result
          SaveCount(Ap,Agp,getLabel(sPr),getLabel(sJk));
        end;
      end;
      //sData:='satu';

    except
      //error?retrying.
      getData(Ap,Agp,ASec);
    end;

  finally
    FreeAndNil(oReg);
  end;
end;

function TDA1.getLastRegData(AText, AExpression: string): string;
var
  o: TRegExpr;
  s: string;
begin
  s := '';
  o := TRegExpr.Create;
  try
    if getBaseRegex(AText,AExpression,o) then
    begin
      repeat
        s := o.Match[0];
			until not o.ExecNext;
		end;
	finally
    FreeAndNil(o);
	end;

  Result := s;
end;

function TDA1.getRegIndex(AText, AExpression: string; AIndex: integer): string;
var
  o: TRegExpr;
  i: integer;
begin
  Result:='';
  o := TRegExpr.Create;
  try
    i:=0;
    if getBaseRegex(AText,AExpression,o) then
    begin
      while i<AIndex do
      begin
        o.ExecNext;
        inc(i,1);
		  end;
      Result := o.Match[0];
		end;
	finally
    FreeAndNil(o);
	end;
end;

procedure TDA1.SaveRegion(AID, AName, AParent,AGrandParent: string);
var
  ASql: string;
begin
  ASql := Format('insert ignore into dataimport(idreg,name,p,gp)values(''%s'',''%s'',''%s'',''%s'')',[AID,AName,AParent,AGrandParent]);
  FQueryExecutor.AddJob(ASql);
end;

procedure TDA1.SaveCount(AID, AParent, APr, AJk: string);
var
  ASql: string;
begin
  if (APr = '0') and (AJk = '0') then exit;
  ASql := Format('update dataimport set prabowo = ''%s'', jokowi = ''%s'' where idreg=''%s'' and p=''%s''',[APr,AJk,AID,AParent]);
  FQueryExecutor.AddJob(ASql);
end;


procedure TDA1.ImportData;
begin
  getData(FID,FIDParent);
end;

end.

