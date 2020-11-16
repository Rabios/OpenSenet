# Written by Rabia Alhaffar in 25/October/2020
# OpenSenet, Simple Open-Source Senet game written in DragonRuby GTK!
# Updated: 16/November/2020 (v0.4)
=begin
  All thanks goes to:
    @Akzidenz-Grotesk
	@kniknoo
	@amirrajan
	@Islacrusez
	@Hiro_r_b
	@Adam
	@craggar
    @danhealy
	@phasefx
	@Lernakow
  
  You devs really helped me a lot! <3
=end

# How to play Senet? http://www.pjhoover.com/senet.php

require "app/variables.rb"    # Variables
require "app/utils.rb"        # Utilities
require "app/finish.rb"       # Finish game scene (If one of 2 players won)
require "app/credits.rb"      # Credits scene code
require "app/main_menu.rb"    # Main menu scene code
require "app/pause_menu.rb"   # Pause menu scene code
require "app/sticks.rb"       # Sticks logic
require "app/pieces.rb"       # Game pieces logic
require "app/game.rb"         # Gameplay scene

#############################################################################
#                               GAME LOOP                                       
#############################################################################
# Check and draw current scene
def check_scene args
  if args.state.scene == 0
	menu args
  elsif args.state.scene == 1
	game args
  elsif args.state.scene == 2
    finish args
  elsif args.state.scene == 3
    credits args
  elsif args.state.scene == 4
    pause_menu args
  end
end

# Main game loop
def tick args
  $gtk.set_window_title "OpenSenet"
  if args.state.tick_count == 0
    $gtk.hide_cursor
  end
  
  # Setup variables
  setup args
  
  check_scene args
  
  # ESC: Exit game
  if args.inputs.keyboard.escape
    $gtk.exit
  end
  
  # TAB or R: Restart game...
  if args.inputs.keyboard.tab || args.inputs.keyboard.r
    $gtk.reset seed: (Time.now.to_f * 100).to_i
  end
  
  args.outputs.primitives << {
    x: 10,
	y: 710,
	text: args.gtk.current_framerate.to_i,
	size_enum: 8,
	r: 0,
	g: 255,
	b: 0,
	a: 255
  }.label
  
  args.outputs.primitives << {
	x: args.inputs.mouse.x,
	y: args.inputs.mouse.y - 32,
	w: 32,
	h: 32,
	path: "sprites/cursor.png"
  }.sprite
end