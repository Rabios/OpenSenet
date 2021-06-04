#############################################################################
#                             PIECES LOGIC                                   
#############################################################################
def pieces_movement args, e
  # See turns
  # To set who pieces we would avoid (Tile empty) and pieces we would exchange places of (Other player pieces...)
  same = args.state.turn == 0 ? 1 : 2
  pp = args.state.turn == 0 ? args.state.enemy.pieces : args.state.player.pieces
  oo = args.state.turn == 0 ? args.state.player.pieces : args.state.enemy.pieces
  
  # If pieces of same player not exist in tile, Move to (Tile empty in that case)
  # If no piece moved and piece movable
  if !args.state.moved
    if args.state.piece[:movable]
      # Case 1: Piece of a player moves on empty tile
      if (args.state.tiles[e[:tile]][:owner] == 0 && !args.state.moved)
        if e[:tile] <= 25
          args.state.tiles[args.state.piece[:tile]][:owner], args.state.tiles[e[:tile]][:owner] = args.state.tiles[e[:tile]][:owner], args.state.tiles[args.state.piece[:tile]][:owner]
          args.state.piece[:tile] = e[:tile]
          args.state.moved = true
          roll_check args
          args.state.selected = 0
        elsif e[:tile] > 25 && args.state.piece[:house_of_beauty]
          args.state.tiles[args.state.piece[:tile]][:owner], args.state.tiles[e[:tile]][:owner] = args.state.tiles[e[:tile]][:owner], args.state.tiles[args.state.piece[:tile]][:owner]
          args.state.piece[:tile] = e[:tile]
          args.state.piece[:movable] = false
          args.state.moved = true
          roll_check args
          args.state.selected = 0
        end
      end
    
      # Case 2: If player want to move a piece to tile and it has piece by same player on, That shouldn't happen...
      if (args.state.tiles[e[:tile]][:owner] == same && args.state.piece[:movable] && !args.state.moved && args.state.tiles[args.state.piece[:tile] + args.state.steps[args.state.current_sticks]][:owner] == same)
        # Disable selection of piece and pass that piece isn't moved yet...
        e[:possible] = false
        args.state.moved = false
      end
    
      # Case 3: Exchanging position of player with piece with piece of other player in same place
      # Protection on pieces is also implemented...
      pp.each_with_index do |p, i|
        correct_piece = pp[i][:tile] == e[:tile]
        not_same_place = !(e[:tile] == args.state.piece[:tile])
        incorrect_owner = args.state.tiles[e[:tile]][:owner] != same
    
        if (correct_piece && not_same_place && incorrect_owner && !args.state.moved)
      
          # We make sure that piece not protected...
          forward_protected = (args.state.tiles[e[:tile] + 1] && args.state.tiles[e[:tile] + 1][:owner] != 0 && args.state.tiles[e[:tile] + 1][:owner] != same)
          backward_protected = (args.state.tiles[e[:tile] - 1] && args.state.tiles[e[:tile] - 1][:owner] != 0 && args.state.tiles[e[:tile] - 1][:owner] != same)
        
          if (forward_protected || backward_protected || e[:tile] > 26)
            e[:possible] = false
            args.state.moved = false
          else
            args.state.tiles[pp[i][:tile]][:owner], args.state.tiles[args.state.piece[:tile]][:owner] = args.state.tiles[args.state.piece[:tile]][:owner], args.state.tiles[pp[i][:tile]][:owner]
            args.state.piece[:tile], pp[i][:tile] = pp[i][:tile], args.state.piece[:tile]
            args.state.selected = 0
            args.state.moved = true
            roll_check args
          end
        end
      end
      
      if args.state.piece[:tile] == 25
        args.state.piece[:house_of_beauty] = true
      end
    else
      piece_unmovable args, p
    end
  end
end

