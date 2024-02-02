local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface("lab-pet")

local cam
local pets = {}
loadingAttemps = false
local showInfo = true
local isOpen = false
local nearbyPed = nil
local bowlObj
local petMoving, stay, feeding, ballThrown, chasing, searching = false, false, false, false, false, false
local petSpeed = 8.0
local followThePlayer  = false
local ropeFollowThePlayer = false
local openBoughtMenu = false
local ballGame = false
local firstDisable = true
tempRope = nil
local follow = false
blip = nil
local alreadyHunting = {
    state = false
}

RegisterNetEvent('esx:playerLoaded', function()
    loadingAttemps = true
    TriggerEvent('lab-pet:client:petLongerNeeded', pets)
end)

-- *Callback

Citizen.CreateThread(function()
    while true do
        Wait(2)
        local dst = #(GetEntityCoords(PlayerPedId()) - PET.petBuyCoords)
        if dst <= 1.5 then
            if not HasStreamedTextureDictLoaded("petshop") then
                RequestStreamedTextureDict("petshop", true)
                while not HasStreamedTextureDictLoaded("petshop") do
                    Wait(1)
                end

            else
                if dst <= 0.6 then
                    if dst <= 0.4 and not openBoughtMenu then
                        -- if IsControlJustPressed(0, 38) then
                        boughtScreen(true)
                        openBoughtMenu = true
                        -- end
                    end
                end
                if dst >= 0.6 then
                    openBoughtMenu = false
                end
                DrawMarker(9,PET.petBuyCoords.x,PET.petBuyCoords.y,PET.petBuyCoords.z+ 0.01, 0.0, 0.0, 0.0, 85.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255,255,255, 255,false, false, 2, true, "petshop", "img", false)
            end
        end
    end
end)


local loading = false
local showShowKey = false
Citizen.CreateThread(function()
    while true do
        local pldist = GetEntityCoords(GetPlayerPed(-1))
        sleep = 1000
            for i = 0, #pets do
                for j,v in ipairs(GetGamePool('CPed')) do
                    if v ~= GetPlayerPed(-1) then
                        local peddist = GetEntityCoords(v)
                        local dist = GetDistanceBetweenCoords(pldist.x,pldist.y,pldist.z,peddist.x,peddist.y,peddist.z,true)
                        if dist <= 1.5 then
                            if dist <= 1.3 then
                                if dist <= 1.2 then
                                    local onScreen, coordX, coordY = GetCurrentEntityCoords(NetworkGetNetworkIdFromEntity(v))
                                    if PET.debugMode then
                                    end  
                                    if pets[NetworkGetNetworkIdFromEntity(v)] ~= nil then
                                        if pets[NetworkGetNetworkIdFromEntity(v)].netID  == NetworkGetNetworkIdFromEntity(v) then
                                            showShowKey = true
                                            nearbyPed = NetworkGetNetworkIdFromEntity(v)
                                            SetEntityDrawOutline(nearbyPed, true)
                                            SetEntityDrawOutlineColor(255, 0, 255, 255)
                                            -- SetEntityDrawOutlineShader(0)
                                            SendNUIMessage({
                                                action = "SHOW_KEY",
                                                coordX = coordX,
                                                coordY = coordY,
                                                --! Datayı tekrardan atmak daha mantıklı
                                                petName = pets[NetworkGetNetworkIdFromEntity(v)].petName,
                                                petLabel = pets[NetworkGetNetworkIdFromEntity(v)].petLabel,
                                                petLevel = pets[NetworkGetNetworkIdFromEntity(v)].petOwner,
                                                petIMG = pets[NetworkGetNetworkIdFromEntity(v)].petIMG,
                                                petHealthLevel = pets[NetworkGetNetworkIdFromEntity(v)].petHealthLevel,
                                                petThirstLevel = pets[NetworkGetNetworkIdFromEntity(v)].petThirstLevel,
                                                petHungryLevel = pets[NetworkGetNetworkIdFromEntity(v)].petHungryLevel,
                                                petGender = pets[NetworkGetNetworkIdFromEntity(v)].petGender,
                                                vehicleSeat = pets[NetworkGetNetworkIdFromEntity(v)].vehicleSeat,
                                                showInfo  = showInfo,
                                                Locales = Locales
                                            })
                                            if IsControlJustPressed(0,PET.petInteractKeyCode) then
                                                local user_id = vSERVER.getid()
                                                if tonumber(pets[NetworkGetNetworkIdFromEntity(v)].petOwner) == tonumber(user_id) then
                                                    SetNuiFocus(true, true)
                                                    SetNuiFocusKeepInput(true)
                                                    if firstDisable then
                                                        SetNuiFocusKeepInput(true)
                                                        LockKeyboard = true
                                                    else
                                                        SetNuiFocusKeepInput(false)
                                                        LockKeyboard = false
                                                    end
                                                    openControlMenu(pets[NetworkGetNetworkIdFromEntity(v)])
                                                    isOpen = true
                                                    Citizen.CreateThread(function()
                                                        while isOpen do
                                                            DisableDisplayControlActions()
                                                            Citizen.Wait(1)
                                                        end
                                                    end)
                                                end
                                            end
                                            sleep = 0
                                        else
                                        end
                                    end
                                else
                                    if showShowKey then
                                        SendNUIMessage({
                                            action = "CLOSE_KEY"
                                        })
                                        showShowKey = false
                                        sleep = 200
                                        nearbyPed = nil
                                    end
                                end
                            end
                        end
                    else
                        -- Wait()
                    end
                end
            end
        Wait(sleep)
    end
end)


