#include-once
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

_GDIPlus_Startup()
OnAutoItExitRegister("_MG_Graph_Herunterfahren")


; #INDEX# ================================================================================================================================================
; Title 			: MultiGraph
; AutoIt Version 	: 3.3.8.0
; UDF Version	 	: 1.0.0.3
; Date of creation 	: 01.02.2013 (DD.MM.YYYY)
; UDF-Language		: German
; Description 		: create a dynamic line graph
; Author			: SBond
; Dll(s) 			: ---
; ========================================================================================================================================================



; #AUTHOR INFORMATION# ===================================================================================================================================
; Author	: SBond
; E-Mail	: sbond.softwareinfo@gmail.com
; Language	: German  (Deutsch)
; Country	: Germany (Deutschland)
; Webside	: http://www.livesystem-pro.de
; ========================================================================================================================================================



; #UPDATES# ==============================================================================================================================================
;
; 16.03.2013	-	1.0.0.3 - behoben: 			die Hintergrundfarbe der Achsenbeschriftung wurde nicht komplett übernommen
; 07.03.2013	-	1.0.0.2 - neue Funktion: 	_MG_Graph_optionen_position () -> verschiebt einen Graphen in der GUI oder passt die Größe neu an
; 06.03.2013	-	1.0.0.1 - behoben: 			geplottete Werte an der ersten Position des Graphen waren fehlerhaft
; 01.02.2013	-	1.0.0.0	- erste Veröffentlichung
;
; ========================================================================================================================================================



; #HINTS AND INFORMATION# ================================================================================================================================
;
; Allgemeine Informationen über diese UDF
; ----------------------------------------------------------------------
;
; Dies ist meine erste UDF. Sie entspricht nicht ganz dem UDF coding standard, aber ich hoffe mal dass ihr mit der Dokumentation klar kommt.
; Mit dieser UDF könnt ihr einen oder meherer unabhängige Liniendiagramme (bzw. Graphen) erzeugen.
;
; Es wäre eventuell wichtig zu wissen, dass der absolute Nullpunkt in der linken unteren Ecke des Graphen ist. Eine vier Quadranten-Ansicht, ist
; zwar möglich, aber noch relativ aufwändig (die Berechnungen müssen dann selber gemacht werden).
;
; In der Grundeinstellung, können 10 Graphen mit jeweils 10 Kanälen betrieben werden. Wer mehr benötigt, kann dies einfach in den Variablen einstellen.
; Die Nummerierung der Graphen und der Kanäle beginnt bei 1 und nicht bei 0. Dies ist wichtig, da auf dem Index 0 die Einstellungen der Graphen gespeichert werden.
;
; Zu den Begriffen.....   Es könnte eventuell etwas verwirren, aber wenn hier von "Plotten" geschrieben wird, z.B. "die Werte in den Graphen plotten", so meine ich nicht
; dass die Werte in der GUI dargestellt werden. Die Werte werden in den Buffer geplottet. Erst wenn alle Punkte eingezeichnet sind oder die Funktion "_MG_Graph_updaten"
; genutzt wird, wird die Darstellung in der GUI aktualisiert.
;
;
;
;
;
; kurze Aufschlüsselung der Abkürzungen in den Variablen
; ----------------------------------------------------------------------
;
; $MG_aGraph [ Graphnummer ][ Kanalnummer ][ Kanaleinstellungen ]         wobei in der Kanalnummer 0 die ganzen Einstellungen des Graphen hinterlegt sind
;
; $MG_a_			-> MultiGraph allgemeine Einstellungen
; $MG_k_			-> MultiGraph Kanal-Einstellungen
;
; i					-> integer
; f					-> float
; h					-> handle
; b					-> boolean
; a					-> array
; s					-> string
; v					-> variable  (hier meistens ein Hex-Wert)
;
; ========================================================================================================================================================



; #CURRENT# ==============================================================================================================================================
;
; Function								Parameter
; ----------------------------------------------------------------------
; _MG_Graph_erstellen 					($iGraph, $hGUI, $iX_Pos, $iY_Pos, $iBreite, $iHoehe)
; _MG_Graph_optionen_position 			($iGraph, $hGUI, $iX_Pos, $iY_Pos, $iBreite, $iHoehe)
; _MG_Graph_optionen_allgemein 			($iGraph, $iAufloesung, $iY_min, $iY_max, $vHintergrundfarbe, $iRendermodus)
; _MG_Graph_optionen_Rahmen 			($iGraph, $bAnzeigen, $vRahmenfarbe, $iRahmenbreite)
; _MG_Graph_optionen_Hauptgitterlinien 	($iGraph, $bHauptgitter_aktiviert, $iHauptgitter_abstand_X, $iHauptgitter_abstand_Y, $iHauptgitter_breite, $vHauptgitter_farbe, $iHauptgitter_Transparenz)
; _MG_Graph_optionen_Hilfsgitterlinien 	($iGraph, $bHilfsgitter_aktiviert, $iHilfsgitter_abstand_X, $iHilfsgitter_abstand_Y, $iHilfsgitter_breite, $vHilfsgitter_farbe, $iHilfsgitter_Transparenz)
; _MG_Graph_optionen_Plottmodus 		($iGraph, $iPlottmodus, $iPlottfrequenz, $iClearmodus, $bInterpolation)
; _MG_Kanal_optionen 					($iGraph, $iKanal, $bKanal_aktivieren, $iLinien_Breite, $vLinien_Farbe, $iLinien_Transparenz)
; _MG_Graph_initialisieren 				($iGraph)
; _MG_Wert_setzen 						($iGraph, $iKanal, $fWert)
; _MG_Graph_updaten 					($iGraph)
; _MG_Graph_clear 						($iGraph)
; _MG_Graph_Achse_links 				($iGraph, $bAchse_anzeigen, $fMin_Wert, $fMax_Wert, $iNachkommastellen, $sEinheit, $vSchriftfarbe, $vHintergrundfarbe, $fSchriftgroesse, $iLabelbreite, $fIntervall)
; _MG_Graph_Achse_rechts 				($iGraph, $bAchse_anzeigen, $fMin_Wert, $fMax_Wert, $iNachkommastellen, $sEinheit, $vSchriftfarbe, $vHintergrundfarbe, $fSchriftgroesse, $iLabelbreite, $fIntervall)
; _MG_Graph_Achse_unten 				($iGraph, $bAchse_anzeigen, $fMin_Wert, $fMax_Wert, $iNachkommastellen, $sEinheit, $vSchriftfarbe, $vHintergrundfarbe, $fSchriftgroesse, $iLabelbreite, $fIntervall)
; _MG_Graph_Achse_unten_update 			($iGraph, $fMin_Wert, $fMax_Wert, $iNachkommastellen, $sEinheit)
; _MG_Graph_Achse_links_update 			($iGraph, $fMin_Wert, $fMax_Wert, $iNachkommastellen, $sEinheit)
; _MG_Graph_Achse_rechts_update 		($iGraph, $fMin_Wert, $fMax_Wert, $iNachkommastellen, $sEinheit)
; _MG_Graph_plotten 					($iGraph)
; _MG_Graph_entfernen					($iGraph)
;
; ========================================================================================================================================================



; #FUNCTION-DESCRIPTION# ==============================================================================================================================================
;
; Function								kurze Beschreibung
; ----------------------------------------------------------------------
; _MG_Graph_erstellen 					erstellt einen Graphen
; _MG_Graph_optionen_position			verschiebt einen Graphen in der GUI oder passt die Größe neu an
; _MG_Graph_optionen_allgemein 			ändert die allgemeinen Einstellungen des Graphen
; _MG_Graph_optionen_Rahmen 			ändert die Rahmen-Einstellungen des Graphen
; _MG_Graph_optionen_Hauptgitterlinien 	ändert die Einstellungen der Hauptgitterlinien im Graphen
; _MG_Graph_optionen_Hilfsgitterlinien 	ändert die Einstellungen der Hilfsgitterlinien im Graphen
; _MG_Graph_optionen_Plottmodus 		ändert die Plott-Einstellungen des Graphen
; _MG_Kanal_optionen 					ändert die Kanal-Einstellungen des Graphen
; _MG_Graph_initialisieren 				plottet den Graphen erstmalig in der GUI
; _MG_Wert_setzen 						legt den neuen Wert für den nächsten Plottvorgang fest
; _MG_Graph_updaten						zeichnet den Graph in die GUI bzw. aktualisiert die Darstellung
; _MG_Graph_clear						löscht die aktuell geplotteten Werte
; _MG_Graph_Achse_links					erzeugt eine Achsbeschriftung auf der linken Seite (Y-Achse), die sich an den horizontalen Hauptgitterlinien richtet
; _MG_Graph_Achse_rechts				erzeugt eine Achsbeschriftung auf der rechten Seite (Y-Achse), die sich an den horizontalen Hauptgitterlinien richtet
; _MG_Graph_Achse_unten					erzeugt eine Achsbeschriftung auf der unteren Seite (X-Achse), die sich an den vertikalen Hauptgitterlinien richtet
; _MG_Graph_Achse_unten_update			aktualisiert die Achsbeschriftung auf der unteren Seite (X-Achse)
; _MG_Graph_Achse_links_update			aktualisiert die Achsbeschriftung auf der linken Seite (Y-Achse)
; _MG_Graph_Achse_rechts_update			aktualisiert die Achsbeschriftung auf der rechten Seite (Y-Achse)
; _MG_Graph_plotten						plottet die neuen Werte in den Graphen und aktualisiert ggf. die Darstellung in der GUI (je nach Einstellungen)
; _MG_Graph_entfernen					löscht den Graphen aus der GUI
;
; ========================================================================================================================================================



; #INTERNAL_USE_ONLY# ====================================================================================================================================
;
; Function								Parameter
; ----------------------------------------------------------------------
; _MG_Graph_Hauptgitterlinien_plotten 	($iGraph, $iModus)
; _MG_Graph_Hilfsgitterlinien_plotten 	($iGraph, $iModus)
; _MG_Graph_Herunterfahren 				()
;
; ========================================================================================================================================================



