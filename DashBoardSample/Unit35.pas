unit Unit35;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Types,
  Vcl.Buttons, Vcl.Imaging.pngimage;

type

  THackControlItem = class(TControlItem);

  TForm35 = class(TForm)
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Image1: TImage;
    procedure GridPanel1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    oMovedPanel: TPanel;
    SavPoint: TPoint;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form35: TForm35;
var
  WindowList: TList;

implementation

{$R *.dfm}

procedure TForm35.GridPanel1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
  // Récupère le contrôle en cours dans le GridPanel
  function GetMovedControlItem():TControlItem;
  var
    i: integer;
    oControl: TControlItem;
  begin
    Result := nil;
    for i := 0 to Pred(GridPanel1.ControlCollection.Count) do
    begin
      if GridPanel1.ControlCollection.Items[i].Control = oMovedPanel then
      begin
        Result := GridPanel1.ControlCollection.Items[i];
        Break;
      end;
    end;
  end;
  // Retourne les coordonnées du rectangle dans lequel se trouve le pointeur de la souris.
  function GetCellRectAtMousePoint(): TRect;
  var
    i: Integer;
    j: Integer;
  begin
    for i := 0 to Pred(GridPanel1.ColumnCollection.Count) do
    begin
      for j := 0 to Pred(GridPanel1.RowCollection.Count) do
      begin
        if PtInRect(GridPanel1.CellRect[i,j], TPoint.Create(X, Y)) then
        begin
          // Result := GridPanel1.CellRect[i,j];
          Result := TRect.Create(
            TPoint.Create(i, j),
            TPoint.Create(i, j)
          );
          Exit;
        end;
      end;
    end;
  end;
var
  MovedControl: TControlItem;
  MovedRect: TRect;
  MouseRect: TRect;
begin
  Accept := True;
////
//  if State = TDragState.dsDragEnter then
//  begin
//    if Sender is TPanel then
//      oMovedPanel := TPanel(Sender);
//    Memo1.Lines.Clear;
//    SavPoint := TPoint.Create(-1,-1);
//  end;

  Label4.Caption := Format('Mouse Coord %d %d', [X, Y]);
  GridPanel1.ControlCollection.BeginUpdate;
  try
    if State in [TDragState.dsDragMove] then
    begin
      if oMovedPanel <> nil then
      begin
        MovedControl := GetMovedControlItem;
        if MovedControl <> nil then
        begin

          // Coordonnées de la souris dans la grille (Ligne/Colonne
          MouseRect := GetCellRectAtMousePoint;

          if SavPoint <> MouseRect.TopLeft then
          begin
            SavPoint := MouseRect.TopLeft;

            THackControlItem(MovedControl).InternalSetLocation(
              MouseRect.TopLeft.X,
              MouseRect.TopLeft.Y,
              False,
              False
            );

            Memo1.Lines.Add(Format('Move to %d %d', [MouseRect.TopLeft.X, MouseRect.TopLeft.Y]))
          end;
        end;
      end;
    end;
  finally
    GridPanel1.ControlCollection.EndUpdate;
  end;
end;

procedure TForm35.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  oMovedPanel := nil;

  if Sender is TImage then
    oMovedPanel := TPanel(TImage(Sender).Parent)
  else if Sender is TPanel then
    oMovedPanel := TPanel(Sender)
  else
    oMovedPanel := nil;

  Memo1.Lines.Clear;
  SavPoint := TPoint.Create(-1,-1);

  ReleaseCapture;
  SendMessage(Panel1.Handle, WM_SYSCOMMAND, 61458, 0) ;
end;

procedure TForm35.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

  // Récupère le contrôle en cours dans le GridPanel
  function GetMovedControlItem():TControlItem;
  var
    i: integer;
    oControl: TControlItem;
  begin
    Result := nil;
    for i := 0 to Pred(GridPanel1.ControlCollection.Count) do
    begin
      if GridPanel1.ControlCollection.Items[i].Control = oMovedPanel then
      begin
        Result := GridPanel1.ControlCollection.Items[i];
        Break;
      end;
    end;
  end;
  // Retourne les coordonnées du rectangle dans lequel se trouve le pointeur de la souris.
  function GetCellRectAtMousePoint(): TRect;
  var
    i: Integer;
    j: Integer;
    oPoint: TPoint;
  begin
    for i := 0 to Pred(GridPanel1.ColumnCollection.Count) do
    begin
      for j := 0 to Pred(GridPanel1.RowCollection.Count) do
      begin
        if Sender is TImage then
          oPoint := oMovedPanel.ClientToParent(TImage(Sender).ClientToParent(TPoint.Create(X, Y)));
        if PtInRect(GridPanel1.CellRect[i,j], oPoint) then
        //if PtInRect(GridPanel1.CellRect[i,j], TPoint.Create(X, Y)) then
        begin
          // Result := GridPanel1.CellRect[i,j];
          Result := TRect.Create(
            TPoint.Create(i, j),
            TPoint.Create(i, j)
          );
          Exit;
        end;
      end;
    end;
  end;
var
  MovedControl: TControlItem;
  MovedRect: TRect;
  MouseRect: TRect;
begin
  Label4.Caption := Format('Mouse Coord %d %d', [X, Y]);
  if oMovedPanel <> nil then
  begin
    GridPanel1.ControlCollection.BeginUpdate;
    try
      MovedControl := GetMovedControlItem;
      if MovedControl <> nil then
      begin

        // Coordonnées de la souris dans la grille (Ligne/Colonne
        MouseRect := GetCellRectAtMousePoint;

        if SavPoint <> MouseRect.TopLeft then
        begin
          SavPoint := MouseRect.TopLeft;

          THackControlItem(MovedControl).InternalSetLocation(
            MouseRect.TopLeft.X,
            MouseRect.TopLeft.Y,
            False,
            False
          );
//          MovedControl).InternalSetLocation(
//            MouseRect.TopLeft.X,
//            MouseRect.TopLeft.Y,
//            False,
//            False
//          );

          Memo1.Lines.Add(Format('Move to %d %d', [MouseRect.TopLeft.X, MouseRect.TopLeft.Y]))
        end;
      end;
    finally
      GridPanel1.ControlCollection.EndUpdate;
      oMovedPanel := nil;
    end;
  end;
end;

procedure TForm35.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//
end;

end.