def piece_movable args, p, pieces
  args.state.piece = p
  # Set that we have selected a piece (1), If not it's 0
  args.state.selected = 1
  #$gtk.log "INFO: CHECKING AVAILABLE TILES..."
  
  same = args.state.turn == 0 ? 1 : 2
  
  # Note that mechanics here somehow needs to be improved...
  # Get tiles available to, While combination of steps and tile of piece selected < 29
  if args.state.piece[:movable]
    move1 = args.state.piece[:tile] == 0 ? args.state.steps[args.state.current_sticks] : args.state.piece[:tile] + args.state.steps[args.state.current_sticks]
    move2 = args.state.piece[:tile] >= args.state.steps[args.state.current_sticks] ? args.state.piece[:tile] - args.state.steps[args.state.current_sticks] : args.state.piece[:tile]
    
    if (args.state.tiles[move1])
      if (move1 < 25)
        x1 = args.state.board.x + args.state.tiles[move1][:x]
        y1 = args.state.board.y + args.state.tiles[move1][:y]
      elsif (args.state.piece[:tile] < 25 && move1 == 25)
        x1 = args.state.board.x + args.state.tiles[25][:x]
        y1 = args.state.board.y + args.state.tiles[25][:y]
      elsif (args.state.piece[:tile] == 25 && (move1 > 25) && (move1 <= 30 || move1 >= 30) && args.state.piece[:house_of_beauty])
        #$gtk.log "1"
        if (move1 > 25 && move1 < 30)
          x1 = args.state.board.x + args.state.tiles[move1][:x]
          y1 = args.state.board.y + args.state.tiles[move1][:y]
        elsif (move1 == 30)
          args.state.tiles[25][:owner] = 0
          move2 = move1 = 30
          x1 = args.state.board.x + args.state.tiles[29][:x]
          y1 = args.state.board.y + args.state.tiles[29][:y]
          args.state.piece[:tile] = move1
          args.state.piece[:movable] = false
          remove_piece args
          roll_check args
        end
      elsif (args.state.piece[:tile] < 25 && (move1 > 25) && (move1 <= 30 || move1 >= 30) && !args.state.piece[:house_of_beauty])
        move1 = args.state.piece[:tile]
        x1 = args.state.board.x + args.state.tiles[move1][:x]
        y1 = args.state.board.y + args.state.tiles[move1][:y]
      end
    else
      x1 = args.state.board.x + args.state.tiles[args.state.piece[:tile]][:x]
      y1 = args.state.board.y + args.state.tiles[args.state.piece[:tile]][:y]
    end
  
    if args.state.piece[:movable]
      # If x2 and y2 tiles aren't out of board, Make point in tile we can move backward to...
      # Else, Use same first point...
      if (args.state.tiles[move2])
        x2 = args.state.board.x + args.state.tiles[move2][:x]
        y2 = args.state.board.y + args.state.tiles[move2][:y]
      else
        x2 = x1
        y2 = y1
      end
      
      # Get available tiles to move on
      #$gtk.log "INFO: PUSHING POINTS..."
    
      # We make sure to follow the game rules and player shouldn't exchange place of piece with one of his pieces
      # And push points that shows possible moves...
      move1_not_same_player = args.state.tiles[move1][:owner] != same
      move1_not_empty = args.state.tiles[move1][:owner] != 0
      move1_protected_by_forward = move1_not_empty && (args.state.tiles[move1 + 1] && args.state.tiles[move1 + 1][:owner] != 0 && args.state.tiles[move1 + 1][:owner] != same)
      move1_protected_by_backward = move1_not_empty && (args.state.tiles[move1 - 1] && args.state.tiles[move1 - 1][:owner] != 0 && args.state.tiles[move1 - 1][:owner] != same)
      move1_not_forbidden = move1_not_same_player && (move1 <= 25 || (move1 > 25 && args.state.piece[:tile] == 25 && args.state.tiles[move1][:owner] == 0 && args.state.piece[:tile] == 25 && args.state.piece[:house_of_beauty]))
      move1_empty_but_not_forbidden = args.state.tiles[move1][:owner] == 0 && move1_not_forbidden
      move1_not_same_position = args.state.piece[:tile] != move1
      move1_protected = move1_not_same_position && move1_not_same_player && !(move1_protected_by_forward || move1_protected_by_backward) && move1_not_forbidden || (move1_empty_but_not_forbidden && move1_not_forbidden)
    
      move2_not_same_player = args.state.tiles[move2][:owner] != same
      move2_not_empty = args.state.tiles[move2][:owner] != 0
      move2_protected_by_forward = move2_not_empty && (args.state.tiles[move2 + 1] && args.state.tiles[move2 + 1][:owner] != 0 && args.state.tiles[move2 + 1][:owner] != same)
      move2_protected_by_backward = move2_not_empty && (args.state.tiles[move2 - 1] && args.state.tiles[move2 - 1][:owner] != 0 && args.state.tiles[move2 - 1][:owner] != same)
      move2_not_forbidden = move2_not_same_player || (move2 <= 25 && args.state.piece[:tile] == 25 && args.state.piece[:house_of_beauty])
      move2_empty_but_not_forbidden = args.state.tiles[move2][:owner] == 0 && move2_not_forbidden
      move2_not_same_position = args.state.piece[:tile] != move2
      move2_protected = move2_not_same_position && move2_not_same_player && (!(move2_protected_by_forward || move2_protected_by_backward) && move2_not_forbidden) || (move2_empty_but_not_forbidden && move2_not_forbidden)
    
      other_pieces(pieces, args.state.piece[:order]).each do |q|
        if (!(((x1 - args.state.board.x) == args.state.tiles[q[:tile]][:x]) && ((y1 - args.state.board.y) == args.state.tiles[q[:tile]][:y])))
          args.state.points.push << { x: x1 + 30, y: y1 + 35, possible: move1_protected, tile: move1 }
        end
        
        if (!(((x2 - args.state.board.x) == args.state.tiles[q[:tile]][:x]) && ((y2 - args.state.board.y) == args.state.tiles[q[:tile]][:y])))
          args.state.points.push << { x: x2 + 30, y: y2 + 35, possible: move2_protected, tile: move2 }
        end
      end
    end
  end
