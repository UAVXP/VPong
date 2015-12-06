--[[	***
	In separate file!
		***]]
PUI = {}
function reloadVars()
	isFirstRun = true
	showWinner = false
	rightGuyScore = 0
	leftGuyScore = 0
	timerValue = maxTimerValue
	scoreValue = 0
end
-- MAIN MENU
--[[
PUI.mainmenuFrame = loveframes.Create("frame")
PUI.mainmenuFrame:SetName( "" )
PUI.mainmenuFrame:SetPos(0, -25)
PUI.mainmenuFrame:SetSize( love.window.getWidth(), love.window.getHeight() + 25 )
--PUI.mainmenuFrame:Center()
PUI.mainmenuFrame:SetState("mainmenu")
PUI.mainmenuFrame:SetDraggable( false )
PUI.mainmenuImage = loveframes.Create("image", PUI.mainmenuFrame)
PUI.mainmenuImage:SetImage("images/engine/background06_widescreen.png")
--PUI.mainmenuFrame:SetScreenLocked( true	)
--PUI.mainmenuFrame:ShowCloseButton( false )
--PUI.mainmenuFrame:MakeTop()
--PUI.mainmenuFrame:SetModal( true ) -- ?? makes grey transparent foreground
--PUI.mainmenuFrame:SetAlwaysOnTop( true )
]]
--[[
local imagebutton1 = loveframes.Create("imagebutton")
imagebutton1:SetText("New Game")
imagebutton1:SetState("mainmenu")
imagebutton1:SetImage("images/engine/null.png")
imagebutton1:SetPos(5, 30)
--imagebutton1:SizeToImage()
imagebutton1:SetSize(100, 20)
imagebutton1.OnClick = function(object)
    print("New Game")
end
local imagebutton2 = loveframes.Create("imagebutton")
imagebutton2:SetText("Choose Mode")
imagebutton2:SetState("mainmenu")
imagebutton2:SetImage("images/engine/null.png")
imagebutton2:SetPos(5, 60)
--imagebutton2:SizeToImage()
imagebutton2:SetSize(100, 20)
imagebutton2.OnClick = function(object)
    print("Choose Mode")
end
local imagebutton3 = loveframes.Create("imagebutton")
imagebutton3:SetText("Exit")
imagebutton3:SetState("mainmenu")
imagebutton3:SetImage("images/engine/null.png")
imagebutton3:SetPos(5, 90)
--imagebutton3:SizeToImage()
imagebutton3:SetSize(100, 20)
imagebutton3.OnClick = function(object)
    print("Exit")
end
]]
PUI.mainmenuText1 = loveframes.Create("clickabletext")
PUI.mainmenuText1:SetState("mainmenu")
PUI.mainmenuText1:SetLinksEnabled(true)
PUI.mainmenuText1:SetDetectLinks(true)
PUI.mainmenuText1:SetText( "New Game" )
PUI.mainmenuText1:SetPos( 20, love.window.getHeight() - 200 )
PUI.mainmenuText1:SetFont(love.graphics.newFont( "verdanab.ttf", 12 ))
PUI.mainmenuText1.OnClickLink = function(object, text)
--	loveframes.SetState("none")
--	reloadAll()
	PUI.newGame.Frame:SetVisible(not PUI.newGame.Frame:GetVisible())
end
PUI.mainmenuText2 = loveframes.Create("clickabletext")
PUI.mainmenuText2:SetState("mainmenu")
PUI.mainmenuText2:SetLinksEnabled(true)
PUI.mainmenuText2:SetDetectLinks(true)
--PUI.mainmenuText2:SetText( "Choose Mode" )
PUI.mainmenuText2:SetText( "Settings" )
PUI.mainmenuText2:SetPos( 20, love.window.getHeight() - 175 )
PUI.mainmenuText2:SetFont(love.graphics.newFont( "verdanab.ttf", 12 ))
PUI.mainmenuText2.OnClickLink = function(object, text)
--	print("Settings")
	PUI.mainSettings.Frame:SetVisible(not PUI.mainSettings.Frame:GetVisible())
