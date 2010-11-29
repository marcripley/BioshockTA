# Gameplay
require "rapture"

# Player initialization
@rapture = Rapture.new("Bio Ripley", 6)

# Require and initialize rooms
require "rooms"
require "enemies"

# Start the game by placing player in the Entryway
@rapture.start(:entryway)

# Get instructions
input = ''
until input == "end"
  input = gets.chomp
  begin
    @rapture.instruct(input) if input != "end"
  rescue
    puts "Whatever you typed isn't working. Try again!"
  end
end