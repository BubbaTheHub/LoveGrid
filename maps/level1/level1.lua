function level1()

--	love.audio.stop( )
--	music=love.audio.newSource("music/64bytes.mp3")
--	swordSound = love.audio.newSource("maps/level1/sounds/sword.wav")
--	love.audio.play(music,0,true) --plays the music,don't know,loop
	
	--from here
	tile = {}
	for i=0,5 do -- change 4 to the number of tile images minus 1.
		tile[i] = love.graphics.newImage( "maps/level1/images/tile"..i..".png" )
	end
   
	artifact = {}
	for i=0,16 do -- number of atifacts minus 1.
		artifact[i] = love.graphics.newImage( "maps/level1/images/artifact"..i..".png" )
	end
	-- to here

    -- 23x17 tile space
   map={
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 2, 2, 3, 3, 3, 3, 3, 4, 2, 2, 2, 2, 0},
   { 0, 2, 2, 3, 3, 3, 3, 3, 4, 2, 2, 2, 2, 0},
   { 0, 2, 2, 3, 3, 3, 3, 3, 4, 2, 2, 2, 2, 0},
   { 0, 4, 4, 4, 4, 3, 3, 3, 4, 2, 2, 2, 2, 0},
   { 0, 4, 4, 4, 4, 3, 3, 3, 4, 3, 3, 2, 3, 0},
   { 0, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 2, 3, 0},
   { 0, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 2, 3, 0},
   { 0, 4, 4, 4, 4, 1, 1, 1, 1, 3, 3, 3, 3, 0},
   { 0, 4, 4, 4, 4, 1, 1, 1, 1, 3, 3, 3, 3, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   }
   
   artifact_map={
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 12, 12, 13, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 15, 16, 14, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 3, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0},
   { 0, 0, 5, 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   }
   
   
function testMap(x, y)
-- check for artifacts, then move if there is none
    if testArtifactMap(x, y) then
    
-- is tile on map passable
    	if map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 0 then
        	return false
    	end
 
-- if it's water you need to know how to swim
    	if map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 4 then
    		if player.inventory.canSwim == 1 then
    			return true
    		end
    		infoBar.message = "Du kan ikke svømme!"
        	infoBar.duration = 200
        	return false
    	end
    	return true
    end -- end test artifact
    return false
end -- end test map (terrain)

function testArtifactMap(x, y)
    -- check for different artifacts
	
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 2 then
        infoBar.message = "Du fant en skatt!"
        infoBar.duration = 200
        player.score = player.score + 1000
        artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] = 0
        return false
    end
    
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 3 then
    	-- Show the player what he found
        infoBar.message = "You found Love!"
        infoBar.duration = 200
        
        -- Award some points
        player.score = player.score + 100
   		artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] = 0
        return false
    end
	
	if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 5 then
        infoBar.message = "Du fant en nøkkel"
        infoBar.duration = 200
        player.inventory.hasKey = 1
        artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] = 0
        return false
    end
	
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 6 then
    	-- Show the player what he found
        infoBar.message = "Du har lært å svømme!"
        infoBar.duration = 200
        
        -- Award some points
        player.inventory.canSwim = 1
   		artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] = 0
        return false
    end
       
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 7 then
		-- you stumped your foot on a tree
        return false
    end 
    
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 10 then
		-- you stumped your foot on something
        return false
    end
    
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 11 then
		-- you stumped your foot on something
        return false
    end
	
	if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 12 then
		-- you stumped your foot on something
        return false
    end
    
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 13 then
		-- you stumped your foot on something
        return false
    end
    
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 14 then
		-- you stumped your foot on something
        return false
    end
    
    -- A doorway
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 15 then
    	if player.inventory.hasKey == 1 then
    		-- A doorway
    		player.inventory.hasKey = 0
        	require "maps/level2/level2" -- exclude ".lua" according to love2d wiki
        	level2()
        	return true
        end
        infoBar.message = "Døren er låst!"
        infoBar.duration = 200
        return false
	end
    
    if artifact_map[(player.grid_y / squareHeight) + y][(player.grid_x / squareWidth) + x] == 16 then
		-- you stumped your foot on something
        return false
    end
    
    -- return true for passable terrain
    return true
end
end -- function end