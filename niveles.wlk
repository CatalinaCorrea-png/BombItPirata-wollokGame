import players.*
import wollok.game.*
import extras.*

// Inicializar la pantalla de inicio
object pantallas{

  method iniciar(){
    game.addVisual(boton1)
    config.configurarTeclasInicio()
  }
  method pantallaPausa() {
    game.addVisual(pausa)
    game.addVisual(botonPausa1)
    game.addVisual(botonPausa2)
    config.configurarTeclasPausa()
  }

}
object nivel1 {

  method iniciar() {
    game.removeVisual(boton2)
    game.addVisual(tableroPiso)
    game.addVisual(tableroPuntajes)

    game.addVisual(new Barril(position = game.at(10,1)))
    game.addVisual(new BotellaAzul(position = game.at(11,1)))
    game.addVisual(new BotellaRoja(position = game.at(12,1)))
    game.addVisual(new Silla(position = game.at(13,1)))
    game.addVisual(new Bloque(position = game.at(12,3)))
    // game.addVisual(mapa)
    game.addVisual(player1)
    game.addVisual(player2)
    config.configurarTeclas()
    // Construccion de nivel
    constructor.wall_gen()
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
    /// PAUSA
    keyboard.p().onPressDo({
      game.stop()
      pantallas.pantallaPausa()
    })

    game.onTick(1000, "seMueve", {self.random()})
  }

method random() {
  const direcciones = [1,2,3,4]
  self.movimiento(direcciones.anyOne())
  }
// USA EL moveTo DE CATALINA
method movimiento(a) {
  if (a == 1) {if(player2.limiteU() && player2.colisionU() && player2.tieneVida()) player2.moveTo(player2.position().up(1))}
  if (a == 2) {if(player2.limiteD() && player2.colisionD() && player2.tieneVida()) player2.moveTo(player2.position().down(1))}
  if (a == 3) {if(player2.limiteR() && player2.colisionR() && player2.tieneVida()) player2.moveTo(player2.position().right(1))}
  if (a == 4) {if(player2.limiteL() && player2.colisionL() && player2.tieneVida()) player2.moveTo(player2.position().left(1))}
}

  method configurarColisiones() {
    game.onCollideDo(player1, { algo => algo.teEncontro(player1) })
    game.onCollideDo(player2, { algo => algo.teEncontro(player2) })
  }

  method configurarTeclasInicio() {
    keyboard.q().onPressDo({
      game.removeVisual(boton1)
      game.addVisual(boton2)
      game.schedule(110, {nivel1.iniciar()})
      })
  }
  method configurarTeclasPausa() {
      keyboard.u().onPressDo({
        game.removeVisual(botonPausa1)
        game.addVisual(botonPausa3)
        game.schedule(100, {game.start()})
      })
  }
}