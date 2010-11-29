# Rapture and Rooms
# I'm currently including all player actions as Rapture methods, but I'd like to break those off to a subclass.

# Defines the environment and starting methods
class Rapture
  attr_accessor :player

  require "rapturesubs"
  
  def initialize(player_name, difficulty)
    @player = Player.new(player_name, difficulty)
    @rooms = []
    @enemies = []
    @weapons = []
    @weapons_list = [:wrench, :pistol, :shotgun]
  end

  # Method to add rooms
  def add_room(reference, name, description, connections, items, enemies)
    @rooms << Room.new(reference, name, description, connections, items, enemies)
  end

  # Method to define enemies
  def add_enemy(name, health, power, strong, weak)
    @enemies << Enemy.new(name, health, power, strong, weak)
  end

  # Starts the beginning of the game
  def start(location)
    puts "Welcome to Rapture, " + @player.name + ".\n\n"
    @player.location = location
    show_current_description
    show_current_items
  end

  # Process the player's instruction string, finding matching methods and sending the method call
  def instruct(instruction)
    @action = nil
    
    # Translate action shortcuts, format and split
    shortcuts = {"n" => "go north", "w" => "go west", "e" => "go east", "s" => "go south"}
    instruction = shortcuts.include?(instruction) ? shortcuts[instruction] : instruction
    instruction_split = instruction.downcase.split

    # If no word, ask what?, one word, check for method or ask to specify
    # if multi-word, search for method and process
    puts "What?" if instruction == ''
    if instruction_split.size == 1
      @action = instruction_split[0] if self.respond_to?instruction_split[0]
    else
      # Loop through string adding words till you find an existing method,
      # then assign the action and choice from the split strings
      0.upto(instruction_split.size - 1) do |n|
        if self.respond_to?instruction_split[0..n].join('_')
          @action = instruction_split[0..n].join('_')
          @choice = instruction_split[(n+1)..instruction_split.size].join('_').to_sym
        end
      end
    end

    if @action != nil
      self.send @action, @choice
    else
      puts "You can't " + instruction if instruction != ''
    end
  end

  #==Helper Methods
  # These are helper methods to aid action methods
  #
  def show_current_description
    puts find_room_in_rapture(@player.location).full_description
  end

  def find_room_in_rapture(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  # Check for direction key in hash, with error handling
  def find_room_in_direction(direction)
    room = find_room_in_rapture(@player.location).connections.has_key?(direction) ? find_room_in_rapture(@player.location).connections[direction] : @player.location
    return room
  end

  # List current items in room
  def show_current_items
    puts find_room_in_rapture(@player.location).list_items
  end

  # Check for current item selected
  def find_current_item(item)
    find_room_in_rapture(@player.location).items.include?(item)
  end

  # Generate enemy in room
  def show_enemies
    chance = find_room_in_rapture(@player.location).enemies
    if chance == 10
      @enemy = Enemy.new("Leadheaded Splicer", 100, rand(10), :tk, :shock)
      puts "There is a " + @enemy.name + " in the room! It's seen you! It runs straight for you..."
      fight_choice
    end
  end

  #==Action Methods
  #
  # This defines all movement with error handling
  def go(direction)
    current_room = @player.location
    @player.location = find_room_in_direction(direction)
    if current_room == @player.location
      puts "\nYou cannot go " + direction.to_s
    else
      puts "\nYou go " + direction.to_s
      show_current_description
      show_current_items
      show_enemies
    end
  end

  # List items in the current room
  def look
    p "this"
    show_current_items
  end

  # List player's current inventory
  def inventory
    p "this"
    puts @player.list_inventory
  end

  # Removes an item from a room and places it in the player's inventory
  def pick_up(item)
    if find_current_item(item)
      # Remove item from @rooms item array, converting the item to a single item array
      find_room_in_rapture(@player.location).items -= [item.to_sym]
      if @weapons_list.include?(item.to_sym)
        @player.weapons << item
      else
        @player.inventory << item
      end
      puts "You picked up the " + item.to_s.gsub('_', ' ')
    else
      puts "You cannot pick up a " + item.to_s.gsub('_', ' ')
    end
  end

  #==Fight Methods
  #
  # Fight or run
  def fight_choice
    puts "Fight or run?"
    fight_input = gets.chomp.downcase
    if fight_input == "fight"
      until @enemy.health <= 0
        fight_enemy
      end
      puts "You've killed the " + @enemy.name
    elsif fight_input == "run"
      run_away
    else
      puts "You have to do something!"
    end
  end

  # Choose weapon
  def fight_enemy
    puts "Choose your weapon"
    @weapons = @player.weapons
    1.upto(@weapons.size) {|n| puts n.to_s + " - " + @weapons[n-1].to_s}
    puts (@weapons.size + 1).to_s + " - Screw this, just run"
    weapon_input = gets.chomp
    battle(weapon_input)
  end
  
  # Fight the enemy
  def battle(weapon)
    weapon = :wrench
    damage_to_enemy = rand(15) + 15
    damage_to_player = @enemy.power + rand(10) + 5
    @enemy.health -= damage_to_enemy
    puts "You did " + damage_to_enemy.to_s + " damage to the " + @enemy.name + "!"
    if @enemy.health >0
      @player.health -= damage_to_player
      puts "The " + @enemy.name + " hits you with a pipe and inlicts " + damage_to_player.to_s + " damage on you."
      puts "You now have " + @player.health.to_s + " health left."
    end
  end

  # Check for room connections and go to the 'previous' room, or lower in the rooms array connected to current
  def run_away
    current_room = find_room_in_rapture(@player.location)
    room_number = @rooms.index(current_room)
    connected = false
    until connected
      prev_room = @rooms[room_number - 1].reference
      connected = current_room.connections.value?(prev_room)
      if connected
        direction = current_room.connections.index(prev_room)
        go(direction)
      end
      room_number -= 1
    end
  end
end