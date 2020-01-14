namespace :check_state do
  desc 'check_state'

  task auto_tweet: :environment do
    # 全てのユーザーを取得
    users = User.all

    users.each do |user|
      # 本日のデータが存在し、stateが予定日状態のものだけを取得
      result = user.morning_activity_results.find_by(execution_at: Date.current.all_day, state: :not_implemented)
      # データがなければ次へ
      next unless result
      # stateをfailedにできなければ次へ
      next unless  result.failed!

      # 自動ツイートを実施
      twitter_client(user.authentications.first)
      tweet = "私は今日、朝活をサボってしまいました。\r次回はサボらないことをここに誓います。"
      if user.post_picture.attached?
        media_url = user.post_picture_path
      else
        media_url = "#{Rails.root}/app/assets/images/picture.jpg"
      end
      media = open(media_url)
      @client.update_with_media(tweet, media)
      media.close
    end
  end

  private

  def twitter_client(key)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Settings.twitter_key
      config.consumer_secret = Settings.twitter_secret
      config.access_token = key.access_token
      config.access_token_secret = key.access_token_secret
    end
  end
end
