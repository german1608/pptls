
##
# Superclase de todas las posibles jugadas del proyecto. Como tal no se debería
# instanciar. Para facilitar la implementación de los métodos se usa una atributo
# de instancia llamado +debilidades+, que es arreglo que contiene las clases
# que vencen a la jugada creada.
class Jugada

    ##
    # Representa al objeto como un string. La representación es el nombre
    # de la subclase (la jugada en si).
    def to_s
        "#{self.class}"
    end

    def inspect
        self.to_s
    end

    ##
    # Dos jugadas son iguales si las clases que se usaron para instanciarlas
    # son las mismas.
    def eql?(other)
        self.class.eql?(other.class)
    end

    def hash
        self.class.hash
    end

    ##
    # Retorna la cantidad de puntos que resulta de realizar la jugada `self`
    # contra la jugada +j+.
    #
    # === Parámetros
    # - +j+ jugada realizada por el oponente. Debe ser instancia de una subclase de Jugada
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

##
# Subclase de +Jugada+. Su representación es un puño cerrado.
class Piedra < Jugada
    ##
    # Una +Piedra+ tiene como +debilidades+ el +Papel+ y a +Spock+
    def initialize
        @debilidades = [Papel, Spock]
    end
end

##
# Subclase de +Jugada+. Su representación es la palma de la mano.
class Papel < Jugada
    ##
    # Un +Papel+ tiene como +debilidades+ el +Lagarto+ y las +Tijeras+
    def initialize
        @debilidades = [Tijeras, Lagarto]
    end
end

##
# Subclase de +Jugada+. Su representación es un puño cerrado con los dedos
# índice y medio extendidos (símbolo de la paz).
class Tijeras < Jugada
    ##
    # Unas +Tijeras+ tienen como +debilidades+ las +Piedra+s y a +Spock+
    def initialize
        @debilidades = [Piedra, Spock]
    end
end

##
# Subclase de +Jugada+. Su representación es un puño cerrado jungando
# las puntas de los dedos.
class Lagarto < Jugada
    ##
    # Un +Lagarto+ tiene como +debilidades+ las +Tijeras+ y la +Piedra+
    def initialize
        @debilidades = [Tijeras, Piedra]
    end
end

##
# Subclase de +Jugada+. Su representación es la mano con los dedos
# extendidos y el dedo medio y anular separados.
class Spock < Jugada
    ##
    # Un +Spock+ tiene como +debilidades+ el +Papel+ y el +Lagarto+
    def initialize
        @debilidades = [Papel, Lagarto]
    end
end
