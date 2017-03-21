# run: "ruby sc1.rb 12345 bz3 2.10.2016"

require 'yaml'
require_relative 'lib/controller.rb'

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

totals = [
  {yml_hits: 10, visits: 20, pages: 30}
]
dates.each do |date|
  totals.push({date: date, yml_hits: 1, visits: 3, pages: 5})
end

totals.each do |hash|
  s.totals(hash)
end
