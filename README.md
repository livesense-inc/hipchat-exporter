HipChat Exporter
================

[![CircleCI](https://circleci.com/gh/livesense-inc/hipchat-exporter.svg?style=svg)](https://circleci.com/gh/livesense-inc/hipchat-exporter)

Export the history (messages) of rooms from HipChat.

## Motivation

* [なぜ本ツールを作成するのか？（in Japanese）](https://github.com/livesense-inc/hipchat-exporter/issues/1)

## Requirements

* Ruby 2.5.0
* MySQL
  * [Why this tool need a database? (in Japanese)](https://github.com/livesense-inc/hipchat-exporter/issues/6#issuecomment-364744048)
  * version 5.6.4+, why? -> The date in HipChat need microseconds (6 digits) precision
    * [MySQL :: MySQL 5.6 Reference Manual :: 11.3.6 Fractional Seconds in Time Values](https://dev.mysql.com/doc/refman/5.6/en/fractional-seconds.html)
    * [MySQL :: MySQL 5.6 リファレンスマニュアル :: 11.3.6 時間値での小数秒](https://dev.mysql.com/doc/refman/5.6/ja/fractional-seconds.html)
  * utf8mb4, why? -> The messages in HipChat include emoji

## Usage

### (1) Export the history of rooms to JSON files

```
# bundle exec thor help history:export
Usage:
  thor task:history:export

Options:
  [--from=FROM]  # Date (or Time) like "20180101"
  [--to=TO]      # Date (or Time), like "20180131", default is Time.current
  [--threads=N]  # Threads count for speedup blocking operations
  [--force]      # Skip asking questions
```

Example:

```
bundle exec thor task:history:export --from=20171101 --to=20171107 --threads=20
```

### (2) Save the history of rooms to DB

```
bundle exec thor task:history:save
```

## Setup

```
git clone git@github.com:livesense-inc/hipchat-exporter.git
cd hipchat-exporter
```

```
bundle install --path vendor/bundle
bundle exec rake db:create
bundle exec rake db:migrate
```

```
cp .env.example .env
```

Fill `HIPCHAT_TOKEN` in `.env`

```
cp rooms.csv.example rooms.csv
```

Fill room_id and room_name in `rooms.csv` (room_name is optional)

## Testing

```
bundle exec rspec
```
