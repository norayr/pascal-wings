unit wings;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

type
  // Opaque pointers (C structs as pointers)
  PWMScreen = Pointer;
  PWMWidget = Pointer;
  PWMWindow = Pointer;
  PWMButton = Pointer;
  PWMLabel  = Pointer;
  PWMTextField = Pointer;

  // TextView / multi-line widget in WINGs is WMText
  PWMText = Pointer;

  // C callback type: void (*WMAction)(WMWidget *self, void *clientData)
  TWMAction = procedure(self: PWMWidget; clientData: Pointer); cdecl;

const
  // WMButtonType (enum in C). WBTMomentaryPush is the normal push button.
  WBTMomentaryPush = 0;

procedure WMInitializeApplication(const appName: PChar; argc: Pcint; argv: PPChar); cdecl; external 'WINGs';

function WMOpenScreen(const displayName: PChar): PWMScreen; cdecl; external 'WINGs';
function WMCreateWindow(screen: PWMScreen; const name: PChar): PWMWindow; cdecl; external 'WINGs';

procedure WMSetWindowTitle(win: PWMWindow; const title: PChar); cdecl; external 'WINGs';
procedure WMSetWindowCloseAction(win: PWMWindow; action: TWMAction; clientData: Pointer); cdecl; external 'WINGs';

procedure WMMoveWidget(w: PWMWidget; x, y: cint); cdecl; external 'WINGs';
procedure WMResizeWidget(w: PWMWidget; width, height: cuint); cdecl; external 'WINGs';
procedure WMRealizeWidget(w: PWMWidget); cdecl; external 'WINGs';
procedure WMMapWidget(w: PWMWidget); cdecl; external 'WINGs';
procedure WMMapSubwidgets(w: PWMWidget); cdecl; external 'WINGs';

procedure WMDestroyWidget(widget: PWMWidget); cdecl; external 'WINGs';
procedure WMScreenMainLoop(scr: PWMScreen); cdecl; external 'WINGs';

// --- Label ---
function WMCreateLabel(parent: PWMWidget): PWMLabel; cdecl; external 'WINGs';
procedure WMSetLabelText(l: PWMLabel; const text: PChar); cdecl; external 'WINGs';

// --- Button ---
function WMCreateButton(parent: PWMWidget; buttonType: cint): PWMButton; cdecl; external 'WINGs';
procedure WMSetButtonText(b: PWMButton; const text: PChar); cdecl; external 'WINGs';
procedure WMSetButtonAction(b: PWMButton; action: TWMAction; clientData: Pointer); cdecl; external 'WINGs';

// --- TextField (single-line edit) ---
function WMCreateTextField(parent: PWMWidget): PWMTextField; cdecl; external 'WINGs';
procedure WMSetTextFieldText(t: PWMTextField; const text: PChar); cdecl; external 'WINGs';
function WMGetTextFieldText(t: PWMTextField): PChar; cdecl; external 'WINGs';

// --- Text (multi-line "text view") ---
//function WMCreateText(parent: PWMWidget): PWMText; cdecl; external 'WINGs';
function WMCreateTextForDocumentType(parent: PWMWidget; parser, writer: Pointer): PWMText; cdecl; external 'WINGs';

procedure WMAppendTextStream(t: PWMText; const text: PChar); cdecl; external 'WINGs';
procedure WMFreezeText(t: PWMText); cdecl; external 'WINGs';
procedure WMThawText(t: PWMText); cdecl; external 'WINGs';
procedure WMSetTextHasVerticalScroller(t: PWMText; shouldHave: cint); cdecl; external 'WINGs';
procedure WMSetTextHasHorizontalScroller(t: PWMText; shouldHave: cint); cdecl; external 'WINGs';
procedure WMSetTextEditable(t: PWMText; editable: cint); cdecl; external 'WINGs';

// Free strings returned by some WINGs calls
// (WMGetTextFieldText returns something you should free)
procedure wfree(ptr: Pointer); cdecl; external 'WUtil';

implementation
end.
