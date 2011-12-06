# SublimeVideo Async Data Server (Cramp)

## Installation

copy `.gitconfig` content to `.git/config`

``` bash
bundle install
```

## Development

Running thin:

``` bash
bundle exec thin --max-persistent-conns 1024 --timeout 0 -R config.ru start
```
Vebose mode (Very useful when you want to view all the data being sent/received by thin):

``` bash
bundle exec thin --max-persistent-conns 1024 --timeout 0 -V -R config.ru start
```

## Documentations

- [http://cramp.in](http://cramp.in)

## Deployment

``` bash
git push production
```
