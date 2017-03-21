require 'active_record'
require 'yaml'

stand = ARGV[1]
PARAM = YAML.load_file("config/#{stand}.yml")

ActiveRecord::Base.logger = Logger.new(STDERR)

#blizko staging3
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: PARAM['host'],
  port: PARAM['port'],
  database: PARAM['db'],
  username: PARAM['username'],
  password: PARAM['password'],
  prepared_statements: false
)
