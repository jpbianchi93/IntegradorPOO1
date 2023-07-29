import wollok.game.*
import pantallas.*
import mapa.*

object cronometroInGame{
	method numeros(tiempoTotal,cronometro,position){
		const cantidadDeDigitos= tiempoTotal.toString().size()
		cantidadDeDigitos.times({i=>game.addVisual(new Numero(posicionNumero=i-1,cronometro=cronometro,position=position))})
	}
}

class Cronometro {
	const tiempoTotal
	const frecuencia
	var property tiempoTranscurrido = 0
	
	method empezar() {
		game.onTick(1000/frecuencia, "contadorDeTiempo", {self.contador()})
	}
	method detener(){
		game.removeTickEvent("contadorDeTiempo")
	}
	
	method velocidadDelTiempo() = 1000/frecuencia	//1000ms = 1seg
	method tiempoRestante() = tiempoTotal-tiempoTranscurrido*self.velocidadDelTiempo()
	method contador(){
		if(self.tiempoRestante()<=0) {
			self.detener()
			pantalla.cambiarPantalla()
			musica.stop()
		}
		tiempoTranscurrido+=1
	}
	method numero() = (self.tiempoRestante()/1000).truncate(0)
}

class Numero {
	var posicionNumero
	var position
	var cronometro
	var image = self.image()
	
	method position()= position.right(posicionNumero)
	method imagenes(){
		const string = cronometro.numero().toString()
		return if (string.size() - 1 < posicionNumero)
			"vacio"
		else
			string.charAt(posicionNumero)
	}
	method image() = "numeros/"+self.imagenes()+".png"
	method actualizar() {
		image = self.image()
	}
}
