import Ingredientes.*

class Pedido {
	const property ingredientes = #{}
	method puntajeQueOtorga() = 10 * ingredientes.size()
	method tipoDeIngredientes() = ingredientes.map({i=>i.className()})
	method image()
}

object completa inherits Pedido {
	method initialize() {
		ingredientes.addAll([new Pan(), new Lechuga(), new Tomate(), new Paty()])	 
	}
	override method image() = 'completa.png'
}

object conTomate inherits Pedido {
	method initialize() {
		ingredientes.addAll([new Pan(), new Tomate(), new Paty()])
	}
	override method image() = 'patty-tomate.png'   
}

object conLechuga inherits Pedido {
	method initialize() {
		ingredientes.addAll([new Pan(), new Lechuga(), new Paty()])
	}
	override method image() = 'patty-lechuga.png'  
}

object simple inherits Pedido {
	method initialize() {
		ingredientes.addAll([new Pan(), new Paty()])
	}
	override method image() = 'simple.png'  
}