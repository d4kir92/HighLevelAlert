-- By D4KiR
local _, HighLevelAlert = ...
HighLevelAlert:SetAddonOutput("HighLevelAlert", 136219)
local hlaset = nil
local DEFAULT_WIDTH = 520
local DEFAULT_HEIGHT = 520
function HighLevelAlert:ToggleSettings()
	if hlaset == nil then return end
	hlaset:Toggle()
end

local function GetCollapsed(key)
	if key == nil then return nil end
	if type(HLATAB) ~= "table" then return nil end
	if type(HLATAB["COLLAPSED"]) ~= "table" then return nil end
	return HLATAB["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	if key == nil then return end
	if type(HLATAB) ~= "table" then return end
	if type(HLATAB["COLLAPSED"]) ~= "table" then HLATAB["COLLAPSED"] = {} end
	if collapsed then
		HLATAB["COLLAPSED"][key] = true
	else
		HLATAB["COLLAPSED"][key] = nil
	end
end

local function AddCategory(key, level)
	hlaset:AddCategory({
		["label"] = "LID_" .. key,
		["key"] = key,
		["search"] = key,
		["level"] = level
	})
end

local function AddCheckbox(key, default, func)
	hlaset:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = HighLevelAlert:GV(HLATAB, key, default),
		["func"] = function(value)
			HighLevelAlert:SV(HLATAB, key, value)
			if func then func(value) end
		end
	})
end

local function AddSlider(key, default, min, max, step, decimals, func)
	hlaset:AddSlider({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = HighLevelAlert:GV(HLATAB, key, default),
		["min"] = min,
		["max"] = max,
		["step"] = step,
		["decimals"] = decimals,
		["func"] = function(value)
			HighLevelAlert:SV(HLATAB, key, value)
			if func then func(value) end
		end
	})
end

function HighLevelAlert:InitSettings()
	HLATAB = HLATAB or {}
	HighLevelAlert:SetVersion(136219, "0.5.0")
	HighLevelAlert:AddSlash("hla", HighLevelAlert.ToggleSettings)
	HighLevelAlert:AddSlash("highlevelalert", HighLevelAlert.ToggleSettings)
	hlaset = HighLevelAlert:CreateUIWindow({
		["name"] = "HighLevelAlertSettings",
		["pTab"] = {"CENTER"},
		["width"] = HighLevelAlert:GV(HLATAB, "WINDOWWIDTH", DEFAULT_WIDTH),
		["height"] = HighLevelAlert:GV(HLATAB, "WINDOWHEIGHT", DEFAULT_HEIGHT),
		["minWidth"] = 360,
		["minHeight"] = 240,
		["onResize"] = function(width, height)
			HighLevelAlert:SV(HLATAB, "WINDOWWIDTH", width)
			HighLevelAlert:SV(HLATAB, "WINDOWHEIGHT", height)
		end,
		["getCollapsed"] = function(key) return GetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
		["title"] = format("|T136219:16:16:0:0|t HighLevelAlert v%s", HighLevelAlert:GetVersion())
	})

	hlaset:SuspendLayout()
	hlaset:AddSearch()
	AddCategory("GENERAL")
	AddCheckbox("MMBTN", HighLevelAlert:GetWoWBuild() ~= "RETAIL", function(value)
		if value then
			HighLevelAlert:ShowMMBtn("HighLevelAlert")
		else
			HighLevelAlert:HideMMBtn("HighLevelAlert")
		end
	end)

	AddCategory("TEXT")
	AddCheckbox("SHOWTEXT", true, function() HighLevelAlert:UpdateText() end)
	AddSlider("TEXTSCALE", 1, 0.4, 2, 0.1, 1, function(value) HighLevelAlert:SetTextScale(value) end)
	AddCategory("WARNINGS")
	AddCheckbox("SHOWWARNINGFORPLAYERS", true)
	hlaset:ResumeLayout()
	HighLevelAlert:CreateMinimapButton({
		["name"] = "HighLevelAlert",
		["icon"] = 136219,
		["dbtab"] = HLATAB,
		["vTT"] = {{"|T136219:16:16:0:0|t HighLevelAlert", "v" .. HighLevelAlert:GetVersion()}, {HighLevelAlert:Trans("LID_LEFTCLICK"), HighLevelAlert:Trans("LID_OPENSETTINGS")}, {HighLevelAlert:Trans("LID_RIGHTCLICK"), "Unlock/lock Text"}, {HighLevelAlert:Trans("LID_SHIFTRIGHTCLICK"), HighLevelAlert:Trans("LID_HIDEMINIMAPBUTTON")}},
		["funcL"] = function() HighLevelAlert:ToggleSettings() end,
		["funcR"] = function() HighLevelAlert:ToggleFrame() end,
		["funcSR"] = function()
			HighLevelAlert:SV(HLATAB, "MMBTN", false)
			HighLevelAlert:MSG("Minimap Button is now hidden.")
			HighLevelAlert:HideMMBtn("HighLevelAlert")
		end,
		["dbkey"] = "MMBTN"
	})
end
