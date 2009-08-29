unit main;

interface

uses
  JvGnuGetText, Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, soundex_audiere, XPMan, ExtCtrls, IniFiles;

type
  TMainForm = class(TForm)
    grpAudioControl: TGroupBox;
    grpAudioInfo: TGroupBox;
    dlgOpen: TOpenDialog;
    txtAudioTitle: TStaticText;
    txtAudioArtist: TStaticText;
    txtAudioAlbum: TStaticText;
    txtAudioTrack: TStaticText;
    trackBarAudioVolume: TTrackBar;
    btnAudioPlay: TButton;
    btnAudioStop: TButton;
    grpFileControl: TGroupBox;
    btnFileOpen: TButton;
    btnFileClose: TButton;
    trackBarAudioPosition: TTrackBar;
    txtAudioVolume: TStaticText;
    txtPosition: TStaticText;
    timer: TTimer;
    btnTestSound: TButton;
    btnTestMusic: TButton;
    btnTestEffect: TButton;
    btnTestWaveGen: TButton;
    XPManifest1: TXPManifest;
    radioGrpWaveGen: TRadioGroup;
    btnGetInfo: TButton;
    cbbDeviceTypeList: TComboBox;
    cbbDeviceList: TComboBox;
    lvPlayList: TListView;
    txtAudioComment: TStaticText;
    btnAudioPause: TButton;
    radiogrpPlayMode: TRadioGroup;
    btnFileClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure timerTimer(Sender: TObject);
    procedure trackBarAudioVolumeChange(Sender: TObject);
    procedure btnAudioPlayClick(Sender: TObject);
    procedure btnAudioStopClick(Sender: TObject);
    procedure btnTestSoundClick(Sender: TObject);
    procedure btnTestMusicClick(Sender: TObject);
    procedure btnTestEffectClick(Sender: TObject);
    procedure btnTestWaveGenClick(Sender: TObject);
    procedure btnGetInfoClick(Sender: TObject);
    procedure cbbDeviceTypeListChange(Sender: TObject);
    procedure btnFileCloseClick(Sender: TObject);
    procedure lvPlayListDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAudioPauseClick(Sender: TObject);
    procedure radiogrpPlayModeClick(Sender: TObject);
    procedure btnFileClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm  : TMainForm;
  MyIni     : TIniFile;
  AppTitle  : string;
  AppPath   : string;
  AppName   : string;
  AppDomain : string;
  AppIni    : string;
  AppStart  : string;

  AudioSys  : TAudioSystem;
  playList  : TPlayList;
  
implementation

{$R *.dfm}

procedure TMainForm.btnAudioPauseClick(Sender: TObject);
begin
  if lvPlayList.Items.Count<=0 then exit;

  if not assigned(playList)       then exit;
  if not assigned(playList.Audio) then exit;
  if not playList.Items[playList.ItemIndex].IsPlaying then exit;

  playList.pause(not playList.Items[playList.ItemIndex].IsPausing);
  //playList.Audio.pause(not playList.Audio.isPausing);
end;

procedure TMainForm.btnAudioPlayClick(Sender: TObject);
begin
  if lvPlayList.Items.Count<=0 then exit;

  if playList.IsPlaying     then PlayList.stop;

  if lvPlaylist.ItemIndex<0 then playList.play(0)
  else                           playList.play(lvPlaylist.ItemIndex);

end;

procedure TMainForm.btnAudioStopClick(Sender: TObject);
begin
  if lvPlaylist.ItemIndex<0 then exit;

  if playList.IsPlaying then playList.stop;
  MainForm.Caption:=AppTitle;
  Application.Title:=AppTitle;
end;

procedure TMainForm.btnFileClearClick(Sender: TObject);
begin
  if assigned(playList) then playList.stop;
  if assigned(playList) then playList.Clear;
  lvPlaylist.Clear;
end;

procedure TMainForm.btnFileCloseClick(Sender: TObject);
var
  idx:integer;
begin
  if lvPlaylist.Items.Count<0then exit;

  idx:=lvPlaylist.ItemIndex;
  if idx>=0 then
    begin
      if playList.Items[idx].IsPlaying then
        playList.stop;
      playList.Delete(idx);
      lvPlaylist.Selected.Delete;
      if idx>=lvPlayList.Items.Count then
        idx:=lvPlayList.Items.Count-1
      else if lvPlayList.Items.Count<=0 then
        idx:=-1
      else
        idx:=idx;

      lvPlaylist.ItemIndex:=idx;
    end
  else
    begin
      //for I := 0 to lvPlaylist.Items.Count - 1 do
    end;
end;

procedure TMainForm.btnFileOpenClick(Sender: TObject);
var
  I: Integer;
  fN,fNF:string;
