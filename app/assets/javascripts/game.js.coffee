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
    @monsters = []
    @monsterTimer = null
    @currentHighlight = null
    @monsterMap = []
    @wave = 0

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
      @currentHighlight = null
      e.preventDefault()
      switch @waiting_click
        when "move"
          @player.move(e)
        when "spell"
          @activeCard.cast(e)
      @draw()

  spawnMonsters: () ->
    @monsterTimer = window.setInterval(@spawnWave, 10000)

  spawnWave: () ->
    game = window.current_game
    game.wave += 1
    monsterEntranceSquare = game.squareList[game.squareList.length - 1]
    console.log(monsterEntranceSquare)
    bossPresent = false
    for template in game.monsterTemplates
      number = 0
      if template.difficulty > 2 && @wave % 5 == 0
        unless @bossPresent
          number = Math.floor(Math.random(1))
          bossPresent = true if number > 0
      else if template.difficulty == 2
        number = Math.ceil(Math.random(3))
      else
        number = Math.ceil(Math.random(6))
      if number > 0
        for n in [1..number]
          monster = new Monster(template, game)
          game.monsters.push(monster)
          monster.spawn(monsterEntranceSquare)
          x = monster.squareObj().x
          y = monster.squareObj().y
          unless $.isArray(game.monsterMap[x])
            game.monsterMap[x] = []
          unless $.isArray(game.monsterMap[x][y])
            game.monsterMap[x][y] = []
          game.monsterMap[x][y].push(monster)
    game.draw()


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
          # console.log(@monsterMap[x])
          if @monsterMap[x] && @monsterMap[x][y]
            console.log(@monsterMap[x][y])
            @ctx.fillText(@monsterMap[x][y].name,x*50, y*50)
        else
          @ctx.drawImage(images[0],x*50,y*50)
    @currentHighlight.call() if @currentHighlight

  moveHighlight: () ->
    @highlight("rgba(100, 200, 100, 0.3)", @player.validSquares(@player.moveDistance), "move")

  highlight: (color, toHighlight, eventName) ->
    @currentHighlight = =>
      @activeCard = null
      $('#map').removeClass()
      $("#map").addClass(eventName)
      @waiting_click = eventName
      for square in toHighlight
        @ctx.fillStyle = color
        @ctx.fillRect((square.x - 1)*50, (square.y-1)*50, 50, 50)
    @draw()

  getSquare: (e) =>
    return null unless e
    if e.pageX || e.pageY
      x = e.pageX
      y = e.pageY
    else
      x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
      y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
    x -= @map.offsetLeft
    y -= @map.offsetTop
    squareIndex = @squares[Math.floor(x/50)][Math.floor(y/50)] if @squares[Math.floor(x/50)]
    if squareIndex
      @squareList[squareIndex - 1]


window.Game = Game