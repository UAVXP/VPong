require( "Tserial" )
loveframes = require( "UI" )

require( "themes" )

SETTINGS = {}
--SETTINGS.FilePath = "data/settings.txt"
SETTINGS.FilePath = "st.dat"
SETTINGS.Keyboard = {}
SETTINGS.Keyboard.RightPlatform = {}
SETTINGS.Keyboard.LeftPlatform = {}
SETTINGS.Sound = {}
SETTINGS.Video = {}
SETTINGS.Video.Resolution = {}

SOUNDS = {}
SOUNDS.Background = nil

STATE = {}
STATE.Current = "score" -- Can be "time" or "score"

function createResizedImage( width, height )
	return love.graphics.newQuad( 0, 0, width, height, width, height )
end
function resizeAndPosWindow( width, height, flags )
	local dummyX, dummyY, dflags = love.window.getMode()
	if not flags then flags = dflags end
	local canSetMode = love.window.setMode( width, height, flags )
	if not canSetMode then return false end
--	love.resize(width, height)
	alignPUI()
	local deskW, deskH = love.window.getDesktopDimensions()
	love.window.setPosition( deskW/2 - width/2, deskH/2 - height/2 )
	
	reloadAll()
end

function setupSomeImages()
	THEMES.MainMenu.Background.Image = love.graphics.newImage(THEMES.MainMenu.Background.ImagePath)
	THEMES.MainMenu.Background.Width = THEMES.MainMenu.Background.Image:getWidth()
	THEMES.MainMenu.Background.Height = THEMES.MainMenu.Background.Image:getHeight()
--	local tX, tY = 16, 16
--	testQuad = love.graphics.newQuad( 0, 0, tX, tY, tX, tY )
--	testQuad = createResizedImage( tX, tY )

	startGameImage = love.graphics.newImage( "images/engine/stgm_src.png" )

	THEMES.Current.Theme.PlatformLeft.Image = love.graphics.newImage(THEMES.Current.Theme.PlatformLeft.ImagePath)
	THEMES.Current.Theme.PlatformRight.Image = love.graphics.newImage(THEMES.Current.Theme.PlatformRight.ImagePath)
	THEMES.Current.Theme.Ball.Image = love.graphics.newImage(THEMES.Current.Theme.Ball.ImagePath)
	if love.filesystem.exists( THEMES.Current.Theme.Background.ImagePath ) then
		THEMES.Current.Theme.Background.Image = love.graphics.newImage(THEMES.Current.Theme.Background.ImagePath)
		THEMES.Current.Theme.Background.Width = THEMES.Current.Theme.Background.Image:getWidth()
		THEMES.Current.Theme.Background.Height = THEMES.Current.Theme.Background.Image:getHeight()
	end
	
	THEMES.Current.Theme.PlatformLeft.Width = THEMES.Current.Theme.PlatformLeft.Image:getWidth()
	THEMES.Current.Theme.PlatformLeft.Height = THEMES.Current.Theme.PlatformLeft.Image:getHeight()
	THEMES.Current.Theme.PlatformRight.Width = THEMES.Current.Theme.PlatformRight.Image:getWidth()
	THEMES.Current.Theme.PlatformRight.Height = THEMES.Current.Theme.PlatformRight.Image:getHeight()
	THEMES.Current.Theme.Ball.Width = THEMES.Current.Theme.Ball.Image:getWidth()
	THEMES.Current.Theme.Ball.Height = THEMES.Current.Theme.Ball.Image:getHeight()
end

function setupSounds()
	print("setupSounds()")
	if THEMES.Current.Theme.Background.SoundPath and love.filesystem.exists( THEMES.Current.Theme.Background.SoundPath ) then
		if SOUNDS.Background ~= nil then
			SOUNDS.Background:stop()
		end
		SOUNDS.Background = love.audio.newSource( THEMES.Current.Theme.Background.SoundPath, "stream" )
		SOUNDS.Background:play()
		SOUNDS.Background:setVolume( SETTINGS.Sound.MusicVolume / 100 )
	else
		if SOUNDS.Background ~= nil then
			SOUNDS.Background:stop()
		end
	end
end
function stopSounds()
	if SOUNDS.Background ~= nil then
		SOUNDS.Background:stop()
	end
end

function setupPhysics()
	
	-- One meter is 32px in physics engine
	love.physics.setMeter( 32 )

	-- Create a world with standard gravity
	world = love.physics.newWorld(0, 0, true)

	-- Create the ground body at (0, 0) static
	ground = love.physics.newBody(world, 0, 0, "static")
	
	-- Create the ground shape at (400,500) with size (600,10).
