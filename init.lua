if minetest.global_exists("default") then
    minetest.log("ERROR: Something is wrong, this library MUST load prior to default")
end

intlitems = {}
intlitems.wt = {} 

local writetemplate = false
if minetest.setting_getbool("writeintlitemstemplate") == true then
 
    writetemplate = true
    dofile(minetest.get_modpath("intlitems").."/build.lua");
 
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
        if intlitems.wt[originaltext] == nil and originaltext:len() > 3 then
            intlitems.wt[originaltext] = ""
        end 
    end
    return S(originaltext)
end


local origregister_item = core.register_item
function core.register_item(name, nodedef)
    nodedef.description = gettext(nodedef.description)    
    origregister_item(name,nodedef)
end
 