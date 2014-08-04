unit udm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, db,IniFiles,forms;

type

  { Tdm }

  Tdm = class(TDataModule)
    dsAct: TDataSource;
    zConn: TZConnection;
    qView: TZQuery;
    zConnMon: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LoadConfig;
    { private declarations }
  public
    { public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  LoadConfig;
  zConn.Connect;
  zConnMon.Connect;
end;

procedure Tdm.LoadConfig;
var
  AFileIni: TIniFile;
  i: integer;
begin
  AFileIni := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TZConnection then
      begin
        with TZConnection(Components[i]),AFileIni do
				begin
          HostName:=ReadString('general','host','localhost');
          Port:=ReadInteger('general','port',0);
          Database:=ReadString('general','db','da1');
          User:=ReadString('general','user','root');
          Password:=ReadString('general','password','');
          LibraryLocation:=ReadString('general','librarylocation','libmySQL50.dll');
        end;
      end;
    end;

  finally
    FreeAndNil(AFileIni);
  end;

end;

end.