begin

  if dlgOpen.Execute then
  begin
    if dlgOpen.Files.Count>0 then
    begin
      MyIni.WriteString('Path','LastFolder',ExtractFilePath(dlgOpen.Files[0]));
      MyIni.UpdateFile;
    end;
    for I := 0 to dlgOpen.Files.Count - 1 do
    begin
      fNF:=dlgOpen.Files[I];
      fN :=ExtractFileName(fNF);
      if ExtractFileExt(fN)='.m3u' then
        begin
          playList.LoadFromFile(fNF);
        end
      else
        begin
          playlist.Add(TPlayListItem.Create());
          playList.Items[playList.Count-1].idx  := playList.Count-1;
          playList.Items[playList.Count-1].Name := ChangeFileExt(fN,'');
          playList.Items[playList.Count-1].Path := fNF;
          playList.Items[playList.Count-1].Code := 'utf-8';
          playList.Items[playList.Count-1].Time := EncodeTime(0,0,0,0);
          playList.Items[playList.Count-1].Memo := '';
          playList.Items[playList.Count-1].Pos  := 0;
        end;
    end;
    lvPlayList.Clear;
    for I := 0 to playList.count - 1 do
      lvPlayList.AddItem(playList.Items[I].Name,playList.Items[I]);

  end;
end;

procedure TMainForm.btnGetInfoClick(Sender: TObject);
begin
  cbbDeviceTypeList.Items.Clear;
  cbbDeviceTypeList.Items.Add(_('Audio Device'));
  //cbbDeviceTypeList.Items.Add(_('MIDI Device'));
  cbbDeviceTypeList.Items.Add(_('CD Device'));
  cbbDeviceTypeList.Items.Add(_('Supported File'));
  cbbDeviceTypeList.ItemIndex:=0;
  cbbDeviceTypeList.OnChange(self);
end;

procedure TMainForm.btnTestEffectClick(Sender: TObject);
var
  effect:TEffect;
begin
  effect := TEffect.Create(self);
  try
    effect.FileName:=AppPath+'test.mp3';
    effect.Volume:=trackBarAudioVolume.Position;
    effect.play;
    if effect.Tags.Count>0 then
    begin
      txtAudioTitle.Caption  :=effect.Tags.Values['title'];
      txtAudioArtist.Caption :=effect.Tags.Values['artist'];
      txtAudioAlbum.Caption  :=effect.Tags.Values['album'];
      txtAudioTrack.Caption  :=effect.Tags.Values['track'];
      txtAudioComment.Caption:=effect.Tags.Values['comment'];
    end;
    effect.Volume:=60;
//    while effect.isPlaying do;
//    begin
//      sleep(100);
//    end;
  finally
//    if assigned(effect) then FreeAndNil(effect);
  end;
end;

procedure TMainForm.btnTestMusicClick(Sender: TObject);
var
  midi:TMusic;
begin
  midi := TMusic.Create(self);
  try
  try
    midi.FileName:=AppPath+'test.mid';
    midi.Volume:=trackBarAudioVolume.Position;
    midi.play;
  finally
    midi.free;
  end;
  except
    if assigned(midi) then FreeAndNil(midi);
  end;
end;

procedure TMainForm.btnTestSoundClick(Sender: TObject);
var
  wave:TSound;
begin
  wave := TSound.Create(self);
  try
    wave.FileName:=AppPath+'test.it';
    wave.play;
    wave.Volume:=trackBarAudioVolume.Position;
  finally
    if assigned(wave) then FreeAndNil(wave);
  end;
end;

procedure TMainForm.btnTestWaveGenClick(Sender: TObject);
var
  wave:TWaveGenerator;
  tone:TWaveGenerator;
  pink:TWaveGenerator;
  white:TWaveGenerator;
begin
  wave := TWaveGenerator.Create(self);
  tone := TWaveGenerator.Create(self);
  pink := TWaveGenerator.Create(self);
  white:= TWaveGenerator.Create(self);
  try
    if radioGrpWaveGen.ItemIndex<0 then radioGrpWaveGen.ItemIndex:=3;
    case radioGrpWaveGen.ItemIndex of
      0: begin
           tone.MakeTone(1000);
           tone.play;
           tone.Volume:=trackBarAudioVolume.Position;
           sleep(1000);
           tone.stop;
         end;
      1: begin
           wave.MakeSquareWave(1000);
           wave.play;
           wave.Volume:=trackBarAudioVolume.Position;
           sleep(1000);
           wave.stop;
         end;
      2: begin
           white.MakeWhiteNoise;
           white.play;
           white.Volume:=trackBarAudioVolume.Position;
           sleep(1000);
           white.stop;
         end;
      3: begin
           pink.MakePinkNoise;
           pink.play;
           pink.Volume:=trackBarAudioVolume.Position;
           sleep(1000);
           pink.stop;
         end;
    end;
  finally
    if assigned(wave)  then FreeAndNil(wave);
    if assigned(tone)  then FreeAndNil(tone);
    if assigned(pink)  then FreeAndNil(pink);
    if assigned(white) then FreeAndNil(white);
  end;
