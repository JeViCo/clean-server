local SelectedName = "Выбрать ..."
local SelectedMarker
local eDB = {
    gridlist = {},
    button = {},
    window = {},
	column = {},
}

local eDB_Extra = {
    edit = {},
    button = {},
    label = {},
    window = {},
}

local function centerWindow(center_window)
    local screenW,screenH=guiGetScreenSize()
    local windowW,windowH=guiGetSize(center_window,false)
    local x,y = (screenW-windowW)/2,(screenH-windowH)/2
    guiSetPosition(center_window,x,y,false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		setElementData(getLocalPlayer(), "sel_data", false)
		
		eDB.window[1] = guiCreateWindow(478, 301, 305, 377, "Браузер данных", false)
		guiWindowSetSizable(eDB.window[1], false)
		guiSetVisible(eDB.window[1], false)
		
		eDB.button[1] = guiCreateButton(10, 28, 76, 27, "Выбрать ...", false, eDB.window[1])
		guiSetProperty(eDB.button[1], "NormalTextColour", "FFAAAAAA")
		eDB.button[2] = guiCreateButton(217, 28, 74, 27, "Обновить", false, eDB.window[1])
		guiSetProperty(eDB.button[2], "NormalTextColour", "FFAAAAAA")
		eDB.button[8] = guiCreateButton(131, 28, 76, 27, "Сброс", false, eDB.window[1])
		guiSetProperty(eDB.button[8], "NormalTextColour", "FFAAAAAA")
		eDB.gridlist[2] = guiCreateGridList(10, 65, 197, 299, false, eDB.window[1])
		guiGridListSetSortingEnabled(eDB.gridlist[2], false)
		eDB.column[1] = guiGridListAddColumn(eDB.gridlist[2], "Значение+", 0.6)
		eDB.column[2] = guiGridListAddColumn(eDB.gridlist[2], "Value", 0.3)
		eDB.button[3] = guiCreateButton(217, 65, 76, 27, "Создать", false, eDB.window[1])
		guiSetProperty(eDB.button[3], "NormalTextColour", "FFAAAAAA")
		eDB.button[4] = guiCreateButton(217, 102, 76, 27, "Редактировать", false, eDB.window[1])
		guiSetProperty(eDB.button[4], "NormalTextColour", "FFAAAAAA")
		eDB.button[5] = guiCreateButton(217, 139, 76, 27, "Удалить", false, eDB.window[1])
		guiSetProperty(eDB.button[5], "NormalTextColour", "FFAAAAAA")
		eDB.button[6] = guiCreateButton(219, 176, 76, 27, "Удалят все", false, eDB.window[1])
		guiSetProperty(eDB.button[6], "NormalTextColour", "FFAAAAAA")
		eDB.button[7] = guiCreateButton(217, 337, 76, 27, "Закрыть", false, eDB.window[1])
		guiSetProperty(eDB.button[7], "NormalTextColour", "FFAAAAAA")



		eDB_Extra.window[1] = guiCreateWindow(445, 396, 279, 179, "Создать", false)
		guiWindowSetSizable(eDB_Extra.window[1], false)
		guiSetVisible(eDB_Extra.window[1], false)

		eDB_Extra.label[1] = guiCreateLabel(10, 27, 115, 15, "Название:", false, eDB_Extra.window[1])
		eDB_Extra.edit[1] = guiCreateEdit(10, 42, 257, 30, "", false, eDB_Extra.window[1])
		eDB_Extra.button[1] = guiCreateButton(10, 137, 115, 30, "Добавить", false, eDB_Extra.window[1])
		guiSetProperty(eDB_Extra.button[1], "NormalTextColour", "FFAAAAAA")
		eDB_Extra.label[2] = guiCreateLabel(10, 82, 115, 15, "Значение:", false, eDB_Extra.window[1])
		eDB_Extra.edit[2] = guiCreateEdit(10, 97, 257, 30, "", false, eDB_Extra.window[1])
		eDB_Extra.button[3] = guiCreateButton(154, 139, 115, 30, "Отмена", false, eDB_Extra.window[1])
		guiSetProperty(eDB_Extra.button[3], "NormalTextColour", "FFAAAAAA")


		centerWindow(eDB.window[1])
		centerWindow(eDB_Extra.window[1])
		addEventHandler("onClientGUIClick", eDB_Extra.button[1], addElementData, false)
		addEventHandler("onClientGUIClick", eDB_Extra.button[3], function() guiSetVisible(eDB_Extra.window[1], false) end, false)
		addEventHandler("onClientGUIClick", eDB.button[2], getData, false)
		addEventHandler("onClientGUIClick", eDB.button[4], editElementData, false)
		addEventHandler("onClientGUIClick", eDB.button[5], removeElementData, false)
		addEventHandler("onClientGUIClick", eDB.button[6], removeAllElementData, false)
		addEventHandler("onClientGUIClick", eDB.button[1], selectSomething, false)
		addEventHandler("onClientGUIClick", eDB.button[8], resetSelected, false)
		addEventHandler("onClientGUIClick", eDB.button[7], 
			function()
				guiSetVisible(eDB.window[1], false)
				showCursor(false)
			end, 
		false)
		addEventHandler("onClientGUIClick", eDB.button[3], 
			function() 
				guiSetEnabled(eDB_Extra.edit[1], true)
				guiSetVisible(eDB_Extra.window[1], true)
				guiBringToFront(eDB_Extra.window[1]) 
				guiSetText(eDB_Extra.button[1], "Добавить")
				guiSetText(eDB_Extra.window[1], "Создать")
			end, 
		false)
	end
)

