Rails.application.routes.draw do
  # ログインしてない時のパス
  root 'tops#index'

  post '/line_message/callback', to: 'line_message_api#callback'
end
