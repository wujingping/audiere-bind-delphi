program AudierePlayer;

uses
  JvGnuGetText,
  SysUtils,
  Forms,
  main in 'main.pas' {MainForm},
  soundex_audiere in 'soundex_audiere.pas';

{$R *.res}

var
  AppPath  : string;
  AppName  : string;
  AppDomain: string;

begin
  // Get App Path Info and Text domain name. 
  AppPath:=ExtractFilePath(Application.ExeName);
  AppName:=ExtractFileName(Application.ExeName);
  AppDomain:=ChangeFileExt(AppName,'');

  // Use delphi.mo for runtime library translations, if it is there
  TextDomain(AppDomain);
  AddDomainForResourceString(AppDomain);

  //VCL, important ones
  //TP_GlobalIgnoreClass(TFont);
  //TP_GlobalIgnoreClassProperty(TAction,'Category');
  //TP_GlobalIgnoreClassProperty(TControl, 'HelpKeyword');
  //TP_GlobalIgnoreClassProperty(TNotebook, 'Pages');
  //  These are normally not needed.
  //TP_GlobalIgnoreClassProperty(TControl,'ImeName');

  Application.Initialize;
  Application.Title:=_('Audiere Player Demo');
  Application.Title:=_(Application.Title);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