end
PUI.mainmenuText3 = loveframes.Create("clickabletext")
PUI.mainmenuText3:SetState("mainmenu")
PUI.mainmenuText3:SetLinksEnabled(true)
PUI.mainmenuText3:SetDetectLinks(true)
PUI.mainmenuText3:SetText( "Quit" )
PUI.mainmenuText3:SetPos( 20, love.window.getHeight() - 150 )
PUI.mainmenuText3:SetFont(love.graphics.newFont( "verdanab.ttf", 12 ))
PUI.mainmenuText3.OnClickLink = function(object, text)
--	print("Quit")
	love.event.quit()
end
PUI.newGame = {}
PUI.newGame.Frame = loveframes.Create("frame")
PUI.newGame.Frame:SetState("mainmenu")
PUI.newGame.Frame:SetName( "New Game" )
PUI.newGame.Frame:SetSize( love.window.getWidth()/2, love.window.getHeight()/2 )
PUI.newGame.Frame:Center()
--PUI.newGame.Frame:SetDraggable( false )
--PUI.newGame.Frame:SetScreenLocked( true )
PUI.newGame.Frame:ShowCloseButton( false )
PUI.newGame.Frame:MakeTop()
PUI.newGame.Frame:SetVisible(false)
PUI.newGame.timerButton = loveframes.Create("button", PUI.newGame.Frame)
PUI.newGame.timerButton:SetText( "Timer Mode" )
PUI.newGame.timerButton:SetPos( 10, PUI.newGame.Frame:GetHeight()/2 - PUI.newGame.timerButton:GetHeight()/2 )
PUI.newGame.timerButton:SetWidth( PUI.newGame.Frame:GetWidth() / 2 - 5 - 10 )
PUI.newGame.timerButton.OnClick = function(object, x, y)
	loveframes.SetState("none")
	PUI.newGame.Frame:SetVisible( false )
	STATE.Current = "time"
	reloadVars()
	reloadAll()
end
PUI.newGame.timerButton.Tooltip = loveframes.Create("tooltip")
PUI.newGame.timerButton.Tooltip:SetState("mainmenu")
PUI.newGame.timerButton.Tooltip:SetObject(PUI.newGame.timerButton)
PUI.newGame.timerButton.Tooltip:SetPadding( 20 )
PUI.newGame.timerButton.Tooltip:SetText( "In this mode you have only 120 seconds\nto beat your opponent." )
PUI.newGame.scoreButton = loveframes.Create("button", PUI.newGame.Frame)
PUI.newGame.scoreButton:SetText( "Score Mode" )
PUI.newGame.scoreButton:SetPos( PUI.newGame.Frame:GetWidth() / 2 + 5, PUI.newGame.Frame:GetHeight()/2 - PUI.newGame.scoreButton:GetHeight()/2 )
PUI.newGame.scoreButton:SetWidth( PUI.newGame.Frame:GetWidth() / 2 - 10 - 10 )
PUI.newGame.scoreButton.OnClick = function(object, x, y)
	loveframes.SetState("none")
	PUI.newGame.Frame:SetVisible( false )
	STATE.Current = "score"
	reloadVars()
	reloadAll()
end
PUI.newGame.scoreButton.Tooltip = loveframes.Create("tooltip")
PUI.newGame.scoreButton.Tooltip:SetState("mainmenu")
PUI.newGame.scoreButton.Tooltip:SetObject(PUI.newGame.scoreButton)
PUI.newGame.scoreButton.Tooltip:SetPadding( 20 )
PUI.newGame.scoreButton.Tooltip:SetText( "In this mode you should take "..maxScoreValue.." points\nto beat your opponent." )

-- To another file
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
-- MAIN SETTINGS
PUI.mainSettings = {}
PUI.mainSettings.Frame = loveframes.Create("frame")
PUI.mainSettings.Frame:SetState("mainmenu")
PUI.mainSettings.Frame:SetName( "Settings" )
PUI.mainSettings.Frame:SetSize( love.window.getWidth()/2, love.window.getHeight()/2 )
PUI.mainSettings.Frame:Center()
--PUI.mainSettings.Frame:SetDraggable( false )
--PUI.mainSettings.Frame:SetScreenLocked( true )
PUI.mainSettings.Frame:ShowCloseButton( false )
PUI.mainSettings.Frame:MakeTop()
PUI.mainSettings.Frame:SetVisible(false)
--PUI.mainSettings.Frame:SetModal( true ) -- ?? makes grey transparent foreground
--PUI.mainSettings.Frame:SetAlwaysOnTop( true )
PUI.mainSettings.Frame.OnClose = function( object )
	loveframes.SetState("gamemenu")
