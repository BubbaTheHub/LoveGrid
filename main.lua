-- This basic mockup is my first attempt at making a game.
-- It is licenced under Creative Commons Attribution 3.0
-- I'd love to see what you do with it.
-- Hit me up at berntzen@gmail.com

function love.load()
-- set up globals here
	
--	music=love.audio.newSource("music/blacksands.mp3")
--	love.audio.play(music,0,true) --plays the music,don't know,loop
	
	-- the wonderful keyRepeat!
	love.keyboard.setKeyRepeat(10, 200)
	
	love.graphics.setFont("vag.ttf", 56) -- fontfile, size
	
	infoBar ={
		message = "",
		duration = 0
	}
   
   squareHeight = 80
   squareWidth = 100
   
	player = {
		grid_x = 200, -- squares from left * squareWidth
        grid_y = 160, -- squares from top * squareHeight
        act_x = 200,
        act_y = 160,
        speed = 15,
        face = {}, --"up", "down", "left", "right"
        dir = 1,
        score = 0,
        inventory = {
        	canSwim = 0, 	--Perhaps all
        	hasSword = 0, 	--these are better
        	hasKey = 0		--off being booleans?
        },					--How is this in Lua?
    }
    
    for i=0,3 do -- change 3 to the number of player face images including 0.
		player.face[i] = love.graphics.newImage( "images/player"..i..".png" )
	end
end

-- Load the first level.
require "maps/level1/level1"
level1()
-- Consequent levels are called from within whichever level you are at.
-- For example when you enter a door, defeat a dragon, fall through a hole or what ever.


function love.update(dt)
	--sweet smooth player moove transition
    player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)
    player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
    
    
end

function love.draw()
-- which line is the player at?
playerLine = player.grid_y/squareHeight

-- the map
    for y=1, #map do
        for x=1, #map[y] do
        	love.graphics.draw(tile[map[y][x]], x * squareWidth, y * squareHeight )
        	-- Did you remember to count all the tile images when you set the table in the level?
        	-- Otherwise you are thrown an error concerning user data...
        	
        	-- Draw artifacts here as well if you want terrain to overlap them.
        	-- love.graphics.draw(artifact[artifact_map[y][x]], x * squareWidth, y * squareHeight )
        end
    end
   
-- the artifacts
-- This is split up in two because we need to draw the player in front of some artifacts,
-- and behind others. Feel free to beutify this if you know how...
    for y=1, playerLine-1 do
        for x=1, #artifact_map[y] do
        	love.graphics.draw(artifact[artifact_map[y][x]], x * squareWidth, y * squareHeight )
        	-- did you remember to count all the artifact images when you set the table in the level?
        	-- Otherwise you are thrown an error concerning user data...
        end 
    end
-- the player
    love.graphics.draw(player.face[player.dir], player.act_x, player.act_y )
    
    for y=playerLine, #artifact_map do
        for x=1, #artifact_map[y] do
        	love.graphics.draw(artifact[artifact_map[y][x]], x * squareWidth, y * squareHeight )
        	-- did you remember to count all the artifact images when you set the table in the level?
        	-- Otherwise you are thrown an error concerning user data...
        end 
    end      

-- display messages
	displayInfoBar()
    
end

function love.keypressed(key)
    if key == "up" then
    	player.dir = 0
        if testMap(0, -1) then
            player.grid_y = player.grid_y - squareHeight
        end
	elseif key == "down" then
		player.dir = 1
        if testMap(0, 1) then
            player.grid_y = player.grid_y + squareHeight
        end
    elseif key == "left" then
    	player.dir = 2
        if testMap(-1, 0) then
            player.grid_x = player.grid_x - squareWidth
        end
    elseif key == "right" then
    	player.dir = 3
        if testMap(1, 0) then
            player.grid_x = player.grid_x + squareWidth
        end
    end
end


function displayInfoBar()
	-- get delta time
	dt = love.timer.getDelta( )
	
	
	if infoBar.duration > 0 then
		-- show the message
		love.graphics.print(infoBar.message, 100, 50, 0, 1, 1)
		infoBar.duration = infoBar.duration * dt
	else
		-- remove the message
		infoBar.duration = 0
		infoBar.message = ""
	end
	
	-- show the score
    love.graphics.print("Score: " ..player.score, 1000, 50, 0, 1, 1)
	return true
end