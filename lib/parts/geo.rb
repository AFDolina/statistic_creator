module Part
  module Geo
    def create_geo_stat(switcher, hash={})
    case switcher
      when 'Month'
        GeoByMonth.create(company_id: hash[:company_id],
                                date: hash[:beginning_of_month],
                                pages: hash[:pages],
                                visits: hash[:visits],
                                city_id: hash[:city_id])
      when 'Week'
        GeoByWeek.create(company_id: hash[:company_id],
                                first_week_day: hash[:first_week_day],
                                last_week_day: hash[:last_week_day],
                                year: hash[:year],
                                week: hash[:week],
                                pages: hash[:pages],
                                visits: hash[:visits],
                                city_id: hash[:city_id])
      end
    end

    def update_geo_stat(switcher, id, hash={})
      case switcher
      when 'Month'
        data = GeoByMonth.select('pages', 'visits').where(id: id).first
        p = data['pages'].to_i + hash[:pages]
        v = data['visits'].to_i + hash[:visits]
        GeoByMonth.update(id, pages: p, visits: v)
      when 'Week'
        data = GeoByWeek.select('pages', 'visits').where(id: id).first
        p = data['pages'].to_i + hash[:pages]
        v = data['visits'].to_i + hash[:visits]
        GeoByWeek.update(id, pages: p, visits: v)
      end
    end
  end
end
