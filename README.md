## dockerでrailsの開発環境構築手順
  * プロジェクトをクローンした場合は1から
  0. rails new 準備
    `docker-compose run --rm app rails new . --force --database=postgresql --webpack=vue --skip-bundle`でrails newする
    `docker-compose run --rm app rails webpacker:install`する
  1. `docker-compose build`する
  2. yarn install
    ```
      docker-compose run --rm app yarn install
    ```
  3. db作成
    ```
      docker-compose run --rm app rails db:create db:migrate db:seed
    ```

## TODO
  * docekr-compose.prd.yml作る
  * docekr-compose.tor.yml作る
