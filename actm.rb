# run: "ruby actm.rb 12345 bz3 2.10.2016"

require 'yaml'
require_relative 'lib/controller.rb'

company_id = ARGV[0] # 12345
stand = ARGV[1] # bz3 pc1 yp2 ..
date = ARGV[2].nil? ? Date.today : Date.parse(ARGV[2]) # 11.10.2015 or 2017-03-21 or other parsable format

CONFIG = YAML.load_file("config/#{stand}.yml")
stand_link = CONFIG['stand_link']
product_listing_slug = CONFIG['p_listing_slug']

s = StatisticCreator.new(company_id, date)

#создаем список дат
dates = []
for i in 0..8 do
  dates.push(date - (i*7))
end

#создаем список хешей, для передачи в методы создающие записи в базе
act = []
activities = CONFIG['activities']
i = 0
dates.each do |date|
  activities.each do |activ|
    i += 1
    act.push({action: activ, date: date, value: i})
  end
end

#инициализируем создание/апдейт записи для каждого значения хеша из массива
act.each do |hash|
  s.activities(hash)
end
