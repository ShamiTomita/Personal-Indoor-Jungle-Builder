#CLI Controller

class IndoorJungle::PlantAssistant
BASE_PATH = "https://www.plants.com/c/all-plants"

  def run
    make_plants
    add_attributes_to_plants
    display_plant
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

  def display_plant
    IndoorJungle::Plant.all.each do |plant|
      puts "#{plant.name}"
      puts "#{plant.price_range}"
      puts "#{plant.sunlight}"
      puts "#{plant.water}"
      puts "#{plant.temperature}"
      puts "#{plant.plant_url}"
      puts "-----------------------"
    end
  end




end