end;

procedure TMainForm.cbbDeviceTypeListChange(Sender: TObject);
begin
  Case cbbDeviceTypeList.ItemIndex of
    0:cbbDeviceList.Items:=AudioSys.AudioDevice;
    1:cbbDeviceList.Items:=AudioSys.DiscDevice;
    2:cbbDeviceList.Items:=AudioSys.FileFormat;
  End;
  if cbbDeviceList.Items.Count>0 then
    cbbDeviceList.ItemIndex:=0;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  timer.Enabled:=false;
  lvPlayList.Clear;
  if assigned(playList) then FreeAndNil(playList);

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    AppPath:=ExtractFilePath(Application.ExeName);
    AppName:=ExtractFileName(Application.ExeName);
    AppIni :=ChangeFileExt(Application.ExeName,'.ini');
    AppDomain:=ChangeFileExt(AppName,'');


    TextDomain(AppDomain);
    AddDomainForResourceString(AppDomain);
    //VCL, important ones
    //TP_GlobalIgnoreClass(TFont);
    //TP_GlobalIgnoreClassProperty(TAction,'Category');
    //TP_GlobalIgnoreClassProperty(TControl, 'HelpKeyword');
    //TP_GlobalIgnoreClassProperty(TNotebook, 'Pages');
    //  These are normally not needed.
    //TP_GlobalIgnoreClassProperty(TControl,'ImeName');

    //TP_GlobalIgnoreClass(TWindowsMediaPlayer);
    //TP_GlobalIgnoreClass(TVLCPlugin2);

    //TranslateComponent (Self,AppDomain);
    TranslateComponent (Self);

    MyIni := TIniFile.Create(AppIni);
    AppStart := MyIni.ReadString('Path','LastFolder',AppPath);
    trackBarAudioVolume.Position:=MyIni.ReadInteger('Setting','Volume',80);

    //if not soundEx_Audiere. AdrLoadDLL then Application.Terminate;
    playList:= TPlayList.Create(self);
    playList.PlayMode:=pmSequence;

    AudioSys := TAudioSystem.Create(self);
    btnGetInfo.Click;

    MainForm.Caption:=Application.Title+' - Audiere v'+AudioSys.Version;
    Application.Title:=MainForm.Caption;
    AppTitle:=Application.Title;

    dlgOpen.InitialDir:=AppStart;
    dlgOpen.Filter := AudioSys.FileFilter+'|'+playList.FileFilter;
    //dlgOpen.FileName:='*.mp3';
    dlgOpen.DefaultExt:='.mp3';
    dlgOpen.FilterIndex:=2;

end;

{-------------------------------------------------------------------------------
  过程名:    TMainForm.FormDestroy
  作者:      @author netcharm
  日期:      2009.07.26
  参数:      @param Sender: TObject
  返回值:    @return 无
-------------------------------------------------------------------------------}
procedure TMainForm.FormDestroy(Sender: TObject);
begin
    timer.Enabled:=false;
    
    btnFileCloseClick(Self);
  try

//    lvPlayList.Clear;
//    if assigned(playList) then FreeAndNil(playList);

    if assigned(MyIni)    then
    begin
      MyIni.UpdateFile;
      FreeAndNil(MyIni);
    end;

  except

  end;
end;

procedure TMainForm.lvPlayListDblClick(Sender: TObject);
begin
  if  lvPlayList.ItemIndex<0 then exit;

  if not PlayList.Items[lvPlayList.ItemIndex].IsPlaying then
  begin
    playList.stop;
    playList.play(lvPlayList.ItemIndex);
    playList.Audio.Volume:=trackBarAudioVolume.Position;
  end;
end;

procedure TMainForm.radiogrpPlayModeClick(Sender: TObject);
begin
  if not assigned(playList) then exit;

  case radiogrpPlayMode.ItemIndex of
    0: playList.PlayMode:=pmSingle;
    1: playList.PlayMode:=pmSequence;
    2: playList.PlayMode:=pmRandom;
    3: playList.PlayMode:=pmRepeat;
    4: playList.PlayMode:=pmRepeatAll;
    else
      playList.PlayMode:=pmSequence;
  end;
end;

procedure TMainForm.timerTimer(Sender: TObject);
var
  I: integer;
