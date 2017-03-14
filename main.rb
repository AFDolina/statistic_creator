require 'yaml'
require 'date'

require_relative 'lib/enviroment.rb'

require_relative 'lib/models/activities.rb'
require_relative 'lib/models/geo.rb'
require_relative 'lib/models/pages.rb'
require_relative 'lib/models/referers.rb'
require_relative 'lib/models/total.rb'

class StatisticCreator
  def initialize(d=Date.today)
    @date = (d.instance_of? Date) ? d : Date.parse(d)
    project = ENV['project'].nil? ? 'bz' : ENV['project']
    class_conf = YAML.load_file("config/#{project}.yml")
  end

  def beginning_of_month(date)
    return date.change(day: 1).strftime('%Y-%m-%d')
  end

  def week_parameters(date)
    parameters = Hash.new
    parameters[:first_week_day] = date.beginning_of_week.strftime('%Y-%m-%d')
    parameters[:last_week_day] = date.end_of_week.strftime('%Y-%m-%d')
    parameters[:year] = date.year
    parameters[:week] = date.cweek + 1
    return parameters
  end

  def spot_subject(page)
    subject = Hash.new

    r1 = Regexp.new('/#{class_conf[cs_catalog_slug]}/(\\d+)-\\w+')
    r2 = Regexp.new('/#{class_conf[p_catalog_slug]}/(\\d+)-\\w+')

    r3 = Regexp.new('/blogs/post/\\w+') # /blogs/post/novoe-muzhskoe-belie-dlya-teh-kto-lyubit-pogoryachee
    r4 = Regexp.new('/buy/variations/(\\d+)') # /buy/variations/320
    r5 = Regexp.new('/products/variations/(\\d+)-(\\d+)') # /products/variations/479420-320

    if page =~ r1
      subject[:type] = "pt_skkt"
      subject[:id] =  page.split('/')[2].split('-')[0].to_i
    elseif page =~ r2
      subject[:type] = "pt_pkt"
      subject[:id] = page.split('/')[2].split('-')[0].to_i
    elseif page =~ r3
      subject[:type] = "pt_pkbp" # define subject_id in incomming hash
    elseif page =~ r4
      subject[:type] = "pt_plt"
      subject[:id] = page.split('/')[3].to_i # multigroup id
    elseif page =~ r5
      subject[:type] = "pt_plt"
      subject[:id] = page.split('/')[3].split('-')[1].to_i # multigroup id
    end
    return subject
  end

  def create_page_stat(switcher, hash={})
    subject = spot_subject(hash[:page])
    subject[:type] = hash[:subject_type].nil? ? subject[:type] : hash[:subject_type]
    subject[:id] = hash[:subject_id].nil? ? subject[:id] : hash[:subject_id]
    subject.each { |key, value| hash[key] = value }

    case switcher
    when 'Month'
      PagesByMonth.create(company_id: hash[:company_id],
                            date: hash[:beginning_of_month],
                            page: hash[:page],
                            pages: hash[:pages_count],
                            subject_type: hash[:type],
                            subject_id: hash[:id])
    when 'Week'
      PagesByWeek.create(company_id: hash[:company_id],
                          first_week_day: hash[:first_week_day],
                          last_week_day: hash[:last_week_day],
                          year: hash[:year],
                          week: hash[:week],
                          page: hash[:page],
                          pages: hash[:pages_count],
                          subject_type: hash[:type],
                          subject_id: hash[:id])
    end
  end

  def update_page_stat(switcher, id, hash={})
    case switcher
    when 'Month'
      pages = PagesByMonth.select("pages").where(id: id).first.pages
      puts 'Pages: ' + pages.to_s
      v = pages.to_i + hash[:pages_count]
      PagesByMonth.update(id, pages: v)
    when 'Week'
      pages = PagesByWeek.select("pages").where(id: id).first.pages
      puts 'Pages: ' + pages.to_s
      v = pages.to_i + hash[:pages_count]
      PagesByWeek.update(id, pages: v)
    end
  end

  def create_referers_stat(company_id, referer, source_id=1, internal=true, pages=1, date=@date)
    d = beginning_of_month(date)
    h = week_parameters(date)

    ReferersByMonth.create(company_id: company_id,
                            date: d,
                            referer: referer,
                            pages: pages,
                            source_id: source_id,
                            is_internal: internal)
    ReferersByWeek.create(company_id: company_id,
                            first_week_day: h["first_week_day"],
                            last_week_day: h["last_week_day"],
                            year: h["year"],
                            week: h["week"],
                            referer: referer,
                            pages: pages,
                            source_id: source_id,
                            is_internal: internal)
  end

  def create_activities_stat(company_id, action='phone_hits', date=@date, value=1)
    d = beginning_of_month(date)
    h = week_parameters(date)

    ActivitiesTotal.create(company_id: company_id,
                            action: action,
                            value: value)
    ActivitiesByDay.create(company_id: company_id,
                            date: date,
                            action: action,
                            value: value)
    ActivitiesByWeek.create(company_id: company_id,
                            first_week_day: h["first_week_day"],
                            last_week_day: h["last_week_day"],
                            year: h["year"],
                            week: h["week"],
                            action: action,
                            value: value)
    ActivitiesByMonth.create(company_id: company_id,
                            date: d,
                            action: action,
                            value: value)
  end

  def create_total_stat
  end

  def create_geo_stat
  end

  def pages(hash={})
    return if hash[:company_id].nil?
    return if hash[:page].nil?

    hash[:date] = hash[:date].nil? ? @date : (Date.parse(hash[:date]) if !hash[:date].instance_of? Date)
    hash[:pages_count] = 1 if hash[:pages_count].nil?
    hash[:beginning_of_month] = beginning_of_month(hash[:date]) if hash[:beginning_of_month].nil?
    week_parameters(hash[:date]).each {|key, value| hash[key] = value} if hash[:first_week_day].nil?

    pmonths = PagesByMonth.where(company_id: hash[:company_id],
                        page: hash[:page],
                        date: hash[:beginning_of_month])
    pmonths.empty? ? (create_page_stat('Month', hash)) : (update_page_stat('Month', pmonths.first.id, hash))
    pweeks = PagesByWeek.where(company_id: hash[:company_id],
                        first_week_day: hash[:first_week_day],
                        last_week_day: hash[:last_week_day],
                        year: hash[:year],
                        week: hash[:week],
                        page: hash[:page])
    pweeks.empty? ? (create_page_stat('Week', hash)) : (update_page_stat('Week', pweeks.first.id, hash))
  end
end
