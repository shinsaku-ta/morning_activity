namespace :check_state do
  desc 'check_state'

  task auto_tweet: :environment do
    # 全てのユーザーを取得
    users = User.all

    users.each do |user|
      # 本日のデータが存在し、stateが予定日状態のものだけを取得
      result = user.morning_activity_results.where(execution_at: Date.current.all_day, state: :not_implemented)
      if result
        # stateをfailedに変更
        if result.update(state: :failed)
          # 自動ツイートを実施
          # twitter_client(user.authentication)
          # @client.update("#{user.post_picture}\r")
        end
      end
    end
  end

  # private

  # def twitter_client(key)
  #   @client = Twitter::REST::Client.new do |config|
  #     config.twitter.key = Settings.twitter_key
  #     config.twitter.secret = Settings.twitter_secret
  #     config.access_token = key.access_token
  #     config.access_token_secret = key.access_token_secret
  #   end
  # end
end
