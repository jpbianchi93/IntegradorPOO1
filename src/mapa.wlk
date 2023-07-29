import wollok.game.*
import cocina.*
import cronometro.*
import Ingredientes.*
import personaje.*
import objetos.*
import pedidos.*


object mapa {
	method crearNivel(){
		game.clear()
		game.width(cocina.maximaColumna())
		game.height(cocina.maximaFila())
		game.addVisual(pisoCocina)
		musica.loop()
		musica.play()
		
		//PERSONAJE
		const jugador1 = new Chef()
		game.addVisual(jugador1)
		
		//MOVIMIENTO
		keyboard.w().onPressDo({jugador1.arriba()})
		keyboard.a().onPressDo({jugador1.izquierda()})
		keyboard.s().onPressDo({jugador1.abajo()})
		keyboard.d().onPressDo({jugador1.derecha()})
		keyboard.space().onPressDo({jugador1.agarrarOSoltarObjeto()})
		keyboard.e().onPressDo({jugador1.accion()})
	
		//FILA DE ABAJO
		const noQuieresMesadaAbajo = #{3,5,8,10,12}
		(1..cocina.maximaColumna()-5).forEach({x =>  
		if (!noQuieresMesadaAbajo.contains(x)) {
			game.addVisualIn(new Mesada() , game.at(x , 1))	
			}
			game.addVisualIn(new TablaDePicar(), game.at(3,1)) 
			game.addVisualIn(new TablaDePicar(), game.at(5,1)) 
			game.addVisualIn(new Plancha(numero=1), game.at(8,1)) 
			game.addVisualIn(new Plancha(numero=1), game.at(10,1)) 
			game.addVisualIn(new DespensaDePan(),game.at(12,1)) 
		})
		
		//FILA DE ARRIBA
		const noQuieresMesadaArriba = #{3,4,9,11}
		(2..cocina.maximaColumna()-6).forEach({x =>  
			if (!noQuieresMesadaArriba.contains(x)) {
				game.addVisualIn(new Mesada() , game.at(x , 8))	
			}
			game.addVisualIn(new Fregadero(numero=1), game.at(3,8)) 
			game.addVisualIn(new Fregadero(numero=2), game.at(4,8)) 
			game.addVisualIn(new Plancha(numero=2), game.at(9,8))
			game.addVisualIn(new Plancha(numero=2), game.at(11,8)) 
		})
		
		//COLUMNA IZQUIERDA
		const noQuieresMesadaALaIzquierda = #{2,5,6,7}
		(2..cocina.maximaFila()-4).forEach({y =>  
			if (!noQuieresMesadaALaIzquierda.contains(y)) {
				game.addVisualIn(new Mesada() , game.at(1 , y))	
				}
			game.addVisualIn(new Tacho(image = 'trash-can.png'), game.at(1,2))
			game.addVisualIn(new DespensaDeLechuga(),game.at(1,5))
			game.addVisualIn(new DespensaDeTomate(),game.at(1,6)) 
			game.addVisualIn(new DespensaDePaty(),game.at(1,7)) 
		})
		
		//COLUMNA DERECHA
		const noQuieresMesadaALaDerecha = #{3,4,5}
		(2..cocina.maximaFila()-4).forEach({y => 
	    	if (!noQuieresMesadaALaDerecha.contains(y)) {
	        	game.addVisualIn(new Mesada(), game.at(13, y))
	    		}
	    	game.addVisualIn(new DispenserDePlatos(), game.at(13,3))
			game.addVisualIn(new Recibidor(numero=2), game.at(13,4)) 
			game.addVisualIn(new Recibidor(numero=1), game.at(13,5)) 
		})		
		
		game.addVisual(mascota)
		
		const tiempoDeJuego = 300000
		const cronometro = new Cronometro(tiempoTotal = tiempoDeJuego, frecuencia = 1)
		const positionCronometro = game.at(9, 11)
		cronometroInGame.numeros(tiempoDeJuego/1000,cronometro,positionCronometro)
		cronometro.empezar()
		
		5.times({i=>cocina.generarPedidos()})
		
		game.addVisual(contadorDeCompletas)
		game.addVisual(contadorDeSimples)
		game.addVisual(contadorDeConTomate)
		game.addVisual(contadorDeConLechuga)
		
		cocina.recibirPedido()
	}	 
}

object musica {
	const sonido = new Sound(file = './sounds/musica_corta.mp3')
	
	method loop() {sonido.shouldLoop(true)}
	method play() {sonido.play()}
	method stop() {sonido.stop()}
}

object pisoCocina {
	const property position = game.origin()
	var image = self.image()
	
	method image() = "pisococina.png"
	method actualizar() {
		image = self.image()
	}
}