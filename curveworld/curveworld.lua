
local M = {}

local origin = vmath.vector4()
local curve = vmath.vector4()
local constants -- Buffer - needs to be initialized with render.constant_buffer()
local culling_frustum

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

-- Calculate the curved vertex offset for a given delta-pos from the origin point.
function M.get_curve_offset(dx, dz)
	local kx, kz = dx*dx, dz*dz
	local ox = -kz*curve.w
	local oy = -kz*curve.z - kx*curve.x
	return ox, oy
end

local MAX_FOV = math.pi - 0.00000001

function M.get_cull_fov(fov, aspect, far)
	local hh = math.tan(fov/2) * far
	local hw = hh * aspect -- aspect = w/h
	local max_dist = math.sqrt(hw*hw + hh*hh + far*far)
	local max_dx, max_dy = M.get_curve_offset(max_dist, max_dist)
	local new_hw, new_hh = hw + math.abs(max_dx), hh + math.abs(max_dy)
	new_hh = math.max(new_hh, new_hw/aspect)
	local new_fov = math.min(math.atan(new_hh/far) * 2, MAX_FOV)
	return new_fov
end

function M.render_init(self)
	constants = render.constant_buffer()
	constants.curve = curve
	constants.curve_origin = origin
end

function M.set_cull_frustum(frustum)
	culling_frustum = frustum
end

function M.calc_cull_frustum(self)
	local win_width = render.get_window_width()
	local win_height = render.get_window_height()
	return vmath.matrix4_perspective(math.rad(135), win_width/win_height, 0.1, 1000) * self.view
end

function M.get_draw_options(self)
	local frustum = culling_frustum or M.calc_cull_frustum(self)
	return { frustum = frustum, constants = constants }
end

return M
