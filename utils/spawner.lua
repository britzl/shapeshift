--- This module can be used to simplify the spawning of random things at a
-- regular or semi-regular interval

local M = {}

local spawners = {}

--- Add a spawner that will be invoked at a regular interval (with optional randomness).
-- When the spawner is invoked it will pick a random choice among the provided choices and
-- pass that choice to a callback function 
-- @param choices A list of things to randomly chose between
-- @param interval The interval in seconds between calls to the callback function
-- @param variation The random variation that will be applied to the interval (next = interval + math.random(0, interval * variation))
-- @param next Initial value for when the spawner will be triggered the first time
-- @param fn The function to call when the spawner is triggered
function M.add(choices, interval, variation, next, fn)
	table.insert(spawners, { choices = choices, fn = fn, interval = interval, variation = variation, next = next })
end

function M.clear()
	spawners = {}
end

--- Update the spawners and invoke any callbacks that should be triggered
-- @param dt
function M.update(dt)
	for _,spawner in pairs(spawners) do
		spawner.next = spawner.next - dt
		if spawner.next <= 0 then
			spawner.next = spawner.interval + math.random(0, math.floor(spawner.interval * spawner.variation))
			spawner.fn(spawner.choices[math.random(1, #spawner.choices)])
		end
	end
end


return M