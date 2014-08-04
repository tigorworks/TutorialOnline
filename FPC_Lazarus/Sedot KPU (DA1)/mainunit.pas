unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TASources, TAChartListbox,
  TADbSource, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  ZConnection, httpsend, RegExpr, DA1Class, QueryExecutor;

type

  { TFormMain }

  TFormMain = class(TForm)
    btnDownload: TButton;
    ChartPie: TChart;
    ChartPiePieSeries1: TPieSeries;
    chartSource: TListChartSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbQueue: TLabel;
    lbTotal: TLabel;
    lbpr: TLabel;
    lbjk: TLabel;
    lvThread: TListView;
    mError: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    sbMain: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    tmMon: TTimer;
    procedure btnDownloadClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmMonTimer(Sender: TObject);
  private
    FDA1: TDA1;
    procedure EvOnExecQuery(Sender: TObject ; SQL: string);
    procedure EvOnQueryError(Sender: TObject ; SQL: string);
    { private declarations }
  public
    { public declarations }
  end;

var
  FormMain: TFormMain;

const
  URL_DA1 = 'http://pilpres2014.kpu.go.id/da1.php';

implementation

uses udm;


{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormShow(Sender: TObject);
begin

end;

procedure TFormMain.tmMonTimer(Sender: TObject);
var
  i: integer;
  sPr,sJk: string;
begin
  lvThread.Items.BeginUpdate;
  lvThread.Items.Clear;
  for i:= 0 to FDA1.ThreadList.Count - 1 do
  begin
    if FDA1.ThreadList[i] <> nil then
    begin
      if Trim(TDA1Executor(FDA1.ThreadList[i]).Name) = '' then Continue;
   	  with lvThread.Items.Add do
			begin
        Caption:=TDA1Executor(FDA1.ThreadList[i]).Name;
        SubItems.Add('Running');
      end;
    end;
  end;

  lvThread.Items.EndUpdate;

  with dm.qView do
  begin
    Close;
    sql.Text:='select * from vw_realcount';
    Open;
    sPr:=(Format('0|%f|?|Prabowo - Hatta (%f%s)',[FieldByName('prabowopr').AsFloat,FieldByName('prabowopr').AsFloat,'%']));
    sJk:=(Format('0|%f|?|Jokowi - JK (%f%s)',[FieldByName('jokowipr').AsFloat,FieldByName('jokowipr').AsFloat,'%']));

    if (FieldByName('prabowopr').AsFloat < 1) and (FieldByName('jokowipr').AsFloat < 1) then exit;
    chartSource.DataPoints.Clear;
  	chartSource.DataPoints.Add(sPr);
    chartSource.DataPoints.Add(sJk);

    lbpr.Caption:= FormatFloat('#,##0',FieldByName('prabowo').AsFloat);
    lbjk.Caption:= FormatFloat('#,##0',FieldByName('jokowi').AsFloat);
    lbTotal.Caption:=FormatFloat('#,##0',FieldByName('prabowo').AsFloat + FieldByName('jokowi').AsFloat);
  end;
  lbQueue.Caption:= FormatFloat('#,##0',_QueryExecutor.SQLQueue);;

end;

procedure TFormMain.EvOnExecQuery(Sender: TObject; SQL: string);
begin
  sbMain.SimpleText:=Format('SQL : %s',[SQL]);
end;

procedure TFormMain.EvOnQueryError(Sender: TObject; SQL: string);
begin
  mError.Lines.Add(SQL);
end;



procedure TFormMain.btnDownloadClick(Sender: TObject);
var
  s: string;
begin
  FDA1 := TDA1.Create;
  try
    FDA1.ID:='';
    FDA1.IDParent:='0';
    FDA1.ImportData;
    tmMon.Enabled:=True;
  finally
  end;
  btnDownload.Enabled:=False;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin

end;

procedure TFormMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeAndNil(dm);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  dm := Tdm.Create(Self);
  _QueryExecutor := TQueryList.Create;
  _QueryExecutor.OnExecQuery:=@EvOnExecQuery;
  _QueryExecutor.OnQueryError:=@EvOnQueryError;
end;

end.

