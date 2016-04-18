local M = {}

function M.fall_down(callback)
	local duration = 0.3
	local rotation = 100
	
	--go.cancel_animations("#sprite", "tint")
	--go.animate("#sprite", "tint", go.PLAYBACK_ONCE_FORWARD, vmath.vector4(0, 0, 0, 0.5), go.EASING_INBACK, duration)

	go.cancel_animations(".", "euler.z")
	go.animate(".", "euler.z", go.PLAYBACK_ONCE_FORWARD, math.random(1,2) == 1 and rotation or -rotation, go.EASING_OUTQUART, duration * 3)
	
	go.cancel_animations(".", "scale")
	go.animate(".", "scale", go.PLAYBACK_ONCE_FORWARD, 0, go.EASING_OUTCUBIC, duration * 1.5, 0, callback)

	local pos = go.get_position()
	go.animate(".", "position.y", go.PLAYBACK_ONCE_FORWARD, pos.y + 500 / 2 * 0.3, go.EASING_OUTCUBIC, duration)
end


function M.bounce(id, height, duration)
	assert(id)
	assert(height)
	assert(duration)
	local pos = go.get_position(id)
	pos.y = 0
	go.set_position(pos, id)
	go.cancel_animations(id, "position.y")
	go.animate(id, "position.y", go.PLAYBACK_LOOP_PINGPONG, pos.y + height, go.EASING_OUTQUAD, duration)
end

return M