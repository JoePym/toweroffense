class Card
  constructor:(player, card) ->
    @player = player
    @rating = card.rating
    @width = card.width
    @cost = card.cost
    @range = card.range
    @name = card.name
    @id = card.id
    @monster_id = card.monster_id
    @card_type = card.card_type

  highlight: (game) ->
    currentSquare = @player.squareObj()
    nextSquare = @player.nextSquareObj()
    prevSquare = @player.previousSquareObj()
    direction = if nextSquare.x != currentSquare.x then 'y' else 'x'
    targets = @squareIterator(direction, nextSquare, nextSquare, true)
    if prevSquare
      direction = if prevSquare.x != currentSquare.x then 'y' else 'x'
      targets = targets.concat @squareIterator(direction, prevSquare, prevSquare, false)
    targets = targets.concat [currentSquare]
    game.highlight("rgba(200, 0, 0, 0.5)", targets, "spell")


  squareIterator: (method, square, currentSquare, forward) ->
    targets = []
    while square && square[method] == currentSquare[method] && targets.length < @range
      targets.push(square)
      if forward
        square = @player.game.squareList[square.index]
      else
        square = @player.game.squareList[square.index - 2]
    targets
  cast: ->
    console.log("Cast spell " + @name)

window.Card = Card