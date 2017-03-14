require_relative 'main.rb'


s = StatisticCreator.new('19.01.2017')
data = [
  {company_id: 321, page: 'String'},
  {company_id: 321, page: '/products/123-asd', subject_type: 'pt_pkt', subject_id: 123}
]

s.pages(data[0])

s.pages({company_id: 3214, page: 'String'})
