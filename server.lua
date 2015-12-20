local server = {}

Net = require( "net" )
Net:init( "Server" )
Net:connect( nil, 25045 )
--Net:setMaxPing( 2000 )
--Net:registerCMD( "updateStatsOfPlayer", function( table, parameters, id, dt ) Net.users[id].name = table.name Net.users[id].color = table.color end )
local hasChanged = false
Net:registerCMD( "updatePlyInfo", function( table, parameters, id, dt )
	if parameters ~= nil then
	--	print(id..":", parameters.pos.x, parameters.pos.y)
	end
	if parameters ~= nil and type(parameters) == "table" and Net.users[id] ~= nil then
		if Net.users[id].PlyInfo == nil then
			Net.users[id].PlyInfo = {}
			Net.users[id].PlyInfo.pos = {}
		end
	--	print("Received pos of client "..id..": ", (parameters[1] or 0), (parameters[2] or 0))
		if Net.users[id].PlyInfo.pos.x ~= parameters.pos.x then
			Net.users[id].PlyInfo.pos.x = parameters.pos.x or 23
			hasChanged = true
		end
		if Net.users[id].PlyInfo.pos.y ~= parameters.pos.y then
			Net.users[id].PlyInfo.pos.y = parameters.pos.y or 3553
			hasChanged = true
			print("y changed")
		end
	end
end )

function server.update(dt)
	if hasChanged then
		local stime = love.timer.getTime()
		local Plys = {}
		
		for k, v in pairs(Net.users) do
			-- Collecting all the infos
			if Plys[k] == nil then
				Plys[k] = {}
			end
		--	if Net.users[k] and Net.users[k].PlyInfo then
			if v.PlyInfo ~= Plys[k].PlyInfo then
			--	print("Pos of client "..k..": ", Net.users[k].PlyInfo.pos.x, Net.users[k].PlyInfo.pos.y)
				-- Sending to all clients
			--	Plys[k] = Net.users[k]
			--	Plys[k].PlyInfo = Net.users[k].PlyInfo
				Plys[k].PlyInfo = v.PlyInfo
				Net:send( Plys, "updatePlysInfo", "", k )
			end
			
			-- Sending those
			--	print(v.PlyInfo.pos.x, v.PlyInfo.pos.y)
		--	Net:send( {}, "updatePlysInfo", Plys, k )
			
				
			end
		hasChanged = false
		local etime = love.timer.getTime()
		print(string.format("It took %.3f milliseconds!", 1000 * (etime - stime)))
	end
	Net:update( dt )
end

function Net.event.server.userConnected( id )
	Net:send( {}, "print", "Hello, you've connected to my server", id )
	Net:send( {}, "setUserID", id, id )
end

print( "Server initialized" )
return server