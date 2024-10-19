import players.*
import niveles.*

/// VISUALES TABLERO
object tableroPiso {
  const property position = game.at(6,0)

  method image() = "wood-bg-680x600.png"
}
object tableroPuntajes {
  const property position = game.at(2,0)

  method image() = "wood-bg-80x600.png"
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

/// OBJETO BOMBA
class Bomba {
  var property position

  method image() = "bomb.png"
  method explota(largoExplosion, player) {
    const explosion = new Explosion(position = self.position().down(largoExplosion.min(3)).left(largoExplosion.min(3)), largo = largoExplosion.min(3))
    game.schedule(3000, {
      game.addVisual(explosion)
      explosion.colisiones()
    })
    game.schedule(4000, {
      game.removeVisual(explosion)
    })
  }
  method esColisionable() = true
  method teEncontro(player) = true // No hace nada
  method explota() = true // No hace nada

}

class Explosion {
  var property position
  var property largo 
  const property indexLargos = []
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
  
  method teEncontro(player) {
    // player.perderVida()
    self.colisiones()
  }

   method colisiones() {
    var objetos = []

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().left(opLargo))})
    if (!objetos.isEmpty()) objetos.forEach({obj => obj.explota()})
    // objetos.clear()

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().right(opLargo))})
    if (!objetos.isEmpty()) objetos.forEach({obj => obj.explota()})
    // objetos.clear()

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().up(opLargo))})
    if (!objetos.isEmpty()) objetos.forEach({obj => obj.explota()})
    // objetos.clear()

    objetos = self.indexLargos().flatMap({ opLargo => game.getObjectsIn(self.centro().down(opLargo))})
    if (!objetos.isEmpty()) objetos.forEach({obj => obj.explota()})
    // objetos.clear()
    
    }

}

/// OBJETOS COLISIONES
class ObjetoNoSolido {
  var property position
  var property bonuses = #{new AumentoExplosion(position = self.position()),new VidaMas(position = self.position()), new PuntosDobles(position = self.position()),new BombaMas(position = self.position())} //Esta en class Bonus
  method esColisionable() = true

  method explota() {
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
    var property puntos = 0
    
    method esColisionable() = true
    method explota() = false
}


/// POWERUPS (capaz no es necesario la superclase, pero vemos)
class Powerup {
  var property position

  method esColisionable() = false
  method explota() = true // No hace nada

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

/// Constructores
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
    b = 1.randomUpTo(14).truncate(0)
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