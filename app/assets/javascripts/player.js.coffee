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

  move: (e) ->
    square = @game.getSquare(e)
    return if $.inArray(square, @validSquares(@moveDistance)) == -1
    @square = square.index
    @game.draw()

  inflict: (damage) ->
    console.log("ouch: "+ damage)
    @shield = @shield - damage
    return if @shield > 0
    damage = 0 - @shield
    @shield = 0
    @health = @health - damage
    console.log("hp remaining:" + @health)
    @die() if @health <= 0

  die: ->
    console.log("you snuffed it")
    window.location.reload()

  validSquares: (range) ->
    index = @square
    min = Math.max(index - range, 0)
    @game.squareList[(min)..(index + range - 1)]

  squareObj: ->
    @game.squareList[@square - 1]

  nextSquareObj: ->
    @game.squareList[@square]

  previousSquareObj: ->
    @game.squareList[@square - 2]


window.Player = Player
