LuaCocoa.import("QuartzCore")
LuaCocoa.import("Foundation")
LuaCocoa.import("AVFoundation")

-- Note: If you modify this file while the application is running 
-- (which is in the .app bundle currently), 
-- Leopard FSEvents will notify the application
-- that this file has been changed and I reload the script.
-- You can do any special handling you need to do here.
function OnUnloadBeforeReload()
	print("OnUnloadBeforeReload")
end

function OnLoadFinished(animatable_layer, app_delegate)
	print("OnLoadFinished")

	--[[
		sm.SetLayerBackgroundColor(animatable_layer, 0, 0, .9, .9)
		sm.SetLayerBorderColor(animatable_layer, 0.0, 0.0, 0.0, 1.0)
		sm.SetLayerCornerRadius(animatable_layer, 8.0)
		sm.SetLayerBorderWidth(animatable_layer, 4.0)
		sm.SetLayerPosition(animatable_layer, 200, 150)
		sm.SetLayerSize(animatable_layer, 200, 200)
	--]]
end

function OnAnimationDidStop(animatable_layer, the_animation, reached_natural_end)
	print("OnAnimationDidStop", animatable_layer, the_animation, reached_natural_end)
end

g_IconLayers = {}
g_IconsAreIn = false

function OnAction1(animatable_layer, app_delegate)
	print("OnAction1", animatable_layer)

	local keyframe_animation = CAKeyframeAnimation:animation()
	-- Demonstrating setter dot-notation here.
	-- Also, this is the formal Obj-C/Cocoa way to create an NSArray of structs
	-- See OnAction2 for a short-cut Lua/Cocoa way.
	keyframe_animation.values = 
		NSArray:arrayWithObjects_(
			NSValue:valueWithPoint_(
				NSMakePoint(0,0)
			),
			NSValue:valueWithPoint_(
				NSMakePoint(240, 380)
			),
			NSValue:valueWithPoint_(
				NSMakePoint(300, 200)
			),
			nil
		)
	-- I could write the delegate directly in Lua,
	-- but because I want to support unloading/reloading the entire Lua state,
	-- I need to be careful about dangling objects when Lua gets torn down 
	-- and an animation is still in flight and then finishes firing a 
	-- callback into a dead delegate.
	-- Using Obj-C garbage collection might avoid that messy case since 
	-- Obj-C is supposed to nil out dead references automatically. 
	-- I should try that some time.
	keyframe_animation.delegate = app_delegate
--	keyframe_animation.duration = 4
	
	animatable_layer.position = CGPointMake(300, 200)
	animatable_layer:addAnimation_forKey_(keyframe_animation, "position")


end

function OnAction2(animatable_layer, app_delegate)
	print("OnAction2", animatable_layer)
	local keyframe_animation = CAKeyframeAnimation:animation()
	-- Some shortcuts for LuaCocoa:
	-- Instead of explicitly creating a new NSArray, we can use a Lua table.
	-- Since we aren't using the arrayWithObjects method, we don't need to 
	-- worry about the nil-termination requirement.
	-- Instead of using the function NSMakePoint, LuaCocoa overloads the
	-- struct name to be a constructor function so if you pass it the
	-- paramters to fill the struct, it will fill it.
	-- Instead of boxing the structs in NSValues, we can let LuaCocoa do that.
	-- The way this works is that when we cross the bridge, the table gets
	-- converted/copied into an NSArray automatically via the topropertylist
	-- functions.
	keyframe_animation.values = {
		NSPoint(0,550),
		NSPoint(500, 250),
		NSPoint(200, 200)
	}
	-- I could write the delegate directly in Lua,
	-- but because I want to support unloading/reloading the entire Lua state,
	-- I need to be careful about dangling objects when Lua gets torn down 
	-- and an animation is still in flight and then finishes firing a 
	-- callback into a dead delegate.
	-- Using Obj-C garbage collection might avoid that messy case since 
	-- Obj-C is supposed to nil out dead references automatically. 
	-- I should try that some time.
	keyframe_animation.delegate = app_delegate
	keyframe_animation.duration = 2.5
	animatable_layer.position = CGPoint(200, 200)
	animatable_layer:addAnimation_forKey_(keyframe_animation, "position")
end


