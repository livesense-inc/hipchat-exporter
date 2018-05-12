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
* HipChat API Token:

![image](https://user-images.githubusercontent.com/634357/39954552-b3398b28-55fc-11e8-90fe-93050a81ce61.png)

## Usage

### Step 1) Export rooms and save them to DB

```
bundle exec thor task:room:export
```

### Step 2) Export the history of rooms to JSON files

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

### Step 3) Save the history of rooms to DB

```
bundle exec thor task:history:save
```

### Step 4) Export the messages to CSV files

```
bundle exec thor task:message:export
```

The messages CSV files are exported to `dist` directory.

### Step 5) Import messages CSV files to Slack

* [Import message history – Slack Help Center](https://get.slack.help/hc/en-us/articles/201748703-Import-message-history)
* [メッセージ履歴をインポートする（Japanese）](https://get.slack.help/hc/ja/articles/201748703-%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8%E5%B1%A5%E6%AD%B4%E3%82%92%E3%82%A4%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%88%E3%81%99%E3%82%8B)

### Other (show task list)

```
bundle exec thor -T
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

## Debugging

```
bundle exec pry
```

## Testing

```
bundle exec rspec
```

## Other

### Reset the database

db:reset -> db:drop && db:create && db:migarete

```
bundle exec rake db:reset
```

### Map room names in CSV file and rooms in DB and show room id list

```
cp room_names.csv.example room_names.csv
```

Fill room names `room_names.csv`

```
bundle exec thor task:room:export
bundle exec thor task:room:map
```

### Show tasks list

```
bundle exec thor -T
```

```
task
----
thor task:history:clear   # Remove room history JSON files
thor task:history:export  # Export the history of rooms to JSON files
thor task:history:save    # Save the history of rooms to DB
thor task:message:clear   # Remove messages CSV files
thor task:message:export  # Export the messages to CSV files
thor task:room:export     # Export rooms and save them to DB
thor task:room:map        # Map room names in CSV file and room ids in DB
```
