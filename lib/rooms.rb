# Initializes all rooms

@rapture.add_room(:entryway, "Entryway", "A dark open entry hall. It looks old and abandoned, but there are a few lights on.", {:west => :lounge}, [:wrench], 0)
@rapture.add_room(:lounge, "Lounge", "A small, well lit room. There is a dead body on the floor. You hear whispers in a nearby room...", {:east => :entryway, :north => :hall1}, [:first_aid_kit, :eve_hypo], 10)
@rapture.add_room(:hall1, "Hall", "It's small and you can see the underwater city out of the giant windows. There's an elevator at the end of the hall.", {:south => :lounge, :north => :elevator1}, [], 1)
@rapture.add_room(:elevator1, "Elevator", "Press up to go to the Kashmir Restaurant.", {:south => :lounge}, [], 1) #, :up => :medpavilion
# @rapture.add_room(:kashmir, "Kashmir Restaurant", "It's awfully quiet in here. There's music playing in the back, but no sign of life.", {:south => :hall1, :north => :surgery, :west => :dentist, :east => :}, [:first_aid_kit, :eve_hypo, :bandages, :pep_bar], 0)
# @rapture.add_room(:medpavilion, "Medical Pavilion", "There are bodies scattered everywhere. They all have severe burns.", {:south => :hall1, :north => :surgery, :west => :dentist, :east => :}, [:first_aid_kit, :eve_hypo, :bandages, :pep_bar], 6)