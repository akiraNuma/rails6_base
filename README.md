## dockerでrailsの開発環境構築手順
  * プロジェクトをクローンした場合は1から
  0. rails new 準備
    ` docker-compose run app rails new . --force --database=postgresql --webpack=vue --skip-bundle`でrails newする
    `docker-compose run app rails webpacker:install`する
  1. `docker-compose build`する
  2. db作成
    ```
      docker-compose run app rails db:create
      docker-compose run app rails db:migrate
    ```
  3. webpacker install
    ```
      docker-compose run app rails webpacker:install
      docker-compose run app rails webpacker:install:vue
    ```
    後から参加する人は
    上のコマンドじゃなくて
    `yarn install`

## TODO
  * docekr-compose.prd.yml作る
  * docekr-compose.tor.yml作る
