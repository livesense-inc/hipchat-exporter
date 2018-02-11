HipChat Exporter
================

[![CircleCI](https://circleci.com/gh/livesense-inc/hipchat-exporter.svg?style=svg)](https://circleci.com/gh/livesense-inc/hipchat-exporter)

Export the history (messages) of rooms from HipChat.

## Requirements

* Ruby 2.5.0

## Usage

Export the history of rooms to JSON files.

```
bundle exec thor help history:export
```

```
Usage:
  thor history:export

Options:
  [--from=FROM]
  [--to=TO]
```

Example:

```
bundle exec thor history:export --from=20171101 --to=20171107
```

## Setup

```
git clone git@github.com:livesense-inc/hipchat-exporter.git
cd hipchat-exporter
```

```
bundle install --path vendor/bundle
```

```
cp .env.sample .env
```

Fill `HIPCHAT_TOKEN` in `.env`

## Testing

```
bundle exec rspec
```