; #VARIABLES# ============================================================================================================================================
Global Enum		$MG_a_bGraph_aktiviert, _									; enthält die Information, ob dieser Graph verwendet wird
				$MG_a_hGUI, _												; das GUI-handle, auf dem der Graph gezeichnet werden soll
				$MG_a_iX_Pos, _												; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
				$MG_a_iY_Pos, _												; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
				$MG_a_iBreite, _											; die Breite des Graphen
				$MG_a_iHoehe, _												; die Höhe des Graphen
				$MG_a_hGraphic, _											; handle zum Grafik-Objekt
				$MG_a_hBitmap, _											; handle zum Grafik-Kontext
				$MG_a_hBuffer, _											; handle zum Grafik-Buffer
				$MG_a_iAufloesung, _										; Auflösung bzw. horizontale Skalierung: Ist die Anzahl der Werte, die dargestellt werden. (Wenn die Auflösung gleich die Breite des Graphen ist, dann wird pro Pixel ein Wert dargestellt.)
				$MG_a_fInkrement_groesse, _									; der horizontale Pixelabstand zwischen zwei dargestellten Werten
				$MG_a_iVerschiebung, _										; Anzahl der horizontalen Pixel, die im "Scroll-Modus" für jede neue Darstellung verschoben werden müssen.
				$MG_a_iY_min, _												; der kleinste Wert, der im Graph dargestellt werden kann
				$MG_a_iY_max, _												; der größte Wert, der im Graph dargestellt werden kann
				$MG_a_iWertebereich, _										; Wertebereich des Graphen (Y-Achse)
				$MG_a_fWertaufloesung, _									; Auflösung bzw. vertikale Skalierung: kleinster vertikaler Pixelabstand zwischen 2 Werten
				$MG_a_vHintergrundfarbe, _									; die Hintergrundfarbe des Graphen
				$MG_a_bRahmen, _											; aktiviert/deaktiviert den Rahmen für den Graphen
				$MG_a_vRahmenfarbe, _										; die Rahmenfarbe
				$MG_a_iRahmenbreite, _										; die Breite des Rahmens. (der Zeichenbereich des Graphen wird dabei nicht verschoben oder verändert)
				$MG_a_hRahmen, _											; handle des Rahmens
				$MG_a_bHauptgitter_aktiviert, _								; aktiviert/deaktiviert die Hauptgitterlinien
				$MG_a_iHauptgitter_abstand_X, _								; der horizontale Abstand zwischen den Hauptgitterlinien
				$MG_a_iHauptgitter_abstand_Y, _								; der vertikale Abstand zwischen den Hauptgitterlinien
				$MG_a_vHauptgitter_farbe, _									; die verwendete Farbe der Hauptgitterlinien
				$MG_a_iHauptgitter_breite, _								; die Linienbreite
				$MG_a_iHauptgitter_Transparenz, _							; die verwendete Transparenz der Hauptgitterlinien (0 bis 255) -> 0: keine Transparenz; 255: unsichtbar
				$MG_a_hHauptgitter_Pen, _									; handle zum "Zeichen-Stift"
				$MG_a_iHauptgitter_Merker, _								; ein Merker zum Zwischenspeichern von Positionsinformationen
				$MG_a_bHilfsgitter_aktiviert, _								; aktiviert/deaktiviert die Hilfsgitterlinien
				$MG_a_iHilfsgitter_abstand_X, _								; der horizontale Abstand zwischen den Hilfsgitterlinien
				$MG_a_iHilfsgitter_abstand_Y, _								; der vertikale Abstand zwischen den Hilfsgitterlinien
				$MG_a_vHilfsgitter_farbe, _									; die verwendete Farbe der Hilfsgitterlinien
				$MG_a_iHilfsgitter_breite, _								; die Linienbreite
				$MG_a_iHilfsgitter_Transparenz, _							; die verwendete Transparenz der Hilfsgitterlinien (0 bis 255) -> 0: keine Transparenz;  255: unsichtbar
				$MG_a_hHilfsgitter_Pen, _									; handle zum "Zeichen-Stift"
				$MG_a_iHilfsgitter_Merker, _								; ein Merker zum Zwischenspeichern von Positionsinformationen
				$MG_a_iRendermodus, _										; Antialiasing (Kantenglättung) -> 0: keine Glättung;  1: Glättung mit 8 X 4 Rechteckfilter;  2: Glättung mit 8 X 8 kubischem Filter
				$MG_a_iPlottfrequenz, _										; ist die Anzahl der Plottvorgänge, bevor der Graph in der GUI aktualisiert wird. (je höher der Wert, desto mehr Werte können pro Sekunde dargestellt werden)
				$MG_a_iPlott_Counter, _										; allgemeiner Merker für den Plottvorgang (Zähler für die Plottfrequenz)
				$MG_a_iPlottmodus, _										; Anzeigemodus des Graphen -> 0: stehender Graph: Werte werden von links nach rechts gezeichnet;  1: bewegter Graph: Graph "scrollt" kontinuierlich von rechts nach links
				$MG_a_iClearmodus, _										; Löschmodus (nur wenn Plottmodus: 0) -> 0: alte Werte nicht löschen;  1: "aktualisieren" der alten Werte;  2: Graphinhalt nach kompletten durchlauf löschen
				$MG_a_bInterpolation, _										; aktiviert/deaktiviert die Interpolation zwischen 2 Werten
				$MG_a_iPosition_aktuell, _									; aktuelle (horizontale) Position des zu plottenden Wertes im Zeichenbereich
				$MG_a_iAchsbeschriftungen_rechts, _							; Anzahl der Beschriftungen der Y-Achse (rechte Seite)
				$MG_a_iAchsbeschriftungen_rechts_intervall, _				; Multiplikator: Darstellungsfaktor zwischen den Hauptgitterlinien -> 1: jede Hauptgitterlinie;  2: jede zweite Hauptgitterlinie; ...usw...
				$MG_a_iAchsbeschriftungen_links, _							; Anzahl der Beschriftungen der Y-Achse (linke Seite)
				$MG_a_iAchsbeschriftungen_links_intervall, _				; Multiplikator: Darstellungsfaktor zwischen den Hauptgitterlinien -> 1: jede Hauptgitterlinie;  2: jede zweite Hauptgitterlinie; ...usw...
				$MG_a_iAchsbeschriftungen_unten, _							; Anzahl der Beschriftungen der X-Achse
				$MG_a_iAchsbeschriftungen_unten_intervall, _				; Multiplikator: Darstellungsfaktor zwischen den Hauptgitterlinien -> 1: jede Hauptgitterlinie;  2: jede zweite Hauptgitterlinie; ...usw...
				$MG_a_ANZAHL_EINTRAEGE										; aktuelle Größe des Graph-Arrays (der Wert wird durch den Enum erzeugt; die Variable muss an LETZTER STELLE stehen!)



Global Enum		$MG_k_bKanal_aktivieren, _									; aktiviert/deaktivert den jeweiligen Kanal eines Graphen
				$MG_k_fY_aktueller_Wert, _									; aktueller Wert
				$MG_k_fY_letzter_Wert, _									; letzter Wert
				$MG_k_iLinien_Transparenz, _								; die verwendete Transparenz der Linie (0 bis 255) -> 0: keine Transparenz;  255: unsichtbar
				$MG_k_vLinien_Farbe, _										; die Farbe der Linie
				$MG_k_iLinien_Breite, _										; die Linienbreite
				$MG_k_hPen													; handle zum "Zeichen-Stift"





; legt die max. Anzahl der verwendeten Graphen und Anzahl der jeweiligen Kanäle fest
Global $MG_iMax_Anzahl_Graphen = 10
Global $MG_iMax_Anzahl_Kanaele = 10


Global $MG_aGraph[$MG_iMax_Anzahl_Graphen + 1][$MG_iMax_Anzahl_Kanaele + 1][$MG_a_ANZAHL_EINTRAEGE]
; ========================================================================================================================================================









; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_erstellen
; Beschreibung ..: 	erstellt einen Graphen
; Syntax.........: 	_MG_Graph_erstellen ($iGraph, $hGUI, $iX_Pos, $iY_Pos, $iBreite, $iHoehe)
;
; Parameter .....: 	$hGUI 		- das GUI-handle, auf dem der Graph gezeichnet werden soll
;                  	$iGraph    	- Graph-Index das verwendet werden soll (beginnend mit 1)
;                  	$iX_Pos		- X-Koordinate des Zeichenbereiches (linke, obere Ecke)
;                  	$iY_Pos		- Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
;                  	$iBreite 	- die Breite des Graphen
;                  	$iHoehe 	- die Höhe des Graphen
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;                  		 		| -2 der Graph ist schon aktiviert
;
; Autor .........: 	SBond
; Bemerkungen ...:  Wichtig: der Graphindex beginnt bei 1. Der Index 0 ist reserviert und sollte nicht verwendet werden.
;
; ========================================================================================================================================================
Func _MG_Graph_erstellen ($iGraph, $hGUI, $iX_Pos, $iY_Pos, $iBreite, $iHoehe)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Graph schon aktiviert ist
	If ($MG_aGraph[$iGraph][0][$MG_a_bGraph_aktiviert] = True) Then Return (-2)



	; erzeugt den Graphen mit den Voreinstellungen
	$MG_aGraph[$iGraph][0][$MG_a_bGraph_aktiviert]							= True
	$MG_aGraph[$iGraph][0][$MG_a_hGUI]										= $hGUI
	$MG_aGraph[$iGraph][0][$MG_a_iX_Pos]									= $iX_Pos
	$MG_aGraph[$iGraph][0][$MG_a_iY_Pos]									= $iY_Pos
	$MG_aGraph[$iGraph][0][$MG_a_iBreite]									= $iBreite
	$MG_aGraph[$iGraph][0][$MG_a_iHoehe]									= $iHoehe
	$MG_aGraph[$iGraph][0][$MG_a_hGraphic]									= _GDIPlus_GraphicsCreateFromHWND	($hGUI)
	$MG_aGraph[$iGraph][0][$MG_a_hBitmap]									= _GDIPlus_BitmapCreateFromGraphics	($iBreite, $iHoehe, $MG_aGraph[$iGraph][0][$MG_a_hGraphic])
	$MG_aGraph[$iGraph][0][$MG_a_hBuffer]									= _GDIPlus_ImageGetGraphicsContext	($MG_aGraph[$iGraph][0][$MG_a_hBitmap])
	$MG_aGraph[$iGraph][0][$MG_a_iAufloesung]								= $iBreite
	$MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse]						= $iBreite / $MG_aGraph[$iGraph][0][$MG_a_iAufloesung]
	$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]								= Ceiling($iBreite - $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse])
	$MG_aGraph[$iGraph][0][$MG_a_iY_min]									= 0
	$MG_aGraph[$iGraph][0][$MG_a_iY_max]									= 100
	$MG_aGraph[$iGraph][0][$MG_a_iWertebereich]								= Abs($MG_aGraph[$iGraph][0][$MG_a_iY_max] - $MG_aGraph[$iGraph][0][$MG_a_iY_min])
	$MG_aGraph[$iGraph][0][$MG_a_fWertaufloesung]							= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iWertebereich]
	$MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe]							= 0xFFFFFF
	$MG_aGraph[$iGraph][0][$MG_a_bRahmen]									= True
	$MG_aGraph[$iGraph][0][$MG_a_vRahmenfarbe]								= 0x000000
	$MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite]								= 1
	$MG_aGraph[$iGraph][0][$MG_a_hRahmen]									= GUICtrlCreateLabel ("", $iX_Pos - 1, $iY_Pos - 1, $iBreite + 2, $iHoehe + 2)
	$MG_aGraph[$iGraph][0][$MG_a_bHauptgitter_aktiviert]					= True
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X]					= 50
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]					= 50
	$MG_aGraph[$iGraph][0][$MG_a_vHauptgitter_farbe]						= 0x000000
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_breite]						= 1
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Transparenz]					= 180
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker]						= 0
	$MG_aGraph[$iGraph][0][$MG_a_bHilfsgitter_aktiviert]					= True
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X]					= 10
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y]					= 10
	$MG_aGraph[$iGraph][0][$MG_a_vHilfsgitter_farbe]						= 0x000000
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_breite]						= 1
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Transparenz]					= 220
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker]						= 0
	$MG_aGraph[$iGraph][0][$MG_a_iRendermodus]								= 2
	$MG_aGraph[$iGraph][0][$MG_a_iPlottfrequenz]							= 1
	$MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter]							= 0
	$MG_aGraph[$iGraph][0][$MG_a_iPlottmodus]								= 0
	$MG_aGraph[$iGraph][0][$MG_a_iClearmodus]								= 1
	$MG_aGraph[$iGraph][0][$MG_a_bInterpolation]							= True
	$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts]				= 0
	$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links]					= 0
	$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten]					= 0
	$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts_intervall]		= 0
	$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links_intervall]		= 0
	$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten_intervall]		= 0
	$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]							= 0


	; berechnet den ARGB-Farbcode für die Gitterlinien
	Local $vFarbcode_Hauptgitterlinien = "0x" & Hex(255 - $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Transparenz],2) & Hex($MG_aGraph[$iGraph][0][$MG_a_vHauptgitter_farbe],6)
	Local $vFarbcode_Hilfsgitterlinien = "0x" & Hex(255 - $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Transparenz],2) & Hex($MG_aGraph[$iGraph][0][$MG_a_vHilfsgitter_farbe],6)


	; ARGB-Farbcode übernehmen
	$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen]	= _GDIPlus_PenCreate($vFarbcode_Hauptgitterlinien, $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_breite])
	$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen]	= _GDIPlus_PenCreate($vFarbcode_Hilfsgitterlinien, $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_breite])


	; die Farbe des Rahmen übernehmen
	GUICtrlSetBkColor ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $MG_aGraph[$iGraph][0][$MG_a_vRahmenfarbe])
	GUICtrlSetState   ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $GUI_SHOW)
	GUICtrlSetState   ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $GUI_DISABLE)


	; den Rahmen fest andocken
	GUICtrlSetResizing ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $GUI_DOCKALL)


	; Antialiasing (Kantenglättung) übernehmen und den Zeichenbereich leeren
	_GDIPlus_GraphicsSetSmoothingMode	($MG_aGraph[$iGraph][0][$MG_a_hBuffer], $MG_aGraph[$iGraph][0][$MG_a_iRendermodus])
	_GDIPlus_GraphicsClear				($MG_aGraph[$iGraph][0][$MG_a_hBuffer], 0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])


	; Grundeinstellung der einzelnen Kanäle
	For $iKanal = 1 To $MG_iMax_Anzahl_Kanaele Step 1

		$MG_aGraph[$iGraph][$iKanal][$MG_k_bKanal_aktivieren]		= False
		$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert]		= ""
		$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert]			= ""
		$MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Transparenz]		= 0
		$MG_aGraph[$iGraph][$iKanal][$MG_k_vLinien_Farbe]			= 0x0055FF
		$MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Breite]			= 1
		$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen]					= _GDIPlus_PenCreate(0xFF000000 + $MG_aGraph[$iGraph][$iKanal][$MG_k_vLinien_Farbe], $MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Breite])

	Next


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_erstellen






; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_optionen_position
; Beschreibung ..: 	verschiebt einen Graphen in der GUI oder passt die Größe neu an
; Syntax.........: 	_MG_Graph_optionen_position ($iGraph, $hGUI, $iX_Pos, $iY_Pos, $iBreite, $iHoehe)
;
; Parameter .....: 	$hGUI 		- das GUI-handle, auf dem der Graph gezeichnet werden soll
;                  	$iGraph    	- Graph-Index das verwendet werden soll (beginnend mit 1)
;                  	$iX_Pos		- X-Koordinate des Zeichenbereiches (linke, obere Ecke)
;                  	$iY_Pos		- Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
;                  	$iBreite 	- die Breite des Graphen
;                  	$iHoehe 	- die Höhe des Graphen
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:  Die Achsbeschriftungen müssen manuell aktualisiert werden, damit die neue Position übernommen wird
;
; ========================================================================================================================================================
Func _MG_Graph_optionen_position ($iGraph, $hGUI, $iX_Pos, $iY_Pos, $iBreite, $iHoehe)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; die alten Resourcen freigeben
	_GDIPlus_GraphicsDispose ($MG_aGraph[$iGraph][0][$MG_a_hGraphic])
	_GDIPlus_GraphicsDispose ($MG_aGraph[$iGraph][0][$MG_a_hBuffer])
	_GDIPlus_BitmapDispose 	 ($MG_aGraph[$iGraph][0][$MG_a_hBitmap])


	; verschiebt den Graphen und passt die Einstellungen an
	$MG_aGraph[$iGraph][0][$MG_a_iX_Pos]									= $iX_Pos
	$MG_aGraph[$iGraph][0][$MG_a_iY_Pos]									= $iY_Pos
	$MG_aGraph[$iGraph][0][$MG_a_iBreite]									= $iBreite
	$MG_aGraph[$iGraph][0][$MG_a_iHoehe]									= $iHoehe
	$MG_aGraph[$iGraph][0][$MG_a_hGraphic]									= _GDIPlus_GraphicsCreateFromHWND	($hGUI)
	$MG_aGraph[$iGraph][0][$MG_a_hBitmap]									= _GDIPlus_BitmapCreateFromGraphics	($iBreite, $iHoehe, $MG_aGraph[$iGraph][0][$MG_a_hGraphic])
	$MG_aGraph[$iGraph][0][$MG_a_hBuffer]									= _GDIPlus_ImageGetGraphicsContext	($MG_aGraph[$iGraph][0][$MG_a_hBitmap])
	$MG_aGraph[$iGraph][0][$MG_a_iAufloesung]								= $iBreite
	$MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse]						= $iBreite / $MG_aGraph[$iGraph][0][$MG_a_iAufloesung]
	$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]								= Ceiling($iBreite - $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse])
	$MG_aGraph[$iGraph][0][$MG_a_fWertaufloesung]							= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iWertebereich]


	; den Rahmen neu positionieren
	GUICtrlSetPos  ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], _														; handle zum Label
					$MG_aGraph[$iGraph][0][$MG_a_iX_Pos]  - $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite], _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
					$MG_aGraph[$iGraph][0][$MG_a_iY_Pos]  - $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite], _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
					$MG_aGraph[$iGraph][0][$MG_a_iBreite] + (2*$MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite]), _		; breite des Labels
					$MG_aGraph[$iGraph][0][$MG_a_iHoehe]  + (2*$MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite]))		; höhe des Labels



	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_optionen_position






; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_optionen_allgemein
; Beschreibung ..: 	ändert die allgemeinen Einstellungen des Graphen
; Syntax.........: 	_MG_Graph_optionen_allgemein ($iGraph, $iAufloesung, $iY_min, $iY_max, $vHintergrundfarbe, $iRendermodus)
;
; Parameter .....: 	$iGraph 			- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$iAufloesung    	- Auflösung bzw. horizontale Skalierung: Ist die Anzahl der Werte, die dargestellt werden.
;										  Wenn die Auflösung gleich die Breite des Graphen ist, dann wird pro Pixel ein Wert dargestellt.
;                  	$iY_min				- der kleinste Wert, der im Graph dargestellt werden kann
;                  	$iY_max				- der größte Wert, der im Graph dargestellt werden kann
;                  	$vHintergrundfarbe 	- die Hintergrundfarbe (RGB) des Graphen in Hex-Darstellung (z.B. für Weiß: 0xFFFFFF)
;                  	$iRendermodus 		- Antialiasing (Kantenglättung)
;										| 0		keine Glättung
;										| 1		Glättung mit 8 X 4 Rechteckfilter
;										| 2		Glättung mit 8 X 8 kubischem Filter
;
; Rückgabewerte .: 	Erfolg 				|  0
;
;                  	Fehler 				| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_optionen_allgemein ($iGraph, $iAufloesung, $iY_min, $iY_max, $vHintergrundfarbe, $iRendermodus)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; neue Einstellungen übernehmen
	$MG_aGraph[$iGraph][0][$MG_a_iAufloesung]				= $iAufloesung
	$MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse]		= $MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iAufloesung]
	$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]				= Ceiling($MG_aGraph[$iGraph][0][$MG_a_iBreite] - $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse])
	$MG_aGraph[$iGraph][0][$MG_a_iY_min]					= $iY_min
	$MG_aGraph[$iGraph][0][$MG_a_iY_max]					= $iY_max
	$MG_aGraph[$iGraph][0][$MG_a_iWertebereich]				= Abs($iY_max - $iY_min)
	$MG_aGraph[$iGraph][0][$MG_a_fWertaufloesung]			= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iWertebereich]
	$MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe]			= $vHintergrundfarbe
	$MG_aGraph[$iGraph][0][$MG_a_iRendermodus]				= $iRendermodus


	; Antialiasing (Kantenglättung) übernehmen und den Zeichenbereich leeren
	_GDIPlus_GraphicsSetSmoothingMode	($MG_aGraph[$iGraph][0][$MG_a_hBuffer], $MG_aGraph[$iGraph][0][$MG_a_iRendermodus])
	_GDIPlus_GraphicsClear				($MG_aGraph[$iGraph][0][$MG_a_hBuffer], 0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_optionen_allgemein








; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_optionen_Rahmen
; Beschreibung ..: 	ändert die Rahmen-Einstellungen des Graphen
; Syntax.........: 	_MG_Graph_optionen_Rahmen ($iGraph, $bAnzeigen, $vRahmenfarbe, $iRahmenbreite)
;
; Parameter .....: 	$iGraph 			- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$bAnzeigen	    	- aktiviert/deaktiviert den Rahmen
;										| True		Rahmen anzeigen
;										| False		Rahmen nicht anzeigen
;
;                  	$vRahmenfarbe		- die Farbe (RGB) des Rahmen in Hex-Darstellung (z.B. für Schwarz: 0x000000)
;                  	$iRahmenbreite		- die Breite des Rahmens (in Pixeln)
;
; Rückgabewerte .: 	Erfolg 				|  0
;
;                  	Fehler 				| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:  					die Änderung der Rahmenbreite verschiebt oder ändert den Zeichenbereich nicht. Der Rahmen dehnt sich demnach nach außen aus.
;
; ========================================================================================================================================================
Func _MG_Graph_optionen_Rahmen ($iGraph, $bAnzeigen, $vRahmenfarbe, $iRahmenbreite)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; neue Einstellungen übernehmen
	$MG_aGraph[$iGraph][0][$MG_a_bRahmen]			= $bAnzeigen
	$MG_aGraph[$iGraph][0][$MG_a_vRahmenfarbe]		= $vRahmenfarbe
	$MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite]		= $iRahmenbreite



	; verschiebt den Rahmen mittig zum Zeichenbereich
	If ($bAnzeigen = True) Then

		GUICtrlSetPos  ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], _							; handle zum Label
						$MG_aGraph[$iGraph][0][$MG_a_iX_Pos]  - $iRahmenbreite, _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
						$MG_aGraph[$iGraph][0][$MG_a_iY_Pos]  - $iRahmenbreite, _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
						$MG_aGraph[$iGraph][0][$MG_a_iBreite] + (2*$iRahmenbreite), _		; breite des Labels
						$MG_aGraph[$iGraph][0][$MG_a_iHoehe]  + (2*$iRahmenbreite))			; höhe des Labels

		; Rahmenfarbe übernehmen
		GUICtrlSetBkColor ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $vRahmenfarbe)
		GUICtrlSetState   ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $GUI_SHOW)
		GUICtrlSetState   ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $GUI_DISABLE)

	Else

		; Rahmen ausblenden, wenn er deaktiviert wird
		GUICtrlSetState   ($MG_aGraph[$iGraph][0][$MG_a_hRahmen], $GUI_HIDE)

	EndIf



	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_optionen_Rahmen








; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_optionen_Hauptgitterlinien
; Beschreibung ..: 	ändert die Einstellungen der Hauptgitterlinien im Graphen
; Syntax.........: 	_MG_Graph_optionen_Hauptgitterlinien ($iGraph, $bHauptgitter_aktiviert, $iHauptgitter_abstand_X, $iHauptgitter_abstand_Y, $iHauptgitter_breite, $vHauptgitter_farbe, $iHauptgitter_Transparenz)
;
; Parameter .....: 	$iGraph 					- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$bHauptgitter_aktiviert	    - aktiviert/deaktiviert die Hauptgitterlinien
;												| True		Hauptgitterlinien anzeigen
;												| False		Hauptgitterlinien nicht anzeigen
;
;                  	$iHauptgitter_abstand_X		- der horizontale Abstand zwischen den Hauptgitterlinien
;                  	$iHauptgitter_abstand_Y		- der vertikale Abstand zwischen den Hauptgitterlinien
;                  	$iHauptgitter_breite		- die Linienbreite des Gitters (in Pixeln)
;                  	$vHauptgitter_farbe			- die Farbe (RGB) des Rahmen in Hex-Darstellung (z.B. für Dunkelgrau: 0x777777)
;                  	$iHauptgitter_Transparenz	- die verwendete Transparenz der Hauptgitterlinien (0 bis 255)
;												| 0 		keine Transparenz
;												| 255		unsichtbar
;
; Rückgabewerte .: 	Erfolg 						|  0
;
;                  	Fehler 						| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_optionen_Hauptgitterlinien ($iGraph, $bHauptgitter_aktiviert, $iHauptgitter_abstand_X, $iHauptgitter_abstand_Y, $iHauptgitter_breite, $vHauptgitter_farbe, $iHauptgitter_Transparenz)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; neue Einstellungen übernehmen
	$MG_aGraph[$iGraph][0][$MG_a_bHauptgitter_aktiviert]		= $bHauptgitter_aktiviert
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X]		= $iHauptgitter_abstand_X
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]		= $iHauptgitter_abstand_Y
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_breite]			= $iHauptgitter_breite
	$MG_aGraph[$iGraph][0][$MG_a_vHauptgitter_farbe]			= $vHauptgitter_farbe
	$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Transparenz]		= $iHauptgitter_Transparenz


	; den alten "Zeichenstift" löschen und den neuen erstellen
	Local $vFarbcode = "0x" & Hex(255 - $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Transparenz],2) & Hex($MG_aGraph[$iGraph][0][$MG_a_vHauptgitter_farbe],6)
	_GDIPlus_PenDispose($MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])
	$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen] 				= _GDIPlus_PenCreate($vFarbcode, $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_breite])


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_optionen_Hauptgitterlinien








; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_optionen_Hilfsgitterlinien
; Beschreibung ..: 	ändert die Einstellungen der Hilfsgitterlinien im Graphen
; Syntax.........: 	_MG_Graph_optionen_Hilfsgitterlinien ($iGraph, $bHilfsgitter_aktiviert, $iHilfsgitter_abstand_X, $iHilfsgitter_abstand_Y, $iHilfsgitter_breite, $vHilfsgitter_farbe, $iHilfsgitter_Transparenz)
;
; Parameter .....: 	$iGraph 					- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$bHilfsgitter_aktiviert	    - aktiviert/deaktiviert die Hilfsgitterlinien
;												| True		Hilfsgitterlinien anzeigen
;												| False		Hilfsgitterlinien nicht anzeigen
;
;                  	$iHilfsgitter_abstand_X		- der horizontale Abstand zwischen den Hilfsgitterlinien
;                  	$iHilfsgitter_abstand_Y		- der vertikale Abstand zwischen den Hilfsgitterlinien
;                  	$iHilfsgitter_breite		- die Linienbreite des Gitters (in Pixeln)
;                  	$vHilfsgitter_farbe			- die Farbe (RGB) des Rahmen in Hex-Darstellung (z.B. für Grau: 0x777777)
;                  	$iHilfsgitter_Transparenz	- die verwendete Transparenz der Hilfsgitterlinien (0 bis 255)
;												| 0 		keine Transparenz
;												| 255		unsichtbar
;
; Rückgabewerte .: 	Erfolg 						|  0
;
;                  	Fehler 						| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_optionen_Hilfsgitterlinien ($iGraph, $bHilfsgitter_aktiviert, $iHilfsgitter_abstand_X, $iHilfsgitter_abstand_Y, $iHilfsgitter_breite, $vHilfsgitter_farbe, $iHilfsgitter_Transparenz)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; neue Einstellungen übernehmen
	$MG_aGraph[$iGraph][0][$MG_a_bHilfsgitter_aktiviert]		= $bHilfsgitter_aktiviert
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X]		= $iHilfsgitter_abstand_X
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y]		= $iHilfsgitter_abstand_Y
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_breite]			= $iHilfsgitter_breite
	$MG_aGraph[$iGraph][0][$MG_a_vHilfsgitter_farbe]			= $vHilfsgitter_farbe
	$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Transparenz]		= $iHilfsgitter_Transparenz


	; den alten "Zeichenstift" löschen und den neuen erstellen
	Local $vFarbcode = "0x" & Hex(255 - $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Transparenz],2) & Hex($MG_aGraph[$iGraph][0][$MG_a_vHilfsgitter_farbe],6)

	_GDIPlus_PenDispose($MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])
	$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen] = _GDIPlus_PenCreate($vFarbcode, $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_breite])


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_optionen_Hilfsgitterlinien








; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_optionen_Plottmodus
; Beschreibung ..: 	ändert die Plott-Einstellungen des Graphen
; Syntax.........: 	_MG_Graph_optionen_Plottmodus ($iGraph, $iPlottmodus, $iPlottfrequenz, $iClearmodus, $bInterpolation)
;
; Parameter .....: 	$iGraph 			- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$iPlottmodus		- die grundsätzliche Darstellungsart, der zu plottenden Werte
;										| 0			stehender Graph:	Werte werden von links nach rechts gezeichnet
;										| 1			bewegter Graph:		der gesamte Graph "scrollt" kontinuierlich von rechts nach links
;
;                  	$iPlottfrequenz		- ist die Anzahl der Plottvorgänge (einzelne Werte), bevor der Graph in der GUI aktualisiert wird.
;										| 0			der Graph wird erst aktualisiert, wenn der komplette Bildbereich geplottet wurde. (es werden so viele Werte geplottet, wie der Graph breit ist)
;										| >0		je höher der Wert, desto mehr Werte können pro Sekunde dargestellt werden
;
;                  	$iClearmodus		- die "Reinigungsmethode" des Graphen. Diese Option wird nur angewendet, wenn der Plottmodus 0 ist.
;										| 0			keine Reinigung		- nach einem kompletten Bilddurchlauf werden keine alten Werte gelöscht. (es wird dann einfach überzeichnet)
;										| 1			partielle Reinigung	- nach einem kompletten Bilddurchlauf werden die alten (geplotteten) Werte durch neue überschrieben
;										| 2			komplette Reinigung - nach einem kompletten Bilddurchlauf wird der Graphinhalt gelöscht
;
;                  	$bInterpolation		- aktiviert/deaktiviert die Interpolation der geplotteten Werte
;										| True		Interpolation aktivieren
;										| False		Interpolation deaktivieren
;
; Rückgabewerte .: 	Erfolg 				|  0
;
;                  	Fehler 				| -1 		der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:						Die aktivierte Interpolation ermöglicht einen schnelleren Plottvorgang, da die gezeichnete Linie direkt von Punkt zu Punkt verbunden wird.
;										Wird die Interpolation deaktiviert, so werden nur horizontale und vertikale Linien gezeichnet. In diesem Fall werden meistens 2 Zeichenvorgänge
;										zwischen 2 Punkten benötigt.
;
;										Um möglichst viele Werte pro Sekunde zu plotten, sollte man den Plottmodus auf 0 und den Clearmodus auf 2 setzen.
;										Dadurch kommt Darstellung einem Oszilloskop sehr nahe.
;
; ========================================================================================================================================================
Func _MG_Graph_optionen_Plottmodus ($iGraph, $iPlottmodus, $iPlottfrequenz, $iClearmodus, $bInterpolation)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; neue Einstellungen übernehmen
	$MG_aGraph[$iGraph][0][$MG_a_iPlottfrequenz]		= $iPlottfrequenz
	$MG_aGraph[$iGraph][0][$MG_a_iPlottmodus]			= $iPlottmodus
	$MG_aGraph[$iGraph][0][$MG_a_iClearmodus]			= $iClearmodus
	$MG_aGraph[$iGraph][0][$MG_a_bInterpolation]		= $bInterpolation

	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_optionen_Plottmodus







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Kanal_optionen
; Beschreibung ..: 	ändert die Kanal-Einstellungen des Graphen
; Syntax.........: 	_MG_Kanal_optionen ($iGraph, $iKanal, $bKanal_aktivieren, $iLinien_Breite = 1, $vLinien_Farbe = 0xCCCCCC, $iLinien_Transparenz = 0)
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$iKanal					- Kanal-Index, auf dem sich die Einstellungen beziehen
;                  	$bKanal_aktivieren		- aktiviert/deaktiviert die Darstellung des Kanals im Graphen
;											| True		Kanal aktivieren
;											| False		Kanal deaktivieren
;
;                  	$iLinien_Breite			- die Breite der geplotteten Linie (in Pixeln)
;                  	$vLinien_Farbe			- die Farbe (RGB) der Linie in Hex-Darstellung (z.B. für Dunkelgrau: 0xCCCCCC)
;                  	$iLinien_Transparenz	- die verwendete Transparenz der Linie (0 bis 255)
;											| 0 		keine Transparenz
;											| 255		unsichtbar
;
; Rückgabewerte .: 	Erfolg 					|  0
;
;                  	Fehler 					| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;											| -2 der Kanal-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:							Je mehr Kanäle geplottet werden, desto langsamer wird die Geschwindigkeit des Graphen.
;
; ========================================================================================================================================================
Func _MG_Kanal_optionen ($iGraph, $iKanal, $bKanal_aktivieren, $iLinien_Breite = 1, $vLinien_Farbe = 0xCCCCCC, $iLinien_Transparenz = 0)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Kanal-Index außerhalb des gültigen Bereichs liegt
	If ($iKanal > $MG_iMax_Anzahl_Kanaele) OR ($iKanal <= 0) Then Return (-2)


	; neue Einstellungen übernehmen
	$MG_aGraph[$iGraph][$iKanal][$MG_k_bKanal_aktivieren]		= $bKanal_aktivieren
	$MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Breite]			= $iLinien_Breite
	$MG_aGraph[$iGraph][$iKanal][$MG_k_vLinien_Farbe]			= $vLinien_Farbe
	$MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Transparenz]		= $iLinien_Transparenz


	; den alten "Zeichenstift" löschen und den neuen erstellen
	Local $vFarbcode = "0x" & Hex(255 - $MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Transparenz],2) & Hex($MG_aGraph[$iGraph][$iKanal][$MG_k_vLinien_Farbe],6)

	_GDIPlus_PenDispose($MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])
	$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen] = _GDIPlus_PenCreate($vFarbcode, $MG_aGraph[$iGraph][$iKanal][$MG_k_iLinien_Breite])


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Kanal_optionen







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_initialisieren
; Beschreibung ..: 	plottet den Graphen erstmalig in der GUI
; Syntax.........: 	_MG_Graph_initialisieren ($iGraph)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:				Diese Funktion sollte verwendet werden, nachdem der Graph erstellt und konfiguriert wurde. Es dient nur zur sauberen Darstellung
;								und muss daher nicht zwangsweise verwendet werden. Wird diese Funktion nicht verwendet, so wird der Graph erst sichtbar, wenn mit dem
;								Plottvorgang begonnen wurde. (ggf. kann es sein, das solange nur der Rahmen sichtbar ist)
;
; ========================================================================================================================================================
Func _MG_Graph_initialisieren ($iGraph)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; die Gitterlinien plotten und anschließend den Graphen in der GUI darstellen
	_GDIPlus_GraphicsClear ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], 0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])
	_MG_Graph_Hauptgitterlinien_plotten($iGraph, 0)
	_MG_Graph_Hilfsgitterlinien_plotten($iGraph, 0)
	_MG_Graph_updaten($iGraph)


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_initialisieren







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Wert_setzen
; Beschreibung ..: 	legt den neuen Wert für den nächsten Plottvorgang fest
; Syntax.........: 	_MG_Wert_setzen ($iGraph, $iKanal, $fWert)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;					$iKanal 	- Kanal-Index, auf dem sich die Einstellungen beziehen
;					$fWert 		- der Wert, der beim nächsten Plottvorgang dargestellt werden soll
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;								| -2 der Kanal-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Wert_setzen ($iGraph, $iKanal, $fWert)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Kanal-Index außerhalb des gültigen Bereichs liegt
	If ($iKanal > $MG_iMax_Anzahl_Kanaele) OR ($iKanal <= 0) Then Return (-2)


	; Berechnung der vertikalen Position des Wertes
	Local $fWert_neu = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - (($fWert - $MG_aGraph[$iGraph][0][$MG_a_iY_min])* $MG_aGraph[$iGraph][0][$MG_a_fWertaufloesung])


	; den letzten Wert und den neuen Wert speichern
	If ($MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert] = "") Then $MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert]	= $fWert_neu
	$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert]	= $fWert_neu


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Wert_setzen






; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_updaten
; Beschreibung ..: 	zeichnet den Graph in die GUI bzw. aktualisiert die Darstellung
; Syntax.........: 	_MG_Graph_updaten ($iGraph)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:				Es werden keine Werte geplottet. Es wird lediglich nur die Darstellung in der GUI aktualisiert.
;
; ========================================================================================================================================================
Func _MG_Graph_updaten ($iGraph)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; den Graph in die GUI zeichnen
	_GDIPlus_GraphicsDrawImageRect ($MG_aGraph[$iGraph][0][$MG_a_hGraphic], _		; handle zum Graphic-Objekt
									$MG_aGraph[$iGraph][0][$MG_a_hBitmap], _		; handle zum Bitmap-Objekt
									$MG_aGraph[$iGraph][0][$MG_a_iX_Pos], _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
									$MG_aGraph[$iGraph][0][$MG_a_iY_Pos], _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
									$MG_aGraph[$iGraph][0][$MG_a_iBreite], _		; die Breite des Zeichenbereiches
									$MG_aGraph[$iGraph][0][$MG_a_iHoehe])			; die Höhe des Zeichenbereiches


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_updaten






; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_clear
; Beschreibung ..: 	löscht die aktuell geplotteten Werte
; Syntax.........: 	_MG_Graph_clear ($iGraph)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:				Es werden dabei keine Einstellungen am Graphen verändert
;
; ========================================================================================================================================================
Func _MG_Graph_clear ($iGraph)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; die aktuelle Position auf Null setzen, die geplotteten Werte löschen und die Gitterlinien neu zeichnen
	$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] = 0

	_GDIPlus_GraphicsClear($MG_aGraph[$iGraph][0][$MG_a_hBuffer], 0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])

	_MG_Graph_Hauptgitterlinien_plotten($iGraph, 0)
	_MG_Graph_Hilfsgitterlinien_plotten($iGraph, 0)



	; die Plottwerte der einzelnen Kanäle zurücksetzen
	For $iKanal = 1 To $MG_iMax_Anzahl_Kanaele Step 1

		$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert]	= ""
		$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert]		= ""

	Next



	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_clear







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_Achse_links
; Beschreibung ..: 	erzeugt eine Achsbeschriftung auf der linken Seite (Y-Achse), die sich an den horizontalen Hauptgitterlinien richtet
; Syntax.........:  _MG_Graph_Achse_links ($iGraph, $bAchse_anzeigen = True, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%", $vSchriftfarbe = 0x000000, $vHintergrundfarbe = Default, $fSchriftgroesse = 8.5, $iLabelbreite = 60, $fIntervall = 1)
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$bAchse_anzeigen		- aktiviert/deaktiviert die Beschriftung der linken Achse
;											| True		Achsbeschriftung aktivieren
;											| False		Achsbeschriftung deaktivieren
;
;					$fMin_Wert				- der unterste Wert, der angezeigt werden kann
;					$fMax_Wert				- der oberste Wert, der angezeigt werden kann
;					$iNachkommastellen		- die Anzahl der Nachkommastellen, die angezeigt werden sollen (Nachkommastellen werden gerundet)
;					$sEinheit				- die Einheit die angezeigt werden soll (z.B. " sek", " %", " KG", ....)
;					$vSchriftfarbe			- die Farbe (RGB) der Schrift in Hex-Darstellung (z.B. für Blau: 0x0000FF)
;					$vHintergrundfarbe		- die Hintergrund (RGB) der Beschriftung in Hex-Darstellung (oder 'Default', wenn keine Hintergrundfarbe verwendet werden soll)
;					$fSchriftgroesse		- die Schriftgröße (Standard 9.0)
;					$iLabelbreite			- die Breite, die für jede Beschriftungseinheit reserviert wird (50 bis 70 sollte in der Regel ausreichen)
;					$fIntervall				- Faktor (mindestens >= 0.1): vertikaler Abstandsfaktor zwischen den Beschriftungen im Bezug auf die Hauptgitterlinien (siehe Bemerkungen)
;
; Rückgabewerte .: 	Erfolg 					| >0	gibt die Anzahl der Beschriftungen der linken Y-Achse zurück
;
;                  	Fehler 					| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;											| -2 	der Abstand der Hauptgitterlinien wurde zu klein gewählt
;
; Autor .........: 	SBond
; Bemerkungen ...:							Beispiele für die Intervalle, mit der Annahme, dass 5 vertikale Hauptgitterlinien im Graphen sichtbar sind:
;
;											Intervall = 1:		neben jeder Hauptgitterlinie wird eine Beschriftung angezeigt 	(insgesamt 5)
;											Intervall = 2:		neben jeder zweiten Hauptgitterlinie wird eine Beschriftung angezeigt 	(insgesamt 3)
;											Intervall = 0.5:	neben jeder Hauptgitterlinie wird eine Beschriftung angezeigt und zwischen den Hauptgitterlinien wird eine Beschriftung	angezeigt	(insgesamt 10)
;
; ========================================================================================================================================================
Func _MG_Graph_Achse_links ($iGraph, $bAchse_anzeigen = True, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%", $vSchriftfarbe = 0x000000, $vHintergrundfarbe = Default, $fSchriftgroesse = 9.0, $iLabelbreite = 60, $fIntervall = 1)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Abstand der Hauptgitterlinien zu klein gewählt wurde
	If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] < 1) Then Return (-2)


	; begrenzt den Intervall auf min. 0.1
	If ($fIntervall < 0.1) Then $fIntervall = 0.1



	; alte Achsbeschriftung löschen, sofern welche vorhanden sind
	If ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links] <> 0) Then

		For $i = 0 to $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links] Step 1
			GUICtrlDelete (Eval("_MG_Graph_Achse_links" & $iGraph & $i))
			GUICtrlDelete (Eval("_MG_Graph_Achse_links_Strich" & $iGraph & $i))
		Next

		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links] = 0

	EndIf



	; Achsbeschriftungen erzeugen, wenn die Option aktiviert wurde
	If ($bAchse_anzeigen = True) Then


		; diverse Vorberechnungen
		Local $iLabelhoehe 					= $fSchriftgroesse + 2

		Local $fAnzahl_Hauptgitterlinien 	= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]
		Local $fAbstand 					= $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]

		Local $iX_Pos_Strich 				= $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] - $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite] - 8
		Local $iX_Pos_Beschriftung 			= $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] - ($iLabelbreite + $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite] + 8)

		Local $fWertebereich 				= $fMax_Wert - $fMin_Wert
		Local $fWertdifferenz 				= $fWertebereich / $fAnzahl_Hauptgitterlinien

		Local $iCounter 					= 0


		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links] = 0
		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links_intervall] = $fIntervall


		; Anzahl und Abstand der Beschriftungen berechnen und anschließend anzeigen
		For $i = 0 to $fAnzahl_Hauptgitterlinien Step $fIntervall

			$iCounter += 1
			$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links] += 1

			Local $iY_Pos_Strich 			= ($MG_aGraph[$iGraph][0][$MG_a_iHoehe] + $MG_aGraph[$iGraph][0][$MG_a_iY_Pos]) - ($fAbstand*$i) - 12
			Local $iY_Pos_Beschriftung 		= ($MG_aGraph[$iGraph][0][$MG_a_iHoehe] + $MG_aGraph[$iGraph][0][$MG_a_iY_Pos]) - ($fAbstand*$i) - ($iLabelhoehe/2)

			Local $fWert 					= $fMin_Wert + ($i*$fWertdifferenz)
			Local $vBeschriftung 			=  StringFormat("%." & $iNachkommastellen & "f", $fWert) & $sEinheit


			Assign ("_MG_Graph_Achse_links_Strich" & $iGraph & $iCounter, GUICtrlCreateLabel("_", $iX_Pos_Strich, $iY_Pos_Strich, 8, 14, BitOR($SS_CENTERIMAGE, $SS_RIGHT)),2)
			GUICtrlSetColor		(Eval("_MG_Graph_Achse_links_Strich" & $iGraph & $iCounter), $vSchriftfarbe)
			GUICtrlSetBkColor	(Eval("_MG_Graph_Achse_links_Strich" & $iGraph & $iCounter), $vHintergrundfarbe)
			GUICtrlSetResizing  (Eval("_MG_Graph_Achse_links_Strich" & $iGraph & $iCounter), $GUI_DOCKALL)


			Assign ("_MG_Graph_Achse_links" & $iGraph & $iCounter, GUICtrlCreateLabel($vBeschriftung, $iX_Pos_Beschriftung, $iY_Pos_Beschriftung, $iLabelbreite, $iLabelhoehe, BitOR($SS_CENTERIMAGE, $SS_RIGHT)),2)
			GUICtrlSetColor		(Eval("_MG_Graph_Achse_links" & $iGraph & $iCounter), $vSchriftfarbe)
			GUICtrlSetBkColor	(Eval("_MG_Graph_Achse_links" & $iGraph & $iCounter), $vHintergrundfarbe)
			GUICtrlSetFont 		(Eval("_MG_Graph_Achse_links" & $iGraph & $iCounter), $fSchriftgroesse)
			GUICtrlSetResizing  (Eval("_MG_Graph_Achse_links" & $iGraph & $iCounter), $GUI_DOCKALL)

		Next

	EndIf



	; Rückgabewert: gibt die Anzahl der Beschriftungen der linken Y-Achse zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links])


EndFunc	;==> _MG_Graph_Achse_links








; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_Achse_rechts
; Beschreibung ..: 	erzeugt eine Achsbeschriftung auf der rechten Seite (Y-Achse), die sich an den horizontalen Hauptgitterlinien richtet
; Syntax.........:  _MG_Graph_Achse_rechts ($iGraph, $bAchse_anzeigen = True, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%", $vSchriftfarbe = 0x000000, $vHintergrundfarbe = Default, $fSchriftgroesse = 8.5, $iLabelbreite = 60, $fIntervall = 1)
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$bAchse_anzeigen		- aktiviert/deaktiviert die Beschriftung der rechten Achse
;											| True		Achsbeschriftung aktivieren
;											| False		Achsbeschriftung deaktivieren
;
;					$fMin_Wert				- der unterste Wert, der angezeigt werden kann
;					$fMax_Wert				- der oberste Wert, der angezeigt werden kann
;					$iNachkommastellen		- die Anzahl der Nachkommastellen, die angezeigt werden sollen (Nachkommastellen werden gerundet)
;					$sEinheit				- die Einheit die angezeigt werden soll (z.B. " sek", " %", " KG", ....)
;					$vSchriftfarbe			- die Farbe (RGB) der Schrift in Hex-Darstellung (z.B. für Blau: 0x0000FF)
;					$vHintergrundfarbe		- die Hintergrund (RGB) der Beschriftung in Hex-Darstellung (oder 'Default', wenn keine Hintergrundfarbe verwendet werden soll)
;					$fSchriftgroesse		- die Schriftgröße (Standard 9.0)
;					$iLabelbreite			- die Breite, die für jede Beschriftungseinheit reserviert wird (50 bis 70 sollte in der Regel ausreichen)
;					$fIntervall				- Faktor (mindestens >= 0.1): vertikaler Abstandsfaktor zwischen den Beschriftungen im Bezug auf die Hauptgitterlinien (siehe Bemerkungen)
;
; Rückgabewerte .: 	Erfolg 					| >0	gibt die Anzahl der Beschriftungen der rechten Y-Achse zurück
;
;                  	Fehler 					| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;											| -2 	der Abstand der Hauptgitterlinien wurde zu klein gewählt
;
; Autor .........: 	SBond
; Bemerkungen ...:							Beispiele für die Intervalle, mit der Annahme, dass 5 vertikale Hauptgitterlinien im Graphen sichtbar sind:
;
;											Intervall = 1:		neben jeder Hauptgitterlinie wird eine Beschriftung angezeigt 	(insgesamt 5)
;											Intervall = 2:		neben jeder zweiten Hauptgitterlinie wird eine Beschriftung angezeigt 	(insgesamt 3)
;											Intervall = 0.5:	neben jeder Hauptgitterlinie wird eine Beschriftung angezeigt und zwischen den Hauptgitterlinien wird eine Beschriftung	angezeigt	(insgesamt 10)
;
; ========================================================================================================================================================
Func _MG_Graph_Achse_rechts ($iGraph, $bAchse_anzeigen = True, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%", $vSchriftfarbe = 0x000000, $vHintergrundfarbe = Default, $fSchriftgroesse = 9.0, $iLabelbreite = 60, $fIntervall = 1)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Abstand der Hauptgitterlinien zu klein gewählt wurde
	If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] < 1) Then Return (-2)


	; begrenzt den Intervall auf min. 0.1
	If ($fIntervall < 0.1) Then $fIntervall = 0.1



	; alte Achsbeschriftung löschen, sofern welche vorhanden sind
	If ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts] <> 0) Then

		For $i = 0 to $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts] Step 1
			GUICtrlDelete (Eval("_MG_Graph_Achse_rechts" & $iGraph & $i))
			GUICtrlDelete (Eval("_MG_Graph_Achse_rechts_Strich" & $iGraph & $i))
		Next

		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts] = 0

	EndIf



	; Achsbeschriftungen erzeugen, wenn die Option aktiviert wurde
	If ($bAchse_anzeigen = True) Then


		; diverse Vorberechnungen
		Local $iLabelhoehe 					= $fSchriftgroesse + 2

		Local $fAnzahl_Hauptgitterlinien 	= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]
		Local $fAbstand 					= $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]

		Local $iX_Pos_Strich 				= $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] + $MG_aGraph[$iGraph][0][$MG_a_iBreite] + $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite]
		Local $iX_Pos_Beschriftung 			= $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] + $MG_aGraph[$iGraph][0][$MG_a_iBreite] + $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite] + 10

		Local $fWertebereich 				= $fMax_Wert - $fMin_Wert
		Local $fWertdifferenz 				= $fWertebereich / $fAnzahl_Hauptgitterlinien

		Local $iCounter = 0


		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts] = 0
		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts_intervall] = $fIntervall


		; Anzahl und Abstand der Beschriftungen berechnen und anschließend anzeigen
		For $i = 0 to $fAnzahl_Hauptgitterlinien Step $fIntervall

			$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts] += 1
			$iCounter += 1

			Local $iY_Pos_Strich 			= ($MG_aGraph[$iGraph][0][$MG_a_iHoehe] + $MG_aGraph[$iGraph][0][$MG_a_iY_Pos]) - ($fAbstand*$i) - 12
			Local $iY_Pos_Beschriftung 		= ($MG_aGraph[$iGraph][0][$MG_a_iHoehe] + $MG_aGraph[$iGraph][0][$MG_a_iY_Pos]) - ($fAbstand*$i) - ($iLabelhoehe/2)

			Local $fWert 					= $fMin_Wert + ($i*$fWertdifferenz)
			Local $vBeschriftung 			=  StringFormat("%." & $iNachkommastellen & "f", $fWert) & $sEinheit


			Assign ("_MG_Graph_Achse_rechts_Strich" & $iGraph & $iCounter, GUICtrlCreateLabel("_", $iX_Pos_Strich, $iY_Pos_Strich, 8, 14, BitOR($SS_CENTERIMAGE, $SS_LEFT)),2)
			GUICtrlSetColor		(Eval("_MG_Graph_Achse_rechts_Strich" & $iGraph & $iCounter), $vSchriftfarbe)
			GUICtrlSetBkColor	(Eval("_MG_Graph_Achse_rechts_Strich" & $iGraph & $iCounter), $vHintergrundfarbe)
			GUICtrlSetResizing  (Eval("_MG_Graph_Achse_rechts_Strich" & $iGraph & $iCounter), $GUI_DOCKALL)

			Assign ("_MG_Graph_Achse_rechts" & $iGraph & $iCounter, GUICtrlCreateLabel($vBeschriftung, $iX_Pos_Beschriftung, $iY_Pos_Beschriftung, $iLabelbreite, $iLabelhoehe, BitOR($SS_CENTERIMAGE, $SS_LEFT)),2)
			GUICtrlSetColor		(Eval("_MG_Graph_Achse_rechts" & $iGraph & $iCounter), $vSchriftfarbe)
			GUICtrlSetBkColor	(Eval("_MG_Graph_Achse_rechts" & $iGraph & $iCounter), $vHintergrundfarbe)
			GUICtrlSetFont 		(Eval("_MG_Graph_Achse_rechts" & $iGraph & $iCounter), $fSchriftgroesse)
			GUICtrlSetResizing  (Eval("_MG_Graph_Achse_rechts" & $iGraph & $iCounter), $GUI_DOCKALL)

		Next

	EndIf



	; Rückgabewert: gibt die Anzahl der Beschriftungen der linken Y-Achse zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts])


EndFunc	;==> _MG_Graph_Achse_rechts








; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_Achse_unten
; Beschreibung ..: 	erzeugt eine Achsbeschriftung auf der unteren Seite (X-Achse), die sich an den vertikalen Hauptgitterlinien richtet
; Syntax.........:  _MG_Graph_Achse_unten ($iGraph, $bAchse_anzeigen = True, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%", $vSchriftfarbe = 0x000000, $vHintergrundfarbe = Default, $fSchriftgroesse = 8.5, $iLabelbreite = 60, $fIntervall = 1)
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;                  	$bAchse_anzeigen		- aktiviert/deaktiviert die Beschriftung der unteren Achse
;											| True		Achsbeschriftung aktivieren
;											| False		Achsbeschriftung deaktivieren
;
;					$fMin_Wert				- der unterste Wert, der angezeigt werden kann
;					$fMax_Wert				- der oberste Wert, der angezeigt werden kann
;					$iNachkommastellen		- die Anzahl der Nachkommastellen, die angezeigt werden sollen (Nachkommastellen werden gerundet)
;					$sEinheit				- die Einheit die angezeigt werden soll (z.B. " sek", " %", " KG", ....)
;					$vSchriftfarbe			- die Farbe (RGB) der Schrift in Hex-Darstellung (z.B. für Blau: 0x0000FF)
;					$vHintergrundfarbe		- die Hintergrund (RGB) der Beschriftung in Hex-Darstellung (oder 'Default', wenn keine Hintergrundfarbe verwendet werden soll)
;					$fSchriftgroesse		- die Schriftgröße (Standard 9.0)
;					$iLabelbreite			- die Breite, die für jede Beschriftungseinheit reserviert wird (50 bis 70 sollte in der Regel ausreichen)
;					$fIntervall				- Faktor (mindestens >= 0.1): vertikaler Abstandsfaktor zwischen den Beschriftungen im Bezug auf die Hauptgitterlinien (siehe Bemerkungen)
;
; Rückgabewerte .: 	Erfolg 					| >0	gibt die Anzahl der Beschriftungen der X-Achse zurück
;
;                  	Fehler 					| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;											| -2 	der Abstand der Hauptgitterlinien wurde zu klein gewählt
;
; Autor .........: 	SBond
; Bemerkungen ...:							Beispiele für die Intervalle, mit der Annahme, dass 5 vertikale Hauptgitterlinien im Graphen sichtbar sind:
;
;											Intervall = 1:		neben jeder Hauptgitterlinie wird eine Beschriftung angezeigt 	(insgesamt 5)
;											Intervall = 2:		neben jeder zweiten Hauptgitterlinie wird eine Beschriftung angezeigt 	(insgesamt 3)
;											Intervall = 0.5:	neben jeder Hauptgitterlinie wird eine Beschriftung angezeigt und zwischen den Hauptgitterlinien wird eine Beschriftung	angezeigt	(insgesamt 10)
;
; ========================================================================================================================================================
Func _MG_Graph_Achse_unten ($iGraph, $bAchse_anzeigen = True, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%", $vSchriftfarbe = 0x000000, $vHintergrundfarbe = Default, $fSchriftgroesse = 9.0, $iLabelbreite = 60, $fIntervall = 1)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Abstand der Hauptgitterlinien zu klein gewählt wurde
	If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] < 1) Then Return (-2)


	; begrenzt den Intervall auf min. 0.1
	If ($fIntervall < 0.1) Then $fIntervall = 0.1



	; alte Achsbeschriftung löschen, sofern welche vorhanden sind
	If ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten] <> 0) Then

		For $i = 0 to $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten] Step 1
			GUICtrlDelete (Eval("_MG_Graph_Achse_unten" & $iGraph & $i))
			GUICtrlDelete (Eval("_MG_Graph_Achse_unten_Strich" & $iGraph & $i))

		Next

		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten] = 0

	EndIf



	; Achsbeschriftungen erzeugen, wenn die Option aktiviert wurde
	If ($bAchse_anzeigen = True) Then


		; diverse Vorberechnungen
		Local $iLabelhoehe 					= $fSchriftgroesse + 2

		Local $fAnzahl_Hauptgitterlinien 	= $MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X]
		Local $fAbstand 					= $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X]

		Local $iY_Pos_Strich 				= ($MG_aGraph[$iGraph][0][$MG_a_iY_Pos] + $MG_aGraph[$iGraph][0][$MG_a_iHoehe]) + $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite]
		Local $iY_Pos_Beschriftung 			= ($MG_aGraph[$iGraph][0][$MG_a_iY_Pos] + $MG_aGraph[$iGraph][0][$MG_a_iHoehe]) + $MG_aGraph[$iGraph][0][$MG_a_iRahmenbreite] + 10

		Local $fWertebereich				= $fMax_Wert - $fMin_Wert
		Local $fWertdifferenz 				= $fWertebereich / $fAnzahl_Hauptgitterlinien

		Local $iCounter = 0


		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten] = 0
		$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten_intervall] = $fIntervall



		; Anzahl und Abstand der Beschriftungen berechnen und anschließend anzeigen
		For $i = 0 to $fAnzahl_Hauptgitterlinien Step $fIntervall

			$iCounter += 1
			$MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten] += 1



			; die Achsenbeschriftung rechts anordnen, wenn der Scrollmodus (Plottmodus = 1) aktiviert wurde
			If ($MG_aGraph[$iGraph][0][$MG_a_iPlottmodus] = 1) Then

				Local $iX_Pos_Strich 		= 	$MG_aGraph[$iGraph][0][$MG_a_iBreite] + $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] - ($fAbstand * $i) - 2
				Local $iX_Pos_Beschriftung 	= 	$MG_aGraph[$iGraph][0][$MG_a_iBreite] + $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] - ($fAbstand * $i) - ($iLabelbreite/2)

			Else ;ansonsten links anordnen

				Local $iX_Pos_Strich 		= $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] + $fAbstand * $i - 2
				Local $iX_Pos_Beschriftung 	= $MG_aGraph[$iGraph][0][$MG_a_iX_Pos] + $fAbstand * $i - ($iLabelbreite/2)

			EndIf



			Local $fWert 					= $fMin_Wert + ($i*$fWertdifferenz)
			Local $vBeschriftung 			=  StringFormat("%." & $iNachkommastellen & "f", $fWert) & $sEinheit

			Assign ("_MG_Graph_Achse_unten_Strich" & $iGraph & $iCounter, GUICtrlCreateLabel("|", $iX_Pos_Strich, $iY_Pos_Strich, 4, 9, BitOR($SS_CENTERIMAGE, $SS_CENTER)),2)
			GUICtrlSetColor		(Eval("_MG_Graph_Achse_unten_Strich" & $iGraph & $iCounter), $vSchriftfarbe)
			GUICtrlSetBkColor	(Eval("_MG_Graph_Achse_unten_Strich" & $iGraph & $iCounter), $vHintergrundfarbe)
			GUICtrlSetFont 		(Eval("_MG_Graph_Achse_unten_Strich" & $iGraph & $iCounter), 9)
			GUICtrlSetResizing  (Eval("_MG_Graph_Achse_unten_Strich" & $iGraph & $iCounter), $GUI_DOCKALL)


			Assign ("_MG_Graph_Achse_unten" & $iGraph & $iCounter, GUICtrlCreateLabel($vBeschriftung, $iX_Pos_Beschriftung, $iY_Pos_Beschriftung, $iLabelbreite, $iLabelhoehe, BitOR($SS_CENTERIMAGE, $SS_CENTER)),2)
			GUICtrlSetColor		(Eval("_MG_Graph_Achse_unten" & $iGraph & $iCounter), $vSchriftfarbe)
			GUICtrlSetBkColor	(Eval("_MG_Graph_Achse_unten" & $iGraph & $iCounter), $vHintergrundfarbe)
			GUICtrlSetFont 		(Eval("_MG_Graph_Achse_unten" & $iGraph & $iCounter), $fSchriftgroesse)
			GUICtrlSetResizing  (Eval("_MG_Graph_Achse_unten" & $iGraph & $iCounter), $GUI_DOCKALL)

		Next

	EndIf



	; Rückgabewert: gibt die Anzahl der Beschriftungen der X-Achse zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten])


EndFunc	;==> _MG_Graph_Achse_unten







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_Achse_unten_update
; Beschreibung ..: 	aktualisiert die Achsbeschriftung auf der unteren Seite (X-Achse)
; Syntax.........:  _MG_Graph_Achse_unten_update ($iGraph, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%")
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;					$fMin_Wert				- der unterste Wert, der angezeigt werden kann
;					$fMax_Wert				- der oberste Wert, der angezeigt werden kann
;					$iNachkommastellen		- die Anzahl der Nachkommastellen, die angezeigt werden sollen (Nachkommastellen werden gerundet)
;					$sEinheit				- die Einheit die angezeigt werden soll (z.B. " sek", " %", " KG", ....)
;
; Rückgabewerte .: 	Erfolg 					| >0	gibt die Anzahl der Beschriftungen der X-Achse zurück
;
;                  	Fehler 					| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;											| -2 	der Abstand der Hauptgitterlinien wurde zu klein gewählt
;
; Autor .........: 	SBond
; Bemerkungen ...:							Die Anzahl und Position der Beschriftungen werden dabei nicht verändert
;
; ========================================================================================================================================================
Func _MG_Graph_Achse_unten_update ($iGraph, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%")

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Abstand der Hauptgitterlinien zu klein gewählt wurde
	If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] < 1) Then Return (-2)


	; diverse Vorberechnungen
	Local $fIntervall 					= $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten_intervall]
	Local $fAnzahl_Hauptgitterlinien 	= $MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X]
	Local $fWertebereich 				= $fMax_Wert - $fMin_Wert
	Local $fWertdifferenz 				= ($fWertebereich * $fIntervall) / $fAnzahl_Hauptgitterlinien



	; neue Einstellungen übernehmen
	For $i = 1 to $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten] Step 1

		Local $fWert 			= $fMin_Wert + (($i-1)*$fWertdifferenz)
		Local $vBeschriftung 	=  StringFormat("%." & $iNachkommastellen & "f", $fWert) & $sEinheit

		GUICtrlSetData (Eval("_MG_Graph_Achse_unten" & $iGraph & $i), $vBeschriftung)

	Next



	; Rückgabewert: gibt die Anzahl der Beschriftungen der X-Achse zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_unten])


EndFunc	;==> _MG_Graph_Achse_unten_update






; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_Achse_links_update
; Beschreibung ..: 	aktualisiert die Achsbeschriftung auf der linken Seite (Y-Achse)
; Syntax.........:  _MG_Graph_Achse_links_update ($iGraph, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%")
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;					$fMin_Wert				- der unterste Wert, der angezeigt werden kann
;					$fMax_Wert				- der oberste Wert, der angezeigt werden kann
;					$iNachkommastellen		- die Anzahl der Nachkommastellen, die angezeigt werden sollen (Nachkommastellen werden gerundet)
;					$sEinheit				- die Einheit die angezeigt werden soll (z.B. " sek", " %", " KG", ....)
;
; Rückgabewerte .: 	Erfolg 					| >0	gibt die Anzahl der Beschriftungen der linken Y-Achse zurück
;
;                  	Fehler 					| -1 	der Graph-Index liegt über dem eingestellten Limit (Anzahl der max. Graphen)
;											| -2 	der Abstand der Hauptgitterlinien wurde zu klein gewählt
;
; Autor .........: 	SBond
; Bemerkungen ...:							Die Anzahl und Position der Beschriftungen werden dabei nicht verändert
;
; ========================================================================================================================================================
Func _MG_Graph_Achse_links_update ($iGraph, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%")

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Abstand der Hauptgitterlinien zu klein gewählt wurde
	If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] < 1) Then Return (-2)


	; diverse Vorberechnungen
	Local $fIntervall 					= $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links_intervall]
	Local $fAnzahl_Hauptgitterlinien 	= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]
	Local $fWertebereich 				= $fMax_Wert - $fMin_Wert
	Local $fWertdifferenz 				= ($fWertebereich * $fIntervall) / $fAnzahl_Hauptgitterlinien



	; neue Einstellungen übernehmen
	For $i = 1 to $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links] Step 1

		Local $fWert 			= $fMin_Wert + (($i-1)*$fWertdifferenz)
		Local $vBeschriftung 	=  StringFormat("%." & $iNachkommastellen & "f", $fWert) & $sEinheit

		GUICtrlSetData(Eval("_MG_Graph_Achse_links" & $iGraph & $i), $vBeschriftung)

	Next



	; Rückgabewert: gibt die Anzahl der Beschriftungen der linken Y-Achse zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_links])


EndFunc	;==> _MG_Graph_Achse_links_update







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_Achse_rechts_update
; Beschreibung ..: 	aktualisiert die Achsbeschriftung auf der rechten Seite (Y-Achse)
; Syntax.........:  _MG_Graph_Achse_rechts_update ($iGraph, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%")
;
; Parameter .....: 	$iGraph 				- Graph-Index, auf dem sich die Einstellungen beziehen
;					$fMin_Wert				- der unterste Wert, der angezeigt werden kann
;					$fMax_Wert				- der oberste Wert, der angezeigt werden kann
;					$iNachkommastellen		- die Anzahl der Nachkommastellen, die angezeigt werden sollen (Nachkommastellen werden gerundet)
;					$sEinheit				- die Einheit die angezeigt werden soll (z.B. " sek", " %", " KG", ....)
;
; Rückgabewerte .: 	Erfolg 					| >0	gibt die Anzahl der Beschriftungen der rechten Y-Achse zurück
;
;                  	Fehler 					| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;											| -2 	der Abstand der Hauptgitterlinien wurde zu klein gewählt
;
; Autor .........: 	SBond
; Bemerkungen ...:							Die Anzahl und Position der Beschriftungen werden dabei nicht verändert
;
; ========================================================================================================================================================
Func _MG_Graph_Achse_rechts_update ($iGraph, $fMin_Wert = 0, $fMax_Wert = 100, $iNachkommastellen = 1, $sEinheit = "%")

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Abstand der Hauptgitterlinien zu klein gewählt wurde
	If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] < 1) Then Return (-2)


	; diverse Vorberechnungen
	Local $fIntervall 					= $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts_intervall]
	Local $fAnzahl_Hauptgitterlinien 	= $MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y]
	Local $fWertebereich 				= $fMax_Wert - $fMin_Wert
	Local $fWertdifferenz 				= ($fWertebereich * $fIntervall) / $fAnzahl_Hauptgitterlinien



	; neue Einstellungen übernehmen
	For $i = 1 to $MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts] Step 1

		Local $fWert = $fMin_Wert + (($i-1)*$fWertdifferenz)
		Local $vBeschriftung =  StringFormat("%." & $iNachkommastellen & "f", $fWert) & $sEinheit

		GUICtrlSetData(Eval("_MG_Graph_Achse_rechts" & $iGraph & $i), $vBeschriftung)

	Next



	; Rückgabewert: gibt die Anzahl der Beschriftungen der rechten Y-Achse zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iAchsbeschriftungen_rechts])


