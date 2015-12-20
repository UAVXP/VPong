local server = {}

Net = require( "net" )
Net:init( "Server" )
Net:connect( nil, 25045 )
--Net:setMaxPing( 2000 )
--Net:registerCMD( "updateStatsOfPlayer", function( tbl, parameters, id, dt ) Net.users[id].name = table.name Net.users[id].color = table.color end )
local hasChanged = false
Net:registerCMD( "updatePlyInfo", function( tbl, parameters, id, dt )
	if parameters ~= nil then
	--	print(id..":", parameters.pos.x, parameters.pos.y)
	end
--	print("Ass:", parameters)
	if parameters ~= nil and type(parameters) == "table" and Net.users[id] ~= nil then
		if Net.users[id].PlyInfo == nil then
			print("Filling new user's info")
			Net.users[id].PlyInfo = {}
			Net.users[id].PlyInfo.pos = {}
			Net.users[id].PlyInfo.ID = id
		end
	--	print("Received pos of client "..id..": ", (parameters[1] or 0), (parameters[2] or 0))
		if Net.users[id].PlyInfo ~= parameters then
			hasChanged = true
		--	print("something changed")
			Net.users[id].PlyInfo.pos.x = parameters.pos.x or 23
			Net.users[id].PlyInfo.pos.y = parameters.pos.y or 3553
		end
	end
end )

function server.update(dt)
	if hasChanged then
	--	local stime = love.timer.getTime()
		local Plys = {}
		
		for k, v in pairs(Net.users) do
			-- Collecting all the infos
			if Plys[k] == nil then
				Plys[k] = {}
			end
		--	if Net.users[k] and Net.users[k].PlyInfo then
			if v.PlyInfo ~= Plys[k].PlyInfo then
			--	print("Pos of client "..k..": ", Net.users[k].PlyInfo.pos.x, Net.users[k].PlyInfo.pos.y)
				
			--	Plys[k] = Net.users[k]
			--	Plys[k].PlyInfo = Net.users[k].PlyInfo
				Plys[k].PlyInfo = {}
				Plys[k].PlyInfo = v.PlyInfo
				
			--	table.removeKey(Plys[k], "ping") -- Removing "ping"
			--	Net:send( Plys, "updatePlysInfo", "", k )
			end
			
			
			--	print(v.PlyInfo.pos.x, v.PlyInfo.pos.y)
		--	Net:send( {}, "updatePlysInfo", Plys, k )
		end
		
		-- Sending to all clients (yes, separate loop!)
		for k, v in pairs(Net.users) do
			Net:send( Plys, "updatePlysInfo", "", k )
		end
		
	--	local etime = love.timer.getTime()
	--	print(string.format("It took %.3f milliseconds!", 1000 * (etime - stime)))
		hasChanged = false
	end
	Net:update( dt )
end

function Net.event.server.userConnected( id )
	Net:send( {}, "print", "Hello, you've connected to my server", id )
	Net:send( {}, "setUserID", id, id )
end

print( "Server initialized" )
return server