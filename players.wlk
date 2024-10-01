import extras.*

class Player {
  var property position
  const imagen
  const imagen2
  var cambioImg = true
  var property largoExplosion = 1

  method image() = if(cambioImg) imagen else imagen2
  method cambiarImg() {
    if(cambioImg) cambioImg = false
    else cambioImg = true
  }

  method limiteL() = self.position().x().between(8, 21)
  method limiteR() = self.position().x().between(7, 20)
  method limiteU() = self.position().y().between(1, 12)
  method limiteD() = self.position().y().between(2, 14)

  method colisionL() = game.getObjectsIn(self.position().x() - 1).size() == 0
  method colisionR() = game.getObjectsIn(self.position().x() + 1).size() == 0

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
}

const player1 = new Player(position = game.at(7,1), imagen = "player-1-idle.png", imagen2 = "player-1-run-2.png")
const player2 = new Player(position = game.at(21,1), imagen =  "player-2-idle.png", imagen2 = "player-2-run-2.png")
