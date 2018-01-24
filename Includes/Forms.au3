;Forms for ISN AutoIt Studio

;----------Programmeinstellungen----------
#include "..\Forms\ISN_Programmeinstellungen.isf" ;Hauptfenster für Programmeinstellungen

;Module der Programmeinstellungen
$config_tab = GUICtrlCreatetab(10,30,868,803)
guictrlsetstate($config_tab,$GUI_HIDE) ;Hide the tab ;)

;Allgemein
$config_Sheet1 = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Allgemein.isf"

;Automatische Updates
$config_Sheet2 = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Updates.isf"

;Skripteditor
$config_Sheet3 = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Skripteditor.isf"

;Skriptbaum
$config_Sheet_Skriptbaum = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Skriptbaum.isf"

;Darstellung
$config_Sheet_Darstellung = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Darstellung.isf"

;Farben
$config_Sheet_Farben = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Farbeinstellungen.isf"

;Hotkeys
$config_Sheet_Hotkeys = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Hotkeys.isf"

;Sprache
$config_Sheet_Sprache = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Sprache.isf"

;Automatisches Backup
$config_Sheet_Backup = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_AutoBackup.isf"

;Programmpfade
$config_Sheet_Programmpfade = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Programmpfade.isf"

;Skins
$config_Sheet_Skins = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Skins.isf"

;Plugins
$config_Sheet_Plugins = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Plugins.isf"

;Erweitert
$config_Sheet_Erweitert = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Erweitert.isf"

;Trophys
$config_Sheet_Trophys = GUICtrlCreateTabItem(_Get_langstr(125))
#include "..\Forms\ISN_Programmeinstellungen_Trophys.isf"

;Toolbar
$config_Sheet_toolbar = GUICtrlCreateTabItem(_Get_langstr(952))
#include "..\Forms\ISN_Programmeinstellungen_Toolbar.isf"

;Tidy
$config_Sheet_Tidy = GUICtrlCreateTabItem(_Get_langstr(327))
#include "..\Forms\ISN_Programmeinstellungen_Tidy.isf"

;Includes
$config_Sheet_Include = GUICtrlCreateTabItem(_Get_langstr(1074))
#include "..\Forms\ISN_Programmeinstellungen_Includes.isf"

;Automatische Speicherung
$config_Sheet_AutoSave = GUICtrlCreateTabItem(_Get_langstr(1085))
#include "..\Forms\ISN_Programmeinstellungen_AutoSpeicherung.isf"

;Dateitypen für Skript Editor
$config_Sheet_Skript_Editor_Dateitypen = GUICtrlCreateTabItem(_Get_langstr(1109))
#include "..\Forms\ISN_Programmeinstellungen_Dateitypen.isf"

;Ordnerpfade für api und proberties Dateien
$config_Sheet_API_Pfade = GUICtrlCreateTabItem(_Get_langstr(1121))
#include "..\Forms\ISN_Programmeinstellungen_APIs.isf"

;Makrosicherheit
$config_Sheet_Makrosicherheit = GUICtrlCreateTabItem(_Get_langstr(1150))
#include "..\Forms\ISN_Programmeinstellungen_Makrosicherheit.isf"

;AutoIt Pfade
$config_Sheet_Programmpfade_AutoItPfade = GUICtrlCreateTabItem(_Get_langstr(407))
#include "..\Forms\ISN_Programmeinstellungen_Autoitpfade.isf"

;Tools
$config_Sheet_Tools = GUICtrlCreateTabItem(_Get_langstr(607))
#include "..\Forms\ISN_Programmeinstellungen_Tools.isf"


GUICtrlCreateTabItem("") ;End Config GUI
;-----------------------------------------


;----------Projekteinstellungen----------
#include "..\Forms\ISN_Projekteinstellungen.isf"