end
PUI.mainSettings.tabs = loveframes.Create("tabs", PUI.mainSettings.Frame)
PUI.mainSettings.tabs:SetPos(0, 30)
PUI.mainSettings.tabs:SetSize(PUI.mainSettings.Frame:GetWidth(), PUI.mainSettings.Frame:GetHeight())
PUI.mainSettings.tabs.tab1 = loveframes.Create("panel")
PUI.mainSettings.tabs.tab1.Draw = function()
end
local fullscreenModes = love.window.getFullscreenModes()
table.sort(fullscreenModes, function(a, b) return a.width*a.height < b.width*b.height end)
PUI.mainSettings.tabs.tab1.multiChoice1 = loveframes.Create("multichoice", PUI.mainSettings.tabs.tab1)
PUI.mainSettings.tabs.tab1.multiChoice1:SetPos(5, 30)
for k,v in pairs(fullscreenModes) do
--	print(v.width, v.height)
	PUI.mainSettings.tabs.tab1.multiChoice1:AddChoice( v.width.."x"..v.height )
end
PUI.mainSettings.tabs.tab1.multiChoice1:SetChoice(SETTINGS.Video.Resolution.Width.."x"..SETTINGS.Video.Resolution.Height)
PUI.mainSettings.tabs.tab1.checkBox1 = loveframes.Create("checkbox", PUI.mainSettings.tabs.tab1)
PUI.mainSettings.tabs.tab1.checkBox1:SetText("Fullscreen")
PUI.mainSettings.tabs.tab1.checkBox1:SetPos(5, 65)
PUI.mainSettings.tabs.tab1.checkBox1:SetChecked(SETTINGS.Video.Resolution.Fullscreen)
PUI.mainSettings.tabs.tab1.applyButton = loveframes.Create("button", PUI.mainSettings.tabs.tab1)
PUI.mainSettings.tabs.tab1.applyButton:SetText( "Apply" )
PUI.mainSettings.tabs.tab1.applyButton:SetPos( PUI.mainSettings.Frame:GetWidth() - PUI.mainSettings.tabs.tab1.applyButton:GetWidth()*2 - 10*2, PUI.mainSettings.Frame:GetHeight() - PUI.mainSettings.tabs.tab1.applyButton:GetHeight() - 35 )
PUI.mainSettings.tabs.tab1.applyButton.OnClick = function( object, x, y )
	local resolution = split( PUI.mainSettings.tabs.tab1.multiChoice1:GetChoice(), "x" )
	SETTINGS.Video.Resolution.Width = tonumber(resolution[1])
	SETTINGS.Video.Resolution.Height = tonumber(resolution[2])
	SETTINGS.Video.Resolution.Fullscreen = PUI.mainSettings.tabs.tab1.checkBox1:GetChecked()
	love.filesystem.write( SETTINGS.FilePath, Tserial.pack(SETTINGS) )
	--	love.resize(SETTINGS.Video.Resolution.Width, SETTINGS.Video.Resolution.Height)
	local dummyX, dummyY, dflags = love.window.getMode()
	dflags.fullscreen = SETTINGS.Video.Resolution.Fullscreen
	resizeAndPosWindow( SETTINGS.Video.Resolution.Width, SETTINGS.Video.Resolution.Height, dflags )
end
PUI.mainSettings.tabs.tab1.OKButton = loveframes.Create("button", PUI.mainSettings.tabs.tab1)
PUI.mainSettings.tabs.tab1.OKButton:SetText( "OK" )
PUI.mainSettings.tabs.tab1.OKButton:SetPos( PUI.mainSettings.Frame:GetWidth() - PUI.mainSettings.tabs.tab1.OKButton:GetWidth() - 10, PUI.mainSettings.Frame:GetHeight() - PUI.mainSettings.tabs.tab1.OKButton:GetHeight() - 35 )
PUI.mainSettings.tabs.tab1.OKButton.OnClick = function( object, x, y )
	PUI.mainSettings.tabs.tab1.applyButton.OnClick()
	PUI.mainSettings.Frame:SetVisible(false)
