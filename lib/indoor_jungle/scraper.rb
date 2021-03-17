
#Scraper.scrape_site('https://www.plants.com/c/all-plants')
#Scraper.scrape_plant('https://www.plants.com/p/snake-plant-157646?c=all-plants')
class IndoorJungle::Scraper
  def self.scrape_site(site)
    page = Nokogiri::HTML(URI.open(site))
    plants_lumped = []

    page.css('div.ProductList_productItem__HxDc2').each do |plants|
      plants_lumped << {
        :name => plants.css('div.col-12').text,
        :price_range => plants.css("a span").children[1].text,
        :plant_url => "https://www.plants.com" + (plants.css("a")[0].attributes["href"].value)
      }
      end
      plants_lumped
  end


  def self.scrape_plant(plant_url)
    page = Nokogiri::HTML(URI.open(plant_url))
    plant = {}
    element = page.css('div.product-layout-')
      if element.css('p.condition-text.mb-0').empty?
        plant[:sunlight] = ["nope", "nah", "oops"]
        plant[:water] = "nah"
        plant[:temperature] = "ooops"
        plant
      else
      plant[:sunlight] = element.css('p.condition-text.mb-0').first.text
      plant[:water] = element.css('div.image-card p')[1].text
      plant[:temperature] = element.css('div.image-card p')[2].text.delete("\u00B0F")
      plant 
    end
  end
end
