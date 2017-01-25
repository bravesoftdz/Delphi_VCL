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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Image1: TImage;
    Panel2: TPanel;
    Image2: TImage;
    grdpnl1: TGridPanel;
    Panel3: TPanel;
    Image3: TImage;
    Panel4: TPanel;
    Panel5: TPanel;
    Image4: TImage;
    Image5: TImage;
    procedure GridPanel1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdpnl1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure grdpnl1DragDrop(Sender, Source: TObject; X, Y: Integer);
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

procedure TForm35.grdpnl1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  //
end;

procedure TForm35.grdpnl1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
  // Récupère le contrôle en cours dans le GridPanel
  function GetMovedControlItem():TControlItem;
  var
    i: integer;
    oControl: TControlItem;
  begin
    Result := nil;
    for i := 0 to Pred(grdpnl1.ControlCollection.Count) do
    begin
      if grdpnl1.ControlCollection.Items[i].Control = oMovedPanel then
      begin
        Result := grdpnl1.ControlCollection.Items[i];
        Break;
      end;
    end;
  end;
  // Retourne les coordonnées du rectangle dans lequel se trouve le pointeur de la souris.
  function GetCellRectAtMousePoint(var bFound: Boolean): TRect;
  var
    i: Integer;
    j: Integer;
    oPoint: TPoint;
  begin
    bFound := False;
    for i := 0 to Pred(grdpnl1.ColumnCollection.Count) do
    begin
      for j := 0 to Pred(grdpnl1.RowCollection.Count) do
      begin
        if Sender is TImage then
          oPoint := oMovedPanel.ClientToParent(TImage(Sender).ClientToParent(TPoint.Create(X, Y)))
        else if Sender is TGridPanel then
          oPoint := TPoint.Create(X, Y)
        else if Sender is TPanel then
          oPoint := oMovedPanel.ClientToParent(TPoint.Create(X, Y))
        else
          raise Exception.Create('Erreur Sender Not found');
        if PtInRect(grdpnl1.CellRect[i,j], oPoint) then
        //if PtInRect(GridPanel1.CellRect[i,j], TPoint.Create(X, Y)) then
        begin
          // Result := GridPanel1.CellRect[i,j];
          Result := TRect.Create(
            TPoint.Create(i, j),
            TPoint.Create(i, j)
          );
          bFound := True;
          Exit;
        end;
      end;
    end;
  end;
  function ExistControlItemInRect(var Rect: TRect; var oMovedItem: TControlItem): Boolean;
  var
    i: integer;
    oControl: TControlItem;
    oControlRect: TRect;
  begin
    Result := False;
    for i := 0 to Pred(grdpnl1.ControlCollection.Count) do
    begin
      oControl := grdpnl1.ControlCollection.Items[i];

      if oControl.Control = oMovedPanel then // si c'est lui même, on continu à chercher
        Continue;

      oControlRect := TRect.Create(
        TPoint.Create(oControl.Column, oControl.Row),
        TPoint.Create(oControl.Column + oControl.ColumnSpan, oControl.Row + oControl.RowSpan)
      );

      if oControlRect.IntersectsWith(Rect) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
  function DestRectIsOutOfBounds(var Rect: TRect; var oMovedItem: TControlItem): Boolean;
  var
    i: integer;
    oControl: TControlItem;
    oControlRect: TRect;
  begin
    Result := False;
    if Rect.Top < 0 then
      Result := True
    else if Rect.Left < 0 then
      Result := True
    else if Rect.Top + Rect.Height > grdpnl1.RowCollection.Count then
      Result := True
    else if Rect.Left + Rect.Width > grdpnl1.ColumnCollection.Count then
      Result := True;
  end;
var
  MovedControl: TControlItem;
  DestRect: TRect;
  MouseRect: TRect;
  bFound: Boolean;
begin
  Accept := (Source is TPanel) and (Source = oMovedPanel);

  if not Accept then
    Exit;

  if (Sender is TPanel) and (Sender <> Source) then
  begin
    Accept := False;
    Exit;
  end else if (Sender is TImage) and (TControl(Sender).Parent <> Source) then
  begin
    Accept := False;
    Exit;
  end;

  bFound := False;
  Label4.Caption := Format('Mouse Coord %d %d', [X, Y]);
  if oMovedPanel <> nil then
  begin
    grdpnl1.ControlCollection.BeginUpdate;
    try
      MovedControl := GetMovedControlItem;
      if MovedControl <> nil then
      begin

        // Coordonnées de la souris dans la grille (Ligne/Colonne
        MouseRect := GetCellRectAtMousePoint(bFound);

        // Rect de destination
        DestRect := TRect.Create(
          TPoint.Create(MouseRect.Left, MouseRect.Top),
          TPoint.Create(MouseRect.Left + MovedControl.ColumnSpan, MouseRect.Top + MovedControl.RowSpan)
        );

        // Detecte si il y a un controle dans la zone
        // si oui, on refuse
        if ExistControlItemInRect(DestRect, MovedControl) then //
          Accept := False
        // Détecte si la position ou l'on est est hors limites
        else if DestRectIsOutOfBounds(DestRect, MovedControl) then
          Accept := False;

        if bFound and (SavPoint <> MouseRect.TopLeft) then
        begin
          SavPoint := MouseRect.TopLeft;

          if Accept then
          begin
            THackControlItem(MovedControl).InternalSetLocation(
              MouseRect.TopLeft.X,
              MouseRect.TopLeft.Y,
              False,
              False // True
            );
          end;
        end;
      end;
    finally
      grdpnl1.ControlCollection.EndUpdate;
    end;
  end;
