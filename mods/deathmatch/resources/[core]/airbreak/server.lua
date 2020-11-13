addEvent("setAlpha",true)
addEventHandler("setAlpha",getRootElement(),function(el,alpha)
	setElementAlpha(el,alpha)
	if getElementType(el) == "player" then
		toggleControl(el, "enter_exit", not isControlEnabled(el, "enter_exit"))
	end
end)