if minetest.global_exists("default") then
    minetest.log("ERROR: Something is wrong, this library MUST load prior to default")
end

intlitems = {}
intlitems.wt = {} 

local writetemplate = false
if minetest.setting_getbool("writeintlitemstemplate") == true then
    

    filename = minetest.get_modpath("intlitems") .. DIR_DELIM .. "locale" .. DIR_DELIM .. "template.txt" 

    writetemplate = true

    local file = io.open(filename,"r")
    if file ~= nil then
        while true do
          local line = file:read("*line")
          if line == nil then break end
          local bits = line:split(" = ")
          if bits[2] ~= nil then
            intlitems.wt[bits[1]] = bits[2]
          else
            intlitems.wt[bits[1]] = ""
          end
        end
        file:close()
    end

    minetest.register_chatcommand("writeintlitems", {
	    params = "no params", 
        description = "Writes the international items template intlitems/locale/template.txt", 
        func = function(name, param)
            
            local file = io.open(filename,"w")
            for k,v in pairs(intlitems.wt) do
                file:write(k, " = " , v , "\n")
            end
            file:close()
            return true, "Done! Wrote " .. #intlitems.wt .. " records."
        end,
        })

 
end
 
local S;
if (minetest.get_modpath("intllib")) then
    dofile(minetest.get_modpath("intllib").."/intllib.lua");
    S = intllib.Getter("intlitems");
else
    S = function ( s ) return s end;
end

local function gettext(originaltext)
    if originaltext == nil or originaltext == "" then
        return ""
    end
    if writetemplate then 
        if intlitems.wt[originaltext] == nil then
            intlitems.wt[originaltext] = ""
        end 
    end
    return S(description)
end


local origregister_item = core.register_item
function core.register_item(name, nodedef)
    nodedef.description = gettext(nodedef.description)    
    origregister_item(name,nodedef)
end
 