throwingBall = false
Citizen.CreateThread(function()
    while true do
        -- Top fırlatma gibi vesaire kullanım
        if ballGame then
            if ballThrown then
                if pet == nil then
                    pet = NetworkGetEntityFromNetworkId(nearbyPed)
                end
                local speed = GetEntitySpeed(pet)
                local dst3 = #(GetEntityCoords(pet) - GetEntityCoords(ballObj))
                local petToPlayer = #(GetEntityCoords(pet) - GetEntityCoords(PlayerPedId())) 
                if speed <= 0 then
                    throwingBall = true
                    TaskGoToEntity(pet, ballObj, -1, 2.0, petSpeed, 1073741824.0, 0)
                    stay = false
                    feeding = false
                    if dst3 < 2 then 
                        DeleteEntity(ballObj)
                        ballThrown = false
                        petMoving = false
                        chasing = false
                        returnBall = true
                        TaskGoToEntity(pet, ballObj, -1, 2.0, petSpeed, 1073741824.0, 0)        
                    end
                end
            end

            -- Move & Stay
            local dst = #(GetEntityCoords(pet) - GetEntityCoords(PlayerPedId()))
            if throwingBall  and dst > 5 and not petMoving and not stay and not feeding and not chasing and not attacking and
                not searching then
                petMoving = true
                TaskGoToEntity(pet, PlayerPedId(), -1, 1.0, petSpeed, 1073741824.0, 0)
            elseif throwingBall  and dst < 5  then
                petMoving = false
                if returnBall then
                    print('returned ball')
                    TriggerServerEvent('lab-pet:server:returnBall')
                    returnBall = false
                    ballGame = false
                    throwingBall = false
                end
            end
        end
        Wait(0)
    end
end)




-- **  Functions
boughtScreen = function()
    SetEntityCoords(PlayerPedId(), PET.petBuyCoords.x,PET.petBuyCoords.y,PET.petBuyCoords.z-0.9, 0, 0, 0, true)
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(120)
    setCamera(true)
    SendNUIMessage({
        action = "OPEN_BOUGHTSCREEN",
        petlist = PET.AvailablePets
    })
    SetNuiFocus(true, true)
    Wait(1200)
end

openControlMenu = function(data)
    SendNUIMessage({
        action = "OPEN_CONTROLPANEL",
        data = data,
        Locales = Locales,
        Orders = PET.Orders
    })
end


setCamera = function(bool)
    if bool then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
        
        local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.65)
        SetCamCoord(cam, coordsCam.x+0.5,coordsCam.y-0.5,coordsCam.z-1.0)
        PointCamAtCoord(cam, PET.petShowCoords.x,PET.petShowCoords.y,PET.petShowCoords.z-0.5)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 800, true, true)   
    else
        ClearFocus()
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
        
        cam = nil
    end
end


deletePed = function()
    DeleteEntity(dog)
end



GetCurrentEntityCoords = function (entity)
    local eID = NetworkGetEntityFromNetworkId(entity)
    local entityCoord = GetEntityCoords(eID)
    local min, max = GetModelDimensions(GetEntityModel(eID))
    local height = (max.y - min.y) / 2
    local onScreen, coordX, coordY = GetHudScreenPositionFromWorldPosition(entityCoord.x, entityCoord.y + height, entityCoord.z)
    return onScreen, coordX, coordY
end


