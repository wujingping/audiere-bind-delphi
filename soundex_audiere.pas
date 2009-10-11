{*******************************************************}
{                                                       }
{       soundex_audiere.pas Unit                        }
{                                                       }
{       版权所有 (C) 2009 NetCharm Studio!              }
{                                                       }
{*******************************************************}
//******************************************************************************
{*
* @file soundex_audiere.pas
* @version \$Id$
* @author netcharm
* @author Copyright © 2009 by NetCharm
* @date 2009/07/26
* @brief  Audiere Lib v1.9.4 Delphi Binding and Components
* @remarks
*}
//******************************************************************************

unit soundex_audiere;

interface

uses
  Windows, SysUtils, Classes, Contnrs, Audiere, ExtCtrls, JclFileUtils;

type
  TErrorCode = (ecNoError, ecDevice, ecNoFile, ecLoading, ecOpening, ecPlaying, ecEnding, ecUnknwn);

{ TStopCallBack }
{*
* @brief
*}
  TStopCallBack = class(TAdrCallback)
  private

  protected

  public
    FIsPlaying : boolean;
    FResult    : string;
    g_sound    : TAdrOutputStream;
    g_stream   : TAdrOutputStream;

    constructor Create;
    destructor Destroy; override;

    procedure call(event : TAdrStopEvent);
    procedure streamStopped(event : TAdrStopEvent);
  published

  end;

{ TAudioSystem }

{*
* @brief  Audiere Lib System Component
*}
  TAudioSystem = class(TComponent)
  private
    FDiscDevice  : TStringList;
    FAudioDevice : TStringList;
    FFileFormat  : TStringList;
    FFileFilter  : string;
    FVersion     : string;

  protected
    function getVersion:string;
    function getDiscDevice:TStringList;
    function getAudioDevice:TStringList;
    function getFileFormat:TStringList;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property DiscDevice  : TStringList read getDiscDevice;
    property AudioDevice : TStringList read getAudioDevice;
    property FileFormat  : TStringList read getFileFormat;
    property FileFilter  : String      read FFileFilter;
    property Version     : string      read getVersion;

  end;

{ TAudio }

{*
* @brief  Basic Component of Audio Player
*}
  //TAudio = class(TObject)
  TAudio = class(TComponent)
  private
    pDevice    : Pointer;
    pSource    : Pointer;
    pOutput    : Pointer;

    AdrDevice  : TAdrAudioDevice;
    AdrSource  : TAdrSampleSource;
    AdrOutput  : TAdrOutputStream;

    AdrSound   : TAdrOutputStream;
    AdrEffect  : TAdrSoundEffect;

    AdrMIDI    : TAdrMIDIDevice;
    AdrMusic   : TAdrMIDIStream;

    FDevice    : string;
    FFileName  : string;
    FIsPlaying : boolean;
    FIsPausing : boolean;
    FBuffer    : array of byte;
    FFormat    : string;
    FLength    : Integer;
    FPosition  : Integer;
    FLastPos   : Integer;
    FVolume    : Integer;
    FSeekable  : boolean;
    FRepeat    : boolean;
    FTags      : TStringList;
    FErrorCode : TErrorCode;
  protected
    function  getName: string;
    function  isSeekable: Boolean;

    function  getFormat:string;
    function  getLength:Integer;

    procedure setVolume(aVolume:integer);
    function  getVolume:integer;

    procedure setPosition(Position: Integer);
    function  getPosition: Integer;

    procedure setRepeat(aRepeat: boolean);
    function  getRepeat: boolean;

    function  getTags:TStringList;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function  isPlaying: Boolean;
    function  isPausing: Boolean;
  published
    property Device    : string        read getName;
    property FileName  : string        read FFileName   write FFileName;
    property Playing   : boolean       read isPlaying;
    property Pausing   : boolean       read isPausing;
    property Format    : string        read getFormat;
    property Length    : integer       read getLength;
    property Position  : integer       read getPosition write setPosition;
    property Volume    : integer       read getVolume   write setVolume;
    property Seekable  : boolean       read isSeekable;
    property Loop      : boolean       read getRepeat   write setRepeat;
    property Tags      : TStringList   read FTags;

    procedure open(aFile:string);
    function  read(sampleCount: Integer; aBuffer: Pointer): Integer;

    procedure reset;
    procedure play;virtual;
    //procedure play(aName:string);overload;virtual;
    procedure playStream;
    procedure pause(OnOff:boolean);virtual;
    procedure resume;virtual;
    procedure stop;//virtual;

  end;

{ TSound }
{*
* @brief  Sound Player Component
*}
  //TSound = class(TObject)
  TSound = class(TAudio)
  private

  protected

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    //procedure play(aName:string);override;
    procedure play;override;
    //procedure stop;override;
  end;

{ TMusic }

{*
* @brief  MIDI Player Component
*}
  TMusic = class(TAudio)
  private

  protected

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    procedure play;override;
  end;

{ TEffect }

{*
* @brief Sound Effect Compnent
*}
  TEffect = class(TAudio)
  private
    FType     : TAdrSoundEffectType;
  protected

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property mode    :TAdrSoundEffectType   read FType write FType;

    procedure play;override;
 end;

{ TDisc }

{*
* @brief CD Player Conmponent 
*}
  TDisc = class(TAudio)
  private
    AdrDevice : TAdrCDDevice;
    AdrOutput : TAdrCDDevice;

    FHasCD    : boolean;
    
    FTrackCount   : integer;
    FTrackNumber  : integer;
    FDoorOpening  : boolean;
  protected
    function  isDoorOpen:boolean;
    function  isContainsCD:boolean;
    function  getTrackCount:integer;
    procedure openDoor;
    procedure closeDoor;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property HasCD       :boolean       read isContainsCD;
    property DoorOpening :boolean       read isDoorOpen;
    property TrackCount  :integer       read getTrackCount;
    property TrackNumber :integer       read FTrackNumber;

    procedure close;
    procedure eject;
    procedure play(aTrackNo:integer);//override;overload;
    procedure pause(OnOff:boolean);
  end;

{ TWaveGenerator }

