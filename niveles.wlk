import players.*
import extras.*
import wollok.game.*

object nivel1 {

  method iniciar() {
    // game.addVisual(mapa)
    // Construccion de nivel
    constructor.wall_gen()
    game.addVisual(player1)
    game.addVisual(player2)
    game.addVisual(caraPlayer1)
    game.addVisual(caraPlayer2)
    game.addVisual(vidaPlayer1)
    game.addVisual(vidaPlayer2)

    /// Para Prueba. Despues van con un constructor
    game.addVisual(new Barril(position = game.at(10,1)))
    game.addVisual(new BotellaAzul(position = game.at(11,1)))
    game.addVisual(new BotellaRoja(position = game.at(12,1)))
    game.addVisual(new Silla(position = game.at(13,1)))

    config.configurarTeclas()
  }
}



object config {

  method configurarTeclas() {
    /// PLAYER 1:
    keyboard.c().onPressDo({ player1.aumExplosion() })
    keyboard.g().onPressDo({ player1.perderVida() })
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
  if (a == 1) {player2.moveTo(player2.position().up(1))}
  if (a == 2) {player2.moveTo(player2.position().down(1))}
  if (a == 3) {player2.moveTo(player2.position().right(1))}
  if (a == 4) {player2.moveTo(player2.position().left(1))}
}

  method configurarColisiones() {
    game.onCollideDo(player1, { algo => algo.teEncontro(player1) })
    game.onCollideDo(player2, { algo => algo.teEncontro(player2) })
  }

}