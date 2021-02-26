# 事前準備
# .envファイルに次の行を追加
# LINE_NOTIFY_API_TOKEN=hogehoge

# 実行方法
# bundle exec rails runner "LineBot::NotifyApi.new.send_notify('test')"

require 'json'
require 'net/http'
require 'uri'

class LineBot::NotifyApi
  LINE_NOTIFY_API_TOKEN = ENV['LINE_NOTIFY_API_TOKEN']
  LINE_NOTIFY_API_URI = URI.parse('https://notify-api.line.me/api/notify')

  def send_notify(msg)
    post_notify(LINE_NOTIFY_API_TOKEN, msg)
  end

  private

  def post_notify(token, msg)
    request = Net::HTTP::Post.new(LINE_NOTIFY_API_URI)
    request['Authorization'] = "Bearer #{token}"
    request.set_form_data(message: msg)
    response = Net::HTTP.start(LINE_NOTIFY_API_URI.hostname, LINE_NOTIFY_API_URI.port, use_ssl: LINE_NOTIFY_API_URI.scheme == "https") do |https|
      https.request(request)
    end
  end
end