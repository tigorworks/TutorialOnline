unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, DBClient, jsonquery, StdCtrls;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    JSONQuery1: TJSONQuery;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  JSONQuery1.Close;
  JSONQuery1.CommandText := 'select * from inf_lokasi';
  JSONQuery1.Open;
  ShowMessage(JSONQuery1.FieldByName('Lokasi_ID').AsString);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  JSONQuery1.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // JSONQuery1.Open;
end;

end.
