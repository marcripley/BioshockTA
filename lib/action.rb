# Define action methods and output, other than the go action

class Action < Rapture
  attr_accessor :action, :choice

  # Creating an Action object uses the action parameter to call the right method
  def initialize(action, choice)
    @action = action.gsub(' ', '_')
    @choice = choice
    self.send @action, @choice
  end

  def pick_up(item)
    puts "You picked up the " + item
  end
end