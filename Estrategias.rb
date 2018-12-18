load 'Jugadas.rb'   

class Estrategia
    attr_accessor :jugador

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