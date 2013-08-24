class Game
  constructor: () ->
    @squares = []
    @player = new Player(this)
    @map = $("#map canvas")[0]
    @map.width = 1000
    @map.height = 600
    @squareList = []
    @setupHandlers()
    @preloaded = false
    @waiting_click = ""

  setupHandlers: () ->
    $('body').on 'click', '#move', (e) =>
      e.preventDefault()
      @moveHighlight()
    $('body').on 'click', '.spell', (e) =>
      e.preventDefault()
      cardId = e.target.id.replace("card_", '')*1
      for card in @player.deck when card.id == cardId
        if card.range == 0
          card.cast()
        else
          card.highlight(this)

    $(@map).on 'click', (e) =>
      e.preventDefault()
      switch @waiting_click
        when "move"
          @player.move(e)
      @draw()

  addSquare: (square) ->
    @squareList[square.index - 1] = square
    @squares[square.x - 1] = [] unless $.isArray(@squares[square.x - 1])
    @squares[square.x - 1][square.y - 1] = square.index

  draw: (callback)->
    if(!@ctx)
      @ctx = @map.getContext('2d')
    images = $("#map .images img")
    width = @map.width
    height = @map.height
    @ctx.clearRect(0, 0, width, height)
    uris = (image.src for image in images)
    if @preloaded
      @drawGrid(callback, images)
    else
      $.promises.preloadImages(uris).done =>
        @preloaded = true
        @drawGrid(callback, images)


  drawGrid: (callback, images) ->
    for y in [(@map.height/50)..0]
      for x in [(@map.width/50)..0]
        if @squares[x] && @squares[x][y]
          if @squares[x][y] == "dead"
            @ctx.drawImage(images[3],x*50,y*50)
          else
            @ctx.drawImage(images[1],x*50,y*50)
          if @player.square == @squares[x][y]
            @ctx.drawImage(images[2],x*50, y*50)
        else
          @ctx.drawImage(images[0],x*50,y*50)
    callback.call() if callback

  moveHighlight: () ->
    @highlight("rgba(0, 0, 200, 0.5)", @player.validSquares(@player.moveDistance), "move")

  highlight: (color, toHighlight, eventName) ->
    @draw =>
      $('#map').removeClass()
      $("#map").addClass(eventName)
      @waiting_click = eventName
      for square in toHighlight
        @ctx.fillStyle = color
        @ctx.fillRect((square.x - 1)*50, (square.y-1)*50, 50, 50)

window.Game = Game