import niveles.*

object tableroPiso {
  const property position = game.at(6,0)

  method image() = "wood-bg-680x600.png"
}
object pantallaInicio {
  const property position = game.at(0,0)
  method image() = "fondoPantallaInicio.png"
}
object tableroPuntajes {
  const property position = game.at(2,0)

  method image() = "wood-bg-80x600.png"
}
object mapa {
  const property position = game.at(4,0)

  method image() = ""
}
object boton1 {
  const property position = game.at(8,5)

  method image() = "boton_inicio.png"
}
object boton2 {
  const property position = game.at(8,5)

  method image() = "boton_inicio2.png"
}
object pausa {
  const property position = game.at(9,3)

  method image() = "fondoPausa1.png"  
}
object botonPausa1 {
  const property position = game.at(10,7)

  method image() = "botonPausa1.png" 
}
object botonPausa2 {
  const property position = game.at(10,5)

  method image() = "botonPausa2.png" 
}
object botonPausa3 {
  const property position = game.at(10,7)

  method image() = "botonPausa3.png" 
}
object botonPausa4 {
  const property position = game.at(10,5)

  method image() = "botonPausa4.png" 
}
object fondoModoJuego{
  const property position = game.at(0,0)
  method image() = "fondoModoDeJuegos.png"
}
object botonUnJugador {
  const property position = game.at(8,4)
  method image() = "boton1Jugador.png"
}
object botonDosJugadores {
  const property position = game.at(12.5,4)
  method image() = "boton2Jugadores.png"
}
object botonUnJugador2 {
  const property position = game.at(8,4)
  method image() = "boton1Jugador_2.png"
}
object botonDosJugadores2 {
  const property position = game.at(12.5,4)
  method image() = "boton2Jugadores_2.png"
}
class Bomba {
  var property position

  method image() = "bomb.png"
  method explota(largoExplosion) {
    const explosion = new Explosion(position = self.position().down(largoExplosion.min(3)).left(largoExplosion.min(3)), largo = largoExplosion.min(3))
    game.schedule(2000, {
      game.addVisual(explosion)
    })
    game.schedule(3000, {
      game.removeVisual(explosion)
    })
  }
  method esColisionable() = true
}

class Explosion {
  var property position
  var property largo

  method image() {
    if(self.largo() == 1) {
      return "explosion1.png"  
    } else if(self.largo() == 2) {
      return "explosion2.png"  
      } else {
        return "explosion3.png"  
      }
  }

  method esColisionable() = false
  
  // method teEncontro(player) {
  //   player.perderVida()
  // }

}

class Muerte {
  var property position
  method image() = "skull.png"

  method muere(jugador) {
    game.schedule(1000,{ game.addVisual(self)})
    game.schedule(3000, {
      game.removeVisual(jugador) 
      game.removeVisual(self) 
    })
  }

    method esColisionable() = false

    method teEncontro(player) = null
}

class Vidas {
  var property position
  const player
  method image() {
    if(player.vidas() >= 3){
      return "HealthBar-3.png"
    } else if(player.vidas() == 2){
      return "HealthBar-2.png"
    } else if(player.vidas() == 1){
      return "HealthBar-1.png"
    } else {
      return "HealthBar-0.png"
    }
  }
}
class CaraPlayer {
  var property position
  const player
  const imagen
  const imagen2
  method image() = if(player.tieneVida()) imagen else imagen2
}

/// OBJETOS COLISIONES
class ObjetoNoSolido {
  var property position
  // var property bonuses = #{AumentoExplosion,VidaMas,PuntosDobles} //Esta en class Bonus
  method esColisionable() = true

  method seRompe() {
    self.dropea()
    game.removeVisual(self)
  }

  method dropea() {
    // RANDOM PARA VER SI DROPEA O NO
    // De ahi va a la clase bonus para elegir qué se dropea? o se elige acá con otro random

  }
}

class Barril inherits ObjetoNoSolido {
  // var property position = game.at(10,1)
  var property puntos = 50
  method image() = "Barrel.png"
}

