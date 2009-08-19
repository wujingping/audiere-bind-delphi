//=========================================================================
// Audiere Sound System
// Version 1.9.2
// (c) 2002 Chad Austin
//
// This API uses principles explained at
// http://aegisknight.org/cppinterface.html
//
// This code licensed under the terms of the LGPL.  See the Audiere
// license.txt.
//-------------------------------------------------------------------------
// Delphi Conversion By:
// Jarrod Davis
// Jarrod Davis Software
// http://www.jarroddavis.com   - Jarrod Davis Software
// http://www.gamevisionsdk.com - Game Application Framework for Delphi
// support@jarroddavis.com      - Support Email
//-------------------------------------------------------------------------
// How to use:
//   * Include Audiere in your Uses statement
//   * Enable or Disable the DYNAMICS compiler define
//   * If Dynamic, be sure to call AdrLoadDLL before using any commands.
//     the DLL will be automaticlly unloaded at termination.
//   * If Static, then use as normal.
// History:
//   * Initial 1.9.2 release.
//   + Added dynamic loading. Use the DYNAMIC compiler define to control
//     this. When enabled you can then use ArdLoadLL/AdrUnloadDLL to
//     dynamiclly load/unload dll at runtime.
//=========================================================================

unit Audiere;

{$A+}
{$Z4}
{$DEFINE DYNAMIC}

interface

const
  DLL_NAME = 'Audiere.dll';

