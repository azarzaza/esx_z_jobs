local PlayersWorking = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_z_jobs:buyLicense', function(source, cb, zone)
    print(zone.Type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = zone.License

	if license == nil then
		print(('esx_illegal: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= license.price then
		xPlayer.removeMoney(license.price)

		TriggerEvent('esx_license:addLicense', source, license.name, function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_z_jobs:canHarvest', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItemCount = xPlayer.getInventoryItem(item.db_name).count

	if xPlayer.canCarryItem(item.db_name, 1) and xItemCount <= item.max then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_z_jobs:harvestItems')
AddEventHandler('esx_z_jobs:harvestItems', function(zone)
    if not PlayersWorking[source] and zone.Type ~= 'farm' then
		PlayersWorking[source] = true
        processItem(zone.Item)
    elseif zone.Type == 'farm' then
        processItem(zone.Item)
	else
		print(('esx_jobs: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_z_jobs:stopWork')
AddEventHandler('esx_z_jobs:stopWork', function()
	PlayersWorking[source] = false
end)

function processItem(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemQty = xPlayer.getInventoryItem(item.db_name).count
   
    local requiredItemQtty = 0
    if item.requires ~= "nothing" then
        requiredItemQtty = xPlayer.getInventoryItem(item.requires).count
    end
    if itemQty >= item.max then
        TriggerClientEvent('esx:showNotification', source, _U('max_limit', item.name))
    elseif item.requires ~= "nothing" and requiredItemQtty <= 0 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough', item.requires_name))
    else
        xPlayer.addInventoryItem(item.db_name, item.add)
    end

    if item.requires ~= "nothing" then
        local itemToRemoveQtty = xPlayer.getInventoryItem(item.requires).count
        if itemToRemoveQtty > 0 then
            xPlayer.removeInventoryItem(item.requires, item.remove)
        end
    end
    
end

RegisterServerEvent('esx_z_jobs:startWork')
AddEventHandler('esx_z_jobs:startWork', function(item)
	if not PlayersWorking[source] then
		PlayersWorking[source] = true
		Work(source, item)
	else
		print(('esx_jobs: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function Work(source, item)

	SetTimeout(item.time, function()

		if PlayersWorking[source] == true then

			local xPlayer = ESX.GetPlayerFromId(source)
			if xPlayer == nil then
				return
			end

            local itemQtty = 0
            if item.name ~= _U('delivery') then
                itemQtty = xPlayer.getInventoryItem(item.db_name).count
            end

            local requiredItemQtty = 0
            if item.requires ~= "nothing" then
                requiredItemQtty = xPlayer.getInventoryItem(item.requires).count
            end

            if item.name ~= _U('delivery') and itemQtty >= item.max then
                TriggerClientEvent('esx:showNotification', source, _U('max_limit', item.name))
            elseif item.requires ~= "nothing" and requiredItemQtty <= 0 then
                TriggerClientEvent('esx:showNotification', source, _U('not_enough', item.requires_name))
            else
                if item.name ~= _U('delivery') then
                    -- Chances to drop the item
                    if item.drop == 100 then
                        xPlayer.addInventoryItem(item.db_name, item.add)
                    else
                        local chanceToDrop = math.random(100)
                        if chanceToDrop <= item.drop then
                            xPlayer.addInventoryItem(item.db_name, item.add)
                        end
                    end
                else
                    xPlayer.addMoney(item.price)
                end
            end
			if item.requires ~= "nothing" then
				local itemToRemoveQtty = xPlayer.getInventoryItem(item.requires).count
				if itemToRemoveQtty > 0 then
					xPlayer.removeInventoryItem(item.requires, item.remove)
				end
			end

			Work(source, item)

		end
	end)
end