addEvent("openEDB", true)
addEventHandler("openEDB", getRootElement(), 
	function()
		if guiGetVisible(eDB.window[1]) == true then
			guiSetVisible(eDB.window[1], false)
			showCursor(false)
		else
			guiSetVisible(eDB.window[1], true)
			showCursor(true)	
		end
	end,
false)

function findPlayer(pname)
	for i, p in ipairs(getElementsByType("player")) do 
		if string.gsub(getPlayerName(p), '#%x%x%x%x%x%x', '') == pname then
			return p;
		end
	end		
end

function addElementData()
	if getElementData(getLocalPlayer(), "sel_data") then
		element = getElementData(getLocalPlayer(), "sel_data")
	else
		print("Элемент не выбран!", 125, 0, 0, true)
	end
	if guiGetText(eDB_Extra.edit[1]) ~= "" and guiGetText(eDB_Extra.edit[2]) ~= "" then
		setElementData(element, guiGetText(eDB_Extra.edit[1]), guiGetText(eDB_Extra.edit[2]))
	end
	guiSetEnabled(eDB_Extra.edit[2], true)
	guiSetVisible(eDB_Extra.window[1], false)
	guiSetText(eDB_Extra.edit[1], "")
	guiSetText(eDB_Extra.edit[2], "")
	getData(eDB.button[2])
end

function editElementData()
	if source == eDB.button[4] then
		guiSetEnabled(eDB_Extra.edit[2], true)
		local sR, sC = guiGridListGetSelectedItem(eDB.gridlist[2])
		guiSetText(eDB_Extra.edit[1], guiGridListGetItemText(eDB.gridlist[2], sR, 1))
		guiSetText(eDB_Extra.edit[2], guiGridListGetItemText(eDB.gridlist[2], sR, 2))
		guiSetVisible(eDB_Extra.window[1], true)
		guiBringToFront(eDB_Extra.window[1])
		guiSetText(eDB_Extra.button[1], "Установить")
		guiSetText(eDB_Extra.window[1], "Редактировать")
		guiSetEnabled(eDB_Extra.edit[1], false)
		if guiGetText(eDB_Extra.edit[1]) == "sel_data" then
			guiSetEnabled(eDB_Extra.edit[2], false)
		end
	end
end

function getData(button)
	if source == eDB.button[2] or button == eDB.button[2] then
		local element = false;
		if getElementData(getLocalPlayer(), "sel_data") then
			element = getElementData(getLocalPlayer(), "sel_data")
		else
			print("Элемент не выбран!", 125, 0, 0, true)
		end
		if element then
			triggerServerEvent("onRequestAllElementData", getLocalPlayer(), element)
		end
	end
end

function removeElementData()
	if source == eDB.button[5] then
		local element = false;
		if getElementData(getLocalPlayer(), "sel_data") then
			element = getElementData(getLocalPlayer(), "sel_data")
		else
			outputChatBox("Элемент не выбран!", 125, 0, 0, true)
		end	
		local sR2, sC2 = guiGridListGetSelectedItem(eDB.gridlist[2])
		local key = guiGridListGetItemText(eDB.gridlist[2], sR2, sC2)		
		triggerServerEvent("onRequestToRemoveElementData", getLocalPlayer(), "this", element, key)
	end
end

function removeAllElementData()
	if source == eDB.button[6] then
		local element = false;
		if getElementData(getLocalPlayer(), "sel_data") then
			element = getElementData(getLocalPlayer(), "sel_data")
		else
			outputChatBox("Элемент не выбран!", 125, 0, 0, true)
		end	
		triggerServerEvent("onRequestToRemoveElementData", getLocalPlayer(), "all", element)
	end
end