class BotellaAzul inherits ObjetoNoSolido {
  // var property position = game.at(11,1)
  var property puntos = 10
  method image() = "BlueBottle.png"
}

class BotellaRoja inherits ObjetoNoSolido {
  // var property position = game.at(12,1)
  var property puntos = 15
  method image() = "RedBottle.png"
}

class Silla inherits ObjetoNoSolido {
  // var property position = game.at(13,1)
  var property puntos = 25
  method image() = "chair.png"
}


class Wall {
    var property position
    var property image = 'solid-1.png'
    
    method esColisionable() = true
}


/// BONUS (capaz no es necesario la superclase, pero vemos)
class Bonus {
  var property position
  var property bonuses = #{AumentoExplosion,VidaMas,PuntosDobles}

  method esColisionable() = false

  // IDEA: 
  // Cuando explota algo, hay una posibilidad RANDOM de que large BONUS (el objeto que explotó)
  // Despues se elije el bonus con otro random. del 0-2 s(3 opciones)

}

class AumentoExplosion inherits Bonus {
  method teEncontro(jugador) {
    self.darBonus(jugador)
  }
  method darBonus(jugador) {
    jugador.aumExplosion()
  }
}
//---------------
class VidaMas inherits Bonus {
  method teEncontro(jugador) {
    self.darBonus(jugador)
  }
  method darBonus(jugador) {
    jugador.vidaMas()
  }
}
//---------------
class PuntosDobles inherits Bonus {
  method teEncontro(jugador) {
    self.darBonus(jugador)
  }
  method darBonus(jugador) {
    jugador.puntosDobles()
  }
}

// Constructores
object item_constructor {
  method wall_gen(_lista, kind) {
    kind.construir(_lista)
  }
}
object wall_constructor {
  method construir(_lista) {
    _lista.forEach({ n => 
      const block = new Wall(position = game.at(n.get(0), n.get(1)))
      game.addVisual(block)})
  }
}
object barril_generator {
  method construir(_lista) {
    _lista.forEach({ n => 
    const block = new Barril (position = game.at(n.get(0), n.get(1)))
    free_board.saved().clear()
    game.addVisual(block)})
  }
}
object ba_generator {
  method construir(_lista) {
    _lista.forEach({ n=> 
    const block = new BotellaAzul (position = game.at(n.get(0), n.get(1)))
    free_board.saved().clear()
    game.addVisual(block)})
  }
}
object br_generator {
  method construir(_lista) {
    _lista.forEach({ n=> 
    const block = new BotellaRoja (position = game.at(n.get(0), n.get(1)))
    free_board.saved().clear()
    game.addVisual(block)})
  }
}
object silla_generator {
  method construir(_lista) {
    _lista.forEach({ n=> 
    const block = new Silla(position = game.at(n.get(0), n.get(1)))
    free_board.saved().clear()
    game.addVisual(block)})
  }
}

// Espacios libres
object free_board {
  var property counter = 1
  var property x = 0
  var property y = 0
  var property a = 0
  var property b = 0
  var property pos = []
  var property saved = []

  // 2 posiciones random
  method pos_eval_x() {
    a = 7.randomUpTo(21).truncate(0)
    return a
  }
  method pos_eval_y() {
    b = 1.randomUpTo(13).truncate(0)
    return b
  }
  //Si no estan en la lista de listas, se setean x e y
  method pos_eval(lvl) {
    lvl.map().forEach({ n =>
      pos = [self.pos_eval_x(), self.pos_eval_y()]
      if(!(lvl.map().contains(pos)) and (counter <= 25) and !(canceled_slots.contains(pos))) {
        x = pos.get(0)
        y = pos.get(1)
        saved.add([x,y]) // Se guardan las posiciones libres
        counter += 1
      }
    })
    // Para la proxima vuelta, estas tambien ya estan ocupadas
    self.saved().forEach({ n => 
      lvl.map().add(n)
    })
    counter = 1
    pos.clear()
  }
}