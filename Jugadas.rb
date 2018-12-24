class Jugada
    def to_s
        "#{self.class}"
    end

    def inspect
        self.to_s
    end

    def eql?(other)
        self.class.eql?(other.class)
    end

    def hash
        self.class.hash
    end

    def puntos j
        if !(j.is_a? Jugada and j.class != Jugada and self.is_a? Jugada and self.class != Jugada)
            raise ArgumentError.new("Solo se puede calcular los puntos a subclases de Jugada")
        end
        jugada_class = j.class
        if @debilidades.include? jugada_class
            [0, 1]
        elsif self.class == jugada_class
            [0, 0]
        else
            [1, 0]
        end
    end
end

class Piedra < Jugada

    def initialize
        @debilidades = [Papel, Spock]
    end
end

class Papel < Jugada

    def initialize
        @debilidades = [Tijeras, Lagarto]
    end
end

class Tijeras < Jugada
    def initialize
        @debilidades = [Piedra, Spock]
    end
end

class Lagarto < Jugada

    def initialize
        @debilidades = [Tijeras, Piedra]
    end
end


class Spock < Jugada
    def initialize
        @debilidades = [Papel, Lagarto]
    end
end
