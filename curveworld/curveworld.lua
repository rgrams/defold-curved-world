
local M = {}

local cam_pos = vmath.vector4()
local curve = vmath.vector4()
local constants -- Buffer - needs to be initialized with render.constant_buffer()

function M.get_cam_pos()
	local cp = cam_pos
	return cp.x, cp.y, cp.z
end

function M.set_cam_pos(x, y, z)
	local cp = cam_pos
	cp.x, cp.y, cp.z = x, y, z
	constants.camera_pos = cam_pos
end
local set_cam_pos = M.set_cam_pos

function M.update_cam_pos(obj_url)
	local pos = go.get_position(obj_url)
	set_cam_pos(pos.x, pos.y, pos.z)
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
	constants.camera_pos = cam_pos
end

function M.get_draw_options(self)
	local win_width = render.get_window_width()
	local win_height = render.get_window_height()
	local frust_proj = vmath.matrix4_perspective(math.rad(135), win_width/win_height, 0.1, 1000)
	local frustum = frust_proj * self.view
	return { frustum = frustum, constants = constants }
end

return M