--	ground_shape = love.physics.newRectangleShape( 400, 500, 600, 10)
	ground_shape = love.physics.newRectangleShape( love.graphics.getWidth()/2, love.graphics.getHeight() + 10/2, love.graphics.getWidth(), 10)

	-- Create fixture between body and shape
	ground_fixture = love.physics.newFixture( ground, ground_shape)
	ground_fixture:setUserData("ground")
	
	-- Create the ground body at (0, 0) static
	ceiling = love.physics.newBody(world, 0, 0, "static")
	
	-- Create the ground shape at (400,500) with size (600,10).
	ceiling_shape = love.physics.newRectangleShape( love.graphics.getWidth()/2, -10/2, love.graphics.getWidth(), 10)

	-- Create fixture between body and shape
	ceiling_fixture = love.physics.newFixture( ceiling, ceiling_shape)
	ceiling_fixture:setUserData("ceiling")

	-- Load the image of the ball.
--	ball = love.graphics.newImage(THEMES.Current.Theme.Ball.ImagePath)

	-- Create a Body for the circle
--	body = love.physics.newBody(world, 400, 200, "dynamic")
	body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic")
	
	-- Attatch a shape to the body.
	circle_shape = love.physics.newCircleShape( 0,0,32)
	
    -- Create fixture between body and shape
    fixture = love.physics.newFixture( body, circle_shape)
	fixture:setUserData("ball")

	-- Calculate the mass of the body based on attatched shapes.
	-- This gives realistic simulations.
	body:setMassData(circle_shape:computeMass( 1 ))
	
	local rp = THEMES.Current.Theme.PlatformRight.Image
--	RightPlatform = love.physics.newBody( world, love.graphics.getWidth() - 15 - rp:getWidth()/2, 15 + THEMES.Current.Theme.PlatformLeft.Height/2, "static" ) -- body is from center
	RightPlatform = love.physics.newBody( world, love.graphics.getWidth() - 15 - rp:getWidth()/2, love.graphics.getHeight()/2, "static" )
	-- Create the ground shape at (400,500) with size (600,10).
--	RightPlatformShape = love.physics.newRectangleShape( love.graphics.getWidth() - 15 - THEMES.Current.Theme.PlatformLeft.Width, 15, THEMES.Current.Theme.PlatformLeft.Width, THEMES.Current.Theme.PlatformLeft.Height )
	RightPlatformShape = love.physics.newRectangleShape( 0, 0, THEMES.Current.Theme.PlatformLeft.Width, THEMES.Current.Theme.PlatformLeft.Height )
	RightPlatformFixture = love.physics.newFixture( RightPlatform, RightPlatformShape )
	RightPlatformFixture:setUserData("RightPlatform")
--	RightPlatform:setMassData(RightPlatformShape:computeMass( 1 ))

	local lp = THEMES.Current.Theme.PlatformLeft.Image
--	LeftPlatform = love.physics.newBody( world, 23, 15 + THEMES.Current.Theme.PlatformLeft.Height/2, "static" ) -- body is from center
--	LeftPlatform = love.physics.newBody( world, THEMES.Current.Theme.PlatformLeft.Width/2 + 15, 15 + THEMES.Current.Theme.PlatformLeft.Height/2, "static" ) -- body is from center
	LeftPlatform = love.physics.newBody( world, THEMES.Current.Theme.PlatformLeft.Width/2 + 15, love.graphics.getHeight()/2, "static" )
	-- Create the ground shape at (400,500) with size (600,10).
--	LeftPlatformShape = love.physics.newRectangleShape( love.graphics.getWidth() - 15 - THEMES.Current.Theme.PlatformLeft.Width, 15, THEMES.Current.Theme.PlatformLeft.Width, THEMES.Current.Theme.PlatformLeft.Height )
	LeftPlatformShape = love.physics.newRectangleShape( 0, 0, THEMES.Current.Theme.PlatformLeft.Width, THEMES.Current.Theme.PlatformLeft.Height )
	LeftPlatformFixture = love.physics.newFixture( LeftPlatform, LeftPlatformShape )
	LeftPlatformFixture:setUserData("LeftPlatform")
--	LeftPlatform:setMassData(LeftPlatformShape:computeMass( 1 ))

	world:setCallbacks( beginContact, endContact )
end

