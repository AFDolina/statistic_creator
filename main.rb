require 'yaml'
require 'date'

require_relative 'lib/connection.rb'

require_relative 'lib/models/activities.rb'
require_relative 'lib/models/geo.rb'
require_relative 'lib/models/pages.rb'
require_relative 'lib/models/referers.rb'
require_relative 'lib/models/total.rb'

require_relative 'lib/parts/pages.rb'
require_relative 'lib/parts/referers.rb'
require_relative 'lib/parts/activities.rb'

class StatisticCreator
  include Part::Page
  include Part::Referer
  include Part::Activities

  def initialize(company_id, d=Date.today)
    @company_id = company_id
    @date = (d.instance_of? Date) ? d : Date.parse(d)
    stand = ARGV[1]
    class_conf = YAML.load_file("config/#{stand}.yml")
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

  def referers(hash={})
    hash[:company_id] = @company_id if hash[:company_id].nil?

    hash[:date] = hash[:date].nil? ? @date : ((hash[:date].instance_of? Date) ? hash[:date] : Date.parse(hash[:date]))
    hash[:pages] = 1 if hash[:pages].nil?
    hash[:beginning_of_month] = beginning_of_month(hash[:date]) if hash[:beginning_of_month].nil?
    week_parameters(hash[:date]).each {|key, value| hash[key] = value} if hash[:first_week_day].nil?

    hash[:referer] = '' if hash[:referer].nil?

    rmonths = ReferersByMonth.where(company_id: hash[:company_id],
                        referer: hash[:referer],
                        date: hash[:beginning_of_month])
    rmonths.empty? ? (create_referer_stat('Month', hash)) : (update_referer_stat('Month', rmonths.first.id, hash))

    rweeks = ReferersByWeek.where(company_id: hash[:company_id],
                        first_week_day: hash[:first_week_day],
                        last_week_day: hash[:last_week_day],
                        year: hash[:year],
                        week: hash[:week],
                        referer: hash[:referer])
    rweeks.empty? ? (create_referer_stat('Week', hash)) : (update_referer_stat('Week', rweeks.first.id, hash))
  end

  def pages(hash={})
    hash[:company_id] = @company_id if hash[:company_id].nil?
    return if hash[:page].nil?

    hash[:date] = hash[:date].nil? ? @date : ((hash[:date].instance_of? Date) ? hash[:date] : Date.parse(hash[:date]))
    hash[:pages] = 1 if hash[:pages].nil?
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



  def activities(hash={})
    hash[:company_id] = @company_id if hash[:company_id].nil?
    return if hash[:action].nil?

    hash[:date] = hash[:date].nil? ? @date : ((hash[:date].instance_of? Date) ? hash[:date] : Date.parse(hash[:date]))
    hash[:value] = 1 if hash[:value].nil?
    hash[:beginning_of_month] = beginning_of_month(hash[:date]) if hash[:beginning_of_month].nil?
    week_parameters(hash[:date]).each {|key, value| hash[key] = value} if hash[:first_week_day].nil?

    amonths = ActivitiesByMonth.where(company_id: hash[:company_id],
                        action: hash[:action],
                        date: hash[:beginning_of_month])
    amonths.empty? ? (create_activities_stat('Month', hash)) : (update_activities_stat('Month', amonths.first.id, hash))

    aweeks = ActivitiesByWeek.where(company_id: hash[:company_id],
                        first_week_day: hash[:first_week_day],
                        last_week_day: hash[:last_week_day],
                        year: hash[:year],
                        week: hash[:week],
                        action: hash[:action])
    aweeks.empty? ? (create_activities_stat('Week', hash)) : (update_activities_stat('Week', aweeks.first.id, hash))

    aday = ActivitiesByDay.where(company_id: hash[:company_id],
                        action: hash[:action],
                        date: hash[:date])
    aday.empty? ? (create_activities_stat('Day', hash)) : (update_activities_stat('Day', aday.first.id, hash))

    atotal = ActivitiesTotal.where(company_id: hash[:company_id],
                        action: hash[:action])
    atotal.empty? ? (create_activities_stat('Total', hash)) : (update_activities_stat('Total', atotal.first.id, hash))
  end

  def create_total_stat
  end

  def create_geo_stat
  end
end
