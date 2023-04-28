local AddOnName, HighLevelAlert = ...
local DEBUG = false
local COLR = "|cffff0000"
local COLY = "|cffffff00"
local COLG = "|cff00ff00"
local COLADDON = "|cffff6060"

function HighLevelAlert:MSG(...)
	print(format("[%s" .. AddOnName .. "|r] %s", COLADDON, COLG), ...)
end

function HighLevelAlert:DEB(...)
	print(format("[%s" .. AddOnName .. "|r] [%sDEBUG|r] %s", COLADDON, COLY, COLY), ...)
end

function HighLevelAlert:ERR(...)
	print(format("[%s" .. AddOnName .. "|r] %s", COLADDON, COLR), ...)
end

if DEBUG then
	HighLevelAlert:DEB("> DEBUG IS ON")
end

function HighLevelAlert:Grid(n, snap)
	n = n or 0
	snap = snap or 10
	local mod = n % snap

	return (mod > (snap / 2)) and (n - mod + snap) or (n - mod)
end

LHLA = LHLA or {}
HighLevelAlert:LangenUS()

if GetLocale() == "enUS" then
	HighLevelAlert:LangenUS()
elseif GetLocale() == "deDE" then
	HighLevelAlert:LangdeDE()
end

function HighLevelAlert:GT(id)
	local ts = LHLA[id]

	if ts then
		for i = 1, 8 do
			ts = string.gsub(ts, "{rt" .. i .. "}", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. i .. ":16:16:0:0|t")
		end
	else
		HighLevelAlert:ERR("MISSING TRANSLATION: " .. id)
		ts = id
	end

	return ts
end

--[[FRAME]]
local hla = CreateFrame("Frame", nil, UIParent)
hla:SetSize(600, 50)
hla:SetPoint("CENTER", 0, 240)
hla:Hide()
--[[TEXT]]
hla.text = hla:CreateFontString(nil, "ARTWORK")
hla.text:SetAllPoints(true)
hla.text:SetFont("Fonts\\FRIZQT__.TTF", 30, "OUTLINE")
hla.text:SetText("")
--[[TEXTURE]]
hla.texv = hla:CreateTexture(nil, "OVERLAY")
hla.texv:SetColorTexture(1, 1, 1, 1)
hla.texv:SetSize(2, hla:GetHeight())
hla.texv:SetPoint("CENTER", hla, "CENTER")
hla.texh = hla:CreateTexture(nil, "OVERLAY")
hla.texh:SetColorTexture(1, 1, 1, 1)
hla.texh:SetSize(hla:GetWidth(), 2)
hla.texh:SetPoint("CENTER", hla, "CENTER")
local texv = UIParent:CreateTexture(nil, "OVERLAY")
texv:SetColorTexture(1, 1, 1, 0.5)
texv:SetSize(2, UIParent:GetHeight())
texv:SetPoint("CENTER", UIParent, "CENTER")
texv:Hide()
local texh = UIParent:CreateTexture(nil, "OVERLAY")
texh:SetColorTexture(1, 1, 1, 0.5)
texh:SetSize(UIParent:GetWidth(), 2)
texh:SetPoint("CENTER", UIParent, "CENTER")
texh:Hide()
local hlaShown = nil
local fThink = CreateFrame("FRAME")

fThink:HookScript("OnUpdate", function(self)
	if hla:IsShown() ~= hlaShown then
		hlaShown = hla:IsShown()
		local hlaMoving = hla.isMoving

		if hlaShown and hlaMoving then
			hla.texv:Show()
			hla.texh:Show()
			texv:Show()
			texh:Show()
		else
			hla.texv:Hide()
			hla.texh:Hide()
			texv:Hide()
			texh:Hide()
		end
	end
end)

--[[MOVING]]
hla:SetMovable(true)
hla:EnableMouse(true)

