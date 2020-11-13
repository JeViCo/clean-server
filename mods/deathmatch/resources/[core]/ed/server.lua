addEvent("onRequestToRemoveElementData", true)
addEvent("onRequestAllElementData", true)

function onRequestAllElementData(element)
	local allElementData = getAllElementData(element)
	triggerClientEvent(source, "onClientRequestAllElementData", source, allElementData)

end
addEventHandler("onRequestAllElementData", getRootElement(), onRequestAllElementData)

function onRequestToRemoveElementData(toRemove, element, key)
	if toRemove == "this" then
		if key ~= "sel_data" then
			removeElementData(element, key)
		end
	elseif toRemove == "all" then
		for k, v in pairs(getAllElementData(element)) do 
			if k ~= "sel_data" then
				removeElementData(element, k)
			end
		end
	end
	triggerClientEvent(source, "onClientRequestAllElementData", source, getAllElementData(element))
end
addEventHandler("onRequestToRemoveElementData", getRootElement(), onRequestToRemoveElementData)

addCommandHandler("edata", 
	function(player)
		if isObjectInACLGroup ( "user." .. getAccountName ( getPlayerAccount ( player ) ), aclGetGroup ( "Admin" ) ) then
			triggerClientEvent(player, "openEDB", getRootElement())
		end
	end
)