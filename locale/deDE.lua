-- deDE German Deutsch
local _, HighLevelAlert = ...
LHLA = LHLA or {}

function HighLevelAlert:LangdeDE()
	LHLA["LID_NPSCVAR"] = "\"%s\" (Namensplaketten) ist ausgeschaltet, bitte aktivieren Sie es."
	LHLA["LID_WARNING"] = "Achtung"
	LHLA["LID_CAUTION"] = "Vorsicht"
	LHLA["LID_PVPNEARBY"] = "%d PVP-Spieler in der Nähe!"
	LHLA["LID_SKULLELITESNEARBY"] = "%d {rt8}-Elites in der Nähe!"
	LHLA["LID_SKULLSNEARBY"] = "%d {rt8} in der Nähe!"
	LHLA["LID_REDELITESNEARBY"] = "%d Rot-Eliten in der Nähe!"
	LHLA["LID_REDSNEARBY"] = "%d Rot-Eliten in der Nähe!"
	LHLA["LID_HELPTEXTLOCKED"] = "Warnhinweis-Text ist fixiert, Rechtsklick zum Entsperren."
	LHLA["LID_LOCKEDTEXT"] = "Warnhinweis-Text ist jetzt gesperrt."
	LHLA["LID_UNLOCKEDTEXT"] = "Warnhinweis-Text ist jetzt entsperrt."
end