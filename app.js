(function() {
  var app, express;
  express = require('express');
  app = express.createServer(express.logger());
  app.get('/', function(request, response) {
    return response.send('Hi!');
  });
  app.listen(process.env.PORT || 3000);
}).call(this);
