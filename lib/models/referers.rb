class ReferersByMonth < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_referers_by_months'
end

class ReferersByWeek < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_referers_by_weeks'
end