function love.load()
--[[	THEMES.MainMenu.Background.Image = love.graphics.newImage(THEMES.MainMenu.Background.ImagePath)
	THEMES.MainMenu.Background.Width = THEMES.MainMenu.Background.Image:getWidth()
	THEMES.MainMenu.Background.Height = THEMES.MainMenu.Background.Image:getHeight()
--	local tX, tY = 16, 16
--	testQuad = love.graphics.newQuad( 0, 0, tX, tY, tX, tY )
--	testQuad = createResizedImage( tX, tY )

	startGameImage = love.graphics.newImage( "images/engine/stgm_src.png" )

	THEMES.Current.Theme.PlatformLeft.Image = love.graphics.newImage(THEMES.Current.Theme.PlatformLeft.ImagePath)
	THEMES.Current.Theme.PlatformRight.Image = love.graphics.newImage(THEMES.Current.Theme.PlatformRight.ImagePath)
	THEMES.Current.Theme.Ball.Image = love.graphics.newImage(THEMES.Current.Theme.Ball.ImagePath)
	if love.filesystem.exists( THEMES.Current.Theme.Background.ImagePath ) then
		THEMES.Current.Theme.Background.Image = love.graphics.newImage(THEMES.Current.Theme.Background.ImagePath)
		THEMES.Current.Theme.Background.Width = THEMES.Current.Theme.Background.Image:getWidth()
		THEMES.Current.Theme.Background.Height = THEMES.Current.Theme.Background.Image:getHeight()
	end
	
	
	THEMES.Current.Theme.PlatformLeft.Width = THEMES.Current.Theme.PlatformLeft.Image:getWidth()
	THEMES.Current.Theme.PlatformLeft.Height = THEMES.Current.Theme.PlatformLeft.Image:getHeight()
	THEMES.Current.Theme.PlatformRight.Width = THEMES.Current.Theme.PlatformRight.Image:getWidth()
	THEMES.Current.Theme.PlatformRight.Height = THEMES.Current.Theme.PlatformRight.Image:getHeight()
	THEMES.Current.Theme.Ball.Width = THEMES.Current.Theme.Ball.Image:getWidth()
	THEMES.Current.Theme.Ball.Height = THEMES.Current.Theme.Ball.Image:getHeight()]]
	
	setupSomeImages()
--[[
	if love.filesystem.exists( SETTINGS.FilePath ) then
		for line in love.filesystem.lines(SETTINGS.FilePath) do
			table.insert( SETTINGS.Raw, line )
		end
		SETTINGS.Keyboard.RightPlatform.MoveUp = SETTINGS.Raw[1]
		SETTINGS.Keyboard.RightPlatform.MoveDown = SETTINGS.Raw[2]
		SETTINGS.Keyboard.LeftPlatform.MoveUp = SETTINGS.Raw[3]
		SETTINGS.Keyboard.LeftPlatform.MoveDown = SETTINGS.Raw[4]
		
		PUI.settingsTabsTab1.textinput1:SetText( SETTINGS.Keyboard.LeftPlatform.MoveUp )
		PUI.settingsTabsTab1.textinput2:SetText( SETTINGS.Keyboard.LeftPlatform.MoveDown )
		PUI.settingsTabsTab1.textinput3:SetText( SETTINGS.Keyboard.RightPlatform.MoveUp )
		PUI.settingsTabsTab1.textinput4:SetText( SETTINGS.Keyboard.RightPlatform.MoveDown )
	end
]]
	if love.filesystem.exists( SETTINGS.FilePath ) then
		SETTINGS = Tserial.unpack( love.filesystem.read( SETTINGS.FilePath ) )
	else
		if not love.filesystem.write( SETTINGS.FilePath, "" ) then
			love.window.showMessageBox( "Error", "Can't create settings file.", "info", false )
		end
		-- Standard keyboard configuration
		SETTINGS.Keyboard.RightPlatform.MoveUp = "up"
		SETTINGS.Keyboard.RightPlatform.MoveDown = "down"
		SETTINGS.Keyboard.LeftPlatform.MoveUp = "w"
		SETTINGS.Keyboard.LeftPlatform.MoveDown = "s"
		
		-- Standard sound configuration
	--	SETTINGS.Sound.MusicEnabled = true
		SETTINGS.Sound.MusicVolume = 100
		
		SETTINGS.Video.Resolution.Width = 800
		SETTINGS.Video.Resolution.Height = 600
		SETTINGS.Video.Resolution.Fullscreen = false
		
		love.filesystem.write( SETTINGS.FilePath, Tserial.pack(SETTINGS) )
	end

	require( "pui" )
	
--	resizeAndPosWindow( SETTINGS.Video.Resolution.Width, SETTINGS.Video.Resolution.Height )
	
	scoreFont = love.graphics.newImageFont( "images/score/all2.png", "0123456789" )
	winnerFont = love.graphics.newFont( 20 )
	
--[[	if THEMES.Current.Theme.Background.SoundPath and love.filesystem.exists( THEMES.Current.Theme.Background.SoundPath ) then
		print("MAKE SOME NOISE")
		if SOUNDS.Background ~= nil then
			SOUNDS.Background:stop()
		end
		SOUNDS.Background = love.audio.newSource( THEMES.Current.Theme.Background.SoundPath, "stream" )
		SOUNDS.Background:play()
		SOUNDS.Background:setVolume( SETTINGS.Sound.MusicVolume / 100 )
	else
		if SOUNDS.Background ~= nil then
			SOUNDS.Background:stop()
		end
	end]]
	
