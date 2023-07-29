import objetos.*
import Ingredientes.*
import pedidos.*
import personaje.*
import wollok.game.*


object cocina {
	var puntaje = 0
	const property maximaFila = 12 
	const property maximaColumna = 18
	const property pedidosEnEspera = []
	
	method completarPedido(unPlato) {
		if (unPlato.size()== 4) {
			pedidosEnEspera.remove(completa)
			contadorDeCompletas.actualizar()
		} else if (unPlato.size()== 2) {
			pedidosEnEspera.remove(simple)	
			contadorDeSimples.actualizar()
		} else if (unPlato.contains((new Lechuga()).className())){
			pedidosEnEspera.remove(conLechuga)
			contadorDeConLechuga.actualizar()
		} else {
			pedidosEnEspera.remove(conTomate)
			contadorDeConTomate.actualizar()
		}
	}
	
	method cantidadDeCompletas() = pedidosEnEspera.count({i=> i==completa})
	method cantidadDeSimples() = pedidosEnEspera.count({i=> i==simple})
	method cantidadDeConTomate() = pedidosEnEspera.count({i=> i==conTomate})
	method cantidadDeConLechuga() = pedidosEnEspera.count({i=> i==conLechuga})
	
	
	method sumarPuntaje(unPlato) {
		puntaje += unPlato.puntosQueOtorga()
		self.completarPedido(unPlato.tipoDeIngredientesApoyados())
		console.println(puntaje)
		game.say(mascota,"Bien hecho,tienes un total de "+puntaje.toString()+" puntos")
	}
	
	method puntaje() = puntaje
	
	method buscarPedido(unPlato) = self.tipoDePedidosEnEspera().find(unPlato)
	
	method tipoDePedidosEnEspera() = pedidosEnEspera.map({p=>p.tipoDeIngredientes()})
	
	method generarPedidos(){
		const menu = [completa, simple, conTomate, conLechuga]
		pedidosEnEspera.add(menu.get(0.randomUpTo(3)))
	}
	
	method recibirPedido(){
		game.onTick(17500, 'nuevoPedido', {self.generarPedidos()})
	}
}

object contadorDeCompletas {
	var image
	const property position = game.at(17,7)	
	method image() = "numeros/"+ cocina.cantidadDeCompletas() +".png"
	method actualizar() {
		image = self.image()
	}
}

object contadorDeConTomate {
	var image
	const property position = game.at(17,5)	
	method image() = "numeros/"+ cocina.cantidadDeConTomate() +".png"
	method actualizar() {
		image = self.image()
	}
}

object contadorDeConLechuga {
	var image
	const property position = game.at(17,3)
	method image() = "numeros/"+ cocina.cantidadDeConLechuga() +".png"
	
	method actualizar() {
		image = self.image()
	}
}

object contadorDeSimples {
	var image
	const property position = game.at(17,1)
	method image() = "numeros/"+ cocina.cantidadDeSimples() +".png"
	method actualizar() {
		image = self.image()
	}
}


object mascota {
	var image
	const property position = game.at(1, 10)
	method image() = "burgi.png"
	method actualizar() {
		image = self.image()
	}
}