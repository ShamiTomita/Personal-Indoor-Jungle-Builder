#CLI Controller

class IndoorJungle::PlantAssistant
  BASE_PATH = "https://www.plants.com/c/all-plants"

  @@cold = [] #house the least amount of plants
  @@room_temp = [] #should house the most plants
  @@warm = [] #house most plants
  @@low_light = [] #should house least amount
  @@medium_light = [] #should house most
  @@high_light = [] #should house all except ones that cant take bright sun
  @@low_maintenance = [] #when soil is dry "drought tolerant"
  @@medium_maintenance = [] #water once a week "moderate"
  @@high_maintenance = [] #"keep humidity tray full" "saturated" "ambient humidity" "do not"

  def initialize
    make_plants
    add_attributes_to_plants
    sort_plants
  end

  def make_plants
    plants_array = IndoorJungle::Scraper.scrape_site(BASE_PATH)
    IndoorJungle::Plant.create_from_collection(plants_array)
  end

  def add_attributes_to_plants
      IndoorJungle::Plant.all.each do |plant|
      attributes = IndoorJungle::Scraper.scrape_plant(plant.plant_url)
      plant.add_plant_attributes(attributes)
    end
  end

  def call
    #cold, low_light, low_maintenance
    switch = nil
    plants = []
    temp = nil
    light = nil
    attention = nil
    temp_input = nil
    light_input = nil
    attention_input = nil
    input_2 = nil


    puts "To get started, we need to get some more information about you"
    sleep(1)
    puts "Would you describe your home temperature as: cool(around 60F), room temp(around 70F), or warm? (around or above 80F)"

    until temp_input == "cool" || temp_input == "cold" || temp_input == "colder" || temp_input == "room temp" || temp_input == "room" || temp_input == "average" || temp_input == "warm" || temp_input == "tropical" || temp_input == "hot" || temp_input == "60F" || temp_input == "70F" || temp_input == "80F"
      temp_input = gets.chomp
    end

    if temp_input == "cool" || temp_input == "cold" || temp_input == "colder" || temp_input == "60F"
      temp = @@cold
    elsif temp_input == "room temp" || temp_input == "room" || temp_input == "average" || temp_input == "70F"
      temp = @@room_temp
    elsif  temp_input == "warm" || temp_input == "hot" || temp_input == "tropical" || temp_input == "80F"
      temp = @@warm
    end

    puts "Would you describe the light sources in your home as: low light, medium light, or bright?"

    until light_input == "low light" || light_input == "low" || light_input == "medium light" || light_input == "medium" || light_input == "average" || light_input == "bright" || light_input == "hight light" || light_input == "sunny"
    light_input = gets.chomp
    end

    if light_input == "low light" || light_input == "low"
      light = @@low_light
    elsif light_input == "medium light" || light_input == "medium" || light_input == "average"
      light = @@medium_light
    elsif light_input == "bright" || light_input == "high light" || light_input == "sunny"
      light = @@high_light
    end

    puts "Finally, would you describe your attention to plant care as: relaxed, average, or vigilant?"

    until attention_input == "relaxed" || attention_input == "lazy" || attention_input == "average" || attention_input == "medium" || attention_input == "vigilant" || attention_input == "above average"
    attention_input = gets.chomp
    end

    if attention_input == "relaxed" || attention_input == "lazy"
      attention = @@low_maintenance
    elsif attention_input == "average" ||attention_input == "medium"
      attention = @@medium_maintenance
    elsif attention_input == "vigilant" || attention_input == "above average"
      attention = @@high_maintenance
    end

    IndoorJungle::Plant.all.each do |plant|
      if temp.include?(plant) && light.include?(plant) && attention.include?(plant)
        plants << plant
      end
    end


      if plants.empty?
        puts "I'm sorry but your answers did not result in a match."
      else
        puts "Thank you for your input! Based on your responses, your ideal plant matches are: "
        puts "-----------------------".green
        plants.each do |x|
        sleep(2)
      display_plant(x)
      sleep(2.5)
      end
    end

    puts "Would you like to 'redo' your ansers or see the full 'list of plants'? Or 'exit'? "

    until input_2 == "redo" || input_2 == "try again" || input_2 == "list" || input_2 == "list of plants" || input_2 == "plants" || input_2 == "exit" || input_2 == "Exit"
      input_2 = gets.chomp
    end

    if input_2 == "redo" || input_2 == "try again"
      call
    elsif input_2 == "list" || input_2 == "list of plants" || input_2 == "plants"
      display_plants
    else
      puts "-----------------------".green
      sleep(1)
      puts "Thank you for using your Indoor Jungle Builder!"
      puts "Please Like & Subscribe"
      sleep(3)
      exit
    end
  end

  def display_plant(plant)
    puts "Plant Name: #{plant.name}".light_green
    puts "Sunlight: #{plant.sunlight}."
    puts "Water: #{plant.water}."
    puts "Temperature: " + "#{plant.temperature}.".capitalize
    puts "URL: #{plant.plant_url}"
    puts "-----------------------".green
  end

  def display_plants
    IndoorJungle::Plant.all.each do |plant|
      puts "Plant Name: #{plant.name}".light_green
      puts "#{plant.price_range}".magenta
      puts "Sunlight: #{plant.sunlight}."
      puts "Water: #{plant.water}."
      puts "Temperature: " + "#{plant.temperature}.".capitalize
      puts "#{plant.plant_url}"
      puts "-----------------------".green
    end
    puts "Would you like to 'redo' your ansers or see the full 'list of plants'? "
    input_2 = gets.chomp
    if input_2 == "redo" || input_2 == "try again"
      call
    elsif input_2 == "list" || input_2 == "list of plants" || input_2 == "plants"
      display_plants
    else
      puts "Thank you for using your Indoor Jungle Builder!"
      exit
    end
  end

  def library(klass = IndoorJungle::Plant ) #importing the Song class into this class so we can create a library of all the songs
    sorted_library = klass.all.collect{|obj| obj if obj.class == klass}
    sorted_library = sorted_library.delete_if {|obj| obj == nil}
    sorted_library.uniq
  end

  def sort_plants
    sort_plants_by_light
    sort_plants_by_temp
    sort_plants_by_maintenance
  end

  def sort_plants_by_light
    #====> plant instances can be in all three
    sorted_plants = self.library
    sorted_plants.each do |plant|
      if plant.sunlight[0].include?("tolerate") || plant.sunlight[0].include?("handle") || plant.sunlight[0].include?("low") || plant.sunlight[0].include?("soft")
        @@low_light << plant
      end
      if !plant.sunlight[0].include?("medium") || plant.sunlight[0].include?("bright")|| plant.sunlight[0].include?("sunny") || plant.sunlight[0].include?("full")
        @@high_light << plant
      end
      if !plant.sunlight[0].include?("Full") || !plant.sunlight[0].include?("sunny")
          @@medium_light << plant
      end
    end
    @@low_light
    @@medium_light
    @@high_light
  end

  def sort_plants_by_temp
    sorted_plants = self.library
    sorted_plants.each do |plant|
      if plant.temperature.include?("60-65") || plant.temperature.include?("60") || plant.temperature.include?("60-80") || plant.temperature.include?("Cooler") || plant.temperature.include?("cooler")
        @@cold  << plant
      end
      if plant.temperature.include?("60-80") || plant.temperature.include?("70") ||plant.temperature.include?("75") || plant.temperature.include?("65-90") || plant.temperature.include?("65 - 90") || plant.temperature.include?("65-85")
        @@room_temp << plant
      end
      if plant.temperature.include?("tropical") || plant.temperature.include?("warm") || plant.temperature.include?("80") || plant.temperature.include?("90") || plant.temperature.include?("65-85")
        @@warm << plant
      end
    end
    @@cold
    @@room_temp
    @@warm
  end

  def sort_plants_by_maintenance
    sorted_plants = self.library
    sorted_plants.each do |plant|
      if plant.water.include?("Drought") || plant.water.include?("tolerant") || plant.water.include?("tolerate") || plant.water.include?("soil is dry") && !plant.water.include?("do not") && !plant.water.include?("keep")
        @@low_maintenance << plant
      end
      if true
        @@high_maintenance << plant
      end
      if !plant.water.include?("never") && !plant.water.include?("not") && !plant.water.include?("overwater")
        @@medium_maintenance << plant
      end
    end
    @@low_maintenance
    @@medium_maintenance
    @@high_maintenance
  end

