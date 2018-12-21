load 'Partida.rb'

Shoes.app(title: "Piedra, Papel, Tijera, Lagarto o Spock", width: 500, height: 700, resizable: false) do
    background('imagenes/espacio.jpeg')

    def esconder
        inicialCopiar.hide()
        inicialSesgada.hide()
        inicialUniforme.hide()
    end

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
                            choose: "Manual" do |list|
                                case list.text
                                when "Manual" 
                                    @lineaJugador1.text = "Manual"
                                when "Copiar"
                                    @lineaJugador1.text = "Copiar"
                                when "Uniforme"
                                    @lineaJugador1.text = "Uniforme"
                                when "Sesgada"
                                    @lineaJugador1.text = "Sesgada"
                                when "Pensar"
                                    @lineaJugador1.text = "Pensar"
                                end

                            end        
            end


            para "Nombre del segundo jugador", align: 'center', stroke:white
            @lineaJugador2  = edit_line(:margin_left => '30%')
            para "Estrategia del segundo jugador", align: 'center', stroke:white 
            stack do
                style(:margin_left => '30%',)
                @estrategia2 = list_box items: ["Manual", "Copiar", "Uniforme", "Sesgada", "Pensar"],
                    choose: "Manual" do |list|
                        case list.text
                        when "Manual" 
                            @lineaJugador2.text = "Manual"
                        when "Copiar"
                            @lineaJugador2.text = "Copiar"
                        when "Uniforme"
                            @lineaJugador2.text = "Uniforme"
                        when "Sesgada"
                            @lineaJugador2.text = "Sesgada"
                        when "Pensar"
                            @lineaJugador2.text = "Pensar"
                        end

                    end
            end

            
        end
    #FIN VISTA DE CONFIGURACION

    #INICIO VISTA DE OBJETIVO
    vistaObjetivo =
        stack do
            para "Jugar hasta cierta puntuacion", align: 'center', stroke:white
            @lineaAlzancar  = edit_line(:margin_left => '30%')
            stack do
                style(:margin_left => '32%',)
                @alcanzarButton = button "Alcanzar Puntuacion" 
            end
            
            para "Jugar cierta cantidad de rondas" , align: 'center',  stroke:white
            @lineaRondar    = edit_line(:margin_left => '30%')
            stack do
                style(:margin_left => '37%',)
                @rondasButton = button "Jugar Rondas"
            end
        end
    #FIN DE VISTA DE OBJETIVO
    

    #INICIO VISTA DE JUEGO
    vistaJuego = 
        stack do
            @Dir = Dir.pwd
            @jugador1 = "Jugador1"
            @jugador2 = "Jugador2"
            @resumen = "X perdio contra Y"
            @puntuacion = " 1 - 0 "
            flow do
                para @jugador1, margin_left:110, stroke:white
                para @jugador2, margin_left:240, stroke:white
            end
            flow do
                style(:margin_left => '10%', :left => '10%')
                    @player1 = image 'imagenes/rock.png' , height: 200, width:200
                    @player2 = image 'imagenes/rock.png' , height: 200, width:200
            end

            para @resumen, align: 'center', stroke:white
            para @puntuacion, align: "center", stroke:white

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
                    para "Jugada inicial de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaCopiar1  = edit_line(:margin_left => '30%')
                end
            elsif @estrategia1.text == "Uniforme"
                stack do
                    para "Lista de jugadas de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaUniforme1  = edit_line(:margin_left => '30%')
                end
            elsif @estrategia1.text == "Sesgada"
                stack do
                    para "Lista de jugadas de la estrategia del primer jugador", align: 'center', stroke:white
                    @lineaSesgada1  = edit_line(:margin_left => '30%')
                end
            else 
                omitir1 = true
            end
    
            if @estrategia2.text == "Copiar"
                stack do
                    para "Jugada inicial de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaCopiar2  = edit_line(:margin_left => '30%')
                end
            elsif @estrategia2.text == "Uniforme"
                stack do
                    para "Lista de jugadas de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaUniforme2  = edit_line(:margin_left => '30%')
                end
            elsif @estrategia2.text == "Sesgada"
                stack do
                    para "Lista de jugadas de la estrategia del segundo jugador", align: 'center', stroke:white
                    @lineaSesgada2  = edit_line(:margin_left => '30%')
                end
            else 
                omitir2 = true
            end
    
            vistaObjetivo.show()
        end   
        
        botonJugar = button "Listo para jugar" do
            vistaObjetivo.hide()
            vistaJuego.show()
            vistaConfiguracion.hide()
            botonJugar.hide()
            botonSiguiente.hide()
        end
    end


    botonJugar.hide()

end