--	if loveframes.GetState() ~= "mainmenu" then
--		setupSounds()
--	end
	
	setupPhysics()

--	isFirstRun = true

	local dummyX, dummyY, dflags = love.window.getMode()
	dflags.fullscreen = SETTINGS.Video.Resolution.Fullscreen
	resizeAndPosWindow( SETTINGS.Video.Resolution.Width, SETTINGS.Video.Resolution.Height, dflags )
	print("LOADED")
end

--resizeAndPosWindow( SETTINGS.Video.Resolution.Width, SETTINGS.Video.Resolution.Height )
loveframes.SetState("mainmenu")

function alignPUI()
	-- UI centerize
	PUI.gamemenuFrame:Center()
	PUI.settingsFrame:Center()
	PUI.newGame.Frame:Center()
	PUI.mainSettings.Frame:Center()
	
	PUI.mainmenuText1:SetPos( 20, love.graphics.getHeight() - 200 )
	PUI.mainmenuText2:SetPos( 20, love.graphics.getHeight() - 175 )
	PUI.mainmenuText3:SetPos( 20, love.graphics.getHeight() - 150 )
end
function reloadAll()
	cleanMadness()

--	love.load()
	setupSomeImages()
	print("reloadAll()")
	if loveframes.GetState() == "none" then
		setupSounds()
	end
	setupPhysics()
	
	alignPUI()
end
function love.resize(w, h)
--	print(("Window resized to width: %d and height: %d."):format(w, h))
	reloadAll()
end

function canMove( platform, down )
	if not down then
		if platform.Y - 15*2 < 0 then
			return false
		end
	end
	
	if down then
		if (platform.Image:getHeight() + 15) + platform.Y >= love.graphics.getHeight() then
			return false
		end
	end
	
	
	return true
end
function canMove2( body, down )
	if not down then
		if body:getY() - (15 + THEMES.Current.Theme.PlatformLeft.Height/2) - 15 < 0 then
			return false
		end
	end
	
	if down then
		if (15 + THEMES.Current.Theme.PlatformLeft.Height/2) + body:getY() >= love.graphics.getHeight() then -- 15 - hole, 150 - height of platform
			return false
		end
	end
	
	
	return true
end
function isBallOutsideOfScreen()
	if body:getX() > love.graphics.getWidth() or body:getX() < 0 then
		return true
	end

	return false
end

local madBalls = {}
local madBallsCurTime = 0
local madBallsDieTime = 0
function cleanMadness()
	if #madBalls > 0 then
		for k, v in pairs( madBalls ) do
			if v then
			--	v.fixture:destroy()
			--	v.shape:destroy()
				v.body:destroy()
				v = nil
			end
		end
		if madBalls then madBalls = nil end
		madBalls = {}
	end
	madBallsCurTime = 0
	madBallsDieTime = 0
end
function getMad()
	cleanMadness()
	madBallsCurTime = love.timer.getTime()
	madBallsDieTime = madBallsCurTime + 3
	for i=1, 100 do
		madBalls[i] = {}
		madBalls[i].body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic")
		madBalls[i].shape = love.physics.newCircleShape( 0,0,32)
		madBalls[i].fixture = love.physics.newFixture( madBalls[i].body, madBalls[i].shape)
		madBalls[i].body:setLinearVelocity( (randomFloat(0, 1) > 0.5) and 100000 or -100000, (randomFloat(0, 1) > 0.5) and 100000 or -100000 )
	end
end
local madBallsFlowCurTime = 0
local madBallsFlowDieTime = 0
function createFlow()
	local i = #madBalls + 1
	madBalls[i] = {}
	madBalls[i].body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic")
	madBalls[i].shape = love.physics.newCircleShape( 0,0,32)
	madBalls[i].fixture = love.physics.newFixture( madBalls[i].body, madBalls[i].shape)
	madBalls[i].body:setMass(10)
	madBalls[i].fixture:setRestitution(0.4)
	local x, y = love.mouse.getPosition()
	x = x - love.graphics.getWidth()/2
	y = y - love.graphics.getHeight()/2
--	local xA, bA = -(x - love.graphics.getWidth()/2 - x)*10, -(y - love.graphics.getHeight()/2)*10
--	local xA, bA = x*10, y*10
	local xA, bA = x*2, y*2
	print( x, y, xA, bA )
	madBalls[i].body:setLinearVelocity( xA, bA )
--	return madBalls[i]
end

