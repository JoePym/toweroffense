class Monster

  constructor: (monster, game) ->
    @game = game
    @name = monster.name
    @id = monster.id
    @damage = monster.damage
    @hp = monster.hp
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
    ,(2/monster.moveDistance)*10000

  move:(monster) ->
    game = window.current_game
    game.monsterMap[monster.squareObj().x][monster.squareObj().y] = null
    monster.square = monster.square - 1
    x = monster.squareObj().x
    y = monster.squareObj().y
    unless $.isArray(game.monsterMap[x])
      game.monsterMap[x] = []
    game.monsterMap[x][y] = monster
    console.log(monster.name + " is moving to " +monster.square)
    if @square == game.player.square
      monster.attack()
    game.draw()
    monster.setMoveTimer(monster)

  squareObj: ->
    @game.squareList[@square - 1]

  attack: ->
    console.log("NOM")
    window.current_game.player.inflict(@damage)

  inflict: (damage) ->
    @hp -= damage
    @die if @hp <= 0

  die: ->
    @square = null
    window.clearInterval(@timer) if @timer
    @game.monsters = @game.monsters.filter (m) -> this isnt m

window.Monster = Monster