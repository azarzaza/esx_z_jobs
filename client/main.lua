local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
  local PlayerData = {}
  local menuIsShowed = false
  local hintIsShowed = false
  local hasAlreadyEnteredMarker = false
  local Blips = {}
  local JobBlips = {}
  local isInMarker = false
  local isInPublicMarker = false
  local isFarming = false
  local hintToDisplay = "no hint to display"
  local onDuty = true
  local spawnedItems = 0
  local jobItems = {}
  local cZone = {}
  ESX = nil
  
  Citizen.CreateThread(function()
      while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
      end
      
      while ESX.GetPlayerData().job == nil do
          Citizen.Wait(10)
      end
  
      PlayerData = ESX.GetPlayerData()
      refreshBlips()
  end)
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
      PlayerData = xPlayer
      refreshBlips()
  end)
  
  function OpenMenu()
      ESX.UI.Menu.CloseAll()
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
      {
          title    = _U('cloakroom'),
          elements = {
              {label = _U('job_wear'),     value = 'job_wear'},
              {label = _U('citizen_wear'), value = 'citizen_wear'}
          }
      }, function(data, menu)
          if data.current.value == 'citizen_wear' then
              onDuty = false
              ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                  TriggerEvent('skinchanger:loadSkin', skin)
              end)
          elseif data.current.value == 'job_wear' then
              onDuty = true
              ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                  if skin.sex == 0 then
                      TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                  else
                      TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                  end
              end)
          end
  
          menu.close()
      end, function(data, menu)
          menu.close()
      end)
  end
  
  
  AddEventHandler('esx_z_jobs:action', function(job, zone)
    menuIsShowed = true
    cZone = zone
    local allowToWork = isWorkHour(zone.Item)
    if not allowToWork then
        ESX.ShowNotification(_U('not_work_hour'))
        return false
    end
    if zone.Type == "cloakroom" then
        if zone.IsLicense then
            ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
                if hasProcessingLicense then
                    OpenMenu()
                else
                    OpenBuyLicenseMenu(zone)
                end
            end, GetPlayerServerId(PlayerId()), zone.License.name)
        else
            ESX.ShowNotification(_U('license_not_allowed'))
        end
    elseif zone.Type == "farm" then
        hintToDisplay = "no hint to display"
        hintIsShowed = false
        if IsPedInAnyVehicle(playerPed, false) then
            ESX.ShowNotification(_U('foot_work'))
        else
            SpawnFarmItems(zone)
        end
	elseif zone.Type == "work" then
		hintToDisplay = "no hint to display"
		hintIsShowed = false
		if IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowNotification(_U('foot_work'))
		else
			TriggerServerEvent('esx_z_jobs:startWork', zone.Item)
		end
	elseif zone.Type == "delivery" then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		hintToDisplay = "no hint to display"
		hintIsShowed = false
		
		TriggerServerEvent('esx_z_jobs:startWork', zone.Item)
    end
    if Config.GPSEnabled then
    	nextStep(zone.GPS)
    end
end)

function startFarming(zone)
   
end



function nextStep(gps)
	if gps ~= 0 then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
		SetBlipRoute(Blips['delivery'], true)
		ESX.ShowNotification(_U('next_point'))
	end
end

AddEventHandler('esx_z_jobs:hasExitedMarker', function(zone)
	TriggerServerEvent('esx_z_jobs:stopWork')
	hintToDisplay = "no hint to display"
	menuIsShowed = false
	hintIsShowed = false
	isInMarker = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	onDuty = false
	myPlate = {} -- loosing vehicle caution in case player changes job.
	spawner = 0
	deleteBlips()
	refreshBlips()
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil then
		for jobKey,jobValues in pairs(Config.Jobs) do

			if jobKey == PlayerData.job.name then
				for zoneKey,zoneValues in pairs(jobValues.Zones) do

					if zoneValues.Blip then
						local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
						SetBlipSprite  (blip, jobValues.BlipInfos.Sprite)
						SetBlipDisplay (blip, 4)
						SetBlipScale   (blip, 1.2)
						SetBlipCategory(blip, 3)
						SetBlipColour  (blip, jobValues.BlipInfos.Color)
						SetBlipAsShortRange(blip, true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(zoneValues.Name)
						EndTextCommandSetBlipName(blip)
						table.insert(JobBlips, blip)
					end
				end
			end
		end
	end
end

-- Show top left hint
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if hintIsShowed then
			ESX.ShowHelpNotification(hintToDisplay)
		else
			Citizen.Wait(500)
		end
	end
end)

-- Display markers (only if on duty and the player's job ones)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local zones = {}

		if PlayerData.job ~= nil then
			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					zones = v.Zones
				end
			end

			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(zones) do
				if onDuty or v.Type == "cloakroom" then
					if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
		end
	end
end)


-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and PlayerData.job.name ~= 'unemployed' then
			local zones = nil
			local job = nil

			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					job = v
					zones = v.Zones
				end
			end

			if zones ~= nil then
				local coords      = GetEntityCoords(PlayerPedId())
				local currentZone = nil
				local zone        = nil
				local lastZone    = nil

				for k,v in pairs(zones) do
					if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
						isInMarker  = true
						currentZone = k
						zone        = v
						break
					else
						isInMarker  = false
					end
				end

				if IsControlJustReleased(0, Keys['E']) and not menuIsShowed and isInMarker then
					if onDuty or zone.Type == "cloakroom" then
						TriggerEvent('esx_z_jobs:action', job, zone)
					end
				end

				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if (onDuty or zone.Type == "cloakroom") then
						hintToDisplay = zone.Hint
						hintIsShowed = true
					else
						if not isInPublicMarker then
							hintToDisplay = "no hint to display"
							hintIsShowed = false
						end
					end
				end

				if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('esx_z_jobs:hasExitedMarker', zone)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	-- Slaughterer
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")

	-- Tailor
	RequestIpl("id2_14_during_door")
	RequestIpl("id2_14_during1")
end)

