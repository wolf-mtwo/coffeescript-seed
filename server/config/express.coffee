express = require 'express'
glob = require 'glob'

module.exports = (app, config) ->
  app.set 'views', config.root + '/views'
  app.engine 'html', require('ejs').renderFile
  app.set 'view engine', 'html'
  app.use express.static config.root + '/public'

  models = glob.sync config.root + '/models/**/*.js'
  models.forEach (model) ->
    require(model)

  controllers = glob.sync config.root + '/controllers/**/*.js'
  controllers.forEach (controller) ->
    require(controller)(app)

  # catch 404 and forward to error handler
  app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

  # error handlers

  # development error handler
  # will print stacktrace
  if app.get('env') == 'development'
    app.use (err, req, res, next) ->
      res.status err.status || 500
      res.render 'error',
        message: err.message
        error: err
        title: 'error'

  # production error handler
  # no stacktraces leaked to user
  app.use (err, req, res, next) ->
    res.status err.status || 500
    res.render 'error',
      message: err.message
      error: {}
      title: 'error'