#######################################


  def self.cold
    puts "-----------------------".green
    @@cold.each do |plant|
      puts plant.name
      puts plant.temperature
      puts "-----------------------".green
    end
  end

  def self.room_temp
    puts "-----------------------".green
    @@room_temp.each do |plant|
      puts plant.name
      puts plant.temperature
      puts "-----------------------".green
    end
  end

  def self.warm
    puts "-----------------------".green
    @@warm.each do |plant|
      puts plant.name
      puts plant.temperature
      puts "-----------------------".green
    end
  end

  def self.low_light
    puts "-----------------------".green
    @@low_light.each do |plant|
      puts plant.name
      puts plant.sunlight[0]
      puts "-----------------------".green
    end
  end

  def self.medium_light
    puts "-----------------------".green
    @@medium_light.each do |plant|
      puts plant.name
      puts plant.sunlight[0]
      puts "-----------------------".green
    end
  end

  def self.high_light
    puts "-----------------------".green
    @@high_light.each do |plant|
      puts plant.name
      puts plant.sunlight[0]
      puts "-----------------------".green
    end
  end

  def self.low_maintenance
    puts "-----------------------".green
    @@low_maintenance.each do |plant|
      puts plant.name
      puts plant.water
      puts "-----------------------".green
    end
  end

  def self.medium_maintenance
    puts "-----------------------".green
    @@medium_maintenance.each do |plant|
      puts plant.name
      puts plant.water
      puts "-----------------------".green
    end
  end

  def self.high_maintenance
    puts "-----------------------".green
    @@high_maintenance.each do |plant|
      puts plant.name
      puts plant.water
      puts "-----------------------".green
    end
  end


end




    #iterate through Plant.all
    #Plant.all.sunlight if include? "bright" || "indirect"
    # Highlgiht <<
    # Mediumlight <<
    # Lowlight <<
    # Temperature within different ranges
