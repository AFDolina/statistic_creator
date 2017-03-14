class ActivitiesTotal < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_activities_totals'
end

class ActivitiesByDay < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_activities_by_days'
end

class ActivitiesByWeek < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_activities_by_weeks'
end

class ActivitiesByMonth < ActiveRecord::Base
  self.table_name = 'statistics.company_statistic_activities_by_months'
end
