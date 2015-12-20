SERVER = false
CLIENT = false

require("common")

function love.load( args )
	if args[2] == "-server" then
		SERVER = true
	else
		CLIENT = true
	end
	print( SERVER, CLIENT )
	
	test = {}
	if SERVER then
		print( "Initializing server..." )
		test = require("server")
	elseif CLIENT then
		print( "Initializing client..." )
		test = require("client")
	end

	love.update = test.update -- Do we need "or" section?
	love.keypressed = test.keypressed
end