{*
* @brief Generator Some Wave like single tone, Square Wave, White Noise, Pink Noise
*}
  TWaveGenerator = class(TAudio)
  private

  protected

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

  published
    procedure MakePinkNoise;
    procedure MakeSquareWave(aFrequency: Double);
    procedure MakeTone(aFrequency: Double);
    procedure MakeWhiteNoise;
    procedure play;
    procedure stop;
  end;

  TPlayMode = (pmSingle, pmSequence, pmRandom, pmRepeat, pmRepeatAll);
{ TPlayListItem }
{*
* @brief  Playlist Item object
*}
  TPlayListItem = class(TObject)
  public
    idx       : LongInt;
    Name      : string;
    Path      : string;
    Code      : string;
    Time      : TDateTime;
    Memo      : string;
    Pos       : LongInt;
    IsPlayed  : boolean;
    IsPlaying : boolean;
    IsPausing : boolean;

    //constructor Create(AOwner: TComponent);
    constructor Create;
    destructor  Destroy; override;

  end;

{ TPlayList }
{*
* @brief  PlayList for medias
*}
  TPlayList = class(TComponent)
  private
    FSysInfo   : TAudioSystem;
    FMultiPlay : boolean;
    FSorting   : boolean;
    FIsPlaying : boolean;
    FIsPausing : boolean;
    FSortMode  : Integer;
    FCount     : Integer;
    FPlayMode  : TPlayMode;
    FFadingIn  : boolean;
    FFadingOut : boolean;
    FItemIndex : integer;
    FLastIndex : integer;
    FChanged   : boolean;
    FItems     : TObjectList;
    FSound     : TSound;
    FTimer     : TTimer;
    FFilter    : string;
    FVolume    : Integer;
  protected
    function  GetChanged:boolean;
    function  GetAudio:TSound;
    procedure SetAudio(aSound: TSound);
    function  GetItem(Index: Integer):TPlayListItem;
    procedure SetItem(Index: Integer; Value: TPlayListItem);
    procedure checkStatus;
    function  checkFile(index: integer):integer;
    procedure onTimer(Sender: TObject);

    procedure LoadFromList(aList: TStringList);
    procedure SaveToList(var aList: TStringList);

  public
    //constructor Create(AOwner: TComponent);
    constructor Create(AOwner: TComponent);
    destructor  Destroy; override;

    procedure LoadFromFile(aFile: string);
    procedure SaveToFile(aFile: string);

    procedure Add(Value: TPlayListItem);overload;
    procedure Add(Index: Integer; Value: TPlayListItem);overload;
    procedure Delete(Index: Integer);
    procedure Clear;
    procedure Sort;

    property Items[Index: Integer]: TPlayListItem  read GetItem    write SetItem; default;
  published
    property MultiPlay            : boolean        read FMultiPlay write FMultiPlay;
    property Sorting              : boolean        read FSorting   write FSorting;
    property IsPlaying            : boolean        read FIsPlaying write FIsPlaying;
    property IsPausing            : boolean        read FIsPausing write FIsPausing;
    property FadingIn             : boolean        read FFadingIn  write FFadingIn;
    property FadingOut            : boolean        read FFadingOut write FFadingOut;
    property Count                : Integer        read FCount     write FCount;
    property ItemIndex            : Integer        read FItemIndex write FItemIndex;
    property FileFilter           : string         read FFilter;
    property PlayMode             : TPlayMode      read FPlayMode  write FPlayMode;
    property Audio                : TSound         read GetAudio;//   write FSound;
    property Changed              : boolean        read GetChanged;//   write FSound;

    procedure play(index: integer);
    procedure pause(OnOff:boolean);
    procedure resume;
    procedure stop;
    procedure first;
    procedure prev;
    procedure next;
    procedure last;


  end;


implementation

resourcestring
  DEVICE_AUTO_DETECT = 'AutoDetect: Choose default device';


