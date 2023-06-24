
local M = {}

local persp_proj, ortho_proj = vmath.matrix4_perspective, vmath.matrix4_orthographic

local origin = vmath.vector4()
local curve = vmath.vector4()
local constants -- Buffer - needs to be initialized with render.constant_buffer()
local culling_frustum
local culling_proj
local culling_is_enabled = true

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
local get_curve_offset = M.get_curve_offset

function M.get_cull_extents(hw, hh, far)
	local max_dist = math.sqrt(hw*hw + hh*hh + far*far)
	local max_dx, max_dy = get_curve_offset(max_dist, max_dist)
	local new_hw, new_hh = hw + math.abs(max_dx), hh + math.abs(max_dy)
	return new_hw, new_hh
end
local get_cull_extents = M.get_cull_extents

local MAX_FOV = math.pi - 0.00000001

function M.get_cull_fov(fov, aspect, far)
	local hh = math.tan(fov/2) * far
	local hw = hh * aspect -- aspect = w/h
	local new_hw, new_hh = get_cull_extents(hw, hh, far)
	new_hh = math.max(new_hh, new_hw/aspect)
	local new_fov = math.min(math.atan(new_hh/far) * 2, MAX_FOV)
	return new_fov
end
local get_cull_fov = M.get_cull_fov

function M.get_persp_cull_proj(fov, aspect, near, far)
	fov = get_cull_fov(fov, aspect, far)
	return persp_proj(fov, aspect, near, far)
end

function M.get_ortho_cull_proj(hw, hh, near, far)
	hw, hh = get_cull_extents(hw, hh, far)
	return ortho_proj(-hw, hw, -hh, hh, near, far)
end

function M.render_init(self)
	constants = render.constant_buffer()
	constants.curve = curve
	constants.curve_origin = origin
end

function M.set_cull_frustum(frustum)
	culling_frustum = frustum
end

function M.set_cull_proj(proj)
	culling_proj = proj
end

function M.set_culling_enabled(enabled)
	culling_is_enabled = enabled
end

function M.get_culling_enabled()
	return culling_is_enabled
end

function M.get_draw_options(self, render_proj)
	local opts = { constants = constants }
	if culling_is_enabled then
		local frustum = culling_frustum or (culling_proj or render_proj) * self.view
		opts.frustum = frustum
	end
	return opts
end

return M
