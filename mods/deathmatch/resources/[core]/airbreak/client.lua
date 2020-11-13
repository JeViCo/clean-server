minmult = 1.3 -- минимальная скорость
maxmult = 3 -- максимальная скорость

function startBreak ( )
	if true then
	
		local veh = getPedOccupiedVehicle(localPlayer)
		if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			el = veh
		else
			el = localPlayer
		end
		
		if air then
			air = false
			if veh then
				setElementFrozen(el, false)
				for _, oc in pairs(getVehicleOccupants(el)) do
					triggerServerEvent("setAlpha",localPlayer,oc,255)
				end
				triggerServerEvent("setAlpha",localPlayer,el,255)
			else
				triggerServerEvent("setAlpha",localPlayer,el,255)
			end
			setElementCollisionsEnabled ( el, true )
			removeEventHandler ( "onClientRender", getRootElement(), breakControls )
		else
			if veh then
				setElementFrozen(el, true)
				for _, oc in pairs(getVehicleOccupants(el)) do
					triggerServerEvent("setAlpha",localPlayer,oc,20)
				end
				triggerServerEvent("setAlpha",localPlayer,veh,20)
			else
				triggerServerEvent("setAlpha",localPlayer,el,20)
			end
			setElementCollisionsEnabled ( el, false )
			addEventHandler ( "onClientRender", getRootElement(), breakControls )
			air = true
		end
	end
end
--bindKey ("rshift", "down", startBreak)

local screenSize = Vector2( guiGetScreenSize() )

function breakControls()
	--if not isCursorShowing() and not isMTAWindowActive() then
	if not isMTAWindowActive() then
		local veh = getPedOccupiedVehicle(localPlayer)
		if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			el = veh
		else
			el = localPlayer
		end
		
		local px, py, pz = getElementPosition ( el )
		local rx, ry, rz = getElementRotation ( el )
		if ( getKeyState ( "lshift" ) ) then
			mult = maxmult
		else
			mult = minmult
		end
		if ( getKeyState("w") ) then
			local x = (0.4*mult)*math.cos((rz+90)*math.pi/180)
			local y = (0.4*mult)*math.sin((rz+90)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementPosition (el, nx, ny, pz )
		end
		if ( getKeyState("s") ) then		
			local x = -(0.4*mult)*math.cos((rz+90)*math.pi/180)
			local y = -(0.4*mult)*math.sin((rz+90)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementPosition (el, nx, ny, pz )
		end
		if ( getKeyState("a") ) then
			local x = -(0.4*mult)*math.cos((rz)*math.pi/180)
			local y = -(0.4*mult)*math.sin((rz)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementPosition ( el, nx, ny, pz )
		end
		if ( getKeyState("d") ) then
			local x = (0.4*mult)*math.cos((rz)*math.pi/180)
			local y = (0.4*mult)*math.sin((rz)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementPosition ( el, nx, ny, pz )
		end
		if ( getKeyState("arrow_u") or getKeyState("space")) then		
			setElementPosition (el, px, py, pz + (0.5*mult))
		end
		if ( getKeyState("arrow_d") or getKeyState("lctrl")) then		
			setElementPosition (el, px, py, pz - (0.5*mult))
		end
		local rz = findRotation()
		if getElementType(el) == "player" then
			setElementRotation(el,rx,ry,-rz)
		else
			setElementRotation(el,0,0,rz)
		end
	end
end

function onbsp(cmd, stand, val)
	if getElementData(localPlayer,"player:hasAdminRights") then
		if not stand then
			outputChatBox("Вы не ввели параметр! Возможны: start/end")
		else
			if not tonumber(val) then
				outputChatBox("Вы не ввели параметр! Возможны любые числа.")
			else
				if string.lower(stand) == "start" then
					minmult = tonumber(val)
					outputChatBox("параметр '"..stand.."' был изменён на "..val)
				elseif string.lower(stand) == "end" then
					maxmult = tonumber(val)
					outputChatBox("параметр '"..stand.."' был изменён на "..val)
				end
			end
		end
	end
end

function onrebsp(cmd, stand)
	if getElementData(localPlayer,"player:hasAdminRights") then
		if not stand then
			outputChatBox("Вы не ввели параметр! Возможны: start/end")
		else
			if string.lower(stand) == "start" then
				minmult = 1.3
				outputChatBox("параметр '"..stand.."' был восстановлен.")
			elseif string.lower(stand) == "end" then
				maxmult = 3
				outputChatBox("параметр '"..stand.."' был восстановлен.")
			end
		end
	end
end

addEventHandler ( "onClientResourceStart", resourceRoot, 
	function ()
		bindKey ( "rshift", "down", startBreak )
		air = false
		
		addCommandHandler("bsp",onbsp)
		addCommandHandler("rebsp",onrebsp)
	end
)

function findRotation() 
	local x1, y1, z1, x2, y2, z2 = getCameraMatrix()
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

--

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

addCommandHandler("getMarkerInfo", function()
	local x,y,z = getElementPosition(localPlayer)
	x,y,z = math.round(x, 2), math.round(y, 2), math.round(z, 2)
    local _,_,r = getElementRotation ( localPlayer ) 
    local x2 = math.round(x - math.sin ( math.rad ( r + 180 ) ) * 1.8, 2)
    local y2 = math.round(y + math.cos ( math.rad ( r + 180 ) ) * 1.8, 2)
	outputConsole(string.format("Enter: px = %.2f, py = %.2f, pz = %.2f",x,y,z-0.9) .. "\n" .. string.format("Exit: px = %.2f, py = %.2f, pz = %.2f",x2,y2,z) .. "\n" .. string.format("Player: px = %.2f, py = %.2f, pz = %.2f, rot = %d",x,y,z,math.floor(r)) .. "\n\n")
end)
addCommandHandler("getCamInfo", function()
	local x1,y1,z1,x2,y2,z2 = getCameraMatrix()
	outputConsole(string.format("From: x = %.2f, y = %.2f, z = %.2f",x1,y1,z1) .. "\n" .. string.format("To: x = %.2f, y = %.2f, z = %.2f",x2,y2,z2) .. "\n\n")
end)