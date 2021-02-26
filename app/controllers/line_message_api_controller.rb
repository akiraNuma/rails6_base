class LineMessageApiController < ApiController
  before_action :validate_signature

  # ルーティングで設定したcallbackアクションを呼び出す
  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Image
          message_id = event.message['id']
          response = client.get_message_content(message_id)
          tf = Tempfile.open("content")
          tf.binmode
          tf.write(response.body)
          reply_text(event, "[MessageType::IMAGE]\nid:#{message_id}\nreceived #{tf.size} bytes data")
        when Line::Bot::Event::MessageType::Video
          message_id = event.message['id']
          response = client.get_message_content(message_id)
          tf = Tempfile.open("content")
          tf.binmode
          tf.write(response.body)
          reply_text(event, "[MessageType::VIDEO]\nid:#{message_id}\nreceived #{tf.size} bytes data")
        when Line::Bot::Event::MessageType::Audio
          message_id = event.message['id']
          response = client.get_message_content(message_id)
          tf = Tempfile.open("content")
          tf.binmode
          tf.write(response.body)
          reply_text(event, "[MessageType::AUDIO]\nid:#{message_id}\nreceived #{tf.size} bytes data")
        when Line::Bot::Event::MessageType::File
          message_id = event.message['id']
          response = client.get_message_content(message_id)
          tf = Tempfile.open("content")
          tf.binmode
          tf.write(response.body)
          reply_text(event, "[MessageType::FILE]\nid:#{message_id}\nfileName:#{event.message['fileName']}\nfileSize:#{event.message['fileSize']}\nreceived #{tf.size} bytes data")
        when Line::Bot::Event::MessageType::Sticker
          handle_sticker(event)
        when Line::Bot::Event::MessageType::Location
          handle_location(event)
        when Line::Bot::Event::MessageType::Text
          # オウム返し
          reply_text(event, event.message["text"])

          # # プロフィール
          # profile = client.get_profile(event['source']['userId'])
          # profile = JSON.parse(profile.read_body)
          # reply_text(event, [
          #   "Display name\n#{profile['displayName']}",
          #   "Status message\n#{profile['statusMessage']}",
          # ])

          # # ボタンの選択肢
          # # ref https://developers.line.biz/ja/reference/messaging-api/#template-messages
          # reply_content(event, {
          #   type: 'template',
          #   altText: 'Buttons alt text',
          #   template: {
          #     type: 'buttons',
          #     # thumbnailImageUrl: THUMBNAIL_URL,
          #     title: 'My button sample',
          #     text: 'Hello, my button',
          #     actions: [
          #       { label: 'Go to line.me', type: 'uri', uri: 'https://line.me', altUri: {desktop: 'https://line.me#desktop'} },
          #       { label: 'Send postback', type: 'postback', data: 'hello world' },
          #       { label: 'Send postback2', type: 'postback', data: 'hello world', text: 'hello world' },
          #       { label: 'Send message', type: 'message', text: 'This is message' }
          #     ]
          #   }
          # })
        end
      end
    end
    head :ok
  end

  private

  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
  end

  def client
    @client ||= ::Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end

  def reply_text(event, texts)
    texts = [texts] if texts.is_a?(String)
    client.reply_message(
      event['replyToken'],
      texts.map { |text| {type: 'text', text: text} }
    )
  end

  def reply_content(event, messages)
    res = client.reply_message(
      event['replyToken'],
      messages
    )
    logger.warn res.read_body unless Net::HTTPOK === res
    res
  end

  # スタンプ
  def handle_sticker(event)
    # Message API available stickers
    # https://developers.line.me/media/messaging-api/sticker_list.pdf
    msgapi_available = event.message['packageId'].to_i <= 4
    messages = [{
      type: 'text',
      text: "[スタンプ]\npackageId: #{event.message['packageId']}\nstickerId: #{event.message['stickerId']}"
    }]
    if msgapi_available
      messages.push(
        type: 'sticker',
        packageId: event.message['packageId'],
        stickerId: event.message['stickerId']
      )
    end
    reply_content(event, messages)
  end

  # 位置情報
  def handle_location(event)
    message = event.message
    messages = [{
      type: 'text',
      text: "[位置情報]\ntitle: #{message['title'] || message['address']}\naddress: #{message['address']}\nlatitude: #{message['latitude']}\nlongitude: #{message['longitude']}"
    }]
    messages.push(
      type: 'location',
      title: message['title'] || message['address'],
      address: message['address'],
      latitude: message['latitude'],
      longitude: message['longitude']
    )
    reply_content(event, messages)
  end
end