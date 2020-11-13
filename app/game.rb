#############################################################################
#                             GAMEPLAY SCENE                               
#############################################################################
def game args
  if args.inputs.keyboard.key_up.p
    args.state.scene = 4
  end
  
  #$gtk.log "INFO: RENDERING BACKGROUND..."
  args.outputs.primitives << {
    x: 0,
	y: 0,
	w: 1280,
	h: 720,
	path: "sprites/game_background.jpg"
  }.sprite
  
  # Draw
  draw_turn_texts args
  draw_board args
  draw_sticks args
  
  if args.state.selected == 1 && args.state.tiles[args.state.piece[:tile]]
    args.outputs.primitives << {
      x: args.state.board.x + args.state.tiles[args.state.piece[:tile]][:x],
      y: args.state.board.y + args.state.tiles[args.state.piece[:tile]][:y],
      w: 100,
      h: 100,
	  r: 255,
	  g: 0,
	  b: 255,
	  a: 255
    }.solid
  end
	  
  draw_player_pieces args
  draw_enemy_pieces args
  
  #$gtk.log "INFO: RENDERING DICE..."
  
  # Draw points allowed for piece to move on!
  piece_clicked args
  #$gtk.log args.state.piece
  #$gtk.log "INFO: CLICKED ON PIECE..."
  #$gtk.log "INFO: RENDERING POSSIBLE MOVES..."
  	
  tiles_points_controls args
  roll_sticks args
  
  # We always check for winner even if turn not passed
  check_winner args
  
  #$gtk.log "INFO: DICE ROLLED!"
  check_turn_finish args
  
  args.outputs.primitives << {
    x: 1152,
	y: args.state.board.y,
	w: 96,
	h: 96,
	path: mouse_on_rect(args, 1152, args.state.board.y, 96, 96) ? "sprites/pause_hovered.png" : "sprites/pause_unhovered.png"
  }.sprite
  
  if (mouse_on_rect(args, 1152, args.state.board.y, 96, 96) && args.inputs.mouse.button_left)
    args.outputs.sounds << args.state.click_sound
    args.state.scene = 4
  end
  
  args.outputs.primitives << {
    x: 1152,
	y: args.state.board.y + 104,
	w: 96,
	h: 96,
	path: args.state.turn == 0 ? "sprites/pass_player.png" : "sprites/pass_enemy.png"
  }.sprite
  
  draw_info args
end

# Draw current player text...
# Current player text has more alpha than other one...
# We make sure that the text of other player not hidden...
def draw_turn_texts args
  #$gtk.log "INFO: RENDERING TURNS TEXTS..."
  args.outputs.primitives << {
    x: args.state.board.x,
	y: args.state.board.y + 450,
	text: "PLAYER 1",
	size_enum: 22,
	r: 0,
	g: 0,
	b: 255,
	a: args.state.turn == 0 ? 255 : args.state.ualpha
  }.label

  args.outputs.primitives << {
	x: args.state.board.x + 770,
	y: args.state.board.y + 450,
	text: "PLAYER 2",
	size_enum: 22,
	r: 255,
	g: 0,
	b: 0,
	a: args.state.turn == 1 ? 255 : args.state.ualpha
  }.label
end

# Draw board
# First, Draw grid via loop then draw board image...
def draw_board args
  #$gtk.log "INFO: RENDERING BOARD IMAGE.."
  args.outputs.primitives << {
    x: args.state.board.x,
	y: args.state.board.y,
	w: 1000,
	h: 300,
	path: "sprites/board.jpg"
  }.sprite
  
  #$gtk.log "INFO: RENDERING BOARD GRID..."
  10.times.map do |r|
    3.times.map do |c|
	  args.outputs.primitives << {
	    x: args.state.board.x + (100 * r),
		y: args.state.board.y + (100 * c),
		w: 100,
		h: 100,
		r: 0,
		g: 0,
		b: 0,
		a: 255
	  }.border
	end
  end
end

# This draws curren tplayer info...
def draw_info args
  args.outputs.primitives << {
    x: args.state.board.x + 500,
	y: args.state.board.y - 20,
	text: "EXTRA TURN AVAILABLE: " + (args.state.extra_turn ? "YES" : "NO"),
	size_enum: 12,
	r: 0,
	g: 255,
	b: 0,
	a: 255
  }.label
  
  args.outputs.primitives << {
    x: args.state.board.x + 500,
	y: args.state.board.y - 60,
	text: "ROLLED: #{args.state.steps[args.state.current_sticks] != 0 ? args.state.steps[args.state.current_sticks] : 'NOT ROLLED!'}",
	size_enum: 12,
	r: 0,
	g: 255,
	b: 0,
	a: 255
  }.label
  
  args.outputs.primitives << {
    x: args.state.board.x + 500,
	y: args.state.board.y - 100,
	text: "ROLLS: #{args.state.rolls}",
	size_enum: 12,
	r: 0,
	g: 255,
	b: 0,
	a: 255
  }.label
  
  pieces_available = 0
  if args.state.turn == 0
    args.state.player.pieces.each do |p|
	  if p[:onboard]
	    pieces_available += 1
	  end
	end
  elsif args.state.turn == 1
    args.state.enemy.pieces.each do |p|
	  if p[:onboard]
	    pieces_available += 1
	  end
	end
  end
  
  args.outputs.primitives << {
    x: args.state.board.x + 500,
	y: args.state.board.y - 140,
	text: "AVAILABLE PIECES: #{pieces_available}",
	size_enum: 12,
	r: 0,
	g: 255,
	b: 0,
	a: 255
  }.label
end