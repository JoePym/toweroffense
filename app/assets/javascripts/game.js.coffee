class Game
  constructor: () ->
    @squares = []
    @player = new Player(this)
    @map = $("#map canvas")[0]
    @map.width = 600
    @map.height = 600
    @squareList = []
    @setupHandlers()
    @preloaded = false
    @waiting_click = ""
    @monsters = []
    @monsterTimer = null
    @currentHighlight = null
    @wave = 0

  setupHandlers: () ->
    $('body').on 'click', '#move', (e) =>
      e.preventDefault()
      @moveHighlight()
    $('body').on 'click', 'a.spell', (e) =>
      e.preventDefault()
      cardId = $(e.target).parents('a.spell').attr('id').replace("card_", '')*1
      for card in @player.deck when card.id == cardId
        if card.range == 0
          card.cast()
        else
          card.highlight(this)
    $('body').on 'click', '.legendarySpell', (e) =>
      e.preventDefault()
      cardId = $(e.target).attr('id').replace("card_", '')*1
      for card in @player.deck when card.id == cardId
        if card.range == 0 || card.range > @squareList.length
          card.cast()
        else
          card.highlight(this)


    $('body').on 'click', '#map canvas', (e) =>
      @currentHighlight = null
      e.preventDefault()
      switch @waiting_click
        when "move"
          @player.move(e)
        when "spell"
          if @activeCard
            @activeCard.cast(e)
      @activeCard = null
      @waiting_click = null
      @draw()

  spawnMonsters: () ->
    @monsterTimer = window.setInterval(->
      window.current_game.spawnWave()
    , 10000)


  spawnWave: () ->
    game = window.current_game
    game.wave += 1
    monsterTemplates = []
    sc = game.squareList.length
    monsterEntranceSquares = game.squareList[(sc - 4)..(sc - 1)]
    for template in game.monsterTemplates
      number = 0
      if template.difficulty > 2 && @wave % 5 == 0 && @wave > 0
        number = 1
      else if template.difficulty == 2
        number = Math.floor(Math.random()*@wave)
      else if template.difficulty == 1
        number = Math.floor(Math.random()*@wave*2) + 1
      if number > 0
        for n in [1..number]
          monsterTemplates.push(template)
    for template, n in monsterTemplates
      monster = new Monster(template, game)
      game.monsters.push(monster)
      monster.spawn(monsterEntranceSquares[n %3])
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
      @drawGrid(images)
    else
      $.promises.preloadImages(uris).done =>
        @preloaded = true
        @drawGrid(images)

  drawGrid: (images) ->
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
    @monsters = @monsters.filter (monster) -> !monster.dead
    deadMonsters = @monsters.filter (monster) -> monster.dead
    orderedMonsters = @monsters.sort (a,b) ->
      return if a.difficulty >= b.difficulty then 1 else -1
    for monster in orderedMonsters
      @ctx.drawImage(images.siblings("##{monster.name}:first")[0], (monster.squareObj().x - 1)*50, (monster.squareObj().y - 1)*50)
    for deadmonster in deadMonsters
      deadmonster.die()
    @currentHighlight.call() if @currentHighlight

  moveHighlight: () ->
    @highlight("rgba(100, 200, 100, 0.3)", @player.validSquares(@player.moveDistance), "move")

  highlight: (color, toHighlight, eventName) ->
    @currentHighlight = =>
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