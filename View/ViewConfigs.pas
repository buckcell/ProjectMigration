unit ViewConfigs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TWindowConfigs = class(TForm)
    LblLimitRows: TLabel;
    RadioBtnAllRows: TRadioButton;
    RadioBtnLimitRows: TRadioButton;
    TxtLimitRows: TEdit;
    PanelRows: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure RadioBtnAllRowsClick(Sender: TObject);
    procedure RadioBtnLimitRowsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WindowConfigs: TWindowConfigs;

implementation

{$R *.dfm}

procedure TWindowConfigs.RadioBtnAllRowsClick(Sender: TObject);
begin
  RadioBtnLimitRows.Checked := false;
  TxtLimitRows.Enabled := false;
end;

procedure TWindowConfigs.RadioBtnLimitRowsClick(Sender: TObject);
begin
  RadioBtnAllRows.Checked := false;
  TxtLimitRows.Enabled := true;
  TxtLimitRows.SetFocus;
end;

end.