local _, HighLevelAlert = ...
local DEBUG = false
local COLR = "|cffff0000"
local COLY = "|cffffff00"
function HighLevelAlert:MSG(...)
	D4:MSG("HLA", 136219, ...)
end

function HighLevelAlert:DEB(...)
	D4:MSG("HLA", 136219, ...)
end

function HighLevelAlert:ERR(...)
	D4:MSG("HLA", 136219, ...)
end

if DEBUG then
	HighLevelAlert:DEB("> DEBUG IS ON")
end

--[[FRAME]]
local hla = CreateFrame("Frame", "HighLevelAlertFrame", UIParent)
hla:SetSize(800, 50)
hla:SetPoint("CENTER", 0, 240)
hla:Hide()
--[[TEXT]]
hla.text = hla:CreateFontString(nil, "ARTWORK", "GameFontNormal")
hla.text:SetAllPoints(true)
hla.text:SetFont("Fonts\\FRIZQT__.TTF", 42, "OUTLINE")
hla.text:SetText("")
function HighLevelAlert:SetShowText(val)
	if val then
		hla:Show()
	else
		hla:Hide()
	end
end

function HighLevelAlert:SetTextScale(val)
	if val then
		hla:SetScale(val)
	end
end

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
fThink:HookScript(
	"OnUpdate",
	function(self)
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
	end
)

function HighLevelAlert:SetPosition()
	local point, relativeTo, relativePoint, x, y = HLATAB.hlaPosition[1], HLATAB.hlaPosition[2], HLATAB.hlaPosition[3], HLATAB.hlaPosition[4], HLATAB.hlaPosition[5]
	x = D4:Grid(x, 10)
	y = D4:Grid(y, 10)
	hla:SetPoint(point, relativeTo, relativePoint, x, y)
end

hla:SetScript(
	"OnMouseDown",
	function(self, button)
		if button == "LeftButton" and not self.isMoving then
			if not D4:GV(HLATAB, "lockedText", true) then
				self:EnableMouse(true)
				self:SetMovable(true)
				self:StartMoving()
				self.isMoving = true
				D4:ShowGrid(self)
			else
				HighLevelAlert:MSG(D4:Trans("LID_HELPTEXTLOCKED"))
			end
		end
	end
)

hla:SetScript(
	"OnMouseUp",
	function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
			local point, _, relPoint, x, y = self:GetPoint()
			x = D4:Grid(x, 10)
			y = D4:Grid(y, 10)
			HLATAB.hlaPosition = {point, "UIParent", relPoint, x, y}
			HighLevelAlert:SetPosition()
			D4:HideGrid(self)
		end
	end
)

function HighLevelAlert:ToggleFrame()
	if hla then
		D4:SV(HLATAB, "lockedText", not D4:GV(HLATAB, "lockedText", true))
		if D4:GV(HLATAB, "lockedText", true) then
			hla:EnableMouse(false)
			hla:SetMovable(false)
			D4:MSG("HighLevelAlert", 136219, "Text is now locked.")
		else
			hla:EnableMouse(true)
			hla:SetMovable(true)
			D4:MSG("HighLevelAlert", 136219, "Text is now unlocked.")
		end
	else
		C_Timer.After(
			1,
			function()
				HighLevelAlert:ToggleFrame()
			end
		)
	end
end

