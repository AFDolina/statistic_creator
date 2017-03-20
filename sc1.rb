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

require_relative 'main.rb'

company_id = 4445
date_string = '20.03.2017'
add_partition_script = 'scripts/bz3_addpart.sh'

#system("sh #{add_partition_script}")

s = StatisticCreator.new(date_string)

dates = []
date = Date.parse(date_string)
for i in 0..10 do
  dates.push(date - i)
end

pages = []
dates.each do |date|
  pages.push({company_id: company_id, page: '/', date: date})
end
pages.push({company_id: company_id, page: '/products/123-asd'})
pages.push({company_id: company_id, page: '/products/123-asd', subject_type: 'pt_pkt', subject_id: 123})
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
