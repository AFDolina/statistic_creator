module Part
  module Activities
    def create_activities_stat(switcher, hash={})
    case switcher
      when 'Month'
        ActivitiesByMonth.create(company_id: hash[:company_id],
                                date: hash[:beginning_of_month],
                                value: hash[:value],
                                action: hash[:action])
      when 'Week'
        ActivitiesByWeek.create(company_id: hash[:company_id],
                                first_week_day: hash[:first_week_day],
                                last_week_day: hash[:last_week_day],
                                year: hash[:year],
                                week: hash[:week],
                                value: hash[:value],
                                action: hash[:action])
      when 'Day'
        ActivitiesByDay.create(company_id: hash[:company_id],
                                date: hash[:date],
                                value: hash[:value],
                                action: hash[:action])
      when 'Total'
        ActivitiesTotal.create(company_id: hash[:company_id],
                                value: hash[:value],
                                action: hash[:action])
      end
    end

    def update_activities_stat(switcher, id, hash={})
      case switcher
      when 'Month'
        value = ActivitiesByMonth.select("value").where(id: id).first.value
        v = value.to_i + hash[:value]
        ActivitiesByMonth.update(id, value: v)
      when 'Week'
        value = ActivitiesByWeek.select("value").where(id: id).first.value
        v = value.to_i + hash[:value]
        ActivitiesByWeek.update(id, value: v)
      when 'Day'
        value = ActivitiesByDay.select("value").where(id: id).first.value
        v = value.to_i + hash[:value]
        ActivitiesByDay.update(id, value: v)
      when 'Total'
        value = ActivitiesTotal.select("value").where(id: id).first.value
        v = value.to_i + hash[:value]
        ActivitiesTotal.update(id, value: v)
      end
    end
  end
end
