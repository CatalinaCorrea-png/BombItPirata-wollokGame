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

// Inicializar la pantalla de inicio
object pantallas{

  method iniciar(){
    game.addVisual(pantallaInicio)
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
    game.removeVisual(pantallaInicio)
    game.addVisual(tableroPiso)
    game.addVisual(tableroPuntajes)

    game.addVisual(new Barril(position = game.at(10,1)))
    game.addVisual(new BotellaAzul(position = game.at(11,1)))
    game.addVisual(new BotellaRoja(position = game.at(12,1)))
    game.addVisual(new Silla(position = game.at(13,1)))
    game.addVisual(new Wall(position = game.at(12,3)))
  
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
  //method juegoEnPausa() = 1 // false
  method configurarTeclas() {
    /// PAUSA
    keyboard.p().onPressDo({pantallas.pantallaPausa()})
      //if (!self.juegoEnPausa()) {
        //pantallas.pantallaPausa()  // Mostrar la pantalla de pausa
      //}})
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
  const direcciones = [1, 1, 2, 2, 3, 3, 4, 4, 5] // se repiten para que sea menos probable que ponga una bomba
  
  const direccionPlayer2 = direcciones.anyOne()
  const direccionPlayer3 = direcciones.anyOne()
  const direccionPlayer4 = direcciones.anyOne()

  self.movimiento(direccionPlayer2, direccionPlayer3, direccionPlayer4)
}

method movimiento(direplayer2, direplayer3, direplayer4) {
  
  // Player2 Para que se mueva el 2 descomentar esto
  // if (direplayer2 == 1) {
    // player2.moveTo(player2.position().down(1))
  // } else if (direplayer2 == 2) {
    // player2.moveTo(player2.position().up(1))
  // } else if (direplayer2 == 3) {
    // player2.moveTo(player2.position().left(1))
  // } else if (direplayer2 == 4) {
    // player2.moveTo(player2.position().right(1))
  // } else if (direplayer2 == 5) {
    // if(player2.tieneVida()) player2.ponerBomba(player2.position()) 
  // }
  
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
    if(player3.tieneVida()) player3.ponerBomba(player3.position()) 
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
    if(player4.tieneVida()) player4.ponerBomba(player4.position()) 
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
    keyboard.q().onPressDo({
      game.removeVisual(boton1)
      game.addVisual(boton2)
      game.schedule(200, {nivel1.iniciar()})
      })
  }
  
  method configurarTeclasPausa() {
    //var enPausa = false
    // REANUDAR JUEGO
    keyboard.e().onPressDo({
      game.removeVisual(botonPausa1)
      game.addVisual(botonPausa3)
      game.schedule(200, {
        game.removeVisual(pausa)
        game.removeVisual(botonPausa2)
        game.removeVisual(botonPausa3)
        })
    })
    // SALIR A PANTALLA INICIAL
    keyboard.f().onPressDo({
      game.removeVisual(botonPausa2)
      game.addVisual(botonPausa4)
      game.schedule(200, {
        game.removeVisual(pausa)
        game.removeVisual(botonPausa1)
        game.removeVisual(botonPausa4)
        game.removeVisual(boton2)
        pantallas.iniciar()
      })
    })
    }
}