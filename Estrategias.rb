load 'Jugadas.rb'  

class Estrategia
    attr_accessor :jugador, :SEMILLA
    SEMILLA = 42

    def initialize(jugador=nil)
        @jugador = jugador
    end

    def prox(historial)
    end

    def to_s
        "Jugador: #{@jugador} - Estrategia: #{self.class}"
    end

    def inspect
        self.to_s
    end

    def reset
    end

end

class Manual < Estrategia
    
    def prox(historial)
        opcion = -1
        while opcion<1 or opcion>5 do
            print ( "Indique un valor para su jugada 
                    1- Piedra
                    2- Papel
                    3- Tijeras
                    4- Lagarto
                    5- Spock\n")
            opcion = gets.to_i
        end
        jugada = nil
        case opcion
            when 1
                jugada = Piedra.new
            when 2
                jugada = Papel.new
            when 3
                jugada = Tijeras.new
            when 4
                jugada = Lagarto.new
            when 5
                jugada = Spock.new
            else 
                jugada = Jugada.new
        end        
    end
end

class Copiar < Estrategia
    attr_accessor :primeraJugada

    def initialize(primeraJugada, jugador=nil)
        if !(primeraJugada.is_a? (Jugada))
            raise ArgumentError.new("La estrategia de Copia debe inicializar con una Jugada")
        end
        self.jugador = jugador
        self.primeraJugada = primeraJugada
    end
    
    def prox(historial)
        if (historial == [])
            print "Jugando la primera jugada #{self.primeraJugada} \n"
            jugada = self.primeraJugada
        else
            print(" Jugando la copia #{historial.last}\n")
            jugada = historial.last
        end
    end
end

class Uniforme < Estrategia
    attr_accessor :jugadas

    def initialize(jugadas, jugador=nil)
        self.jugadas = jugadas.uniq
        self.jugadas.each{ | elem | 
            if !(elem.is_a? (Jugada))
                raise ArgumentError.new("La estrategia Uniforme debe tener una lista unicamente con Jugadas")
            end
        }
        self.jugador = jugador
    end

    def prox(historial)
        posicion = Random.new(SEMILLA)
        posicion = posicion.rand(self.jugadas.size)
        jugada = self.jugadas[posicion]    
    end
end

class Pensar < Estrategia

    def prox(historial)
        numPiedras = historial.count{|x| x.is_a? Piedra}
        numPapel   = historial.count{|x| x.is_a? Papel}
        numTijeras = historial.count{|x| x.is_a? Tijeras}
        numLagarto = historial.count{|x| x.is_a? Lagarto}
        numSpock   = historial.count{|x| x.is_a? Spock}
        total = numPiedras + numPapel + numTijeras + numSpock + numLagarto

        posicion = Random.new(SEMILLA)
        posicion = posicion.rand(total-1)

        case posicion
            when 0...numPiedras
                jugada = Piedra.new
            when numPiedras...numPiedras+numPapel
                jugada = Papel.new
            when numPiedras+numPapel...numPiedras+numPapel+numTijeras
                jugada = Tijeras.new
            when numPiedras+numPapel+numTijeras...numPiedras+numPapel+numTijeras+numLagarto
                jugada = Lagarto.new
            when numPiedras+numPapel+numTijeras+numLagarto...total
                jugada = Spock.new
        end
    end
end

class Sesgada < Estrategia
end



