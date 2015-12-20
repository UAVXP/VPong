local client = {}

Net = require( "net" )
Net:init( "Client" )
Net:connect( "127.0.0.1", 25045 )
Net:send( {}, "print", "Hello There Mr. Server!" )

Plys = {}
local selfID = ""

--[[---------------------------------------------------------
	Prints a table to the console
-----------------------------------------------------------]]
function PrintTable( t, indent, done )
	done = done or {}
	indent = indent or 0
--	local keys = table.GetKeys( t )
	local keys={}
	local n=0
	for k,v in pairs(t) do
	  n=n+1
	  keys[n]=k
	end
	table.sort( keys, function( a, b )
		if ( (type(a) == "number") and (type(b) == "number") ) then return a < b end
		return tostring( a ) < tostring( b )
	end )
	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		print( string.rep( "\t", indent ) )
		if  ( type(value) == "table" and not done[ value ] ) then
			done[ value ] = true
		--	print( tostring( key ) .. ":" .. "\n" )
			print( tostring( key ) .. ":" )
			PrintTable ( value, indent + 2, done )
		else
		--	print( tostring( key ) .. "\t=\t" )
			print( tostring( key ), "=", tostring( value ) )
		end
	end
end

Net:registerCMD( "setUserID", function( table, parameters, dt )
	selfID = parameters
end )
Net:registerCMD( "updatePlysInfo", function( table, parameters, dt )
	local tbl = table
	-- Receiving self and others pos
	if type(tbl) == "table" and Plys ~= tbl then
		Plys = tbl
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

local PlyInfo = {}
PlyInfo.pos = {}

function client.update(dt)
	-- Sending info to server
--	PlyInfo.pos.x = (PlyInfo.pos.x or 0) + 1
--	PlyInfo.pos.y = (PlyInfo.pos.y or 0) - 1
	PlyInfo.pos.x = 2
	if love.keyboard.isDown("w") then
		PlyInfo.pos.y = (PlyInfo.pos.y or 0) + 10 * dt
		Net:send( {}, "updatePlyInfo", PlyInfo )
	--	print("sended up")
	end
	if love.keyboard.isDown("s") then
		PlyInfo.pos.y = (PlyInfo.pos.y or 0) - 10 * dt
		Net:send( {}, "updatePlyInfo", PlyInfo )
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
	if Plys[selfID] and Plys[selfID].PlyInfo then
		text = Plys[selfID].PlyInfo.pos.y
	end
	love.graphics.print(text or 0, 5, 25)
	--[[local i = 0
	for k, v in pairs(Plys) do
		if v and v.PlyInfo then
			love.graphics.print(k..": "..v.PlyInfo.pos.y, 5, 25*i+10)
			i = i + 1
		end
	end]]
end

print( "Client initialized" )
return client