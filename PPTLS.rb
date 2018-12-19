load 'Partida.rb'

Shoes.app {
    boton = button "Hola"
    piedra = image 'imagenes/rock.png'
    piedra.click do
        piedra.replace image 'imagenes/scissors.png'
    end

}

