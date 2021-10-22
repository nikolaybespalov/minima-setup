[code]
var
  //MainPage: TWizardPage;
  JavaIconImage: TBitmapImage;
  ImageLabel: TLabel;
  TopLabel: TLabel;
  RadioButton1: TNewRadioButton;  
  RadioButton2: TNewRadioButton;
  JRELocationEdit: TNewEdit;
  BrowseJRELocationButton: TNewButton;  
  BottomLabel: TLabel;
  DownloadJavaCheckBox: TNewCheckBox;

procedure OnSelectJREPageActivate(Sender: TWizardPage);
begin
  if GetMajorVersion(GetEnv('JAVA_HOME') + '\bin\java.exe') >= {#MinimumJavaVersion2} then
  begin
    JRELocationEdit.Text := GetEnv('JAVA_HOME');
  end;

  if GetMajorVersion(JRELocationEdit.Text + '\bin\java.exe') >= {#MinimumJavaVersion2} then
  begin
    WizardForm.NextButton.Enabled := True;
    WizardForm.Update;
  end
  else
  begin
    //WizardForm.NextButton.Enabled := False;
    DownloadJavaCheckBox.Checked := True;
  end;

  JRELocationEdit.SelectAll();
end;

function OnSelectJREPageBackButtonClick(Sender: TWizardPage): Boolean;
begin
  Result := True;
end;

procedure OnSelectJREPageCancelButtonClick(Sender: TWizardPage; var ACancel, AConfirm: Boolean);
begin
end;

function OnSelectJREPageNextButtonClick(Sender: TWizardPage): Boolean;
begin
  if DownloadJavaCheckBox.Checked then
  begin
    JavaLocation := ExpandConstant('{app}') + '\' + ExpandConstant('{#JreOutputFolder}');
  end
  else
  begin
    JavaLocation := JRELocationEdit.Text;
  end;

  JavaOptions := '{#JavaOptions}';

  Result := True;
end;

function OnShouldSkipSelectJREPage(Sender: TWizardPage): Boolean;
begin
end;

procedure OnChangeJRELocationEdit(Sender: TObject);
begin
  if GetMajorVersion(JRELocationEdit.Text + '\bin\java.exe') >= {#MinimumJavaVersion2} then
  begin
    WizardForm.NextButton.Enabled := True;
    WizardForm.ActiveControl := WizardForm.NextButton;
  end
  else
  begin
    WizardForm.NextButton.Enabled := False;
  end;
end;

procedure OnClickBrowseJRELocationButton(Sender: TObject);
  var Directory: String;
begin
  if JRELocationEdit.Text <> '' then
  begin
    Directory := JRELocationEdit.Text;
  end
  else
  begin
    Directory := ExpandConstant('{commonpf}');
  end;

  BrowseForFolderEx(Directory);
  JRELocationEdit.Text := Directory;

  if WizardForm.NextButton.Enabled then
  begin
    WizardForm.ActiveControl := WizardForm.NextButton;
  end;
  
end;

procedure OnClickDownloadJavaCheckBox(Sender: TObject);
begin
  if DownloadJavaCheckBox.State then
  begin
    JRELocationEdit.Enabled := False;
    BrowseJRELocationButton.Enabled := False;
    WizardForm.NextButton.Enabled := True;
  end
  else
  begin
    JRELocationEdit.Enabled := True;
    BrowseJRELocationButton.Enabled := True;
    if GetMajorVersion(JRELocationEdit.Text + '\bin\java.exe') >= {#MinimumJavaVersion2} then
    begin
      WizardForm.NextButton.Enabled := True;
      WizardForm.ActiveControl := WizardForm.NextButton;
    end
    else
    begin
      WizardForm.NextButton.Enabled := False;
    end;
  end;
end;

procedure OnRadioButton1Click(Sender: TObject);
begin
  JRELocationEdit.Enabled := False;
  BrowseJRELocationButton.Enabled := False;
  WizardForm.NextButton.Enabled := True;
end;

procedure OnRadioButton2Click(Sender: TObject);
begin
  JRELocationEdit.Enabled := True;
  BrowseJRELocationButton.Enabled := True;
  WizardForm.NextButton.Enabled := False;
end;

function CreateSelectJREPage(AfterID: Integer): TWizardPage;
var
  MainPage: TWizardPage;
  //JavaIconImage: TBitmapImage;
  //ImageLabel: TLabel;
//  TopLabel: TLabel;
//  RadioButton1: TNewRadioButton;  
//  RadioButton2: TNewRadioButton;
//  JRELocationEdit: TNewEdit;  
//  BottomLabel: TLabel;
begin
  MainPage := CreateCustomPage(AfterID, 'Select Java Location', 'Where is Java located?');
  
  MainPage.OnActivate := @OnSelectJREPageActivate;
  MainPage.OnBackButtonClick := @OnSelectJREPageBackButtonClick;
  MainPage.OnCancelButtonClick := @OnSelectJREPageCancelButtonClick;
  MainPage.OnNextButtonClick := @OnSelectJREPageNextButtonClick;
  MainPage.OnShouldSkipPage := @OnShouldSkipSelectJREPage;

  {TODO: replace}
  ExtractTemporaryFile('java32.bmp');
  
  JavaIconImage := TBitmapImage.Create(WizardForm);
  
  with JavaIconImage do
  begin
    Parent := MainPage.Surface;
    Bitmap := TBitmap.Create();
    with Bitmap do
    begin
      AlphaFormat := afDefined;
      LoadFromFile(ExpandConstant('{tmp}\java32.bmp'));
    end;
    Left := ScaleX(0);
    Top := ScaleY(0);
    AutoSize := False;
    Height := ScaleY(32);
    Width := ScaleX(32);
    Stretch := True;
    
    BackColor := MainPage.Surface.Color
  end;

  ImageLabel := TLabel.Create(MainPage);
  with ImageLabel do
  begin
    Caption := 'Minima requires Java JRE or JDK (' + ExpandConstant('{#MinimumJavaVersion}') + ' at least).';
    Parent := MainPage.Surface;
    Top := 9;
    Left := 44;
  end;

  TopLabel := TLabel.Create(MainPage);
  with TopLabel do
  begin
    Caption := 'To continue, click Next. If you want to select different location, click Browse.';
    Parent := MainPage.Surface;
    Top := 44;
    Left := 0;
  end;

  JRELocationEdit := TNewEdit.Create(MainPage);
  with JRELocationEdit do
  begin
    Text := '';
    Parent := MainPage.Surface;
    Top := 68;
    Left := 0;
    Width := 332;
    Enabled := True;
    OnChange := @OnChangeJRELocationEdit;
  end;

  BrowseJRELocationButton := TNewButton.Create(MainPage);
  with BrowseJRELocationButton do
  begin
    Caption := 'Browse...';
    Parent := MainPage.Surface;
    Top := 67;
    Left := 342;
    Width := 75;
    Height := 23;
    Enabled := True;
    OnClick := @OnClickBrowseJRELocationButton;
  end;
  
  {TopLabel := TLabel.Create(MainPage);
  with TopLabel do
  begin
    Caption := 'Please specify which JRE Minima will use, then click Next.';
    Parent := MainPage.Surface;
    //Top := 0;
    //Left := 0;
  end;

  RadioButton1 := TNewRadioButton.Create(WizardForm);
  with RadioButton1 do
  begin
    Caption := 'Download the required JRE'
    Parent := MainPage.Surface;
    Top := 26;
    Left := 4;
    Width := MainPage.SurfaceWidth;
    Checked := True;
    OnClick := @OnRadioButton1Click;
    //Font.Height := 13;
    //Font.Size := 8;
    //Alignment := taCenter;
    //Anchors := [akRight];
  end;

  RadioButton2 := TNewRadioButton.Create(WizardForm);
  with RadioButton2 do
  begin
    Caption := 'Use the following JRE'
    Parent := MainPage.Surface;
    Top := 48;
    Left := 4;
    Width := MainPage.SurfaceWidth;
    OnClick := @OnRadioButton2Click;
    //Font.Height := 13;
    //Font.Size := 8;
    //Alignment := taRightJustify;
    //Anchors := akTop;
  end;

  JRELocationEdit := TNewEdit.Create(MainPage);
  with JRELocationEdit do
  begin
    Text := GetJavaHome();
    Parent := MainPage.Surface;
    Top := 72;
    Left := 0;
    Width := 332;
    Enabled := False;
  end;

  BrowseJRELocationButton := TNewButton.Create(MainPage);
  with BrowseJRELocationButton do
  begin
    Caption := 'Browse...';
    Parent := MainPage.Surface;
    Top := 71;
    Left := 342;
    Width := 75;
    Height := 23;
    Enabled := False;
  end;}

  //BottomLabel := TLabel.Create(MainPage);
  //with BottomLabel do
  //begin
  //  Parent := MainPage.Surface;
  //  Caption := 'At least Java ' + ExpandConstant('{#MinimumJavaVersion}') + ' JRE or JDK is required.'
  //  Top := 216;
  //  Left := 0;
  //end;
  DownloadJavaCheckBox := TNewCheckBox.Create(MainPage);
  with DownloadJavaCheckBox do
  begin
    Parent := MainPage.Surface;
    Top := 216;
    Left := 0;
    Width := MainPage.SurfaceWidth;
    Caption := 'Download the required Java (Version 8 Update 301) automatically.';
    State := False;
    OnClick := @OnClickDownloadJavaCheckBox;
  end;
  
  result:= MainPage;
end;