type
  { TTag}
  PTag = ^TTag;
  TTag = class(TObject)
  public
    key:string;
    value:string;
    category:string;
  end;

  { TAdrRefCounted  }
  PAdrRefCounted = ^TAdrRefCounted;
  TAdrRefCounted = class
  public
    procedure Ref;   virtual; stdcall; abstract;
    procedure UnRef; virtual; stdcall; abstract;
  end;

  { TAdrSeekMode  }
  TAdrSeekMode = (
    Adr_Seek_Begin,
    Adr_Seek_Current,
    Adr_Seek_End
  );

  PAudioDeviceDesc = ^TAudioDeviceDesc;
  TAudioDeviceDesc = record
    /// Name of device, i.e. "directsound", "winmm", or "oss"
    name : string;
    // Textual description of device.
    description : string;
  end;

  { TAdrFile }
  PAdrFile = ^TAdrFile;
  TAdrFile = class(TAdrRefCounted)
  public
    function Read(aBuffer: Pointer; aSize: Integer): Integer; virtual; stdcall; abstract;
    function Seek(aPosition: Integer; aSeekMode: TAdrSeekMode): Boolean; virtual; stdcall; abstract;
    function Tell: Integer; virtual; stdcall; abstract;
  end;

  { TAdrSampleFormat }
  TAdrSampleFormat = (
    Adr_SampleFormat_U8,
    Adr_SampleFormat_S16
  );

  { TAdrFileFormat }
  TAdrFileFormat = (
    FF_AUTODETECT,
    FF_WAV,
    FF_OGG,
    FF_FLAC,
    FF_MP3,
    FF_MOD,
    FF_AIFF,
    FF_SPEEX
  );

  { TAdrSampleSource }
  PAdrSampleSource = ^TAdrSampleSource;
  TAdrSampleSource = class(TAdrRefCounted)
  public
    procedure getFormat(var aChannelCount: Integer; var aSampleRate: Integer; var aSampleFormat: TAdrSampleFormat); virtual; stdcall; abstract;
    function  read(aFrameCount: Integer; aBuffer: Pointer): Integer;  virtual; stdcall; abstract;
    procedure reset; virtual; stdcall; abstract;
    function  isSeekable: Boolean; virtual; stdcall; abstract;
    function  getLength: Integer; virtual; stdcall; abstract;
    procedure setPosition(Position: Integer); virtual; stdcall; abstract;
    function  getPosition: Integer; virtual; stdcall; abstract;
    procedure setRepeat(aRepeat: boolean); virtual; stdcall; abstract;
    function  getRepeat: boolean; virtual; stdcall; abstract;
    function  getTagCount: Integer; virtual; stdcall; abstract;
    function  getTagKey(aIndex: integer): PChar; virtual; stdcall; abstract;
    function  getTagValue(aIndex: integer): PChar; virtual; stdcall; abstract;
    function  getTagType(aIndex: integer): PChar; virtual; stdcall; abstract;
  end;

  { TAdrLoopPointSource }
  PAdrLoopPointSource = ^TAdrLoopPointSource;
  TAdrLoopPointSource = class(TAdrRefCounted)
  public
    procedure addLoopPoint(aLocation: integer; aTarget:integer; aLoopCount: integer); virtual; stdcall; abstract;
    procedure removeLoopPoint(aIndex: integer); virtual; stdcall; abstract;
    function  getLoopPointCount: integer; virtual; stdcall; abstract;
    function  getLoopPoint(aIndex: integer; var aLocation: integer; var aTarget: integer; aLoopCount: integer): Boolean; virtual; stdcall; abstract;
  end;

  { TAdrOutputStream }
  PAdrOutputStream = ^TAdrOutputStream;
  TAdrOutputStream = class(TAdrRefCounted)
  public
    procedure Play; virtual; stdcall; abstract;
    procedure Stop; virtual; stdcall; abstract;
    function  IsPlaying: Boolean; virtual; stdcall; abstract;
    procedure Reset; virtual; stdcall; abstract;
    procedure SetRepeat(aRepeat: Boolean); virtual; stdcall; abstract;
    function  GetRepeat: Boolean; virtual; stdcall; abstract;
    procedure SetVolume(aVolume: Single); virtual; stdcall; abstract;
    function  GetVolume: Single; virtual; stdcall; abstract;
    procedure SetPan(aPan: Single); virtual; stdcall; abstract;
    function  GetPan: Single; virtual; stdcall; abstract;
    procedure SetPitchShift(aShift: Single); virtual; stdcall; abstract;
    function  GetPitchShift: Single; virtual; stdcall; abstract;
    function  IsSeekable: Boolean; virtual; stdcall; abstract;
    function  GetLength: Integer; virtual; stdcall; abstract;
    procedure SetPosition(aPosition: Integer); virtual; stdcall; abstract;
    function  GetPosition: Integer; virtual; stdcall; abstract;
  end;

  { TAdrEventType }
  TAdrEventType = (
    ET_STOP
  );

  { TAdrEvent  }
  PAdrEvent = ^TAdrEvent;
  TAdrEvent = class(TAdrRefCounted)
  public
    function getType: TAdrEventType;   virtual; stdcall; abstract;
  end;

  { TAdrReason }
  TAdrReason = (
    STOP_CALLED,
    STREAM_ENDED
  );

  { TAdrStopEvent }
  PAdrStopEvent = ^TAdrStopEvent;
  TAdrStopEvent = class(TAdrRefCounted)
  public
    function  getType: TAdrEventType; virtual; stdcall; abstract;
    function  getOutputStream:TAdrOutputStream; virtual; stdcall; abstract;
    function  getReason:TAdrReason; virtual; stdcall; abstract;
  end;

  { TAdrCallback }
  PAdrCallback = ^TAdrCallback;
  TAdrCallback = class(TAdrRefCounted)
  public
    function  getType: TAdrEventType; virtual; stdcall; abstract;
    procedure call(aEvent: TAdrEvent); virtual; stdcall; abstract;
  end;

  { TAdrStopCallback }
  PAdrStopCallback = ^TAdrStopCallback;
  TAdrStopCallback = class(TAdrRefCounted)
  public
    function  getType: TAdrEventType; virtual; stdcall; abstract;
    procedure call(aEvent: TAdrEvent); virtual; stdcall; abstract;
    procedure streamStopped(aStopEvent: TAdrEvent); virtual; stdcall; abstract;
  end;

  { TAdrAudioDevice }
  PAdrAudioDevice = ^TAdrAudioDevice;
  TAdrAudioDevice = class(TAdrRefCounted)
  public
    procedure update; virtual; stdcall; abstract;
    function  openStream(aSource: TAdrSampleSource): TAdrOutputStream; virtual; stdcall; abstract;
    function  openBuffer(aSamples: Pointer; aFrameCount, aChannelCount, aSampleRate: Integer; aSampelFormat: TAdrSampleFormat):  TAdrOutputStream; virtual; stdcall; abstract;
    function  getName: PChar; virtual; stdcall; abstract;
    procedure registerCallback(aCallback: TAdrCallback); virtual; stdcall; abstract;
    procedure unregisterCallback(aCallback: TAdrCallback); virtual; stdcall; abstract;
    procedure clearCallbacks; virtual; stdcall; abstract;
  end;

  { TAdrSampleBuffer }
  PAdrSampleBuffer = ^TAdrSampleBuffer;
  TAdrSampleBuffer = class(TAdrRefCounted)
  public
    procedure GetFormat(var ChannelCount: Integer; var aSampleRate: Integer; var aSampleFormat: TAdrSampleFormat); virtual; stdcall; abstract;
    function  GetLength: Integer; virtual; stdcall; abstract;
    function  GetSamples: Pointer; virtual; stdcall; abstract;
    function  OpenStream: TAdrSampleSource; virtual; stdcall; abstract;
  end;

  { TAdrSoundEffectType }
  TAdrSoundEffectType = (
    Adr_SoundEffectType_Single,
    Adr_SoundEffectType_Multiple
  );

  { TAdrSoundEffect }
  PAdrSoundEffect = ^TAdrSoundEffect;
  TAdrSoundEffect = class(TAdrRefCounted)
  public
    procedure Play; virtual; stdcall; abstract;
    procedure Stop; virtual; stdcall; abstract;
    procedure SetVolume(aVolume: Single); virtual; stdcall; abstract;
    function  GetVolume: Single; virtual; stdcall; abstract;
    procedure SetPan(aPan: Single); virtual; stdcall; abstract;
    function  GetPan: Single; virtual; stdcall; abstract;
    procedure SetPitchShift(aShift: Single); virtual; stdcall; abstract;
    function  GetPitchShift: Single; virtual; stdcall; abstract;
  end;

  { TAdrCDDevice }
  PAdrCDDevice = ^TAdrCDDevice;
  TAdrCDDevice = class(TAdrRefCounted)
  public
    function  GetName: PChar; virtual; stdcall; abstract;
    function  getTrackCount: integer; virtual; stdcall; abstract;
    procedure play(aTrack: integer); virtual; stdcall; abstract;
    procedure stop; virtual; stdcall; abstract;
    procedure pause; virtual; stdcall; abstract;
    procedure resume; virtual; stdcall; abstract;
    function  isPlaying: Boolean; virtual; stdcall; abstract;
    function  containsCD: Boolean; virtual; stdcall; abstract;
    function  isDoorOpen: Boolean; virtual; stdcall; abstract;
    procedure openDoor; virtual; stdcall; abstract;
    procedure closeDoor; virtual; stdcall; abstract;
  end;

  { TAdrMIDIStream }
  PAdrMIDIStream = ^TAdrMIDIStream;
  TAdrMIDIStream = class(TAdrRefCounted)
  public
    procedure play; virtual; stdcall; abstract;
    procedure stop; virtual; stdcall; abstract;
    procedure pause; virtual; stdcall; abstract;
    function  isPlaying: Boolean; virtual; stdcall; abstract;
    function  getLength: integer; virtual; stdcall; abstract;
    function  getPosition: integer; virtual; stdcall; abstract;
    procedure setPosition(aPositions: integer); virtual; stdcall; abstract;
    function  getRepeat: Boolean; virtual; stdcall; abstract;
    procedure setRepeat(aRepeat: Boolean); virtual; stdcall; abstract;
  end;

  { TAdrMIDIDevice }
  PAdrMIDIDevice = ^TAdrMIDIDevice;
  TAdrMIDIDevice = class(TAdrRefCounted)
  public
    function  GetName: PChar; virtual; stdcall; abstract;
    function  OpenStream(aFileName: PChar): TAdrMIDIStream; virtual; stdcall; abstract;
  end;


  
{ --- Audiere Routines -------------------------------------------------- }
{$IFNDEF DYNAMIC}

