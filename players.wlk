import extras.*

class Player {
  var property position
  const imagen
  const imagen2
  const imagenDead
  var cambioImg = true
  var property largoExplosion = 1
  var property puntaje = 0
  var property vidas = 3
    // Esto es admisible  ?
  var property objNoColisionables = #{0,player1,player2}
  method esColisionable() = true

  // IMAGEN
  method image() {
    if(!self.tieneVida()) {
      return imagenDead
    } else if(cambioImg) {
      return imagen 
    } else {
      return imagen2
    }
  }
  method cambiarImg() {
    if(cambioImg) cambioImg = false
    else cambioImg = true
  }

  // COLISIONES
  method limBordes(nuevaPosicion) = nuevaPosicion.x().between(7, 21) && nuevaPosicion.y().between(1, 13)

  method colisiones(nuevaPosicion) = self.esNoColisionable(game.getObjectsIn(nuevaPosicion))
  method esNoColisionable(objSet) = objSet.isEmpty() || !objSet.asList().first().esColisionable() // ! Porque puede pasar si el obj NO esColisionable() (!false)
  
  method canMoveHere(nuevaPosicion) = self.limBordes(nuevaPosicion) && self.colisiones(nuevaPosicion) && self.tieneVida()
  
  // ACCIONES 
  method moveTo(nuevaPosicion) {
    if (self.canMoveHere(nuevaPosicion)){
		  position = nuevaPosicion
      self.cambiarImg()
    }
	}

  method ponerBomba(posicion) {
    const bomba = new Bomba(position = posicion)
    game.addVisual(bomba)
    bomba.explota(largoExplosion.min(3))
    game.schedule(2500, {game.removeVisual(bomba)})
  }

  // BONUSES
  method aumExplosion() {
    largoExplosion += 1
  }

  method teEncontro(jugador) {
    game.say(jugador, "que onda pa")
  }

  method vidaMas() {
    if(!self.vidas().equals(3)) self.vidas(1)
  }

  // VIDA/MUERTE
  method tieneVida() = self.vidas() > 0

  method perderVida() {
    if(self.tieneVida()){
      vidas -= 1
    }
    self.muere()
  }

  method muere() {
    if(self.vidas().equals(0)) {
      const muerte = new Muerte(position = self.position().up(1))
      muerte.muere(self)
      // game.schedule(3000, game.removeVisual(self))
    }
  }


}

const player1 = new Player(position = game.at(7,1), imagen = "player-1-idle.png", imagen2 = "player-1-run-2.png", imagenDead = "player-1-dead.png")
const player2 = new Player(position = game.at(18,5), imagen =  "player-2-idle.png", imagen2 = "player-2-run-2.png", imagenDead = "player-2-dead.png")

// Constructor
object constructor {
    var property positions = [
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

    method wall_gen() {
        positions.forEach({ n => 
            const block = new Wall(position = game.at(n.get(0), n.get(1)))
            game.addVisual(block)
        })
    }
}