load 'Jugadas.rb'

class Estrategia
    attr_accessor :jugador, :SEMILLA
    SEMILLA = 42

    def prox(jugada_pasada=nil)
        if !(jugada_pasada == nil or
            (jugada_pasada.is_a? Jugada and jugada_pasada.class != Jugada))
            raise ArgumentError.new('La jugada pasada no es nil ni una subclase de Jugada')
        end
    end

    def initialize(jugador=nil)
        @jugador = jugador
    end

    def to_s
        "Jugador: #{@jugador} - Estrategia: #{self.class} "
    end

    def reset
    end

    def inspect
        self.to_s
    end
end

class Manual < Estrategia

    def prox(jugada_pasada)
        super jugada_pasada
        opcion = ""
        opciones_posibles = ["1", "2", "3", "4", "5"]
        while !(opciones_posibles.include? opcion) do
            puts ( "Indique un valor para su jugada
                    1- Piedra
                    2- Papel
                    3- Tijeras
                    4- Lagarto
                    5- Spock")
            opcion = gets.to_s
        end
        inputs_para_manual = {
            "1" => Piedra,
            "2" => Papel,
            "3" => Tijeras,
            "4" => Lagarto,
            "5" => Spock
        }
        inputs_para_manual[opcion].new
    end
end

class Copiar < Estrategia
    attr_accessor :primeraJugada, :reiniciar

    def initialize(primeraJugada, jugador=nil)
        if !(primeraJugada.is_a? Jugada and primeraJugada.class != Jugada)
            raise ArgumentError.new("La estrategia de Copia debe inicializar con una subclase de Jugada")
        end
        self.jugador = jugador
        self.primeraJugada = primeraJugada
        self.reiniciar = false
    end

    def prox(jugada_pasada=nil)
        super jugada_pasada
        if jugada_pasada == nil
            @primeraJugada
        else
            jugada_pasada
        end
    end

    def reset
        self.reiniciar = true
    end

end

class Uniforme < Estrategia
    attr_accessor :jugadas

    def initialize(jugadas, jugador=nil)
        posibles_jugadas = [:Tijeras, :Papel, :Piedra, :Spock, :Lagarto]
        if jugadas.size == 0
            raise ArgumentError.new("La estrategia Uniforme debe tener una lista con al menos un elemento de tipo Jugada")
        end
        self.jugadas = jugadas.uniq
        self.jugadas.each do |x|
            if !(posibles_jugadas.include? x)
                raise ArgumentError.new("La estrategia Uniforme debe tener una lista unicamente con Jugadas")
            end
        end
        self.jugador = jugador
    end

    def prox(jugada_pasada=nil)
        super jugada_pasada
        retornos = {
            :Tijeras => Tijeras,
            :Papel => Papel,
            :Piedra => Piedra,
            :Spock => Spock,
            :Lagarto => Lagarto
        }
        posicion = Random.new(SEMILLA)
        posicion = posicion.rand(self.jugadas.size)
        retornos[self.jugadas[posicion]].new
    end
end


class Pensar < Estrategia
    def initialize
        @historial = []
    end

    def prox(jugada_pasada)
        super jugada_pasada
        if jugada_pasada != nil
            @historial.push jugada_pasada
        end
        numPiedras = @historial.count{|x| x.is_a? Piedra}
        numPapel   = @historial.count{|x| x.is_a? Papel}
        numTijeras = @historial.count{|x| x.is_a? Tijeras}
        numLagarto = @historial.count{|x| x.is_a? Lagarto}
        numSpock   = @historial.count{|x| x.is_a? Spock}
        total = numPiedras + numPapel + numTijeras + numSpock + numLagarto
        if total==0 or total==1
            numLagarto,numPapel,numPiedras,numSpock,numTijeras,total = 1,1,1,1,1,5
        end
        posicion = Random.new(SEMILLA)
        posicion = posicion.rand(total-1)

        case posicion
            when 0...numPiedras
                Piedra.new
            when numPiedras...numPiedras+numPapel
                Papel.new
            when numPiedras+numPapel...numPiedras+numPapel+numTijeras
                Tijeras.new
            when numPiedras+numPapel+numTijeras...numPiedras+numPapel+numTijeras+numLagarto
                Lagarto.new
            when numPiedras+numPapel+numTijeras+numLagarto...total
                Spock.new
        end
    end

    def reset
        @historial = []
    end
end

class Sesgada < Estrategia
    def initialize probs_sesgadas
        posibles_jugadas = [:Tijeras, :Papel, :Piedra, :Spock, :Lagarto]
        simbolos_a_jugadas = {
            :Tijeras => Tijeras,
            :Papel => Papel,
            :Piedra => Piedra,
            :Spock => Spock,
            :Lagarto => Lagarto
        }
        # La estrategia para escoger los elementos es crear un arreglo de Jugadas
        # donde las mismas aparecen consecutivamente el numero de veces que el hash
        # pasado como argumento indique. Al momento de jugar se genera un numero
        # entre 0 y la suma de los valores (la longitud de este arreglo).
        @jugadas_posibles = []
        probs_sesgadas.each do |key, val|
            if !(posibles_jugadas.include? key)
                raise ArgumentError.new('Las claves del argumento de Sesgada deben ser simbolos a las jugadas')
            end
            if !(val.is_a? Integer)
                raise ArgumentError.new('Los valores del argumento de Sesgada deben ser numeros')
            end
            val.times do
                @jugadas_posibles.push(simbolos_a_jugadas[key])
            end
        end
    end
    def prox(jugada_pasada=nil)
        super jugada_pasada
        posicion = Random.new(SEMILLA)
        posicion = posicion.rand(@jugadas_posibles.size)
        @jugadas_posibles[posicion].new
    end
end



if __FILE__ == $0
    sesgada = Sesgada.new({
        :Piedra => 2,
        :Papel => 0,
        :Tijeras => 4,
        :Lagarto => 3,
        :Spock => 2
    })
    puts sesgada.prox().to_s
end
