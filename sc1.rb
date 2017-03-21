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
require_relative 'main.rb'

company_id = ARGV[0] # 12345
stand = ARGV[1] # bz3 pc1 yp2 ..
date = ARGV[2].nil? ? Date.today : Date.parse(ARGV[2]) # 11.10.2015 or 2017-03-21 or other parsable format
add_partition_script = "scripts/#{stand}_addpart.sh"

#system("sh #{add_partition_script}")

CONFIG = YAML.load_file("config/#{stand_link}.yml")
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

#activities = ['phone_hits']
#act = [
#  {company_id: company_id, action: 'phone_hits'},
#  {company_id: company_id, date: '21.01.2017', action: 'phone_hits'},
#  {company_id: company_id, date: '21.01.2017', action: 'phone_hits', value: 123}
#]
#act.each do |hash|
#  s.activities(hash)
#end

#referers = [
#  {company_id: company_id, referer: 'String'},
#  {company_id: company_id, referer: 'www.test3-blizko.ru'},
#  {company_id: company_id, referer: 'www.yandex.ru', pages: 3},
#  {company_id: company_id, referer: 'www.mail.ru', is_internal: true, source_id: 1},
#  {company_id: company_id, referer: 'www.mail.ru'}
#]
#referers.each do |hash|
#  s.referers(hash)
#end