--[[EVENTS]]
hla:RegisterEvent("PLAYER_LOGIN")
hla:SetScript(
	"OnEvent",
	function(self, event, ...)
		HLATAB = HLATAB or {}
		if event == "PLAYER_LOGIN" then
			hla:ClearAllPoints()
			if HLATAB.hlaPosition then
				HighLevelAlert:SetPosition()
			else
				hla:SetPoint("CENTER", UIParent, "CENTER", 0, 240)
			end

			if D4:GV(HLATAB, "lockedText", true) then
				hla:EnableMouse(false)
				hla:SetMovable(false)
			else
				hla:EnableMouse(true)
				hla:SetMovable(true)
			end

			for i = 1, 60 do
				SetCVar("nameplateMaxDistance", i)
			end

			if GetCVarBool("nameplateShowAll") == false then
				HighLevelAlert:MSG(format(D4:Trans("LID_NPSCVAR"), UNIT_NAMEPLATES_AUTOMODE))
			else
				--[[ NPC-Enemies Nameplates ]]
				-- is enabled, when nameplateShowAll is
				if GetCVarBool("nameplateShowEnemies") == false then
					HighLevelAlert:MSG(format(D4:Trans("LID_NPSCVAR"), UNIT_NAMEPLATES_SHOW_ENEMIES))
					SetCVar("nameplateShowEnemies", true)
				end

				--[[ Player-Enemies Nameplates ]]
				if GetCVarBool("UnitNameEnemyPlayerName") == false then
					HighLevelAlert:MSG(format(D4:Trans("LID_NPSCVAR"), UNIT_NAME_ENEMY))
				end
			end

			SetCVar("ShowClassColorInNameplate", 1)
			HLATAB["TEXTSCALE"] = HLATAB["TEXTSCALE"] or 1
			HighLevelAlert:SetTextScale(HLATAB["TEXTSCALE"])
			if HLATAB["SHOWTEXT"] == nil then
				HLATAB["SHOWTEXT"] = true
			end

			HighLevelAlert:SetShowText(HLATAB["SHOWTEXT"])
			HighLevelAlert:InitSettings()
			self:UnregisterEvent("PLAYER_LOGIN")
		end
	end
)

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
	if HLATAB["SHOWTEXT"] then
		if NPPvpCount > 0 then
			if NPPvpCount == 1 then
				hla.text:SetText(format("[%s%s|r] %s", COLR, D4:Trans("LID_WARNING"), format(D4:Trans("LID_PVPNEARBY"), NPPvpCount)))
			else
				hla.text:SetText(format("[%s%s|r] %s", COLR, D4:Trans("LID_WARNING"), format(D4:Trans("LID_PVPNEARBYS"), NPPvpCount)))
			end

			hla:Show()
		elseif NPSkullEliteCount > 0 then
			if NPSkullEliteCount == 1 then
				hla.text:SetText(format("[%s%s|r] %s", COLR, D4:Trans("LID_WARNING"), format(D4:Trans("LID_SKULLELITESNEARBY"), NPSkullEliteCount, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0:0|t")))
			else
				hla.text:SetText(format("[%s%s|r] %s", COLR, D4:Trans("LID_WARNING"), format(D4:Trans("LID_SKULLELITESNEARBYS"), NPSkullEliteCount, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0:0|t")))
			end

			hla:Show()
		elseif NPSkullCount > 0 then
			if NPSkullCount == 1 then
				hla.text:SetText(format("[%s%s|r] %s", COLR, D4:Trans("LID_WARNING"), format(D4:Trans("LID_SKULLSNEARBY"), NPSkullCount, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0:0|t")))
			else
				hla.text:SetText(format("[%s%s|r] %s", COLR, D4:Trans("LID_WARNING"), format(D4:Trans("LID_SKULLSNEARBYS"), NPSkullCount, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0:0|t")))
			end

			hla:Show()
		elseif NPRedEliteCount > 0 then
			if NPRedEliteCount == 1 then
				hla.text:SetText(format("[%s%s|r] %s", COLY, D4:Trans("LID_CAUTION"), format(D4:Trans("LID_REDELITESNEARBY"), NPRedEliteCount)))
			else
				hla.text:SetText(format("[%s%s|r] %s", COLY, D4:Trans("LID_CAUTION"), format(D4:Trans("LID_REDELITESNEARBYS"), NPRedEliteCount)))
			end

			hla:Show()
		elseif NPRedCount > 0 then
			if NPRedCount == 1 then
				hla.text:SetText(format("[%s%s|r] %s", COLY, D4:Trans("LID_CAUTION"), format(D4:Trans("LID_REDSNEARBY"), NPRedCount)))
			else
				hla.text:SetText(format("[%s%s|r] %s", COLY, D4:Trans("LID_CAUTION"), format(D4:Trans("LID_REDSNEARBYS"), NPRedCount)))
			end

			hla:Show()
		else
			hla.text:SetText("")
			hla:Hide()
		end
	else
		hla.text:SetText("")
		hla:Hide()
	end
end

local FUA = CreateFrame("Frame")
FUA:RegisterEvent("NAME_PLATE_UNIT_ADDED")
FUA:SetScript(
	"OnEvent",
	function(self, event, unit)
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
			if isPlayer and UnitIsPVP(unit) and D4:GV(HLATAB, "SHOWWARNINGFORPLAYERS", true) then
				PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE or SOUNDKIT.RAID_WARNING, "Ambience")
				table.insert(NPPvp, unit)
			elseif not isPlayer then
				if isSkull and isElite then
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
			end

			HighLevelAlert:UpdateText()
		end
	end
)

local FUR = CreateFrame("Frame")
FUR:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
FUR:SetScript(
	"OnEvent",
	function(self, event, unit)
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
	end
)