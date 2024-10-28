import players.*
import extras.*
import wollok.game.*
import map_generator.*

// Inicializar la pantalla de inicio
object pantallas{
  method iniciar(){
    game.addVisual(pantallaInicio)
    game.addVisual(botonInicio1)
    config.configurarTeclasInicio()
  }
  method pantallaPausa() {
    game.addVisual(pausa)
    game.addVisual(botonPausa1Color)
    game.addVisual(botonPausa2)
    config.configurarTeclasPausa()
  }
  method modosDeJuego() {
    game.addVisual(fondoModoJuego)
    game.addVisual(botonUnJugador)
    game.addVisual(botonDosJugadores)
    config.configurarTeclasModosDeJuegos()
  }

}

object config {
  var property juegoEnPausa = false 
  var property enInicio = true

  method configurarTeclas() {
    juegoEnPausa = false
    /// PAUSA
    keyboard.p().onPressDo({
      if (!juegoEnPausa){
        juegoEnPausa = true
        pantallas.pantallaPausa()
      }
    })
  
    /// PLAYER 1:
    // keyboard.c().onPressDo({ if(!juegoEnPausa and !enInicio and player1.tieneVida()) player1.aumExplosion() })
    keyboard.g().onPressDo({ if(!juegoEnPausa and !enInicio and player1.tieneVida()) player1.addBomba() })
    // keyboard.v().onPressDo({ if(!juegoEnPausa and !enInicio and player1.tieneVida()) player1.vidaMas() })

    keyboard.a().onPressDo({if (!juegoEnPausa and !enInicio) player1.moveTo(player1.position().left(1)) }) 
    keyboard.d().onPressDo({if (!juegoEnPausa and !enInicio) player1.moveTo(player1.position().right(1)) }) 
    keyboard.w().onPressDo({if (!juegoEnPausa and !enInicio)  player1.moveTo(player1.position().up(1)) }) 
    keyboard.s().onPressDo({if (!juegoEnPausa and !enInicio)  player1.moveTo(player1.position().down(1)) }) 
    keyboard.space().onPressDo({ 
      if(!juegoEnPausa and !enInicio and player1.tieneVida()) player1.ponerBomba(player1.position()) 
      })

    /// PLAYER 2:
    if(nivel1.multiplayer()){
      keyboard.left().onPressDo({if (!juegoEnPausa and !enInicio) player2.moveTo(player2.position().left(1)) })
      keyboard.right().onPressDo({if (!juegoEnPausa and !enInicio) player2.moveTo(player2.position().right(1)) })
      keyboard.up().onPressDo({if (!juegoEnPausa and !enInicio) player2.moveTo(player2.position().up(1)) })
      keyboard.down().onPressDo({if (!juegoEnPausa and !enInicio) player2.moveTo(player2.position().down(1)) })
      keyboard.enter().onPressDo({ 
        if(!juegoEnPausa and !enInicio and player2.tieneVida()) player2.ponerBomba(player2.position()) 
      })
    }

    if (!juegoEnPausa and !enInicio) game.onTick(250, "seMueve", {self.random()})
    
  }

method random() {
  const direcciones = [1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5] // se repiten para que sea menos probable que ponga una bomba
  
  // Se podria mejorar evaluando las 4 posiciones posibles para ir sin chocarse, y recien de ahi sacar una random (de una lista por ejemplo).
  // Que pongan bombas cuando se encuentren con un objeto solido.
  // Las bombas cuentan como posiciones ocupadas para que las esquiven los mogules.
  const direccionPlayer2 = direcciones.anyOne()
  const direccionPlayer3 = direcciones.anyOne()
  const direccionPlayer4 = direcciones.anyOne()

  if (!juegoEnPausa and !enInicio) self.movimiento(direccionPlayer2, direccionPlayer3, direccionPlayer4)
}

method movimiento(direplayer2, direplayer3, direplayer4) {
  
  // Player2 Para que se mueva el 2 descomentar esto (sin multiplayer)
  if(!nivel1.multiplayer()){
    if (direplayer2 == 1) {
      player2.moveTo(player2.position().down(1))
    } else if (direplayer2 == 2) {
      player2.moveTo(player2.position().up(1))
    } else if (direplayer2 == 3) {
      player2.moveTo(player2.position().left(1))
    } else if (direplayer2 == 4) {
      player2.moveTo(player2.position().right(1))
    } else if (direplayer2 == 5) {
      if(player2.tieneVida()) player2.ponerBomba(player2.position()) 
    }
  }
  
  // player3
  if (direplayer3 == 1) {
    player3.moveTo(player3.position().down(1))
  } else if (direplayer3 == 2) {
    player3.moveTo(player3.position().up(1))
  } else if (direplayer3 == 3) {
    player3.moveTo(player3.position().left(1))
  } else if (direplayer3 == 4) {
    player3.moveTo(player3.position().right(1))
  } else if (direplayer3 == 5) {
    if(!juegoEnPausa and !enInicio and player3.tieneVida()) player3.ponerBomba(player3.position()) 
  }

  // player4
  if (direplayer4 == 1) {
    player4.moveTo(player4.position().down(1))
  } else if (direplayer4 == 2) {
    player4.moveTo(player4.position().up(1))
  } else if (direplayer4 == 3) {
    player4.moveTo(player4.position().left(1))
  } else if (direplayer4 == 4) {
    player4.moveTo(player4.position().right(1))
  } else if (direplayer4 == 5) {
    if(!juegoEnPausa and !enInicio and player4.tieneVida()) player4.ponerBomba(player4.position()) 
  }
}

