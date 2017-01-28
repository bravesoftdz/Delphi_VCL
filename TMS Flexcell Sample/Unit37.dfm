object Form37: TForm37
  Left = 0
  Top = 0
  Caption = 'Form37'
  ClientHeight = 259
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 9
    Top = 10
    Width = 172
    Height = 22
    OnClick = SpeedButton1Click
  end
  object Sqlite_demoConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQLite_Demo')
    Connected = True
    LoginPrompt = False
    Left = 187
    Top = 60
  end
  object Fdqa_categoriesTable: TFDQuery
    Active = True
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'SELECT * FROM FDQA_Categories')
    Left = 187
    Top = 107
  end
  object fdqryCategoriesTable: TFDQuery
    Active = True
    Connection = Sqlite_demoConnection
    SQL.Strings = (
      'SELECT * FROM Categories')
    Left = 79
    Top = 62
  end
end
