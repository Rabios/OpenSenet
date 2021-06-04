#############################################################################
#                              UTILITIES                                     
#############################################################################
# Detects collision between 2 rectangles...
def AABB(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2
end

# e: Array
# i: The order of piece from pieces array to get pieces with order different than it...
# returns array contains pieces from array e with order different than i
def other_pieces(e, i)
  _ = []
  e.each do |p|
    if !(p[:order] == i)
      _.push(p)
    end
  end
  return _
end

def is_mobile
  return ($gtk.platform == "iOS" || $gtk.platform == "Android")
end

def touch_down(args)
  return (args.state.touched == 1)
end

def touch_press(args)
  return (args.state.touched == 1 && (args.state.touched != args.state.touched_previously))
end

# Checks if mouse pointer is on rectangle ;)
def mouse_on_rect(args, x, y, w, h)
  if !is_mobile
    return AABB(args.inputs.mouse.x, args.inputs.mouse.y, 1, 1, x, y, w, h)
  else
    if !args.inputs.finger_one.nil?
      return AABB(args.inputs.finger_one.x, args.inputs.finger_one.y, 1, 1, x, y, w, h)
    end
  end
end

# Here where values resetted in case turn passed to next player...
def pass_turn args
  args.state.current_sticks = 0
  args.state.turn = args.state.turn == 0 ? 1 : 0
  args.state.rolls = 0
  args.state.points.clear()
  args.state.pieces_moved = 0
  args.state.extra_turn = false
  args.state.moved = false
  args.state.finished = false
  args.state.rolled = false
  args.state.selected = 0
  args.state.steps = [0]
  args.state.sticks = [0, 0, 0, 0]
end

# This to check turn finisb
def check_turn_finish args
  # If not extra turn and available rolls, Pass turn directly
  # If mistaked, Press space key to pass it manually (But automatical pass works fine for now...)
  if ((args.state.pieces_moved == args.state.rolls && args.state.rolls >= 1 && !args.state.extra_turn) || args.inputs.keyboard.key_up.space || ((args.inputs.mouse.button_left || touch_press(args)) && mouse_on_rect(args, 1152, args.state.board.y + 104, 96, 96)))
    args.state.finished = true
  end
  
  # If turn finish and before passing turn to next player
  # Reset some values
  if args.state.finished
    pass_turn args
  end
end

# We check winner via looking of pieces available of board
# Player who gets it's pieces out of board wins! (Due to Senet rules)
def check_winner args
  player1_pieces_out_of_board = 0
  player2_pieces_out_of_board = 0
  
  # Loop to check if all pieces of Player 1 out of board
  # In this case, Winner is set to 1 (Player 1)
  args.state.player.pieces.each do |p|
    if !p[:onboard]
      player1_pieces_out_of_board += 1
    end
  end
  
  if player1_pieces_out_of_board == args.state.player.pieces.length()
    args.state.winner = 1
  end
  
  # Loop to check if all pieces of Player 2 out of board
  # In this case, Winner is set to 2 (Player 2)
  args.state.enemy.pieces.each do |p|
    if !p[:onboard]
      player2_pieces_out_of_board += 1
    end
  end
  
  if player2_pieces_out_of_board == args.state.enemy.pieces.length()
    args.state.winner = 2
  end
  
  if (args.state.winner > 0)
    args.state.scene = 2
  end
end
