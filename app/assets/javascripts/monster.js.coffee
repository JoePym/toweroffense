class Monster

  constructor: (monster, game) ->
    @game = game
    @name = monster.name
    @id = monster.id
    @damage = monster.damage
    @hp = monster.hp
    @dead = false
    @moveDistance = monster.move
    @difficulty = monster.difficulty
    @square = null
    @timer = null

  spawn: (square) ->
    @square = square.index
    @setMoveTimer(this)

  setMoveTimer:(monster) ->
    if monster.moveDistance > 0
      monster.timer = window.setTimeout ->
        monster.move(monster)
      ,(2/monster.moveDistance)*5000

  move:(monster) ->
    unless monster.dead
      game = window.current_game
      if monster.square - 1 == game.player.square
        monster.attack()
      else
        monster.square = monster.square - 1
      game.draw()
      monster.setMoveTimer(monster)

  squareObj: ->
    @game.squareList[@square - 1]

  attack: ->
    window.current_game.player.inflict(@damage)

  inflict: (damage) ->
    @hp -= damage
    @dead = true if @hp <= 0

  die: ->
    @square = null
    window.clearInterval(@timer) if @timer

window.Monster = Monster