{-------------------------------------------------------------------------------
  过程名:    Register
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{*
* @author netcharm
* @date 2009/07/26 : Original Version
* @result 无
* @brief
*}
//******************************************************************************
procedure Register;
begin
  RegisterComponents('Audiere Lib', [TAudioSystem, TPlayList, TSound, TMusic, TEffect,
                                    TDisc, TWaveGenerator]);
end;

{ TStopCallBack }
constructor TStopCallBack.Create;
begin

end;

destructor TStopCallBack.Destroy;
begin

  inherited;
end;

procedure TStopCallBack.call(event: TAdrStopEvent);
begin
  FIsPlaying := false;
  FResult:='';
  if event.getReason() = STOP_CALLED then
    FResult := FResult+'Stop Called'+#$0a
  else if event.getReason() = STREAM_ENDED then
    FResult := FResult+'Stream Ended'+#$0a
  else
    FResult := FResult+'Unknown'+#$0a;

  if      (event.getOutputStream() = g_sound) then
    begin
      FResult := FResult+'Deleting sound'+#$0a;
      g_sound := nil;
    end
  else if (event.getOutputStream() = g_stream) then
    begin
      FResult := FResult+'Deleting stream'+#$0a;
      g_stream := nil;
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    TStopCallBack.streamStopped
  作者:      netcharm
  日期:      2009.08.11
  参数:      event: TAdrStopEvent
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{*
* @author netcharm
* @date 2009/08/11 : Original Version
* @param event TAdrStopEvent
* @result 无
* @brief
*}
//******************************************************************************
procedure TStopCallBack.streamStopped(event: TAdrStopEvent);
begin
  FIsPlaying := false;
  FResult:='';
  if event.getReason() = STOP_CALLED then
    FResult := FResult+'Stop Called'+#$0a
  else if event.getReason() = STREAM_ENDED then
    FResult := FResult+'Stream Ended'+#$0a
  else
    FResult := FResult+'Unknown'+#$0a;

  if      (event.getOutputStream() = g_sound) then
    begin
      FResult := FResult+'Deleting sound'+#$0a;
      g_sound := nil;
    end
  else if (event.getOutputStream() = g_stream) then
    begin
      FResult := FResult+'Deleting stream'+#$0a;
      g_stream := nil;
    end;
end;

//

{ TWaveGenerator }

{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TWaveGenerator.Create(AOwner: TComponent);
begin
  inherited;
  try
    if not assigned(AdrDevice) then
      AdrDevice := AdrOpenDevice('', '');
  except
  
  end;
end;


{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TWaveGenerator.Destroy;
begin
//  if assigned(AdrOutput) then AdrOutput.UnRef;
//  if assigned(AdrSource) then AdrSource.UnRef;
//  if assigned(AdrDevice) then AdrDevice.UnRef;
  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.MakeSquareWave
  作者:      netcharm
  日期:      2009.07.26
  参数:      aFrequency: Double
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param aFrequency Double   
* @result 无
* @brief
*}
//******************************************************************************
procedure TWaveGenerator.MakeSquareWave(aFrequency: Double);
begin
  try
    if assigned(AdrDevice) then
    begin
      //AdrSource:=TWaveSquareWaveBuffer.Create(aFrequency);
      AdrSource:=AdrCreateSquareWave(aFrequency);
    end;
  except
  
  end;
end;


{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.MakeTone
  作者:      netcharm
  日期:      2009.07.26
  参数:      aFrequency: Double
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param aFrequency Double   
* @result 无
* @brief
*}
//******************************************************************************
procedure TWaveGenerator.MakeTone(aFrequency: Double);
begin
  try
    if assigned(AdrDevice) then
    begin
      //AdrSource:=TWaveToneBuffer.Create(aFrequency);
      AdrSource:=AdrCreateTone(aFrequency);

    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.MakePinkNoise
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TWaveGenerator.MakePinkNoise;
begin
  try
    if assigned(AdrDevice) then
    begin
      //AdrSource:=TWavePinkNoiseBuffer.Create;
      AdrSource:=AdrCreatePinkNoise;
    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.MakeWhiteNoise
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TWaveGenerator.MakeWhiteNoise;
begin
  try
    if assigned(AdrDevice) then
    begin
      //AdrSource:=TWaveWhiteNoiseBuffer.Create;
      pSource   := AdrCreateWhiteNoise;
      AdrSource := pSource;
    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.play
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TWaveGenerator.play;
begin
  try
    if assigned(AdrOutput) then
      begin
        if AdrOutput.isPlaying then AdrOutput.stop;
        if AdrOutput.InstanceSize<4 then
        begin
          pOutput   := AdrOpenSound(AdrDevice, AdrSource, true);
          AdrOutput := pOutput;
        end;
      end
    else
      begin
        pOutput   := AdrOpenSound(AdrDevice, AdrSource, true);
        AdrOutput := pOutput;
      end;
    AdrOutput.Ref;
    AdrOutput.Play;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TWaveGenerator.stop
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TWaveGenerator.stop;
begin
  try
    if assigned(AdrOutput) then
    begin
      if AdrOutput.IsPlaying then 
      begin
        AdrOutput.Stop;
        AdrOutput.UnRef;
      end;
      AdrOutput:=nil;
    end;
  except

  end;
  inherited;
end;

{ TAudio }

{-------------------------------------------------------------------------------
  过程名:    TAudio.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TAudio.Create(AOwner: TComponent);
begin
  inherited;
  FDevice    := '';
  FFileName  := '';
  FIsPlaying := false;
  FFormat    := '';
  FLength    := 0;
  FPosition  := 0;
  FLastPos   := 0;
  FVolume    := 0;
  FSeekable  := false;
  FRepeat    := false;
  FIsPausing := false;
  FTags      := TStringList.Create;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TAudio.Destroy;
begin
  try
    if assigned(FTags)     then FreeAndNil(FTags);
    
//    if assigned(AdrOutput) then AdrOutput.UnRef;
//    if assigned(AdrSource) then Adrsource.UnRef;
//    if assigned(AdrDevice) then AdrDevice.UnRef;
//    if assigned(AdrSound)  then AdrSound.UnRef;
//    if assigned(AdrEffect) then AdrEffect.UnRef;
//    if assigned(AdrMIDI)   then AdrMIDI.UnRef;
//    if assigned(AdrMusic)  then AdrMusic.UnRef;

//    AdrSound  := nil;
//    AdrEffect := nil;
//    AdrMIDI   := nil;
//    AdrMusic  := nil;
//    AdrOutput := nil;
//    Adrsource := nil;
//    AdrDevice := nil;
//    pOutput   := nil;
//    pSource   := nil;
//    pDevice   := nil;

    AdrSound  := nil;
    AdrEffect := nil;
    AdrMIDI   := nil;
    AdrMusic  := nil;
    AdrOutput := nil;
    Adrsource := nil;
    AdrDevice := nil;
    pOutput   := nil;
    pSource   := nil;
    pDevice   := nil;

  except

  end;
  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getFormat
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    string
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result string
* @brief
*}
//******************************************************************************
function TAudio.getFormat: string;
begin
  //AdrSource.get

end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getLength
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    Integer
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result Integer
* @brief
*}
//******************************************************************************
function TAudio.getLength: Integer;
begin
  result:=0;
  try
    if assigned(AdrOutput) then
      FLength:=AdrOutput.GetLength
    else
      FLength:=0;
    result:=FLength;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getName
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    string
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result string
* @brief
*}
//******************************************************************************
function TAudio.getName: string;
begin
  result:='';
  try
    if assigned(AdrDevice) then
    begin
      FDevice:=AdrDevice.getName;
      result:=FDevice;
    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getPosition
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    Integer
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result Integer
* @brief
*}
//******************************************************************************
function TAudio.getPosition: Integer;
begin
  result:=0;
  try
    if isSeekable then
    begin
      begin
        if assigned(AdrOutput) then
          FPosition:=AdrOutput.GetPosition
        else
          FPosition:=0;
      end;
    end;
    result:=FPosition;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getRepeat
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    boolean
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result boolean
* @brief
*}
//******************************************************************************
function TAudio.getRepeat: boolean;
begin
  result:=false;
  try
    if assigned(AdrOutput) then
      FRepeat:=AdrOutput.GetRepeat
    else
      FRepeat:=false;
    result:=FRepeat;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getTags
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    TStringList
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result TStringList
* @brief
*}
//******************************************************************************
function TAudio.getTags: TStringList;
var
  I: Integer;
  tag:TTag;
