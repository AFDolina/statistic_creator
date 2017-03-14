class GeoByMonth < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_geo_by_months'
end

class GeoByWeek < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_geo_by_weeks'
end
