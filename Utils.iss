[code]
{https://stackoverflow.com/questions/44247751/inno-setup-opening-directory-browse-dialog-from-another-dialog-without-hiding}
var FakePage: TInputDirWizardPage;

function FileReplaceString(const FileName, SearchString, ReplaceString: string):boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      { Only save if text has been changed. }
      if StringChangeEx(MyText, SearchString, ReplaceString, True) > 0 then
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
  end;
end;

procedure processMinimaXml();
begin
  FileReplaceString(ExpandConstant('{app}') + '\' + 'minima.xml', '%MINIMA_CONF_PATH%', DataFolderLocation)
  FileReplaceString(ExpandConstant('{app}') + '\' + 'minima.xml', '%JAVA_LOCATION%', JavaLocation)
  FileReplaceString(ExpandConstant('{app}') + '\' + 'minima.xml', '%JAVA_OPTIONS%', JavaOptions)
end;

function GetMajorVersion(const Filename: String): Integer;
var
  MS, LS: Cardinal;
  Major, Minor, Rev, Build: Cardinal;
begin
  if GetVersionNumbers(Filename, MS, LS) then
  begin
    Major := MS shr 16;
    //Minor := MS and $FFFF;
    //Rev := LS shr 16;
    //Build := LS and $FFFF;
    //Version := Format('%d.%d.%d', [Major, Minor, Rev]);
    Result := Major;
  end
end;

procedure BrowseForFolderEx(var Directory: String);
begin
  FakePage.Values[0] := Directory;
  FakePage.Buttons[0].OnClick(FakePage.Buttons[0]);
  Directory := FakePage.Values[0];
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := (PageID = FakePage.ID);
end;