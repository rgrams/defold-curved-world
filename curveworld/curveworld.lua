
local M = {}

local origin = vmath.vector4()
local curve = vmath.vector4()
local constants -- Buffer - needs to be initialized with render.constant_buffer()

function M.get_origin()
	local cp = origin
	return cp.x, cp.y, cp.z
end

function M.set_origin(x, y, z)
	local cp = origin
	cp.x, cp.y, cp.z = x, y, z
	constants.curve_origin = origin
end
local set_origin = M.set_origin

function M.update_origin(obj_url)
	local pos = go.get_position(obj_url)
	set_origin(pos.x, pos.y, pos.z)
end

function M.get_curve()
	return curve.z, curve.x, curve.w -- z, x, horiz
end

function M.set_curve(z, x, horiz)
	if z then  curve.z = z  end
	if x then  curve.x = x  end
	if horiz then  curve.w = horiz  end
	constants.curve = curve
end

function M.change_curve(z, x, horiz)
	if z then  curve.z = curve.z + z  end
	if x then  curve.x = curve.x + x  end
	if horiz then  curve.w = curve.w + horiz  end
	constants.curve = curve
end

function M.render_init(self)
	constants = render.constant_buffer()
	constants.curve = curve
	constants.curve_origin = origin
end

function M.get_draw_options(self)
	local win_width = render.get_window_width()
	local win_height = render.get_window_height()
	local frust_proj = vmath.matrix4_perspective(math.rad(135), win_width/win_height, 0.1, 1000)
	local frustum = frust_proj * self.view
	return { frustum = frustum, constants = constants }
end

return M
