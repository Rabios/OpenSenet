#############################################################################
#                             STICKS LOGIC                                   
#############################################################################
def roll_sticks args
  # If left mouse button pressed
  if args.inputs.mouse.button_left || touch_press(args)
    #$gtk.log "INFO: DOING AABB CHECK..."
    if args.state.rolls == args.state.pieces_moved
      if mouse_on_rect(args, args.state.board.x, args.state.board.y - 150, 90, 120)
        #$gtk.log "ROLLING DICE..."
        # Reset sticks info and increase rolls
        roll args
        args.state.rolls += 1
    
        # If not rolled and not extra turn (First roll), Roll...
        if !(args.state.extra_turn && args.state.rolls == 0)
          args.state.current_sticks = args.state.rolls - 1
          roll args
          args.state.rolled = true
        end
      end
    end
  end
  args.state.rolled = true
end

def roll args
  args.outputs.sounds << args.state.roll_sound
  args.state.steps = [0]
  args.state.sticks = [0, 0, 0, 0]
  
  4.times.map do |s|
    args.state.sticks[s] = rand(2)
    args.state.steps[args.state.current_sticks] += args.state.sticks[s]
  end
  
  if args.state.steps[args.state.current_sticks] == 0
    args.state.steps[args.state.current_sticks] = 5
  end
end

def roll_check args
  # If rolled 2 or 3, No extra turn
  # Else, Roll again and move
  if args.state.steps[args.state.current_sticks] == 2 || args.state.steps[args.state.current_sticks] == 3
    args.state.extra_turn = false
    args.state.moved = false
    args.state.finished = true
  else
    args.state.extra_turn = true
    args.state.moved = false
    args.state.rolls += 1
    
    # Change sticks
    args.state.current_sticks = args.state.rolls - 1
    roll args
    
    # Set that player rolled
    args.state.rolled = true
  end
end

def draw_sticks args
  4.times.map do |s|
    args.outputs.primitives << {
      x: args.state.board.x + (s * 30),
      y: args.state.board.y - 150,
      w: 20,
      h: 120,
      path: args.state.sticks[s] == 0 ? "sprites/square-red.png" : "sprites/square-indigo.png"
    }.sprite
  end
end
