# 事前準備
# .envファイルに次の行を追加
# LINE_CHANNEL_SECRET=hogehoge
# LINE_CHANNEL_TOKEN=hogehoge

# 実行方法
# 全ユーザーにテキスト配信
# bundle exec rails runner "LineBot::MessageApi.new.broadcast_text('test')"

class LineBot::MessageApi

  def broadcast_text(text)
    broadcast(
      type: 'text',
      text: text
    )
  end

  def broadcast(messages)
    client.broadcast(messages)
  end

  private

  def client
    @client ||= ::Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end
end