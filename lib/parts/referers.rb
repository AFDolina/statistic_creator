module Part
  module Referer
    def spot_source(referer)
      source = Hash.new

      r1 = Regexp.new('\\w*#{class_conf[project]}.\\w+')
      r2 = Regexp.new('\\w*yandex.\\w+')
      r3 = Regexp.new('\\w*google.\\w+')
      r4 = Regexp.new('\\w*mail.\\w+')
      r5 = Regexp.new('\\w*yahoo.\\w+')
      r7 = Regexp.new('\\w*#{class_conf[company_url]}.\\w+')

      if !(referer =~ r1).nil?
        source = {source_id: 1, is_internal: true}
      elseif !(referer =~ r2).nil?
        source = {source_id: 2, is_internal: false}
      elseif !(referer =~ r3).nil?
        source = {source_id: 3, is_internal: false}
      elseif !(referer =~ r4).nil?
        source = {source_id: 4, is_internal: false}
      elseif !(referer =~ r5).nil?
        source = {source_id: 5, is_internal: false}
      elseif !(referer =~ r7).nil?
        source = {source_id: 7, is_internal: true}
      else
        source = {source_id: 8, is_internal: false}
      end
      return source
    end

    def create_referer_stat(switcher, hash={})
    source = spot_source(hash[:referer])
    source[:source_id] = hash[:source_id].nil? ? source[:source_id] : hash[:source_id]
    source[:is_internal] = hash[:is_internal].nil? ? source[:is_internal] : hash[:is_internal]
    source.each { |key, value| hash[key] = value }

    case switcher
      when 'Month'
        ReferersByMonth.create(company_id: hash[:company_id],
                                date: hash[:beginning_of_month],
                                referer: hash[:referer],
                                pages: hash[:pages],
                                source_id: hash[:source_id],
                                is_internal: hash[:is_internal])
      when 'Week'
        ReferersByWeek.create(company_id: hash[:company_id],
                                first_week_day: hash[:first_week_day],
                                last_week_day: hash[:last_week_day],
                                year: hash[:year],
                                week: hash[:week],
                                referer: hash[:referer],
                                pages: hash[:pages],
                                source_id: hash[:source_id],
                                is_internal: hash[:is_internal])
      end
    end

    def update_referer_stat(switcher, id, hash={})
      case switcher
      when 'Month'
        pages = ReferersByMonth.select("pages").where(id: id).first.pages
        v = pages.to_i + hash[:pages]
        ReferersByMonth.update(id, pages: v)
      when 'Week'
        pages = ReferersByWeek.select("pages").where(id: id).first.pages
        v = pages.to_i + hash[:pages]
        ReferersByWeek.update(id, pages: v)
      end
    end
  end
end
