-- Hammerspoon config

---------------- Switch to the last space with cmd-0 --------------------
-- macOS 27 moved Mission Control's accessibility tree from the Dock to WindowManager
-- (Hammerspoon#3897), so hs.spaces.gotoSpace only flashes Mission Control and fails.
-- Open it ourselves and press the space button in WindowManager's tree instead:
--   mc.display (one per display, at its global position) > mc.spaces > mc.spaces.list > "Desktop N"
local TARGET_SCREEN = "Built-in Retina Display"

local function childWithId(el, id)
    for _, c in ipairs(el and el:attributeValue("AXChildren") or {}) do
        if c:attributeValue("AXIdentifier") == id then return c end
    end
end

-- The last space button of the display whose top-left corner matches `frame`, or nil
-- while Mission Control is still building its tree.
local function lastSpaceButton(wm, frame)
    for _, display in ipairs(hs.axuielement.applicationElement(wm):attributeValue("AXChildren") or {}) do
        local pos = display:attributeValue("AXPosition")
        if display:attributeValue("AXIdentifier") == "mc.display" and pos
            and math.abs(pos.x - frame.x) < 1 and math.abs(pos.y - frame.y) < 1 then
            local list = childWithId(childWithId(display, "mc.spaces"), "mc.spaces.list")
            local buttons = list and list:attributeValue("AXChildren") or {}
            return buttons[#buttons]
        end
    end
end

local function switchToLastSpace()
    local screen
    for _, s in ipairs(hs.screen.allScreens()) do
        if s:name() == TARGET_SCREEN then screen = s end
    end
    local wm = hs.application.get("com.apple.WindowManager")
    if not (screen and wm) then
        print("Cmd+0: no " .. TARGET_SCREEN .. " or no WindowManager")
        return
    end

    local frame, button = screen:fullFrame(), nil
    local deadline = hs.timer.secondsSinceEpoch() + 2
    hs.spaces.toggleMissionControl()
    hs.timer.waitUntil(function()
        button = lastSpaceButton(wm, frame)
        return button ~= nil or hs.timer.secondsSinceEpoch() > deadline
    end, function()
        if button then
            button:performAction("AXPress")
        else
            hs.spaces.toggleMissionControl()
            print("Cmd+0: last space button not found in WindowManager's Mission Control tree")
        end
    end, 0.05)
end

hs.hotkey.bind({"cmd"}, "0", switchToLastSpace)

-- 3-finger swipe down (BetterTouchTool trigger "Open URL" hammerspoon://closemissioncontrol).
-- macOS 27 ignores the synthetic Escape BTT's "Exit Mission Control" action sends, so close
-- it with the same toggle as above, and only while it is open (mc.display exists only then).
hs.urlevent.bind("closemissioncontrol", function() -- URL hosts arrive lowercased
    local wm = hs.application.get("com.apple.WindowManager")
    if wm and childWithId(hs.axuielement.applicationElement(wm), "mc.display") then
        hs.spaces.toggleMissionControl()
    end
end)
-------------------------------------------------------------------------

---------------- Auto-switch to English for terminal apps ----------------
local terminalApps = {"Ghostty", "Alacritty", "iTerm2", "Terminal", "kitty", "WezTerm", "com.mitchellh.ghostty"}

local function switchToEnglish()
    hs.keycodes.setLayout("U.S.")
end

local function isTerminalApp(appName)
    for _, term in ipairs(terminalApps) do
        if appName == term then
            return true
        end
    end
    return false
end

-- Event-driven: fires once per app activation (replaces a 10 Hz frontmost-app poll).
-- Global so the watcher isn't garbage-collected.
appWatcher = hs.application.watcher.new(function(appName, event, app)
    if event ~= hs.application.watcher.activated then return end
    if isTerminalApp(appName) or (app and isTerminalApp(app:bundleID())) then
        switchToEnglish()
    end
end)
appWatcher:start()
-------------------------------------------------------------------------
