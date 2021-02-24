#!/usr/bin/env ruby
require_relative "../lib/plant.rb"
require_relative "../lib/scraper.rb"
require 'nokogiri'

class Plant_Assistant
  BASE_PATH = "https://www.plants.com/c/all-plants"

  def run
    make_plants
    add_attributes_to_plants
    display_plant
  end

  def make_plants
    plants_array = Scraper.scrape_site(BASE_PATH)
    Plant.create_from_collection(plants_array)
  end

  def add_attributes_to_plants
    Plant.all.each do |plant|
      attributes = Scraper.scrape_plant(plant.plant_url)
      plant.add_plant_attributes(attributes)
    end
  end

  def display_plant
    Plant.all.each do |plant|
      puts "#{plant.name}"
      puts "#{plant.price_range}"
      puts "#{plant.sunlight}"
      puts "#{plant.water}"
      puts "#{plant.temperature}"
      puts "#{plant.plant_url}"
      puts "-----------------------"
  end




end
