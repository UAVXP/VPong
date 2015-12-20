local client = {}

Net = require( "net" )
Net:init( "Client" )
Net:connect( "127.0.0.1", 25045 )
Net:send( {}, "print", "Hello There Mr. Server!" )

Plys = {}

Net:registerCMD( "updatePlysInfo", function( table, parameters, id, dt )
	-- Receiving self and others pos
	if type(table) == "table" then
		Plys = table
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
	PlyInfo.pos.x = (PlyInfo.pos.x or 0) + 1
	PlyInfo.pos.y = (PlyInfo.pos.y or 0) - 1
--	print("Sending: ", PlyInfo.pos.x, PlyInfo.pos.y)
	Net:send( {}, "updatePlyInfo", PlyInfo )
	
	-- Receiving from server
	for k, v in pairs(Plys) do
		if v.PlyInfo then
			print(k, v.PlyInfo.pos.x, v.PlyInfo.pos.y)
		end
	end

	Net:update( dt )
end

print( "Client initialized" )
return client