function  AdrCreateLoopPointSource       (aSource: TAdrSampleSource): TAdrLoopPointSource;(*cdecl = nil;*) stdcall = nil; 																																				external DLL_NAME name '_AdrCreateLoopPointSource@4';
function  AdrCreateMemoryFile            (aBuffer: Pointer; BufferSize: Integer): TAdrFile;(*cdecl = nil;*) stdcall = nil; 																																		external DLL_NAME name '_AdrCreateMemoryFile@8';
function  AdrCreatePinkNoise             : TAdrSampleSource;(*cdecl = nil;*) stdcall = nil; 																																																			external DLL_NAME name '_AdrCreatePinkNoise@0';
function  AdrCreateSampleBuffer          (aSamples: Pointer; aFrameCount, aChannelCount, aSampleRate: Integer; aSampleFormat: TAdrSampleFormat): TAdrSampleBuffer;(*cdecl = nil;*) stdcall = nil; external DLL_NAME name '_AdrCreateSampleBuffer@20';
function  AdrCreateSampleBufferFromSource(aSource: TAdrSampleSource): TAdrSampleBuffer;(*cdecl = nil;*) stdcall = nil; 																																						external DLL_NAME name '_AdrCreateSampleBufferFromSource@4';
function  AdrCreateSquareWave            (aFrequency: Double): TAdrSampleSource;(*cdecl = nil;*) stdcall = nil; 																																									external DLL_NAME name '_AdrCreateSquareWave@8';
function  AdrCreateTone                  (aFrequency: Double): TAdrSampleSource;(*cdecl = nil;*) stdcall = nil; 																																									external DLL_NAME name '_AdrCreateTone@8';
function  AdrCreateWhiteNoise            : TAdrSampleSource;(*cdecl = nil;*) stdcall = nil; 																																																			external DLL_NAME name '_AdrCreateWhiteNoise@0';
function  AdrEnumerateCDDevices          : PChar;(*cdecl = nil;*) stdcall = nil; 																																																									external DLL_NAME name '_AdrEnumerateCDDevices@0';
function  AdrGetSampleSize               (aFormat: TAdrSampleFormat): Integer;(*cdecl = nil;*) stdcall = nil; 																																										external DLL_NAME name '_AdrGetSampleSize@4';
function  AdrGetSupportedAudioDevices    : PChar;(*cdecl = nil;*) stdcall = nil; 																																																									external DLL_NAME name '_AdrGetSupportedAudioDevices@0';
function  AdrGetSupportedFileFormats     : PChar;(*cdecl = nil;*) stdcall = nil; 																																																									external DLL_NAME name '_AdrGetSupportedFileFormats@0';
function  AdrGetVersion                  : PChar;(*cdecl = nil;*) stdcall = nil; 																																																									external DLL_NAME name '_AdrGetVersion@0';
function  AdrOpenCDDevice                (aName: PChar): TAdrCDDevice;(*cdecl = nil;*) stdcall = nil; 																																														external DLL_NAME name '_AdrOpenCDDevice@4';
function  AdrOpenDevice                  (const aName: PChar; const aParams: PChar): TAdrAudioDevice;(*cdecl = nil;*) stdcall = nil; 																															external DLL_NAME name '_AdrOpenDevice@8';
function  AdrOpenFile                    (aName: PChar): TAdrFile;(*cdecl = nil;*) stdcall = nil; 																																														external DLL_NAME name '_AdrOpenFile@8';
function  AdrOpenMIDIDevice              (aName: PChar): TAdrMIDIDevice;(*cdecl = nil;*) stdcall = nil; 																																												  external DLL_NAME name '_AdrOpenMIDIDevice@4';
function  AdrOpenSampleSource            (const aFilename: PChar; aFileFormat: TAdrFileFormat): TAdrSampleSource;(*cdecl = nil;*) stdcall = nil; 																								  external DLL_NAME name '_AdrOpenSampleSource@8';
function  AdrOpenSampleSourceFromFile    (aFile: TAdrFile; aFileFormat: TAdrFileFormat): TAdrSampleSource;(*cdecl = nil;*) stdcall = nil; 																												external DLL_NAME name '_AdrOpenSampleSourceFromFile@8';
function  AdrOpenSound                   (aDevice: TAdrAudioDevice; aSource: TAdrSampleSource; aStreaming: LongBool): TAdrOutputStream;(*cdecl = nil;*) stdcall = nil; 														external DLL_NAME name '_AdrOpenSound@12';
function  AdrOpenSoundEffect             (aDevice: TAdrAudioDevice; aSource: TAdrSampleSource; aType: TAdrSoundEffectType): TAdrSoundEffect;(*cdecl = nil;*) stdcall = nil; 											external DLL_NAME name '_AdrOpenSoundEffect@12';						

