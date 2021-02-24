#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'pry'
site = 'https://www.plants.com/c/all-plants'
#Scraper.scrape_site('https://www.plants.com/c/all-plants')
#Scraper.scrape_plant('https://www.plants.com/p/snake-plant-157646?c=all-plants')
class Scraper
  def self.scrape_site(site)
    page = Nokogiri::HTML(open(site))
    plants_lumped = []
    page.css('div.product-item').each do |plants|
      plants_lumped << {
        :name => plants.css('span.title').text,
        :price_range => plants.css("a span").children[1].text,
        :plant_url => "https://www.plants.com" + (plants.css("a")[0].attributes["href"].value)
      }
      end
      plants_lumped
  end

  def self.scrape_plant(plant_url)
    page = Nokogiri::HTML(open(plant_url))
    plant = {}
    page.css('div.instruction-note.row').each do |element|
      plant[:sunlight] = element.css('div.image-card p')[0].text,
      plant[:water] = element.css('div.image-card p')[1].text,
      plant[:temperature] = element.css('div.image-card p')[2].text.delete("\u00B0 F")
    end
    plant
  end

end
