load 'Estrategias.rb'
load 'Jugadas.rb'

# Ejemplo de llamada  p = Partida.new({:'G'=>Estrategia.new, :'P'=>Estrategia.new})

class Partida
    attr_accessor :puntos, :jugador1, :jugador2, :historial, :acumulado
    
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
        @historial = [[],[]]
        @acumulado = 0
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
        self.acumulado += 1
        jug1 = jugador1.prox(self.historial[1])
        jug2 = jugador2.prox(self.historial[0])
        resultado = jug1.puntos(jug2)
        self.historial[0].push(jug1)
        self.historial[1].push(jug2)
        self.SumarPuntos(resultado)
        print resultado
    end

    def reiniciar
        self.puntos=[0,0]
        self.historial = [[],[]]
    end

    def rondas(numRondas)
        x = 1
        while x <= numRondas
            self.prox
            puts " Ronda #{x} :  #{historial[0].last}  - #{historial[1].last}
                   Puntuacion #{self.puntos}
                   --------------------------------------------------------
                "
            x += 1
        end
    end

    def alcanzar(objetivo)
        while (puntos[0]!= objetivo and puntos[1]!= objetivo)
            self.prox
            puts " Ronda #{self.acumulado} :  #{historial[0].last}  - #{historial[1].last} \n Puntuacion #{self.puntos} "
            puts " --------------------------------------------------------"
        end
    end

end

def ParseSesgado(texto)
    pares = texto.split(';')
    listado = []
    for par in pares
        temp = par.split("(")[1].split(",")
        opcion = temp [0]
        probabilidad = temp[1].split(")")[0].to_i
        case opcion 
            when /(P|p)iedra/
                jugada = Piedra.new
            when /(P|p)apel/
                jugada = Papel.new
            when /(T|t)ijeras/
                jugada = Tijeras.new
            when /(S|s)ock/
                jugada = Spock.new
            when /(L|l)agarto/
                jugada = Lagarto.new
        end 
        listado.push([jugada,probabilidad])     
        print "Logrado #{jugada} con #{probabilidad}\n"
        print jugada.puntos(Tijeras.new)
    end
end

def ParseUniforme(texto)
    opciones = texto.split(',')
    listado = []
    for opcion  in opciones
        case opcion 
            when /(P|p)iedra/
                jugada = Piedra.new
            when /(P|p)apel/
                jugada = Papel.new
            when /(T|t)ijera(s)?/
                jugada = Tijeras.new
            when /(S|s)ock/
                jugada = Spock.new
            when /(L|l)agarto/
                jugada = Lagarto.new
        end 
        listado.push(jugada)     
    end
    return listado
end
