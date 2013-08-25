class Player
  constructor:(game) ->
    @power = 100
    @health = 100
    @square = 1
    @shield = 0
    @moveDistance = 3
    @deck = []
    @game = game
    $.getJSON 'players/1', (data) =>
      @deck.push(new Card(this, card)) for card in data.cards
      @game.addSquare(square) for square in data.squares
      @game.monsterTemplates = data.monsters
      @game.draw()
      @game.spawnMonsters()
      @game.spawnWave()
      @setPowerUp()

  setPowerUp: () ->
    window.setInterval(->
      window.current_game.player.powerUp()
    , 1000)

  powerUp: () ->
    player = window.current_game.player
    player.power = Math.min(player.power + 10, 100)
    $('.buttons .power').text(window.current_game.player.power)

  move: (e) ->
    square = @game.getSquare(e)
    return if $.inArray(square, @validSquares(@moveDistance)) == -1
    @square = square.index
    @game.draw()

  inflict: (damage) ->
    @shield = @shield - damage
    if @shield > 0
      $('.buttons .shield').text(@shield)
    else
      damage = 0 - @shield
      @shield = 0
      $('.buttons .shield').text(@shield)
      @health = @health - damage
      $('.buttons .health').text(@health)
      @die() if @health <= 0

  die: ->
    console.log("you snuffed it")
    window.location.reload()

  validSquares: (range) ->
    index = @square
    min = Math.max(index - range, 0)
    max = (index + range - 1)
    for monster in (@game.monsters.filter (monster) -> !monster.dead)
      if monster.square < max
        max = monster.square
    squares = @game.squareList[min..max]

  squareObj: ->
    @game.squareList[@square - 1]

  nextSquareObj: ->
    @game.squareList[@square]

  previousSquareObj: ->
    @game.squareList[@square - 2]


window.Player = Player
