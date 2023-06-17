
# Curved World

> :warning: A work in progress.

A simple demo of a curved 3D world effect similar to Animal Crossing.

## Demo Controls

- Click on window to capture cursor and activate mouse look control.
- Press escape to release cursor capture.
- WASD or arrow keys to move character.
- Mouse wheel to zoom in and out.
- Page Up and Page Down to adjust curvature on the Z axis.
- Home and End to adjust curvature on the X axis.

## Module API

Require the module to use it:

```lua
local curveworld = require "curveworld.curveworld"
```

### curveworld.get_origin()

Get the center position of the curving effect (usually your camera position) in world-space. Returns x, y, and z.

### curveworld.set_origin(x, y, z)

Set the world-space center position for the curving effect.

### curveworld.update_origin(obj_url)

Sets the center position using an object's local position.

### curveworld.get_curve()

Get the current curve parameters. Returns z, x, and horizontal-shear.

### curveworld.set_curve(z, x, horiz)

Set the strength of the curve effect. `z` is the curve along the Z axis, `x` is the curve along the X axis, and `horiz` is the horizontal shearing effect. Each parameter is only set if it is specified, so you may pass in `nil` or `false` for any parameter to keep its current value.

### curveworld.change_curve(z, x, horiz)

Add values to the current curve strength settings. Like with `curveworld.set_curve()`, settings are only changed if a corresponding value is specified.

### curveworld.render_init(self)

Sets up a constants buffer to pass information to the shader for all models. Call this function from your render script's init function. `self` should be the same `self` that is provided to the init function.

### curveworld.get_draw_options(self)

Returns a table with a culling frustum and a shader constants buffer, to be passed to [`render.draw()`](https://defold.com/ref/stable/render/#render.draw:predicate-[options]) so that the curve settings and origin position will be used for all models.
