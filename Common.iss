#define MyAppName "Minima"
#define MyAppVersion "0.98.44"
#define MyAppPublisher "Minima"
#define MyAppURL "https://minima.global/"
#define WinswLink64 "https://github.com/winsw/winsw/releases/download/v2.11.0/WinSW-x64.exe"
#define WinswLink86 "https://github.com/winsw/winsw/releases/download/v2.11.0/WinSW-x86.exe"
#define WinswOutputFile "WinSW.exe"
#define JreLink64 "https://javadl.oracle.com/webapps/download/GetFile/1.8.0_301-b09/d3c52aa6bfa54d3ca74e617f18309292/windows-i586/jre-8u301-windows-x64.tar.gz"
#define JreLink64Sha "1205d90bfc9c378442949cc77e70d6cbcad064ed1093eaa943b9ce1d3c1f651e"
#define JreLink86 "https://javadl.oracle.com/webapps/download/GetFile/1.8.0_301-b09/d3c52aa6bfa54d3ca74e617f18309292/windows-i586/jre-8u301-windows-i586.tar.gz"
#define JreLink86Sha "d2ad766fa711071a96a6d01e1f26e290b5c49dcc25da29d29738470638f4e472"
#define JreOutputFile "jre.tar.gz"
#define JreOutputFolder "jre1.8.0_301"
#define MinimumJavaVersion "8"
#define MinimumJavaVersion2 8
#define JavaOptions "-Xmx1G"

[Code]
var
  DataFolderLocation: String;
  JavaLocation: String;
  JavaOptions: String;