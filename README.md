# DRP Menu GUI

DRP Menu created by Big Yoda for DRP Framework.


# Example:

__resource.lua
```lua
resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "client.lua"
client_script "@drp_menu/client.lua"

dependencies {
  "drp_menu"
}
```

client.lua
```lua
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
      if (IsControlJustPressed(0, 244)) then -- M
        openExampleMenu()
      end
  end
end)

function openExampleMenu()
    DRP_MenuOpen(GetCurrentResourceName(), "Menu-ID", {
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
         menu.close() -- Closes Menu
     end, function(menu, data) -- When the menu has been closed but not hidden.
         print("closed")
     end)
end
```