function OnAction3(animatable_layer, app_delegate)
	print("OnAction3", animatable_layer)
	local keyframe_animation = CAKeyframeAnimation:animation()
	keyframe_animation.values = {
		0,
		2*math.pi,
		-2 * math.pi,
--		1 * math.pi
		0
	}
	-- I could write the delegate directly in Lua,
	-- but because I want to support unloading/reloading the entire Lua state,
	-- I need to be careful about dangling objects when Lua gets torn down 
	-- and an animation is still in flight and then finishes firing a 
	-- callback into a dead delegate.
	-- Using Obj-C garbage collection might avoid that messy case since 
	-- Obj-C is supposed to nil out dead references automatically. 
	-- I should try that some time.
	keyframe_animation.delegate = app_delegate
	keyframe_animation.duration = 3.0
--	animatable_layer:setValue_forKeyPath_(NSNumber:numberWithFloat_(math.pi), "transform.rotation.z")
	animatable_layer:setValue_forKeyPath_(NSNumber:numberWithFloat_(0), "transform.rotation.z")
	
	animatable_layer:addAnimation_forKey_(keyframe_animation, "transform.rotation.z")

end


function OnAction4(animatable_layer, app_delegate)
	print("OnAction4", animatable_layer)
	local keyframe_animation = CAKeyframeAnimation:animation()
	keyframe_animation.values = {
		1.0,
		0.1,
		1.0
	}
	-- I could write the delegate directly in Lua,
	-- but because I want to support unloading/reloading the entire Lua state,
	-- I need to be careful about dangling objects when Lua gets torn down 
	-- and an animation is still in flight and then finishes firing a 
	-- callback into a dead delegate.
	-- Using Obj-C garbage collection might avoid that messy case since 
	-- Obj-C is supposed to nil out dead references automatically. 
	-- I should try that some time.
	keyframe_animation.delegate = app_delegate
	keyframe_animation.duration = 2.0
	animatable_layer.opacity = 1.0
	animatable_layer:addAnimation_forKey_(keyframe_animation, "opacity")
end

function OnAction5(animatable_layer, app_delegate)
	print("OnAction5", animatable_layer)

	OnAction2(animatable_layer, app_delegate)
	OnAction3(animatable_layer, app_delegate)
	OnAction4(animatable_layer, app_delegate)

end

function OnAction6(animatable_layer, app_delegate)

	if g_IconsAreIn then
		OnCloseFavorites(animatable_layer, app_delegate)
	else
		OnFavorites(animatable_layer, app_delegate)
	end


end

function OnAction7(animatable_layer, app_delegate)

	local layer, player = GetOrCreateMovieLayer()
	animatable_layer:addSublayer_(layer)
--	layer:setFrame_(animatable_layer:frame())
	player:play()

	--[[
	print(layer)
	local the_contents = layer.contents
	print(the_contents)
	for i=1, NUMBER_OF_ICONS do
		g_IconLayers[i]:setContents_(the_contents)
	end
--]]
--	sm.CreateIconLayer = sm.CreateMovieIconLayer
end