begin
  result:=nil;
  if not assigned(FTags) then
    FTags:=TStringList.Create;
  try
    FTags.Clear;
    if assigned(AdrSource) then
    begin
      FTags.NameValueSeparator:='=';
      for I := 0 to AdrSource.getTagCount - 1 do
      begin
        tag.key        := Trim(AdrSource.getTagKey(I));
        tag.value      := Trim(AdrSource.getTagValue(I));
        tag.category   := Trim(AdrSource.getTagType(I));

        if UTF8Decode(tag.key)     <>'' then
          tag.key      := UTF8Decode(tag.key);
        if UTF8Decode(tag.value)   <>'' then
          tag.value    := UTF8Decode(tag.value);
        if UTF8Decode(tag.category)<>'' then
          tag.category := UTF8Decode(tag.category);

        FTags.AddObject(tag.key+'='+tag.value,tag);
      end;
    end
  finally
    //Tags.Assign(FTags);
    result:=FTags;
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.getVolume
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    integer
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result integer
* @brief
*}
//******************************************************************************
function TAudio.getVolume: integer;
begin
  result:=FVolume;
  try
    if assigned(AdrOutput) then
      FVolume:=Trunc(AdrOutput.GetVolume*100);
    result:=FVolume;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.isPlaying
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    Boolean
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result Boolean
* @brief
*}
//******************************************************************************
function TAudio.isPausing: Boolean;
begin
  try
    //if FIsPausing then
      result:=FIsPausing;
  except
    result:=false;
  end;
end;

function TAudio.isPlaying: Boolean;
begin
  try
    //if assigned(pOutput) then
    if assigned(AdrOutput) then
      FIsPlaying:=AdrOutput.IsPlaying
    else
      FIsPlaying:=false;
    result:=FIsPlaying;
  except
    result:=false;
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.isSeekable
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    Boolean
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result Boolean
* @brief
*}
//******************************************************************************
function TAudio.isSeekable: Boolean;
begin
  result:=false;
  try
    if assigned(AdrOutput) then
      FSeekable:=AdrOutput.IsSeekable
    else
      FSeekable:=false;
    result:=FSeekable;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.open
  作者:      netcharm
  日期:      2009.07.26
  参数:      aFile: string
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param aFile string   
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.open(aFile: string);
begin

end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.pause
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.pause(OnOff:boolean);
begin
  FIsPausing:=OnOff;
  try
    if OnOff then
      begin
        if assigned(AdrOutput) then
        begin
          FLastPos:=AdrOutput.GetPosition;
          AdrOutput.Stop;
        end;
      end
    else
      begin
        if assigned(AdrOutput) then
        begin
          AdrOutput.SetPosition(FLastPos);
          AdrOutput.Ref;
          AdrOutput.Play;
        end;
      end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.playStream
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{*
* @author netcharm
* @date 2009/07/26 : Original Version
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.play;
begin

end;

procedure TAudio.playStream;
begin

end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.read
  作者:      netcharm
  日期:      2009.07.26
  参数:      sampleCount: Integer; aBuffer: Pointer
  返回值:    Integer
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param sampleCount Integer   
* @param aBuffer Pointer   
* @result Integer
* @brief
*}
//******************************************************************************
function TAudio.read(sampleCount: Integer; aBuffer: Pointer): Integer;
begin
  result:=0;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.reset
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.reset;
begin
  try
    if assigned(AdrOutput) then
      AdrOutput.Reset;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.resume
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.resume;
begin
  FIsPausing:=false;
  try
    if assigned(AdrOutput) then
    begin
      AdrOutput.SetPosition(FLastPos);
      AdrOutput.Ref;
      AdrOutput.Play;
    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.setPosition
  作者:      netcharm
  日期:      2009.07.26
  参数:      Position: Integer
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param Position Integer   
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.setPosition(Position: Integer);
begin
  try
    if isSeekable then
    begin
      FPosition:=Position;
      if assigned(AdrOutput) then
        AdrOutput.SetPosition(FPosition);
    end;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.setRepeat
  作者:      netcharm
  日期:      2009.07.26
  参数:      aRepeat: boolean
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param aRepeat boolean   
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.setRepeat(aRepeat: boolean);
begin
  try
    FRepeat:=aRepeat;
    if assigned(AdrOutput) then
      AdrOutput.SetRepeat(FRepeat);
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.setVolume
  作者:      netcharm
  日期:      2009.07.26
  参数:      aVolume: integer
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param aVolume integer   
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.setVolume(aVolume: integer);
begin
  try
    FVolume:=aVolume;
    if assigned(AdrOutput) then
      AdrOutput.SetVolume(FVolume/100);
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudio.stop
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TAudio.stop;
begin
  try
    if assigned(AdrOutput) then
    begin
      if isPlaying then
      begin
        AdrOutput.Stop;
        Sleep(50);
      end;
      if Position>=Length then
        Sleep(100);
      AdrOutput.Unref;
      Sleep(50);
      AdrOutput:=nil;
      Sleep(100);
    end;
  except
  
  end;
end;

{ TSound }

{-------------------------------------------------------------------------------
  过程名:    TSound.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TSound.Create;
begin
  inherited;
  try
    //if not assigned(pDevice) then
    if not assigned(AdrDevice) then
    begin
      AdrDevice := AdrOpenDevice('', '');
      //pDevice := AdrOpenDevice('', '');
      //AdrDevice := pDevice;
      FDevice   := AdrDevice.getName;
  //    if Assigned(AdrDevice) then
  //        AdrDevice.Ref;
    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TSound.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TSound.Destroy;
begin
  //if assigned(FTags) then FreeAndNil(FTags);
  If FIsPlaying or FIsPausing then stop;
  if assigned(AdrDevice) then AdrDevice.UnRef;
  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TSound.play
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version
* @result 无
* @brief
*}
//******************************************************************************
procedure TSound.play;
begin
  try
    FErrorCode:=ecNoError;
    FIsPausing:=false;
    if not assigned(AdrDevice) then
    begin
      AdrDevice := AdrOpenDevice('', '');
      FDevice   := AdrDevice.getName;
    end;
    if assigned(AdrDevice) then
      begin
        if not FileExists(FFileName) then
        begin
          FErrorCode:=ecNoFile;
          exit;
        end;

        if AdrSource <> nil then AdrSource := nil;
        AdrSource := AdrOpenSampleSource(PAnsiChar(FFileName),FF_AUTODETECT);
        if AdrSource = nil then
        begin
          FErrorCode:=ecLoading;
          exit;
        end;

        if AdrOutput <> nil then AdrOutput := nil;
        AdrOutput := AdrOpenSound(AdrDevice, AdrSource, true);
        if AdrOutput = nil then
        begin
          FErrorCode:=ecOpening;
          exit;
        end;

        AdrOutput.Ref;
        AdrOutput.SetVolume(FVolume/100);
        AdrOutput.Play;
        getTags;
      end
    else
      FErrorCode:=ecDevice;
  except

  end;