end
PUI.mainSettings.tabs.tab1.CancelButton = loveframes.Create("button", PUI.mainSettings.tabs.tab1)
PUI.mainSettings.tabs.tab1.CancelButton:SetText( "Cancel" )
PUI.mainSettings.tabs.tab1.CancelButton:SetPos( PUI.mainSettings.Frame:GetWidth() - PUI.mainSettings.tabs.tab1.CancelButton:GetWidth()*3 - 10*3, PUI.mainSettings.Frame:GetHeight() - PUI.mainSettings.tabs.tab1.CancelButton:GetHeight() - 35 )
PUI.mainSettings.tabs.tab1.CancelButton.OnClick = function( object, x, y )
	PUI.mainSettings.Frame:SetVisible(false)
end
PUI.mainSettings.tabs:AddTab("Video", PUI.mainSettings.tabs.tab1, "Video settings", "images/keyboard.png")

-- GAME MENU
-- 300x150
PUI.gamemenuFrame = loveframes.Create("frame")
PUI.gamemenuFrame:SetName( "Game Menu" )
PUI.gamemenuFrame:SetSize( 500, 250 )
PUI.gamemenuFrame:Center()
PUI.gamemenuFrame:SetState("gamemenu")
PUI.gamemenuFrame:SetDraggable( false )
PUI.gamemenuFrame:SetScreenLocked( true	)
PUI.gamemenuFrame:ShowCloseButton( false )
PUI.gamemenuFrame:MakeTop()
--	PUI.gamemenuFrame:SetModal( true ) -- ?? makes grey transparent foreground
PUI.gamemenuFrame:SetAlwaysOnTop( true )


-- Make this section better by tables
PUI.exitButton = loveframes.Create("button", PUI.gamemenuFrame)
PUI.exitButton:SetText( "Exit to main menu" )
PUI.exitButton:SetPos( 10, PUI.gamemenuFrame:GetHeight() - PUI.exitButton:GetHeight() - 10 )
PUI.exitButton:SetSize( PUI.gamemenuFrame:GetWidth() - 20, PUI.exitButton:GetHeight() )
PUI.exitButton.OnClick = function( object, x, y )
	-- Make a question
--	love.event.quit()
	love.keypressed("escape", "")
--	reloadAll()
	loveframes.SetState("mainmenu")
	reloadAll()
	stopSounds()
	reloadVars()
end
PUI.settingsButton = loveframes.Create("button", PUI.gamemenuFrame)
PUI.settingsButton:SetText( "Settings" )
--PUI.settingsButton:SetPos( 10, PUI.gamemenuFrame:GetHeight() - PUI.settingsButton:GetHeight() - PUI.exitButton:GetHeight() - 15 )
PUI.settingsButton:SetPos( 10, PUI.gamemenuFrame:GetHeight() - PUI.settingsButton:GetHeight()*2 - 10 )
PUI.settingsButton:SetSize( PUI.gamemenuFrame:GetWidth() - 20, PUI.settingsButton:GetHeight() )
PUI.settingsButton.OnClick = function( object, x, y )
	loveframes.SetState("settings")