loadAnimDict = function(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

SetAnim = function(animName, animID, targetPed)
    loadAnimDict(animName)
    TaskPlayAnim(targetPed, animName, animID, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
end


playSound = function(soundType)
    SendNUIMessage({
        action = "PLAYSOUND",
        type = soundType
    })
end

createBlip = function(data)
    local blip = nil
    if data.entity ~= nil then
        -- make blip for entities
        blip = AddBlipForEntity(data.entity)
    end
    if data.shortRange ~= nil and data.shortRange == true then
        SetBlipAsShortRange(blip, true)
    elseif data.shortRange == false then
        SetBlipAsShortRange(blip, false)
    end

    SetBlipSprite(blip, data.sprite)
    SetBlipColour(blip, data.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.text)
    EndTextCommandSetBlipName(blip)
    return blip
end


attackLogic = function(alreadyHunting, animalNetworkID)
    followThePlayer  = false
    print('Attack logic =>', alreadyHunting)
    pet = NetworkGetEntityFromNetworkId(tonumber(animalNetworkID))
    if not HasStreamedTextureDictLoaded("petshop") then
        RequestStreamedTextureDict("petshop", true)
        while not HasStreamedTextureDictLoaded("petshop") do
            Wait(1)
        end       
    end
    while true do
        Wait(0)
        local color = {
            r = 2,
            g = 241,
            b = 181,
            a = 100
        }
        local plyped = PlayerPedId()
        local position = GetEntityCoords(plyped)
        local coords, entity = RayCastGamePlayCamera(1000.0)
        Draw2DText(PET.petAttackKeyCodeDisplay, 4, { 255, 255, 255 }, 0.4, 0.43, 0.888 + 0.025)
        if IsControlJustReleased(0, PET.petAttackKeyCode) then
            print(' IsEntityAPed(entity) ~= 1',  IsEntityAPed(entity) ~= 1,  IsEntityAPed(entity))
            if IsEntityAPed(entity) ~= 1 then
                return false
            end
            local chaseDistance = PET.chaseDistance
            local indicator = PET.chaseIndicator
            AttackTargetedPed(pet, entity)
            alreadyHunting.state = true
            print('Attacking pet =< ', pet, chaseDistance, indicator, IsPedDeadOrDying(entity) == false, entity)
            while IsPedDeadOrDying(entity) == false do
                Wait(5)
                local pedCoord = GetEntityCoords(entity)
                local petCoord = GetEntityCoords(pet)
                local distance = GetDistanceBetweenCoords(pedCoord, petCoord)
                DrawMarker(9,pedCoord.x, pedCoord.y, pedCoord.z + 2, 0.0, 0.0, 0.0, 85.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255,255,255, 255,false, false, 2, false, "petshop", "attackIMG", false)
                if indicator ~= false and IsPedDeadOrDying(entity) ~= false then
                    alreadyHunting.state = false
                    return true
                end
                if distance >= chaseDistance then
                    alreadyHunting.state = false
                    return true
                end
            end
            -- later ask server to give xp
            alreadyHunting.state = false
            return true
        end
        -- target
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        DrawMarker(9,coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255,255,255, 255,true, false, 2, false, "petshop", "attackIMG", false)
    end
end



AttackTargetedPed = function(AttackerPed, targetPed)
    if not AttackerPed and not targetPed then
        return false
    end
    SetPedCombatAttributes(AttackerPed, 46, 1)
    TaskGoToEntityWhileAimingAtEntity(AttackerPed, targetPed, targetPed, 8.0, 1, 0, 15, 1, 1, 1566631136)
    TaskCombatPed(AttackerPed, targetPed, 0, 16)
    SetRelationshipBetweenPed(AttackerPed)
    SetPedCombatMovement(AttackerPed, 3)


    while IsPedDeadOrDying(targetPed, 0) ~= 1 do
        Wait(1000)
        -- skip
    end
    TaskFollowTargetedPlayer(AttackerPed, PlayerPedId(), 3.0, false)
end

SetRelationshipBetweenPed = function(ped)
    if not ped then
        return
    end
    -- note: if we don't do this they will star fighting among themselves!
    RemovePedFromGroup(AttackerPed)
    SetPedRelationshipGroupHash(AttackerPed, GetHashKey(AttackerPed))
    SetCanAttackFriendly(AttackerPed, false, false)

end


Draw2DText = function(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1], colour[2], colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

RotationToDirection = function(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

RayCastGamePlayCamera = function(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z,
        destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return c, e
end

getSpawnLocation = function(plyped)
    if IsPedInAnyVehicle(plyped, true) then
        return GetOffsetFromEntityInWorldCoords(plyped, -2.0, 1.0, 0.5)
    else
        return GetOffsetFromEntityInWorldCoords(plyped, 1.0, -1.0, 0.5)
    end
end


TaskFollowTargetedPlayer = function(follower, targetPlayer, distanceToStopAt, skip)
    ClearPedTasks(follower)
    if skip == false then
        TaskGoToCoordAnyMeans(follower, GetEntityCoords(targetPlayer), 10.0, 0, 0, 0, 0)
        Wait(5000)
    end
    TaskFollowToOffsetOfEntity(follower, targetPlayer, 2.5, 2.5, 2.5, 5.0, 10.0, distanceToStopAt, 1)
    return true
end
-- **  Commands 
-- RegisterCommand('setanim', function(source,args)
--     if nearbyPed ~= nil then
--         if args[1] == "pet" then
--             print(args[2], args[3],NetworkGetEntityFromNetworkId(nearbyPed) )
--             ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed) )
--             SetAnim(args[2], args[3], NetworkGetEntityFromNetworkId(nearbyPed))
--         end
--         if args[1] == "player" then
--             print(args[2], args[3],PlayerPedId())
--             ClearPedTasksImmediately(PlayerPedId())
--             SetAnim(args[2], args[3], PlayerPedId())
--         end
--     else
--         print('pet yok')
--     end
 
-- end)


RegisterCommand(PET.showPetCommand, function()
    local user_id = vSERVER.getid()
    for k,v in pairs(pets) do
        if tonumber(v.petOwner) == tonumber(user_id) then
            pet = NetworkGetEntityFromNetworkId(k)
            createBlip({
                entity = pet,
                sprite = PET.PetMiniMap.sprite,
                colour = PET.PetMiniMap.colour,
                text = v.petName,
                shortRange = false
            })
        end
    end
end)


RegisterCommand('at', function()
    followThePlayer = false
    attackLogic(alreadyHunting)
end)

RegisterCommand(PET.petInfoCommand, function()
    if showInfo then
        showInfo = false
    else
        showInfo = true
    end
end)



-- **  NUI Callbacks
RegisterNUICallback('closeMenu', function()
    headerShown = false
    sendData = nil
    SetNuiFocus(false)
    setCamera(false)
    FreezeEntityPosition(PlayerPedId(), false)
    isOpen = false
    deletePed()
    if dog ~= nil then
        DeleteEntity(dog)
        DeletePed(dog)
        dog = nil
    end
end)

local dog = nil

RegisterNUICallback('changePet', function(data,cb)
    Wait(1000)
    local randomAnim = PET.RandomAnim[data.animalList][math.random(1,#PET.RandomAnim[data.animalList])]
    if dog ~= nil then
        DeleteEntity(dog)
        DeletePed(dog)
        dog = nil
    end
    pedHash = GetHashKey(data.pedHash)
    while not HasModelLoaded(pedHash) do RequestModel(pedHash) Wait(20) end
    dog = CreatePed(9, pedHash, PET.petShowCoords.x, PET.petShowCoords.y, PET.petShowCoords.z-1.0, PET.petShowCoords.h, false, true)
    SetEntityHeading(dog, 119.9)
    FreezeEntityPosition(dog, true)
    SetPedComponentVariation(dog, 3 , 0, 0, 2) -- 3(torso)   |  Tasma değiştiriyor


    if data.petBoughtAnim ~= "false" then
        loadAnimDict(randomAnim.animName)
        if IsEntityPlayingAnim( dog, randomAnim.animName, randomAnim.animID,3) then 
            TaskPlayAnim( dog, randomAnim.animName, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )           
            ClearPedTask(dog)
        else
            TaskPlayAnim( dog, randomAnim.animName, randomAnim.animID, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
        end
	end       
end)

RegisterNUICallback('buyPet', function(data,cb)
    if dog ~= nil then
        DeleteEntity(dog)
    end
    TriggerServerEvent('lab-pet:server:buyPet', data)
end)

local animalRotation

RegisterNUICallback("mouseMovement",function(data)
    if dog then
            local x = data['x'] / 10
            local y = data['y'] / 10   
        SetEntityRotation(dog, animalRotation[1] + y, 0.0, animalRotation[3] - x)
    end
end)

RegisterNUICallback("registerMouse",function(data)
    -- print('registerMouse')
    animalRotation = GetEntityRotation(dog)
end)

RegisterNUICallback("changePetIMG",function(data)
    if data.petNewIMG == "" then
        data.petNewIMG = PET.DefaultPetIMG 
    end
    print('changepetIMG',data.networkID, data.petNewIMG, data.variable)
    pets[tonumber(data.networkID)].petIMG = data.petNewIMG
    TriggerServerEvent('lab-pet:server:changeVariable', tonumber(data.networkID), data.petNewIMG, data.variable)
end)


RegisterNUICallback("changePetName",function(data)
    if data.petNewName == "" then
        data.petNewName = PET.DefaultPetName
    end
    print('changepetName',data.networkID, data.petNewName ,data.variable)
    print(json.encode(pets))
    print(json.encode(pets[65534]))
    pets[tonumber(data.networkID)].petName = data.petNewName
    TriggerServerEvent('lab-pet:server:changeVariable', tonumber(data.networkID), data.petNewName, data.variable)
end)



RegisterNUICallback('setEvent', function(data)
    eventName = data.eventName
    animalType = data.animalType
    animalNetworkID = data.animalNetworkID
    TriggerEvent(eventName, animalType, animalNetworkID)
end)

RegisterNUICallback('disableControls',function (data,cb)
    firstDisable = not firstDisable
    if firstDisable then
        SetNuiFocusKeepInput(true)
        LockKeyboard = true
    else
        SetNuiFocusKeepInput(false)
        LockKeyboard = false
    end
end)






-- **  Events

RegisterNetEvent('lab-pet:client:uptadePets', function(petIndex, petValues) -- TODO burada tüm client güncellemeleri tarzı bir şey yapılabilir.
    pets[petIndex] = petValues
    if tonumber(pets[petIndex].petHealthLevel) <= 0 then
        pets[petIndex].dead = true
        if PET.PermanentlyDie then
            pets[petIndex] = nil
            TriggerServerEvent('lab-pet:server:DeletePet', petIndex, petValues)
        end
    end
end)

RegisterNetEvent('lab-pet:client:petLongerNeeded', function()
    if json.encode(pets) ~= "[]" then
        for k,v in pairs(pets) do
            pet = NetworkGetEntityFromNetworkId(tonumber(pets[k].netID))
            SetBlockingOfNonTemporaryEvents(pet, true)
        end
    end
end)

RegisterNetEvent('lab-pet:client:loadingAttemps', function() -- Sistem petleri yükledikten sonra döngüleri aktif etsin diye.
    loadingAttemps = true
end)

RegisterNetEvent('lab-pet:client:sendNotify', function(text, level, levelupping,networkID)
    if PET.NotificationInScript then
        SendNUIMessage({
            action = "SHOW_NOTIFY",
            message = text,
            level = level,
            Locales = Locales,
          })
          if levelupping == "levelupping" then
            playSound("levelup")
            pets[tonumber(networkID)].petLevel = level
          end
    else
        PET.Notification(text,inform)
    end
end)

RegisterNetEvent('lab-pet:client:fill', function(amount, type)
    print('FILL =>', nearbyPed, amount, type)
    if nearbyPed ~= nil then
        -- if pet == nil then
            
        -- end
        if type == "heal" then
            if tonumber(pets[nearbyPed].petHealthLevel) <= 0 then
                SetAnim("rcmextreme3", "idle", PlayerPedId())
                if PET.ProgressBar then
                    Wait(2200)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    Wait(220)
                    ClearPedTasksImmediately(PlayerPedId())
                end
                pets[nearbyPed].dead = false
                pets[nearbyPed].petHealthLevel = amount
                TriggerServerEvent('lab-pet:server:fill',nearbyPed, pets[nearbyPed].petHealthLevel, type)
                ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))

                
                playSound("levelup")
                TriggerEvent('lab-pet:client:sendNotify', Locales.HealToAnimal)

                SetAnim("creatures@rottweiler@melee@", "dog_attack", NetworkGetEntityFromNetworkId(nearbyPed))
                Wait(1200)
                ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
            else
                TriggerEvent('lab-pet:client:sendNotify', Locales.AnimalHealthMax)
            
            end

            if IsPedDeadOrDying(NetworkGetEntityFromNetworkId(nearbyPed), 1) then
                local coords = GetEntityCoords(NetworkGetEntityFromNetworkId(nearbyPed))
                NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(NetworkGetEntityFromNetworkId(nearbyPed)), true, false)
                isDead = false
                SetEntityInvincible(NetworkGetEntityFromNetworkId(nearbyPed), false)
                ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
                SetEntityMaxHealth(NetworkGetEntityFromNetworkId(nearbyPed), 200)
                SetEntityHealth(NetworkGetEntityFromNetworkId(nearbyPed), 200)
                ClearPedBloodDamage(NetworkGetEntityFromNetworkId(nearbyPed))
                SetPlayerSprint(NetworkGetEntityFromNetworkId(nearbyPed), true)
			end
            -- TEST 

            --
        end
        if type == "hungry" then -- pet'in gireceği animasyonlarda kedi /kuş / köpek şeklinde ayırılması gerekiyor "pets[nearbyPed].listOf"
            if tonumber(pets[nearbyPed].petHungryLevel) <= 96 then
                SetAnim("rcmextreme3", "idle", PlayerPedId()) --- Karakter eğilecek
                TaskTurnPedToFaceEntity(NetworkGetEntityFromNetworkId(nearbyPed), PlayerPedId(), 0.3) -- pet oyuncuya dönecek
                Wait(1200)
                if pets[nearbyPed].listOf == "dog" then
                    SetAnim("creatures@rottweiler@tricks@", "sit_loop", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2200)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetAnim('creatures@retriever@amb@world_dog_barking@idle_a', 'idle_c', NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2000)
                    SetAnim("creatures@rottweiler@melee@", "dog_attack", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(1500)
                    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
                end
                if pets[nearbyPed].listOf == "cat" then
                    SetAnim("creatures@cat@amb@world_cat_sleeping_ledge@exit", "exit_l", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2200)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetAnim('creatures@cat@player_action@', 'action_a', NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2000)
                    SetAnim("creatures@cat@amb@peyote@enter", "enter", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(3500)
                    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
                end
                if  (pets[nearbyPed].petHungryLevel + tonumber(amount)) >= 97 then
                    pets[nearbyPed].petHungryLevel =  100
                else
                    pets[nearbyPed].petHungryLevel =  pets[nearbyPed].petHungryLevel + tonumber(amount)
                end
                playSound("levelup")
                TriggerEvent('lab-pet:client:sendNotify', Locales.HungryToAnimal)
                TriggerServerEvent('lab-pet:server:fill', nearbyPed, pets[nearbyPed].petHungryLevel, type)
            else
                TriggerEvent('lab-pet:client:sendNotify', Locales.AnimalHungryMax)
            end
        end
        if type == "thirst" then
            if tonumber(pets[nearbyPed].petThirstLevel) <= 96 then
                SetAnim("rcmextreme3", "idle", PlayerPedId()) --- Karakter eğilecek
                TaskTurnPedToFaceEntity(NetworkGetEntityFromNetworkId(nearbyPed), PlayerPedId(), 0.3) -- pet oyuncuya dönecek
                Wait(1200)
                if pets[nearbyPed].listOf == "dog" then
                    SetAnim("creatures@rottweiler@tricks@", "sit_loop", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2200)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetAnim('creatures@retriever@amb@world_dog_barking@idle_a', 'idle_c', NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2000)
                    SetAnim("creatures@rottweiler@melee@", "dog_attack", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(1500)
                    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
                end
                if pets[nearbyPed].listOf == "cat" then
                    SetAnim("creatures@cat@amb@world_cat_sleeping_ledge@exit", "exit_l", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2200)
                    ClearPedTasksImmediately(PlayerPedId())
                    SetAnim('creatures@cat@player_action@', 'action_a', NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(2000)
                    SetAnim("creatures@cat@amb@peyote@enter", "enter", NetworkGetEntityFromNetworkId(nearbyPed))
                    Wait(3500)
                    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
                end
                if  (pets[nearbyPed].petThirstLevel + tonumber(amount)) >= 97 then
                    pets[nearbyPed].petThirstLevel =  100
                else
                    pets[nearbyPed].petThirstLevel =  pets[nearbyPed].petThirstLevel + tonumber(amount)
                end
                playSound("levelup")
                TriggerEvent('lab-pet:client:sendNotify', Locales.HungryToAnimal)
                TriggerServerEvent('lab-pet:server:fill', nearbyPed, pets[nearbyPed].petThirstLevel, type)
            else
                TriggerEvent('lab-pet:client:sendNotify', Locales.AnimalHungryMax)
            end
        end
        FreezeEntityPosition(NetworkGetEntityFromNetworkId(nearbyPed), false)
    else
        TriggerEvent('lab-pet:client:sendNotify', Locales.NotFoundAnyAnimal)
    end
end)


local tempRope = nil
RegisterNetEvent('lab-pet:client:useRope', function()
    if not pets[nearbyPed].rope then

        local petCoords =  GetEntityCoords(NetworkGetEntityFromNetworkId(nearbyPed))
        local playerCoords =  GetEntityCoords(PlayerPedId())
        loadAnimDict('missfbi4prepp1')
        TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
        RopeLoadTextures()
        while not RopeAreTexturesLoaded() do
            Citizen.Wait(50)
        end
        -- TaskWanderStandard(NetworkGetEntityFromNetworkId(nearbyPed), 10.0, 10) -- etrafta boş koştursun diye, yoksa yerinden oynamıyor malesef ki
        tempRope = AddRope(petCoords.x, petCoords.y, petCoords.z, 0.0, 0.0, 0.0, 1.0, 1, 5.0, 0.1, true, true, true, 1.0, true, true) 
        if pets[nearbyPed].petHash ~= "a_c_pug" or pets[nearbyPed].petHash ~= "a_c_poodle" or  pets[nearbyPed].petHash ~= "a_c_cat_01" then
            AttachEntitiesToRope(tempRope, PlayerPedId(), NetworkGetEntityFromNetworkId(nearbyPed), 0.0, 0.0, 0.1, 0.0, 0.0, 0.1, 3.0, true, true, "SKEL_R_Finger00", "SKEL_Head")
        else
            AttachEntitiesToRope(tempRope, PlayerPedId(), NetworkGetEntityFromNetworkId(nearbyPed), 0.0, 0.0, 0.1, 0.0, 0.0, 0.1, 3.0, true, true, "SKEL_R_Finger00", "SKEL_Neck_1")
        end
        pets[nearbyPed].rope = true
        pets[nearbyPed].follow = true
        ropeFollowThePlayer = true
        if pet == nil then
            pet = NetworkGetEntityFromNetworkId(nearbyPed)
        end
        TaskGoToEntity(pet, PlayerPedId(), -1, 0.2, petSpeed, 1073741824.0, 0)
    else
        DeleteRope(tempRope)
        ClearPedTasksImmediately(PlayerPedId())
        pets[nearbyPed].rope = false
        pets[nearbyPed].follow = false
    end
    TriggerServerEvent('lab-pet:server:changeToBoolean', tonumber(nearbyPed), "rope",  pets[nearbyPed].rope)

end)

RegisterNetEvent('lab-pet:client:useTennisBall')
AddEventHandler('lab-pet:client:useTennisBall', function()
    if pet == nil then
        pet = NetworkGetEntityFromNetworkId(nearbyPed)
    end
    local hash = 'prop_tennis_ball'
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.0))
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    ballObj = CreateObjectNoOffset(hash, x, y, z, true, false)
    SetModelAsNoLongerNeeded(hash)
    AttachEntityToEntity(ballObj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.15, 0, 0, 0, 270.0, 60.0,true, true, false, true, 1, true) -- object is attached to right hand 
    TaskTurnPedToFaceEntity(pet, PlayerPedId(), 0.3) -- pet oyuncuya dönecek
    Wait(1500)
    SetAnim('creatures@rottweiler@indication@', 'indicate_high', pet)
    Wait(1500)
    ClearPedTasksImmediately(pet)
    local forwardVector = GetEntityForwardVector(PlayerPedId())
    local force = 50.0
    local animDict = "melee@unarmed@streamed_variations"
    local anim = "plyr_takedown_front_slap"
    ClearPedTasks(PlayerPedId())
    while (not HasAnimDictLoaded(animDict)) do
        RequestAnimDict(animDict)
        Citizen.Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), animDict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Wait(500)
    DetachEntity(ballObj)
    ApplyForceToEntity(ballObj, 1, forwardVector.x * force, forwardVector.y * force + 5.0, forwardVector.z, 0, 0, 0, 0,
        false, true, true, false, true)
    ballID = ObjToNet(ballObj)
    SetNetworkIdExistsOnAllMachines(ballObj, true)
    Wait(1200)
    -- pet = nil
    ballGame = true
    ballThrown = true
    chasing = true
end)


RegisterNetEvent('lab-pet:client:followOwner', function(animalType, animalNetworkID)
    pet = NetworkGetEntityFromNetworkId(tonumber(animalNetworkID))
    print('^2pets[tonumber(animalNetworkID)].followThePlayer [1] (Normal)', pets[tonumber(animalNetworkID)].followThePlayer)
    if pets[tonumber(animalNetworkID)].followThePlayer == false  then
        -- ClearPedTasksImmediately(pet)
        pets[tonumber(animalNetworkID)].followThePlayer  = true
        TaskGoToEntity(pet, PlayerPedId(), -1, 0.5, petSpeed, 1073741824.0, 0)
    else
        pets[tonumber(animalNetworkID)].followThePlayer  = false
        ClearPedTasksImmediately(pet)
    end
    TriggerServerEvent('lab-pet:server:changeToBoolean', tonumber(animalNetworkID), "followThePlayer",  pets[tonumber(animalNetworkID)].followThePlayer)
    print('^3pets[tonumber(animalNetworkID)].followThePlayer [2] (Sonraki değer.)', pets[tonumber(animalNetworkID)].followThePlayer)
end)


RegisterNetEvent('lab-pet:client:sit', function(animalType, animalNetworkID)
    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed) )
    if pets[tonumber(animalNetworkID)].petHash == "a_c_westy" or pets[tonumber(animalNetworkID)].petHash == "a_c_poodle" or pets[tonumber(animalNetworkID)].petHash == "a_c_pug" then
        SetAnim("amb@lo_res_idles@", "creatures_world_pug_sitting_lo_res_base", NetworkGetEntityFromNetworkId(nearbyPed))
    else
        SetAnim(PET.OrderAnim[animalType]["sit"].animName, PET.OrderAnim[animalType]["sit"].animID, NetworkGetEntityFromNetworkId(nearbyPed))
    end
end)

RegisterNetEvent('lab-pet:client:getup', function(animalType)
    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
    if pets[tonumber(animalNetworkID)].petHash == "a_c_westy" or pets[tonumber(animalNetworkID)].petHash == "a_c_poodle" or pets[tonumber(animalNetworkID)].petHash == "a_c_pug" then
        SetAnim("creatures@pug@amb@world_dog_sitting@exit", "exit", NetworkGetEntityFromNetworkId(nearbyPed))
    else
        SetAnim(PET.OrderAnim[animalType]["getup"].animName, PET.OrderAnim[animalType]["getup"].animID, NetworkGetEntityFromNetworkId(nearbyPed))
    end
    Wait(1200)
    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed))
