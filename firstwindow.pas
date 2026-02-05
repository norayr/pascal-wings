program firstwindow;

{$mode objfpc}{$H+}

uses
  wings, ctypes, SysUtils;

const
  WIN_W = 360;
  WIN_H = 140;

var
  ClickCount: cint = 0;

procedure CloseAll(self: PWMWidget; clientData: Pointer); cdecl;
begin
  WMDestroyWidget(self);
  Halt(0);
end;

procedure OnButtonClick(self: PWMWidget; clientData: Pointer); cdecl;
var
  lbl: PWMLabel;
  s: AnsiString;
begin
  lbl := PWMLabel(clientData);
  Inc(ClickCount);
  s := 'Clicked ' + IntToStr(ClickCount) + ' time(s)';
  WMSetLabelText(lbl, PChar(s));
end;

var
  scr: PWMScreen;
  win: PWMWindow;
  btn: PWMButton;
  lbl: PWMLabel;

  argc: cint;
  argv: PPChar;
  argvMem: array[0..1] of PChar;
begin
  // Build a tiny argv: argv[0]=program name, argv[1]=nil
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

  // --- Label ---
  lbl := WMCreateLabel(PWMWidget(win));
  WMMoveWidget(PWMWidget(lbl), 10, 10);
  WMResizeWidget(PWMWidget(lbl), WIN_W - 20, 24);
  WMSetLabelText(lbl, PChar('Press the button'));

  // --- Button ---
  btn := WMCreateButton(PWMWidget(win), WBTMomentaryPush);
  WMMoveWidget(PWMWidget(btn), 10, 50);
  WMResizeWidget(PWMWidget(btn), 160, 30);
  WMSetButtonText(btn, PChar('Click me'));
  WMSetButtonAction(btn, @OnButtonClick, Pointer(lbl));

  // show everything
  WMRealizeWidget(PWMWidget(win));
  WMMapWidget(PWMWidget(win));
  WMMapSubwidgets(PWMWidget(win));

  WMScreenMainLoop(scr);
end.
