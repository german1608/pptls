load 'Partida.rb'
load 'Tablero.rb'

##
# Intefaz de usuario, se manejan 3 segmentos tratados para simular vistas.
# La vista de configuracion, la vista de objetivos y la vista de juegos
Shoes.app(title: "Piedra, Papel, Tijera, Lagarto o Spock", width: 500, height: 600, resizable: false) do
    background('imagenes/espacio.jpeg')
    @tablero = Tablero.new()
    @turno = 1

    #INICIO VISTA DE CONFIGURACION
    # Se recaudan los datos del usuario y de sus estrategias, para luego
    # Dirigirse a la vista de objetivos
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
    # Vista donde se encuentra la puntuacion, ultima jugada y simbolos de la misma
    vistaJuego =
        stack do
            @Dir = Dir.pwd

            flow do
                @jugador1 = para "jugador1", margin_left:110, stroke:white
                @jugador2 = para "jugador2", margin_left:270, stroke:white
            end
            flow do
                style(:margin_left => '10%', :left => '10%')
                    @player1 = image 'imagenes/Spock.png' , height: 200, width:200
                    @player2 = image 'imagenes/Piedra.png' , height: 200, width:200
            end

            @resumen = para "Comenzando", align: 'center', stroke:white
            @puntuacion = para " [0-0] ", align: "center", stroke:white
            @numRonda = para "Ronda 0", align: 'center', stroke:white

            flow do
                style(:margin_left => '110')
                @piedra  = image 'imagenes/Piedra.png' , height: 100, width:100
                @piedra.click do
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 != "Manual")
                        cambiarImagen(@player1, "Piedra")
                        @tablero.partida.prox_jug2(Piedra.new)
                        actualizar
                    end
                    if(@tablero.estrategia2 == "Manual" and @tablero.estrategia1 != "Manual")
                        cambiarImagen(@player2, "Piedra")
                        @tablero.partida.prox_jug1(Piedra.new)
                        actualizar
                    end 
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 == "Manual")
                        if(@turno == 1)
                            cambiarImagen(@player1, "Piedra")
                            @turno = 2
                            @jugada_jug1 = Piedra.new
                        else
                            cambiarImagen(@player2, "Piedra")
                            print @jugada_jug1
                            @tablero.partida.prox_calculado(@jugada_jug1, Piedra.new)
                            @turno = 1
                            actualizar
                        end                            
                    end 
                end
                @papel   = image 'imagenes/Papel.png' , height: 100, width:100
                @papel.click do
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 != "Manual")
                        cambiarImagen(@player1, "Papel")
                        @tablero.partida.prox_jug2(Papel.new)
                        actualizar
                    end 
                    if(@tablero.estrategia2 == "Manual" and @tablero.estrategia1 != "Manual")
                        cambiarImagen(@player2, "Papel")
                        @tablero.partida.prox_jug1(Papel.new)
                        actualizar
                    end  
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 == "Manual")
                        if(@turno == 1)
                            cambiarImagen(@player1, "Papel")
                            @turno = 2
                            @jugada_jug1 = Papel.new
                        else
                            cambiarImagen(@player2, "Papel")
                            print @jugada_jug1
                            @tablero.partida.prox_calculado(@jugada_jug1, Papel.new)
                            @turno = 1
                            actualizar
                        end                            
                    end 
                end
                @tijera  = image 'imagenes/Tijeras.png' , height: 100, width:100
                @tijera.click do
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 != "Manual")
                        cambiarImagen(@player1, "Tijeras")
                        @tablero.partida.prox_jug2(Tijeras.new)
                        actualizar
                    end 
                    if(@tablero.estrategia2 == "Manual" and @tablero.estrategia1 != "Manual")
                        cambiarImagen(@player2, "Tijeras")
                        @tablero.partida.prox_jug1(Tijeras.new)
                        actualizar
                    end  
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 == "Manual")
                        if(@turno == 1)
                            cambiarImagen(@player1, "Tijeras")
                            @turno = 2
                            @jugada_jug1 = Tijeras.new
                        else
                            cambiarImagen(@player2, "Tijeras")
                            print @jugada_jug1
                            @tablero.partida.prox_calculado(@jugada_jug1, Tijeras.new)
                            @turno = 1
                            actualizar
                        end                            
                    end 
                end
            end
            flow do
                style(:margin_left => '160')
                @spock   = image 'imagenes/Spock.png' , height: 100, width:100
                @spock.click do
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 != "Manual")
                        cambiarImagen(@player1, "Spock")
                        @tablero.partida.prox_jug2(Spock.new)
                        actualizar
                    end 
                    if(@tablero.estrategia2 == "Manual" and @tablero.estrategia1 != "Manual")
                        cambiarImagen(@player2, "Spock")
                        @tablero.partida.prox_jug1(Spock.new)
                        actualizar
                    end 
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 == "Manual")
                        if(@turno == 1)
                            cambiarImagen(@player1, "Spock")
                            @turno = 2
                            @jugada_jug1 = Spock.new
                        else
                            cambiarImagen(@player2, "Spock")
                            print @jugada_jug1
                            @tablero.partida.prox_calculado(@jugada_jug1, Spock.new)
                            @turno = 1
                            actualizar
                        end                            
                    end 
                end
                @lagarto = image 'imagenes/Lagarto.png' , height: 100, width:100
                @lagarto.click do
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 != "Manual")
                        cambiarImagen(@player1, "Lagarto")
                        @tablero.partida.prox_jug2(Lagarto.new)
                        actualizar
                    end 
                    if(@tablero.estrategia2 == "Manual" and @tablero.estrategia1 != "Manual")
                        cambiarImagen(@player2, "Lagarto")
                        @tablero.partida.prox_jug1(Lagarto.new)
                        actualizar
                    end 
                    if(@tablero.estrategia1 == "Manual" and @tablero.estrategia2 == "Manual")
                        if(@turno == 1)
                            cambiarImagen(@player1, "Lagarto")
                            @turno = 2
                            @jugada_jug1 = Lagarto.new
                        else
                            cambiarImagen(@player2, "Lagarto")
                            print @jugada_jug1
                            @tablero.partida.prox_calculado(@jugada_jug1, Lagarto.new)
                            @turno = 1
                            actualizar
                        end                            
                    end 
                end
            end
            stack do
                flow do
                    style(:margin_left => '43%')
                    button "Proximo" do
                        @tablero.partida.prox
                        actualizar
                    end
                end
                flow do
                    style(:margin_left => '42%')
                    button "Reiniciar" do
                        @tablero.partida.reiniciar
                        actualizar
                    end
                end
            end
            stack do
                # Segmento para jugar alcanzando x cantidad de puntos leidas por un edit_line
                para "Jugar hasta cierta puntuacion", align: 'center', stroke:white
                @lineaAlcanzar  = edit_line(:margin_left => '30%')
                stack do
                    style(:margin_left => '32%',)
                    @alcanzarButton = button "Alcanzar Puntuacion" do
                        if(@tablero.estrategia1 != "Manual"  or @tablero.estrategia2 != "Manual")
                            @tablero.partida.alcanzar(@lineaAlcanzar.text().to_i)
                        end
                        actualizar
                        vistaObjetivo.hide()
                        vistaJuego.show()
                        vistaConfiguracion.hide()
                        ##@botonJugar.hide()
                        @botonSiguiente.hide()
                    end
                end
    
                # Segmento para jugar alcanzando x cantidad de rondas leidas por un edit_line
                para "Jugar cierta cantidad de rondas" , align: 'center',  stroke:white
                @lineaRondar    = edit_line(:margin_left => '30%')
                stack do
                    style(:margin_left => '37%',)
                    @rondasButton = button "Jugar Rondas" do
                        if(@tablero.estrategia1 != "Manual"  or @tablero.estrategia2 != "Manual")
                            @tablero.partida.rondas(@lineaRondar.text().to_i)
                        end
                        actualizar
                        vistaObjetivo.hide()
                        vistaJuego.show()
                        vistaConfiguracion.hide()
                        #@botonJugar.hide()
                        @botonSiguiente.hide()
                    end
                end
            end
        end
    #FIN VISTA DE JUEGO

    #INICIO VISTA DE OBJETIVO
    # vista donde se indica como se quiere jugar, y la configuracion inicial de cada estrategia
    # en caso de ser necesario
        vistaObjetivo =
        stack do
            # Segmento para jugar alcanzando x cantidad de puntos leidas por un edit_line
            para "Jugar hasta cierta puntuacion", align: 'center', stroke:white
            @lineaAlcanzar  = edit_line(:margin_left => '30%')
            stack do
                style(:margin_left => '32%',)
                @alcanzarButton = button "Alcanzar Puntuacion" do
                    poblar
                    if(@tablero.estrategia1 != "Manual" or @tablero.estrategia2 != "Manual")
                        @tablero.partida.alcanzar(@lineaAlcanzar.text().to_i)
                    end
                    actualizar
                    vistaObjetivo.hide()
                    vistaJuego.show()
                    vistaConfiguracion.hide()
                    ##@botonJugar.hide()
                    @botonSiguiente.hide()
                end
            end

            # Segmento para jugar alcanzando x cantidad de rondas leidas por un edit_line
            para "Jugar cierta cantidad de rondas" , align: 'center',  stroke:white
            @lineaRondar    = edit_line(:margin_left => '30%')
            stack do
                style(:margin_left => '37%',)
                @rondasButton = button "Jugar Rondas" do
                    poblar  
                    if(@tablero.estrategia1 != "Manual" or @tablero.estrategia2 != "Manual")
                        @tablero.partida.rondas(@lineaRondar.text().to_i)
                    end
                    actualizar
                    vistaObjetivo.hide()
                    vistaJuego.show()
                    vistaConfiguracion.hide()
                    #@botonJugar.hide()
                    @botonSiguiente.hide()
                end
            end
        end
    #FIN DE VISTA DE OBJETIVO

    #Botones
    vistaJuego.hide()
    vistaObjetivo.hide()
    

    flow do
        style( :margin_left => '40%')
        botonSiguiente = button "Siguiente" do
            vistaConfiguracion.hide()
            botonSiguiente.hide()

            #Informacion jugador1
            if @estrategia1.text == "Copiar"
                stack do
                    style( :margin_left => '30%')
                    @paraCopiar1 = para "Jugada inicial de la estrategia del primer jugador", margin_left: '-15%', stroke:white
                    @lineaCopiar1  = list_box items: ["Piedra", "Papel", "Tijeras", "Spock", "Lagarto"],
                    choose: "Piedra" do |list|
                        case list.text
                        when "Piedra"
                            @copiar1 = Piedra.new
                            @tablero.copiar1 = @copiar1
                        when "Papel"
                            @copiar1 = Papel.new
                            @tablero.copiar1 = @copiar1
                        when "Tijeras"
                            @copiar1 = Tijeras.new
                            @tablero.copiar1 = @copiar1
                        when "Spock"
                            @copiar1 = Spock.new
                            @tablero.copiar1 = @copiar1
                        when "Lagarto"
                            @copiar1 = Lagarto.new
                            @tablero.copiar1 = @copiar1
                        end

                    end
                end
            elsif @estrategia1.text == "Uniforme"
                stack do
                    @paraUniforme1 = para "Lista de jugadas de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaUniforme1  = edit_line(:margin_left => '30%')
                    @lineaUniforme1.text = "Ex: Piedra, Papel, Tijera"
                end
            elsif @estrategia1.text == "Sesgada"
                stack do
                    @paraSesgada1 = para "Lista de jugadas de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaSesgada1  = edit_box(:margin_left => '30%')
                    @lineaSesgada1.text = "Ex: (Piedra,5); (Papel,3); (Tijera,2)"
                end
            end

            #Informacion jugador2
            if @estrategia2.text == "Copiar"
                stack do
                    style( :margin_left => '30%')
                    @paraCopiar2 = para "Jugada inicial de la estrategia del segundo jugador", margin_left: '-15%', stroke:white
                    @lineaCopiar2  = list_box items: ["Piedra", "Papel", "Tijeras", "Spock", "Lagarto"],
                    choose: "Piedra" do |list|
                        case list.text
                        when "Piedra"
                            @copiar2 = Piedra.new
                            @tablero.copiar2 = @copiar2
                        when "Papel"
                            @copiar2 = Papel.new
                            @tablero.copiar2 = @copiar2
                        when "Tijeras"
                            @copiar2 = Tijeras.new
                            @tablero.copiar2 = @copiar2
                        when "Spock"
                            @copiar2 = Spock.new
                            @tablero.copiar2 = @copiar2
                        when "Lagarto"
                            @copiar2 = Lagarto.new
                            @tablero.copiar2 = @copiar2
                        end

                    end
                end
            elsif @estrategia2.text == "Uniforme"
                stack do
                    @paraUniforme2 = para "Lista de jugadas de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaUniforme2  = edit_line(:margin_left => '30%')
                    @lineaUniforme2.text = "Ex: Piedra, Papel, Tijera"
                end
            elsif @estrategia2.text == "Sesgada"
                stack do
                    @paraSesgada2 = para "Lista de jugadas de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaSesgada2  = edit_box(:margin_left => '30%')
                    @lineaSesgada2.text = "Ex: (Piedra,5),(Papel,3), (Tijera,2)"
                end
            end

            vistaObjetivo.show()
        end
    end

    '''    
    #@botonJugar = 
        stack do
            button "Listo para jugar" do
            poblar
            actualizar
            vistaObjetivo.hide()
            vistaJuego.show()
            vistaConfiguracion.hide()
            #@botonJugar.hide()
            @botonSiguiente.hide()
        end
    end
    '''

    ##
    # Funcion que toma todos los datos ingresados por el usuario y los
    # vacia en el @tablero, para luego crear la partida
    def poblar
        @tablero.jugador1 = @lineaJugador1.text()
        @tablero.jugador2 = "a"

        @jugador1.replace(@lineaJugador1.text())
        @jugador2.replace(@lineaJugador2.text())

        @tablero.estrategia1 = @estrategia1.text
        @tablero.estrategia2 = @estrategia2.text
        if(@lineaCopiar1)
            @paraCopiar1.hide()
            @lineaCopiar1.hide()
        end
        if(@lineaUniforme1)
            @tablero.lineaUniforme1 = @lineaUniforme1.text()
            @paraUniforme1.hide()
            @lineaUniforme1.hide()
        end
        if(@lineaSesgada1)
            @tablero.lineaSesgada1 = @lineaSesgada1.text()
            @paraSesgada1.hide()
            @lineaSesgada1.hide()
        end
        if(@lineaCopiar2)
            @paraCopiar2.hide()
            @lineaCopiar2.hide()
        end
        if(@lineaUniforme2)
            @tablero.lineaUniforme2 = @lineaUniforme2.text()
            @paraUniforme2.hide()
            @lineaUniforme2.hide()
        end
        if(@lineaSesgada2)
            @tablero.lineaSesgada2 = @lineaSesgada2.text()
            @paraSesgada2.hide()
            @lineaSesgada2.hide()
        end
        puts @tablero
        @tablero.crearPartida
        puts @tablero.partida
    end

    ##
    # Cambia la imagen de la ultima jugada para ambos jugadores, al igual
    # que actualiza el numero de ronda y la puntuacion en la interfaz
    def actualizar
        if(@numRonda != 0)
            @player1.path = "#{@Dir}/imagenes/#{@tablero.partida.jugada_previa_j1}.png"
            @player2.path = "#{@Dir}/imagenes/#{@tablero.partida.jugada_previa_j2}.png"
        end
        @puntuacion.replace("#{@tablero.partida.puntos[0]} - #{@tablero.partida.puntos[1]}")
        @numRonda.replace("Ronda #{@tablero.partida.acumulado}")
    end

    ##
    # Dado un shoes::image en la variable jugador, cambia su imagen a la de la jugada pasada por parametro
    def cambiarImagen(jugador,jugada)
        jugador.path = "#{@Dir}/imagenes/#{jugada}.png"
    end

end

