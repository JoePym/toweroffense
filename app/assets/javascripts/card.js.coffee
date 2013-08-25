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
    game.highlight("rgba(200, 0, 0, 0.3)", @validTargets(), "spell")
    game.activeCard = this

  validTargets: () ->
    currentSquare = @player.squareObj()
    nextSquare = @player.nextSquareObj()
    prevSquare = @player.previousSquareObj()
    direction = if nextSquare.x != currentSquare.x then 'y' else 'x'
    targets = @squareIterator(direction, nextSquare, nextSquare, true)
    if prevSquare
      direction = if prevSquare.x != currentSquare.x then 'y' else 'x'
      targets = targets.concat @squareIterator(direction, prevSquare, prevSquare, false)
    targets = targets.concat [currentSquare]

  squareIterator: (method, square, currentSquare, forward) ->
    targets = []
    while square && square[method] == currentSquare[method] && targets.length < @range
      targets.push(square)
      if forward
        square = @player.game.squareList[square.index]
      else
        square = @player.game.squareList[square.index - 2]
    targets

  cast: (e) ->
    square = @player.game.getSquare(e) if e
    return if $.inArray(square, @validTargets()) == -1 && @range != 0
    monstersHit = (monster for monster in @player.game.monsters when monster.squareObj() is square)
    console.log $.isArray(monstersHit)
    console.log(@card_type)
    switch @card_type
      when "heal"
        @player.health = @player.health + @rating
      when "shield"
        @player.shield = @rating
      when 'damage'
        console.log(monstersHit)
        if $.isArray(monstersHit)
          for monster in monstersHit
            console.log("boom: " + monster.name)
            monster.inflict(@rating)
    console.log("Cast spell " + @name)

window.Card = Card