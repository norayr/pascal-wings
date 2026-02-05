program window3;

{$mode objfpc}{$H+}

uses
  wings, ctypes, SysUtils;

const
  WIN_W = 600;
  WIN_H = 460;

var
  scr: PWMScreen;
  win: PWMWindow;

  textLog: PWMText;
  textInput: PWMText;
  btnSend: PWMButton;
  lbl: PWMLabel;

procedure CloseAll(self: PWMWidget; clientData: Pointer); cdecl;
begin
  WMDestroyWidget(self);
  Halt(0);
end;

procedure AppendLineToLog(const s: AnsiString);
begin
  WMFreezeText(textLog);
  WMAppendTextStream(textLog, PChar(s));
  WMAppendTextStream(textLog, PChar(LineEnding));
  WMThawText(textLog);
end;

procedure OnSend(self: PWMWidget; clientData: Pointer); cdecl;
var
  p: PChar;
  msg: AnsiString;
begin
  p := WMGetTextStream(textInput);
  if p = nil then Exit;

  try
    msg := AnsiString(p);
  finally
    wfree(p);
  end;

  // ignore empty
  if Trim(msg) = '' then Exit;

  AppendLineToLog('you: ' + msg);
  WMSetLabelText(lbl, PChar('Last sent: ' + msg));

  // NOTE: we cant find exported "WMSetTextStream", so we dont clear input for now.
end;

var
  argc: cint;
  argv: PPChar;
  argvMem: array[0..1] of PChar;
begin
  argvMem[0] := PChar(ParamStr(0));
  argvMem[1] := nil;
  argv := @argvMem[0];
  argc := 1;

  WMInitializeApplication(PChar('fp-wings'), @argc, argv);

  scr := WMOpenScreen(nil);
  if scr = nil then
  begin
    WriteLn('WMOpenScreen failed');
    Halt(1);
  end;

  win := WMCreateWindow(scr, PChar('window3'));
  WMSetWindowTitle(win, PChar('WINGs chat-ish demo'));
  WMResizeWidget(PWMWidget(win), WIN_W, WIN_H);
  WMSetWindowCloseAction(win, @CloseAll, nil);

  // Status label
  lbl := WMCreateLabel(PWMWidget(win));
  WMMoveWidget(PWMWidget(lbl), 10, 10);
  WMResizeWidget(PWMWidget(lbl), WIN_W - 20, 22);
  WMSetLabelText(lbl, PChar('Type below, click Send'));

  // Top: log
  textLog := WMCreateTextForDocumentType(PWMWidget(win), nil, nil);
  WMMoveWidget(PWMWidget(textLog), 10, 40);
  WMResizeWidget(PWMWidget(textLog), WIN_W - 20, WIN_H - 150);
  WMSetTextEditableB(textLog, False);
  WMSetTextHasVerticalScrollerB(textLog, True);
  WMSetTextHasHorizontalScrollerB(textLog, False);

  // Bottom: input
  textInput := WMCreateTextForDocumentType(PWMWidget(win), nil, nil);
  WMMoveWidget(PWMWidget(textInput), 10, WIN_H - 100);
  WMResizeWidget(PWMWidget(textInput), WIN_W - 120, 60);
  WMSetTextEditableB(textInput, True);
  WMSetTextHasVerticalScrollerB(textInput, False);
  WMSetTextHasHorizontalScrollerB(textInput, False);
  WMSetTextIgnoresNewlineB(textInput, True);

  // Send button
  btnSend := WMCreateButton(PWMWidget(win), WBTMomentaryPush);
  WMMoveWidget(PWMWidget(btnSend), WIN_W - 95, WIN_H - 95);
  WMResizeWidget(PWMWidget(btnSend), 85, 30);
  WMSetButtonText(btnSend, PChar('Send'));
  WMSetButtonAction(btnSend, @OnSend, nil);

  AppendLineToLog('ready.');

  WMRealizeWidget(PWMWidget(win));
  WMMapWidget(PWMWidget(win));
  WMMapSubwidgets(PWMWidget(win));

  WMScreenMainLoop(scr);
end.

