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
  OnActivate = FormActivate
  OnClose = FormClose
  DesignSize = (
    338
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object BtnDiscard: TSpeedButton
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
    Caption = 'Salvar (Ctrl+S)'
  end
  object PageConfigs: TPageControl
    Left = 8
    Top = 8
    Width = 322
    Height = 324
    ActivePage = TabMigration
    TabOrder = 0
    object TabMigration: TTabSheet
      Caption = 'Migra'#231#227'o'
      object LblUntil: TLabel
        Left = 195
        Top = 252
        Width = 17
        Height = 13
        Caption = 'At'#233
      end
      object LblFrom: TLabel
        Left = 87
        Top = 252
        Width = 13
        Height = 13
        Caption = 'De'
      end
      object GroupLimit: TRadioGroup
        Left = 3
        Top = 182
        Width = 308
        Height = 103
        Caption = 'Limite de Migra'#231#227'o'
        ItemIndex = 0
        Items.Strings = (
          'Todas'
          'Limite:')
        TabOrder = 2
        OnClick = GroupLimitClick
      end
      object GroupCommit: TRadioGroup
        Left = 3
        Top = 103
        Width = 308
        Height = 73
        Caption = 'Commitar'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'No Final'
          'A cada:')
        TabOrder = 1
        OnClick = GroupCommitClick
      end
      object TxtCommit: TEdit
        Left = 222
        Top = 134
        Width = 82
        Height = 21
        AutoSelect = False
        AutoSize = False
        Enabled = False
        NumbersOnly = True
        TabOrder = 3
      end
      object TxtLimitStarts: TEdit
        Left = 107
        Top = 249
        Width = 82
        Height = 21
        AutoSelect = False
        AutoSize = False
        Enabled = False
        NumbersOnly = True
        TabOrder = 4
      end
      object TxtLimitEnds: TEdit
        Left = 222
        Top = 249
        Width = 82
        Height = 21
        AutoSelect = False
        AutoSize = False
        Enabled = False
        NumbersOnly = True
        TabOrder = 5
      end
      object GroupLog: TGroupBox
        Left = 3
        Top = 3
        Width = 308
        Height = 94
        Caption = 'Log de Sa'#237'da'
        TabOrder = 0
        object CheckLogActions: TCheckBox
          Left = 8
          Top = 24
          Width = 153
          Height = 17
          Caption = 'Mostrar a'#231#245'es executadas'
          TabOrder = 0
          OnClick = SomeChange
        end
        object CheckLogDatas: TCheckBox
          Left = 8
          Top = 59
          Width = 153
          Height = 17
          Caption = 'Mostrar dados inseridos'
          TabOrder = 1
          OnClick = SomeChange
        end
      end
    end
    object TabExceptions: TTabSheet
      Caption = 'Exce'#231#245'es'
      ImageIndex = 2
      object GroupException: TRadioGroup
        Left = 3
        Top = 0
        Width = 308
        Height = 105
        Caption = 'Tratamento de Erro'
        ItemIndex = 0
        Items.Strings = (
          'Parar Migra'#231#227'o'
          'Ignorar dado'
          'Tratar dado')
        TabOrder = 0
        OnClick = SomeChange
      end
    end
    object TabFirebird: TTabSheet
      Caption = 'Firebird'
      ImageIndex = 1
      object GroupTable: TRadioGroup
        Left = 3
        Top = 0
        Width = 308
        Height = 105
        Caption = 'Tabela'
        ItemIndex = 0
        Items.Strings = (
          'Manter Tabela'
          'Limpar Tabela')
        TabOrder = 0
        OnClick = GroupLimitClick
      end
    end
  end
  object Actions: TActionList
    Left = 288
    Top = 48
    object ActSave: TAction
      Caption = 'Salvar (Ctrl + S)'
      Enabled = False
      ShortCut = 16467
      OnExecute = ActSaveExecute
    end
    object ActDiscard: TAction
      Caption = 'Descartar (Esc)'
      Enabled = False
      OnExecute = ActDiscardExecute
    end
    object ActEsc: TAction
      ShortCut = 27
      OnExecute = ActEscExecute
    end
  end
end
