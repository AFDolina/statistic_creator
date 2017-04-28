# referers
# String                 | source_id | is_internal
# blizko                 | 1         | true
# yandex                 | 2         | false
# google                 | 3         | false
# mail                   | 4         | false
# др.поисковая система   | 5         | false
#                        | 6         | false
# Внутренний переход     | 7         | true
# Прямой переход         | 8         | false
#
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

stand_link = CONFIG['stand_link']
p_listing_slug = CONFIG['p_listing_slug']
company_slug = CONFIG['company_slug']
referers = [
  {referer: "www.#{stand_link}.ru"},
  {referer: "www.#{stand_link}.ru/#{p_listing_slug}/computer/computer/monitors"},
  {referer: "www.#{stand_link}.ru/#{p_listing_slug}/otdyhirazvlecheniya/sportivnye_tovary/sportivnye_igry/mjachi"},
  {referer: "www.#{stand_link}.ru/#{p_listing_slug}/010202-list-nerzhavejucshij"},
  {referer: "http://#{company_slug}.#{stand_link}.ru/", is_internal: true, source_id: 1},
  {referer: "www.yandex.ru/", source_id: 2},
  {referer: "www.yahoo.com/", source_id: 5},
  {referer: "www.mail.ru/", source_id: 4},
  {referer: "www.google.ru/", suorce_id: 3},
  {referer: '', source_id: 8}
]

dates.each do |date|
  referers.push({date: date, referer: '', source_id: 8})
end

referers.each do |hash|
  s.referers(hash)
end