end;

{ TMusic }

{-------------------------------------------------------------------------------
  过程名:    TMusic.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TMusic.Create(AOwner: TComponent);
begin
  inherited;
  //FTags:=TStringList.Create;
  try
    if not assigned(AdrDevice) then
    begin
      //AdrDevice := AdrOpenMIDIDevice('');
      pDevice := AdrOpenMIDIDevice('');
      AdrMIDI := pDevice;
      //FDevice := AdrDevice.GetName;
    end;
  except

  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TMusic.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TMusic.Destroy;
begin
  try
    //if assigned(FTags) then FreeAndNil(FTags);
    if assigned(AdrDevice) then
    begin
      AdrDevice.UnRef;
      AdrDevice:=nil;
    end;
  except
  
  end;
  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TMusic.play
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TMusic.play;
begin
  try
    if assigned(AdrDevice) then
    begin
      //AdrMusic:=AdrDevice.OpenStream(PChar(FFileName));
      pOutput := AdrMIDI.OpenStream(PChar(FFileName));
      AdrMusic := pOutput;
      if AdrMusic.InstanceSize>4 then
      begin
        AdrMusic.Ref;
        AdrMusic.play;
        getTags;
      end;
    end;
  finally

  end;
end;

{ TEffect }

{-------------------------------------------------------------------------------
  过程名:    TEffect.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TEffect.Create;
begin
  inherited;
  try
    if not assigned(AdrDevice) then
    begin
      //AdrDevice := AdrOpenDevice('', '');
      pDevice :=AdrOpenDevice('', '');
      AdrDevice := pDevice;
    end;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TEffect.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TEffect.Destroy;
begin
  try
    if assigned(AdrEffect) then
    begin
      AdrEffect.UnRef;
      AdrEffect:=nil;
    end;
  except
  
  end;
  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TEffect.play
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TEffect.play;
begin
  try
    if assigned(AdrDevice) then
    begin
      //AdrSource := AdrOpenSampleSource(PAnsiChar(FFileName),FF_AUTODETECT);
      pSource := AdrOpenSampleSource(PAnsiChar(FFileName),FF_AUTODETECT);
      AdrSource := pSource;
      AdrSource.ref;
      //AdrEffect := AdrOpenSoundEffect(AdrDevice, AdrSource, Adr_SoundEffectType_Multiple);
      pOutput := AdrOpenSoundEffect(AdrDevice, AdrSource, Adr_SoundEffectType_Multiple);
      AdrOutput := pOutput;
      AdrEffect := pOutput;
      AdrEffect.Ref;
      AdrEffect.Play;

      getTags;
    end;
  except
  
  end;
end;

{ TDisc }

{-------------------------------------------------------------------------------
  过程名:    TDisc.close
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TDisc.close;
begin
  try
    closeDoor;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.closeDoor
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TDisc.closeDoor;
begin
  try
    if assigned(AdrOutput) then
      AdrOutput.closeDoor;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TDisc.Create;
begin
  inherited;
  try
    if not assigned(AdrOutput) then
      AdrOutput := AdrOpenCDDevice('');
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TDisc.Destroy;
begin

  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.eject
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TDisc.eject;
begin
  try
    openDoor;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.getTrackCount
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    integer
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result integer
* @brief
*}
//******************************************************************************
function TDisc.getTrackCount: integer;
begin
  result:=-1;
  try
    if assigned(AdrOutput) then
      FTrackCount:=AdrOutput.getTrackCount;
    result:=FTrackCount;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.isContainsCD
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    boolean
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result boolean
* @brief
*}
//******************************************************************************
function TDisc.isContainsCD: boolean;
begin
  result:=false;
  FHasCD:=false;
  try
    if assigned(AdrOutput) then
      FHasCD:=AdrOutput.containsCD;
    result:=FHasCD;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.isDoorOpen
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    boolean
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result boolean
* @brief
*}
//******************************************************************************
function TDisc.isDoorOpen: boolean;
begin
  result:=false;
  FDoorOpening:=false;
  try
    if assigned(AdrOutput) then
      FDoorOpening:=AdrOutput.isDoorOpen;
    result:=FDoorOpening;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.openDoor
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
procedure TDisc.openDoor;
begin
  try
    if assigned(AdrOutput) then
      AdrOutput.openDoor;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.play
  作者:      netcharm
  日期:      2009.07.26
  参数:      aTrackNo: integer
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @param aTrackNo integer   
* @result 无
* @brief
*}
//******************************************************************************
procedure TDisc.pause(OnOff:boolean);
begin

  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TDisc.play
  作者:      netcharm
  日期:      2009.08.11
  参数:      aTrackNo: integer
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/08/11 : Original Version 
* @param aTrackNo integer   
* @result 无
* @brief
*}
//******************************************************************************
procedure TDisc.play(aTrackNo: integer);
begin
  try
    if assigned(AdrOutput) then
    begin
      AdrOutput.Ref;
      AdrOutput.play(aTrackNo);
    end;
  except
  
  end;
end;


{ TAudioSystem }

{-------------------------------------------------------------------------------
  过程名:    TAudioSystem.Create
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
constructor TAudioSystem.Create(AOwner: TComponent);
begin
  inherited;
  FVersion     := '';
  FDiscDevice  := TStringList.Create;
  FAudioDevice := TStringList.Create;
  FFileFormat  := TStringList.Create;
  try
    FDiscDevice.Delimiter := ';';
    FAudioDevice.Delimiter := ';';
    FFileFormat.Delimiter := ';';

    getVersion;
    getAudioDevice;
    getDiscDevice;
    getFileFormat;
    
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudioSystem.Destroy
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
destructor TAudioSystem.Destroy;
begin
  if assigned(FDiscDevice) then FreeAndNil(FDiscDevice);
  if assigned(FAudioDevice) then FreeAndNil(FAudioDevice);
  if assigned(FFileFormat) then FreeAndNil(FFileFormat);

  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudioSystem.getAudioDevice
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    TStringList
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result TStringList
* @brief
*}
//******************************************************************************
function TAudioSystem.getAudioDevice: TStringList;
var
  device:TAudioDeviceDesc;
  str:string;
  idx,sep:integer;
