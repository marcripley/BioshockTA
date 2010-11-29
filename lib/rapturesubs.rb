  # Initializes the player and stores the name, current location, health and inventory
  class Player
    attr_accessor :name, :difficulty, :location, :health, :weapons, :inventory

    def initialize(player_name, difficulty)
      @name = player_name
      @difficulty = difficulty
      @health = 100
      @weapons = []
      @inventory = []
    end

    def list_inventory
      "You have a " + (@weapons + @inventory).join(', ')
    end
  end

  # This class defines the rooms in Rapture with their connections, items, and enemies
  # Bonus items (with random odds) could be included later to include bandages, food, etc...
  class Room
    attr_accessor :reference, :name, :description, :connections, :items, :enemies

    def initialize(reference, name, description, connections, items, enemies)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
      @items = items
      @enemies = enemies # Probability of enemies in room, 0-10
    end

    def full_description
      "You are in the " + @name + "\n" + @description
    end

    # List items in current room, formatted for easy reading
    def list_items
      joiner = @items.size > 1 ? ' and ' : ' '
      items_message = @items.size == 0 ? "This room is empty." : "You see a " + @items.join(joiner).gsub('_', ' ') + "."
      return items_message
    end
  end

  class Enemy
    attr_accessor :name, :health, :power, :strong, :weak

    def initialize(name, health, power, strong, weak)
      @name = name
      @health = health
      @power = power
      @strong = strong
      @weak = weak
    end
  end