express   = require 'express'
app       = express.createServer express.logger()

Mongolian = require 'mongolian'
server = new Mongolian 'swan.mongohq.com:27021'
db     = server.db 'app182505'
db.auth 'heroku', 'vnfv66001682rqdvzd4k9k'
usages = db.collection 'site_usages_test'

today = () ->
  date  = new Date
  milli = Date.UTC date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()
  new Date(milli)

app.get '/', (req, res) ->
  res.send 'Hi!'

app.get '/p/:token', (req, res) ->
  usages.update { 't' : req.params.token, 'd' : today() }, { '$inc': { 'p': 1 } }, true
  res.header "Content-Type", "text/javascript"
  res.send 'sublimeVideo.pInc=true'

app.listen process.env.PORT || 3000