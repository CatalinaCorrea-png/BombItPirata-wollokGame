import players.*
import wollok.game.*

object nivel1 {

  method iniciar() {
    // game.addVisual(mapa)
    game.addVisual(player1)
    game.addVisual(player2)
    config.configurarTeclas()
  }
}



object config {

  method configurarTeclas() {
    /// PLAYER 1:
    keyboard.c().onPressDo({ player1.aumExplosion() })
    keyboard.g().onPressDo({ player1.perderVida() })
    keyboard.v().onPressDo({ if(player1.tieneVida()) player1.vidaMas() })

    keyboard.a().onPressDo({ if(player1.limiteL() && player1.colisionL() && player1.tieneVida()) player1.moveTo(player1.position().left(1)) })
    keyboard.d().onPressDo({ if(player1.limiteR() && player1.colisionR() && player1.tieneVida()) player1.moveTo(player1.position().right(1)) })
    keyboard.w().onPressDo({ if(player1.limiteU() && player1.colisionU() && player1.tieneVida()) player1.moveTo(player1.position().up(1)) })
    keyboard.s().onPressDo({ if(player1.limiteD() && player1.colisionD() && player1.tieneVida()) player1.moveTo(player1.position().down(1)) })
    keyboard.space().onPressDo({ 
      if(player1.tieneVida()) player1.ponerBomba(player1.position()) 
      })


    /// PLAYER 2:
    keyboard.left().onPressDo({ if(player2.limiteL() && player2.colisionL() && player2.tieneVida()) player2.moveTo(player2.position().left(1)) })
    keyboard.right().onPressDo({ if(player2.limiteR() && player2.colisionR() && player2.tieneVida()) player2.moveTo(player2.position().right(1)) })
    keyboard.up().onPressDo({ if(player2.limiteU() && player2.colisionU() && player2.tieneVida()) player2.moveTo(player2.position().up(1)) })
    keyboard.down().onPressDo({ if(player2.limiteD() && player2.colisionD() && player2.tieneVida()) player2.moveTo(player2.position().down(1)) })
    keyboard.enter().onPressDo({ 
      if(player2.tieneVida()) player2.ponerBomba(player2.position()) 
    })

  }

  method configurarColisiones() {
    game.onCollideDo(player1, { algo => algo.teEncontro(player1) })
    game.onCollideDo(player2, { algo => algo.teEncontro(player2) })
  }

}