#############################################################################
#                           GAME FINISH SCENE                                
#############################################################################
def finish args
  args.outputs.primitives << {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    path: "sprites/game_background.jpg"
  }.sprite
  
  if args.state.winner == 1
    args.outputs.primitives << {
      x: 220,
      y: 500,
      text: "PLAYER 1 WINS!!!",
      size_enum: 48,
      r: 0,
      g: 0,
      b: 255,
      a: 255
    }.label
  
  elsif args.state.winner == 2
    args.outputs.primitives << {
      x: 220,
      y: 500,
      text: "PLAYER 2 WINS!!!",
      size_enum: 48,
      r: 255,
      g: 0,
      b: 0,
      a: 255
    }.label
  end
  
  if args.state.tick_count % 60 == 0
    rc = rand(255) + 1
    gc = rand(255) + 1
    bc = rand(255) + 1
  end
  
  args.outputs.primitives << {
    x: 230,
    y: 200,
    text: "Tap or press SPACE key to restart game!",
    size_enum: 12,
    r: rc,
    g: gc,
    b: bc,
    a: 255
  }.label
  
  if args.inputs.keyboard.key_up.space || touch_press(args) || (args.inputs.mouse.button_left && args.inputs.mouse.click)
    $gtk.reset seed: (Time.now.to_f * 100).to_i
  end
end
