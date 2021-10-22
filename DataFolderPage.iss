[code]
var
  FolderToInstall: TNewEdit;
  BrowseMinimaDataLocationButton: TNewButton;

function OnDataFolderPageNextButtonClick(Sender: TWizardPage): Boolean;
begin
  DataFolderLocation := FolderToInstall.Text;

  Result := True;
end;

procedure OnClickBrowseDataFolderLocationButton(Sender: TObject);
  var Directory: String;
begin
  Directory := FolderToInstall.Text;

  BrowseForFolderEx(Directory);
  FolderToInstall.Text := Directory;

  WizardForm.ActiveControl := WizardForm.NextButton;
end;

function CreateDataFolderPage():TWizardPage;
var 
  LabelFolder: TLabel;  
  LabelFolder2: TLabel;  
  MainPage: TWizardPage;  
  InstallHelpCheckBox: TNewCheckBox; 
  BtnImage: TBitmapImage;
  Bitmap2: TBitmap;
begin
  
  MainPage := CreateCustomPage(wpSelectDir, 'Select Data Folder Location', 'Where should Minima data be stored?');
  
  MainPage.OnNextButtonClick := @OnDataFolderPageNextButtonClick;

  {TODO: replace}
  ExtractTemporaryFile('minima32.bmp');

  BtnImage := TBitmapImage.Create(WizardForm);

  with BtnImage do
  begin
    Parent := MainPage.Surface;
    Bitmap := TBitmap.Create();
    with Bitmap do
    begin
      AlphaFormat := afDefined;
      LoadFromFile(ExpandConstant('{tmp}\minima32.bmp'));
    end;
    Left := ScaleX(0);
    Top := ScaleY(0);
    AutoSize := False;
    Height := ScaleY(32);
    Width := ScaleX(32);
    Stretch := True;
    
    BackColor := MainPage.Surface.Color
  end;

  LabelFolder := TLabel.Create(MainPage);
  LabelFolder.Parent := MainPage.Surface;
  LabelFolder.Top := 9;
  LabelFolder.Left := 44;
  LabelFolder.Caption := 'Setup will install Minima''s data into the following folder.'

  LabelFolder2 := TLabel.Create(MainPage);
  LabelFolder2.Parent := MainPage.Surface;
  LabelFolder2.Top := 44;
  LabelFolder2.Left := 0;
  LabelFolder2.Caption := 'To continue, click Next. If you would like to select a different folder, click Browse.'

  FolderToInstall := TNewEdit.Create(MainPage);
  FolderToInstall.Enabled := True;
  FolderToInstall.Parent := MainPage.Surface;
  FolderToInstall.Top := 68;
  FolderToInstall.Left := 00;
  FolderToInstall.Width := 332;
  FolderToInstall.Text :=  ExpandConstant('{commonappdata}\Minima');

  BrowseMinimaDataLocationButton := TNewButton.Create(MainPage);
  with BrowseMinimaDataLocationButton do
  begin
    Caption := 'Browse...';
    Parent := MainPage.Surface;
    Top := 67;
    Left := 342;
    Width := 75;
    Height := 23;
    Enabled := True;
    OnClick := @OnClickBrowseDataFolderLocationButton;
  end;
  
  result:= MainPage;
end;