function DRP_MenuOpen(resourceName, id, datas, cb, cbs)
    local display = false
    local menu = {}
    menu.close = function(a)
        a = a or id
        SendNUIMessage({
            display = false,
            id = a,
            resource = resourceName,
            close = true
        })
        local as
        RegisterNUICallback("cancel_pressed", function(data, callback)
            as = data
            -- cbs(data)
            display = false
            callback("ok")
        end)
        while as == nil do Citizen.Wait(0) end
        cbs(menu, as)
    end

    SendNUIMessage({
        display = true,
        title = datas.title,
        subtitle = datas.subtitle,
        elements = datas.elements,
        id = id,
        resource = resourceName
    })
    -- SetNuiFocus(true)
    display = true
    while display do
        Citizen.Wait(0)
        if (IsControlJustPressed(0, 172)) then
            SendNUIMessage({
                control = "up",
                controlme = true,
                id = id,
                resource = resourceName
            })
        elseif (IsControlJustPressed(0, 173)) then
            SendNUIMessage({
                control = "down",
                controlme = true,
                id = id,
                resource = resourceName
            })
        elseif (IsControlJustPressed(0, 176)) then
            SendNUIMessage({
                control = "enter",
                controlme = true,
                id = id,
                resource = resourceName
            })
            local a
            RegisterNUICallback("submit_pressed", function(data, callback)
                a = data
                -- cb(data)
                callback("ok")
            end)
            while a == nil do Citizen.Wait(0) end
            cb(menu, a)
        elseif (IsControlJustPressed(0, 177)) then
            menu.close(id)
        end
    end
end
