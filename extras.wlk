import players.*
import niveles.*

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

class BombasPlayer {
  var property position
  const property player

  method image() {
    if(player.bombas() == 0) return "nb0.png"
    else if(player.bombas() == 1) return "nb1.png"
    else if(player.bombas() == 2) return "nb2.png"
    else if(player.bombas() == 3) return "nb3.png"
    else if(player.bombas() == 4) return "nb4.png"
    else if(player.bombas() == 5) return "nb5.png"
    else if(player.bombas() == 6) return "nb6.png"
    else if(player.bombas() == 7) return "nb7.png"
    else if(player.bombas() == 8) return "nb8.png"
    else return "nb9.png"
  }
}

class PuntajePlayer {
  var property position
  const property player
  const texto = {"          PUNTAJE: " + player.puntaje()}

  method image() = "puntaje-bg.png"
  method text() = texto.apply()
  method textColor() = "FFFFFFFF"

}

/// OBJETO BOMBA
class Bomba {
  var property position
  var property player

  method image() = "bomb.png"
  method explota(largoExplosion) {
    const explosion = new Explosion(position = self.position().down(largoExplosion.min(3)).left(largoExplosion.min(3)), largo = largoExplosion.min(3), player = player)
    game.schedule(3000, {
      game.addVisual(explosion)
      explosion.colisiones()
    })
    game.schedule(4000, {
      game.removeVisual(explosion)
    })
  }
  method esColisionable() = true
  method teEncontro(_player) = true // No hace nada
  method seRompe(_player) = true // No hace nada
  method explotable() = false
}

class Explosion {
  var property position
  var property player
  var property largo 
  const property indexLargos = []

  method explotable() = false

  method indexLargos() {
    if(self.largo() == 1){
      return [0,1]
    } else if (self.largo() == 2){
      return [0,1,2]
    }else {
      return [0,1,2,3]
    }
  }

  method centro() {
    return self.position().up(self.largo()).right(self.largo())
  }

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
  
  method teEncontro(_player) {
    // player.perderVida()
    self.colisiones()
  }

  method colisiones() {
    var objetos = []

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().left(opLargo))})
    if (!objetos.isEmpty()) {
      objetos.forEach({obj => obj.seRompe(player)})
      objetos.clear()
    }

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().right(opLargo))})
    if (!objetos.isEmpty()) {
      objetos.forEach({obj => obj.seRompe(player)})
      objetos.clear()
    }

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().up(opLargo))})
    if (!objetos.isEmpty()) {
      objetos.forEach({obj => obj.seRompe(player)})
      objetos.clear()
    }

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().down(opLargo))})
    if (!objetos.isEmpty()) {
      objetos.forEach({obj => obj.seRompe(player)})
      objetos.clear()
    }
  
  }

}

/// OBJETOS COLISIONES
class ObjetoNoSolido {
  var property position
  var property bonuses = #{new AumentoExplosion(position = self.position()),new VidaMas(position = self.position()), new PuntosDobles(position = self.position()),new BombaMas(position = self.position())} //Esta en class Bonus
  method esColisionable() = true

  method seRompe(player) {
    game.removeVisual(self)
    if (self.dropea()){
      self.addPowerup(bonuses.anyOne())
    }
  }

  method dropea() {
    const a = 1.randomUpTo(10).truncate(0)
    return a.even()
    // RANDOM PARA VER SI DROPEA O NO
    // SI LA CONDICION ES TRUE, DROPEA.
  }

  method addPowerup(powerup) {
    game.addVisual(powerup)
  }

  method explotable() = true
}

class Barril inherits ObjetoNoSolido {
  // var property position = game.at(10,1)
  var property puntos = 50
  method image() = "Barrel.png"
  override method seRompe(player) {
    super(player)
    player.sumarPuntos(self.puntos())
  }
}

class BotellaAzul inherits ObjetoNoSolido {
  // var property position = game.at(11,1)
  var property puntos = 10
  method image() = "BlueBottle.png"
  override method seRompe(player) {
    super(player)
    player.sumarPuntos(self.puntos())
  }
}

class BotellaRoja inherits ObjetoNoSolido {
  // var property position = game.at(12,1)
  var property puntos = 15
  method image() = "RedBottle.png"
  override method seRompe(player) {
    super(player)
    player.sumarPuntos(self.puntos())
  }
}

class Silla inherits ObjetoNoSolido {
  // var property position = game.at(13,1)
  var property puntos = 25
  method image() = "chair.png"
  override method seRompe(player) {
    super(player)
    player.sumarPuntos(self.puntos())
  }
}


class Wall {
    var property position
    var property image = 'solid-1.png'
    var property puntos = 0
    
    method esColisionable() = true
    method seRompe(player) = false
    method explotable() = false
}


/// POWERUPS (capaz no es necesario la superclase, pero vemos)
class Powerup {
  var property position

  method esColisionable() = false
  method seRompe(player) = true // No hace nada
  method explotable() = false
  
}

class AumentoExplosion inherits Powerup {

  method image() = "powerup-exp.png"

  method teEncontro(jugador) {
    jugador.aumExplosion()
    game.removeVisual(self)
  }
}
//---------------
class VidaMas inherits Powerup {

