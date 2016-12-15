--- Module to simplify the handling of collision response messages

local url = require "utils.url"

local M = {}

local COLLISION_RESPONSE = hash("collision_response")

local collisions = {}


--- Register a collision callback to be invoked when the script calling this
-- function receives a collision response with a specific group
-- @param group The group to register collision callback for
-- @param fn Function to call when a collision occurs
function M.register(group, fn)
	assert(group, "You must provide a group")
	assert(fn, "you must provide a function")
	group = type(group) == "userdata" and group or hash(group)
	 
	local url_as_string = url.tostring(msg.url())
	collisions[url_as_string] = collisions[url_as_string] or {}
	table.insert(collisions[url_as_string], { group = group, fn = fn })
end

--- Unregister all collision groups or a single collision group previously
-- registered with @{register}
-- @param group The group to unregister collision callback for or nil for all
function M.unregister(group)
	local url_as_string = url.tostring(msg.url())
	if not collisions[url_as_string] then
		return
	end
	
	if group then
		group = type(group) == "hash" and group or hash(group)
		for k,collision in pairs(collisions[url_as_string]) do
			if collision.group == group then
				collisions[url_as_string][k] = nil
			end
		end
	else
		collisions[url_as_string] = nil
	end
end

function M.on_message(message_id, message, sender)
	if message_id ~= COLLISION_RESPONSE then
		return
	end
	
	local url_as_string = url.tostring(msg.url())
	if not collisions[url_as_string] then
		return
	end

	for k,collision in pairs(collisions[url_as_string]) do
		if collision.group == message.group then
			collision.fn(message, sender)
		end
	end
end

return M