{$ENDIF}

{$IFDEF DYNAMIC}

var
  AdrCreateLoopPointSource       : function(aSource: TAdrSampleSource): TAdrLoopPointSource; (*cdecl = nil;*) stdcall = nil;
  AdrCreateMemoryFile            : function(aBuffer: Pointer; BufferSize: Integer): TAdrFile;(* cdecl = nil;*) stdcall = nil;
  AdrCreatePinkNoise             : function: TAdrSampleSource;(* cdecl = nil;*) stdcall = nil;
  AdrCreateSampleBuffer          : function(aSamples: Pointer; aFrameCount, aChannelCount, aSampleRate: Integer; aSampleFormat: TAdrSampleFormat): TAdrSampleBuffer;(* cdecl = nil;*) stdcall = nil;
  AdrCreateSampleBufferFromSource: function(aSource: TAdrSampleSource): TAdrSampleBuffer;(* cdecl = nil;*) stdcall = nil;
  AdrCreateSquareWave            : function(aFrequency: Double): TAdrSampleSource;(* cdecl = nil;*) stdcall = nil;
  AdrCreateTone                  : function(aFrequency: Double): TAdrSampleSource;(* cdecl = nil;*) stdcall = nil;
  AdrCreateWhiteNoise            : function: TAdrSampleSource;(* cdecl = nil;*) stdcall = nil;
  AdrEnumerateCDDevices          : function: PChar;(* cdecl = nil;*) stdcall = nil;
  AdrGetSampleSize               : function(aFormat: TAdrSampleFormat): Integer;(* cdecl = nil;*) stdcall = nil;
  AdrGetSupportedAudioDevices    : function: PChar;(* cdecl = nil;*) stdcall = nil;
  AdrGetSupportedFileFormats     : function: PChar;(* cdecl = nil;*) stdcall = nil;
  AdrGetVersion                  : function: PChar;(* cdecl = nil;*) stdcall = nil;
  AdrOpenCDDevice                : function(aName: PChar): TAdrCDDevice;(* cdecl = nil;*) stdcall = nil;
  AdrOpenDevice                  : function(const aName: PChar; const aParams: PChar): TAdrAudioDevice;(* cdecl = nil;*) stdcall = nil;
  AdrOpenFile                    : function(aName: PChar): TAdrFile;(* cdecl = nil;*) stdcall = nil;
  AdrOpenMIDIDevice              : function(aName: PChar): TAdrMIDIDevice;(* cdecl = nil;*) stdcall = nil;
  AdrOpenSampleSource            : function(const aFilename: PChar; aFileFormat: TAdrFileFormat): TAdrSampleSource;(* cdecl = nil;*) stdcall = nil;
  AdrOpenSampleSourceFromFile    : function(aFile: TAdrFile; aFileFormat: TAdrFileFormat): TAdrSampleSource;(* cdecl = nil;*) stdcall = nil;
  AdrOpenSound                   : function(aDevice: TAdrAudioDevice; aSource: TAdrSampleSource; aStreaming: LongBool): TAdrOutputStream;(* cdecl = nil;*) stdcall = nil;
  AdrOpenSoundEffect             : function(aDevice: TAdrAudioDevice; aSource: TAdrSampleSource; aType: TAdrSoundEffectType): TAdrSoundEffect;(* cdecl = nil;*) stdcall = nil;

