#############################################################################
#                             CREDITS SCENE                                  
#############################################################################
def credits args
  args.outputs.primitives << {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    r: 0,
    g: 0,
    b: 0,
    a: 255
  }.solid
  
  args.outputs.primitives << {
    x: 470,
    y: 690,
    text: "CREDITS",
    size_enum: 36,
    r: 255,
    g: 255,
    b: 255,
    a: 255
  }.label
  
  args.outputs.primitives << {
    x: 20,
    y: 600,
    x2: 1260,
    y2: 600,
    r: 255,
    g: 255,
    b: 255,
    a: 255
  }.line
  
  args.outputs.primitives << {
    x: 600,
    y: 580,
    x2: 600,
    y2: 0,
    r: 255,
    g: 255,
    b: 255,
    a: 255
  }.line
  
  args.outputs.primitives << {
    x: 170,
    y: 580,
    text: "DEVELOPED BY",
    size_enum: 12,
    r: 255,
    g: 255,
    b: 255,
    a: 255
  }.label
  
  args.outputs.primitives << {
    x: 200,
    y: 520,
    text: "Rabia Alhaffar",
    size_enum: 4,
    r: 0,
    g: 0,
    b: 255,
    a: 255
  }.label
  
  args.outputs.primitives << {
    x: 200,
    y: 440,
    text: "MADE WITH",
    size_enum: 12,
    r: 255,
    g: 255,
    b: 255,
    a: 255
  }.label
  
  args.outputs.primitives << {
    x: 230,
    y: 270,
    w: 128,
    h: 128,
    path: "sprites/icon.png"
  }.sprite
  
  args.outputs.primitives << {
    x: 180,
    y: 230,
    text: "SOURCE CODE",
    size_enum: 12,
    r: 255,
    g: 255,
    b: 255,
    a: 255
  }.label
  
  args.outputs.primitives << {
    x: 90,
    y: 170,
    text: "https://github.com/Rabios/OpenSenet",
    size_enum: 2,
    r: 255,
    g: 0,
    b: 255,
    a: 255
  }.label
  
  if args.state.label4_hovered
    args.outputs.primitives << {
      x: 10,
      y: 40,
      text: "<< BACK",
      size_enum: 6,
      r: 255,
      g: 255,
      b: 0,
      a: 255
    }.label
  else
    args.outputs.primitives << {
      x: 10,
      y: 40,
      text: "<< BACK",
      size_enum: 6,
      r: 255,
      g: 255,
      b: 255,
      a: 255
    }.label
  end

  args.outputs.primitives << {
    x: 610,
    y: 570,
    text: "THANKS FOR EVERYONE IN DRAGONRUBY DISCORD SERVER!",
    size_enum: 4,
    r: 0,
    g: 0,
    b: 255,
    a: 255
  }.label
  
  args.outputs.primitives << {
    x: 820,
    y: 510,
    text: "INCLUDING",
    size_enum: 12,
    r: 255,
    g: 0,
    b: 255,
    a: 255
  }.label
  
  10.times.map do |name|
    args.outputs.primitives << {
      x: 820,
      y: 420 - (name * 38),
      text: args.state.thanks[name],
      size_enum: 1,
      r: args.state.reds[name],
      g: args.state.greens[name],
      b: args.state.blues[name],
      a: 255
    }.label
  end
  
  if args.state.tick_count % 30 == 0
    args.state.reds   = [ rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1 ]
    args.state.greens = [ rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1 ]
    args.state.blues  = [ rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1 ]
  end
  
  if mouse_on_rect(args, 10, 20, 100, 22)
    args.state.label4_hovered = true
    
    if args.inputs.mouse.button_left || touch_press(args)
      args.outputs.sounds << args.state.select_sound
      args.state.animation = 0
      args.state.scene = 0
    end
  else
    args.state.label4_hovered = false
  end
end
