rednet.open("top")
--rednet.open("bottom")
 
shell.run("clear")
print("global-chat wird gestartet")
print("Server wird gestartet")
print("Deine ID: ",os.getComputerID())
print("==========================")
 
function receive()
CID = os.getComputerID()
shell = 0
shellid = 0
while true do
id,message,distance = rednet.receive()
if message ~= null then
if CID ~= id then
-- Nachricht Empfangen
-- Sende an Hauptmonitor
print(id,": ",message)
-- Teste auf shell
if shell == 1 then
if shellid == id then
  if message == CID.."exit" then
    print("Shell wird beendet")
 	  message = "Shell beendet!"
    shell = 0
    else
-- Befehle

if message == "redstoneback" then
  message = "Fuehre Befehl "..message.." aus!"
  redstone.setOutput("back", true)
  sleep(1) 
  redstone.setOutput("back", false) 
end

if message == "redstoneright" then
  message = "Fuehre Befehl "..message.." aus!"
  redstone.setOutput("right", true)
  sleep(1) 
  redstone.setOutput("right", false) 
end

if message == "redstoneleft" then
  message = "Fuehre Befehl "..message.." aus!"
  redstone.setOutput("left", true)
  sleep(1) 
  redstone.setOutput("left", false) 
end

if message == "redstonefront" then
  message = "Fuehre Befehl "..message.." aus!"
  redstone.setOutput("front", true)
  sleep(1) 
  redstone.setOutput("front", false) 
end

if message == "redstonetop" then
  message = "Fuehre Befehl "..message.." aus!"
  redstone.setOutput("top", true)
  sleep(1) 
  redstone.setOutput("top", false) 
end

if message == "redstonebottom" then
  message = "Fuehre Befehl "..message.." aus!"
  redstone.setOutput("bottom", true)
  sleep(1) 
  redstone.setOutput("bottom", false) 
end





  end
else
print("ID: ",id," ist nicht gueltig")
end
end

-- Teste auf Code
if message == CID.."shell" then
  print("Shell gestartet!")
  shellid = id
  print("RemoteID ",shellid)
  shell = 1
  message = "Shell gestartet!"
end
-- Leite Nachrichten weiter :D
for server = 0, 100, 1 do
    rednet.send(server,message)
end
-- Neue Nachricht
if shell == 0 then
  redstone.setOutput("bottom", true)
  sleep(1) 
  redstone.setOutput("bottom", false)
  sleep(1) 
  redstone.setOutput("bottom", true)
  sleep(1) 
  redstone.setOutput("bottom", false) 
end
-- Zwischenspeicher zuruecksetzen
message = null
end
end
end
end
 
-- Eingabe testen und senden
function send()
eingabe = read()
for server = 0, 100, 1 do
	rednet.send(server,eingabe)
end
end
 
-- Eingabe und Antwort parallel in lua
while true do
parallel.waitForAny(send,receive)
end