import wollok.game.*
import cocina.*
import Ingredientes.*
import personaje.*

class Superficie {
	const property esSuperficie = true
	var property image = self.image()
	var ingredienteApoyado = null
	
	method estaOcupada() = ingredienteApoyado != null
	
	method ponerIngrediente(unIngrediente) {
		if(self.estaOcupada() and !ingredienteApoyado.esPlato())
			self.error('Ya hay un ingrediente aquí')
		if (self.estaOcupada() and ingredienteApoyado.esPlato()) {
			ingredienteApoyado.agregarIngrediente(unIngrediente)
			self.actualizarImagen()
			game.removeVisual(unIngrediente)
		}
		else {
			ingredienteApoyado = unIngrediente
			self.actualizarImagen()
		}
	}
	
	method actualizarImagen(){
		image = self.image()
	}
	
	method sacarIngrediente(){
		ingredienteApoyado = null
	}
	
	method ingredienteApoyado() = ingredienteApoyado
	method accion() {}
	method esDespensa() = false
}

class Despensa inherits Superficie {
	method initialize() {
		image = self.image()
	}
	override method esDespensa() = true
}

class DespensaDePan inherits Despensa {
	override method ingredienteApoyado() = if(self.estaOcupada()){super()}else {new Pan()}
	override method image() = 'box-bun.png'
}

class DespensaDeTomate inherits Despensa {
	override method ingredienteApoyado() = if(self.estaOcupada()){super()}else{new Tomate()}
	override method image() = 'box-tomato.png'
}

class DespensaDePaty inherits Despensa {
	override method ingredienteApoyado() = if(self.estaOcupada()){super()}else{new Paty()}
	override method image() = 'box-patty.png'
}

class DespensaDeLechuga inherits Despensa {
	override method ingredienteApoyado() = if(self.estaOcupada()){super()}else{new Lechuga()}
	override method image() = 'box-lettuce.png'
}


class TablaDePicar inherits Superficie {
	method initialize() {
		image = self.image()
	}
	override method image() = if(self.estaOcupada()){ingredienteApoyado.nombre() + '-cutting-board-wood-block.png'}else{'knife-cutting-board-wood-block.png'}
	override method accion() {
		ingredienteApoyado.picar()
	}
}

class Plancha inherits Superficie {
	const tiempoCoccion = 5000
	const property numero
	
	method initialize() {
		image = self.image()
	}
	
	method cocinar() {
		if (ingredienteApoyado.sePuedeCocinar()){
				game.schedule(tiempoCoccion ,{ingredienteApoyado.cocinar()})
		}
	}
	override method image() = if(self.estaOcupada()){'block-red-gas-hob-frying-pan-meat-raw-patty' + numero + '.png'}else{'block-red-gas-hob-frying-pan' + numero + '.png'}
	
	override method ponerIngrediente(unIngrediente) {
		if(!unIngrediente.sePuedeCocinar()) {self.error('Este Ingrediente no necesita cocinarse')}
		super(unIngrediente)
		if(self.estaOcupada() and !unIngrediente.sePuedePicar()){
			self.cocinar()
		}
	}
}

class Tacho inherits Superficie {
	override method ponerIngrediente(unIngrediente) {
		if (unIngrediente.esPlato()){
			unIngrediente.limpiarPlato()
		} else {
		game.removeVisual(unIngrediente)
		ingredienteApoyado = null
		}
	}
}

class Plato {
	const property ingredienteApoyado = #{}
	var image = self.image()
	const property esSuperficie = false
	var property position = null
	
	method sePuedeCocinar() = false
	method sePuedePicar() = false
	method esPlato() = true
	method agregarIngrediente(unIngrediente) {
		if(unIngrediente == self) {self.error('No puedes apilar platos')}
		else if(unIngrediente.sePuedePicar()) {self.error('Este ingrediente no esta picado')}
		else if(unIngrediente.sePuedeCocinar()) {self.error('Este ingrediente esta crudo')}
		else if(unIngrediente.className() != (new Pan()).className() and !self.tipoDeIngredientesApoyados().contains((new Pan()).className())) {self.error('Primero va el pan!')}
		else if (self.tipoDeIngredientesApoyados().contains(unIngrediente.className())) {self.error('Ya está el ingrediente')}
		else {ingredienteApoyado.add(unIngrediente)}
	}
	method estaTerminado() = cocina.tipoDePedidosEnEspera().contains(self.tipoDeIngredientesApoyados())
	method puedeCocinarse() = false
	method limpiarPlato(){
		ingredienteApoyado.forEach({ing=>
			if(game.hasVisual(ing))
				game.removeVisual(ing)
		})
		ingredienteApoyado.clear()
		game.removeVisual(self)
	}
	method puntosQueOtorga() = ingredienteApoyado.size() * 10
	
	method tipoDeIngredientesApoyados() = ingredienteApoyado.map({i=>i.className()})
	
	method obtenerPlatoOrdenado() {
		const ordenDelPlato = ingredienteApoyado.asList()
		return ordenDelPlato.sortedBy({ingrediente1, ingrediente2=>ingrediente1.lugarEnElPlato() < ingrediente2.lugarEnElPlato()}).map({ingrediente=> ingrediente.nombre()})
	}
	method actualizar() {
		image = self.image()
	}
	method image() {
		if (ingredienteApoyado.size()==0) {return 'plate.png'} else {return 'plate-' + self.obtenerPlatoOrdenado().join('-') + '.png'}
	}	
}

class Recibidor inherits Superficie {
	const numero
	
	method initialize(){
		image = self.image()
	}
	override method estaOcupada() = false
	override method ponerIngrediente(unPlato) {
		if(!unPlato.estaTerminado()) {self.error('No es un pedido')}
		cocina.sumarPuntaje(unPlato)
		unPlato.limpiarPlato()
	}
	override method ingredienteApoyado() = null	
	override method image() = 'deliver-table-' + numero + ".png"
}

class Mesada inherits Superficie {
	method initialize() {
		image = self.image()
	}
	override method image() = 'wood-block.png'
}

class DispenserDePlatos inherits Superficie {
	method initialize() {
		image = self.image()
	}
	override method esDespensa() = true
	override method image() = 'plate-dispenser.png'
	override method ingredienteApoyado() = if(self.estaOcupada()){super()}else{new Plato()}
}

class Fregadero inherits Superficie {
	const numero
	method initialize() {
		image = self.image()
	}
	override method image() = 'sink-' + numero + ".png"
}