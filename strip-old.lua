-- ** Stripmining Programm **
-- ** © 2013 SemOnLP       **
-- **************************

--start: block der verhindert das der hautpfad unterborchen wird
function Sicherheitspfad()
	if turtle.detectDown() == false then -- wen kein block unter der turel ist
		turtle.select(1) -- slot 1 auswaehlen
    	turtle.placeDown() -- und unter die turel setzten
	end
end
--end: block der verhindert das der hautpfad unterborchen wird

--start: hier wird der Hauptgang gegraben
function Mittelgang()
	NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	Sicherheitspfad() -- wird nur im Hauptgang gemacht, prueft ob unter der Turtel ein Block ist wen nein setzt sie einen aus slot 1
	KiesUp() -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt

	NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	Sicherheitspfad() -- wird nur im Hauptgang gemacht, prueft ob unter der Turtel ein Block ist wen nein setzt sie einen aus slot 1
	KiesUp() -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt

	Fackel() -- fackel auf der rechten seite setzten
	NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	Sicherheitspfad() -- wird nur im Hauptgang gemacht, prueft ob unter der Turtel ein Block ist wen nein setzt sie einen aus slot 1
	KiesUp() -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt
end
--end: hier wird der Hauptgang gegraben

--start: baut einen Seitengang
function Seitengang()
	for b = 0, 4, 1 do -- grabe dich in den gang
		NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
		KiesUp() -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt
	end
	
	turtle.turnRight() -- umdrehen
	turtle.turnRight() -- umdrehen
	for b = 0, 4, 1 do -- komm zur mitte zurueck
		NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	end
end
--end: baut einen Seitengang

--start: geht 1 block nach vorne
function NachVorne()
	while turtle.detect() do -- prueft ob ein block vor der turel ist
		turtle.dig()
		sleep(0.25)
	end
	
	while(turtle.forward() == false) do --wenn er nicht fahren konnte
		turtle.dig()  -- einmal abbauen
		turtle.attack() -- einmal zuschlagen
	end
end
--end: geht 1 block nach vorne

--start: beim abbauen uebersich ob kies nachfaell, wen ja solange abbauen bis nichts mehr kommt
function KiesUp()
	while turtle.detectUp() do -- prueft ob ueber ihm noch etwas ist 
		turtle.digUp() -- haut den block ueber sich ab
		sleep(0.25) -- wartet, funktioniert nur wen der block direck nachfaellt ist ein block 
	end
end
--end: beim abbauen uebersich ob kis nachfaell, wen ja solange abbauen bis nichts mehr kommt

--start: plaziert die Fackel
function Fackel()
	if (turtle.back()) then-- plaziert die fackel wen er 1 block zurueck fahren konnte
		turtle.select(16) -- waehlt die Fackeln aus
		turtle.placeUp() -- plaziert die Fackel ueber sich
		NachVorne() -- geht wieder nach vorne
	end
	turtle.select(1) -- waehlt wieder slot 1 oder den ersten der dan frei ist
end
--end: plaziert die Fackel

--start: Steuerung fuer Hauptgang und Seitengang
function Strip()
	Mittelgang() -- hier wird der Hauptgang gegraben
	turtle.turnRight() -- startposition fuer die linke seite 
	Seitengang() -- graebt den ersten seitengang und kommt zurueck zur mitte
	Seitengang() -- graebt den zweiten seitengang und kommt zurueck zur mitte
end
--end: Steuerung fuer Hauptgang und Seitengang

--start: entleere das inventar in die endertruhe
function enderTruhe()
	if (endertruhe == 0) then -- wen keine kiste ausgewaehlt ist nicht in endertruhe leeren
		return
	end
	while turtle.detect() do -- die Truhe braucht platz um hingestell werden zu koennen also wird solange gegraben bis platz da ist
		turtle.dig()
		sleep(0.5)
	end
	turtle.select(15) -- Truhe auswaehlen
	turtle.place() -- Truhe plazieren
	for k = 1,14 do -- k dient hier als zaehler um jeden platz leer zu machen
		turtle.select(k)
		if turtle.getItemCount(k) == 0 then
			break -- hier wird abgebrochen wenn der slot leer ist 
			      -- eine schneller entladung der kist ist somit gegeben ^^
		end
		turtle.drop() -- legt die items in aus dem slot in die truhe
	end
	turtle.select(15) -- waehlt slot 15 aus 
	turtle.dig() -- und nimmt die truhe wieder auf
	turtle.select(1) -- waehlt wieder slot 1 oder den ersten der dan frei ist
end
--end: entleere das inventar in die endertruhe

