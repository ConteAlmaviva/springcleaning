--[[
* Ashita - Copyright (c) 2014 - 2022 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

_addon.author   = 'Almavivaconte';
_addon.name     = 'SpringCleaning';
_addon.version  = '0.0.1';

require 'common'

local wardrobes = {
    [8] = "Wardrobe",
    [10] = "Wardrobe2",
    [11] = "Wardrobe3",
    [12] = "Wardrobe4"
}

ashita.register_event('command', function(command, ntype)
    args = command:args()
    if args[1] == "/springcleaning" then
        
        local p_name = AshitaCore:GetDataManager():GetParty():GetMemberName(0);
        local inventory = AshitaCore:GetDataManager():GetInventory();
        local wardrobeContents = {}
        
        for k,v in pairs(wardrobes) do
            maxCap = inventory:GetContainerMax(k)
            for j = 0, maxCap, 1 do
                if maxCap > 0 then
                    itemId = inventory:GetItem(k, j).Id
                    if itemId ~= 0 and itemId ~= 65535 then
                        index = #wardrobeContents+1
                        wardrobeContents[index] = {}
                        wardrobeContents[index]['name'] = AshitaCore:GetResourceManager():GetItemById(itemId).Name[0]
                        wardrobeContents[index]['count'] = 0
                        wardrobeContents[index]['location'] = v
                    end
                end
            end
        end
        
        ACPath = string.format("%s%s", AshitaCore:GetAshitaInstallPath(), "config\\Ashitacast")
        
        myCommand = "dir /b " .. ACPath
        
        local handle = io.popen(myCommand);
        local result = handle:read("*a");
        unusedGear = {}
        ACProfs = {}
        for s in result:gmatch("[^\r\n]+") do
            if string.find(s, p_name) then
                table.insert(ACProfs, ACPath .. "\\" .. s)
            end
        end
        
        
        for k,v in pairs(wardrobeContents) do
            for l,w in pairs(ACProfs) do
                for line in io.lines(w) do
                    if v['count'] == 0 then
                        if string.find(string.lower(line), string.gsub(string.lower(v['name']), "+1", "")) then
                            v['count'] = v['count'] + 1
                        end
                    end
                end
            end
        end
        for k,v in pairs(wardrobeContents) do
            if v['count'] == 0 then
                print(v['name'] .. " in " .. v['location'] .. " is not referenced by Ashitacast.")
            end
        end
        return true
    end
    
    
    
    return false
end);