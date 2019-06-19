unit ViewConfigs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, System.Actions, Vcl.ActnList,
  MyUtils, Configs;

type
  TWindowConfigs = class(TForm)
    LblDatasLimit: TLabel;
    RadioAllDatas: TRadioButton;
    RadioDatasLimit: TRadioButton;
    TxtDatasLimit: TEdit;
    PageConfigs: TPageControl;
    TabDados: TTabSheet;
    TabFirebird: TTabSheet;
    CheckTruncFB: TCheckBox;
    BtnTestConn: TSpeedButton;
    BtnSave: TSpeedButton;
    Actions: TActionList;
    ActSave: TAction;
    ActDiscard: TAction;
    procedure RadioAllDatasClick(Sender: TObject);
    procedure RadioDatasLimitClick(Sender: TObject);
    procedure ActDiscardExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
  end;

var
  WindowConfigs: TWindowConfigs;
  DidChange: boolean;

implementation

{$R *.dfm}

procedure TWindowConfigs.ActSaveExecute(Sender: TObject);
begin
  TConfigs.SetConfig('GENERAL', 'DatasLimit', TUtils.Iff(RadioAllDatas.Checked or (StrToInt(TxtDatasLimit.Text) < 0), '-1', TxtDatasLimit.Text));
  TConfigs.SetConfig('GENERAL', 'TruncFB', TUtils.Iff(CheckTruncFB.Checked, '1', '0'));
end;

procedure TWindowConfigs.ActDiscardExecute(Sender: TObject);
begin
  //
end;

procedure TWindowConfigs.RadioAllDatasClick(Sender: TObject);
begin
  RadioDatasLimit.Checked := false;
  TxtDatasLimit.Enabled := false;
end;

procedure TWindowConfigs.RadioDatasLimitClick(Sender: TObject);
begin
  RadioAllDatas.Checked := false;
  TxtDatasLimit.Enabled := true;
  TxtDatasLimit.SetFocus;
end;

end.
