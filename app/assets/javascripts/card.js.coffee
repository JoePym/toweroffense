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
    monstersHit = []
    if @width
      max = Math.min(square.index + @width, @player.game.squareList.length)
      min = Math.max(square.index - @width, 0)
      squares = @player.game.squareList[min..max]
    else
      squares = [square]
    for square in squares
      for monster in @player.game.monsters when monster.squareObj() is square
        monstersHit.push(monster) if monster
    console.log(monstersHit)
    switch @card_type
      when "heal"
        @player.health = @player.health + @rating
      when "shield"
        @player.shield = @rating
      when "speed"
        @player.moveDistance = @player.moveDistance + @rating
      when "slow"
        for monster in monstersHit
          monster.moveDistance = Math.min(monster.moveDistance - @rating, 0)
      when 'damage'
        if monstersHit.length > 0
          console.log(monstersHit)
          monster = monstersHit[Math.floor(Math.random()*monstersHit.length)]
          monster.inflict(@rating)
      when 'blast'
        for monster in monstersHit
          monster.inflict(@rating)

window.Card = Card