end

def piece_unmovable args, p
  args.state.piece = p
  
  if !args.state.piece[:movable] && args.state.piece[:house_of_beauty]
    if (((args.state.piece[:tile] + args.state.steps[args.state.current_sticks]) >= 30))
      # Else, We do special squares functionality
      #$gtk.log "HERE 3 LIES!!!"
      if (args.state.piece[:tile] == 25 && args.state.steps[args.state.current_sticks] == 5) 
        remove_piece args
        roll_check args
      elsif (args.state.piece[:tile] == 26 && args.state.steps[args.state.current_sticks] == 4)
        remove_piece args
        roll_check args
      elsif (args.state.piece[:tile] == 27 && args.state.steps[args.state.current_sticks] == 3)
        remove_piece args
        roll_check args
      elsif (args.state.piece[:tile] == 28 && args.state.steps[args.state.current_sticks] == 2)
        remove_piece args
        roll_check args
      elsif (args.state.piece[:tile] == 29 && args.state.steps[args.state.current_sticks] >= 1)
        remove_piece args
        roll_check args
      end
    end
  end
end

def remove_piece args
  args.state.tiles[args.state.piece[:tile]][:owner] = 0
  args.state.piece[:onboard] = false
  args.state.piece[:movable] = false
  args.state.piece[:house_of_beauty] = false
  args.state.moved = true
  args.state.selected = 0
end

# Draw player pieces with labels on them
def draw_player_pieces args
  #$gtk.log "INFO: RENDERING GAME PIECES..."
  args.state.player.pieces.each do |p|
    if p[:onboard]
      args.outputs.primitives << {
        x: args.state.board.x + args.state.tiles[p[:tile]][:x],
        y: args.state.board.y + args.state.tiles[p[:tile]][:y],
        w: 100,
        h: 100,
        path: "sprites/circle-indigo.png"
      }.sprite
    
      args.outputs.primitives << {
        x: args.state.board.x + args.state.tiles[p[:tile]][:x] + 35,
        y: args.state.board.y + args.state.tiles[p[:tile]][:y] + 75,
        text: p[:order],
        size_enum: 16,
        alignment_enum: 0,
        r: 0,
        g: 0,
        b: 0,
        a: 255
      }.label
    end
  end
end

