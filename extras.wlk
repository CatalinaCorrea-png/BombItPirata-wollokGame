
object tableroPiso {
  const property position = game.at(6,0)

  method image() = "wood-bg-680x600.png"
}
object tableroPuntajes {
  const property position = game.at(2,0)

  method image() = "wood-bg-80x600.png"
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