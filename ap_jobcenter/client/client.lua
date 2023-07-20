local menuOptions = {}
local cfg = Config.apJobcenter
local pedModel = cfg.pedModel
local pedGarasi = cfg.pedGarasi
local position = cfg.position
local garasiPosition = cfg.garasiPosition
local Spawnveh = cfg.Spawnveh
local debug = cfg.ShowDebug
local Lang = Config.Lang
local vehout = false

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local function setupPoint()
    lib.requestModel(pedModel)
    ped = CreatePed(0, pedModel, position.x, position.y, position.z - 1, position.w, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GUARD_STAND')
    local options = {
        {
            name = 'tgJob',
            icon = 'fa-solid fa-helmet-safety',
            label = Config.String[Lang].listjob,
            distance = 1.2,
            onSelect = function()
                TaskTurnPedToFaceCoord(cache.ped, position, 1400)
                lib.showContext('dartarjob')
            end,
            canInteract = function()
                if IsPedInAnyVehicle(cache.ped) or IsEntityDead(cache.ped) or lib.progressActive() then
                    return false
                end
                return true
            end
        }
    }
    exports.ox_target:addModel(pedModel, options)
end

local function setupGarasi()
    lib.requestModel(pedGarasi)
    pedG = CreatePed(0, pedGarasi, garasiPosition.x, garasiPosition.y, garasiPosition.z - 1, garasiPosition.w, true, true)
    FreezeEntityPosition(pedG, true)
    SetEntityInvincible(pedG, true)
    SetBlockingOfNonTemporaryEvents(pedG, true)
    TaskStartScenarioInPlace(pedG, 'WORLD_HUMAN_GUARD_STAND')
    local options = {}
    table.insert(options, {
        name = 'tgGarasi',
        icon = 'fas fa-car-side',
        label = Config.String[Lang].namablip2,
        distance = 1.2,
        onSelect = function()
            AksesGarasi(ESX.PlayerData.job.name)
        end,
        canInteract = function()
            if vehout or IsPedInAnyVehicle(cache.ped) or IsEntityDead(cache.ped) or lib.progressActive() or ESX.PlayerData.job.name == 'busdriver' then
                return false
            end
            return true
        end
    })
    table.insert(options, {
        name = 'tgSave',
        icon = 'fas fa-parking',
        label = Config.String[Lang].parkir,
        distance = 1.2,
        onSelect = function()
            Delveh()
        end,
        canInteract = function()
            if vehout == false or Plate == nil or IsPedInAnyVehicle(cache.ped) or IsEntityDead(cache.ped) or lib.progressActive() or ESX.PlayerData.job.name == 'busdriver' then
                return false
            end
            return true
        end
    })
    exports.ox_target:addModel(pedGarasi, options)
end

local function setupBlip()
    local blip = AddBlipForCoord(position)
    SetBlipSprite(blip, 590)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 83)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.String[Lang].namablip1)
    EndTextCommandSetBlipName(blip)
end

local function setupBlipGarasi()
    local blip = AddBlipForCoord(garasiPosition)
    SetBlipSprite(blip, 326)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 83)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.String[Lang].namablip2)
    EndTextCommandSetBlipName(blip)
end

function img(name)
    for i, j in pairs(Config.Jobs) do
        if i == name then
            return j.images
        end
    end
end

function AksesGarasi(name)
    for i, j in pairs(Config.Jobs) do
        if i == name then
            if debug then
                print(j.vehJob)
                print(name)
            end
            return SpawnVeh(j.vehJob)
        elseif name == nil or name == 'unemployed' then
            TriggerEvent('ap_jobcenter:notify', Config.String[Lang].jobnil, 'inform', 5000)
            return
        end
    end
end

function SpawnVeh(veh)
    if not vehout then
        local coords = Spawnveh
        RequestModel(veh)
        while not HasModelLoaded(veh) do
            Wait(0)
        end
        if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
            local apveh = CreateVehicle(veh, coords.x, coords.y, coords.z, coords.w, true, false)
            vehout = true
            SetVehicleNumberPlateText(apveh, "ALPIN"..tostring(math.random(111, 999)))
            Plate = GetVehicleNumberPlateText(apveh)
            if debug then
                print(Plate)
            end
            Entity(apveh).state.fuel = 100
            SetVehicleEngineOn(apveh, true, true)
            SetVehicleOnGroundProperly(apveh)
            SetVehicleHasBeenOwnedByPlayer(apveh, true)
            SetEntityAsMissionEntity(apveh, true, true)
            local id = NetworkGetNetworkIdFromEntity(apveh)
            SetNetworkIdCanMigrate(id, true)
            TriggerEvent('ap_jobcenter:notify', Config.String[Lang].vehkeluar..' '..Plate, 'inform', 5000)
        else
            TriggerEvent('ap_jobcenter:notify', Config.String[Lang].bloklok, 'inform', 5000)
        end
    elseif vehout then
        TriggerEvent('ap_jobcenter:notify', Config.String[Lang].blokdouble, 'error', 5000)
    end
end

function Delveh()
    local vehicle = ESX.Game.GetClosestVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)
    plate = GetVehicleNumberPlateText(vehicle)
    if debug then
        print(Plate, plate)
    end
    if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(cache.ped), vehicleCoords) < 15.0 then
        if plate ~= Plate then
            TriggerEvent('ap_jobcenter:notify',  Config.String[Lang].notvehjob, 'error', 5000)
        else
            if vehout then
                ESX.Game.DeleteVehicle(vehicle)
                vehout = false
                Plate = nil
                TriggerEvent('ap_jobcenter:notify', Config.String[Lang].vehrelease, 'success', 5000)
            end
        end
    else
        TriggerEvent('ap_jobcenter:notify', Config.String[Lang].notveh, 'error', 5000)
    end
