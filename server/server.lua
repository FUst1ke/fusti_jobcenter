ESX = exports['es_extended']:getSharedObject()

local avaibleJobs = {}

exports.oxmysql:query('SELECT jobs.name, job_grades.label AS gLabel, jobs.label AS jLabel, jobs.whitelisted, IFNULL(job_grades.grade, 0) AS grade, IFNULL(job_grades.salary, 0) AS salary FROM jobs LEFT JOIN job_grades ON jobs.name=job_grades.job_name WHERE jobs.whitelisted = 0 AND job_grades.grade = 0', {}, function(result)
    if result then
        for i = 1, #result do
            local row = result[i]
            local template = {
                name = row.name,
                grade = row.grade,
                jLabel = row.jLabel,
                gLabel = row.gLabel,
                salary = row.salary
            }
            table.insert(avaibleJobs, template)
        end
    end
end)

function IsJobAvailable(job)
    local jobs = ESX.GetJobs()
    local JobToCheck = jobs[job]
    return not JobToCheck.whitelisted
end

lib.callback.register('fusti_joblisting:getJobs', function(source)
    return avaibleJobs
end)

RegisterNetEvent('fusti_joblisting:setPlayerJob')
AddEventHandler('fusti_joblisting:setPlayerJob', function(job, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsJobAvailable(job) then
        xPlayer.kick("Don't try to cheat!")
    end
    xPlayer.setJob(job, grade)
end)