end)

RegisterNetEvent('lab-pet:client:sleep', function(animalType,animalNetworkID)
    ClearPedTasksImmediately(NetworkGetEntityFromNetworkId(nearbyPed) )
    if pets[tonumber(animalNetworkID)].petHash == "a_c_westy" or pets[tonumber(animalNetworkID)].petHash == "a_c_poodle" or pets[tonumber(animalNetworkID)].petHash == "a_c_pug" then
        TriggerEvent('lab-pet:client:sendNotify', Locales.notSuported)
        return
    end
    SetAnim(PET.OrderAnim[animalType]["sleep"].animName, PET.OrderAnim[animalType]["sleep"].animID, NetworkGetEntityFromNetworkId(nearbyPed))
end)

RegisterNetEvent('lab-pet:client:attack', function(animalType, animalNetworkID)
    pet = NetworkGetEntityFromNetworkId(animalNetworkID)
    if pets[tonumber(animalNetworkID)].petHash == "a_c_westy" or pets[tonumber(animalNetworkID)].petHash == "a_c_poodle" or pets[tonumber(animalNetworkID)].petHash == "a_c_pug" then
        TriggerEvent('lab-pet:client:sendNotify', Locales.canNotAttack)
        return
    end
    ClearPedTasksImmediately(pet)
    pets[tonumber(animalNetworkID)].followThePlayer = false
    attackLogic(alreadyHunting, animalNetworkID)
end)

