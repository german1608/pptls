load 'Partida.rb'

Shoes.app(title: "Piedra, Papel, Tijera, Lagarto o Spock", width: 500, height: 700, resizable: false) do
    background('imagenes/espacio.jpeg')

    
    #INICIO VISTA DE INICIO
    vistaObjetivo =
        stack do
            para "Bienvenido" , align: 'center', size:"large", stroke:white
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

    #INICIO VISTA DE INICIO

    vistaJuego.hide()
    vistaObjetivo.hide()
    flow do
        style( :margin_left => '25%')
        button "Vista Juego" do
            vistaObjetivo.hide()
            vistaJuego.show()
        end
        button "Vista Objetivo" do
            vistaObjetivo.show()
            vistaJuego.hide()
        end
    end

end

