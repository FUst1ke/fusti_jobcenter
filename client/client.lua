local menuOptions = {}
local pedModel = `a_f_y_business_01`
local position = vec3(-265.1539, -964.1055, 31.2233)

local function setupPoint()
    lib.requestModel(pedModel)
    ped = CreatePed(0, pedModel, position.x, position.y, position.z - 1, 206.0, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    local options = {
        {
            name = 'openMenu',
            icon = 'fas fa-briefcase',
            label = 'Open menu',
            onSelect = function()
                lib.showContext('jobcenter')
            end
        }
    }
    exports.ox_target:addModel(pedModel, options)
end

local function setupBlip()
    local blip = AddBlipForCoord(position)
    SetBlipSprite(blip, 419)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Job center')
    EndTextCommandSetBlipName(blip)
end

lib.callback('fusti_joblisting:getJobs', source, function(avaibleJobs)
    setupBlip()
    for i = 1, #avaibleJobs do
        local v = avaibleJobs[i]
        table.insert(menuOptions, {title = v.jLabel, description = 'Grade: '..v.gLabel..' | Salary: '..v.salary..'$', icon = 'briefcase', 
        onSelect = function() 
            TriggerServerEvent('fusti_joblisting:setPlayerJob', v.name, v.grade)
            lib.notify({title = 'Information', description = 'Thanks for choosing us!', type = 'success'})
        end})
    end
    lib.registerContext({
        id = 'jobcenter',
        title = 'Browse jobs',
        options = menuOptions
    })
end)

local point = lib.points.new(position, 15, {})

function point:onEnter()
    setupPoint()
end

function point:onExit()
    DeleteEntity(ped)
    exports.ox_target:removeModel(pedModel, options)
end