--start: graebt den Tunnel solange wie eingegeben wurde
function tunnel()
	bildschirmRun() -- bereinigt den Bildschirm beim Start des Tunnelgrabens
	kistenabstand = 3 -- nach diesem gang wird das 1 mal die truhe geleert
	for aktuellergang = 1, ganganzahl, 1 do -- schleife die soviele gaenge macht wie eingeben
		Strip() -- hier wird der hauptgang mit einem Tunnel links und rechts gegraben
		-- entwerder nur nach links drehen oder nach links drehen und die kiste setzten
		if (aktuellergang  == kistenabstand and aktuellergang ~= ganganzahl) then
			turtle.turnLeft() -- gehe einmal nach links 
			kistenabstand = kistenabstand + 3 -- kistenabstand wieder 3 hoch
			enderTruhe() -- entleer die in die Enertrue
		elseif (aktuellergang  == ganganzahl) then -- letzter gang nach rechts gehen und in die Truhe entlehren
			turtle.turnRight() -- zurueck in gang drehen fuer die fahrt zur Ausgangsposition
			enderTruhe() -- es war der letzte gang, sprich stell die kist das letzte mal und entleeren
		else 
			turtle.turnLeft() -- gehe nur einmal nach lings und mach mit dem hauptgan weiter
		end
		statusBildschirm(aktuellergang) -- Aktuallisierung des Bildschirms wenn ein Gang gegraben wurde (aktuellergang muss uebergeben werden)
	end
end
--end: graebt den Tunnel solange wie eingegeben wurde

--start: Zurueck zur Ausgangsposition
function back()
	for a = 1,ganganzahl * 3 do
		NachVorne()
	end
end
--end: Zurueck zur Ausgangsposition

--start: Aktuallisierung des Bildschirms wenn ein Gang gegraben wurde
function statusBildschirm(aktuellergang)
	-- start: Zeigt das Fuel-Level an
	term.setCursorPos( 1, 3)
	term.clearLine()
	fuellevel = turtle.getFuelLevel()
	print("Fuel-Level: " .. fuellevel)
	
	-- start: Zeigt die anzahl der Fakeln an
	term.setCursorPos( 1, 5)
	term.clearLine()
	fackeln = turtle.getItemCount(16)
	print("Fackeln   : " .. fackeln)
	
	term.setCursorPos(1,7)
	term.clearLine()
	print("Gang " .. aktuellergang .. " von " .. ganganzahl .. " wurde fertiggestellt!")
end
--end: Aktuallisierung des Bildschirms wenn ein Gang gegraben wurde


--START: Programmsteuerung eingabe
--start: Aktuellisuerung des Status fuer Fakeln, Endertruhe, und Fullevel
local function checkStatus()
	local blink = 0 -- wird benoetigt fuer das blinken der Warnung das das Fuellevel nidrig ist
	while true do --prueft endlos den status
		time() -- zeit die Uhrzeit oben rechts an

		-- start: Zeigt das Fuel-Level an
		term.setCursorPos( 1, 3)
		term.clearLine()
		fuellevel = turtle.getFuelLevel()
		if (fuellevel < 500 and blink == 0) then
  			print("Fuel-Level: " .. fuellevel .. " !! Warnung !!")
  			blink = 1 -- setz blinken der Warnung zurueck
		else
			print("Fuel-Level: " .. fuellevel)
			blink = 0 -- setz blinken der Warnung zurueck
		end
		-- end: Zeigt das Fuel-Level an
		-- start: Zeigt die aufladung des Fuel-Level an
		term.setCursorPos( 1, 7)
		term.clearLine()
		term.clearLine()
		ladeeinheiten = turtle.getItemCount(13) -- Einheiten zum Aufladen aus slot 13
		if (ladeeinheiten == 1) then
			print("Hinweis: Fuelaufladung um eine Einheit")
		elseif (ladeeinheiten > 1) then 
			print("Hinweis: Fuelaufladung um " .. ladeeinheiten .. " Einheiten")
		end
		-- end: Zeigt die aufladung des Fuel-Level an
		
		-- start: Pruefung fuer die Endertruhe
		term.setCursorPos( 1, 4)
		term.clearLine()
		endertruhe = turtle.getItemCount(15)
		if (endertruhe == 1) then
			print("Endertruhe: Ja")
			endertruhe = 1 --braucht man nicht ist nur zur sicherheit
		elseif (endertruhe > 1) then
			print("Endertruhe: Bitte nur 1 Kiste")
			endertruhe = 0
		else
			print("Endertruhe: Nein")
			endertruhe = 0
		end		
		-- end: Pruefung fuer die Endertruhe
		
		-- start: Zeigt die anzahl der Fakeln an
		term.setCursorPos( 1, 5)
		term.clearLine()
		fackeln = turtle.getItemCount(16)
		if (fackeln == 0) then
			print("Fackeln   : Keine")
		elseif (fackeln == 1) then
			print("Fackeln   : " .. fackeln .. " (Eingabe 0 = ein Gang)")
		else
			print("Fackeln   : " .. fackeln .. " (Eingabe 0 = " .. fackeln .." Gaenge)")
		end
		-- end: Zeigt die anzahl der Fakeln an
		
		term.setCursorPos(36, 12) -- setzt angezeigte curser zurueck zur eingabe
		sleep(0.4) -- minecraft minute dauert 0.8 Sekunden 
	end
