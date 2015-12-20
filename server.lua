local server = {}

Net = require( "net" )
Net:init( "Server" )
Net:connect( nil, 25045 )
--Net:registerCMD( "updateStatsOfPlayer", function( table, parameters, id, dt ) Net.users[id].name = table.name Net.users[id].color = table.color end )

Net:registerCMD( "updatePlyInfo", function( table, parameters, id, dt )
	if parameters ~= nil then
	--	print(id..":", parameters.pos.x, parameters.pos.y)
	end
	if parameters ~= nil and type(parameters) == "table" and Net.users[id] ~= nil then
		if Net.users[id].PlyInfo == nil then
			Net.users[id].PlyInfo = {}
			Net.users[id].PlyInfo.pos = {}
		end
		if Net.users[id].PlyInfo ~= nil then
		--	print("Received pos of client "..id..": ", (parameters[1] or 0), (parameters[2] or 0))
			Net.users[id].PlyInfo.pos.x = parameters.pos.x or 23
			Net.users[id].PlyInfo.pos.y = parameters.pos.x or 3553
		end
	end
end )

function server.update(dt)
	
	local Plys = {}
	-- Collecting all the infos
	for k, v in pairs(Net.users) do
		if Net.users[k] and Net.users[k].PlyInfo then
		--	print("Pos of client "..k..": ", Net.users[k].PlyInfo.pos.x, Net.users[k].PlyInfo.pos.y)
			-- Sending to all clients
			Plys[k] = Net.users[k]
		end
	end
	-- Sending those
	for k, v in pairs(Net.users) do
	--	print(v.PlyInfo.pos.x, v.PlyInfo.pos.y)
	--	Net:send( {}, "updatePlysInfo", Plys, k )
		Net:send( Plys, "updatePlysInfo", "", k )
	end
	
	Net:update( dt )
end

function Net.event.server.userConnected( id )
	Net:send( {}, "print", "Hello, you've connected to my server", id )
end

print( "Server initialized" )
return server