// Dynamic Loading/Unlocading DLL File
function AdrLoadDLL: Boolean; stdcall;
procedure AdrUnloadDLL; stdcall;

{$ENDIF}

implementation

{$IFDEF DYNAMIC}
uses
  Windows;

var
  AdrDLL: HMODULE = 0;

function AdrLoadDLL: Boolean;
begin
  Result := False;

  AdrDLL := LoadLibrary('audiere.dll');
  if(AdrDLL = 0) then
  begin
    Exit;
  end;

  @AdrCreateLoopPointSource        := GetProcAddress(AdrDLL, '_AdrCreateLoopPointSource@4');
  @AdrCreateMemoryFile             := GetProcAddress(AdrDLL, '_AdrCreateMemoryFile@8');
  @AdrCreatePinkNoise              := GetProcAddress(AdrDLL, '_AdrCreatePinkNoise@0');
  @AdrCreateSampleBuffer           := GetProcAddress(AdrDLL, '_AdrCreateSampleBuffer@20');
  @AdrCreateSampleBufferFromSource := GetProcAddress(AdrDLL, '_AdrCreateSampleBufferFromSource@4');
  @AdrCreateSquareWave             := GetProcAddress(AdrDLL, '_AdrCreateSquareWave@8');
  @AdrCreateTone                   := GetProcAddress(AdrDLL, '_AdrCreateTone@8');
  @AdrCreateWhiteNoise             := GetProcAddress(AdrDLL, '_AdrCreateWhiteNoise@0');
  @AdrEnumerateCDDevices           := GetProcAddress(AdrDLL, '_AdrEnumerateCDDevices@0');
  @AdrGetSampleSize                := GetProcAddress(AdrDLL, '_AdrGetSampleSize@4');
  @AdrGetSupportedAudioDevices     := GetProcAddress(AdrDLL, '_AdrGetSupportedAudioDevices@0');
  @AdrGetSupportedFileFormats      := GetProcAddress(AdrDLL, '_AdrGetSupportedFileFormats@0');
  @AdrGetVersion                   := GetProcAddress(AdrDLL, '_AdrGetVersion@0');
  @AdrOpenCDDevice                 := GetProcAddress(AdrDLL, '_AdrOpenCDDevice@4');
  @AdrOpenDevice                   := GetProcAddress(AdrDLL, '_AdrOpenDevice@8');
  @AdrOpenFile                     := GetProcAddress(AdrDLL, '_AdrOpenFile@8');
  @AdrOpenMIDIDevice               := GetProcAddress(AdrDLL, '_AdrOpenMIDIDevice@4');
  @AdrOpenSampleSource             := GetProcAddress(AdrDLL, '_AdrOpenSampleSource@8');
  @AdrOpenSampleSourceFromFile     := GetProcAddress(AdrDLL, '_AdrOpenSampleSourceFromFile@8');
  @AdrOpenSound                    := GetProcAddress(AdrDLL, '_AdrOpenSound@12');
  @AdrOpenSoundEffect              := GetProcAddress(AdrDLL, '_AdrOpenSoundEffect@12');

	if not Assigned(AdrCreateLoopPointSource       ) then Exit;
	if not Assigned(AdrCreateMemoryFile            ) then Exit;
	if not Assigned(AdrCreatePinkNoise             ) then Exit;
	if not Assigned(AdrCreateSampleBuffer          ) then Exit;
	if not Assigned(AdrCreateSampleBufferFromSource) then Exit;
	if not Assigned(AdrCreateSquareWave            ) then Exit;
	if not Assigned(AdrCreateTone                  ) then Exit;
	if not Assigned(AdrCreateWhiteNoise            ) then Exit;
	if not Assigned(AdrEnumerateCDDevices          ) then Exit;
	if not Assigned(AdrGetSampleSize               ) then Exit;
	if not Assigned(AdrGetSupportedAudioDevices    ) then Exit;
	if not Assigned(AdrGetSupportedFileFormats     ) then Exit;
	if not Assigned(AdrGetVersion                  ) then Exit;
	if not Assigned(AdrOpenCDDevice                ) then Exit;
	if not Assigned(AdrOpenDevice                  ) then Exit;
	if not Assigned(AdrOpenFile                    ) then Exit;
	if not Assigned(AdrOpenMIDIDevice              ) then Exit;
	if not Assigned(AdrOpenSampleSource            ) then Exit;
	if not Assigned(AdrOpenSampleSourceFromFile    ) then Exit;
	if not Assigned(AdrOpenSound                   ) then Exit;
	if not Assigned(AdrOpenSoundEffect             ) then Exit;

  Result := True;
end;

procedure AdrUnloadDLL;
begin
  if AdrDLL <> 0 then
  begin
    FreeLibrary(AdrDLL);
    AdrDLL := 0;
  end;
end;

initialization
begin
end;

finalization
begin
  AdrUnLoadDLL;
end;

{$ENDIF}

end.
