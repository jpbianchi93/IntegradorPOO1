import wollok.game.*
import cocina.*

class Ingrediente {
	var property porcentajeCortado = 0
	var property position 
	var property image 
	var property sePuedePicar = true
	var property sePuedeCocinar = false
	var property esSuperficie = false
	var lugarEnElPlato
	
	method lugarEnElPlato() = lugarEnElPlato
	method picar() {
		if (!sePuedePicar) {self.error('Ya esta picado')}
		porcentajeCortado += 25
		self.picarIngrediente()
	}
	
	method actualizarImagen(){
		image = self.image()
	}
	
	method picarIngrediente() {
		if(self.porcentajeCortado()==100){
			sePuedePicar = false
			self.actualizarImagen()
		}else {}
	}
	
	method estaPicado()
	
	method nombre()
	
	method platoTerminado() = false
	
	method image()
	
	method esPlato() = false
}

class Pan inherits Ingrediente {
	method initialize() {
		image = self.image()
		sePuedePicar = false
		lugarEnElPlato = 1
	}
	override method nombre() = 'bun'
	override method image() = self.nombre() + '-top-bottom.png'
	override method estaPicado() {}
}

class Paty inherits Ingrediente {
	method initialize() {
		image = self.image()
		sePuedeCocinar = true
		lugarEnElPlato = 2
	}
	override method nombre() = 'patty'
	override method image() =
		if (sePuedePicar and sePuedeCocinar) 
			self.nombre() + '.png'
		else if (!sePuedePicar and sePuedeCocinar)
			self.estaPicado()
		else
			self.estaCocinado()

	override method estaPicado() = 'raw-patty.png'
	method estaCocinado() = 'raw-cooked-patty.png'
	method cocinar() {
		if (!sePuedeCocinar) {self.error('Ya esta cocido')}
		sePuedeCocinar = false
		self.actualizarImagen()
	}
} 

class Tomate inherits Ingrediente {
	method initialize() {
		image = self.image()
		lugarEnElPlato = 3
	}
	override method nombre() = 'tomato'
	override method image() = if (sePuedePicar) {self.nombre() + '.png'} else {self.estaPicado()}
	override method estaPicado() = 'tomato-sliced.png'
}

class Lechuga inherits Tomate {
	method initialize() {
		image = self.image()
		lugarEnElPlato = 4
	}
	override method nombre() = 'lettuce'
	override method image() = if (sePuedePicar) {self.nombre() + '.png'} else {self.estaPicado()}
	override method estaPicado()  = 'lettuce-sliced.png'
}


