unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxGDIPlusClasses, ExtCtrls, uthImageMove, ComCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    rgImage1: TRadioGroup;
    rgImage2: TRadioGroup;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    procedure MoveImage(var AImageThread: TTHImageMove ; AImage: TImage ;AFlow: TFlowMove);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FImage1,FImage2: TTHImageMove;


implementation

{$R *.dfm}

procedure TForm1.Image1Click(Sender: TObject);
begin
  MoveImage(FImage1,Image1,TFlowMove(rgImage1.ItemIndex));
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  MoveImage(FImage2,Image2,TFlowMove(rgImage2.ItemIndex));
end;

procedure TForm1.MoveImage(var AImageThread: TTHImageMove;AImage: TImage ;AFlow: TFlowMove);
begin
  if not Assigned(AImageThread) then
  begin
    AImageThread := TTHImageMove.Create;
    AImageThread.Image := AImage;
    AImageThread.FlowMove := AFlow;
    AImageThread.MinLeft := 8;
    AImageThread.MaxLeft := Form1.ClientWidth - AImage.Width - 1;
    AImageThread.Resume;
  end
  else
  begin
    AImageThread.Stop;
    AImageThread := nil;
  end;
end;

end.
