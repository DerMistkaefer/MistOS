local Autor = "DerMistkaefer"
local Version = "0.0.1.8"
local Update_Url = "https://www.dropbox.com/s/l6qc102ukmxbzf3/startup.lua?dl=1"

local File_Config = "MistOS/Config.cfg"


--Function Variabeln
Bios = {}
Config = {}
Var = {}

function Var.Config()
	Config_Options = {}
	Config_Options_Names = {}
end

function Var.Bios()
	Bios_Devices_Name = {}
	Bios_Devices = {}
end

function Variabeln()
	Var.Bios()
	Var.Config()
end


function Config.text()
	Config_Text = {
	"# Configuration file: MistOS\n",
	"general {",
	"	# Auto Update on startup",
	"	C:Update_enable=true\n",
	"	# User Name for OS Label",
	"	C:User_Name=\n",
	"}"
	}
end

function Config.read()
	File = fs.open(File_Config,"r")
	while true do
		Line = File.readLine()
		if Line == nil then break end
		if string.find(Line,"C:") then
			Config_Option_Name = string.sub(Line, string.find(Line,"C:")+2, string.find(Line,"=")-1)
			Config_Options_Names[#Config_Options_Names+1] = Config_Option_Name
			Config_Options[Config_Option_Name] = string.sub(Line, string.find(Line,"=")+1,-1)
		end
	end
	File.close()
end

function Config.save()
	Config.text()
	for key,valve in pairs(Config_Text) do
		if string.find(valve,"C:") then
			for key_1,valve_1 in pairs(Config_Options_Names) do
				if string.find(valve,"C:"..valve_1) then
					Config_Text[key] = string.sub(valve, 1, string.find(valve,"="))..Config_Options[valve_1].."\n"
				end
			end
		end
	end
	
	File = fs.open(File_Config,"w")
	for key,valve in pairs(Config_Text) do
		File.write(valve.."\n")
	end
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
	for key,value in pairs(peripheral.getNames()) do
		Bios_Devices_x = 0
		for key,value_1 in pairs(Bios_Devices_Name) do
			if value_1 == peripheral.getType(value) then Bios_Devices_x = 1 end
		end
		if Bios_Devices_x == 0 then
			Bios_Devices_Name[#Bios_Devices_Name+1] = peripheral.getType(value)
		end
	end
	
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

function Config.print()
	print("Config: Options")
	print()
	print(textutils.serialize(Config_Options))
	print()
end

function Home()
	if not fs.exists(File_Config) then Config.save() end
	
	Config.read()
	Config.save()
	
	if Config_Options["Update_enable"] then Update() end
	
	Bios.load()

end

function Test()
	Bios.print()
	Config.print()
end

Variabeln()
Home()
Test()