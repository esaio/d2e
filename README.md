# d2e

DocBaseからesa.ioへのインポートスクリプトのサンプルです

# TODO

- [ ] userのマッピング
- [ ] 画像、添付ファイルの再アップロード
- [ ] 動作確認

# スクリプトを使った移行の流れ

## スクリプトの用意

```
$ git clone https://github.com/fukayatsu/d2e.git
$ bundle install
$ cp config.sample.yml config.yml
$ cp users.sample.yml  users.yml
```

次に、

- JSON形式でダウンロードした3つのzipを全てzipディレクトリに配置します
- `config.yml` にAPIトークンや設定を記述します
- `users.yml` にdocbase上のユーザー名とesa上のユーザー名の紐付けを記述します
- 必要に応じてimporter.rbの内容を変更します。

## スクリプトの動作確認(Dry Run)

```
$ bundle exec ruby app.rb
```

ここでは、まだ実際には移行が行われません。
移行された場合にどうなるか出力されます

## インポート実行

Dry Runの出力が問題なければ、実際にインポートを実行します。
※ スクリプトの実行前に、esa運営チームにご連絡頂ければAPI制限の一時引き上げなどが可能です。

```
$ bundle exec ruby app.rb --run
```