end
--[[
PUI.themeText = loveframes.Create("text", PUI.gamemenuFrame)
PUI.themeText:SetText( "Choose theme:" )
PUI.themeText:SetPos( 20, 35 )

PUI.themeList = loveframes.Create("list", PUI.gamemenuFrame)
PUI.themeList:SetPos(10, 50)
--PUI.themeList:SetSize(PUI.gamemenuFrame:GetWidth() - 10*2, 50)
PUI.themeList:SetSize(PUI.gamemenuFrame:GetWidth() - 10*2, 85)
PUI.themeList:SetPadding(0) -- Space between thing and edge
PUI.themeList:SetSpacing(0) -- Space between things
--PUI.themeList:EnableHorizontalStacking(true)
]]
PUI.themeButton = loveframes.Create("button", PUI.gamemenuFrame)
PUI.themeButton:SetPos(10, 35)
PUI.themeButton:SetText( "Choose Theme" )
PUI.themeButton:SetSize( PUI.gamemenuFrame:GetWidth()- 10 - 10, 20 )
PUI.themeButton.OnClick = function(object, x, y)
--	love.keypressed(" ", "")
	love.keypressed("escape", "")
	PUI.themeMenu = loveframes.Create("menu")
	PUI.themeMenu:SetPos(x - PUI.themeMenu:GetWidth()/2, y)
	for k, v in pairs( THEMES ) do
		if v.Name ~= nil then
		--	PUI.themeMenu:AddOption(v.Name, v.MainPath.."/menu.png", function()
			PUI.themeMenu:AddOption(v.Name, v.Ball.ImagePath, function()
				if THEMES.Current.Theme ~= v then
					THEMES.Current.Theme = v
					reloadAll()
				end
			--	love.keypressed("escape", "")
			end)
		end
	end
end
--[[
PUI.themeListButtons = {}
for k, v in pairs( THEMES ) do
	if v.Name ~= nil then
		print( v.Name )
		PUI.themeListButtons[k] = loveframes.Create("button")
		PUI.themeListButtons[k]:SetText(v.Name)
		PUI.themeListButtons[k].OnClick = function( object, x, y )
			if THEMES.Current.Theme ~= v then
				THEMES.Current.Theme = v
				reloadAll()
			end
		end
	--	PUI.themeList:AddItem(PUI.themeListButtons[k])
	end
end
]]
PUI.restartButton = loveframes.Create("button", PUI.gamemenuFrame)
PUI.restartButton:SetText( "Restart round" )
PUI.restartButton:SetPos( 10, PUI.gamemenuFrame:GetHeight() - PUI.settingsButton:GetHeight()*3 - 10 )
PUI.restartButton:SetSize( PUI.gamemenuFrame:GetWidth() - 20, PUI.restartButton:GetHeight() )
PUI.restartButton.OnClick = function( object, x, y )
	love.keypressed("escape", "")
	loveframes.SetState("mainmenu")
	PUI.newGame.Frame:SetVisible( true )
end

-- SETTINGS
PUI.settingsFrame = loveframes.Create("frame")
PUI.settingsFrame:SetName( "Settings" )
PUI.settingsFrame:SetSize( love.window.getWidth()/2, love.window.getHeight()/2 )
PUI.settingsFrame:Center()
PUI.settingsFrame:SetState("settings")
--PUI.settingsFrame:SetDraggable( false )
--PUI.settingsFrame:SetScreenLocked( true )
PUI.settingsFrame:ShowCloseButton( false )
PUI.settingsFrame:MakeTop()
--PUI.settingsFrame:SetModal( true ) -- ?? makes grey transparent foreground
--PUI.settingsFrame:SetAlwaysOnTop( true )
PUI.settingsFrame.OnClose = function( object )
	loveframes.SetState("gamemenu")
end
PUI.settingsTabs = loveframes.Create("tabs", PUI.settingsFrame)
PUI.settingsTabs:SetPos(0, 30)
PUI.settingsTabs:SetSize(PUI.settingsFrame:GetWidth(), PUI.settingsFrame:GetHeight())

PUI.settingsTabsTab1 = loveframes.Create("panel")
PUI.settingsTabsTab1.Draw = function()
end
PUI.settingsTabsTab1.text1 = loveframes.Create("text", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.text1:SetText( "Left platform controls" )
PUI.settingsTabsTab1.text1:SetPos( 20, 20 )
PUI.settingsTabsTab1.text2 = loveframes.Create("text", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.text2:SetText( "Move up:" )
PUI.settingsTabsTab1.text2:SetPos( 20, 45 )
PUI.settingsTabsTab1.text3 = loveframes.Create("text", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.text3:SetText( "Move down:" )
PUI.settingsTabsTab1.text3:SetPos( 20, 70 )
PUI.settingsTabsTab1.text4 = loveframes.Create("text", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.text4:SetText( "Right platform controls" )
PUI.settingsTabsTab1.text4:SetPos( 200, 20 )
PUI.settingsTabsTab1.text5 = loveframes.Create("text", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.text5:SetText( "Move up:" )
PUI.settingsTabsTab1.text5:SetPos( 200, 45 )
PUI.settingsTabsTab1.text6 = loveframes.Create("text", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.text6:SetText( "Move down:" )
PUI.settingsTabsTab1.text6:SetPos( 200, 70 )
PUI.settingsTabsTab1.textinput1 = loveframes.Create("textinput", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.textinput1:SetPos( 100, 40 )
PUI.settingsTabsTab1.textinput1:SetWidth( 50 )
PUI.settingsTabsTab1.textinput1:SetText( SETTINGS.Keyboard.LeftPlatform.MoveUp )
PUI.settingsTabsTab1.textinput2 = loveframes.Create("textinput", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.textinput2:SetPos( 100, 65 )
PUI.settingsTabsTab1.textinput2:SetWidth( 50 )
PUI.settingsTabsTab1.textinput2:SetText( SETTINGS.Keyboard.LeftPlatform.MoveDown )
PUI.settingsTabsTab1.textinput3 = loveframes.Create("textinput", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.textinput3:SetPos( 280, 40 )
PUI.settingsTabsTab1.textinput3:SetWidth( 50 )
PUI.settingsTabsTab1.textinput3:SetText( SETTINGS.Keyboard.RightPlatform.MoveUp )
PUI.settingsTabsTab1.textinput4 = loveframes.Create("textinput", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.textinput4:SetPos( 280, 65 )
PUI.settingsTabsTab1.textinput4:SetWidth( 50 )
PUI.settingsTabsTab1.textinput4:SetText( SETTINGS.Keyboard.RightPlatform.MoveDown )
PUI.settingsTabsTab1.settingsTabsTab1ApplyButton = loveframes.Create("button", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:SetText( "Apply" )
--PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:GetWidth() - 10, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:GetHeight() - 35 )
PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:GetWidth()*2 - 10*2, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab1.settingsTabsTab1ApplyButton:GetHeight() - 35 )
PUI.settingsTabsTab1.settingsTabsTab1ApplyButton.OnClick = function( object, x, y )
--[[	local allstr = PUI.settingsTabsTab1.textinput3:GetText().."\r\n"..PUI.settingsTabsTab1.textinput4:GetText().."\r\n"..PUI.settingsTabsTab1.textinput1:GetText().."\r\n"..PUI.settingsTabsTab1.textinput2:GetText()
--	local file = love.filesystem.newFile(SETTINGS.FilePath, love.file_write) -- SETTINGS.FilePath
--	local file = love.filesystem.newFile("settings.txt")
	local file = love.filesystem.newFile(SETTINGS.FilePath) -- Need to make a file if it's not exist
	local isOK, err = file:open( "w" )
	if isOK then
	--	love.filesystem.write(file, allstr)
	--	file:write(allstr)
		file:write(PUI.settingsTabsTab1.textinput3:GetText().."\r\n")
		file:write(PUI.settingsTabsTab1.textinput4:GetText().."\r\n")
		file:write(PUI.settingsTabsTab1.textinput1:GetText().."\r\n")
		file:write(PUI.settingsTabsTab1.textinput2:GetText())
	--	love.filesystem.close(file)
	else
		love.window.showMessageBox( "Error!", "The settings file was not opened!\r\n"..err, "info", false )
	end
	file:close()
]]
	SETTINGS.Keyboard.RightPlatform.MoveUp = PUI.settingsTabsTab1.textinput3:GetText()
	SETTINGS.Keyboard.RightPlatform.MoveDown = PUI.settingsTabsTab1.textinput4:GetText()
	SETTINGS.Keyboard.LeftPlatform.MoveUp = PUI.settingsTabsTab1.textinput1:GetText()
	SETTINGS.Keyboard.LeftPlatform.MoveDown = PUI.settingsTabsTab1.textinput2:GetText()
	love.filesystem.write( SETTINGS.FilePath, Tserial.pack(SETTINGS) )
	love.event.clear()
end
PUI.settingsTabsTab1.OKButton = loveframes.Create("button", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.OKButton:SetText( "OK" )
--PUI.settingsTabsTab1.OKButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab1.OKButton:GetWidth() - 10, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab1.OKButton:GetHeight() - 35 )
PUI.settingsTabsTab1.OKButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab1.OKButton:GetWidth() - 10, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab1.OKButton:GetHeight() - 35 )
PUI.settingsTabsTab1.OKButton.OnClick = function( object, x, y )
	PUI.settingsTabsTab1.settingsTabsTab1ApplyButton.OnClick()
	love.keypressed("escape", "")
end
PUI.settingsTabsTab1.CancelButton = loveframes.Create("button", PUI.settingsTabsTab1)
PUI.settingsTabsTab1.CancelButton:SetText( "Cancel" )
--PUI.settingsTabsTab1.CancelButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab1.CancelButton:GetWidth() - 10, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab1.CancelButton:GetHeight() - 35 )
PUI.settingsTabsTab1.CancelButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab1.CancelButton:GetWidth()*3 - 10*3, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab1.CancelButton:GetHeight() - 35 )
PUI.settingsTabsTab1.CancelButton.OnClick = function( object, x, y )
	love.keypressed("escape", "")
end
PUI.settingsTabs:AddTab("Keyboard", PUI.settingsTabsTab1, "Keyboard settings", "images/keyboard.png")

PUI.settingsTabsTab2 = loveframes.Create("panel")
PUI.settingsTabsTab2.Draw = function()
end
--PUI.settingsTabsTab2.checkBox1 = loveframes.Create("checkbox", PUI.settingsTabsTab2)
--PUI.settingsTabsTab2.checkBox1:SetText("Enable music")
--PUI.settingsTabsTab2.checkBox1:SetPos(20, 20)
--PUI.settingsTabsTab2.checkBox1:SetChecked( SETTINGS.Sound.MusicEnabled )

PUI.settingsTabsTab2.text2 = loveframes.Create("text", PUI.settingsTabsTab2)
PUI.settingsTabsTab2.text2:SetText( "Music Volume" )
PUI.settingsTabsTab2.text2:SetPos( 20, 55 )
PUI.settingsTabsTab2.slider1 = loveframes.Create("slider", PUI.settingsTabsTab2)
PUI.settingsTabsTab2.slider1:SetPos(5, 70)
PUI.settingsTabsTab2.slider1:SetWidth(290)
PUI.settingsTabsTab2.slider1:SetMinMax(0, 100)
PUI.settingsTabsTab2.slider1:SetDecimals(0)
PUI.settingsTabsTab2.slider1:SetValue(SETTINGS.Sound.MusicVolume)
PUI.settingsTabsTab2.slider1.OnValueChanged = function(object)
    PUI.settingsTabsTab2.text1:SetText( PUI.settingsTabsTab2.slider1:GetValue() )
end
PUI.settingsTabsTab2.text1 = loveframes.Create("text", PUI.settingsTabsTab2)
PUI.settingsTabsTab2.text1:SetText( SETTINGS.Sound.MusicVolume )
PUI.settingsTabsTab2.text1:SetPos( PUI.settingsTabsTab2.slider1:GetWidth()/2, 90 )

PUI.settingsTabsTab2.applyButton = loveframes.Create("button", PUI.settingsTabsTab2)
PUI.settingsTabsTab2.applyButton:SetText( "Apply" )
PUI.settingsTabsTab2.applyButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab2.applyButton:GetWidth()*2 - 10*2, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab2.applyButton:GetHeight() - 35 )
PUI.settingsTabsTab2.applyButton.OnClick = function( object, x, y )
--	SETTINGS.Sound.MusicEnabled = PUI.settingsTabsTab2.checkBox1:GetChecked()
	SETTINGS.Sound.MusicVolume = PUI.settingsTabsTab2.slider1:GetValue()
	if SOUNDS.Background ~= nil then
		SOUNDS.Background:setVolume( SETTINGS.Sound.MusicVolume / 100 )
	end
	love.filesystem.write( SETTINGS.FilePath, Tserial.pack(SETTINGS) )
end
PUI.settingsTabsTab2.OKButton = loveframes.Create("button", PUI.settingsTabsTab2)
PUI.settingsTabsTab2.OKButton:SetText( "OK" )
PUI.settingsTabsTab2.OKButton:SetPos( PUI.settingsFrame:GetWidth() - PUI.settingsTabsTab2.OKButton:GetWidth() - 10, PUI.settingsFrame:GetHeight() - PUI.settingsTabsTab2.OKButton:GetHeight() - 35 )
PUI.settingsTabsTab2.OKButton.OnClick = function( object, x, y )
	PUI.settingsTabsTab2.applyButton.OnClick()
	love.keypressed("escape", "")
end
PUI.settingsTabs:AddTab("Sound", PUI.settingsTabsTab2, "Sound settings", "images/sound.png")

--PUI.settingsTabs:SwitchToTab(2)
	
--[[	***
	END: In separate file!
		***]]