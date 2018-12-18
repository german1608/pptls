load 'Estrategias.rb'
load 'Jugadas.rb'

# Ejemplo de llamada  p = Partida.new({:'G'=>Estrategia.new, :'P'=>Estrategia.new})

class Partida
    attr_accessor :puntos, :jugador1, :jugador2, :historial
    
    def initialize(datos)
        @puntos = [0,0]
        if(datos.keys.size !=2)
            raise ArgumentError.new('Deben haber exactamente dos jugadores')
        end
        datos.keys.each{|key| 
            if !(datos[key].is_a? (Estrategia))
                raise ArgumentError.new("Cada jugador debe venir asociado con una estrategia")
            end
            datos[key].jugador = key.to_s
        }
        @jugador1 = datos[datos.keys[0]]
        @jugador2 = datos[datos.keys[1]]
        @historial = []
    end

    def to_s
        "Partida entre:
        #{self.jugador1}
        #{self.jugador2}
        Puntuacion #{self.puntos}"
    end

    def inspect
        self.to_s
    end

    def SumarPuntos(entrada)
        self.puntos = [self.puntos, entrada].transpose.map {|x| x.reduce(:+)}
    end

    def prox
        jug1 = jugador1.prox(self.historial)
        jug2 = jugador2.prox(self.historial)
        resultado = jug1.puntos(jug2)
        self.historial.push([jug1,jug2])
        self.SumarPuntos(resultado)
    end

end