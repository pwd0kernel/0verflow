--[[
    0verflow Hub UI Library Loader
    Simple one-line loader for the UI library
]]

local Loader = {}

-- GitHub Repository Configuration
local REPO_URL = "https://raw.githubusercontent.com/pwd0kernel/0verflow/main/"

-- Load the main library and components
function Loader.Load()
    local success, UILibrary = pcall(function()
        return loadstring(game:HttpGet(REPO_URL .. "init.lua"))()
    end)
    
    if not success then
        error("Failed to load 0verflow UI Library: " .. tostring(UILibrary))
    end
    
    local success2, Components = pcall(function()
        return loadstring(game:HttpGet(REPO_URL .. "Components.lua"))()
    end)
    
    if not success2 then
        error("Failed to load 0verflow UI Components: " .. tostring(Components))
    end
    
    return UILibrary, Components
end

-- Quick setup function
function Loader.CreateWindow(config)
    local UILibrary, Components = Loader.Load()
    
    config = config or {}
    local Window = UILibrary.new(config)
    
    -- Enhanced tab creation that automatically adds components
    local originalCreateTab = Window.CreateTab
    Window.CreateTab = function(self, name)
        local tab = originalCreateTab(self, name)
        Components:AddToTab(tab)
        return tab
    end
    
    return Window, UILibrary, Components
end

return Loader