function HighLevelAlert:SetPosition()
	local point, relativeTo, relativePoint, x, y = HLATAB.hlaPosition[1], HLATAB.hlaPosition[2], HLATAB.hlaPosition[3], HLATAB.hlaPosition[4], HLATAB.hlaPosition[5]
	x = HighLevelAlert:Grid(x, 10)
	y = HighLevelAlert:Grid(y, 10)
	hla:SetPoint(point, relativeTo, relativePoint, x, y)
end

hla:SetScript("OnMouseDown", function(self, button)
	HLATAB.hlaFixed = HLATAB.hlaFixed or false

	if button == "LeftButton" and not self.isMoving then
		if not HLATAB.hlaFixed then
			self:StartMoving()
			self.isMoving = true
		else
			HighLevelAlert:MSG(HighLevelAlert:GT("LID_HELPTEXTLOCKED"))
		end
	elseif button == "RightButton" then
		HLATAB.hlaFixed = not HLATAB.hlaFixed
		hla:SetMovable(not HLATAB.hlaFixed)

		if HLATAB.hlaFixed then
			HighLevelAlert:MSG(HighLevelAlert:GT("LID_LOCKEDTEXT"))
		else
			HighLevelAlert:MSG(HighLevelAlert:GT("LID_UNLOCKEDTEXT"))
		end
	end
end)

hla:SetScript("OnMouseUp", function(self, button)
	HLATAB.hlaFixed = HLATAB.hlaFixed or false

	if button == "LeftButton" and self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
		local point, _, relPoint, x, y = self:GetPoint()
		x = HighLevelAlert:Grid(x, 10)
		y = HighLevelAlert:Grid(y, 10)

		HLATAB.hlaPosition = {point, "UIParent", relPoint, x, y}

		HighLevelAlert:SetPosition()
	end
end)

--[[EVENTS]]
hla:RegisterEvent("ADDON_LOADED")

