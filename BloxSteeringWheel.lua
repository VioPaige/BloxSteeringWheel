-- Services
local uiService = game:GetService(`UserInputService`)


-- Module
local controller = {
	--[[
		ButtonsPressed shows which buttons are currently pressed, in comment here are the buttons they represent on steering wheel (not all steering wheels are supported (yet))
	]]
	buttonsPressed = {
		[Enum.KeyCode.ButtonA] = false, -- 1
		[Enum.KeyCode.ButtonB] = false, -- 2
		[Enum.KeyCode.Y] = false, -- 3
		[Enum.KeyCode.X] = false, -- 4
		[Enum.KeyCode.ButtonR1] = false, -- R1
		[Enum.KeyCode.ButtonL1] = false, -- L1
		[Enum.KeyCode.DPadDown] = false, -- bottom group left bottom
		[Enum.KeyCode.DPadRight] = false, -- bottom group right bottom
		[Enum.KeyCode.DPadUp] = false, -- bottom group right up
		[Enum.KeyCode.DPadLeft] = false, -- bottom group left up
	},
	--[[
		Axes represent how much the user is steering, throttling, or braking (float between -1 and 1)
	]]
	axes = {
		x = 0, -- steer
		y = 0, -- throttle / brake
	},



	--[[
		And now some utility to control the module from the outside
	]]
	takingInput = true, -- whether the local functions below are updating button presses and axes values
}



-- Script Core Values
--[[
	Listeners to be fired upon button presses
]]
local listeners = {
	xChanged = {},
	yChanged = {},
	buttonsUp = {
		[Enum.KeyCode.ButtonA] = {},
		[Enum.KeyCode.ButtonB] = {},
		[Enum.KeyCode.Y] = {},
		[Enum.KeyCode.X] = {},
		[Enum.KeyCode.ButtonR1] = {},
		[Enum.KeyCode.ButtonL1] = {},
		[Enum.KeyCode.DPadDown] = {},
		[Enum.KeyCode.DPadRight] = {},
		[Enum.KeyCode.DPadUp] = {},
		[Enum.KeyCode.DPadLeft] = {}
	},
	buttonsDown = {
		[Enum.KeyCode.ButtonA] = {},
		[Enum.KeyCode.ButtonB] = {},
		[Enum.KeyCode.Y] = {},
		[Enum.KeyCode.X] = {},
		[Enum.KeyCode.ButtonR1] = {},
		[Enum.KeyCode.ButtonL1] = {},
		[Enum.KeyCode.DPadDown] = {},
		[Enum.KeyCode.DPadRight] = {},
		[Enum.KeyCode.DPadUp] = {},
		[Enum.KeyCode.DPadLeft] = {}
	},
}




-- Functions
function inputBegan(input : InputObject, gpe : boolean)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
	if controller.buttonsPressed[input.KeyCode] == nil then return end
	
	controller.buttonsPressed[input.KeyCode] = true
	
	for index, callback in pairs(listeners.buttonsDown[input.KeyCode]) do
		-- sanity check
		if not callback then return end
		if typeof(callback) ~= `function` then return end

		callback()
	end
end

function inputEnded(input : InputObject, gpe : boolean)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
	if controller.buttonsPressed[input.KeyCode] == nil then return end

	controller.buttonsPressed[input.KeyCode] = false
	
	for index, callback in pairs(listeners.buttonsUp[input.KeyCode]) do
		-- sanity check
		if not callback then return end
		if typeof(callback) ~= `function` then return end

		callback()
	end
end

function inputChanged(input : InputObject, gpe : boolean)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
	
	if input.KeyCode == Enum.KeyCode.Thumbstick1 then
		controller.axes.x +=input.Delta.X
		controller.axes.y +=input.Delta.Y
		if input.Delta.Y ~= 0 then
			for index, callback in pairs(listeners.yChanged) do
				-- sanity check
				if not callback then continue end

				callback(controller.axes.y, input.Delta.Y)
			end
		end
		if input.Delta.X ~= 0 then
			for index, callback in pairs(listeners.xChanged) do
				-- sanity check
				if not callback then continue end

				callback(controller.axes.x, input.Delta.X)
			end
		end
	end

end

function controller.calibrate(axis, calibrationValue)
	if calibrationValue > 1 or calibrationValue < -1 then
		return warn(`WheelController.calibrate() - Second parameter has to be a (float) value between -1 and 1.`)
	end
	
	if axis == `x` then
		controller.axes.x = calibrationValue
		return true
	elseif axis == `y` then
		controller.axes.y = calibrationValue
	end
	
	return warn(`WheelController.calibrate() - Invalid axis.`)
end

function controller.getButtonPressed(keyCode)
	return controller.buttonsPressed[keyCode]
end

local pastListeners = 0
function controller.on(event, subevent, callback)
	pastListeners +=1
	
	local eventListenerId = `L{pastListeners}`

	if not callback then
		callback = subevent
		subevent = nil
	end
	
	if not listeners[event] then return warn(`The requested WheelController event "{event}" does not exist.`) end
	if subevent and not listeners[event][subevent] then return warn(`The requested WheelController subevent "{event}.{subevent}" does not exist`) end
	-- sanity check
	if not callback then return warn(`WheelController events require a non-nil callback.`) end
	
	if subevent then listeners[event][subevent][eventListenerId] = callback
	else listeners[event][eventListenerId] = callback end
	
end

function controller.removeListener(event, subevent, listenerId)
	if not listenerId then
		listenerId = subevent
		subevent = nil
	end
	
	if subevent then listeners[event][subevent][listenerId] = nil
	else listeners[event][listenerId] = nil end
end

function controller.getKeyValue(button, isEnum)
	if isEnum == false then button = Enum.KeyCode[button] end
	
	return controller.buttonsPressed[button]
end

-- Events
uiService.InputBegan:Connect(inputBegan)
uiService.InputEnded:Connect(inputEnded)
uiService.InputChanged:Connect(inputChanged)




return controller
