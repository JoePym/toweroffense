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
    console.log(@name + " spawned!")
    @square = square.index
    @setMoveTimer(this)

  setMoveTimer:(monster) ->
    monster.timer = window.setTimeout ->
      monster.move(monster)
    ,(2/monster.moveDistance)*5000

  move:(monster) ->
    game = window.current_game
    monster.square = monster.square - 1
    console.log(monster.name + " is moving to " +monster.square)
    if @square == game.player.square
      monster.attack()
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
    @game.monsters = @game.monsters.filter (m) -> this isnt m

window.Monster = Monster