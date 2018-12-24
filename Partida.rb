load 'Estrategias.rb'
load 'Jugadas.rb'

# Ejemplo de llamada  p = Partida.new({:'G'=>Estrategia.new, :'P'=>Estrategia.new})

class Partida
    attr_accessor :puntos, :jugador1, :jugador2, :jugada_previa_j1, :jugada_previa_j2, :acumulado

    def initialize(datos)
        @puntos = [0,0]
        if(datos.keys.size !=2)
            raise ArgumentError.new('Deben haber exactamente dos jugadores')
        end
        datos.keys.each{|key|
            if !(datos[key].is_a? (Estrategia))
                raise ArgumentError.new("Cada jugador debe venir asociado con una estrategia")
            end
            if key == :Rounds
                raise ArgumentError.new("No te puedes llamar :Rounds. ¿Por qué? Porque aquí mando yo")
            end
            datos[key].jugador = key
        }
        @jugador1 = datos[datos.keys[0]]
        @jugador2 = datos[datos.keys[1]]
        @jugada_previa_j1 = nil
        @jugada_previa_j2 = nil
        @acumulado = 0
    end

    def to_s
        "Partida entre:
        #{self.jugador1.to_s}
        #{self.jugador2.to_s}
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
        jug1 = @jugador1.prox(@jugada_previa_j2)
        jug2 = @jugador2.prox(@jugada_previa_j1)
        resultado = jug1.puntos(jug2)
        @jugada_previa_j1 = jug1
        @jugada_previa_j2 = jug2

        self.SumarPuntos(resultado)
    end

    def reiniciar
        self.puntos=[0,0]
        @jugador1.reset
        @jugador2.reset
        self.acumulado = 0
    end

    def calcular_resultado
        {@jugador1.jugador => @puntos[0], @jugador2.jugador => @puntos[1], :Rounds => @acumulado}
    end
    def rondas(numRondas)
        x = 1
        while x <= numRondas
            self.prox
            puts " Ronda #{x} :  #{@jugada_previa_j1.to_s}  - #{@jugada_previa_j2.to_s}
                   Puntuacion #{self.puntos}
                   --------------------------------------------------------
                "
            x += 1
        end
        calcular_resultado
    end

    def alcanzar(objetivo)
        while (puntos[0]!= objetivo and puntos[1]!= objetivo)
            self.prox
            puts " Ronda #{self.acumulado} :  #{@jugada_previa_j1.to_s}  - #{@jugada_previa_j2.to_s}
                   Puntuacion #{self.puntos} "
            puts " --------------------------------------------------------"
        end
        calcular_resultado
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
            when /(S|s)pock/
                jugada = Spock.new
            when /(L|l)agarto/
                jugada = Lagarto.new
        end
        listado.push(jugada)
    end
    return listado
end

if __FILE__ == $0
    partida = Partida.new({
        :German => Copiar.new(Piedra.new),
        :Gabriel => Copiar.new(Papel.new)
    })
    puts partida.rondas(10)
    puts partida.rondas(10)
    puts partida.alcanzar(100)
end
