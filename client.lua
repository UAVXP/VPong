local client = {}

Net = require( "net" )
Net:init( "Client" )
Net:connect( "127.0.0.1", 25045 )
Net:send( {}, "print", "Hello There Mr. Server!" )

Plys = {}
local selfID = ""

-- Initiating
local PlyInfo = {}
PlyInfo.pos = {}
PlyInfo.pos.x = 0
PlyInfo.pos.y = 0
math.randomseed(os.clock()*100000000000)
PlyInfo.name = "asshole"..math.random(132345, 232345)
print("setting name to "..PlyInfo.name)

Net:registerCMD( "setUserID", function( tbl, parameters, dt )
	selfID = parameters
	
	if PlyInfo ~= nil then
		print("Sending first info to server")
		print(PlyInfo)
		Net:send( {}, "updatePlyInfo", PlyInfo )
	end
end )
Net:registerCMD( "updatePlysInfo", function( tbl, parameters, dt )
	-- Receiving self and others pos
	if type(tbl) == "table" --[[and Plys ~= tbl]] then
	--	print("Updated players info")
		Plys = tbl
		tableRemoveKey(Plys, "Command") -- should be key 1
		tableRemoveKey(Plys, "Param") -- tablelength(Plys)
	--	table.remove(Plys, 1)
	--	table.remove(Plys, tablelength(Plys)+1)
		--[[for k, v in pairs(Plys) do
			print("1", k, v)
			if type(v) == "table" then
				for i, j in pairs(v) do
					print("2", i, j)
				end
			end
		end]]
	--	print(Plys[id])
	end
	--[[if parameters ~= nil then
		Plys = parameters
		for k, v in pairs(parameters) do
			print(v)
		end
	end]]
end )

local fixedUpdateTime = 0.02 -- small, but not so many as love.update time
--local fixedUpdateTime = 0.01 -- better, but it should change(?) depends on ping(??)
previousKeyDownTime = love.timer.getTime() + fixedUpdateTime
function client.update(dt)
	-- Sending info to server
--	PlyInfo.pos.x = (PlyInfo.pos.x or 0) + 1
--	PlyInfo.pos.y = (PlyInfo.pos.y or 0) - 1
	PlyInfo.pos.x = 2
	local fullDelay = dt/Net.currentPing * fixedUpdateTime*2000
	fullDelay = (fullDelay ~= math.huge) and fullDelay or fixedUpdateTime
	--print(fullDelay)
	if love.keyboard.isDown("w") then
		if love.timer.getTime() >= previousKeyDownTime then
			PlyInfo.pos.y = (PlyInfo.pos.y or 0) - 380 * dt
			Net:send( {}, "updatePlyInfo", PlyInfo )
			previousKeyDownTime = love.timer.getTime() + fullDelay
		end
	--	print("sended up")
	end
	if love.keyboard.isDown("s") then
		if love.timer.getTime() >= previousKeyDownTime then
			PlyInfo.pos.y = (PlyInfo.pos.y or 0) + 380 * dt
			Net:send( {}, "updatePlyInfo", PlyInfo )
			previousKeyDownTime = love.timer.getTime() + fullDelay
		end
	--	print("sended down")
	end
--	Net:send( {}, "updatePlyInfo", PlyInfo )
--	print("Sending: ", PlyInfo.pos.x, PlyInfo.pos.y)
	
	
	-- Receiving from server
--	for k, v in pairs(Plys) do
--		if v.PlyInfo then
--			print(k, v.PlyInfo.pos.x, v.PlyInfo.pos.y)
		--	print(v.PlyInfo.pos.y)
--		end
--	end

	Net:update( dt )
end

function love.draw()
--	love.graphics.setBackgroundColor(255, 255, 255)
	local text = "Here's should be your Y position (from server)"
--	if Plys[selfID] and Plys[selfID].PlyInfo then
--		text = Plys[selfID].PlyInfo.pos.y
--	end
--	love.graphics.print(text or 0, 5, 25)
	local i = 0
--	love.graphics.print(tablelength(Plys), 10, 100)
	for k, v in pairs(Plys) do
		if v.PlyInfo then
		--	love.graphics.print(k..": "..v.PlyInfo.pos.y, 5, 25*i+10)
			local posX = 25*i+15
			local posY = v.PlyInfo.pos.y or 0
			love.graphics.print(v.PlyInfo.name, posX, posY - 10)
			love.graphics.rectangle( "fill", posX, posY, 20, 100 )
			i = i + 1
		end
	end
end

print( "Client initialized" )
return client