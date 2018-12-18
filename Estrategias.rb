load 'Jugadas.rb'  

class Estrategia
    attr_accessor :jugador
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
end

class Sesgada < Estrategia
end



class Pensar < Estrategia
end