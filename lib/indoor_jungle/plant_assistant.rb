#CLI Controller
require 'colorize'
require 'pry'
class IndoorJungle::PlantAssistant
BASE_PATH = "https://www.plants.com/c/all-plants"

@@cold = [] #60-65
@@room_temp = [] #60-75
@@warm = [] #tropical vibes, 65-90, warm
@@low_light = [] #"tolerate low light" "handle low light" "moderate"
@@medium_light = [] #"tolerate low light", "prefers bright" "moderate" "without direct sun"
@@high_light = [] #"bright" "sunny" "full sun"
@@low_maintenance = [] #when soil is dry "drought tolerant"
@@medium_maintenance = [] #water once a week "moderate"
@@high_maintenance = [] #"keep humidity tray full" "saturated" "ambient humidity" "do not"

  def initialize
    make_plants
    add_attributes_to_plants
    sort_plants
  end

  def call
    #cold, low_light, low_maintenance
    puts "Welcome to you Personal Indoor Jungle Builder!!!"
    #input = gets
    IndoorJungle::Plant.all.select do |plant|
      if @@cold.include?(plant) && @@high_light.include?(plant) && @@high_maintenance.include?(plant)
        puts plant.name
      end
    end
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

  def self.display_plant
      puts "-----------------------".green
    IndoorJungle::Plant.all.each do |plant|
      puts "Plant Name: #{plant.name}".light_green
      puts "#{plant.price_range}".magenta
      puts "Sunlight: #{plant.sunlight[0]}."
      puts "Water: #{plant.water}."
      puts "Temperature: " + "#{plant.temperature}.".capitalize
      puts "#{plant.plant_url}"
      puts "-----------------------".green
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
      if plant.sunlight[0].include?("tolerate") || plant.sunlight[0].include?("handle") || plant.sunlight[0].include?("low")
        @@low_light << plant
      elsif plant.sunlight[0].include?("moderate") ||plant.sunlight[0].include?("medium") || plant.sunlight[0].include?("prefers") || plant.sunlight[0].include?("without direct")
        @@medium_light << plant
      elsif plant.sunlight[0].include?("bright")|| plant.sunlight[0].include?("sunny") || plant.sunlight[0].include?("full")
        @@high_light << plant
      end
    end
    @@low_light
    @@medium_light
    @@high_light
  end

  def sort_plants_by_temp
    #====> plant istances can have all three if they fall within the range
      sorted_plants = self.library
      sorted_plants.each do |plant|
        if plant.temperature.include?("60-65") || plant.temperature.include?("Cooler" || "cooler")
          @@cold  << plant
        elsif plant.temperature.include? ("60-80") ||plant.temperature.include?("65") || plant.temperature.include?("70") ||plant.temperature.include?("75")
          @@room_temp << plant
        elsif plant.temperature.include?("tropical") || plant.temperature.include?("warm") || plant.temperature.include?("80") || plant.temperature.include?("90")
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
        if plant.water.include?("never") || plant.water.include?("keep") || plant.water.include?("should") || plant.water.include?("humidity") || plant.water.include?("not")
          @@high_maintenance << plant
        elsif plant.water.include?("Drought") || plant.water.include?("tolerant") || plant.water.include?("soil is dry") || plant.water.include?("tolerate")
          @@low_maintenance << plant
        elsif
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
