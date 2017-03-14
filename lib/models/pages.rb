class PagesTotal < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_pages_totals'
end

class PagesByMonth < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_pages_by_months'
end

class PagesByWeek < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_pages_by_weeks'
end