function selectSomething_Now(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (clickedElement) then
		setElementData(getLocalPlayer(), "sel_data", clickedElement)
		guiSetVisible(eDB.window[1], true)
		getData(eDB.button[2])
		removeEventHandler("onClientRender", root, show_SelectInfo)
		removeEventHandler("onClientClick", getRootElement(),	selectSomething_Now)
		guiSetText(eDB.button[1], SelectedName)
		if isElement(SelectedMarker) then
			local attachTo = getElementAttachedTo(SelectedMarker)
			if attachTo then
				detachElements(SelectedMarker, attachTo)
				attachElements(SelectedMarker, clickedElement, 0, 0, 2)
			else
				attachElements(SelectedMarker, clickedElement, 0, 0, 2)
			end
		else
			local x, y, z = getElementPosition(clickedElement)
			SelectedMarker = createMarker(x, y, z, "arrow", 1, 255, 255, 0, 255)
			attachElements(SelectedMarker, clickedElement, 0, 0, 2)
		end
	end
end

function selectSomething()
	if source == eDB.button[1] then
		guiSetVisible(eDB.window[1], false)
		addEventHandler("onClientRender", root, show_SelectInfo)
		setTimer(function()
		addEventHandler("onClientClick", getRootElement(),	selectSomething_Now)
		end, 100, 1)
	end
end

function resetSelected()
	if source == eDB.button[8] then
		setElementData(getLocalPlayer(), "sel_data", false)
		SelectedName = "Выбрать ..."
		guiSetText(eDB.button[1], SelectedName)
		if isElement(SelectedMarker) then
			destroyElement(SelectedMarker)
		end
		guiGridListClear(eDB.gridlist[2])
	end
end

addEvent("onClientRequestAllElementData", true)
addEventHandler("onClientRequestAllElementData", getRootElement(), 
	function(allElementData)
		guiGridListClear(eDB.gridlist[2])
		for k, v in pairs(allElementData) do 
			local row = guiGridListAddRow(eDB.gridlist[2])
			guiGridListSetItemText(eDB.gridlist[2], row, eDB.column[1], tostring(k), false, false)
			guiGridListSetItemText(eDB.gridlist[2], row, eDB.column[2], tostring(v), false, false)
		end
	end
)



local r, g, b = 0, 0, 0
local state = "up"
local wx, wy = guiGetScreenSize()
function show_SelectInfo()
	if state == "up" then
		if r < 255 then
			r = r + 3
		elseif g < 255 then
			g = g + 3
		elseif b < 255 then
			b = b + 3
		else
			state = "down"
		end
	elseif state == "down" then
		if r > 0 then
			r = r - 3
		elseif g > 0 then
			g = g - 3
		elseif b > 0 then
			b = b - 3
		else
			state = "up"
		end
	end
	dxDrawText("Выберите объект, авто, игрока или педа.", 0, wy-wy/4, wx, wy-wy/4, tocolor(r, g, b, 255), 1, "bankgothic", "center", "center", false, false, true, false, false)
	local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
	local px, py, pz = getCameraMatrix()
	local hit, x, y, z, elementHit = processLineOfSight ( px, py, pz, worldx, worldy, worldz )
	if elementHit then
		if getElementType(elementHit) == "player" then
			name = getPlayerName(elementHit)
		elseif getElementType(elementHit) == "ped" then
			name = "N/A"
		elseif getElementType(elementHit) == "vehicle" then
			name = getVehicleName(elementHit)
		elseif getElementType(elementHit) == "object" then
			name = "N/A"
		end
		if getElementType(elementHit) == "player" then
			local pname = string.gsub(name, '#%x%x%x%x%x%x', '')
			if #pname > 8 then
				dxDrawRectangle(screenx*wx+10, screeny*wy+10, 120 + (#pname - 8) * 8, 60, tocolor(0, 0, 0, 127.5))
			else
				dxDrawRectangle(screenx*wx+10, screeny*wy+10, 120, 60, tocolor(0, 0, 0, 127.5))
			end
		else
			dxDrawRectangle(screenx*wx+10, screeny*wy+10, 120, 60, tocolor(0, 0, 0, 127.5))
		end
		dxDrawText("Элемент: "..getElementType(elementHit).."\nМодель: "..getElementModel(elementHit).."\nНазвание: "..name, screenx*wx+15, screeny*wy+15, screenx*wx+50, screeny*wy+50, tocolor(255, 255, 255, 255), 1, "sans", "left", "top", false, false, true, true, false)
		if #string.gsub(name, '#%x%x%x%x%x%x', '') > 8 then
			SelectedName = string.sub(string.gsub(name, '#%x%x%x%x%x%x', ''), 0, 8) .. " .."
		else
			SelectedName = string.gsub(name, '#%x%x%x%x%x%x', '')
		end
	end
end