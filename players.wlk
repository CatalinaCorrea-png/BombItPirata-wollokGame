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
  var property bombas = 5
  var property boolBomba = false

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
    if (self.puedePonerBomba()){
      const bomba = new Bomba(position = posicion)
      game.addVisual(bomba)
      boolBomba = true
      bombas -= 1
      game.schedule(3000, {
        game.removeVisual(bomba)
        boolBomba = false})
      bomba.explota(largoExplosion.min(3), self)
    } else if(bombas == 0) {
      game.say(self, "No tengo mas bombas!")
    }
  }

  method puedePonerBomba() {
    return bombas > 0 && !self.boolBomba()
  }

  // BONUSES
  method aumExplosion() {
    largoExplosion += 1
  }

  method teEncontro(jugador) {
    game.say(jugador, "que onda pa")
  }

  method vidaMas() {
    if(!self.vidas().equals(3)) vidas += 1
  }

  method puntosDobles() {
    puntaje * 2
  }
  
  method addBomba() {
    bombas += 1
  }

  // VIDA/MUERTE
  method tieneVida() = self.vidas() > 0

  method explota() {
    self.perderVida()
  }

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

const player1 = new Player(position = game.at(7,1), imagen = "player-1-idle.png", imagen2 = "player-1-run.png", imagenDead = "player-1-dead.png")
const player2 = new Player(position = game.at(21,1), imagen =  "player-2-idle.png", imagen2 = "player-2-run.png", imagenDead = "player-2-dead.png")
const player3 = new Player(position = game.at(7,13), imagen = "player-3-idle.png", imagen2 = "player-3-run.png", imagenDead = "player-3-dead.png")
const player4 = new Player(position = game.at(21,13), imagen = "player-4-idle.png", imagen2 = "player-4-run.png", imagenDead = "player-4-dead.png")
const vidaPlayer1 = new Vidas(position = game.at(2,11), player = player1)
const vidaPlayer2 = new Vidas(position = game.at(2,8), player = player2)
const vidaPlayer3 = new Vidas(position = game.at(2,5), player = player3)
const vidaPlayer4 = new Vidas(position = game.at(2,2), player = player4)
const caraPlayer1 = new CaraPlayer(position = game.at(3,12), player = player1, imagen = "player-1-head.png", imagen2 = "player-1-head-dead.png")
const caraPlayer2 = new CaraPlayer(position = game.at(3,9), player = player2, imagen = "player-2-head.png", imagen2 = "player-2-head-dead.png")
const caraPlayer3 = new CaraPlayer(position = game.at(3,6), player = player3, imagen = "player-3-head.png", imagen2 = "player-3-head-dead.png")
const caraPlayer4 = new CaraPlayer(position = game.at(3,3), player = player4, imagen = "player-4-head.png", imagen2 = "player-4-head-dead.png")
