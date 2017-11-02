# d2e

DocBaseからesa.ioへのインポートスクリプトのサンプルです

# スクリプトを使った移行の流れ

## メンバーの紐付けの準備

- Docbase上で、memmber全員の「名前」を「ユーザーID (半角小英数) 」と同一に揃えてください
- docbase上のユーザーをesaに招待し、「ScreenName」をdocbase上の「ユーザーID (半角小英数) 」と同じにして下さい

これらは、メンバーの紐付けのために必要です。この作業を行わなくても移行は行なえますが、システムが投稿した記事やコメントの扱いになります。

## スクリプトの用意

※ スクリプトの作成・動作確認はRuby2.4.1で行っております

```
$ git clone https://github.com/fukayatsu/d2e.git
$ bundle install
$ cp config.sample.yml config.yml
```

次に、

- JSON形式でダウンロードした3つのzipを全てzipディレクトリに配置します
  - esaでは同じチーム内での記事の閲覧権限は全員同じなので、全員が閲覧できてまずいドキュメントはこの段階で削除して下さい
- `config.yml` にAPIトークンや設定を記述します
- 必要に応じてimporter.rbの内容を変更します。
  - docbase上のデータをesa上のデータに変更する部分を主に調整していただくと良さそうです。
    - => https://github.com/fukayatsu/d2e/blob/master/lib/converter.rb

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
