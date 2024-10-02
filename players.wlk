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

  method limiteL() = self.position().x().between(8, 21)
  method limiteR() = self.position().x().between(7, 20)
  method limiteU() = self.position().y().between(1, 12)
  method limiteD() = self.position().y().between(2, 14)

  method colisionL() = self.esNoColisionable(game.getObjectsIn(game.at(self.position().x() - 1,self.position().y())))

  method colisionR() = game.getObjectsIn(game.at(self.position().x() + 1,self.position().y())).isEmpty()
  method colisionU() = game.getObjectsIn(game.at(self.position().x(),self.position().y() + 1)).isEmpty()
  method colisionD() = game.getObjectsIn(game.at(self.position().x(),self.position().y() - 1)).isEmpty()

  method esNoColisionable(objSet) = objSet.isEmpty() || objNoColisionables.contains(objSet.asList().first())

  method moveTo(nuevaPosicion) {
		  position = nuevaPosicion
      self.cambiarImg()
	}

  method ponerBomba(posicion) {
    const bomba = new Bomba(position = posicion)
    game.addVisual(bomba)
    bomba.explota(largoExplosion.min(3))
    game.schedule(2500, {game.removeVisual(bomba)})
  }

  method aumExplosion() {
    largoExplosion += 1
  }

  method teEncontro(jugador) {
    game.say(jugador, "que onda pa")
  }

  method tieneVida() = self.vidas() > 0

  method perderVida() {
    if(self.tieneVida()){
      vidas -= 1
    }
    self.muere()
  }

  method vidaMas() {
    if(!self.vidas().equals(3)) self.vidas(1)
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
class Wall {
    var property image = 'solid-1.png'
    var property position
    
    method action() {
        //no pasar
    }
}
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