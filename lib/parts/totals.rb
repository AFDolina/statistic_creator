module Part
  module Total
    def create_totals_stat(switcher, hash={})
    case switcher
      when 'Month'
        TotalByMonth.create(company_id: hash[:company_id],
                                date: hash[:beginning_of_month],
                                pages: hash[:pages],
                                visits: hash[:visits],
                                yml_hits: hash[:yml_hits])
      when 'Week'
        TotalByWeek.create(company_id: hash[:company_id],
                                first_week_day: hash[:first_week_day],
                                last_week_day: hash[:last_week_day],
                                year: hash[:year],
                                week: hash[:week],
                                pages: hash[:pages],
                                visits: hash[:visits],
                                yml_hits: hash[:yml_hits])
      when 'Day'
        TotalByDay.create(company_id: hash[:company_id],
                                date: hash[:date],
                                pages: hash[:pages],
                                visits: hash[:visits],
                                yml_hits: hash[:yml_hits])
      when 'Total'
        Totals.create(company_id: hash[:company_id],
                                pages: hash[:pages],
                                visits: hash[:visits],
                                yml_hits: hash[:yml_hits])
      end
    end

    def update_totals_stat(switcher, id, hash={})
      case switcher
      when 'Month'
        data = TotalByMonth.select('pages', 'visits', 'yml_hits').where(id: id).first
        p = data['pages'].to_i + hash[:pages]
        v = data['visits'].to_i + hash[:visits]
        y = data['yml_hits'].to_i + hash[:yml_hits]
        TotalByMonth.update(id, pages: p, visits: v, yml_hits: y)
      when 'Week'
        data = TotalByWeek.select('pages', 'visits', 'yml_hits').where(id: id).first
        p = data['pages'].to_i + hash[:pages]
        v = data['visits'].to_i + hash[:visits]
        y = data['yml_hits'].to_i + hash[:yml_hits]
        TotalByWeek.update(id, pages: p, visits: v, yml_hits: y)
      when 'Day'
        data = TotalByDay.select('pages', 'visits', 'yml_hits').where(id: id).first
        p = data['pages'].to_i + hash[:pages]
        v = data['visits'].to_i + hash[:visits]
        y = data['yml_hits'].to_i + hash[:yml_hits]
        TotalByDay.update(id, pages: p, visits: v, yml_hits: y)
      when 'Total'
        data = Totals.select('pages', 'visits', 'yml_hits').where(id: id).first
        p = data['pages'].to_i + hash[:pages]
        v = data['visits'].to_i + hash[:visits]
        y = data['yml_hits'].to_i + hash[:yml_hits]
        Totals.update(id, pages: p, visits: v, yml_hits: y)
      end
    end
  end
end
