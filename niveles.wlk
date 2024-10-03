import players.*
import extras.*
import wollok.game.*

// Posiciones de arranque
const canceled_slots = [
  [7,1],[7,2],[7,12],[7,13],
  [8,1],[8,13],
  [20,1],[20,13],
  [21,1],[21,2],[21,12],[21,13]
]

object nivel1 {
  // nivel tiene las posiciones en una lista propia, no estan en el objeto 'constructor'
  var property map = [
        [7,10],
        [8,2],[8,5],[8,7],
        [9,3],[9,7],
        [10,1],[10,7],
        [11,3],[11,5],[11,9],
        [12,1],[12,2],[12,7],
        [13,6],[13,7],[13,8],[13,12],
        [14,4],[14,7],[14,8],[14,10],
        [15,2],[15,10],[15,12],
        [16,7],
        [17,11],
        [18,1],[18,13],
        [19,3],[19,5],[19,9],[19,11],
        [20,2],[20,5],[20,7],[20,12],
        [21,4]]
  
  method iniciar() {
  
    // Construccion de nivel
    // No rompibles
    item_constructor.wall_gen(self.map(), wall_constructor)
    // Rompibles (como tu señora madre)
    free_board.pos_eval(self)
    item_constructor.wall_gen(free_board.saved(), barril_generator)
    free_board.pos_eval(self)
    item_constructor.wall_gen(free_board.saved(), ba_generator)
    free_board.pos_eval(self)
    item_constructor.wall_gen(free_board.saved(), br_generator)
    

    //Players y display
    game.addVisual(player1)
    game.addVisual(player2)
    game.addVisual(player3)
    game.addVisual(player4)
    game.addVisual(caraPlayer1)
    game.addVisual(caraPlayer2)
    game.addVisual(caraPlayer3)
    game.addVisual(caraPlayer4)
    game.addVisual(vidaPlayer1)
    game.addVisual(vidaPlayer2)
    game.addVisual(vidaPlayer3)
    game.addVisual(vidaPlayer4)
  
    /// Para Prueba. Despues van con un constructor
    // game.addVisual(new Barril(position = game.at(10,2)))
    // game.addVisual(new BotellaAzul(position = game.at(11,1)))
    // game.addVisual(new BotellaRoja(position = game.at(12,3)))
    // game.addVisual(new Silla(position = game.at(13,1)))

    config.configurarTeclas()
  }
}



object config {

  method configurarTeclas() {
    /// PLAYER 1:
    keyboard.c().onPressDo({ if(player1.tieneVida()) player1.aumExplosion() })
    keyboard.g().onPressDo({ if(player1.tieneVida()) player1.perderVida() })
    keyboard.v().onPressDo({ if(player1.tieneVida()) player1.vidaMas() })

    keyboard.a().onPressDo({  player1.moveTo(player1.position().left(1)) }) 
    keyboard.d().onPressDo({ player1.moveTo(player1.position().right(1)) }) 
    keyboard.w().onPressDo({  player1.moveTo(player1.position().up(1)) }) 
    keyboard.s().onPressDo({  player1.moveTo(player1.position().down(1)) }) 
    keyboard.space().onPressDo({ 
      if(player1.tieneVida()) player1.ponerBomba(player1.position()) 
      })

    /// PLAYER 2:
    keyboard.left().onPressDo({ player2.moveTo(player2.position().left(1)) })
    keyboard.right().onPressDo({ player2.moveTo(player2.position().right(1)) })
    keyboard.up().onPressDo({ player2.moveTo(player2.position().up(1)) })
    keyboard.down().onPressDo({ player2.moveTo(player2.position().down(1)) })
    keyboard.enter().onPressDo({ 
      if(player2.tieneVida()) player2.ponerBomba(player2.position()) 
    })

    game.onTick(1000, "seMueve", {self.random()})
  }

method random() {
  const direcciones = [1,2,3,4]
  self.movimiento(direcciones.anyOne())
  }
// USA EL moveTo DE CATALINA
method movimiento(a) {
  //player 2
  if (a == 1) {
    // player2.moveTo(player2.position().up(1))
    player3.moveTo(player3.position().down(1))
    player4.moveTo(player4.position().left(1))
  }
  else if (a == 2) {
    // player2.moveTo(player2.position().down(1))
    player3.moveTo(player3.position().up(1))
    player4.moveTo(player4.position().right(1))
  }
  else if (a == 3) {
    // player2.moveTo(player2.position().right(1))
    player3.moveTo(player3.position().left(1))
    player4.moveTo(player4.position().down(1))
  }
  else (a == 4) {
    // player2.moveTo(player2.position().left(1))
    player3.moveTo(player3.position().right(1))
    player4.moveTo(player4.position().up(1))
  }
}

  method configurarColisiones() {
    game.onCollideDo(player1, { algo => algo.teEncontro(player1) })
    game.onCollideDo(player2, { algo => algo.teEncontro(player2) })
    game.onCollideDo(player3, { algo => algo.teEncontro(player3) })
    game.onCollideDo(player4, { algo => algo.teEncontro(player4) })
  }

}