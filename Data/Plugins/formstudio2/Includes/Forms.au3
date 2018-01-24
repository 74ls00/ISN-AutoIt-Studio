
;----------------------------------------------
;FORMS
;----------------------------------------------

#include "..\Forms\Formstudio_GUI_Einstellungen.isf" ;GUI Bearbeiten GUI
#include "..\Forms\Formstudio_Programmeinstellungen.isf" ;GUI Bearbeiten GUI
#include "..\Forms\Formstudio_Extracode.isf" ;Code anzeigen gui
#include "..\Forms\Formstudio_Text_bearbeiten.isf" ;Text bearbeiten GUI
#include "..\Forms\Formstudio_Reihenfolge_der_Controls.isf" ;Reihenfolge der Controls GUI
#include "..\Forms\Formstudio_Tabseite_umbenennen.isf" ;Tabseite umbenennen
#include "..\Forms\Formstudio_Tabseite_Handle_festlegen.isf" ;Tabseite Handle festlegen
#include "..\Forms\Formstudio_Listview_Spalteneditor.isf" ;Spalteneditor
#include "..\Forms\Formstudio_Menueditor.isf" ;Menü Editor
#include "..\Forms\Formstudio_Menueditor_Vorschau.isf" ;Menü Editor Vorschau GUI
#include "..\Forms\Formstudio_Menueditor_fuer_alle_uebernehmen.isf" ;Menü Editor Für alle Übernehmen GUI
#include "..\Forms\Formstudio_Control_Resizing.isf" ;Control Resizing

;Control Editor
if @DesktopHeight < ($hoehe_des_Controleditors+100) then
   $hoehe_des_Controleditors = 450*$DPI
   $breite_des_Controleditors = 350*$DPI
EndIf
#include "..\Forms\Formstudio_ControlEditor.isf" ;Control Editor (Hauptfenster)
If $ISN_Dark_Mode = "true" Then GUICtrlSetImage($BGimage_controleditor, @ScriptDir & "\data\side2_dark.jpg")
#include "..\Forms\Formstudio_ControlEditor_Allgemein.isf" ;Control Editor (Allgemein)
#include "..\Forms\Formstudio_ControlEditor_Aussehen.isf" ;Control Editor (Aussehen)
#include "..\Forms\Formstudio_ControlEditor_Style.isf" ;Control Editor (Style)
#include "..\Forms\Formstudio_ControlEditor_ExStyle.isf" ;Control Editor (ExStyle)
#include "..\Forms\Formstudio_ControlEditor_State.isf" ;Control Editor (State)
#include "..\Forms\Formstudio_ControlEditor_ListeallerControls.isf" ;Control Editor (Liste aller Controls)
if $hoehe_des_Controleditors = 450*$DPI then _GUIScrollbars_Generate($Formstudio_controleditor_GUI, 0, 707*$DPI)
_WinAPI_SetParent($Formstudio_controleditor_GUI,$StudioFenster_inside)


