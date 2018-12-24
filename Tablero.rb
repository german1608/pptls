load 'Partida.rb'

class Tablero
    attr_accessor :jugador1, :estrategia1, :copiar1, :lineaUniforme1,:lineaSesgada1,
                  :jugador2, :estrategia2, :copiar2, :lineaUniforme2,:lineaSesgada2,
                  :partida

    ##
    # Dado un texto estrategia, crea la estrategia correspondiente inicializandolo
    # con sus argumentos necesarios
    def crearEstrategia(jugador, estrategia, copiar = nil, lineaUniforme=nil,lineaSesgada=nil)
        puts estrategia
        case estrategia
            when "Manual"
                Manual.new(jugador)
            when "Copiar"
                Copiar.new(copiar, jugador)
            when "Uniforme"
                Uniforme.new(ParseUniforme(lineaUniforme), jugador)
            when "Sesgada"
                puts " creando sesgada con #{ParseSesgado(lineaSesgada)}\n"
                Sesgada.new(ParseSesgado(lineaSesgada), jugador)
            when "Pensar"
                Pensar.new(jugador)
        end
    end

    ##
    # Crea una partida que estara asociado al tablero, permitiendo mantener un estado unico
    def crearPartida
        e1 = crearEstrategia(self.jugador1, self.estrategia1, self.copiar1, self.lineaUniforme1,self.lineaSesgada1)
        e2 = crearEstrategia(self.jugador2, self.estrategia2, self.copiar2, self.lineaUniforme2,self.lineaSesgada2)
        partida = Partida.new({
            self.jugador1 => e1,
            self.jugador2 => e2
        })
        self.partida = partida
    end

    def menuJuego
        opcion = ""
        opciones_posibles = [1,2,3,4,5]
        while !(opciones_posibles.include? opcion) do
            puts ( "Indique un valor
                    1- Proximo
                    2- Rondas
                    3- Alcanzar
                    4- Reiniciar
                    5- Salir")
            opcion = gets.to_i
        end

        case opcion
        when 1
            self.partida.prox
        when 2 
            puts "Ingrese el numero de rondas"
            self.partida.rondas(gets.to_i)
        when 3
            puts "Ingrese el numero de puntos"
            self.partida.alcanzar(gets.to_i)
        when 4 
            puts "Reiniciando ...."
            self.partida.reiniciar
        when 5
            puts "Gracias por Jugar"
            exit

        end
        self.menuJuego
    end

    def jugar
        puts "Bienvenido a Piedra, Papel, Tijeras, Lagarto o Spock"
        #Menu jugador 1
        puts "Ingresa el nombre del primer jugador"
        self.jugador1 = gets.to_s
        opcion = ""
        opciones_posibles = [1,2,3,4,5]
        while !(opciones_posibles.include? opcion) do
            puts ( "Indique un valor para su estrategia
                    1- Manual
                    2- Copiar
                    3- Sesgada
                    4- Pensar
                    5- Uniforme")
            opcion = gets.to_i
        end

        case opcion
        when 1
            self.estrategia1 = "Manual"
        when 2
            self.estrategia1 = "Copiar"
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
                puts opciones_posibles.include? opcion
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
            self.copiar1 = inputs_para_manual[opcion].new

        when 3
            self.estrategia1 = "Sesgada"
            puts "Indique de la forma (Jugada,Probabilidad) los pares de sus jugadas, separado por ' ; '."
            puts "Ex. (Tijeras,5); (Papel,2)"
            self.lineaSesgada1 = gets.to_s
        
        when 4
            self.estrategia1 = "Pensar"
        
        when 5
            self.estrategia1 = "Uniforme"
            puts "Indique sus jugadas separadas por coma"
            puts "Ex. Tijeras, Piedra, Spock"
            self.lineaUniforme1 = gets.to_s

        end

        #Menu jugador 2
        puts "Ingresa el nombre del Segundo jugador"
        self.jugador2 = gets.to_s
        opcion = ""
        opciones_posibles = [1,2,3,4,5]
        while !(opciones_posibles.include? opcion) do
            puts ( "Indique un valor para su estrategia
                    1- Manual
                    2- Copiar
                    3- Sesgada
                    4- Pensar
                    5- Uniforme")
            opcion = gets.to_i
        end

        case opcion
        when 1
            self.estrategia2 = "Manual"
        when 2
            self.estrategia2 = "Copiar"
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
                puts opciones_posibles.include? opcion
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
            self.copiar2 = inputs_para_manual[opcion].new

        when 3
            self.estrategia2 = "Sesgada"
            puts "Indique de la forma (Jugada,Probabilidad) los pares de sus jugadas, separado por ' ; '."
            puts "Ex. (Tijeras,5); (Papel,2)"
            self.lineaSesgada2 = gets.to_s
        
        when 4
            self.estrategia2 = "Pensar"
        
        when 5
            self.estrategia2 = "Uniforme"
            puts "Indique sus jugadas separadas por coma"
            puts "Ex. Tijeras, Piedra, Spock"
            self.lineaUniforme2 = gets.to_s

        end

        self.crearPartida
        self.menuJuego
    end  

    
end