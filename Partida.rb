load 'Estrategias.rb'
load 'Jugadas.rb'

##
# La partida permite hacer varias rondas a la vez, o jugar
# hasta que se alcance un puntaje dado.
class Partida
    ##
    # Arreglo de puntos cuya primera posición es el puntaje
    # del primer jugador y la segunda el puntaje del segundo.
    attr_accessor :puntos

    ##
    # +Estrategia+ del jugador 1.
    attr_accessor :jugador1

    ##
    # +Estrategia+ del jugador 2.
    attr_accessor :jugador2

    ##
    # +Jugada+ Jugada del turno anterior del jugador 1
    attr_accessor :jugada_previa_j1

    ##
    # +Jugada+ Jugada del turno anterior del jugador 1
    attr_accessor :jugada_previa_j2

    ##
    # Cantidad de rondas que han pasados desde que se creo la partida o
    # desde el ultimo reinicio
    :acumulado

    ##
    # El constructor recibe un +Hash* con dos claves. Dichas claves son los nombres
    # de los jugadores de la partida. Los valores del hash son instancias
    # de las subclases de Estrategias.
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

    ##
    # Retorna la partida como un string.
    def to_s
        "Partida entre:
        #{self.jugador1.to_s}
        #{self.jugador2.to_s}
        Puntuacion #{self.puntos}"
    end

    def inspect
        self.to_s
    end

    ##
    # Actualiza los puntos de la partida.
    #
    # Parámetros
    # +entrada+ :: Arreglo de dos enteros resultado del método puntos de las +Jugada+s.
    def SumarPuntos(entrada)
        self.puntos = [self.puntos, entrada].transpose.map {|x| x.reduce(:+)}
    end

    ##
    # Realiza una ronda en el juego
    def prox
        self.acumulado += 1
        jug1 = @jugador1.prox(@jugada_previa_j2)
        jug2 = @jugador2.prox(@jugada_previa_j1)
        resultado = jug1.puntos(jug2)
        @jugada_previa_j1 = jug1
        @jugada_previa_j2 = jug2

        self.SumarPuntos(resultado)
    end

    ##
    # Reinicia la partida:
    # - El puntaje a +[0, 0]+
    # - Llama al reset de los jugadores
    # - Inicializa a 0 el acumulado (cantidad de rondas)
    def reiniciar
        self.puntos=[0,0]
        @jugador1.reset
        @jugador2.reset
        self.acumulado = 0
    end

    ##
    # Retorna como un hash el puntaje de cada jugador y la cantidad
    # de rondas pasadas
    def calcular_resultado
        {@jugador1.jugador => @puntos[0], @jugador2.jugador => @puntos[1], :Rounds => @acumulado}
    end

    ##
    # Ejecuta +numRondas+ en la partida, actualizando las estructuras
    # necesarias.
    def rondas(numRondas)
        numRondas.times do |x|
            self.prox
            puts " Ronda #{x+1} :  #{@jugada_previa_j1.to_s}  - #{@jugada_previa_j2.to_s}
                   Puntuacion #{self.puntos}
                   --------------------------------------------------------
                "
            x += 1
        end
        calcular_resultado
    end

    ##
    # Juega rondas hasta que alguno de los jugadores tenga como puntaje +objetivo+.
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
