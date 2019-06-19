object WindowConfigs: TWindowConfigs
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Migrator - Configura'#231#245'es'
  ClientHeight = 366
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    338
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object BtnTestConn: TSpeedButton
    Left = 139
    Top = 338
    Width = 89
    Height = 23
    Action = ActDiscard
    Anchors = [akLeft, akBottom]
  end
  object BtnSave: TSpeedButton
    Left = 234
    Top = 338
    Width = 92
    Height = 23
    Action = ActSave
    Anchors = [akLeft, akBottom]
  end
  object PageConfigs: TPageControl
    Left = 8
    Top = 8
    Width = 322
    Height = 324
    ActivePage = TabDados
    TabOrder = 0
    object TabDados: TTabSheet
      Caption = 'Dados'
      object LblDatasLimit: TLabel
        Left = 3
        Top = 3
        Width = 88
        Height = 13
        Caption = 'Limite de migra'#231#227'o'
      end
      object RadioAllDatas: TRadioButton
        Left = 3
        Top = 22
        Width = 49
        Height = 17
        Caption = 'Todas'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RadioAllDatasClick
      end
      object TxtDatasLimit: TEdit
        Left = 172
        Top = 20
        Width = 82
        Height = 21
        AutoSelect = False
        AutoSize = False
        Enabled = False
        NumbersOnly = True
        TabOrder = 1
      end
      object RadioDatasLimit: TRadioButton
        Left = 117
        Top = 22
        Width = 49
        Height = 17
        Caption = 'Limite:'
        TabOrder = 2
        OnClick = RadioDatasLimitClick
      end
    end
    object TabFirebird: TTabSheet
      Caption = 'Firebird'
      ImageIndex = 1
      object CheckTruncFB: TCheckBox
        Left = 3
        Top = 3
        Width = 308
        Height = 17
        Caption = 'Truncar tabela firebird ao iniciar'
        TabOrder = 0
      end
    end
  end
  object Actions: TActionList
    Left = 288
    Top = 280
    object ActSave: TAction
      Caption = 'Salvar'
      OnExecute = ActSaveExecute
    end
    object ActDiscard: TAction
      Caption = 'Descartar'
      OnExecute = ActDiscardExecute
    end
  end
end
