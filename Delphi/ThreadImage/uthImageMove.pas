unit uthImageMove;

interface

uses
  Classes,ExtCtrls,forms;

type
  TFlowMove = (fmToRight,fmToLeft);
  TTHImageMove = class(TThread)
  private
    FFlowMove: TFlowMove;
    FImage: TImage;
    FMaxLeft: integer;
    FMinLeft: integer;
    FisRun: Boolean;
    procedure startMove;
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create;
    property Image: TImage read FImage write FImage;
    property FlowMove: TFlowMove read FFlowMove write FFlowMove;
    property MaxLeft: integer read FMaxLeft write FMaxLeft;
    property MinLeft: integer read FMinLeft write FMinLeft;
    property isRun: Boolean read FisRun write FisRun;
    procedure Stop;
  end;

implementation


{ TTHImageMove }

constructor TTHImageMove.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FFlowMove := fmToRight;
  FMaxLeft := -1;
  FMinLeft := -1;
  FisRun := False;
end;

procedure TTHImageMove.Execute;
begin
  while (True) do
  begin
    FisRun := True;
    Synchronize(startMove);
    sleep(100);
    Application.ProcessMessages;
    if Terminated then
    begin
      FisRun := False;
      Break;
    end;
  end;
end;

procedure TTHImageMove.startMove;
begin
  case FFlowMove of
    fmToRight: 
    begin
      if FMaxLeft > -1 then
      begin
        if Image.Left >= FMaxLeft then
          exit;
      end;
  
      Image.Left := Image.Left + 1;
    end;
    fmToLeft: 
    begin
      if FMinLeft > -1 then
      begin
        if Image.Left <= FMinLeft then
          exit;
      end;
      Image.Left := Image.Left - 1;
    end;
  end;
end;

procedure TTHImageMove.Stop;
begin
  Terminate;
end;

end.
