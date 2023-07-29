import objetos.*
import wollok.game.*
import cocina.*
import Ingredientes.*

class Chef {
		
	var property position = game.at(7,5)
	var property orientacion = 'down'
	var property image = 'player-' + orientacion + '.png'
	var superficieDelante = null
	var objetoEnMano = null
	
	method haySuperficieDelante() { return
		if (orientacion == 'up') {
	            game.getObjectsIn(position.up(1)).any({e => e.esSuperficie()})
	        } else if (orientacion == 'down') {
	            game.getObjectsIn(position.down(1)).any({e => e.esSuperficie()})
	        } else if (orientacion == 'left') {
	            game.getObjectsIn(position.left(1)).any({e => e.esSuperficie()})
	        } else if (orientacion == 'right') {
	            game.getObjectsIn(position.right(1)).any({e => e.esSuperficie()})
	        }
	 	}
	 	
	method obtenerSuperficieDelante(){ return
		if (orientacion == 'up') {
	            game.getObjectsIn(position.up(1)).find({e => e.esSuperficie()})
	        } else if (orientacion == 'down') {
	            game.getObjectsIn(position.down(1)).find({e => e.esSuperficie()})
	        } else if (orientacion == 'left') {
	            game.getObjectsIn(position.left(1)).find({e => e.esSuperficie()})
	        } else if (orientacion == 'right') {
	            game.getObjectsIn(position.right(1)).find({e => e.esSuperficie()})
	        }
	 	}
	
	method actualizarSuperficieDelante() {
		if (self.haySuperficieDelante()) {superficieDelante = self.obtenerSuperficieDelante()}
		else {superficieDelante = null}
	}
	
	method arriba() {
		orientacion = 'up'
	    self.actualizarImagen()
	    if (self.haySuperficieDelante()){superficieDelante = self.obtenerSuperficieDelante() }
	    else {
	        position = position.up(1)
	        self.actualizarSuperficieDelante()
	        }
	    self.actualizarPosicion(objetoEnMano)
	}
	
	method abajo() {
		orientacion = 'down'
	    self.actualizarImagen()
	    if (self.haySuperficieDelante()){superficieDelante = self.obtenerSuperficieDelante() }
	    else {
	        superficieDelante = null
	        position = position.down(1)
	        self.actualizarSuperficieDelante()
	        }
	    self.actualizarPosicion(objetoEnMano)
	  
	}
	
	method izquierda() {
		orientacion = 'left'
	    self.actualizarImagen()
	    if (self.haySuperficieDelante()){superficieDelante = self.obtenerSuperficieDelante() }
	    else {
	        superficieDelante = null
	        position = position.left(1)
	        self.actualizarSuperficieDelante()
	        }
	    self.actualizarPosicion(objetoEnMano)
	    
	}
	
	method derecha() {
		orientacion = 'right'
	    self.actualizarImagen()
	    if (self.haySuperficieDelante()){superficieDelante = self.obtenerSuperficieDelante() }
	    else {
	        superficieDelante = null
	        position = position.right(1)
	        self.actualizarSuperficieDelante()
	        }
	    self.actualizarPosicion(objetoEnMano)
	    
	}	
		
	method objetoEnMano() = objetoEnMano

	method actualizarImagen() {
    	image = 'player-' + orientacion + '.png'
	}
	method actualizarPosicion(unObjeto) {
	    if (unObjeto != null) {
	        if (orientacion == 'up') {
	            unObjeto.position(position.up(1))
	        } else if (orientacion == 'down') {
	            unObjeto.position(position.down(1))
	        } else if (orientacion == 'left') {
	            unObjeto.position(position.left(1))
	        } else if (orientacion == 'right') {
	            unObjeto.position(position.right(1))
	        }
	    } 
	}
	
	method posicionDelante() { return
		if (orientacion == 'up') {
	            position.up(1)
	    } else if (orientacion == 'down') {
	            position.down(1)
	    } else if (orientacion == 'left') {
	           position.left(1)
	    } else if (orientacion == 'right') {
	            position.right(1)
	        
	    } 
	}
	
	method dejarObjeto() {
		superficieDelante.ponerIngrediente(objetoEnMano)
		superficieDelante.actualizarImagen()
		objetoEnMano = null
	}
	
	method accion() {
		superficieDelante.accion()
	}
	
	method agarrarObjeto() {
		objetoEnMano = superficieDelante.ingredienteApoyado()
		self.actualizarPosicion(objetoEnMano)
		if (superficieDelante.esDespensa() and !superficieDelante.estaOcupada()) {
			game.addVisual(objetoEnMano)
		}
		superficieDelante.sacarIngrediente()
		superficieDelante.actualizarImagen()
	}
	
	method agarrarOSoltarObjeto(){
		if(objetoEnMano == null){
			self.agarrarObjeto()
		}
		else
			self.dejarObjeto()
	}
}