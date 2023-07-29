import mapa.*
import wollok.game.*
import mapa.*
import cocina.*

object pantalla {
	method empezar() {
		game.width(cocina.maximaColumna())
		game.height(cocina.maximaFila())
		game.addVisual(inicio)
		keyboard.x().onPressDo({mapa.crearNivel()})
		keyboard.p().onPressDo({game.stop()})
	}
	
	method cambiarPantalla() {
		game.clear()
		game.addVisual(fin)
		keyboard.r().onPressDo({self.empezar()})
	}
}

object inicio {
	const property position = game.origin
	var image
	
	method image() = 'inicio.png'
	method actualizar() {
		image = self.image()
	}
}

object fin {
	const property position = game.origin
	var image 
	method image() {return
		if(cocina.puntaje() > 240)
			'victoria.png'
		else
			'badending.png'
	}
	method actualizar() {
		image = self.image()
	}
	
	method volverAlInicio() {
		game.clear()
		pantalla.empezar()
	}
}