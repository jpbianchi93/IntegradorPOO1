import pedidos.*

object a {
	const property pedidosEnEspera = #{}
	method generarPedidos(){
		const menu = [completa, simple, conTomate, conLechuga]
		pedidosEnEspera.add(menu.get(0.randomUpTo(3)))
	}
}