RegisterNetEvent('lab-pet:client:getIntoCar', function(animalType, animalNetworkID)
    local plyped = PlayerPedId()
    local ped = NetworkGetEntityFromNetworkId(tonumber(animalNetworkID))
    local player_coord = GetEntityCoords(plyped)
    local pet_coord = GetEntityCoords(ped)
    local distance = #(player_coord - pet_coord)
    local vehicle = GetClosestVehicle(player_coord.x, player_coord.y,player_coord.z, 5.000, 0, 70)
    local seatEmpty = 6
    for i = 2, 5, 1 do
        if IsVehicleSeatFree(vehicle, i - 2) then
            SetPedIntoVehicle(ped, vehicle, i - 2)
            if pets[tonumber(animalNetworkID)].petHash == "a_c_westy" or pets[tonumber(animalNetworkID)].petHash == "a_c_poodle" or pets[tonumber(animalNetworkID)].petHash == "a_c_pug" then
                SetAnim("amb@lo_res_idles@", "creatures_world_pug_sitting_lo_res_base", NetworkGetEntityFromNetworkId(nearbyPed))
            else
                SetAnim(PET.OrderAnim[animalType]["sit"].animName, PET.OrderAnim[animalType]["sit"].animID, NetworkGetEntityFromNetworkId(nearbyPed))
            end            SendNUIMessage({
                action = "CLOSE_KEY"
            })
            pets[tonumber(animalNetworkID)].vehicleSeat = true
            TriggerServerEvent('lab-pet:server:changeToBoolean', tonumber(animalNetworkID), "vehicleSeat",  pets[tonumber(animalNetworkID)].vehicleSeat)
            seatEmpty = i - 2
            break
        end
    end

    if seatEmpty == 6 then
        TriggerEvent('lab-pet:client:sendNotify', Locales.vehicleSeatFull)
        return
    end
end)