EndFunc	;==> _MG_Graph_Achse_rechts_update







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_plotten
; Beschreibung ..: 	plottet die neuen Werte in den Graphen und aktualisiert ggf. die Darstellung in der GUI (je nach Einstellungen)
; Syntax.........:  _MG_Graph_plotten ($iGraph)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;
; Rückgabewerte .: 	Erfolg 		| >=0	gibt die aktuelle Plottposition zurück (max. Wert = Breite des Graphen)
;
;                  	Fehler 		| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;								| -2 	der Graph ist deaktiviert
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_plotten ($iGraph)


	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Graph deaktiviert ist
	If ($MG_aGraph[$iGraph][0][$MG_a_bGraph_aktiviert] = False) Then Return (-2)



	; ##################################################### Plottmodus 1: "stehender Graph" #####################################################

	If ($MG_aGraph[$iGraph][0][$MG_a_iPlottmodus] = 0) Then



		; Wenn Clearmodus = 1:  löscht an der aktuellen Plottposition die alten Werte aus dem Graphen, bevor die neuen Werte geplottet werden
		If ($MG_aGraph[$iGraph][0][$MG_a_iClearmodus] = 1) Then


			; den Löschbereich und die Füllfarbe definieren
			Local $hBrush_temp 	= _GDIPlus_BrushCreateSolid (0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])
			Local $iX_Pos 		= $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] + 2
			Local $iBreite 		= $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse] + 2


			; den Löschbereich neu definieren, wenn sich die aktuelle Plottposition am Anfang des Graphen befindet
			If ($MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] <= 2) Then
				$iX_Pos = $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] - 1
				$iBreite = $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse] + 4
			EndIf


			; löschen der alten geplotteten Werte im Löschbereich
			_GDIPlus_GraphicsFillRect($MG_aGraph[$iGraph][0][$MG_a_hBuffer],$iX_Pos, 0 ,$iBreite, $MG_aGraph[$iGraph][0][$MG_a_iHoehe], $hBrush_temp)


			; Gitterlinien im Löschbereich neu zeichnen
			_MG_Graph_Hauptgitterlinien_plotten($iGraph, 1)
			_MG_Graph_Hilfsgitterlinien_plotten($iGraph, 1)


			; die GDI+ Resourcen wieder freigeben
			_GDIPlus_BrushDispose ($hBrush_temp)

		EndIf







		; die Werte der einzelnen Kanäle plotten
		For $iKanal = 1 To $MG_iMax_Anzahl_Kanaele Step 1


			; prüfen, welche Kanäle geplottet werden sollen
			If ($MG_aGraph[$iGraph][$iKanal][$MG_k_bKanal_aktivieren] = True) Then


				; Werte plotten (interpoliert)
				If ($MG_aGraph[$iGraph][0][$MG_a_bInterpolation] = True) Then

					; direkte Linie zwischen den Punkten zeichnen
					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _																; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] - $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse], _	; Position 1: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell], _														; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert], _												; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])																; handle zum Zeichenstift



				Else ; Werte plotten (nicht interpoliert)


					; die horizontale Linie zeichen
					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _																; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] - $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse], _	; Position 1: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell], _ 														; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])																; handle zum Zeichenstift

					; die vertikale Linie zeichen
					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _																; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell], _														; Position 1: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell], _														; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert], _												; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])																; handle zum Zeichenstift

				EndIf

				; aktuellen Punkt für den nächsten Plottvorgang speichern
				$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert] = $MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert]

			EndIf


		Next







		; ggf. die geplotteten Werte in der GUI darstellen
		If ($MG_aGraph[$iGraph][0][$MG_a_iPlottfrequenz] > 0) Then


			If ($MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter] = $MG_aGraph[$iGraph][0][$MG_a_iPlottfrequenz]) Then

				_GDIPlus_GraphicsDrawImageRect ($MG_aGraph[$iGraph][0][$MG_a_hGraphic], _		; handle zum Grafik-Objekt
												$MG_aGraph[$iGraph][0][$MG_a_hBitmap], _ 		; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iX_Pos], _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
												$MG_aGraph[$iGraph][0][$MG_a_iY_Pos], _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
												$MG_aGraph[$iGraph][0][$MG_a_iBreite], _		; die Breite des Graphen
												$MG_aGraph[$iGraph][0][$MG_a_iHoehe])			; die Höhe des Graphen

				$MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter] = 0

			Else

				$MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter] += 1

			EndIf

		EndIf







		; die geplotteten Werte in der GUI darstellen, sobald der Zeichenbereich komplett ist und die Plottposition wieder auf Null setzen
		If ($MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] > $MG_aGraph[$iGraph][0][$MG_a_iBreite]) Then

			$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] = 0

			_GDIPlus_GraphicsDrawImageRect ($MG_aGraph[$iGraph][0][$MG_a_hGraphic], _		; handle zum Grafik-Objekt
											$MG_aGraph[$iGraph][0][$MG_a_hBitmap], _ 		; handle zum Grafik-Buffer
											$MG_aGraph[$iGraph][0][$MG_a_iX_Pos], _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
											$MG_aGraph[$iGraph][0][$MG_a_iY_Pos], _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
											$MG_aGraph[$iGraph][0][$MG_a_iBreite], _		; die Breite des Graphen
											$MG_aGraph[$iGraph][0][$MG_a_iHoehe])			; die Höhe des Graphen



			; Wenn Clearmodus = 2:  löscht alle geplotteten Werte aus dem Buffer
			If ($MG_aGraph[$iGraph][0][$MG_a_iClearmodus] = 2) Then

				_GDIPlus_GraphicsClear ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], 0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])

				; Gitterlinien neu zeichnen
				_MG_Graph_Hauptgitterlinien_plotten($iGraph, 0)
				_MG_Graph_Hilfsgitterlinien_plotten($iGraph, 0)

			EndIf



			; die alten Werte der Kanäle löschen
			For $iKanal = 1 To $MG_iMax_Anzahl_Kanaele Step 1

				; prüfen, welche Kanäle aktiviert sind
				If ($MG_aGraph[$iGraph][$iKanal][$MG_k_bKanal_aktivieren] = True) Then

					$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert] = ""

				EndIf

			Next




		Else ; ...ansonsten die aktuelle Plottposition weiter verschieben

			$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] += $MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse]

		EndIf







	; ##################################################### Plottmodus 2: "bewegter Graph" #####################################################
	ElseIf ($MG_aGraph[$iGraph][0][$MG_a_iPlottmodus] = 1) Then


		; den zu verschiebenen Teil des Graphen kopieren
		Local $hVerschiebung = _GDIPlus_BitmapCloneArea($MG_aGraph[$iGraph][0][$MG_a_hBitmap], _				; handle zum Bitmap-Objekt
														$MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse], _		; X-Koordinate des Kopierbereiches (linke, obere Ecke)
														0, _													; Y-Koordinate des Kopierbereiches (linke, obere Ecke)
														$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung], _			; die Breite des Kopierbereiches
														$MG_aGraph[$iGraph][0][$MG_a_iHoehe])					; die Höhe des Kopierbereiches


		; den Buffer komplett löschen
		_GDIPlus_GraphicsClear($MG_aGraph[$iGraph][0][$MG_a_hBuffer], 0xFF000000 + $MG_aGraph[$iGraph][0][$MG_a_vHintergrundfarbe])


		; den kopierten Teil des Graphen in den Buffer schreiben
		_GDIPlus_GraphicsDrawImageRect($MG_aGraph[$iGraph][0][$MG_a_hBuffer], $hVerschiebung, 0, 0, $MG_aGraph[$iGraph][0][$MG_a_iVerschiebung], $MG_aGraph[$iGraph][0][$MG_a_iHoehe])





		; die Werte der einzelnen Kanäle plotten
		For $iKanal = 1 To $MG_iMax_Anzahl_Kanaele Step 1


			; prüfen, welche Kanäle geplottet werden sollen
			If ($MG_aGraph[$iGraph][$iKanal][$MG_k_bKanal_aktivieren] = True) Then


				; Werte plotten (interpoliert)
				If ($MG_aGraph[$iGraph][0][$MG_a_bInterpolation] = True) Then


					; direkte Linie zwischen den Punkten zeichnen
					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _																; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]-1, _														; Position 1: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iBreite]-1, _																; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert], _												; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])																; handle zum Zeichenstift



				Else ; Werte plotten (nicht interpoliert)


					; die horizontale Linie zeichen
					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _																; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]-1, _														; Position 1: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iBreite]-1, _																; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])																; handle zum Zeichenstift

					; die vertikale Linie zeichen
					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _																; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iBreite]-1, _																; Position 1: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert], _													; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iBreite]-1, _																; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert], _												; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])																; handle zum Zeichenstift

				EndIf

				; aktuellen Punkt für den nächsten Plottvorgang speichern
				$MG_aGraph[$iGraph][$iKanal][$MG_k_fY_letzter_Wert] = $MG_aGraph[$iGraph][$iKanal][$MG_k_fY_aktueller_Wert]

			EndIf

		Next


		; ggf. Gitterlinien zeichnen
		_MG_Graph_Hauptgitterlinien_plotten($iGraph, 2)
		_MG_Graph_Hilfsgitterlinien_plotten($iGraph, 2)



		; ggf. die geplotteten Werte in der GUI darstellen
		If ($MG_aGraph[$iGraph][0][$MG_a_iPlottfrequenz] > 0) Then

			If ($MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter] = $MG_aGraph[$iGraph][0][$MG_a_iPlottfrequenz]) Then

				_GDIPlus_GraphicsDrawImageRect ($MG_aGraph[$iGraph][0][$MG_a_hGraphic], _		; handle zum Grafik-Objekt
												$MG_aGraph[$iGraph][0][$MG_a_hBitmap], _ 		; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iX_Pos], _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
												$MG_aGraph[$iGraph][0][$MG_a_iY_Pos], _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
												$MG_aGraph[$iGraph][0][$MG_a_iBreite], _		; die Breite des Graphen
												$MG_aGraph[$iGraph][0][$MG_a_iHoehe])			; die Höhe des Graphen

				$MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter] = 0

			Else

				$MG_aGraph[$iGraph][0][$MG_a_iPlott_Counter] += 1

			EndIf

		EndIf





		; die geplotteten Werte in der GUI darstellen, sobald der Zeichenbereich komplett ist und die Plottposition wieder auf Null setzen
		If ($MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] > $MG_aGraph[$iGraph][0][$MG_a_iBreite]) Then

			$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] = 0

			_GDIPlus_GraphicsDrawImageRect ($MG_aGraph[$iGraph][0][$MG_a_hGraphic], _		; handle zum Grafik-Objekt
											$MG_aGraph[$iGraph][0][$MG_a_hBitmap], _ 		; handle zum Grafik-Buffer
											$MG_aGraph[$iGraph][0][$MG_a_iX_Pos], _			; X-Koordinate des Zeichenbereiches (linke, obere Ecke)
											$MG_aGraph[$iGraph][0][$MG_a_iY_Pos], _			; Y-Koordinate des Zeichenbereiches (linke, obere Ecke)
											$MG_aGraph[$iGraph][0][$MG_a_iBreite], _		; die Breite des Graphen
											$MG_aGraph[$iGraph][0][$MG_a_iHoehe])			; die Höhe des Graphen


		Else ; ...ansonsten die aktuelle Plottposition weiter verschieben --> dient in diesem Fall nur als Counter, da sich die Plottposition immer am Ende des Zeichenbereiches befindet

			$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell] += int($MG_aGraph[$iGraph][0][$MG_a_fInkrement_groesse])

		EndIf



		; die GDI+ Resourcen wieder freigeben
		_GDIPlus_BitmapDispose($hVerschiebung)

	EndIf




	; gibt die aktuelle Plottposition zurück
	Return ($MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell])


EndFunc	;==> _MG_Graph_plotten







