Rails.application.routes.draw do
  # ログインしてない時のパス
  root 'tops#index'
end