-- [=[

if sm == nil then
	sm = {}
	utils = {}
end


---
-- Sets the background color a layer. Numbers are between 0 and 1.
-- @param the_layer The SMLayer you are working with.
-- @param red_or_color Either a number for the red value or a CGColorRef or nil to disable color.
-- @param green The number for green.
-- @param blue The number for blue.
-- @param alpha The number for alpha.
function sm.SetLayerBackgroundColor(the_layer, red_or_color, green, blue, alpha)
	if type(red_or_color) == "userdata" then
		the_layer:setBackgroundColor_(red_or_color)
	elseif red_or_color == nil then
			the_layer:setBackgroundColorToNil()
	else
		local nscolor = NSColor:colorWithCalibratedRed_green_blue_alpha_(red_or_color, green, blue, alpha)
		local cgcolor = nscolor:CGColor()
		the_layer:setBackgroundColor_(cgcolor);
	end
end

---
-- Sets the border color a layer. Numbers are between 0 and 1.
-- @param the_layer The SMLayer you are working with.
-- @param red_or_color Either a number for the red value or a CGColorRef or nil to disable color.
-- @param green The number for green.
-- @param blue The number for blue.
-- @param alpha The number for alpha.
function sm.SetLayerBorderColor(the_layer, red_or_color, green, blue, alpha)
	if type(red_or_color) == "userdata" then
		the_layer:setBorderColor_(red_or_color)
	elseif red_or_color == nil then
		the_layer:setBorderColorToNil()
	else
		local color = NSColor:colorWithCalibratedRed_green_blue_alpha_(red_or_color, green, blue, alpha):CGColor()
		the_layer:setBorderColor_(color);
	end
end

---
-- Sets the cornerRadius for a layer.
-- @param the_layer The SMLayer you are working with.
-- @param corner_radius A number controlling the roundedness of the layer's corners. 0 is off.
function sm.SetLayerCornerRadius(the_layer, corner_radius)
	the_layer:setCornerRadius_(corner_radius)
end
---
-- Sets the borderWidth for a layer.
-- @param the_layer The SMLayer you are working with.
-- @param border_width A number for the thickness of the border around the layer.
function sm.SetLayerBorderWidth(the_layer, border_width)
	the_layer:setBorderWidth_(border_width)
end

---
-- Sets the x anchorPoint of a layer.
-- @param the_layer The layer you want to manipulate.
-- @param the_value A number representing the x anchorPoint.
function sm.SetLayerAnchorPointX(the_layer, the_value)
	the_layer:setXAnchorPoint_(the_value)
end

---
-- Sets the anchorPoint of a layer.
-- @param the_layer The layer you want to manipulate.
-- @param cgpoint_or_x A CGPoint representing the size or a number representing width or a CGPointFromLua compatible table
-- @param y A number representing height if CGPoint was not the first parameter
function sm.SetLayerAnchorPoint(the_layer, x, y)
	local point = CGPointMake(x, y)
	the_layer:setAnchorPoint_(point)
end


function sm.SetLayerPosition(the_layer, the_position_or_x, y, z)
	--[[
	if type(the_position_or_x) == "userdata" then
		the_layer:setPosition_(the_position_or_x)
		local possible_z = z or y
		if possible_z ~= nil then
			the_layer:setZPosition_(possible_z)
		end
	elseif type(the_position_or_x) == "table" then
		the_layer:setPosition_(cg.CGPointFromLua(the_position_or_x))
		local possible_z = the_position_or_x["z"] or the_position_or_x[1]
		if possible_z ~= nil then
			the_layer:setZPosition_(possible_z)
		end
	else
		the_layer:setPosition_(cg.CGPointFromLua(the_position_or_x, y))
		if z ~= nil then
			the_layer:setZPosition_(z)
		end
	end
	--]]
	local point = CGPointMake(the_position_or_x, y)
	the_layer:setPosition_(point)

	
end

---
-- Sets the width and height of a layer.
-- @param the_layer The layer you want to manipulate.
-- @param cgsize_or_width A CGSize representing the size or a number representing width or a CGSizeFromLua compatible table
-- @param height A number representing height if CGSize was not the first parameter
function sm.SetLayerSize(the_layer, cgsize_or_width, height)
	--[[
	if type(cgsize_or_width) == "userdata" then
		the_layer:setSize_(cgsize_or_width)
	elseif type(cgsize_or_width) == "table" then
		the_layer:setSize_(cg.CGSizeFromLua(cgsize_or_width))
	else
		the_layer:setSize_(cg.CGSizeFromLua(cgsize_or_width, height))
	end
	--]]
	local size = CGSizeMake(cgsize_or_width, height)
	local bounds = the_layer:bounds()
	bounds.size = size
	the_layer:setBounds_(bounds)

end

function sm.AddSublayer(parent_layer, sub_layer)
	parent_layer:addSublayer_(sub_layer)
end

---
-- Creates a new layer.
-- This will also add the layer (by name) to the shared object database. (Behavior being debated)
-- @param layer_name The name of the layer you want to give it as an identifier. The name must be unique (for the database)
-- @return Returns an SMLayer object.
function sm.CreateLayer(layer_name)
	local the_layer = CALayer:layer()
	the_layer:setName_(layer_name)
	return the_layer
end

-- Creates a new layer.
-- This will also add the layer (by name) to the shared object database. (Behavior being debated)
-- @param layer_name The name of the layer you want to give it as an identifier. The name must be unique (for the database)
-- @return Returns an SMLayer object.
function sm.CreateMovieIconLayer(layer_name)
--	print("g_Movie", g_Movie)
	local the_layer = AVPlayerLayer:playerLayerWithPlayer_(g_Movie)
	the_layer:setName_(layer_name)
	return the_layer
end
sm.CreateIconLayer = sm.CreateLayer


---
-- Sets the doubleSided property of a layer.
-- @param the_layer The SMLayer you are working with.
-- @param is_double_sided Pass true to make the layer double sided, false for single sided it
function sm.SetLayerDoubleSided(the_layer, is_double_sided)
	the_layer:setDoubleSided_(is_double_sided)
end


--[[
function sm.animationWithPositionX(position_values, key_times, animation_name, use_relative_offsets, start_delay)
	CAKeyframeAnimation keyframe_animation = CAKeyframeAnimation:animationWithKeyPath_("position.x");
	keyframe_animation.values = keyframe_values;
	keyframe_animation.keyTimes = key_times;
	keyframe_animation:setValue_forKey_(animation_name, "UserName");
	keyframe_animation.removedOnCompletion = false;
	keyframe_animation.fillMode = kCAFillModeBoth;

	if(start_delay != 0.0) then
		-- Watch out: This value needs to be added to CACurrentMediaTime() on start.
		-- I am just using this field for storage because I know the other end copies the keyframe_animation anyway.
		keyframe_animation.beginTime = start_delay;
	end

	return keyframe_animation;
end

function sm.CreatePositionXKeyframeAnimation(position_values, key_times, start_delay, animation_name, use_relative_offsets)
	start_delay = start_delay or 0
	animation_name = animation_name or ""
	use_relative_offsets = use_relative_offsets or false
	return objc.class("SMAnimation"):animationWithPositionX_keyTimes_withName_useRelativeOffsets_startDelay_(position_values, key_times, animation_name, use_relative_offsets, start_delay)
end
--]]


sm.CurrentValue = 0;

ENTER_ANIMATION_DURATION = 4
ICON_FALL_OUT_TIME = 2.5
NUMBER_OF_ICONS = 25
ICON_WIDTH = 46
ICON_HEIGHT = ICON_WIDTH
ICON_WIDTH_PADDING = 4
ICON_OFFSET_PADDING = 5
ICON_Y = 100

function OnFavorites(animatable_layer)
--	print("OnFavorites")
	local transform_root_layer = animatable_layer:superlayer()
	
	local view_rect = transform_root_layer:bounds()

	local window_width = view_rect.size.width
	local window_height = view_rect.size.height

	print(window_width, window_height);

	for i=1, NUMBER_OF_ICONS do
		local index_as_string = tostring(i)
		local concat_string = "iconLayer" .. index_as_string
--		print("concat_string=",concat_string)
		local icon_layer = sm.CreateIconLayer(concat_string)


		-- [[
		sm.SetLayerBackgroundColor(icon_layer, math.random(), math.random(), math.random(), 0.7)
		sm.SetLayerBorderColor(icon_layer, 0.0, 0.0, 0.0, 1.0)
		sm.SetLayerCornerRadius(icon_layer, 8.0)
		sm.SetLayerBorderWidth(icon_layer, 4.0)
		sm.SetLayerAnchorPoint(icon_layer, .5, 1)
		sm.SetLayerPosition(icon_layer, window_width + ((i-1) * (ICON_WIDTH + ICON_WIDTH_PADDING)), ICON_Y)
--		icon_layer:setZPosition_(50)
		sm.SetLayerSize(icon_layer, ICON_WIDTH, ICON_WIDTH)

	--	icon_layer:setAutoresizingMask_(2+16)
		-- ]]
	
		sm.AddSublayer(transform_root_layer, icon_layer)

		

		local position_x_animation = CAKeyframeAnimation:animation()
		position_x_animation.values = {
			NSPoint(window_width + ((i-1) * (ICON_WIDTH + ICON_WIDTH_PADDING)),ICON_Y),
			NSPoint(ICON_OFFSET_PADDING + ICON_WIDTH/2 + ((i-1) * (ICON_WIDTH + ICON_WIDTH_PADDING)), ICON_Y)
		}


		position_x_animation.delegate = app_delegate
		position_x_animation.duration = ENTER_ANIMATION_DURATION
		--		icon_layer.position = CGPoint(2222, ICON_Y)
		icon_layer.position = CGPoint(ICON_OFFSET_PADDING + ICON_WIDTH/2 + ((i-1) * (ICON_WIDTH + ICON_WIDTH_PADDING)), ICON_Y-ICON_HEIGHT)

		local timing_function = CAMediaTimingFunction:functionWithName_(kCAMediaTimingFunctionEaseOut)
		position_x_animation:setTimingFunction_(timing_function)

		icon_layer:addAnimation_forKey_(position_x_animation, "position")

		local rotation_z_animation = CAKeyframeAnimation:animation()
		rotation_z_animation.values = {
			0,
			math.pi/6,
			-math.pi/16,
			0
		}
	-- I could write the delegate directly in Lua,
	-- but because I want to support unloading/reloading the entire Lua state,
	-- I need to be careful about dangling objects when Lua gets torn down 
	-- and an animation is still in flight and then finishes firing a 
	-- callback into a dead delegate.
	-- Using Obj-C garbage collection might avoid that messy case since 
	-- Obj-C is supposed to nil out dead references automatically. 
	-- I should try that some time.
	rotation_z_animation.delegate = app_delegate
	rotation_z_animation.duration = ENTER_ANIMATION_DURATION
	icon_layer:setValue_forKeyPath_(NSNumber:numberWithFloat_(math.pi), "transform.rotation.z")
		rotation_z_animation:setTimingFunction_(timing_function)	
	icon_layer:addAnimation_forKey_(rotation_z_animation, "transform.rotation.z")

	g_IconLayers[i] = icon_layer
--		sm.SetAnimationTimingFunction(position_x_animation, sm.kCAMediaTimingFunctionEaseOut)

--		sm.SetAnimationTimingFunction(rotation_z_animation, sm.kCAMediaTimingFunctionEaseOut)

--[====[
		sm.StartAnimations(icon_layer, 
			{
				position_x_animation, 
				rotation_z_animation,
			},
			ENTER_ANIMATION_DURATION
		)
--]====]	
	end
	g_IconsAreIn = true

end
-- [==[
function OnCloseFavorites()
--	print("OnCloseFavorites")
	for i=1, NUMBER_OF_ICONS do


		local icon_layer = g_IconLayers[i]


--		print("icon_layer", icon_layer)
--		print("icon_name", icon_layer:name())
		sm.SetLayerDoubleSided(icon_layer, false)


		local rotation_x_animation = CAKeyframeAnimation:animation()
		rotation_x_animation.values = {
			0,	
			math.pi,
		}
	-- I could write the delegate directly in Lua,
	-- but because I want to support unloading/reloading the entire Lua state,
	-- I need to be careful about dangling objects when Lua gets torn down 
	-- and an animation is still in flight and then finishes firing a 
	-- callback into a dead delegate.
	-- Using Obj-C garbage collection might avoid that messy case since 
	-- Obj-C is supposed to nil out dead references automatically. 
	-- I should try that some time.
		rotation_x_animation.delegate = app_delegate
	rotation_x_animation.duration = ICON_FALL_OUT_TIME
	icon_layer:setValue_forKeyPath_(NSNumber:numberWithFloat_(math.pi), "transform.rotation.x")


		local timing_function = CAMediaTimingFunction:functionWithName_(kCAMediaTimingFunctionEaseIn)
		rotation_x_animation:setTimingFunction_(timing_function)
	icon_layer:addAnimation_forKey_(rotation_x_animation, "transform.rotation.x")
	g_IconsAreIn = false
	g_IconLayers[i] = nil

		
	end
end
--]==]
--]=]

function CreateMovieLayer()
--	local url = NSURL:URLWithString_("http://???need to file a URL that works")
--	local url = NSURL:fileURLWithPath_("/Users/ewing/Desktop/Evolution/LostVikings/TRINE 2_ LAUNCH TRAILER.mp4")
	local url = NSURL:fileURLWithPath_("/Users/ewing/Desktop/Evolution/Pac-Man Championship Edition DX - Score Attack - Championship II.mp4")
	
	local player = AVPlayer:playerWithURL_(url)
	local layer = AVPlayerLayer:playerLayerWithPlayer_(player)
	sm.SetLayerSize(layer, 640, 480)
	sm.SetLayerAnchorPoint(layer, 0, 0)
	return layer, player
end

g_MovieLayer = nil
g_Movie = nil
function GetOrCreateMovieLayer()
	if not g_MovieLayer then
		g_MovieLayer, g_Movie = CreateMovieLayer()
	end
--	print("g_Movie", g_Movie)
	return g_MovieLayer, g_Movie
end


