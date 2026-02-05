program window1;

{$mode objfpc}{$H+}

uses
  wings, ctypes, SysUtils;

const
  WIN_W = 420;
  WIN_H = 160;

var
  ClickCount: cint = 0;
  lbl: PWMLabel;
  tf: PWMTextField;

procedure CloseAll(self: PWMWidget; clientData: Pointer); cdecl;
begin
  WMDestroyWidget(self);
  Halt(0);
end;

procedure OnButtonClick(self: PWMWidget; clientData: Pointer); cdecl;
var
  p: PChar;
  s: AnsiString;
begin
  Inc(ClickCount);

  // WMGetTextFieldText returns a C string that should be freed with wfree()
  p := WMGetTextFieldText(tf);
  try
    if p <> nil then
      s := AnsiString(p)
    else
      s := '';
  finally
    if p <> nil then
      wfree(p);
  end;

  WMSetLabelText(lbl, PChar('[' + IntToStr(ClickCount) + '] ' + s));
end;

var
  scr: PWMScreen;
  win: PWMWindow;
  btn: PWMButton;

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
    WriteLn('WMOpenScreen failed (no DISPLAY / X11?)');
    Halt(1);
  end;

  win := WMCreateWindow(scr, PChar('fp-wings'));
  WMSetWindowTitle(win, PChar('FreePascal + WINGs'));
  WMResizeWidget(PWMWidget(win), WIN_W, WIN_H);
  WMSetWindowCloseAction(win, @CloseAll, nil);

  // Label
  lbl := WMCreateLabel(PWMWidget(win));
  WMMoveWidget(PWMWidget(lbl), 10, 10);
  WMResizeWidget(PWMWidget(lbl), WIN_W - 20, 24);
  WMSetLabelText(lbl, PChar('Type something, then click the button'));

  // TextField
  tf := WMCreateTextField(PWMWidget(win));
  WMMoveWidget(PWMWidget(tf), 10, 45);
  WMResizeWidget(PWMWidget(tf), WIN_W - 20, 26);
  WMSetTextFieldText(tf, PChar('hello wings'));

  // Button
  btn := WMCreateButton(PWMWidget(win), WBTMomentaryPush);
  WMMoveWidget(PWMWidget(btn), 10, 85);
  WMResizeWidget(PWMWidget(btn), 160, 30);
  WMSetButtonText(btn, PChar('Copy to label'));
  WMSetButtonAction(btn, @OnButtonClick, nil);

  WMRealizeWidget(PWMWidget(win));
  WMMapWidget(PWMWidget(win));
  WMMapSubwidgets(PWMWidget(win));

  WMScreenMainLoop(scr);
end.
