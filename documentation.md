## BloxSteeringWheel Documentation
The BloxSteeringWheel module has a number of properties, methods, and events that developers can make use of in their games.

### Importing
To import this module, visit [the Roblox marketplace page](https://www.roblox.com/library/12892264793/BloxSteeringWheel).

Once you have imported this module, it is recommended that you put it inside a LocalScript that handles player inputs.
```lua
local WheelController = require(script:WaitForChild("BloxSteeringWheel"))
```

### Properties
- buttonsPressed : {}
    - The `buttonsPressed` property includes various buttons that can be pressed on steering wheels. **This list is not complete, as this module does not yet support all steering wheels - there might be functionality overlapping between different wheels, but that is up to the users/developers to report/request.
    - Properties:
        - [Enum.KeyCode.ButtonA] : Boolean : Button 1
		- [Enum.KeyCode.ButtonB] : Boolean : Button 2
		- [Enum.KeyCode.Y] : Boolean : Button 3
		- [Enum.KeyCode.X] : Boolean : Button 4
		- [Enum.KeyCode.ButtonR1] : Boolean : R1
		- [Enum.KeyCode.ButtonL1] : Boolean : L1
		- [Enum.KeyCode.DPadDown] : Boolean : Bottom group left bottom button
		- [Enum.KeyCode.DPadRight] : Boolean : Bottom group right bottom button
		- [Enum.KeyCode.DPadUp] : Boolean : Bottom group top right button
		- [Enum.KeyCode.DPadLeft] : Boolean : Bottom group top left button
- axes: {}
    - The `axes` property includes information about the X and Y of the player's steering. (X is steering wheel left/right, Y is pedals gas/brake)
    - Properties:
        - x : Number : Value between -1 and 1 (-1 is max left, 1 is max right)
        - y : Number : Value between -1 and 1 (-1 is full brake, 1 is full gas)
- takingInput : Boolean
    - The `takingInput` property is just a built-in property to make it clear whether the module is currently active or not. **The module ignores this, developers have to make sure they check/change this variable on their own**

### Functions
- calibrate : function
    - The `calibrate` function is available, as Roblox sometimes messes up Delta (movement change) values when the player changes their inputs too suddenly, this function can be used to re-calibrate.
    - Parameters:
        - axis : String : "x" or "y" (the axis to re-calibrate)
        - calibrationValue : Number : Number between -1 and 1, signifying what value to re-calibrate to (For instance, ask the player to steer to the right as much as possible, and then call this function with "x" axis and calibrationValue set to 1)
    - Example code snippet:
        ```lua
        WheelController.calibrate(`x`, 0) -- sets the current position of the steering wheel as x = 0
        ```
- getButtonPressed : function
    - The `getButtonPressed` function returns whether the specified button is pressed - it is merely an alias for the properties in `WheelController.buttonsPressed`.
    - Parameters:
        - keyCode : Enum.KeyCode : KeyCode for the button to get info about
- on : function
    - The `on` function makes a new event listener with your callback.
    - Parameters:
        - event : string : Name of event to change
            - "xChanged"
            - "yChanged"
            - "buttonsUp"
            - "buttonsDown"
        - subevent : Enum.KeyCode : KeyCode of subevent (only applies when event is `buttonsUp` or `buttonsDown`) (this should be nil if event is yChanged or xChanged)
        - callback : function : Function to run whenever the event occurs
            - callback parameters:
                - yChanged & xChanged:
                    - newValue : Number : Value between -1 and 1 indicating what the new x/y value of the controller is.
                    - delta : Number : Value between -2 and 2 indicating how much the x/y value has changed since it was last updated.
                - All other events:
                    - No parameters.
            - Example code snippet:
                ```lua
                WheelController.on(`yChanged`, nil, function(y, yDelta) -- adds event listener
                    print(`The new y value is {y}`) -- prints new y value
                    print(`The y value is now different from the previous by {yDelta}`) -- prints y value change since last input
                end)
                ```
    - Returns:
        - eventListenerId : String
            - This ID can be used to disconnect an existing event listener.
- removeListener : function
    - The `removeListener` function is used to remove existing event listeners so that they will no longer be fired.
        - event : string : Name of event to change
            - "xChanged"
            - "yChanged"
            - "buttonsUp"
            - "buttonsDown"
        - subevent : Enum.KeyCode : KeyCode of subevent (only applies when event is `buttonsUp` or `buttonsDown`) (this should be nil if event is yChanged or xChanged)
        - eventListenerId : String : ID of the event listener to remove/delete
    - Example code snippet:
        ```lua
        local shouldListenToY = true
        local listenerId = nil

        listenerId = WheelController.on(`yChanged`, nil, function(y, yDelta) -- adds event listener
            if not shouldListenToY then WheelController.removeListener(`yChanged`, nil, listenerId)
        end)
        ```
  
  
That is all for now!