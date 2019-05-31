Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (IsControlJustPressed(0, 182)) then
            print("Baror")
            DRP_MenuOpen(GetCurrentResourceName(), "lol", {
                title = "Title",
                subtitle = "Sub-Title",
                elements = {
                    { label = "Label 1", value = "1" },
                    { label = "Label 2", value = "2" },
                    { label = "Label 3", value = "3" },
                    { label = "Label 4", value = "4" }
                }
            }, function(menu, data) -- When a menu button has been pressed.
                TriggerEvent('chatMessage', "Pressed on " .. data.label .. " with value " .. data.value, { 255, 255, 255 })
                menu.close()
            end, function(menu, data) -- When the menu has been closed but not hidden.
                print("closed")
            end)
        end
    end
end)

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