  method image() = "powerup-vida.png"

  method teEncontro(jugador) {
    jugador.vidaMas()
    game.removeVisual(self)
  }
}
//---------------
class PuntosDobles inherits Powerup {

  method image() = "powerup-puntos.png"

  method teEncontro(jugador) {
    jugador.puntosDobles()
    game.removeVisual(self)
  }
}
//---------------
class BombaMas inherits Powerup {

  method image() = "powerup-bomb.png"

  method teEncontro(jugador) {
    jugador.addBomba()
    game.removeVisual(self)
  }
}

// IMÁGENES
object tableroPiso{ 
  const property position = game.at(6,0)
  method image() = "wood-bg-680x600.png"}
object pantallaInicio{ 
  const property position = game.at(0,0)
  method image() = "fondoPantallaInicio.png"}
object tableroPuntajes{
  const property position = game.at(1,0)
  method image() = "wood-bg-160x600.png"}

object botonInicio1{ 
  const property position = game.at(8,5)
  method image() = "botonPressEnter.png"}
object botonInicio2{ 
  const property position = game.at(8,5)
  method image() = "botonPressEnter2.png"}
object pausa{
  const property position = game.at(9,3)
  method image() = "fondoPausa1.png"  }
object botonPausa1{
  const property position = game.at(10,7)
  method image() = "botonPausa1.png"}
object botonPausa2{
  const property position = game.at(10,5)
  method image() = "botonPausa2.png"}
object botonPausa1Color{
  const property position = game.at(10,7)
  method image() = "botonPausa3.png"}
object botonPausa2Color{
  const property position = game.at(10,5)
  method image() = "botonPausa4.png"}
object fondoModoJuego{
  const property position = game.at(0,0)
  method image() = "fondoModoDeJuegos.png"}
object botonUnJugador{
  const property position = game.at(8,4)
  method image() = "boton1Jugador.png"}
object botonDosJugadores{
  const property position = game.at(12.5,4)
  method image() = "boton2Jugadores.png"}
object botonUnJugador2{
  const property position = game.at(8,4)
  method image() = "boton1Jugador_2.png"}
object botonDosJugadores2{
  const property position = game.at(12.5,4)
  method image() = "boton2Jugadores_2.png"}


// ======================== Esto ya no se usa ========================== //

/// Constructores
// object item_constructor {
//   method wall_gen(_lista, kind) {
//     kind.construir(_lista)
//   }
// }
// object wall_constructor {
//   method construir(_lista) {
//     _lista.forEach({ n => 
//       const block = new Wall(position = game.at(n.get(0), n.get(1)))
//       game.addVisual(block)
//       })
//   }
// }
// object barril_generator {
//   method construir(_lista) {
//     _lista.forEach({ n => 
//     const block = new Barril (position = game.at(n.get(0), n.get(1)))
//     free_board.saved().clear()
//     game.addVisual(block)})
//   }
// }
// object ba_generator {
//   method construir(_lista) {
//     _lista.forEach({ n=> 
//     const block = new BotellaAzul (position = game.at(n.get(0), n.get(1)))
//     free_board.saved().clear()
//     game.addVisual(block)})
//   }
// }
// object br_generator {
//   method construir(_lista) {
//     _lista.forEach({ n=> 
//     const block = new BotellaRoja (position = game.at(n.get(0), n.get(1)))
//     free_board.saved().clear()
//     game.addVisual(block)})
//   }
// }

// object silla_generator {
//   method construir(_lista) {
//     _lista.forEach({ n=> 
//     const block = new Silla(position = game.at(n.get(0), n.get(1)))
//     free_board.saved().clear()
//     game.addVisual(block)})
//   }
// }

// // Espacios libres
// object free_board {
//   var property counter = 1
//   var property x = 0
//   var property y = 0
//   var property a = 0
//   var property b = 0
//   var property pos = []
//   var property saved = []

//   // 2 posiciones random
//   method pos_eval_x() {
//     a = 7.randomUpTo(21).truncate(0)
//     return a
//   }
//   method pos_eval_y() {
//     b = 1.randomUpTo(14).truncate(0)
//     return b
//   }
//   //Si no estan en la lista de listas, se setean x e y
//   method pos_eval(lvl) {
//     lvl.map().forEach({ n =>
//       pos = [self.pos_eval_x(), self.pos_eval_y()]
//       if(!(lvl.map().contains(pos)) and (counter <= 25) and !(canceled_slots.contains(pos))) {
//         x = pos.get(0)
//         y = pos.get(1)
//         saved.add([x,y]) // Se guardan las posiciones libres
//         counter += 1
//       }
//     })
//     // Para la proxima vuelta, estas tambien ya estan ocupadas
//     self.saved().forEach({ n => 
//       lvl.map().add(n)
//     })
//     counter = 1
//     pos.clear()
//   }
// }

// // Posiciones de arranque
// const canceled_slots = [
//   [7,1],[7,2],[7,12],[7,13],
//   [8,1],[8,13],
//   [20,1],[20,13],
//   [21,1],[21,2],[21,12],[21,13]
// ]