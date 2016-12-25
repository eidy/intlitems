local filename = minetest.get_modpath("intlitems") .. DIR_DELIM .. "locale" .. DIR_DELIM .. "template.txt"
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
