program bacada1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, zcomponent, mainunit, DA1Class, udm, QueryExecutor
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  //Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFormMain, FormMain);

  Application.Run;
end.
