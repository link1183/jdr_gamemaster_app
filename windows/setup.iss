#define AppName "JDR Gamemaster App"
#define AppVersion GetEnv('APP_VERSION')
#define AppPublisher "Adrien Gunther"
#define AppExeName "jdr_gamemaster_app.exe"

[Setup]
AppId={{972B7561-A0AF-45AF-8123-B36ED5781439}}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputBaseFilename=JDR-Gamemaster-App-{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{userappdata}\Microsoft\Windows\Start Menu\Programs\{#AppName}"; Filename: "{app}\{#AppExeName}"
