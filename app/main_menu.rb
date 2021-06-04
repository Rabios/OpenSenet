#############################################################################
#                             MAIN MENU SCENE                                
#############################################################################
def menu args
  args.outputs.primitives << {
    x: args.state.recw,
    y: 0,
    w: 1280,
    h: 720,
    r: 0,
    g: 0,
    b: 0,
    a: 255
  }.sprite
  
  # This for moving rectangle used for animation
  if args.state.recw < 1280 && args.state.animation == 0
    args.state.recw += 25
  elsif args.state.animation == 1
    args.state.recw -= 25
    
    if args.state.recw <= 0
      if args.state.goto == -1
        $gtk.exit
      else
        args.state.scene = args.state.goto
      end
    end
  else
    args.state.animation = 2
    args.outputs.primitives << {
      x: 0,
      y: 0,
      w: 1280,
      h: 720,
      path: "sprites/title_background.jpg"
    }.sprite
  
    args.outputs.primitives << {
      x: 380,
      y: 720,
      text: "OpenSenet",
      size_enum: 48,
      r: 0,
      g: 255,
      b: 0,
      a: 255
    }.label
  
    if args.state.label1_hovered
      args.outputs.primitives << {
        x: 50,
        y: 300,
        text: "START GAME",
        size_enum: 14,
        r: 255,
        g: 255,
        b: 0,
        a: 255
      }.label
    elsif !args.state.label1_hovered
      args.outputs.primitives << {
        x: 50,
        y: 300,
        text: "START GAME",
        size_enum: 14,
        r: 255,
        g: 255,
        b: 255,
        a: 255
      }.label
    end
  
    if args.state.label2_hovered
      args.outputs.primitives << {
        x: 50,
        y: 200,
        text: "CREDITS",
        size_enum: 14,
        r: 255,
        g: 255,
        b: 0,
        a: 255
      }.label
    elsif !args.state.label2_hovered
      args.outputs.primitives << {
        x: 50,
        y: 200,
        text: "CREDITS",
        size_enum: 14,
        r: 255,
        g: 255,
        b: 255,
        a: 255
      }.label
    end
  
    if args.state.label3_hovered
      args.outputs.primitives << {
        x: 50,
        y: 100,
        text: "EXIT GAME",
        size_enum: 14,
        r: 255,
        g: 255,
        b: 0,
        a: 255
      }.label
    elsif !args.state.label3_hovered
      args.outputs.primitives << {
        x: 50,
        y: 100,
        text: "EXIT GAME",
        size_enum: 14,
        r: 255,
        g: 255,
        b: 255,
        a: 255
      }.label
    end
    
    if mouse_on_rect(args, 50, 260, 220, 40)
      args.state.label1_hovered = true
      
      if args.inputs.mouse.button_left || touch_press(args)
        args.outputs.sounds << args.state.select_sound
        args.state.animation = 1
        args.state.goto = 1
      end
    else
      args.state.label1_hovered = false
    end
  
    if mouse_on_rect(args, 50, 160, 150, 40)
      args.state.label2_hovered = true
      
      if args.inputs.mouse.button_left || touch_press(args)
        args.outputs.sounds << args.state.select_sound
        args.state.animation = 1
        args.state.goto = 3
      end
    else
      args.state.label2_hovered = false
    end
  
    if mouse_on_rect(args, 50, 60, 196, 40)
      args.state.label3_hovered = true
      
      if args.inputs.mouse.button_left || touch_press(args)
        args.outputs.sounds << args.state.select_sound
        args.state.animation = 1
        args.state.goto = -1
      end
    else
      args.state.label3_hovered = false
    end
  end
end