RegisterNetEvent('lab-pet:client:getOutCar', function(animalType, animalNetworkID)
    local ped = NetworkGetEntityFromNetworkId(tonumber(animalNetworkID))
    local playerped = PlayerPedId()
    local coord = getSpawnLocation(playerped)
    if IsPedInAnyVehicle(ped, true) then
        SetEntityCoords(ped, coord, 1, 0, 0, 1)
        pets[tonumber(animalNetworkID)].vehicleSeat = false
        TriggerServerEvent('lab-pet:server:changeToBoolean', tonumber(animalNetworkID), "vehicleSeat",  pets[tonumber(animalNetworkID)].vehicleSeat)
    end
    Wait(75)
end)


-- disable all control actions
function DisableDisplayControlActions()
    playerPed = PlayerPedId()
    DisablePlayerFiring(playerPed, true)
    SetPedCanPlayGestureAnims(playerPed, false)
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 257, true) -- Attack 2
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 263, true) -- Melee Attack 1
    DisableControlAction(0, 45, true) -- Reload
    DisableControlAction(0, 21, true) -- left shift
    DisableControlAction(0, 22, true) -- Jump
    DisableControlAction(0, 23, true) -- F
    DisableControlAction(0, 182, true) -- L
    DisableControlAction(0, 80, true) -- R
    DisableControlAction(0, 311, true) -- K
    DisableControlAction(0, 26, true) -- C
    DisableControlAction(0, 75, true) -- F
    DisableControlAction(0, 157, true)
    DisableControlAction(0, 158, true)
    DisableControlAction(0, 160, true)
    DisableControlAction(0, 164, true)
    DisableControlAction(0, 165, true)
    DisableControlAction(0, 44, true) -- Cover
    DisableControlAction(0, 37, true) -- Select Weapon
    DisableControlAction(0, 288,  true) -- Disable phone
    DisableControlAction(0, 245,  true) -- Disable chat
    DisableControlAction(0, 289, true) -- Inventory
    DisableControlAction(0, 170, true) -- Animations
    DisableControlAction(0, 167, true) -- Job
    DisableControlAction(0, 244, true) -- Ragdoll
    DisableControlAction(0, 303, true) -- Car lock
    DisableControlAction(0, 29, true) -- B ile işaret
    DisableControlAction(0, 81, true) -- B ile işaret
    DisableControlAction(0, 26, true) -- Disable looking behind
    DisableControlAction(0, 73, true) -- Disable clearing animation
    DisableControlAction(2, 199, true) -- Disable pause screen
    DisableControlAction(2, 36, true) -- Disable going stealth
    DisableControlAction(0, 47, true)  -- Disable weapon
    DisableControlAction(0, 264, true) -- Disable melee
    DisableControlAction(0, 257, true) -- Disable melee
    DisableControlAction(0, 140, true) -- Disable melee
    DisableControlAction(0, 141, true) -- Disable melee
    DisableControlAction(0, 142, true) -- Disable melee
    
end

print('functions.lua its ready')