begin
  result:=nil;
  try
    str:=AdrGetSupportedAudioDevices+';';
    FAudioDevice.Clear;
    FAudioDevice.Append(DEVICE_AUTO_DETECT);

    idx:=Pos(';',str);
    repeat
      FAudioDevice.Append(copy(str, 1, idx-1));
      device.name:=copy(str, 1, idx-1);
      sep:=Pos(':', device.name);
      device.description:=copy(device.name, sep+1, length(device.name)-sep-1);
      delete(device.name, sep, length(device.name)-sep);
      delete(str,1,idx);
      idx:=Pos(';',str);
    until idx<=0;
    //FAudioDevice.Append(_('AutoDetect: Choose default device'));

    result:=FAudioDevice;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudioSystem.getDiscDevice
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    TStringList
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result TStringList
* @brief
*}
//******************************************************************************
function TAudioSystem.getDiscDevice: TStringList;
var
  device:TAudioDeviceDesc;
  str:string;
  idx,sep:integer;
begin
  result:=nil;
  try
    str:=AdrEnumerateCDDevices+';';
    FDiscDevice.Clear;
    FDiscDevice.Append(DEVICE_AUTO_DETECT);

    idx:=Pos(';',str);
    repeat
      FDiscDevice.Append(copy(str, 1, idx-1));
      device.name:=copy(str, 1, idx-1);
      sep:=Pos(':', device.name);
      device.description:=copy(device.name, sep+1, length(device.name)-sep-1);
      delete(device.name, sep, length(device.name)-sep);
      delete(str,1,idx);
      idx:=Pos(';',str);
    until idx<=0;

    result:=FDiscDevice;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudioSystem.getFileFormat
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    TStringList
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result TStringList
* @brief
*}
//******************************************************************************
function TAudioSystem.getFileFormat: TStringList;
var
  device:TAudioDeviceDesc;
  str,strn:string;
  idx,sep:integer;
  I: Integer;
begin
  result:=nil;
  try
    str:=AdrGetSupportedFileFormats+';';
    FFileFormat.Clear;
    FFileFormat.Append(DEVICE_AUTO_DETECT);

    idx:=Pos(';',str);
    repeat
      strn := copy(str, 1, idx-1);
      strn := StringReplace(strn,':',' (*.',[rfReplaceAll]);
      strn := StringReplace(strn,',',';*.',[rfReplaceAll]);
      strn := strn+')';
      FFileFormat.Append(strn);

      device.name:=copy(str, 1, idx-1);
      sep:=Pos(':', device.name);
      device.description:=copy(device.name, sep+1, length(device.name)-sep-1);
      delete(device.name, sep, length(device.name)-sep);
      delete(str,1,idx);
      idx:=Pos(';',str);
    until idx<=0;

    FFileFilter := '';
    for I := 1 to FFileFormat.Count - 1 do
    begin
      FFileFilter := FFileFilter + FFileFormat[I];
      FFileFilter := StringReplace(FFileFilter, '(', '|', [rfReplaceAll]);
      FFileFilter := StringReplace(FFileFilter, ')', '|', [rfReplaceAll]);
      FFileFilter := StringReplace(FFileFilter, '"', '', [rfReplaceAll]);
    end;
    Delete(FFileFilter,Length(FFileFilter),1);
    result:=FFileFormat;
  except
  
  end;
end;

{-------------------------------------------------------------------------------
  过程名:    TAudioSystem.getVersion
  作者:      netcharm
  日期:      2009.07.26
  参数:      无
  返回值:    string
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/07/26 : Original Version 
* @result string
* @brief
*}
//******************************************************************************
function TAudioSystem.getVersion: string;
begin
  result:='';
  try
    result:=AdrGetVersion;
  except
  
  end;
end;

{ TPlayList }

//constructor TPlayList.Create(AOwner: TComponent);
constructor TPlayList.Create(AOwner: TComponent);
begin
  inherited;
  FSysInfo   := TAudioSystem.Create(AOwner);
  
  FMultiPlay := false;
  FSorting   := true;
  FPlayMode  := pmSingle;
  FSortMode  := 0;
  FCount     := 0;
  FFilter    := 'Playlist File|*.m3u;';

  FItems     := TObjectList.Create;
  FItems.Clear;

  FTimer         := TTimer.Create(Self);
  FTimer.Enabled := false;
  FTimer.Interval:= 75;
  FTimer.OnTimer := onTimer;
  FTimer.Enabled := true;

  //FSound := TSound.Create;
end;

destructor TPlayList.Destroy;
begin
  try
    if assigned(FTimer) then
    begin
      FTimer.Enabled:=false;
      FTimer.OnTimer:=nil;
      FreeAndNil(FTimer);
    end;

    if assigned(FSysInfo) then FreeAndNil(FSysInfo);

    if (FIsPlaying or FIsPausing) then stop;
    sleep(100);

    if assigned(FItems) then
    begin
      FItems.Clear;
      FreeAndNil(FItems);
    end;
    if assigned(FSound) then
    begin
      FreeAndNil(FSound);
      //FSound.Free;
    end;

  except

  end;
  inherited;
end;

procedure TPlayList.Add(Value: TPlayListItem);
begin
  try
    FItems.Add(Value);
    FCount:=FItems.Count;
    FChanged:=true;
  except

  end;
end;

procedure TPlayList.Add(Index: Integer; Value: TPlayListItem);
begin
  try
    FItems.Insert(Index, Value);
    FCount:=FItems.Count;
    FChanged:=true;
  except

  end;
end;

function TPlayList.checkFile(index: integer): integer;
var
  rExt:string;
