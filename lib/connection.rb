require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

#blizko staging3
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: '172.31.47.5',
  port: '6432',
  database: 'blizko_stat_test',
  username: 'blizko',
  password: 'uChaet9ahg7z',
  prepared_statements: false
)