-- harvesting items
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

        if cZone  == nil then
            return false
        end
		for i=1, #jobItems, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(jobItems[i]), false) < 1 then
				nearbyObject, nearbyID = jobItems[i], i
			end
		end
		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isFarming then
				ESX.ShowHelpNotification(cZone.label)
			end

			if IsControlJustReleased(0, Keys['E']) and not isFarming then
				isFarming = true
				ESX.TriggerServerCallback('esx_z_jobs:canHarvest', function(canHarvest)
					if canHarvest then
						TaskStartScenarioInPlace(playerPed, cZone.Animation, 0, false)
						-- ZAZA
						TriggerEvent('pogressBar:drawBar', cZone.Item.time, 'Harvest in progress', function()
						end, {
							color = 'green'
						})
						Citizen.Wait(cZone.Item.time)
						ClearPedTasks(playerPed)
						Citizen.Wait(1000)
                        if cZone.PropsType == 'object' then
                            ESX.Game.DeleteObject(nearbyObject)
                        else
                            DeleteEntity(nearbyObject)
                        end
		
						table.remove(jobItems, nearbyID)
						spawnedItems = spawnedItems - 1
                        
                        TriggerServerEvent('esx_z_jobs:harvestItems',cZone)
                        if spawnedItems == 0 then 
                            SpawnFarmItems(cZone)
                        end
					else
						ESX.ShowNotification(_U('max_limit', cZone.Item.name))
					end

					isFarming = false

				end, cZone.Item)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

-- License Menu 
function OpenBuyLicenseMenu(zone)
	ESX.UI.Menu.CloseAll()
	local license = zone.License

	local elements = {
		{
			label = _U('license_no'),
			value = 'no'
		},

		{
			label = ('%s - <span style="color:green;">%s</span>'):format(license.label, _U('jobs_item', ESX.Math.GroupDigits(license.price))),
			value = license.name,
			price = license.price,
            licenseName = license.label,
            zone = zone
		}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'license_shop', {
		title    = _U('license_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value ~= 'no' then
			ESX.TriggerServerCallback('esx_z_jobs:buyLicense', function(boughtLicense)
				if boughtLicense then
					ESX.ShowNotification(_U('license_bought', data.current.licenseName, ESX.Math.GroupDigits(data.current.price)))
				else
					ESX.ShowNotification(_U('license_bought_fail', data.current.licenseName))
				end
			end, data.current.zone)
		else
			menu.close()
		end

	end, function(data, menu)
		menu.close()
	end)
end

-- Check Working hours
function isWorkHour(item)
    local hour = GetClockHours()
    if hour >= item.fromHour and hour <= item.toHour then
     return true
    end
end


function SpawnFarmItems(zone)
    removeSpawnObject()
    cleanupPeds()
    spawnedItems = 0
	while spawnedItems < zone.Item.spawnLimit do
		Citizen.Wait(0)
		local itemCoords = GenerateItemCoords(zone)
        
        if zone.PropsType == "object" then
            ESX.Game.SpawnLocalObject(zone.Props, itemCoords, function(obj)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
    
                table.insert(jobItems, obj)
                spawnedItems = spawnedItems + 1
            end)
        else
            RequestModel( GetHashKey(zone.Props) )
            while not HasModelLoaded(GetHashKey(zone.Props)) do
                Wait(155)
            end
            local ped =  CreatePed(4, GetHashKey(zone.Props),  itemCoords.x,itemCoords.y,itemCoords.z , false, true)
            -- FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
        --	SetBlockingOfNonTemporaryEvents(ped, true)
            -- while true do
            --     Citizen.Wait(0)
            --     TaskPedSlideToCoord(ped,  itemCoords.x,itemCoords.y,itemCoords.z, -349.404, 10)
            -- end
            table.insert(jobItems, ped)
            spawnedItems = spawnedItems + 1
        end
	end
end

function ValidateItemCoord(ItemCoord,zone)
	if spawnedItems > 0 then
		local validate = true

		for k, v in pairs(jobItems) do
			if GetDistanceBetweenCoords(ItemCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(ItemCoord, zone.Pos.x, zone.Pos.y, zone.Pos.z, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateItemCoords(zone)
	while true do
		Citizen.Wait(1)

		local itemCoordX, itemCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		itemCoordX = zone.Pos.x + modX
		itemCoordY = zone.Pos.y + modY

		local coordZ = GetCoordZItem(itemCoordX, itemCoordY)
		local coord = vector3(itemCoordX, itemCoordY, coordZ)

		if ValidateItemCoord(coord,zone) then
			return coord
		end
	end
end

function GetCoordZItem(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ESX.UI.Menu.CloseAll()
        removeSpawnObject()
        cleanupPeds()
	end
end)

function removeSpawnObject()
    for k, v in pairs(jobItems) do
        ESX.Game.DeleteObject(v)
    end
end

-- Cleanup Peds
function cleanupPeds()
    for a = 1, #jobItems do
        DeleteEntity(jobItems[a])
    end
end



