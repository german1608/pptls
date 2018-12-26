load 'Jugadas.rb'

##
# Cada jugador es representado con una estrategia
# Esta clase provee una interfaz sencilla para poder
# implementar estrategias personalizadas por el usuario
# final
#
# +SEMILLA+ :: Semilla para números aleatorios
class Estrategia
    ##
    # jugador :: Nombre del jugador de la estrategia
    attr_accessor :jugador

    ##
    # SEMILLA :: Semilla para generar los números pseudo-aleatorios.
    SEMILLA = 42

    ##
    # Determina la jugada del turno actual. Puede utilizar
    # el historial de jugadas y el parámetro actual.
    #
    # Parámetros:
    # - +jugada_pasada+:: +Jugada+ realizada por el adversario en la ronda anterior
    def prox(jugada_pasada=nil)
        if !(jugada_pasada == nil or
            (jugada_pasada.is_a? Jugada and jugada_pasada.class != Jugada))
            raise ArgumentError.new('La jugada pasada no es nil ni una subclase de Jugada')
        end
    end

    ##
    # Nombre del jugador de la estrategia
    def initialize(jugador=nil)
        @jugador = jugador
    end

    ##
    # Retorna la estrategia como un +String+.
    def to_s
        "Jugador: #{@jugador} - Estrategia: #{self.class} "
    end

    ##
    # Reinicia el estado de la estrategia.
    def reset
    end

    ##
    # Retorna un string que representa la instancia de estrategia
    def inspect
        self.to_s
    end
end

##
# La estrategia manual requiere de un usuario real que escoga
# que desea jugar. Es de las estrategias más simples requeridas.
class Manual < Estrategia

    ##
    # El prox de esta estrategia es sencillamente jugar lo que
    # el usuario decida. Pedimos input por STDIN (aunque en
    # la interfaz resolvemos esto usando un input mocker).
    #
    # Parámetros
    # - +jugada_pasada+: No se usa, pero se deja para que se sobreescriba
    # el método de la superclase
    def prox(jugada_pasada)
        super jugada_pasada

        # Pedimos input hasta que sea una opción posible
        opcion = ""
        opciones_posibles = [1,2,3,4,5]
        while !(opciones_posibles.include? opcion) do
            puts ( "Indique un valor para su jugada
                    1- Piedra
                    2- Papel
                    3- Tijeras
                    4- Lagarto
                    5- Spock")
            opcion = gets.to_i
        end

        # Este hash lookup nos permite evitar el uso
        # engorroso de if's.
        inputs_para_manual = {
            1 => Piedra,
            2 => Papel,
            3 => Tijeras,
            4 => Lagarto,
            5 => Spock
        }
        inputs_para_manual[opcion].new
    end
end

##
# La estrategia Copiar consiste en copiar la jugada
# realizada por el adversario en el turno pasado.
class Copiar < Estrategia
    ##
    # El constructor de Copiar recibe como parámetro
    # la jugada a realizar en el primer turno.
    #
    # Parámetros:
    # - +primeraJugada+: Jugada a realizar en el primer turno.
    # - +jugador+: (opcional) Nombre del jugador.
    def initialize(primeraJugada, jugador=nil)
        if !(primeraJugada.is_a? Jugada and primeraJugada.class != Jugada)
            raise ArgumentError.new("La estrategia de Copia debe inicializar con una subclase de Jugada")
        end
        self.jugador = jugador
        @primeraJugada = primeraJugada
    end

    ##
    # El método prox de esta estrategia revisa si la primeraJugada ya se realizó.
    # Al realizarla se iguala esta a nil para que no vuelva a ser usada (usaría
    # siempre el argumento (la jugada del adversario en la ronda pasado).
    #
    # Parámetros
    # - +jugada_pasada+: +Jugada+ realizada por el adversario en el turno anterior.
    def prox(jugada_pasada=nil)
        super jugada_pasada
        if @primeraJugada == nil
            jugada_pasada
        else
            j = @primeraJugada
            @primeraJugada = nil
            j
        end
    end

end

##
# Estrategia que recibe una lista de Símbolos a Jugadas y retorna
# una instancia de cualquiera de estas escogiendo uniformemente
# un número entero entre 0 y la longitud del parámetro (inclusive, exclusive)
class Uniforme < Estrategia

    ##
    # jugada :: contiene la lista de jugadas sobre las que puede trabajar
    # la estrategia
    attr_accessor :jugadas
    ##
    # El constructor fue descrito en la documentación de la clase.
    # Se hacen los siguientes chequeos:
    # - El argumento solo debe ser un arreglo cuyos elementos sean
    #   - +:Tijeras+
    #   - +:Papel+
    #   - +:Piedra+
    #   - +:Spock+ ó
    #   - +:Lagarto+
    # - El argumento debe tener al menos un elemento.
    #
    # Parámetros:
    # - +jugadas+: Arreglo con las características descritas anteriormente.
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

    ##
    # Retorna la siguiente jugada a realizar de manera uniforme
    # calculando un número pseudo-aleatorio perteneciente a [0, @jugadas.size)
    #
    # Parámetros
    # - +jugada_pasada+: No se usa, pero se deja para poder facilitar el uso
    # de la misma.
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

##
# La estrategia pensar es un poco más complicada de explicar.
# Usa el historial de jugadas (conservado como un atributo de instancia).
# Dicho atributo solo puede ser modificado internamente por los métodos
# de la misma.
class Pensar < Estrategia
    ##
    # Inicializamos la estrategia asignando un historial vacío
    def initialize (jugador=nil)
        @jugador = jugador
        @historial = []
    end

    ##
    # La próxima jugada a realizar usando esta estrategia se describe de
    # la siguiente manera:
    # 1. Sea +numPiedras, +numPapel, +numTijeras, +numLagarto y +numSpock+
    #    la cantidad de piedras, papel, tijeras, lagartos y spocks que ha jugado
    #    el oponente en la partida.
    # 2. Calculamos las sumas de las variables calculadas anteriormente.
    # 3. Se calcula un número aleatorio entero entre 0 y el total calculado
    #    en el paso 2.
    # 4. La jugada será uns instancia de:
    #    - +Piedra+, si el resultado cae en el rango <tt>[0, numPiedras)</tt>
    #    - +Papel+, si el resultado cae en el rango <tt>[numPiedras, numPiedras + numPapel)</tt>
    #    - +Tijeras+, si el resultado cae en el rango <tt>[numPiedras + numPapel,
    #      numPiedras + numPapel + numTijeras)</tt>
    #    - +Lagarto+, si el resultado cae en el rango <tt>[numPiedras + numPapel + numTijeras,
    #      numPiedras + numPapel + numTijeras + numLagarto)</tt>
    #    - +Spock+, si el resultado cae en el rango <tt>[numPiedras + numPapel + numTijeras +
    #      numLagarto, numPiedras + numPapel + numTijeras + numLagarto + numSpock)</tt>
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

    ##
    # Resetear la estrategia es equivalente a vaciar el historial
    def reset
        @historial = []
    end
end

##
# La clase Sesgada es muy similar a Pensar. Esta usa un mapa
# de frecuencia para cada jugada y de esta manera determinar
# la jugada a realizar dependiendo del valor de su frecuencia
# asociada
class Sesgada < Estrategia
    ##
    # El constructor verifica que las claves del hash sean los posibles
    # valores (mismos de +Uniforme+). y que los valores de estos
    # sean de tipo numérico.
    def initialize (probs_sesgadas, jugador = nil)
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

    ##
    # La próxima jugada es sencillamente buscar un elemento de forma uniforme
    # del arreglo +@jugadas_posibles+
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