end

lib.callback('ap_jobcenter:getJobs', source, function(avaibleJobs)
    if Config.ShowBlipJobCenter then
        setupBlip()
    end
    if Config.ShowBlipGarasi then
        setupBlipGarasi()
    end
    for i = 1, #avaibleJobs do
        local v = avaibleJobs[i]
        table.insert(menuOptions, {
            title = v.gLabel, 
            description = Config.String[Lang].descjob, 
            image = img(v.name),
            icon = 'fa-solid fa-helmet-safety', 
            arrow = true,
            metadata = {
                {label = Config.String[Lang].gaji, value = ' $'..ESX.Math.GroupDigits(v.salary)},
            },
            onSelect = function() 
                local data = {
                    joblabel = v.gLabel,
                    jobname = v.name,
                    jobgrade = v.grade
                }
                liatJob(data)
            end
        })
    end
    lib.registerContext({
        id = 'dartarjob',
        title = Config.String[Lang].listjob,
        options = menuOptions,
        onExit = function()
            ClearPedTasks(cache.ped)
        end
    })
end)

function liatJob(data)
    local option = {}
    table.insert(option, {
        title = Config.String[Lang].pilihkerja,
        icon = 'fas fa-check-circle',
        onSelect = function()
            vehout = false
            Plate = nil
            if debug then
                print(Config.String[Lang].pilihkerja..' '..data.joblabel)
                print(vehout, Plate)
            end
            TriggerServerEvent('ap_jobcenter:setPlayerJob', data.jobname, data.jobgrade)
            TriggerEvent('ap_jobcenter:notify', Config.String[Lang].ambilkerja..' '..data.joblabel, 'success', 6000)
            ClearPedTasks(cache.ped)
        end
    })
    if data.jobname ~= 'unemployed' then
        table.insert(option, {
            title = Config.String[Lang].infojob,
            icon = 'fas fa-info-circle',
            onSelect = function()
                infoJob(data)
            end
        })
    end
    lib.registerContext({
        id = 'liatJob',
        title = data.joblabel,
        menu = 'dartarjob',
        options = option,
        onExit = function()
            ClearPedTasks(cache.ped)
        end
    })
    lib.showContext('liatJob')
end

function desc(data)
    for i, j in pairs(Config.Jobs) do
        if i == data.jobname then
            return j.TextJob
        end
    end
end

function infoJob(data)
    local option = {}
    table.insert(option, {
        title = Config.String[Lang].pekerjaan..' '..data.joblabel,
        description = desc(data),
        icon = 'fa fa-book',
    })
    table.insert(option, {
        title = Config.String[Lang].lokkantor,
        description = Config.String[Lang].klikgps,
        icon = 'fas fa-map-pin',
        onSelect = function()
            local type = 'waypointKantor'
            SetWaypoint(data, type)
        end
    })
    table.insert(option, {
        title = Config.String[Lang].lokshop,
        description = Config.String[Lang].klikgps,
        icon = 'fas fa-map-pin',
        onSelect = function()
            local type = 'waypointToko'
            SetWaypoint(data, type)
        end
    })
    table.insert(option, {
        title = Config.String[Lang].lokkerja,
        description = Config.String[Lang].klikgps,
        icon = 'fas fa-map-pin',
        onSelect = function()
            local type = 'waypointKerja'
            SetWaypoint(data, type)
        end
    })
    lib.registerContext({
        id = 'infoJob',
        title = Config.String[Lang].infos,
        menu = 'liatJob',
        options = option,
        onExit = function()
            ClearPedTasks(cache.ped)
        end
    })
    lib.showContext('infoJob')
end

function SetWaypoint(data, type)
    for i, j in pairs(Config.Jobs) do
        if i == data.jobname then
            if type == 'waypointKantor' then
                if debug then
                    print(type, data.joblabel, j.waypointKantor)
                end
                SetNewWaypoint(j.waypointKantor, true)
                TriggerEvent('ap_jobcenter:notify', Config.String[Lang].kantor..' '..data.joblabel..''..Config.String[Lang].setgps, 'success', 6000)
            elseif type == 'waypointToko' then
                if debug then
                    print(type, data.joblabel, j.waypointKantor)
                end
                SetNewWaypoint(j.waypointToko, true)
                TriggerEvent('ap_jobcenter:notify', Config.String[Lang].toko..' '..data.joblabel..''..Config.String[Lang].setgps, 'success', 6000)
            elseif type == 'waypointKerja' then
                if debug then
                    print(type, data.joblabel, j.waypointKantor)
                end
                SetNewWaypoint(j.waypointKerja, true)
                TriggerEvent('ap_jobcenter:notify', Config.String[Lang].lokjob..' '..data.joblabel..''..Config.String[Lang].setgps, 'success', 6000)
            end
            lib.showContext('infoJob')
        end
    end
end

local point = lib.points.new(position, 30, {})
local garasi = lib.points.new(garasiPosition, 30, {})

function point:onEnter()
    if debug then
        print(Config.String[Lang].spawnped1)
    end
    setupPoint()
end

function garasi:onEnter()
    if debug then
        print(Config.String[Lang].spawnped2)
    end
    setupGarasi()
end

function point:onExit()
    if debug then
        print(Config.String[Lang].deleteped1)
    end
    DeleteEntity(ped)
    exports.ox_target:removeModel(pedModel, options)
end

function garasi:onExit()
    if debug then
        print(Config.String[Lang].deleteped2)
    end
    DeleteEntity(pedG)
    exports.ox_target:removeModel(pedGarasi, options)
end