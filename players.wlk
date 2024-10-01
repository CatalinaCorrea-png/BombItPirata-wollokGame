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
  var property objNoColisionables = #{0}

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
    if(!self.vidas().equals(3)) {
      vidas += 1
      }
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
const player2 = new Player(position = game.at(21,1), imagen =  "player-2-idle.png", imagen2 = "player-2-run-2.png", imagenDead = "player-2-dead.png")
