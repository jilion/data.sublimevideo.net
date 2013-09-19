# SublimeVideo Async Data2 Server (Rack + Puma)

## Installation

copy `.gitconfig` content to `.git/config`

``` bash
bundle install
```

## Development

Running:

``` bash
bundle exec rackup
```

## Deployment

``` bash
git push production2
```

# PROTOCOL

Data request are sent in that order of fallback:

1. CORS request on data.sublimevideo.net
2. GIF request on data.sublimevideo.net, if CORS not supported.
3. GIF request on cdn.sublimevideo.net (EdgeCast logs), if data.sublimevideo.net isn't responding.

## CORS requests

CORS requests are always sent to the same url via POST HTTP(S):

`POST //data.sublimevideo.net/d/<SITE TOKEN>.json`

The params (json) sent can include multiples requests event types (load, play, video tag data, video tag crc32 hash request) in any order all sent via an array, ie:

```
[
  { e: 'al', ... # app load event params },
  { e: 'l', ...  # video load event params },
  { e: 'l', ...  # video load event params },
  { e: 's', ...  # video start event params },
  { e: 'v', ...  # video tag data params }
]
```

All requests will be managed and parsed separately by the server.

Some request types can give a response (like 'video load') so in some case an array of responses (json) can be sent back. Order of responses aren't related to order of requests.

## GIF request

Requests done on data.sublimevideo.net or cdn.sublimevideo.net have the same query param.

`GET //data|cdn.sublimevideo.net/_.gif?i=<TIMESTAMP>&s=<SITE TOKEN>&d=<JSON EVENTS ESCAPED>`

Query param is the same as the JSON (escaped) sent via CORS so a GIF request can sent multiple events at once. Be aware that HTTP GET request are limited to 2048 characters on <= IE8 (http://support.microsoft.com/kb/208427) so in some case a request must be split in multiple shorter GIF requests.

## Events:

### App load (al)

Done on Page Visit (on app load). Request params:

```
{
  e: 'al',
  ho: <hostname>, # m:main, e:extra, s:staging, d:dev, i:invalid
  ss*: <ssl>, # 1, not sent if http
  st: <version stage>, # s:stable, b:beta, a:alpha
  dt: <document title>, # (parent.)document.title
  fv*: <flash version>, # not sent if not installed
  jq*: <jquery version>, # not sent if not used
  sr: <screen resolution>, # '2400x1920'
  sd: <screen dpr>, # window.devicePixelRatio (1 if not def)
  bl*: <browser language>, # 'pt-br'
}
```

(*) optional param, nil/false if not present

No respond need to be sent back.

### Video load (l)

Done for each video loaded (via DOM or API).

#### Request params:

```
{
  e: 'l',
  u*: <video uid>, # only if valid
  ho: <hostname>, # m:main, e:extra, s:staging, d:dev, i:invalid
  de: <device>, # d:desktop, m:mobile
  te: <tech>: # h:html5, f:flash, y:youtube, d:dailymotion
  ex*: <external>, # 1, if (parent.)document.url is external
  em*: <embedded>, # 1, only sent if embedded
}
```

(*) optional param, nil/false if not present

#### Response params:

```
{
  e: 'l',
  u: <video uid>,
  h: <video tag crc32 hash on dasv side>
}
```

### Video start (s)

Done for each video started (via DOM or API). Request params:

```
{
  e: 's',
  u*: <video uid>, # only if valid
  ho: <hostname>, # m:main, e:extra, s:staging, d:dev, i:invalid
  de: <device>, # d:desktop, m:mobile
  te: <tech>: # h:html5, f:flash (include YouTube hack for now)
  ex*: <external>, # 1, if (parent.)document.url is external
  em*: <embedded>, # 1, only sent if embedded
  du: <document url>, document.href (document.referrer for embeds)
  ru*: <referrer url>, document.referrer (nil for embeds)
  vd*: <video duration>, # "123456" (in miliseconds, nil if streaming)
  vsr*: <video source resolution>, # '400x300'
}
```

(*) optional param, nil/false if not present

No respond need to be sent back.

### VideoTag data (v) - CORS ONLY

Done via CORS only, in response of l.

This request is sent when the video tag crc32 hash returned differ from the one generated by the player. This event type (v) sends all video tag data needed to re-generate the video tag (data-settings, sources, poster,... everything!)

Request params:

```
{
  e: 'v',
  h: <new video tag crc32 hash>,
  # ... SEE LIST BELOW
}
```

```
h, new Video tag crc32 hash, e.g. h: "23ads4ad"
u, Video uid, e.g. u: "asd123ef"
i*, Video id (sublimevideo hosting or youtube), e.g. i: "12asd2ea"
io*, Video id origin  (sublimevideo/youtube), e.g. io: "sv" / io: "y"
t*, Video title, e.g. n: "My Awesome Video"
p*, Video poster url, e.g. p: "http://posters.sublimevideo.net/123asda3.png"
z, Player size, e.g. z: "400x300"
s*, Video sources hash, see below params for each source
a*, Video data attributes (settings) hash.
o*, Video options hash (ie. { autoembed: true })
```

(*) optional param, nil/false if not present

Video sources of hash params:

```
s: [{
  u: "<video source url>",
  q: "<video source quality (hd/base)>",
  f:  "<video source family (mp4/webm/ogg)>"
  },
  # other sources...
]
}
```
No respond need to be sent back.
