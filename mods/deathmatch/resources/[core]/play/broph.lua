local spawnpoints = {0, 2, 2}
local skin = 1

local data = {
	login = 'Логин',
	password = 'Пароль'
}

local function spawn(player)

	if player and isElement(player) then
		local x,y,z,r = unpack(spawnpoints[math.random(1,#spawnpoints)])
		spawnPlayer(player, Vector3(spawnpoint),0,skin,0,0)
		fadeCamera(player, true)
		setCameraTarget(player, player)
		showChat(player, true)
	end
	
end

local function onJoin()
	spawn(source)
end

local function onWasted()

	local t = tonumber(get("playerRespawnTime")) or 5000
	setTimer(spawn,(t > 50 and t or 50),1,source)

end

local function initScript()
	
	resetMapInfo()
	local players = getElementsByType("player")
	
	for _,player in ipairs(players) do spawn(player) end
	
	addEventHandler("onPlayerJoin",root,onJoin)
	addEventHandler("onPlayerWasted",root,onWasted)
	
end

addEventHandler("onResourceStart",resourceRoot,initScript)

--addCommandHandler("log",function(pl,cmd,...)
addEventHandler("onPlayerSpawn",root,function()
	logIn(source,getAccount ( data.login ), data.password)
	setPlayerScriptDebugLevel(source, 3)
end)
