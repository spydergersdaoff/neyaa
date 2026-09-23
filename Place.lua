local PlaceId = game.PlaceId

local idsJeux = {
    [76460552000865] = 'loadstring(game:HttpGet("https://pastefy.app/KTjnzyRB/raw"))()',
    [142823291] = 'loadstring(game:HttpGet("https://raw.smokingscripts.org/vertex.lua"))()',
    [17625359962] = 'loadstring(game:HttpGet("https://pastefy.app/eM7R6V8O/raw"))()',
}

-- Script de secours si aucun ID ne correspond
local scriptParDefaut = 'loadstring(game:HttpGet("TON_LIEN_DE_SECOURS_ICI"))()'

local codeAExecuter = idsJeux[PlaceId] or scriptParDefaut

if codeAExecuter then
    local func, err = loadstring(codeAExecuter)
    if func then
        pcall(func)
    else
        warn("Erreur de chargement du script : " .. tostring(err))
    end
end