begin
  //exit;
  try
    if not assigned(playList) then
    begin
      Application.Title:=MainForm.Caption;
      exit;
    end;
    if (playList.ItemIndex<0) or (playList.Count<=0) then
    begin
      Application.Title:=MainForm.Caption;
      exit;
//      if playList.IsPlaying then
//        begin
//          playList.ItemIndex:=1;
//        end
//      else
//        begin
//          Application.Title:=MainForm.Caption;
//          exit;
//        end;
    end;

    if lvPlaylist.Items.Count>0 then
    begin
      for I := lvPlaylist.TopItem.Index to lvPlaylist.TopItem.Index+lvPlaylist.VisibleRowCount do
      begin
        if I>=lvPlaylist.Items.Count then break;
        if I<>playList.ItemIndex then lvPlaylist.Items[I].Checked:=false;
      end;

      if assigned(playList.Audio) and (playList.Items[playList.ItemIndex].IsPausing) then
        begin
          lvPlaylist.Items[playList.ItemIndex].Checked:=not lvPlaylist.Items[playList.ItemIndex].Checked;
          if playList.Changed then
          begin
            lvPlaylist.Items[playList.ItemIndex].Selected:=true;
            lvPlaylist.Items[playList.ItemIndex].MakeVisible(false);
          end;
        end
      else if assigned(playList.Audio) and (playList.Items[playList.ItemIndex].IsPlaying) then
        begin
          lvPlaylist.Items[playList.ItemIndex].Checked:=true;
          if playList.Changed then
          begin
            lvPlaylist.Items[playList.ItemIndex].Selected:=true;
            lvPlaylist.Items[playList.ItemIndex].MakeVisible(false);
          end;
        end
      else
        lvPlaylist.Items[playList.ItemIndex].Checked:=false;

    end;

    if assigned(playList.Audio) then
      begin
        if not playList.IsPlaying then
        begin
          MainForm.Caption:=AppTitle;
          trackBarAudioPosition.Position:=0;
          trackBarAudioPosition.SelEnd:=0;
          Application.Title:=AppTitle;
          exit;
        end;
        
        with playList.Audio do
        begin
          if Seekable then
          begin
            trackBarAudioPosition.Position:= Position*100 Div Length;
            trackBarAudioPosition.SelEnd:=trackBarAudioPosition.Position;
          end;

          //trackBarAudioVolume.Position:=Volume;
          Volume:=trackBarAudioVolume.Position;
          trackBarAudioVolume.SelEnd:=trackBarAudioVolume.Position;
          trackBarAudioVolume.ShowSelRange:=true;

          if assigned(tags) then
            begin
              if tags.Count>0 then
                begin
                  txtAudioTitle.Caption  := Tags.Values['title'];
                  txtAudioArtist.Caption := Tags.Values['artist'];
                  txtAudioAlbum.Caption  := Tags.Values['album'];
                  txtAudioTrack.Caption  := Tags.Values['track'];
                  txtAudioComment.Caption:= Tags.Values['comment'];
                  //MainForm.Caption:='['+txtAudioAlbum.Caption+'] - ['+txtAudioArtist.Caption+' - '+txtAudioTitle.Caption+']';
                end;
            end
          else
            begin
              txtAudioTitle.Caption  := playList.Items[playList.ItemIndex].Name;
              txtAudioArtist.Caption := _('None');
              txtAudioAlbum.Caption  := _('None');
              txtAudioTrack.Caption  := _('None');
              txtAudioComment.Caption:= _('None');
              //MainForm.Caption:=txtAudioTitle.Caption;
            end;
          MainForm.Caption:=SysUtils.format('[%d/%d]:[%s] - [%s - %s]',[playList.ItemIndex+1, playList.Count, txtAudioAlbum.Caption, txtAudioArtist.Caption, txtAudioTitle.Caption ]);
        end;
      end
    else
      begin
        MainForm.Caption:=AppTitle;
        trackBarAudioPosition.Position:=0;
        trackBarAudioPosition.SelEnd:=0;
//        trackBarAudioVolume.Position:=0;
//        trackBarAudioVolume.SelEnd:=0;
      end;

    Application.Title:=MainForm.Caption;
  except

  end;
end;

procedure TMainForm.trackBarAudioVolumeChange(Sender: TObject);
begin
  //if lvPlayList.ItemIndex<0 then exit;
  if not assigned(playList) then exit;

  if not assigned(playList.Audio) then exit;
  try
    with playList.Audio do
    begin
      Volume := trackBarAudioVolume.Position;

      MyIni.WriteInteger('Setting','Volume',trackBarAudioVolume.Position);
      MyIni.UpdateFile;

      trackBarAudioVolume.SelEnd:=trackBarAudioVolume.Position;
      trackBarAudioVolume.ShowSelRange:=true;
    end;
  except

  end;
end;

end.