  method configurarColisiones() {
    game.onCollideDo(player1, { algo => algo.teEncontro(player1) })
    game.onCollideDo(player2, { algo => algo.teEncontro(player2) })
    game.onCollideDo(player3, { algo => algo.teEncontro(player3) })
    game.onCollideDo(player4, { algo => algo.teEncontro(player4) })
  }

  // INICIAR JUEGO
  method configurarTeclasInicio() {
    // PARA INICIAR EL JUEGO
    enInicio = true
    keyboard.enter().onPressDo({
      game.removeVisual(botonInicio1)
      game.addVisual(botonInicio2)
      game.schedule(200, {
        game.removeVisual(pantallaInicio)
        game.clear()
        pantallas.modosDeJuego()
        })
      })
  }
  
  method reiniciarJuego() {
    // Adentro del reinicio empiezan todas las variables de los players devuelta
    player1.reiniciar(game.at(7,1))
    player2.reiniciar(game.at(21,1))
    player3.reiniciar(game.at(7,13))
    player4.reiniciar(game.at(21,13))
    game.schedule(100, {pantallas.iniciar()})
  }
  
  method configurarTeclasPausa() {
    var seleccionado 

    // REANUDAR JUEGO
    keyboard.up().onPressDo({
      if (juegoEnPausa){
        seleccionado = 1
        game.removeVisual(botonPausa2Color)
        game.addVisual(botonPausa2)
        game.addVisual(botonPausa1Color)}
      })
    // SALIR A PANTALLA INICIAL
    keyboard.down().onPressDo({
      if (juegoEnPausa){
        seleccionado = 2
        game.removeVisual(botonPausa1)
        game.removeVisual(botonPausa1Color)
        game.removeVisual(botonPausa2Color)
        game.removeVisual(botonPausa2)
        game.addVisual(botonPausa1)
        game.addVisual(botonPausa2Color)
        }
      }) 
    
    keyboard.enter().onPressDo({
      if (juegoEnPausa){
        if (seleccionado == 1){
        game.schedule(200, {
        game.removeVisual(pausa)
        game.removeVisual(botonPausa2)
        game.removeVisual(botonPausa1)
        game.removeVisual(botonPausa1Color)})
        juegoEnPausa = false
        } else if (seleccionado == 2) {

          game.clear()
          self.reiniciarJuego()}}})   
    }
    method configurarTeclasModosDeJuegos(){
      // MODOS DE JUEGO
      // UN JUGADOR
      enInicio = false
      keyboard.n().onPressDo({
        game.addVisual(botonUnJugador2)
        game.schedule(100, {
          game.removeVisual(botonUnJugador2)
          game.clear()
          nivel1.iniciar(false)
        })
      })
        // DOS JUGADORES
      keyboard.m().onPressDo({
        game.addVisual(botonDosJugadores2)
        game.schedule(100, {
          game.removeVisual(botonDosJugadores2)
          game.clear()
          nivel1.iniciar(true)
          })
      })
    }
}