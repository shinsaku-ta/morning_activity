# require File.expand_path(File.dirname(__FILE__) + '/environment')
#
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# every :hour do # 1.minute 1.day 1.week 1.month 1.year is also supported
#   rake 'check_state:auto_tweet'
# end
