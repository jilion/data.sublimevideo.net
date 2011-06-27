express = require('express')
app     = express.createServer express.logger()

app.get '/', (request, response) ->
  response.send 'Hi!'

app.listen process.env.PORT || 3000