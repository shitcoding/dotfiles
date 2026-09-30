-- Hammerspoon config

---------------- Switch spaces with cmd-1..9, cmd-0 = last space -------
-- Instead of macOS's animated space switch (the old BetterTouchTool "Switch To Desktop N"
-- shortcuts; even Reduce Motion only swaps the slide for a fade of the same length), open
-- Mission Control and press the space's button: it lands without the slide.
-- macOS 27 moved Mission Control's accessibility tree from the Dock to WindowManager
-- (Hammerspoon#3897), so hs.spaces.gotoSpace only flashes Mission Control and fails; read
-- WindowManager's tree directly:
--   mc.display (one per display, at its global position) > mc.spaces > mc.spaces.list > "Desktop N"
-- ponytail: every jump opens Mission Control, so it pays MC's CPU cost (~1 s of Apple
-- process time per jump); a gesture-based switcher (github.com/rileycx/strafe) is the
-- upgrade path if that shows.
local TARGET_SCREEN = "Built-in Retina Display"

local function childWithId(el, id)
    for _, c in ipairs(el and el:attributeValue("AXChildren") or {}) do
        if c:attributeValue("AXIdentifier") == id then return c end
    end
end

-- The space buttons of the display whose top-left corner matches `frame`, or nil while
-- Mission Control is still building its tree.
local function spaceButtons(wm, frame)
    for _, display in ipairs(hs.axuielement.applicationElement(wm):attributeValue("AXChildren") or {}) do
        local pos = display:attributeValue("AXPosition")
        if display:attributeValue("AXIdentifier") == "mc.display" and pos
            and math.abs(pos.x - frame.x) < 1 and math.abs(pos.y - frame.y) < 1 then
            local list = childWithId(childWithId(display, "mc.spaces"), "mc.spaces.list")
            local buttons = list and list:attributeValue("AXChildren")
            if buttons and #buttons > 0 then return buttons end
        end
    end
end

-- index: 1-based space number on TARGET_SCREEN, or nil for the last space.
local function switchToSpace(index)
    local screen
    for _, s in ipairs(hs.screen.allScreens()) do
        if s:name() == TARGET_SCREEN then screen = s end
    end
    local wm = hs.application.get("com.apple.WindowManager")
    if not (screen and wm) then
        print("space switch: no " .. TARGET_SCREEN .. " or no WindowManager")
        return
    end

    local frame, buttons = screen:fullFrame(), nil
    local deadline = hs.timer.secondsSinceEpoch() + 2
    hs.spaces.toggleMissionControl()
    hs.timer.waitUntil(function()
        buttons = spaceButtons(wm, frame)
        return buttons ~= nil or hs.timer.secondsSinceEpoch() > deadline
    end, function()
        local button = buttons and buttons[index or #buttons]
        if button then
            button:performAction("AXPress")
        else
            hs.spaces.toggleMissionControl()
            print("space switch: no button for space " .. tostring(index or "last") .. " in WindowManager's Mission Control tree")
        end
    end, 0.05)
end

hs.hotkey.bind({"cmd"}, "0", function() switchToSpace(nil) end)
for i = 1, 9 do
    hs.hotkey.bind({"cmd"}, tostring(i), function() switchToSpace(i) end)
end
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