;Default Page für Projekteinstellungen
GUICtrlSetState($projekteinstellungen_dummytab, $GUI_HIDE) ;Dummytab verstecken
GUICtrlSetState($Projekteinstellungen_eigenschaften_tab, $GUI_SHOW)
_GUICtrlTreeView_SelectItem ($projekteinstellungen_navigation,$projekteinstellungen_navigation_Eigenschaften)
_GUICtrlTreeView_Expand ($projekteinstellungen_navigation,$projekteinstellungen_kompilierungseinstellungen)
GUICtrlSetState($projekteinstellungen_dummytab,$GUI_HIDE)
;----------------------------------------



#include "..\Forms\ISN_Programmeinstellungen_Weitere_Farben.isf" ;Programmeinstellungen Weitere Farben
#include "..\Forms\ISN_Programmeinstellungen_Debug.isf" ;Makro Skript starten
#include "..\Forms\ISN_QuickView.isf" ;QuickView GUI
#include "..\Forms\ISN_Warte_auf_Aktion.isf" ;Warte auf Aktion (beim Start oder Beenden des ISNs)
#include "..\Forms\ISN_Datei_waehlen.isf" ;Choose File GUI
#include "..\Forms\ISN_Funktionsliste.isf" ;Func. List GUI
#include "..\Forms\ISN_Warnung.isf" ;Warnungen GUI
#include "..\Forms\ISN_Willkommen.isf" ;Willkommen GUI
#include "..\Forms\ISN_Neues_Projekt.isf" ;Neues Projekt
#include "..\Forms\ISN_Ladefenster.isf" ;Loading GUI
#include "..\Forms\ISN_Suchen_und_ersetzen.isf" ;Suchen und ersetzen
#include "..\Forms\ISN_Weitere_Dateien_Kompilieren.isf" ;Weitere Dateien Kompilieren
#include "..\Forms\ISN_Icon_auswahl.isf" ;Icon auswählen
#include "..\Forms\ISN_Ueber.isf" ;Über das ISN Fenster
#include "..\Forms\ISN_Startparameter.isf" ;Startparameter
#include "..\Forms\ISN_Neue_Datei_erstellen.isf" ;Neue Datei erstellen
#include "..\Forms\ISN_Projekt_wird_Kompiliert.isf" ;Projekt wird kompiliert
#include "..\Forms\ISN_Parameter_Editor.isf" ;Parameter Editor
#include "..\Forms\ISN_Makro_auswaehlen.isf" ;Marko auswählen GUI
#include "..\Forms\ISN_Makros.isf" ;Markoeditor
#include "..\Forms\ISN_Konfiguration_exportiern.isf" ;Konfiguration Exportieren
#include "..\Forms\ISN_Neues_Makro.isf" ;Neues Makro
#include "..\Forms\ISN_Makro_Trigger_auswaehlen.isf" ;Makro Trigger wählen
#include "..\Forms\ISN_Makro_Aktion_auswaehlen.isf" ;Makro Aktion wählen
#include "..\Forms\ISN_Makro_Statusbar.isf" ;Makro Statusbar
#include "..\Forms\ISN_In_Ordner_nach_Text_Suchen.isf" ;Text in ordnern suchen
#include "..\Forms\ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft.isf" ;Text in ordnern suchen (Suche läuft gui)
#include "..\Forms\ISN_Makro_Sleep.isf" ;Makro Sleep
#include "..\Forms\ISN_Makro_Execute.isf" ;Makro Execute
#include "..\Forms\ISN_Makro_Dateioperation.isf" ;Makro Dateioperation
#include "..\Forms\ISN_Makro_Weitere_Pfade.isf" ;Weitere Pfade
#include "..\Forms\ISN_Makro_Datei_ausfuehren.isf" ;Makro Datei ausführen
#include "..\Forms\ISN_Makro_Kompilieren.isf" ;Makro Kompilieren
#include "..\Forms\ISN_Makro_wird_kompiliert.isf" ;Makro wird Kompilieren
#include "..\Forms\ISN_Makro_Makroslot_Icon.isf" ;Makroslot Icon
#include "..\Forms\ISN_MsgBox_Generator.isf" ;MsgBox generator
#include "..\Forms\ISN_Makro_MsgBox_Generator.isf" ;Makro MsgBox generator
#include "..\Forms\ISN_Makro_Parameter.isf" ;Makro Parametereinstellungen
#include "..\Forms\ISN_Makro_Logeintrag_hinzufuegen.isf" ;Makro Logeintrag hinzufügen
#include "..\Forms\ISN_Trophaeen.isf" ;Trophäen
#include "..\Forms\ISN_Farbtoolbox.isf" ;Farbtoolbox
#include "..\Forms\ISN_Detailinfos_zu_aktuellem_Wort.isf" ;Info zu akteullem Wort (Farbwert)
#include "..\Forms\ISN_Mini_Farbpicker.isf" ;Mini Farbpicker
#include "..\Forms\ISN_Einstellungen_werden_gespeichert.isf" ;Einstellungen werden gespeichert
#include "..\Forms\ISN_Hotkey_bearbeiten.isf" ;Hotkey Bearbeiten
#include "..\Forms\ISN_Hotkey_Warte_auf_Tastendruck.isf" ;Hotkey Warte auf Tastendruck
#include "..\Forms\ISN_Projektverwaltung.isf" ;Projektverwaltung
#include "..\Forms\ISN_Codeausschnitt.isf" ;Codeausschnitt GUI
#include "..\Forms\ISN_Warte_auf_Wrapper.isf" ;Warte auf Wrapper
#include "..\Forms\ISN_Warte_auf_Makro.isf" ;Warte auf Makro
#include "..\Forms\ISN_Projektverwaltung_Neue_Vorlage.isf" ;Neue Vorlage
#include "..\Forms\ISN_Bitwise_Operations_GUI.isf" ;Bitwise Operations GUI
#include "..\Forms\ISN_Datei_loeschen.isf" ;Datei löschen
#include "..\Forms\ISN_Aenderungsprotokolle_Neuer_Eintrag.isf" ;Changelog neuer Eintrag
#include "..\Forms\ISN_Makro_Version_Aendern.isf" ;Makro Projektversion ändern
#include "..\Forms\ISN_Makro_Skript_starten.isf" ;Makro Skript starten
#include "..\Forms\ISN_Aenderungsprotokolle.isf" ;Änderungsprotokolle Manager
#include "..\Forms\ISN_Aenderungsprotokolle_Bericht.isf" ;Änderungsprotokolle Bericht generieren
#include "..\Forms\ISN_Aenderungsprotokolle_Bericht_Hilfe.isf" ;Änderungsprotokolle Bericht Hilfe
#include "..\Forms\ISN_Skriptbaum_Filter.isf" ;Skriptbaum Filter
#include "..\Forms\ISN_Makro_Codeausschnitt.isf" ;Makro Codeausschnitt
#include "..\Forms\ISN_Warte_auf_Plugin.isf" ;Warte auf Plugin
#include "..\Forms\ISN_PELock_Obfuscator.isf" ;PELock Obfuscator
#include "..\Forms\ISN_PELock_Obfuscator_laeuft.isf" ;PELock Obfuscator Vorgang läuft
#include "..\Forms\ISN_ToDoListe_Manager.isf" ;ToDo Liste Manager
#include "..\Forms\ISN_ToDoListe_Kategorien_verwalten.isf" ;Kategorien der ToDo Liste verwalten
#include "..\Forms\ISN_ToDoListe_Neue_Kategorie.isf" ;Neue Kategorie erstellen/bearbeiten
#include "..\Forms\ISN_ToDoListe_Kategorie_loeschen.isf" ;Kategorie löschen
#include "..\Forms\ISN_ToDoListe_Neuer_Eintrag.isf" ;Neue Aufgabe erstellen
#include "..\Forms\ISN_Bitte_Warten.isf" ;Allgemeine "Bitte Warten" GUI
#include "..\Forms\ISN_Druckvorschau.isf" ;Druckvorschau GUI

;Immer zum Schluss (wegen ActiveX Object)
#include "..\Forms\ISN_Bugtracker.isf" ;Bugtracker GUI