end
--end: Aktuellisuerung des Status fuer Fakeln, Endertruhe, und Fullevel

--start: Eingabe der Fackeln und Pruefung ob 0 oder zwischen 1 und 999
local function eingabeTunnellaenge()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Anzahl Gaenge? (0 = Fackelanzahl) :") -- anzeige des Hilfetextes
		term.setCursorPos(36, 12) -- setzt position auf eingabe
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	ganganzahl = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (ganganzahl >= 0 and ganganzahl <= 999) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (ganganzahl == 0) then 
					ganganzahl = fackeln
			    end
				return -- wenn alles ok ist, beende die eingabe
			end
		end
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		print("0 = Fakelanzahl oder 1-999 moeglich")
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: Eingabe der Fackeln und Pruefung ob 0 oder zwischen 1 und 999

--start: Uhrzeit und Tag in Minecraft auslesen und anzeigen
function time()
	term.setCursorPos( 29, 1) -- position auf Zeit setzten
	local day -- locale Variable fuer den Tag in Minecraft
	local zeit -- locale Variable fuer die Uhrzeit in Minecraft
	day = os.day() -- nicht im Gebrauch!
	zeit = textutils.formatTime(os.time(), true) -- wandelt die anzeige in das 24 Stunden Format
	if (string.len(zeit) == 4) then -- zeit Anzeigt vor oder nach 10 Uhr
		print("Zeit:  " .. zeit) -- vor 10 Uhr, es geht um die laenge
	else
		print("Zeit: " .. zeit) -- nach 10 Uhr
	end
end
--start: Uhrzeit und Tag in Minecraft auslesen und anzeigen
--end: Programmsteuerung eingabe

--start: bereinigt den Bildschirm und baut das eingabe Fenster auf
function bildschirmStart()
	shell.run("clear") -- lÃƒÂ¶scht allties auf dem Bildschirm
	print("Systemhinweis")
	print("=======================================")
	term.setCursorPos(1,6)
	term.clearLine()
	print("---------------------------------------")
	term.setCursorPos(1,11)
	print("---------------------------------------")
end
--end: bereinigt den Bildschirm und baut das eingabe Fenster auf

--start: zeigt an das die Turel fertig sit
function zeigtFertig()
	term.setCursorPos(1,10) -- zeile 10 fuer anzeige bereinigen 
	term.clearLine() -- zeile 10 fuer anzeige bereinigen 
	print("!!!Fertig - Programm beendet!!!") -- fertig meldung
	term.setCursorPos(1,12) -- letzte zeile bereinigen 
	term.clearLine() -- letzte zeile bereinigen 
end
--end: zeigt an das die Turel fertig sit

--start: bereinigt den Bildschirm wen die turtel loslaeuft
function bildschirmRun()
	term.setCursorPos(1,7)
	term.clearLine()
	term.setCursorPos(1,12)
	term.clearLine()
	turtle.select(1) -- waehlt zum start slot 1 aus
end
--end: bereinigt den Bildschirm wen die turtel loslaeuft

--**Hauptprogrammsteuerung
--Setzen der globale Variablen (diese sind ueberall verfuegbar)
endertruhe = 0    -- Endertruhe = nein
fackeln = 0       -- Fackeln = 0
ganganzahl = 0    -- Anzahl Gaenge = 0
fuellevel = 0     -- Fuel-Level = 0

-- bereinigt den Bildschirm und baut das eingabe Fenster auf
bildschirmStart()

-- fuerht 2 funktionen gleichzeitig aus, eingab und aktuellisuerung der Fakeln, Endertruhe, und Fullevel
parallel.waitForAny(eingabeTunnellaenge, checkStatus) 

--Laed die Turtel vor dem start wieder auf wen etwas in slot 13 abgelegt wurde
	turtle.select(13) -- Slot 13 auswaehlen
	turtle.refuel(turtle.getItemCount(13)) -- auffuellung mit der anzahl Items in Slot 13

-- hier wird der tunnel gegraben
if (ganganzahl ~= 0) then -- mach das nur wen du auch wirklich was gemacht hast
	tunnel() -- vielleicht so oder doch ueber einen extra status anzeige
	back() -- hier komm die turtel wieder zurueck zum ausgangspunkt
end
--zeit an das die Turtel fertig ist
zeigtFertig()