end;

procedure TForm35.GridPanel1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
//  // Récupère le contrôle en cours dans le GridPanel
//  function GetMovedControlItem():TControlItem;
//  var
//    i: integer;
//    oControl: TControlItem;
//  begin
//    Result := nil;
//    for i := 0 to Pred(GridPanel1.ControlCollection.Count) do
//    begin
//      if GridPanel1.ControlCollection.Items[i].Control = oMovedPanel then
//      begin
//        Result := GridPanel1.ControlCollection.Items[i];
//        Break;
//      end;
//    end;
//  end;
//  // Retourne les coordonnées du rectangle dans lequel se trouve le pointeur de la souris.
//  function GetCellRectAtMousePoint(): TRect;
//  var
//    i: Integer;
//    j: Integer;
//  begin
//    for i := 0 to Pred(GridPanel1.ColumnCollection.Count) do
//    begin
//      for j := 0 to Pred(GridPanel1.RowCollection.Count) do
//      begin
//        if PtInRect(GridPanel1.CellRect[i,j], TPoint.Create(X, Y)) then
//        begin
//          // Result := GridPanel1.CellRect[i,j];
//          Result := TRect.Create(
//            TPoint.Create(i, j),
//            TPoint.Create(i, j)
//          );
//          Exit;
//        end;
//      end;
//    end;
//  end;
//var
//  MovedControl: TControlItem;
//  MovedRect: TRect;
//  MouseRect: TRect;
begin
//  Accept := True;
//////
////  if State = TDragState.dsDragEnter then
////  begin
////    if Sender is TPanel then
////      oMovedPanel := TPanel(Sender);
////    Memo1.Lines.Clear;
////    SavPoint := TPoint.Create(-1,-1);
////  end;
//
//  Label4.Caption := Format('Mouse Coord %d %d', [X, Y]);
//  GridPanel1.ControlCollection.BeginUpdate;
//  try
//    if State in [TDragState.dsDragMove] then
//    begin
//      if oMovedPanel <> nil then
//      begin
//        MovedControl := GetMovedControlItem;
//        if MovedControl <> nil then
//        begin
//
//          // Coordonnées de la souris dans la grille (Ligne/Colonne
//          MouseRect := GetCellRectAtMousePoint;
//
//          if SavPoint <> MouseRect.TopLeft then
//          begin
//            SavPoint := MouseRect.TopLeft;
//
//            THackControlItem(MovedControl).InternalSetLocation(
//              MouseRect.TopLeft.X,
//              MouseRect.TopLeft.Y,
//              False,
//              False
//            );
//
//            Memo1.Lines.Add(Format('Move to %d %d', [MouseRect.TopLeft.X, MouseRect.TopLeft.Y]))
//          end;
//        end;
//      end;
//    end;
//  finally
//    GridPanel1.ControlCollection.EndUpdate;
//  end;
end;

procedure TForm35.Image1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := True;
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

  if Assigned(oMovedPanel) then
  begin

    ReleaseCapture;
    oMovedPanel.BringToFront;
    SendMessage(oMovedPanel.Handle, WM_SYSCOMMAND, 61458, 0) ;
  end;
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
  function GetCellRectAtMousePoint(var bFound: Boolean): TRect;
  var
    i: Integer;
    j: Integer;
    oPoint: TPoint;
  begin
    bFound := False;
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
          bFound := True;
          Exit;
        end;
      end;
    end;
  end;
var
  MovedControl: TControlItem;
  MovedRect: TRect;
  MouseRect: TRect;
  bFound: Boolean;
begin
  bFound := False;
  Label4.Caption := Format('Mouse Coord %d %d', [X, Y]);
  if oMovedPanel <> nil then
  begin
    GridPanel1.ControlCollection.BeginUpdate;
    try
      MovedControl := GetMovedControlItem;
      if MovedControl <> nil then
      begin

        // Coordonnées de la souris dans la grille (Ligne/Colonne
        MouseRect := GetCellRectAtMousePoint(bFound);

        if bFound and (SavPoint <> MouseRect.TopLeft) then
        begin
          SavPoint := MouseRect.TopLeft;

          THackControlItem(MovedControl).InternalSetLocation(
            MouseRect.TopLeft.X,
            MouseRect.TopLeft.Y,
            False,
            False // True
          );

          Memo1.Lines.Add(Format('Move to %d %d', [MouseRect.TopLeft.X, MouseRect.TopLeft.Y]))
        end;
      end;
    finally
      GridPanel1.ControlCollection.EndUpdate;
      oMovedPanel := nil;
    end;
  end;
end;

procedure TForm35.Image2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  //
  Accept := True;
end;

procedure TForm35.Image4MouseDown(Sender: TObject; Button: TMouseButton;
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

  if Assigned(oMovedPanel) then
  begin
    ReleaseCapture;
    oMovedPanel.BringToFront;
    oMovedPanel.BeginDrag(False);
  end;
end;

procedure TForm35.Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

  Accept := True;
end;

procedure TForm35.Panel2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

  Accept := True;
end;

end.
