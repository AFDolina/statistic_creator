module Part
  module Referer
    def spot_source(referer)
      source = Hash.new

      a = 0 if !(referer =~ Regexp.new('\\w*#{class_conf[company_slug]}.#{class_conf[stand_link]\\w+')).nil?
      a = 1 if !(referer =~ Regexp.new('\\w*www.#{class_conf[project]}.\\w+')).nil?
      a = 2 if !(referer =~ Regexp.new('\\w*yandex.\\w+')).nil?
      a = 3 if !(referer =~ Regexp.new('\\w*google.\\w+')).nil?
      a = 4 if !(referer =~ Regexp.new('\\w*mail.\\w+')).nil?
      a = 5 if !(referer =~ Regexp.new('\\w*yahoo.\\w+')).nil?
      a = 7 if !(referer =~ Regexp.new('\\w*#{class_conf[company_slug]}.#{class_conf[stand_link]}.\\w+')).nil?

      case a
        when 0
          source = {source_id: 0, is_internal: true}
        when 1
          source = {source_id: 1, is_internal: true}
        when 2
          source = {source_id: 2, is_internal: false}
        when 3
          source = {source_id: 3, is_internal: false}
        when 4
          source = {source_id: 4, is_internal: false}
        when 5
          source = {source_id: 5, is_internal: false}
        when 7
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
