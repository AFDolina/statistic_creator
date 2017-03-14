class TotalByDay < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_total_by_days'
end

class TotalByWeek < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_total_by_weeks'
end

class TotalByMonth < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_total_by_months'
end

class Totals < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_totals'
end
