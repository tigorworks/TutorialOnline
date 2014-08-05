program ImageThread;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uthImageMove in 'uthImageMove.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
