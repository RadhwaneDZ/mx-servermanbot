Config = nil
exports('GetConfig', function (config)
    Config = config
end)

exports('GetDiscordFromId', function (id)
    for _,v in ipairs(GetPlayerIdentifiers(id)) do
        if string.match(v, 'discord:') then
            return string.gsub(v, 'discord:', '')
        end
    end
    return false
end)

exports('GetGeneralInformations', function (id)
    if GetPlayerName(id) then
        local fetch = [[SELECT * FROM players WHERE identifier = @id;]]
        local fetchData = {['@id'] = Identifier(id)}
        local result = exports['ghmattimysql']:execute(fetch, fetchData)
        local ident = Identifier(id)
        if result and result[1] then
            local discord = GetDiscord(id) or 'Not Finded'
            local embed = {
                fields = {
                    {name = 'Identifier', value = ident or '...', inline = true},
                    {name = 'name', value = result[1].name or '...', inline = true},
                    {name = 'Discord', value = '<@'..discord..'>', inline = true}
                },
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        end
    else
        local fetch = [[SELECT * FROM players WHERE identifier = @id]]
        local fetchData = {['@id'] = id}
        local result = exports['ghmattimysql']:execute(fetch, fetchData)
        if result and result[1] then
           
            local embed = {
                fields = {
                    {name = 'Identifier', value = ident or '...', inline = true},
                    {name = 'name', value = result[1].name or '...', inline = true},
                },
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        end
    end
end)

exports('GetPlayers', function ()
    local embed = {
        color = "#0094ff", -- blue
        author = 'PLAYERS',
    }
    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        local players = QBCore.Functions.GetPlayers()
        embed.title = '`'..#players..'` Online Player(s)'
        if next(players) then
            embed.fields = {
                {name = 'NAME [ID]', inline = true, value = ''},
                {name = 'DISCORD', inline = true, value = ''},
                {name = 'IDENTIFIER', inline = true, value = ''}
            }
            for i = 1, #players do
                local xPlayer = QBCore.Functions.GetPlayer(players[i])
                local discord = GetDiscord(players[i]) or 'Not Finded'
                embed.fields[1].value = embed.fields[1].value..GetPlayerName(players[i])..' ['..players[i]..']'
                embed.fields[2].value = embed.fields[2].value..'<@'..discord..'>'
                embed.fields[3].value = embed.fields[3].value..xPlayer.Functions.GetIdentifier
            end
        end
        TriggerEvent('mx-serverman:SendEmbed', embed)
    end)
end)
exports('Revive', function (id)
    if GetPlayerName(id) then
        TriggerClientEvent('hospital:client:Revive', id)
        local embed = {
            color = "#0094ff", -- blue
            title = '`'..GetPlayerName(id)..'` Revived.',
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
    else    
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
    end
end)

exports('ReviveAll', function ()
   TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        local players = QBCore.Functions.GetPlayers()
        for i = 1, #players do
            TriggerClientEvent('hospital:client:Revive', players[i])
        end
        if next(players) then
            local embed = {
                color = "#0094ff", -- blue
                title = 'All Players Revived. Total:`'..#players..'`',
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        else    
            local embed = {
                color = "#0094ff", -- blue
                title = 'Not player found.',
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        end
    end)
end)
function Identifier(player)
    for _,v in ipairs(GetPlayerIdentifiers(player)) do
        if Config.identifier == 'steam' then  
             if string.match(v, 'steam') then
                  return v
             end
        elseif Config.identifier == 'license' then
             if string.match(v, 'license:') then
                  return string.sub(v, 9)
             end
        end
    end
    return ''
end
function GetDiscord(id)
    for _,v in ipairs(GetPlayerIdentifiers(id)) do
        if string.match(v, 'discord:') then
            return string.gsub(v, 'discord:', '')
        end
    end
    return false
end