# Draw player 2 pieces with labels on them
def draw_enemy_pieces args
  args.state.enemy.pieces.each do |p|
    if p[:onboard]
      args.outputs.primitives << {
        x: args.state.board.x + args.state.tiles[p[:tile]][:x],
        y: args.state.board.y + args.state.tiles[p[:tile]][:y],
        w: 100,
        h: 100,
        path: "sprites/circle-red.png"
      }.sprite
    
      args.outputs.primitives << {
        x: args.state.board.x + args.state.tiles[p[:tile]][:x] + 35,
        y: args.state.board.y + args.state.tiles[p[:tile]][:y] + 75,
        text: p[:order],
        size_enum: 16,
        alignment_enum: 0,
        r: 0,
        g: 0,
        b: 0,
        a: 255
      }.label
    end
  end
end

# Checks if piece clicked and returns it?
def piece_clicked args
  # If not selected before
  if !(args.state.selected == 1)
    # Reset points of selection
    args.state.points.clear()
    
    # Check turn to see pieces of what player we want to move
    pieces = args.state.turn == 0 ? args.state.player.pieces : args.state.enemy.pieces
  
    # If sticks rolled...We allow to move pieces of same player
    # In case left mouse button selected
    if args.state.rolled
      if args.inputs.mouse.button_left || touch_press(args)
        pieces.each do |p|
          #$gtk.log "INFO: DOING AABB..."
          if mouse_on_rect(args, args.state.board.x + args.state.tiles[p[:tile]][:x], args.state.board.y + args.state.tiles[p[:tile]][:y], 100, 100)
            # Set args.state.piece to selected piece
            if (p[:onboard] && p[:movable])
              args.outputs.sounds << args.state.click_sound
              piece_movable args, p, pieces
            elsif (p[:onboard] && !p[:movable])
              args.outputs.sounds << args.state.click_sound
              piece_unmovable args, p
            end
          end
        end
      end
    end
  end
  
  if !mouse_on_rect(args, args.state.board.x, args.state.board.y, 1000, 300) && (args.inputs.mouse.button_left || touch_press(args))
    args.state.selected = 0
  end
end

def tiles_points_controls args
  # Draw points possible to move to...
  # This still needed to improve (Maybe?)
  args.state.points.each do |e|
    if e[:possible]
      args.outputs.primitives << {
        x: e.x,
        y: e.y,
        w: 40,
        h: 40,
        path: "sprites/circle-green.png"
      }.sprite
    end
  
    # If clicked on one of points
    same = args.state.turn == 0 ? 1 : 2
  
    if ((args.inputs.mouse.button_left || touch_press(args)) && args.state.selected == 1 && mouse_on_rect(args, e.x - 30, e.y - 35, 100, 100) && e[:possible])
      #$gtk.log "INFO: MOVING PIECE..."
      # Move piece
      pieces_movement args, e
    
      if args.state.moved
        args.state.selected = 0
        args.state.pieces_moved += 1
        roll_check args
      
        # If piece is in house of waters, Piece get back to house of live (Tile 15)
        # And passes turn directly after stoping on it...
        if args.state.piece[:tile] > 25 && args.state.piece[:onboard] && args.state.piece[:house_of_beauty]
          if args.state.piece[:tile] == 26
            if !((rand(5) + 1) == 4)
              if args.state.tiles[14][:owner] == 0
                args.state.tiles[args.state.piece[:tile]][:owner] = 0
                args.state.piece[:tile] = 14
                args.state.piece[:house_of_beauty] = false
                args.state.piece[:movable] = true
                args.state.tiles[args.state.piece[:tile]][:owner] = same
              else
                args.state.piece[:movable] = false
                args.state.piece[:house_of_beauty] = true
              end
            else
              args.state.tiles[26][:owner] = 0
              args.state.piece[:tile] = 30
              args.state.piece[:movable] = false
              remove_piece args
              roll_check args
            end
            args.state.finished = true
          end
        end
      end
    elsif args.inputs.mouse.button_right
      # Deselect with left mouse button, Select with left mouse button (As code above)
      args.state.selected = 0
    end
  end
end
