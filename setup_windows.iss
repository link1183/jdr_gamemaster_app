#define MyAppName "JDR Gamemaster App"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Adrien Gunther"
#define MyAppExeName "jdr_gamemaster_app.exe"

[Setup]
AppId={{972B7561-A0AF-45AF-8123-B36ED5781439}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=JDR-Gamemaster-App-1.0
Compression=lzma
SolidCompression=yes

[Files]
Source: "C:\Users\adrie\jdr_gamemaster_app\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{userappdata}\Microsoft\Windows\Start Menu\Programs\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"