require 'yaml'
require_relative 'main.rb'

company_id = ARGV[0] # 12345
stand = ARGV[1] # bz3 pc1 yp2 ..
date = ARGV[2].nil? ? Date.today : Date.parse(ARGV[2]) # 11.10.2015 or 2017-03-21 or other parsable format

CONFIG = YAML.load_file("config/#{stand}.yml")
stand_link = CONFIG['stand_link']
product_listing_slug = CONFIG['p_listing_slug']

s = StatisticCreator.new(company_id, date)

dates = []
for i in 0..7 do
  dates.push(date - i)
end

pages = []
dates.each do |date|
  pages.push({page: '/', date: date})
end
pages.push({page: '/products/321-asd'})
pages.push({page: '/products/123-asd', subject_type: 'pt_pkt', subject_id: 123})
pages.push({page: "http://#{stand_link}/#{product_listing_slug}/010106-truba-obsadnaya}")

pages.each do |hash|
  s.pages(hash)
end
