unit wings;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

type
  // Opaque pointers (WINGs is C; treat structs as pointers)
  PWMScreen = Pointer;
  PWMWidget = Pointer;
  PWMWindow = Pointer;
  PWMButton = Pointer;
  PWMLabel  = Pointer;

  // C callback type: void (*WMAction)(WMWidget *self, void *clientData)
  TWMAction = procedure(self: PWMWidget; clientData: Pointer); cdecl;

const
  // WMButtonType (enum in C). WBTMomentaryPush is the "normal" push button.
  // In WINGs headers it's the first enum item, so 0.
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

implementation
end.
