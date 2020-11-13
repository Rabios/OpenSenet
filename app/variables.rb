#############################################################################
#                               SETUP                                       
#############################################################################
def setup args
  #$gtk.log "INFO: LOADING VARIABLES..."
  load_variables args
  load_tiles args
  load_pieces args
  #$gtk.log "INFO: VARIABLES LOADED!"
end

def load_variables args
  args.state.scene          ||= 0             # Current scene (Check above)
  args.state.recw           ||= 0             # width of scene rectangle (Used to animate scenes switching...)
  args.state.board.x        ||= 120           # x position of the board
  args.state.board.y        ||= 240           # y position of the board
  args.state.ualpha         ||= 100           # Alpha for player that is not in his turn
  args.state.rolls          ||= 0             # Rolls allowed when rolling sticks (2 moves for 1, 3, 5 and 1 move only for 2 and 4)
  args.state.animation      ||= 0             # Animation movement number (It has nothing to do with roll args)
  args.state.goto           ||= 0             # Scene selected to go to when clicking on option in main menu
  args.state.label1_hovered ||= false         # Is mouse hovered on "START GAME" label?
  args.state.label2_hovered ||= false         # Is mouse hovered on "CREDITS" label?
  args.state.label3_hovered ||= false         # Is mouse hovered on "EXIT GAME" label?
  args.state.label4_hovered ||= false         # Is mouse hovered on "<< BACK" label?
  args.state.label5_hovered ||= false         # Is mouse hovered on "RESUME" label? 
  args.state.label6_hovered ||= false         # Is mouse hovered on "GO TO MAIN MENU" label?
  args.state.label7_hovered ||= false         # Is mouse hovered on "EXIT GAME" label from pause menu?
  args.state.extra_turn     ||= false         # Extra turn?
  args.state.finished       ||= false         # Turn finished?
  args.state.rolled         ||= false         # Are sticks rolled?
  args.state.moved          ||= false         # Is piece moved? (To break loop of movement...)
  args.state.selected       ||= 0             # Piece selected?
  args.state.piece          ||= 0             # Current piece selected
  args.state.pieces_moved   ||= 0             # Pieces moved, Cleared each time turn passed
  args.state.turn           ||= 0             # 0 for first and 1 for second player
  args.state.current_sticks ||= 0             # Current sticks
  args.state.winner         ||= 0             # 0 for nothing, 1 for first player, 2 for second player
  args.state.sticks         ||= [0, 0, 0, 0]  # Sticks will be used by game...
  args.state.steps          ||= [0]           # Steps depending on result of rolling sticks...
  args.state.points         ||= []            # Points shows possible moves of a piece, Cleared each time piece selected
  
  # Special gift ;)
  args.state.reds           ||= [ rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1 ]
  args.state.greens         ||= [ rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1 ]
  args.state.blues          ||= [ rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1, rand(255) + 1 ]
  args.state.thanks         ||= [ "@Akzidenz-Grotesk", "@kniknoo", "@amirrajan", "@Hiro_r_b", "@Adam", "@craggar", "@Islacrusez", "@phasefx", "@danhealy", "@Lernakow" ]

  args.state.select_sound   ||= "audio/50561__broumbroum__sf3-sfx-menu-select.wav"
  args.state.click_sound    ||= "audio/538548__sjonas88__select-3.wav"
  args.state.roll_sound     ||= "audio/91051__suicidity__sticks-of-god-005.wav"
end

def load_tiles args
  # All pieces in the game will use this as info...
  args.state.tiles ||= [
    { x: 0, y: 200, owner: 1 },
	{ x: 100, y: 200, owner: 2 },
	{ x: 200, y: 200, owner: 1 },
	{ x: 300, y: 200, owner: 2 },
	{ x: 400, y: 200, owner: 1 },
	{ x: 500, y: 200, owner: 2 },
	{ x: 600, y: 200, owner: 1 },
	{ x: 700, y: 200, owner: 2 },
	{ x: 800, y: 200, owner: 1 },
	{ x: 900, y: 200, owner: 2 },
	{ x: 900, y: 100, owner: 1 },
	{ x: 800, y: 100, owner: 2 },
	{ x: 700, y: 100, owner: 1 },
	{ x: 600, y: 100, owner: 2 },
	{ x: 500, y: 100, owner: 0 },
	{ x: 400, y: 100, owner: 0 },
	{ x: 300, y: 100, owner: 0 },
	{ x: 200, y: 100, owner: 0 },
	{ x: 100, y: 100, owner: 0 },
	{ x: 0, y: 100, owner: 0 },
	{ x: 0, y: 0, owner: 0 },
	{ x: 100, y: 0, owner: 0 },
	{ x: 200, y: 0, owner: 0 },
	{ x: 300, y: 0, owner: 0 },
	{ x: 400, y: 0, owner: 0 },
	{ x: 500, y: 0, owner: 0 },
	{ x: 600, y: 0, owner: 0 },
	{ x: 700, y: 0, owner: 0 },
	{ x: 800, y: 0, owner: 0 },
	{ x: 900, y: 0, owner: 0 },
	{ x: 0, y: 0, owner: 0 }  # This left for exceptions...
  ]
end

def load_pieces args
  # Pieces of player 1
  args.state.player.pieces ||= [
    { tile: 0, order: 1, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 2, order: 2, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 4, order: 3, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 6, order: 4, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 8, order: 5, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 10, order: 6, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 12, order: 7, onboard: true, movable: true, house_of_beauty: false }
  ]
  
  # Pieces of player 2
  args.state.enemy.pieces ||= [
    { tile: 1, order: 1, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 3, order: 2, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 5, order: 3, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 7, order: 4, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 9, order: 5, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 11, order: 6, onboard: true, movable: true, house_of_beauty: false },
	{ tile: 13, order: 7, onboard: true, movable: true, house_of_beauty: false }
  ]
end