unit QueryExecutor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ZConnection, ZDataset,udm;

type

  { TQueryExecutor }
  TOnQueryEvent = procedure(Sender: TObject ; ASQL: string) of object;

  TQueryExecutor = class(TThread)
  private
    FOnAfterExecSQL: TNotifyEvent;
    FOnQueryError: TOnQueryEvent;
    FQuery: TZQuery;
    FList: TStringList;
    FSQLQueue: integer;
    FOnExecQuery: TOnQueryEvent;
    procedure DecList;
  public
    constructor Create(ASQLList: TStringList);
    destructor Destroy;
    property SQLQueue: integer read FSQLQueue write FSQLQueue;
    property OnAfterExecSQL: TNotifyEvent read FOnAfterExecSQL write FOnAfterExecSQL;
    property OnExecQuery: TOnQueryEvent read FOnExecQuery write FOnExecQuery;
    property OnQueryError: TOnQueryEvent read FOnQueryError write FOnQueryError;
  protected
    procedure Execute; override;
  end;

  { TQueryList }

  TQueryList = class
  private
    FFExecutor: TQueryExecutor;
    FOnExecQuery: TOnQueryEvent;
    FOnQueryError: TOnQueryEvent;
    FSQLList: TStringList;
    FExecutor: TQueryExecutor;
    FSQLQueue: integer;
    procedure OnAfterExecSQL(Sender: TObject);
    procedure EvOnExecQuery(Sender: TObject ; SQL: string);
    procedure EvOnQueryError(Sender: TObject ; SQL: string);
  public
    constructor Create;
    destructor Destroy;
    procedure AddJob(ASQL: string);
    property SQLQueue: integer read FSQLQueue write FSQLQueue;
    property Executor: TQueryExecutor read FFExecutor;
    property OnExecQuery: TOnQueryEvent read FOnExecQuery write FOnExecQuery;
    property OnQueryError: TOnQueryEvent read FOnQueryError write FOnQueryError;
  end;



implementation

{ TQueryExecutor }

procedure TQueryExecutor.DecList;
begin
  FList.Delete(0);
end;

constructor TQueryExecutor.Create(ASQLList: TStringList);
begin
  inherited Create(True);
  FQuery := TZQuery.Create(nil);
  FQuery.Connection := dm.zConn;
  FList := ASQLList;
  FreeOnTerminate:=True;
end;

destructor TQueryExecutor.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

procedure TQueryExecutor.Execute;
var
  asql : string;
begin
  FreeOnTerminate:=True;
  while (true) and (not Terminated) do
	begin
    try
    if FList.Count < 1 then
    begin
      Sleep(500);
   	  Continue;
    end;

    if Trim(FList[0]) = '' then
    begin
      Sleep(500);
      Continue;
    end;
    with FQuery do
		begin
      Close;
      asql := FList[0];
      sql.Text:=asql;


      if Assigned(FOnExecQuery) then
      	 FOnExecQuery(Self,asql);

      ExecSQL;
      FSQLQueue:=FList.Count;
      if Assigned(FOnAfterExecSQL) then
      	 FOnAfterExecSQL(Self);
      Synchronize(@DecList);
      //FList.Delete(0);
      //FList.Delete(0);
      //sleep(50)
    end;

    except
      with dm do
      begin
        //zConn.Disconnect;
        if Assigned(FOnQueryError) then
        	 FOnQueryError(Self,asql);
        zConn.Connect;
      end;
    end;
  end;
end;

{ TQueryExecutor }

procedure TQueryList.OnAfterExecSQL(Sender: TObject);
begin
  FSQLQueue:=FSQLList.Count;
end;

procedure TQueryList.EvOnExecQuery(Sender: TObject; SQL: string);
begin
  if Assigned(FOnExecQuery) then
  	 FOnExecQuery(Sender,SQL);
end;

procedure TQueryList.EvOnQueryError(Sender: TObject; SQL: string);
begin
  if Assigned(FOnQueryError) then
  	 FOnQueryError(Sender,SQL);
end;

constructor TQueryList.Create;
begin
  FSQLList := TStringList.Create;
  FExecutor := TQueryExecutor.Create(FSQLList);
  FExecutor.OnAfterExecSQL:=@OnAfterExecSQL;
  FExecutor.OnExecQuery:=@EvOnExecQuery;
  FExecutor.Resume;
end;

destructor TQueryList.Destroy;
begin
  FreeAndNil(FSQLList);
  FExecutor.Terminate;
end;

procedure TQueryList.AddJob(ASQL: string);
begin
  FSQLList.Add(ASQL);
end;



end.

