unit Unit37;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Flexcel.Core, FlexCel.XlsAdapter,
  Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, DataSetExports;

type
  TForm37 = class(TForm)
    SpeedButton1: TSpeedButton;
    Sqlite_demoConnection: TFDConnection;
    Fdqa_categoriesTable: TFDQuery;
    fdqryCategoriesTable: TFDQuery;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form37: TForm37;

implementation

{$R *.dfm}

procedure TForm37.SpeedButton1Click(Sender: TObject);
var
  Xls: TXlsFile;
begin
  //
  Xls := TXlsFile.Create(1, TExcelFileFormat.v2010, True);
  try

    DataSetExports.DataSetToXLS(Xls, fdqryCategoriesTable, 1, 1);

    Xls.Save( 'C:\Users\MickaelK\Desktop\Text.xlsx');
  finally
    Xls.Free;
  end;
end;

end.
