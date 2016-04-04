local Autor = "DerMistkaefer"
local Version = "0.0.1.7"
local Update_Url = "https://www.dropbox.com/s/ossy3q3mh4oh14x/startup.lua?dl=1"

--Function Variabeln
local Bios = {}

function Config_File()
	local file = "Config"
	if fs.exists(file) == true then
		File = fs.open(file,"r")
		local Config = {}
		local Config_Option = 0
		while true do
			Line = File.readLine()
			if Line == nil then break end
			Config_Option = Config_Option + 1
			Config[Config_Option] = Line
		end
		File.close()
	else
		File = fs.open(file,"a")
		File.close()
	end
	File = fs.open(file,"w")
	File.writeLine("True")
	File.writeLine("False")
	File.close()	
end

function Update()
	local content = http.get(Update_Url)
	if content then
		while true do
			Line = content.readLine()
			if string.find(Line,"local Version =") == 1 then
				print("System: "..Version.." | Update: "..string.sub(Line, 18, -2))
				if string.sub(Line, 18, -2) ~= Version then
					content.close()
					local content = http.get(Update_Url)
					if content then
						local file = "startup"
						if fs.exists(file) == false then
							File = fs.open(file,"a")
							File.close()
						end
						f = fs.open(file, "w")
						f.write(content.readAll())
						f.close()
						content.close()
						print("Das System wird geupdatet...")
						sleep(3)
						os.reboot()
					end
					content.close()	
				else
					print("Das System ist auf dem neusten Stand.")
					sleep(3)
					break
				end
			end
			if Line == nil then break end
			sleep(0.01)
		end
	end
content.close()	
end

function Bios.load()
	Bios_Devices_Name = {}
	for key,value in pairs(peripheral.getNames()) do
		Bios_Devices_x = 0
		for key,value_1 in pairs(Bios_Devices_Name) do
			if value_1 == peripheral.getType(value) then Bios_Devices_x = 1 end
		end
		if Bios_Devices_x == 0 then
			Bios_Devices_Name[#Bios_Devices_Name+1] = peripheral.getType(value)
		end
	end
	
	Bios_Devices={}
	for key,value in pairs(Bios_Devices_Name) do
		Bios_Devices[value]={}
		for key,value_1 in pairs(peripheral.getNames()) do
			if value == peripheral.getType(value_1) then
				print(value_1)
				Bios_Devices[value][#Bios_Devices[value]+1] = value_1
			end
		end
	end
end


function Bios.print()		
	term.clear()
	term.setCursorPos(1,1)
	print("Bios: Devices")
	print()
	print(textutils.serialize(Bios_Devices_Name))
	print()
	print()
	print(textutils.serialize(Bios_Devices))
	print()
end

function Home()
--Config_File()
Update()
Bios.load()
Bios.print()


end

Home()