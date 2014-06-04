--	ReParty 0.1

-- Wery simple addon that allows you to recreate you party. Just type "/rp"

RP={}
RP.OldParty={}
RP.DisbandTimer=false

function RP.RememberParty()
	for i=1,GetGroupSize() do
		local name=GetUnitName(GetGroupUnitTagByIndex(i))
		if name~=GetUnitName("player") then
			RP.OldParty[#RP.OldParty+1]=name
		end
	end
end

function RP.DisbandGroupIfLeader()
	if not IsPlayerInGroup(GetUnitName("player")) then
		d("RP: You are not in group!") 
		return 
	end
	if IsUnitGroupLeader("player") then
		GroupDisband()
		RP.DisbandTimer=GetGameTimeMilliseconds()
		return true
	else
		d("RP: You are not group leader!")
		return false
	end
end

function RP.InvitePlayers()
	for i=1,#RP.OldParty do
		GroupInviteByName(RP.OldParty[i])
	end
	RP.OldParty={}
end

function RP.commandHandler(text)
	if text~="" then
		d("No such command")
	else
		RP.RememberParty()
		if not RP.DisbandGroupIfLeader() then return end
	end
end

function RP.OnLoad()
	SLASH_COMMANDS["/rp"] = RP.commandHandler
	RP.loaded=true
end

function RP.Update(self)
	if RP.DisbandTimer then
		if GetGameTimeMilliseconds()-RP.DisbandTimer>=2500 then
			RP.InvitePlayers()
			RP.DisbandTimer=false
		end
	end
end

--Addon Initialize
EVENT_MANAGER:RegisterForEvent("ReParty", EVENT_ADD_ON_LOADED, RP.OnLoad)