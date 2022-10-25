local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("sw-npcmechanic:checkCash", function(source, cb)
    local P = QBCore.Functions.GetPlayer(source)
	cb(P.Functions.GetMoney("bank"))
end)

RegisterNetEvent('sw-npcmechanic:chargeCash', function(cost)
	local Player = QBCore.Functions.GetPlayer(source)
	QBCore.Functions.GetPlayer(source).Functions.RemoveMoney("cash", cost)
	if Config.GiveMechanicJobMoney then
    exports['Renewed-Banking']:addAccountMoney(Config.MechanicJobName, math.floor(cost * Config.PayProcent))
	end
end)


QBCore.Functions.CreateCallback('sw-npcmechanic:mechCheck', function(source, cb)
	local dutyList = {}

	for _, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(v)
		if Player.PlayerData.job.name == Config.MechanicJobName and Player.PlayerData.job.onduty then dutyList[tostring(b)] = true end
	end
	local result = false
	for _, v in pairs(dutyList) do if v then result = true end end
	cb(result)
end)