ssh 172.31.47.1 'sudo -u blizko bash' << EOF
. ~/.bashrc
bundle exec rails runner 'date = ENV['date'].nil? ? Date.today : Date.parse(ENV['date'])
Apress::CompanyStatistics::PagesByWeek.add_partition(date)
Apress::CompanyStatistics::PagesByMonth.add_partition(date)

Apress::CompanyStatistics::ActivitiesByDay.add_partition(date)
Apress::CompanyStatistics::ActivitiesByWeek.add_partition(date)
Apress::CompanyStatistics::ActivitiesByMonth.add_partition(date)

Apress::CompanyStatistics::ReferersByWeek.add_partition(date)
Apress::CompanyStatistics::ReferersByMonth.add_partition(date)

Apress::CompanyStatistics::GeoByWeek.add_partition(date)
Apress::CompanyStatistics::GeoByMonth.add_partition(date)

Apress::CompanyStatistics::TotalByDay.add_partition(date)
Apress::CompanyStatistics::TotalByWeek.add_partition(date)
Apress::CompanyStatistics::TotalByMonth.add_partition(date)'
EOF