; #INTERNAL_USE_ONLY# ;===================================================================================================================================
;
; Name...........:	_MG_Graph_Hauptgitterlinien_plotten
; Beschreibung ..:  zeichnet die Hauptgitterlinien in den Graphen ein
; Syntax.........:  _MG_Graph_Hauptgitterlinien_plotten ($iGraph, $iModus = 0)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;					$iModus		- zeichnet die Hauptgitterlinien in bestimmten Bereichen ein
;								| 0		zeichnet die Hauptgitterlinien in den gesamten Zeichenbereich des Graphen
;								| 1		zeichnet die Hauptgitterlinien nur an der aktuellen Plottposition des Graphen
;								| 2		zeichnet die Hauptgitterlinien nur an der letzen Plottposition des Graphen (für den Modus: "bewegter Graph")
;
; Rückgabewerte .: 	Erfolg 		| 0
;
;                  	Fehler 		| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_Hauptgitterlinien_plotten ($iGraph, $iModus = 0)


	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)



	; zeichnet die Hauptgitterlinien in den gesamten Zeichenbereich des Graphen
	If ($iModus = 0) AND ($MG_aGraph[$iGraph][0][$MG_a_bHauptgitter_aktiviert] = True) Then



		; zeichnet die vertikalen Hauptgitterlinien ein
		If Not ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] < 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $i * $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] - 1

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											$iLinie, _																		; Position 1: X-Koordinate
											0, _																			; Position 1: Y-Koordinate
											$iLinie, _																		; Position 2: X-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iHoehe], _											; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])									; handle zum Zeichenstift

			Next

		EndIf



		; zeichnet die horizontalen Hauptgitterlinien ein
		If Not ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] < 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y])

			For $i=1 to $iAnzahl_Linien Step 1

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - ($i * $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y])

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											0, _																			; Position 1: X-Koordinate
											$iLinie, _																		; Position 1: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iBreite], _										; Position 2: X-Koordinate
											$iLinie, _																		; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])									; handle zum Zeichenstift

			Next

		EndIf



	; zeichnet die Hauptgitterlinien nur an der aktuellen Plottposition des Graphen
	ElseIf ($iModus = 1) AND ($MG_aGraph[$iGraph][0][$MG_a_bHauptgitter_aktiviert] = True) Then



		; zeichnet die vertikalen Hauptgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] >= 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $i * $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] - 1

				If ($iLinie >= $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker]) AND ($iLinie < $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]) Then

					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _									; handle zum Grafik-Buffer
												$iLinie, _																	; Position 1: X-Koordinate
												0, _																		; Position 1: Y-Koordinate
												$iLinie, _																	; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iHoehe], _										; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])								; handle zum Zeichenstift

				EndIf

			Next

		EndIf



		; zeichnet die horizontalen Hauptgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] >= 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - ($i * $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y])

				If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker] < $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]) Then

					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _									; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker], _						; Position 1: X-Koordinate
												$iLinie, _																	; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell], _							; Position 2: X-Koordinate
												$iLinie, _																	; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])								; handle zum Zeichenstift

				EndIf

			Next

		EndIf

		$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker] = $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]




	; zeichnet die Hauptgitterlinien nur an der letzen Plottposition des Graphen (für den Modus: "bewegter Graph")
	ElseIf ($iModus = 2) AND ($MG_aGraph[$iGraph][0][$MG_a_bHauptgitter_aktiviert] = True) Then



		; zeichnet die vertikalen Hauptgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X] >= 1) Then

			While ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker] >= $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X])

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iBreite] - (1 + $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker] - $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X])

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											$iLinie, _																		; Position 1: X-Koordinate
											0, _																			; Position 1: Y-Koordinate
											$iLinie, _																		; Position 2: X-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iHoehe], _											; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])									; handle zum Zeichenstift


				$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker] -= $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_X]

			WEnd

			$MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_Merker] += $MG_aGraph[$iGraph][0][$MG_a_iBreite] - $MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]

		EndIf



		; zeichnet die horizontalen Hauptgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y] >= 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - ($i * $MG_aGraph[$iGraph][0][$MG_a_iHauptgitter_abstand_Y])

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung], _									; Position 1: X-Koordinate
											$iLinie, _																		; Position 1: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iBreite], _										; Position 2: X-Koordinate
											$iLinie, _																		; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])									; handle zum Zeichenstift

			Next

		EndIf


	EndIf


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_Hauptgitterlinien_plotten







; #INTERNAL_USE_ONLY# ;===================================================================================================================================
;
; Name...........:	_MG_Graph_Hilfsgitterlinien_plotten
; Beschreibung ..:  zeichnet die Hilfsgitterlinien in den Graphen ein
; Syntax.........:  _MG_Graph_Hilfsgitterlinien_plotten ($iGraph, $iModus = 0)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;					$iModus		- zeichnet die Hilfsgitterlinien in bestimmten Bereichen ein
;								| 0		zeichnet die Hilfsgitterlinien in den gesamten Zeichenbereich des Graphen
;								| 1		zeichnet die Hilfsgitterlinien nur an der aktuellen Plottposition des Graphen
;								| 2		zeichnet die Hilfsgitterlinien nur an der letzen Plottposition des Graphen (für den Modus: "bewegter Graph")
;
; Rückgabewerte .: 	Erfolg 		| 0
;
;                  	Fehler 		| -1 	der Graph-Index liegt außerhalb des gültigen Bereichs
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_Hilfsgitterlinien_plotten ($iGraph, $iModus = 0)


	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)



	; zeichnet die Hilfsgitterlinien in den gesamten Zeichenbereich des Graphen
	If ($iModus = 0) AND ($MG_aGraph[$iGraph][0][$MG_a_bHilfsgitter_aktiviert] = True) Then



		; zeichnet die vertikalen Hilfsgitterlinien ein
		If Not ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X] < 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $i * $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X] - 1

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											$iLinie, _																		; Position 1: X-Koordinate
											0, _																			; Position 1: Y-Koordinate
											$iLinie, _																		; Position 2: X-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iHoehe], _											; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])									; handle zum Zeichenstift

			Next

		EndIf



		; zeichnet die horizontalen Hilfsgitterlinien ein
		If Not ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y] < 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y])

			For $i=1 to $iAnzahl_Linien Step 1

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - ($i * $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y])

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											0, _																			; Position 1: X-Koordinate
											$iLinie, _																		; Position 1: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iBreite], _										; Position 2: X-Koordinate
											$iLinie, _																		; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])									; handle zum Zeichenstift

			Next

		EndIf



	; zeichnet die Hilfsgitterlinien nur an der aktuellen Plottposition des Graphen
	ElseIf ($iModus = 1) AND ($MG_aGraph[$iGraph][0][$MG_a_bHilfsgitter_aktiviert] = True) Then



		; zeichnet die vertikalen Hilfsgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X] >= 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iBreite] / $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $i * $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X] - 1

				If ($iLinie >= $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker]) AND ($iLinie < $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]) Then

					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _									; handle zum Grafik-Buffer
												$iLinie, _																	; Position 1: X-Koordinate
												0, _																		; Position 1: Y-Koordinate
												$iLinie, _																	; Position 2: X-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iHoehe], _										; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])								; handle zum Zeichenstift

				EndIf

			Next

		EndIf



		; zeichnet die horizontalen Hilfsgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y] >= 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - ($i * $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y])

				If ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker] < $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]) Then

					_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _									; handle zum Grafik-Buffer
												$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker], _						; Position 1: X-Koordinate
												$iLinie, _																	; Position 1: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell], _							; Position 2: X-Koordinate
												$iLinie, _																	; Position 2: Y-Koordinate
												$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])								; handle zum Zeichenstift

				EndIf

			Next

		EndIf

		$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker] = $MG_aGraph[$iGraph][0][$MG_a_iPosition_aktuell]




	; zeichnet die Hilfsgitterlinien nur an der letzen Plottposition des Graphen (für den Modus: "bewegter Graph")
	ElseIf ($iModus = 2) AND ($MG_aGraph[$iGraph][0][$MG_a_bHilfsgitter_aktiviert] = True) Then



		; zeichnet die vertikalen Hilfsgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X] >= 1) Then

			While ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker] >= $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X])

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iBreite] - (1 + $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker] - $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X])

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											$iLinie, _																		; Position 1: X-Koordinate
											0, _																			; Position 1: Y-Koordinate
											$iLinie, _																		; Position 2: X-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iHoehe], _											; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])									; handle zum Zeichenstift


				$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker] -= $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_X]

			WEnd

			$MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_Merker] += $MG_aGraph[$iGraph][0][$MG_a_iBreite] - $MG_aGraph[$iGraph][0][$MG_a_iVerschiebung]

		EndIf



		; zeichnet die horizontalen Hilfsgitterlinien ein
		If ($MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y] >= 1) Then

			Local $iAnzahl_Linien = Int($MG_aGraph[$iGraph][0][$MG_a_iHoehe] / $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y])

			For $i = 1 to $iAnzahl_Linien Step 1

				Local $iLinie = $MG_aGraph[$iGraph][0][$MG_a_iHoehe] - ($i * $MG_aGraph[$iGraph][0][$MG_a_iHilfsgitter_abstand_Y])

				_GDIPlus_GraphicsDrawLine  ($MG_aGraph[$iGraph][0][$MG_a_hBuffer], _										; handle zum Grafik-Buffer
											$MG_aGraph[$iGraph][0][$MG_a_iVerschiebung], _									; Position 1: X-Koordinate
											$iLinie, _																		; Position 1: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_iBreite], _										; Position 2: X-Koordinate
											$iLinie, _																		; Position 2: Y-Koordinate
											$MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])									; handle zum Zeichenstift

			Next

		EndIf


	EndIf


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_Hilfsgitterlinien_plotten







; #FUNCTION# ;============================================================================================================================================
;
; Name...........:	_MG_Graph_entfernen
; Beschreibung ..: 	löscht den Graphen aus der GUI
; Syntax.........: 	_MG_Graph_entfernen ($iGraph)
;
; Parameter .....: 	$iGraph 	- Graph-Index, auf dem sich die Einstellungen beziehen
;
; Rückgabewerte .: 	Erfolg 		|  0
;
;                  	Fehler 		| -1 der Graph-Index liegt außerhalb des gültigen Bereichs
;								| -2 der Graph ist schon deaktiviert
;
; Autor .........: 	SBond
; Bemerkungen ...:  Wichtig: der Graphindex beginnt bei 1. Der Index 0 ist reserviert und sollte nicht verwendet werden.
;
; ========================================================================================================================================================
Func _MG_Graph_entfernen ($iGraph)

	; Fehler, wenn der Graph-Index außerhalb des gültigen Bereichs liegt
	If ($iGraph > $MG_iMax_Anzahl_Graphen) OR ($iGraph <= 0) Then Return (-1)


	; Fehler, wenn der Graph schon deaktiviert ist
	If ($MG_aGraph[$iGraph][0][$MG_a_bGraph_aktiviert] = False) Then Return (-2)



	; Graphen deaktivieren
	$MG_aGraph[$iGraph][0][$MG_a_bGraph_aktiviert]	= False


	; Rahmen und Beschriftungen löschen
	_MG_Graph_optionen_Rahmen 	($iGraph, False, 0x000000, 1)
	_MG_Graph_Achse_unten 		($iGraph, False)
	_MG_Graph_Achse_links 		($iGraph, False)
	_MG_Graph_Achse_rechts 		($iGraph, False)


	; die GDI+ Resourcen wieder freigeben
	_GDIPlus_GraphicsDispose ($MG_aGraph[$iGraph][0][$MG_a_hGraphic])
	_GDIPlus_GraphicsDispose ($MG_aGraph[$iGraph][0][$MG_a_hBuffer])
	_GDIPlus_BitmapDispose 	 ($MG_aGraph[$iGraph][0][$MG_a_hBitmap])

	_GDIPlus_PenDispose		 ($MG_aGraph[$iGraph][0][$MG_a_hHauptgitter_Pen])
	_GDIPlus_PenDispose		 ($MG_aGraph[$iGraph][0][$MG_a_hHilfsgitter_Pen])


	For $iKanal = 1 To $MG_iMax_Anzahl_Kanaele Step 1

		_GDIPlus_PenDispose ($MG_aGraph[$iGraph][$iKanal][$MG_k_hPen])

	Next


	; Rückgabewert: Erfolgreich
	Return (0)


EndFunc	;==> _MG_Graph_entfernen






; #INTERNAL_USE_ONLY# ;===================================================================================================================================
;
; Name...........:	_MG_Graph_Herunterfahren
; Beschreibung ..:  gibt die GDI+ Resourcen beim Beenden wieder frei
; Syntax.........: 	_MG_Graph_Herunterfahren ()
;
; Parameter .....:
;
; Rückgabewerte .:
;
; Autor .........: 	SBond
; Bemerkungen ...:
;
; ========================================================================================================================================================
Func _MG_Graph_Herunterfahren ()

	; die GDI+ Resourcen wieder freigeben
	For $i = 1 to $MG_iMax_Anzahl_Graphen

		_MG_Graph_entfernen ($i)

	Next

	_GDIPlus_Shutdown ()

EndFunc	;==> _MG_Graph_Herunterfahren