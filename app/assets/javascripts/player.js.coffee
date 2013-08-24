class Player
  constructor:(game) ->
    @power = 100
    @health = 100
    @square = 1
    @shield = 0
    @moveDistance = 5
    @deck = []
    @game = game
    $.getJSON 'players/1', (data) =>
      @deck.push(new Card(this, card)) for card in data.cards
      @game.addSquare(square) for square in data.squares
      @game.draw()

  move: (e) =>
    square = @getSquare(e)
    return if $.inArray(square, @validSquares(@moveDistance)) == -1
    @square = square.index
    # toCrush = @game.squareList[0..(square.index - 2)]
    # for deadSquare in toCrush
    #   @game.squares[deadSquare.x - 1][deadSquare.y - 1] = "dead"
    @game.draw()


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

  getSquare: (e) =>
    if e.pageX || e.pageY
      x = e.pageX
      y = e.pageY
    else
      x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
      y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
    x -= @game.map.offsetLeft
    y -= @game.map.offsetTop
    squareIndex = @game.squares[Math.floor(x/50)][Math.floor(y/50)] if @game.squares[Math.floor(x/50)]
    if squareIndex
      @game.squareList[squareIndex - 1]



window.Player = Player
