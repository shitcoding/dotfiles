-- Hammerspoon config

---------------- Switch to the last space with cmd-0 --------------------
-- Set MCwaitTime for fast but stable animation
hs.spaces.MCwaitTime = 0.3

-- Function to get the UUID of the main built-in display with multiple spaces
local function getTargetScreenUUID()
    local allSpaces = hs.spaces.allSpaces()
    if not allSpaces then
        print("Error fetching all spaces")
        return nil
    end

    for screenUUID, spaces in pairs(allSpaces) do
        local screen = hs.screen.find(screenUUID)
        if screen and screen:name() == "Built-in Retina Display" and #spaces > 1 then
            return screenUUID
        end
    end

    print("No suitable screen found with multiple spaces.")
    return nil
end

-- Function to switch to the last space on a specific screen
local function switchToLastSpace()
    local inspect = require("hs.inspect")
    local allSpaces, err = hs.spaces.allSpaces()

    if not allSpaces then
        print("Error fetching all spaces:", err)
        return
    end

    -- Dynamically get the UUID of the target screen
    local screenUUID = getTargetScreenUUID()
    if not screenUUID then
        print("Target screen UUID not found.")
        return
    end

    -- Check if the UUID exists in allSpaces
    if allSpaces[screenUUID] then
        -- Get the last space for this screen
        local lastSpaceID = allSpaces[screenUUID][#allSpaces[screenUUID]]
        print("Last Space ID:", lastSpaceID)

        -- Attempt to switch to this space
        local success, errorMsg = hs.spaces.gotoSpace(lastSpaceID)
        if not success then
            print("Failed to switch to last space:", errorMsg)
        end
    else
        print("Screen UUID not found in allSpaces.")
    end
end

-- Bind the function to Cmd-0
hs.hotkey.bind({"cmd"}, "0", switchToLastSpace)
-------------------------------------------------------------------------
