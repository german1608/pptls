load 'Partida.rb'

class Tablero
    attr_accessor :jugador1, :estrategia1, :copiar1, :lineaUniforme1,:lineaSesgada1,
                  :jugador2, :estrategia2, :copiar2, :lineaUniforme2,:lineaSesgada2,
                  :partida

    def crearEstrategia(jugador, estrategia, copiar, lineaUniforme,lineaSesgada)
        case estrategia
            when "Manual" 
                Manual.new(jugador)
            when "Copiar"
                Copiar.new(copiar, jugador)
            when "Uniforme"
                Uniforme.new(ParseUniforme(lineaUniforme), jugador)
            when "Sesgada"
                Sesgada.new(ParseSesgado(lineaSesgada), jugador)
            when "Pensar"
                Pensar.new(jugador)
        end
    end

    def crearPartida
        e1 = crearEstrategia(self.jugador1, self.estrategia1, self.copiar1, self.lineaUniforme1,self.lineaSesgada1)
        e2 = crearEstrategia(self.jugador2, self.estrategia2, self.copiar2, self.lineaUniforme2,self.lineaSesgada2)
        self.partida = Partida.new({
            self.jugador1 => e1,
            self.jugador2 => e2
        })

    end
end


Shoes.app(title: "Piedra, Papel, Tijera, Lagarto o Spock", width: 500, height: 700, resizable: false) do
    background('imagenes/espacio.jpeg')
    @tablero = Tablero.new()

    #INICIO VISTA DE CONFIGURACION
    vistaConfiguracion=
        stack do
            para "Bienvenido" , align: 'center', size:"large", stroke:white

            para "Nombre del primer jugador", align: 'center', stroke:white
            @lineaJugador1  = edit_line(:margin_left => '30%')
            para "Estrategia del primer jugador", align: 'center', stroke:white 
            stack do
                style(:margin_left => '30%',)       
                @estrategia1 = list_box items: ["Manual", "Copiar", "Uniforme", "Sesgada", "Pensar"],
                            choose: "Manual"      
            end


            para "Nombre del segundo jugador", align: 'center', stroke:white
            @lineaJugador2  = edit_line(:margin_left => '30%')
            para "Estrategia del segundo jugador", align: 'center', stroke:white 
            stack do
                style(:margin_left => '30%',)
                @estrategia2 = list_box items: ["Manual", "Copiar", "Uniforme", "Sesgada", "Pensar"],
                    choose: "Manual"
            end

            
        end
    #FIN VISTA DE CONFIGURACION
    

    #INICIO VISTA DE JUEGO
    vistaJuego = 
        stack do
            @Dir = Dir.pwd

            flow do
                @jugador1 = para "jugador1", margin_left:110, stroke:white
                @jugador2 = para "jugador2", margin_left:270, stroke:white
            end
            flow do
                style(:margin_left => '10%', :left => '10%')
                    @player1 = image 'imagenes/rock.png' , height: 200, width:200
                    @player2 = image 'imagenes/rock.png' , height: 200, width:200
            end

            @resumen = para "Comenzando", align: 'center', stroke:white
            @puntuacion = para " [0-0] ", align: "center", stroke:white

            flow do
                style(:margin_left => '110')
                @piedra  = image 'imagenes/rock.png' , height: 100, width:100
                @piedra.click do
                    @player1.path = "#{@Dir}/imagenes/rock.png"
                end
                @papel   = image 'imagenes/paper.png' , height: 100, width:100
                @papel.click do
                    @player1.path = "#{@Dir}/imagenes/paper.png"
                end
                @tijera  = image 'imagenes/scissors.png' , height: 100, width:100
                @tijera.click do
                    @player1.path = "#{@Dir}/imagenes/scissors.png"
                end
            end
            flow do
                style(:margin_left => '160')
                @spock   = image 'imagenes/spock.png' , height: 100, width:100
                @spock.click do
                    @player1.path = "/home/gabriel/Documents/pptls/pptls/imagenes/spock.png"
                end
                @lagarto = image 'imagenes/lizard.png' , height: 100, width:100
                @lagarto.click do
                    @player1.path = "#{@Dir}/imagenes/lizard.png"
                end
            end
        end
    #FIN VISTA DE JUEGO

    #INICIO VISTA DE OBJETIVO
        vistaObjetivo =
        stack do
            para "Jugar hasta cierta puntuacion", align: 'center', stroke:white
            @lineaAlcanzar  = edit_line(:margin_left => '30%')
            stack do
                style(:margin_left => '32%',)
                @alcanzarButton = button "Alcanzar Puntuacion" do
                    @tablero.crearPartida
                    @tablero.partida.alcanzar(@lineaAlcanzar.text().to_i)
                end
            end
            
            para "Jugar cierta cantidad de rondas" , align: 'center',  stroke:white
            @lineaRondar    = edit_line(:margin_left => '30%')
            stack do
                style(:margin_left => '37%',)
                @rondasButton = button "Jugar Rondas"
            end
        end
    #FIN DE VISTA DE OBJETIVO

    #Botones
    vistaJuego.hide()
    vistaObjetivo.hide()

    flow do
        style( :margin_left => '25%')
        botonSiguiente = button "Siguiente" do
            vistaConfiguracion.hide()
            botonSiguiente.hide()
            omitir1 = false
            omitir2 = false
            if @estrategia1.text == "Copiar"
                stack do
                    style( :margin_left => '30%')
                    para "Jugada inicial de la estrategia del primer jugador", margin_left: '-15%', stroke:white
                    @lineaCopiar1  = list_box items: ["Piedra", "Papel", "Tijera", "Spock", "Lagarto"],
                    choose: "Piedra" do |list|
                        case list.text
                        when "Piedra" 
                            @copiar1 = Piedra.new
                        when "Papel"
                            @copiar1 = Papel.new
                        when "Tijera"
                            @copiar1 = Tijera.new
                        when "Spock"
                            @copiar1 = Spock.new
                        when "Lagarto"
                            @copiar1 = Lagarto.new
                        end
                        @tablero.copiar1 = @copiar1
                    end
                end
            elsif @estrategia1.text == "Uniforme"
                stack do
                    para "Lista de jugadas de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaUniforme1  = edit_line(:margin_left => '30%')
                    @lineaUniforme1.text = "Ex: Piedra, Papel, Tijera"
                end
            elsif @estrategia1.text == "Sesgada"
                stack do
                    para "Lista de jugadas de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaSesgada1  = edit_box(:margin_left => '30%')
                    @lineaSesgada1.text = "Ex: (Piedra,5),(Papel,3), (Tijera,2)"
                end
            end
    
            if @estrategia2.text == "Copiar"
                stack do
                    style( :margin_left => '30%')
                    para "Jugada inicial de la estrategia del segundo jugador", margin_left: '-15%', stroke:white
                    @lineaCopiar1  = list_box items: ["Piedra", "Papel", "Tijera", "Spock", "Lagarto"],
                    choose: "Piedra" do |list|
                        case list.text
                        when "Piedra" 
                            @copiar2 = Piedra.new
                        when "Papel"
                            @copiar2 = Papel.new
                        when "Tijera"
                            @copiar2 = Tijera.new
                        when "Spock"
                            @copiar2 = Spock.new
                        when "Lagarto"
                            @copiar2 = Lagarto.new
                        end
                        @tablero.copiar2 = @copiar2
                    end
                end
            elsif @estrategia2.text == "Uniforme"
                stack do
                    para "Lista de jugadas de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaUniforme2  = edit_line(:margin_left => '30%')
                    @lineaUniforme2.text = "Ex: Piedra, Papel, Tijera"
                end
            elsif @estrategia1.text == "Sesgada"
                stack do
                    para "Lista de jugadas de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaSesgada2  = edit_box(:margin_left => '30%')
                    @lineaSesgada2.text = "Ex: (Piedra,5),(Papel,3), (Tijera,2)"
                end
            end

            vistaObjetivo.show()
        end   
    end

        
    @botonJugar = button "Listo para jugar" do
        @tablero.jugador1 = @lineaJugador1.text()
        @tablero.jugador2 = "a"

        @jugador1.replace(@lineaJugador1.text())
        @jugador2.replace(@lineaJugador2.text())

        @tablero.estrategia1 = @estrategia1.text
        @tablero.estrategia2 = @estrategia2.text
        if(@lineaUniforme1)
            @tablero.lineaUniforme1 = @lineaUniforme1.text()
        end
        if(@lineaSesgada1)
            @tablero.lineaSesgada1 = @lineaSesgada1.text()
        end
        if(@lineaUniforme2)
            @tablero.lineaUniforme2 = @lineaUniforme2.text()
        end
        if(@lineaSesgada2)
            @tablero.lineaSesgada2 = @lineaSesgada2.text()
        end
        puts @tablero
        @tablero.crearPartida
        puts @tablero
        vistaObjetivo.hide()
        vistaJuego.show()
        vistaConfiguracion.hide()
        @botonJugar.hide()
        @botonSiguiente.hide()
    end
    
end