hla:SetScript("OnEvent", function(self, event, addonName)
	HLATAB = HLATAB or {}

	if event == "ADDON_LOADED" and addonName == AddOnName then
		hla:ClearAllPoints()

		if HLATAB.hlaPosition then
			HighLevelAlert:SetPosition()
		else
			hla:SetPoint("CENTER", UIParent, "CENTER", 0, 240)
		end

		for i = 1, 60 do
			SetCVar("nameplateMaxDistance", i)
		end

		if GetCVarBool("nameplateShowAll") == false then
			HighLevelAlert:MSG(format(HighLevelAlert:GT("LID_NPSCVAR"), UNIT_NAMEPLATES_AUTOMODE))
		else
			--[[ NPC-Enemies Nameplates ]]
			--[[ -- is enabled, when nameplateShowAll is
			if GetCVarBool("nameplateShowEnemies") == false then
				HighLevelAlert:MSG(format(HighLevelAlert:GT("LID_NPSCVAR"), UNIT_NAMEPLATES_SHOW_ENEMIES))
				SetCVar("nameplateShowEnemies", true)
			end
			]]
			--[[ Player-Enemies Nameplates ]]
			if GetCVarBool("UnitNameEnemyPlayerName") == false then
				HighLevelAlert:MSG(format(HighLevelAlert:GT("LID_NPSCVAR"), UNIT_NAME_ENEMY))
			end
		end

		SetCVar("ShowClassColorInNameplate", 1)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

local NPPvp = {}
local NPSkullElite = {}
local NPSkull = {}
local NPRedElite = {}
local NPRed = {}

function HighLevelAlert:UpdateText()
	local NPPvpCount = #NPPvp
	local NPSkullEliteCount = #NPSkullElite
	local NPSkullCount = #NPSkull
	local NPRedEliteCount = #NPRedElite
	local NPRedCount = #NPRed

	if NPPvpCount > 0 then
		hla.text:SetText(format("[%s%s|r]: %s", COLR, HighLevelAlert:GT("LID_WARNING"), format(HighLevelAlert:GT("LID_PVPNEARBY"), NPPvpCount)))
		hla:Show()
	elseif NPSkullEliteCount > 0 then
		hla.text:SetText(format("[%s%s|r]: %s", COLR, HighLevelAlert:GT("LID_WARNING"), format(HighLevelAlert:GT("LID_SKULLELITESNEARBY"), NPSkullEliteCount)))
		hla:Show()
	elseif NPSkullCount > 0 then
		hla.text:SetText(format("[%s%s|r]|r: %s", COLR, HighLevelAlert:GT("LID_WARNING"), format(HighLevelAlert:GT("LID_SKULLSNEARBY"), NPSkullCount)))
		hla:Show()
	elseif NPRedEliteCount > 0 then
		hla.text:SetText(format("[%s%s|r]: %s", COLY, HighLevelAlert:GT("LID_CAUTION"), format(HighLevelAlert:GT("LID_REDELITESNEARBY"), NPRedEliteCount)))
		hla:Show()
	elseif NPRedCount > 0 then
		hla.text:SetText(format("[%s%s|r]: %s", COLY, HighLevelAlert:GT("LID_CAUTION"), format(HighLevelAlert:GT("LID_REDSNEARBY"), NPRedCount)))
		hla:Show()
	else
		hla.text:SetText("")
		hla:Hide()
	end
end

local FUA = CreateFrame("Frame")
FUA:RegisterEvent("NAME_PLATE_UNIT_ADDED")

FUA:SetScript("OnEvent", function(self, event, unit)
	local level = UnitLevel(unit)
	local classification = UnitClassification(unit)
	local isElite = classification == "worldboss" or classification == "rareelite" or classification == "elite"
	local isEnemy = UnitIsEnemy("player", unit)
	local isPlayer = UnitIsPlayer(unit)

	if DEBUG then
		isEnemy = true
		--HighLevelAlert:DEB(isEnemy, level)
	end

	if level and isEnemy then
		local playerLevel = UnitLevel("player")
		local isSkull = level == -1 or level >= playerLevel + 10
		local isRed = level >= playerLevel + 3

		if isPlayer and UnitIsPVP(unit) then
			PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE or SOUNDKIT.RAID_WARNING, "Ambience")
			table.insert(NPPvp, unit)
		elseif isSkull and isElite then
			PlaySound(SOUNDKIT.RAID_WARNING, "Ambience")
			table.insert(NPSkullElite, unit)
		elseif isSkull then
			PlaySound(SOUNDKIT.READY_CHECK or SOUNDKIT.RAID_WARNING, "Ambience")
			table.insert(NPSkull, unit)
		elseif isRed and isElite then
			PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_2 or SOUNDKIT.RAID_WARNING, "Ambience")
			table.insert(NPRedElite, unit)
		elseif isRed then
			PlaySound(SOUNDKIT.GS_LOGIN or SOUNDKIT.RAID_WARNING, "Ambience")
			table.insert(NPRed, unit)
		end

		HighLevelAlert:UpdateText()
	end
end)

local FUR = CreateFrame("Frame")
FUR:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

FUR:SetScript("OnEvent", function(self, event, unit)
	local removed = false

	for i, u in ipairs(NPPvp) do
		if u == unit then
			table.remove(NPPvp, i)
			removed = true
			break
		end
	end

	if not removed then
		for i, u in ipairs(NPSkullElite) do
			if u == unit then
				table.remove(NPSkullElite, i)
				removed = true
				break
			end
		end
	end

	if not removed then
		for i, u in ipairs(NPSkull) do
			if u == unit then
				table.remove(NPSkull, i)
				removed = true
				break
			end
		end
	end

	if not removed then
		for i, u in ipairs(NPRedElite) do
			if u == unit then
				table.remove(NPRedElite, i)
				removed = true
				break
			end
		end
	end

	if not removed then
		for i, u in ipairs(NPRed) do
			if u == unit then
				table.remove(NPRed, i)
				break
			end
		end
	end

	HighLevelAlert:UpdateText()
end)