QBCore = nil
local alerted = false
local timeleft = 0

local job = "unemployed"

Citizen.CreateThread(function()
    while QBCore == nil do 
        TriggerEvent("QBCore:GetObject",function(obj)
            QBCore = obj
        end)
        Citizen.Wait(0)
    end

    while QBCore.Functions.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    job = QBCore.Functions.GetPlayerData().job.name
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(j)
    job = j.name
end) 

RegisterNetEvent("core_deskbell:alert_c")
AddEventHandler("core_deskbell:alert_c", function(ans)
    if string.match(ans, job) then
        SendNotice(Config.Text["someone_is_waiting"])
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if timeleft == 0 then
            alerted = false
        end

        if timeleft >= 0 then
            timeleft = timeleft - 1
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for __, v in ipairs(Config.Desks) do
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords) < 3 then
                if alerted then
                    DrawText3D(v.coords[1], v.coords[2], v.coords[3], Config.Text["please_wait"] .. timeleft)
                else
                    DrawText3D(v.coords[1], v.coords[2], v.coords[3], Config.Text["press_to_call"])
                    if IsControlJustReleased(0, 38) then
                        alerted = true
                        timeleft = 30
                        TriggerServerEvent("core_deskbell:alert_s", v.job)
                    end
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.45 * scale, 4)
        local width = EndTextCommandGetWidth(5) + 0.01

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        DrawRect(_x, (_y + scale / 78), width, height, 10, 10, 10, 100)
    end
end