--[[local oldPlatformRightY = 0
local oldPlatformLeftY = 0
local lastCollisionShape = ""
local rightGuyScore = 0
local leftGuyScore = 0
local isInMenu = false]]
oldPlatformRightY = 0
oldPlatformLeftY = 0
lastCollisionShape = ""
rightGuyScore = 0
leftGuyScore = 0
isInMenu = false
isFirstRun = true
maxTimerValue = 120
timerValue = maxTimerValue
timerStart = love.timer.getTime()
maxScoreValue = 50
scoreValue = 0
showWinner = false
function love.update(dt)

	if not isInMenu and not PUI.themeMenu then
	--	local pl = THEMES.Current.Theme.PlatformLeft
	--	local pr = THEMES.Current.Theme.PlatformRight
		local pl = LeftPlatform
		local pr = RightPlatform
		
		oldPlatformRightY = pr:getY()
		oldPlatformLeftY = pl:getY()

	--	if canMove( pl, false ) and love.keyboard.isDown("w") then
	--		pl.Y = pl.Y - 300 *0.05 --* dt
	--	end
	--	if canMove( pl, true ) and love.keyboard.isDown("s") then
	--		pl.Y = pl.Y + 300 *0.05 --* dt
	--	end
		if canMove2( pl, false ) and love.keyboard.isDown(SETTINGS.Keyboard.LeftPlatform.MoveUp) then
		--	pl:setY( pl:getY() - 300 *0.05 --[[* dt]] )
			pl:setY( pl:getY() - 380 * dt )
		end
		if canMove2( pl, true ) and love.keyboard.isDown(SETTINGS.Keyboard.LeftPlatform.MoveDown) then
		--	pl:setY( pl:getY() + 300 *0.05 --[[* dt]] )
			pl:setY( pl:getY() + 380 * dt )
		end

	--	if canMove( pr, false ) and love.keyboard.isDown("up") then
	--		pr.Y = pr.Y - 300 *0.05 --* dt
	--	end
	--	if canMove( pr, true ) and love.keyboard.isDown("down") then
	--		pr.Y = pr.Y + 300 *0.05 --* dt
	--	end
		if canMove2( pr, false ) and love.keyboard.isDown(SETTINGS.Keyboard.RightPlatform.MoveUp) then
		--	pr:setY( pr:getY() - 300 *0.05 --[[* dt]] )
			pr:setY( pr:getY() - 380 * dt )
		end
		if canMove2( pr, true ) and love.keyboard.isDown(SETTINGS.Keyboard.RightPlatform.MoveDown) then
		--	pr:setY( pr:getY() + 300 *0.05 --[[* dt]] )
			pr:setY( pr:getY() + 380 * dt )
		end
		
		local oldLeftGuyScore = leftGuyScore
		local oldRightGuyScore = rightGuyScore
		if isBallOutsideOfScreen() then
		--	love.window.showMessageBox( "Test", "Outside!", "info", false )
		--	if lastCollisionShape == pr:getUserData() then
			if lastCollisionShape == "RightPlatform" then
				leftGuyScore = leftGuyScore + 1
				lastCollisionShape = ""
		--	elseif lastCollisionShape == pl:getUserData() then
			elseif lastCollisionShape == "LeftPlatform" then
				rightGuyScore = rightGuyScore + 1
				lastCollisionShape = ""
			end
			resetBall()
		end
		
	--	if leftGuyScore ~= oldLeftGuyScore or rightGuyScore ~= oldRightGuyScore then
	--		resetBall()
	--	end
		
		world:update(dt)
	end
	
	if madBallsCurTime > 0 and love.timer.getTime() >= madBallsDieTime then
		cleanMadness()
		resetBall()
	end
	
	
--	if love.timer.getTime() >= madBallsFlowDieTime then
--		createFlow()
--		madBallsFlowCurTime = love.timer.getTime()
--		madBallsFlowDieTime = madBallsFlowCurTime + 0.01
--	end


	if not isFirstRun and loveframes.GetState() == "none" then
		if STATE.Current == "time" then
			-- timer countdown
			if timerValue > 0 then
				if love.timer.getTime() - timerStart >= 1 then
					timerValue = timerValue - 1
					timerStart = love.timer.getTime()
				end
			else
				resetBall()
				showWinner = true
			--	isInMenu = true
			end
		elseif STATE.Current == "score" then
			-- max score countdown
			local maxScore = math.max( leftGuyScore, rightGuyScore )
			if maxScore >= maxScoreValue then
				resetBall()
				showWinner = true
			end
		end
	end

	
--	world:update(dt)
	loveframes.update(dt)
end
function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end
function tableHasValue( tbl, val )
	for k, v in pairs( tbl ) do
		if v == val then
			return true
		end
	end
	return false
end
function resetBall()
-- Apply a random impulse
--	body:applyLinearImpulse(0,-math.random(0, 1500))

	body:setLinearVelocity( 0, 0 )
	body:setPosition( love.graphics.getWidth()/2, love.graphics.getHeight()/2 )
--	body:setLinearVelocity( 0, 0 )
--	body:applyLinearImpulse(1500, 0)
--	body:setLinearVelocity( 500, 0 )
	body:setLinearVelocity( (randomFloat(0, 1) > 0.5) and 500 or -500, 0 )
	body:setAngularVelocity( 0 )
	body:setAngle( 0 )
	
	isFirstRun = false
