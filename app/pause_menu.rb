#############################################################################
#                            PAUSE MENU SCENE                                
#############################################################################
def pause_menu args
  args.outputs.primitives << {
    x: 0,
	y: 0,
	w: 1280,
	h: 720
  }.solid
  
  args.outputs.primitives << {
    x: 400,
	y: 700,
	text: "GAME PAUSED",
	size_enum: 36,
	r: 255,
	g: 255,
	b: 255,
	a: 255
  }.label
  
  args.outputs.primitives << {
    x: 20,
	y: 610,
	x2: 1260,
	y2: 610,
	r: 255,
	g: 255,
	b: 255,
	a: 255
  }.line
  
  if args.state.label5_hovered
    args.outputs.primitives << {
      x: 540,
	  y: 500,
	  text: "RESUME",
	  size_enum: 20,
	  r: 255,
	  g: 255,
	  b: 0,
	  a: 255
    }.label
  elsif !args.state.label5_hovered
    args.outputs.primitives << {
      x: 540,
	  y: 500,
	  text: "RESUME",
	  size_enum: 20,
	  r: 255,
	  g: 255,
	  b: 255,
	  a: 255
    }.label
  end
  
  if args.state.label6_hovered
    args.outputs.primitives << {
      x: 500,
	  y: 350,
	  text: "MAIN MENU",
	  size_enum: 20,
	  r: 255,
	  g: 255,
	  b: 0,
	  a: 255
    }.label
  elsif !args.state.label6_hovered
    args.outputs.primitives << {
      x: 500,
	  y: 350,
	  text: "MAIN MENU",
	  size_enum: 20,
	  r: 255,
	  g: 255,
	  b: 255,
	  a: 255
    }.label
  end
  
  if args.state.label7_hovered
    args.outputs.primitives << {
      x: 500,
	  y: 200,
	  text: "EXIT GAME",
	  size_enum: 20,
	  r: 255,
	  g: 255,
	  b: 0,
	  a: 255
    }.label
  elsif !args.state.label7_hovered
    args.outputs.primitives << {
      x: 500,
	  y: 200,
	  text: "EXIT GAME",
	  size_enum: 20,
	  r: 255,
	  g: 255,
	  b: 255,
	  a: 255
    }.label
  end
  
  if mouse_on_rect(args, 542, 445, 160, 50)
    args.state.label5_hovered = true
	if args.inputs.mouse.button_left
	  args.outputs.sounds << args.state.select_sound
	  args.state.scene = 1
	end
  else
    args.state.label5_hovered = false
  end
  
  if mouse_on_rect(args, 500, 300, 245, 42)
    args.state.label6_hovered = true
    if args.inputs.mouse.button_left
	  args.outputs.sounds << args.state.select_sound
	  $gtk.reset seed: (Time.now.to_f * 100).to_i
	end
  else
    args.state.label6_hovered = false
  end
  
  if mouse_on_rect(args, 500, 153, 245, 42)
    args.state.label7_hovered = true
    if args.inputs.mouse.button_left
	  args.outputs.sounds << args.state.select_sound
	  $gtk.exit
	end
  else
    args.state.label7_hovered = false
  end
  
  if args.inputs.keyboard.key_up.p
    args.state.scene = 1
  end
end