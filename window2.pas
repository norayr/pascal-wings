program window2;

{$mode objfpc}{$H+}

uses
  wings, ctypes, SysUtils;

const
  WIN_W = 560;
  WIN_H = 380;

var
  lbl: PWMLabel;
  tf: PWMTextField;
  memo: PWMText;
  ClickCount: cint = 0;

procedure CloseAll(self: PWMWidget; clientData: Pointer); cdecl;
begin
  WMDestroyWidget(self);
  Halt(0);
end;

procedure AppendLineToMemo(const Line: AnsiString);
begin
  // Freeze/Thaw makes updates appear immediately (and reduces flicker)
  WMFreezeText(memo);
  WMAppendTextStream(memo, PChar(Line + LineEnding));
  WMThawText(memo);
end;

procedure OnButtonClick(self: PWMWidget; clientData: Pointer); cdecl;
var
  p: PChar;
  s: AnsiString;
begin
  Inc(ClickCount);

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

  WMSetLabelText(lbl, PChar('Last: ' + s));
  AppendLineToMemo('[' + IntToStr(ClickCount) + '] ' + s);
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
  WMSetWindowTitle(win, PChar('FreePascal + WINGs (Text Area)'));
  WMResizeWidget(PWMWidget(win), WIN_W, WIN_H);
  WMSetWindowCloseAction(win, @CloseAll, nil);

  // Label (top)
  lbl := WMCreateLabel(PWMWidget(win));
  WMMoveWidget(PWMWidget(lbl), 10, 10);
  WMResizeWidget(PWMWidget(lbl), WIN_W - 20, 24);
  WMSetLabelText(lbl, PChar('Type -> click -> appended below'));

  // TextField (single-line)
  tf := WMCreateTextField(PWMWidget(win));
  WMMoveWidget(PWMWidget(tf), 10, 45);
  WMResizeWidget(PWMWidget(tf), WIN_W - 20, 26);
  WMSetTextFieldText(tf, PChar('hello wings'));

  // Button
  btn := WMCreateButton(PWMWidget(win), WBTMomentaryPush);
  WMMoveWidget(PWMWidget(btn), 10, 80);
  WMResizeWidget(PWMWidget(btn), 180, 30);
  WMSetButtonText(btn, PChar('Append to text area'));
  WMSetButtonAction(btn, @OnButtonClick, nil);

  // Text Area (multi-line "text view")
  //memo := WMCreateText(PWMWidget(win));
  memo := WMCreateTextForDocumentType(PWMWidget(win), nil, nil);

  WMMoveWidget(PWMWidget(memo), 10, 120);
  WMResizeWidget(PWMWidget(memo), WIN_W - 20, WIN_H - 130);

  // scrollbars + read-only (editable=1 for being able to type in it)
  WMSetTextHasVerticalScroller(memo, 1);
  WMSetTextHasHorizontalScroller(memo, 0);
  WMSetTextEditable(memo, 0);

  AppendLineToMemo('Ready. Click the button to append lines.');

  WMRealizeWidget(PWMWidget(win));
  WMMapWidget(PWMWidget(win));
  WMMapSubwidgets(PWMWidget(win));

  WMScreenMainLoop(scr);
end.

