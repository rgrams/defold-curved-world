
local M = {}

local SET_WORLD_CURVE = hash("set_world_curve")
local SET_CAMERA_POS = hash("set_camera_pos")

local cam_pos = vmath.vector4()
local cam_pos_msg = { camera_pos = cam_pos }
local curve = vmath.vector4()

function M.get_cam_pos()
	local cp = cam_pos
	return cp.x, cp.y, cp.z
end

function M.set_cam_pos(x, y, z)
	local cp = cam_pos
	cp.x, cp.y, cp.z = x, y, z
	msg.post("@render:", "set_camera_pos", cam_pos_msg)
end
local set_cam_pos = M.set_cam_pos

function M.update_cam_pos(obj_url)
	local pos = go.get_position(obj_url)
	set_cam_pos(pos.x, pos.y, pos.z)
end

function M.render_init(self)
	self.constants = render.constant_buffer()
end

function M.get_draw_options(self)
	local win_width = render.get_window_width()
	local win_height = render.get_window_height()
	local frust_proj = vmath.matrix4_perspective(math.rad(135), win_width/win_height, 0.1, 1000)
	local frustum = frust_proj * self.view
	return { frustum = frustum, constants = self.constants }
end

function M.render_on_message(self, message_id, message)
	if message_id == SET_WORLD_CURVE then
		self.constants.curve = message.curve
	elseif message_id == SET_CAMERA_POS then
		self.constants.camera_pos = message.camera_pos
	end
end

return M