begin
  result:=index;
  try
    while not FileExists(TPlayListItem(FItems[result]).Path) do
    begin
      result:=result+1;
      if result>=FItems.Count then
      begin
        //result:=Fitems.Count-1;
        result:=-1;
        break;
      end;
    end ;

    repeat
      rExt:=ExtractFileExt(TPlayListItem(FItems[result]).Path);
      result:=result+1;
      if result>FItems.Count then
      begin
        //result:=Fitems.Count-1;
        result:=0;
        break;
      end;
    until (Pos(UpperCase(rExt), UpperCase(FSysInfo.FileFilter))>0);
    result:=result-1;
  except
    result:=-1;
  end;
end;

procedure TPlayList.checkStatus;
begin
  try
    exit;
    if FIsPlaying then
    begin
      if FLastIndex=FItemIndex then Exit;

      FLastIndex:=FItemIndex;
    end;
  except

  end;
end;

procedure TPlayList.Clear;
begin
  try
    FItems.Clear;
    FCount:=FItems.Count;
    FItemIndex:=-1;
    FChanged:=true;
  except

  end;
end;

procedure TPlayList.Delete(Index: Integer);
begin
  try
    if Index=FItemIndex then
      begin
        stop;
        prev;
      end
    else if Index<FItemIndex then
      FItemIndex:=FItemIndex-1;
      
    FItems.Delete(index);
    FCount:=FItems.Count;
    if FCount<=0 then FItemIndex:=-1;
    FChanged:=true;
  except

  end;
end;

procedure TPlayList.first;
begin
  try
    if FCount>0 then FItemIndex:=0
    else             FItemIndex:=-1;
    checkStatus;
  except

  end;
end;

function TPlayList.GetAudio: TSound;
begin
  result:=nil;
  try
    if assigned(FSound) then
      result:=FSound;
  except

  end;
end;

function TPlayList.GetChanged: boolean;
begin
  result:=FChanged;
  FChanged:=false;
end;

function TPlayList.GetItem(Index: Integer): TPlayListItem;
begin
  result:=nil;
  try
    if (Index<0) or (Index>=FCount) then
      result:=nil
    else
      result:=TPlayListItem(FItems[Index]);
  except

  end;
end;

procedure TPlayList.last;
begin
  try
    if FCount>0 then FItemIndex:=FCount-1
    else             FItemIndex:=-1;
    checkStatus;
  except

  end;
end;

procedure TPlayList.LoadFromFile(aFile: string);
var
  I: Integer;
  fPath, fName, dPath:string;
  aFT: TStringList;
begin
  if not FileExists(aFile) then exit;

  aFT := TStringList.Create;
  try
    dPath:=ExtractFilePath(aFile);
    aFT.LoadFromFile(aFile);
    for I := 0 to aFT.Count - 1 do
    begin
      aFT[I]:=trim(aFT[I]);

      if aFT[I]='' then continue;
      if aFT[I][1]='#' then continue;
      fPath:=ExtractFilePath(aFT[I]);
      fName:=ExtractFileName(aFT[I]);
      if fName='' then continue;

      add(TPlayListItem.Create());
      TPlayListItem(FItems.Last).idx  := Count-1;
      TPlayListItem(FItems.Last).Name := ChangeFileExt(fName,'');

      if ExtractFileDrive(aFT[I])<>'' then
        TPlayListItem(FItems.Last).Path := aFT[I]
      else
        TPlayListItem(FItems.Last).Path := dPath+aFT[I];
        
      TPlayListItem(FItems.Last).Code := 'utf-8';
      TPlayListItem(FItems.Last).Time := EncodeTime(0,0,0,0);
      TPlayListItem(FItems.Last).Memo := '';
      TPlayListItem(FItems.Last).Pos  := 0;
    end;
  finally
    aFT.Free;
    FItemIndex:=0;
  end;
end;

procedure TPlayList.LoadFromList(aList: TStringList);
var
  I: Integer;
  fN, fName:string;
begin
  try
    for I := 0 to aList.Count - 1 do
    begin
      fN := trim(aList[I]);
      fName:=ExtractFileName(fN);
      add(TPlayListItem.Create());
      TPlayListItem(FItems.Last).idx  := Count-1;
      TPlayListItem(FItems.Last).Name := ChangeFileExt(fName,'');
      TPlayListItem(FItems.Last).Path := fN;
      TPlayListItem(FItems.Last).Code := 'utf-8';
      TPlayListItem(FItems.Last).Time := EncodeTime(0,0,0,0);
      TPlayListItem(FItems.Last).Memo := '';
      TPlayListItem(FItems.Last).Pos  := 0;
      //FItems.Items.du
    end;
  finally

  end;
end;

procedure TPlayList.SaveToFile(aFile: string);
var
  I: Integer;
  rPath, fPath, fName, dPath:string;
  aFT: TStringList;
begin
  aFT := TStringList.Create;
  try
    dPath:=ExtractFilePath(aFile);
    aFT.Add('#EXTM3U');
    for I := 0 to FItems.Count - 1 do
    begin
      //aFT.Add('');
      aFT.Add('# '+TPlayListItem(FItems[I]).Name);
      aFT.Add('# '+TPlayListItem(FItems[I]).Memo);
      fPath:=ExtractFilePath(TPlayListItem(FItems[I]).Path);
      fName:=ExtractFileName(TPlayListItem(FItems[I]).Path);
      rPath:=PathGetRelativePath(rPath, dPath);
      if dPath=fPath then
        aFT.Add(fName)
      else
        aFT.Add(TPlayListItem(FItems[I]).Path);
    end;
    aFT.SaveToFile(aFile);
  finally
    aFT.Free;
  end;
end;

procedure TPlayList.SaveToList(var aList: TStringList);
begin

end;

procedure TPlayList.next;
begin
  try
    if FCount>0 then
      begin
        if FItemIndex>=(FCount-1) then
          FItemIndex:=FCount-1
        else
          FItemIndex:=FItemIndex+1;
      end
    else  FItemIndex:=-1;
    checkStatus;
  except

  end;
end;

procedure TPlayList.onTimer(Sender: TObject);
begin
//exit;
  if (not (IsPlaying or IsPausing)) then exit;
  if not assigned(FSound) then exit;