end

function love.mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end
function love.keypressed(key, unicode)
	if loveframes.GetState() ~= "mainmenu" then
		if key == "escape" then
		--	love.event.quit()
			if not isInMenu then
				loveframes.SetState("gamemenu")
				isInMenu = not isInMenu
			else
				loveframes.SetState("none")
				isInMenu = not isInMenu
			end
		end
		if key == "space" then
			resetBall()
			
			RightPlatform:setY( love.graphics.getHeight()/2 )
			LeftPlatform:setY( love.graphics.getHeight()/2 )
			
			local umad = (randomFloat(0, 1) > 0.999) and getMad() or nil
		end
	end

	loveframes.keypressed(key, unicode)
	PUI:KeyPressed(key, unicode)
end
function love.keyreleased(key)
    loveframes.keyreleased(key)
end
function love.textinput(text)
	loveframes.textinput(text)
end
text = ""
bbodyvel = ""
-- This is called every time a collision begin.
local aContact = {}
function beginContact(a, b, c)
	local aa=a:getUserData()
	local bb=b:getUserData()
--	text = "Collided: " .. aa .. " and " .. bb
	
	local abody = a:getBody()
	local bbody = b:getBody()
	local ax, ay = abody:getLinearVelocity()
	local bx, by = bbody:getLinearVelocity()
	
	aContact[1] = abody
	aContact[2] = bbody
	
--	bbody:applyLinearImpulse(x - 1500, 0)
	local x = -bx
	local y = 0
	if aa == "RightPlatform" then
		local speed = (abody:getY() - oldPlatformRightY) * 30 -- 10
		if speed ~= 0 then
			y = speed
		--	bbody:applyAngularImpulse( y + math.random( 8000, 10000 ) )
			bbody:applyAngularImpulse( (abody:getY() - oldPlatformRightY) - math.random( 8000, 10000 ) )
		else
			x = -bx
			y = by
		end

		lastCollisionShape = aa
	elseif aa == "LeftPlatform" then
		local speed = (abody:getY() - oldPlatformLeftY) * 30 -- 10
		if speed ~= 0 then
			y = speed
			bbody:applyAngularImpulse( (abody:getY() - oldPlatformRightY) + math.random( 8000, 10000 ) )
		else
			x = -bx
			y = by
		end

		lastCollisionShape = aa
	else
		x = bx
		y = -by
	end
	
	x = x * 1.05
	y = y * 1.05
	
--	print( math.abs(x) )
	
	bbodyvel = y
	bbody:setLinearVelocity( x, y )
--	bbody:applyLinearImpulse( x, y )
end

-- This is called every time a collision end.
function endContact(a, b, c)
	local aa=a:getUserData()
	local bb=b:getUserData()
--	text = "Collision ended: " .. aa .. " and " .. bb
	
	local abody = a:getBody()
	local bbody = b:getBody()
	
	if aContact[1] ~= abody or aContact[2] ~= bbody then
	--	print( "Maybe, ball's stuck" )
	--	resetBall()
	--	reloadAll() -- Temporary fix!
	end
end

