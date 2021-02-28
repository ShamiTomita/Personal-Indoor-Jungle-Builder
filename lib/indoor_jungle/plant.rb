
class IndoorJungle::Plant
#modeling after the student creator, I will need a place to store all the plants and then each plant's attributes
#
  attr_accessor :name, :price_range, :plant_url, :sunlight, :water, :temperature, :plant

  @@all = []
  @@plants = []

  def initialize(plant_hash)
    plant_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.all
    @@all
  end

  def self.create_from_collection(plants_array)
    plants_array.each do |plant|
      plant = self.new(plant)
      @@plants << plant
    end
  end

  def add_plant_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

end
