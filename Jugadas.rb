class Jugada
    def to_s
        self.class
    end

    def inspect
        self.to_s
    end

    def puntos(j)
    end

    def chequearJugada(j)
        if !(j.is_a? Jugada)
            raise ArgumentError.new("Solo se puede calcular los puntos a una Jugada")
        end
    end

    def eql?(other)
    self.class.eql?(other.class)
    end

    def hash
        self.class.hash
    end

end

class Piedra < Jugada

    def puntos(j)
        chequearJugada(j)
        case j
            when Tijeras, Lagarto
                return [1,0]
            when Piedra
                return [0,0]
            else
                return [0,1]
        end
    end
end

class Papel < Jugada

    def puntos(j)
        chequearJugada(j)
        case j
            when Piedra, Spock
                return [1,0]
            when Papel
                return [0,0]
            else
                return [0,1]
        end
    end
end

class Tijeras < Jugada
    
    def puntos(j)
        chequearJugada(j)
        case j
            when Papel, Lagarto
                return [1,0]
            when Tijeras
                return [0,0]
            else
                return [0,1]
        end
    end
end

class Lagarto < Jugada
    
    def puntos(j)
        chequearJugada(j)
        case j
            when Papel, Spock
                return [1,0]
            when Lagarto
                return [0,0]
            else
                return [0,1]
        end
    end
end

class Spock < Jugada
    
    def puntos(j)
        chequearJugada(j)
        case j
            when Tijeras, Piedra
                return [1,0]
            when Spock
                return [0,0]
            else
                return [0,1]
        end
    end
end