//  if FSound.isPlaying or FSound.isPausing then
  if FSound.isPlaying then
  begin
    FVolume:=FSound.Volume;
    if FSound.Loop then
      FSound.Loop:=false;
  end;

  try
    //exit;
    case FPlayMode of
      pmSingle    : begin
                      //if (not FSound.isPlaying) And (assigned(FSound))then
                      //if (assigned(FSound))then
                      begin
                        if not ((FSound.isPlaying or FSound.isPausing)) then stop;
                      end;
                    end;
      pmSequence  : begin
                      //if (not FSound.isPlaying) And (assigned(FSound)) then
                      if (not (FSound.isPlaying or FSound.isPausing)) then
                      begin
                        if FItemIndex+1<FCount then
                          play(FItemIndex+1)
                        else
                          stop;
                      end;
                    end;
      pmRandom    : begin
                      //if (not FSound.isPlaying) And (assigned(FSound))then
                      if (not (FSound.isPlaying or FSound.isPausing)) then
                      begin
                        play(Random(FCount));
                      end;
                    end;
      pmRepeat    : begin
                      //if (FSound.isPlaying) And (assigned(FSound))then
                      //if (assigned(FSound))then
                      //if (not (FSound.isPlaying or FSound.isPausing)) then
                      begin
                        FSound.Loop:=true;
                      end;
                    end;
      pmRepeatAll : begin
                      //if (not FSound.isPlaying) And (assigned(FSound))then
                      if (not (FSound.isPlaying or FSound.isPausing)) then
                      begin
                        if FItemIndex+1>=FCount then FItemIndex:=-1;
                        sleep(50);
                        play(FItemIndex+1);
                      end;
                    end;
    end;
  except

  end;
end;

procedure TPlayList.pause(OnOff:boolean);
begin
  try
    TPlayListItem(FItems[FItemIndex]).IsPausing:=OnOff;
    FSound.pause(OnOff);
    checkStatus;
  except

  end;
end;

procedure TPlayList.play(index: integer);
begin
  if index<0        then exit;
  if index>FCount-1 then exit;
  if (index=FItemIndex) and (FIsPlaying) then exit;
  try
    if assigned(FTimer) then FTimer.Enabled:=false;
    if FItemIndex>=0 then
    begin
      TPlayListItem(FItems[FItemIndex]).IsPlaying:=false;
      TPlayListItem(FItems[FItemIndex]).IsPausing:=false;
      stop;
    end;

    FItemIndex:=checkFile(index);
    if FItemIndex=-1 then
    begin
      IsPlaying:=false;
      IsPausing:=false;
      exit;
    end;

    if not assigned(FSound) then FSound := TSound.Create(Self);

    //FSound.open(TPlayListItem(FItems[index]).Path);
    repeat
      FSound.FileName:=TPlayListItem(FItems[FItemIndex]).Path;
      FSound.SetVolume(FVolume);
      FSound.play;
      if FSound.FErrorCode<>ecNoError then
      begin
        Sleep(250);
        FItemIndex:=FItemIndex+1;
        if FItemIndex>=FCount then
        begin
          FSound.Stop;
          //FSound.Free;
          exit;
        end;
      end;
    until FSound.FErrorCode=ecNoError;
    TPlayListItem(FItems[FItemIndex]).IsPlaying:=FSound.isPlaying;
    TPlayListItem(FItems[FItemIndex]).IsPausing:=False;
    FIsPlaying:=FSound.isPlaying;
    FIsPausing:=False;
    FChanged:=true;

    if assigned(FTimer) then FTimer.Enabled:=true;
  except

  end;
end;

procedure TPlayList.prev;
begin
  try
    if FCount>0 then
      begin
        if FItemIndex<=0 then
          FItemIndex:=0
        else
          FItemIndex:=FItemIndex-1;
      end
    else  FItemIndex:=-1;
    checkStatus;
  except

  end;
end;

procedure TPlayList.resume;
begin
  try
    FSound.resume;
    checkStatus;
  except

  end;
end;

procedure TPlayList.SetAudio(aSound: TSound);
begin
//
end;

procedure TPlayList.SetItem(Index: Integer; Value: TPlayListItem);
begin
  try
    if (Index>0) And (Index<FCount) then
    begin
      with TPlayListItem(FItems[Index]) do
      begin
        idx       := Value.idx;
        Name      := Value.Name;
        Path      := Value.Path;
        Code      := Value.Code;
        Time      := Value.Time;
        Memo      := Value.Memo;
        IsPlaying := Value.IsPlaying;
        IsPausing := Value.IsPausing;
      end;
    end;
  except

  end;
end;

procedure TPlayList.Sort;
begin
  try
    //FItems.sor
    checkStatus;
  except

  end;
end;

procedure TPlayList.stop;
begin
  try
    if FCount<=0 then exit;
    if assigned(FTimer) then FTimer.Enabled:=false;

    FIsPausing := false;
    FIsPlaying := false;
    
    if (FItemIndex>=0) and (FItemIndex<FCount) then
    begin
      TPlayListItem(FItems[FItemIndex]).IsPausing := false;
      TPlayListItem(FItems[FItemIndex]).IsPlaying := false;
    end;
    if assigned(FSound) then
    begin
      //if FSound.isPlaying or FSound.isPausing then
        FSound.stop;
      //FSound.Free;
      //FreeAndNil(FSound);
    end;

    checkStatus;
  except

  end;
end;


{ TPlayListItem }

constructor TPlayListItem.Create;
begin
  inherited;
  idx       := 0;
  Name      := '';
  Path      := '';
  Code      := 'utf-8';
  Time      := EncodeTime(0,0,0,0);
  Memo      := '';
  Pos       := 0;
  IsPlaying := false;
  IsPausing := false;
end;

destructor TPlayListItem.Destroy;
begin

  inherited;
end;

{-------------------------------------------------------------------------------
  过程名:    不可用
  作者:      netcharm
  日期:      2009.08.11
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{*
* @author netcharm
* @date 2009/08/11 : Original Version
* @result 无
* @brief
*}
//******************************************************************************
initialization
begin
  AdrLoadDll;
end;

{-------------------------------------------------------------------------------
  过程名:    不可用
  作者:      netcharm
  日期:      2009.08.11
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}
//******************************************************************************
{* 
* @author netcharm
* @date 2009/08/11 : Original Version 
* @result 无
* @brief
*}
//******************************************************************************
finalization
begin
  AdrUnLoadDLL;
end;

   
end.