function love:draw()
	if loveframes.GetState() ~= "mainmenu" then
		local lp = THEMES.Current.Theme.PlatformLeft.Image
	--	local rp = THEMES.Current.Theme.PlatformRight.Image
	--	love.graphics.setBackgroundColor(255, 255, 255)
		if THEMES.Current.Theme.Background.Image ~= nil then
		--	love.graphics.draw(THEMES.Current.Theme.Background.Image, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1, THEMES.Current.Theme.Background.Width/2, THEMES.Current.Theme.Background.Height/2)
			local width = love.graphics.getHeight()/THEMES.Current.Theme.Background.Height
			local height = width
		--	print(love.graphics.getHeight(), width)
		--	if love.graphics.getHeight() < width then
		--		print("not cool!")
		--		height = height + (love.graphics.getHeight() - width)
		--	end
			love.graphics.draw(THEMES.Current.Theme.Background.Image, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, width, height, THEMES.Current.Theme.Background.Width/2, THEMES.Current.Theme.Background.Height/2)
			love.graphics.push("all")
			love.graphics.setColor( 255, 255, 255, 30 )
			love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )
			love.graphics.pop()
		else
		--	love.graphics.setBackgroundColor(150, 150, 150)
			love.graphics.setBackgroundColor(20, 20, 20)
		end
	--	love.graphics.draw(lp, 15, THEMES.Current.Theme.PlatformLeft.Y)
	--	love.graphics.draw(rp, love.graphics.getWidth() - 15 - rp:getWidth(), THEMES.Current.Theme.PlatformRight.Y)
	--	love.graphics.print(THEMES.Current.Theme.PlatformLeft.Y, 100, 200)
	--	text = tostring(isFirstRun)
	--	love.graphics.print(text, 5, 25)
	--	love.graphics.print(bbodyvel, 5, 50)
	--	love.graphics.print(body:getPosition(), 100, 200)
	--	love.graphics.print(THEMES.Current.Theme.PlatformRight.Y, love.graphics.getWidth() - 100, 200)
		
		love.graphics.polygon("line", ceiling:getWorldPoints(ceiling_shape:getPoints()))
		love.graphics.polygon("line", ground:getWorldPoints(ground_shape:getPoints()))
	--	love.graphics.polygon("line", RightPlatform:getWorldPoints(RightPlatformShape:getPoints()))
	--	love.graphics.polygon("line", LeftPlatform:getWorldPoints(LeftPlatformShape:getPoints()))
		love.graphics.draw(THEMES.Current.Theme.Ball.Image, body:getX(), body:getY(), body:getAngle(), 1, 1, THEMES.Current.Theme.Ball.Width/2, THEMES.Current.Theme.Ball.Height/2)
		for k, v in pairs(madBalls) do
			if v then
				love.graphics.draw(THEMES.Current.Theme.Ball.Image, v.body:getX(), v.body:getY(), v.body:getAngle(), 1, 1, THEMES.Current.Theme.Ball.Width/2, THEMES.Current.Theme.Ball.Height/2)
			end
		end
		-- 20 and 43 - is bad!
		-- Now a better realisation
		-- 0.8 = 20 / 25 (pixel offset / picture width)
		-- 0.286 = 43 / 150 (pixel offset / picture width)
	--	local xroffset, yroffset = (25 * 0.8), (150 * 0.286)
	--	local xroffset, yroffset = (THEMES.Current.Theme.PlatformLeft.Width * (20 / THEMES.Current.Theme.PlatformLeft.Width)), (THEMES.Current.Theme.PlatformLeft.Height * (43 / THEMES.Current.Theme.PlatformLeft.Height))
		love.graphics.draw(THEMES.Current.Theme.PlatformRight.Image, RightPlatform:getX(), RightPlatform:getY(), RightPlatform:getAngle(),1,1,THEMES.Current.Theme.PlatformRight.Width/2,THEMES.Current.Theme.PlatformRight.Height/2)
	--	love.graphics.print("RightPlatform X: "..RightPlatform:getX() - THEMES.Current.Theme.PlatformLeft.Width/2, 100, 220)
	--	love.graphics.print("RightPlatform Y: "..RightPlatform:getY() - THEMES.Current.Theme.PlatformLeft.Height/2, 100, 235)
		
	--	local xloffset, yloffset = (THEMES.Current.Theme.PlatformLeft.Width * (20 / THEMES.Current.Theme.PlatformLeft.Width)), (THEMES.Current.Theme.PlatformLeft.Height * (43 / THEMES.Current.Theme.PlatformLeft.Height))
	--	love.graphics.draw(THEMES.Current.Theme.PlatformLeft.Image, LeftPlatform:getX() + xloffset, LeftPlatform:getY() - yloffset, LeftPlatform:getAngle(),1,1,32,32)
	--	love.graphics.draw(THEMES.Current.Theme.PlatformLeft.Image, LeftPlatform:getX(), LeftPlatform:getY(), LeftPlatform:getAngle(),1,1,THEMES.Current.Theme.PlatformLeft.Width/2,THEMES.Current.Theme.PlatformLeft.Height/2)
		love.graphics.draw(THEMES.Current.Theme.PlatformLeft.Image, LeftPlatform:getX(), LeftPlatform:getY(), LeftPlatform:getAngle(),1,1,THEMES.Current.Theme.PlatformLeft.Width/2,THEMES.Current.Theme.PlatformLeft.Height/2)
	--	love.graphics.print("LeftPlatform X: "..LeftPlatform:getX() - THEMES.Current.Theme.PlatformLeft.Width/2, 100, 250)
	--	love.graphics.print("LeftPlatform Y: "..LeftPlatform:getY() - THEMES.Current.Theme.PlatformLeft.Height/2, 100, 265)
		
		love.graphics.push("all")
			love.graphics.setFont( scoreFont )
		--	love.graphics.setColorMode( "modulate" ) -- Removed in 0.9.0
		--	love.graphics.setColor( 255, 0, 0, 255 ) -- Not working
		--	love.graphics.print(rightGuyScore, 20, 400)
		--	love.graphics.print(leftGuyScore, love.graphics.getWidth() - 20 - 100, 400)
		--	local scoreOffset = 250
		--	local scoreOffset = 50
			local scoreOffset = 60
		--	love.graphics.push("all")
			if THEMES.Current.Theme.DarkTheme then
				love.graphics.setColor( 255, 255, 255, 100 )
			--	love.graphics.rectangle( "fill", love.graphics.getWidth()/2 - 36/2 - scoreOffset - 10, 5, scoreOffset*3.2, 80 )
				local strWidth = scoreFont:getWidth( tostring(rightGuyScore)..tostring(leftGuyScore).."000" )
				love.graphics.rectangle( "fill", love.graphics.getWidth()/2 - strWidth/2, 5, strWidth + 10 + 10, 80 )
			end
		--	love.graphics.pop()
			love.graphics.setColor( 255, 255, 255, 255 )
			love.graphics.printf(rightGuyScore, love.graphics.getWidth()/2 - 36/2 - scoreOffset*2, 15, 125, "right") -- 36x60 - one number  -- 125?
			love.graphics.print(leftGuyScore, love.graphics.getWidth()/2 - 36/2 + scoreOffset, 15)

			if THEMES.Current.Theme.DarkTheme then
				love.graphics.setColor( 255, 255, 255, 100 )
			--	love.graphics.rectangle( "fill", love.graphics.getWidth()/2 - 36/2 - scoreOffset - 10, 5, scoreOffset*3.2, 80 )
				local strWidth = scoreFont:getWidth( tostring(rightGuyScore)..tostring(leftGuyScore) )
				love.graphics.rectangle( "fill", love.graphics.getWidth() - 50 - 100, love.graphics.getHeight() - 125 - 10 - 5, 90, 40 )
			end
			love.graphics.setColor( 255, 255, 255, 255 )
			local valueToShow = ""
			if STATE.Current == "time" then
				valueToShow = timerValue
			elseif STATE.Current == "score" then
			--	valueToShow = maxScoreValue - math.max( leftGuyScore, rightGuyScore )
				valueToShow = maxScoreValue - (leftGuyScore + rightGuyScore)
			end
			love.graphics.printf(valueToShow, love.graphics.getWidth() - 125, love.graphics.getHeight() - 125 - 10, 125, "right", 0, 0.5, 0.5)
		love.graphics.pop()
		
		if isFirstRun then
			love.graphics.draw( startGameImage, love.graphics.getWidth()/2 - startGameImage:getWidth()/2, love.graphics.getHeight() - startGameImage:getHeight() - 50, 0, 1, 1, 0, 0)
		end
		
	--	showWinner = true
		if showWinner then
			love.graphics.push("all")
				love.graphics.setFont( winnerFont )
				local winnerName = "No one"
				local prefixLine = ""
				if STATE.Current == "time" then
					prefixLine = "The time is over"
				elseif STATE.Current == "score" then
					prefixLine = "Needed score achieved"
				end
				if (STATE.Current == "time") or (STATE.Current == "score") then
					if rightGuyScore > leftGuyScore then
						winnerName = "Left Guy" -- "Right Guy loses"
					elseif rightGuyScore < leftGuyScore then
						winnerName = "Right Guy" -- "Left Guy loses"
					end
				end
				local winnerStr = winnerName.." won!"
				
				local prefStrWidth = winnerFont:getWidth( prefixLine )
				local prefStrHeight = winnerFont:getHeight( prefixLine )
				local winStrWidth = winnerFont:getWidth( winnerStr )
				local winStrHeight = winnerFont:getHeight( winnerStr )
			--	love.graphics.print(winnerStr, 15, love.graphics.getHeight() - 50) -- Left bottom corner
				love.graphics.print(prefixLine, love.graphics.getWidth() / 2 - prefStrWidth / 2, (love.graphics.getHeight() / 2 - prefStrHeight / 2) + 40)
				love.graphics.print(winnerStr, love.graphics.getWidth() / 2 - winStrWidth / 2, (love.graphics.getHeight() / 2 - winStrHeight / 2) + 65)
			love.graphics.pop()
		end
		
	--	love.graphics.setColor( 0, 0, 0, 255 )
	--	love.graphics.print( "", x, y, r, sx, sy, ox, oy, kx, ky )

	--	love.graphics.print("FPS: " .. love.timer.getFPS(), 50, 50)
	--	love.graphics.print("dt: " .. love.timer.getDelta(), 50, 100)
	else
		local width = love.graphics.getHeight()/THEMES.MainMenu.Background.Height
		local height = width
	--	love.graphics.draw(THEMES.MainMenu.Background.Image, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, width, height, THEMES.MainMenu.Background.Width/2, THEMES.MainMenu.Background.Height/2)
		love.graphics.draw(THEMES.MainMenu.Background.Image, 0, 0, 0, love.graphics.getWidth()/THEMES.MainMenu.Background.Width, love.graphics.getHeight()/THEMES.MainMenu.Background.Height, 0, 0)
	--	love.graphics.draw(THEMES.Current.Theme.Ball.Image, testQuad, 100, 100)
	end
	loveframes.draw()
end