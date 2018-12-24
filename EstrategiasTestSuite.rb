require "test/unit"
load "Jugadas.rb"
load "Estrategias.rb"
load "InputMocking.rb"

class EstrategiasTestSuite < Test::Unit::TestCase
    def test_manual
        inputs_para_manual = {
            "1" => Piedra,
            "2" => Papel,
            "3" => Tijeras,
            "4" => Lagarto,
            "5" => Spock
        }
        inputs_para_manual.each do |input, jugada|
            InputMocker.with_fake_input([input]) do
                manual = Manual.new()
                assert_instance_of(jugada, manual.prox(nil))
            end
        end
        # Probamos que haga raise de ArgumentError cuando el argumento no sea una subclase
        manual = Manual.new()
        assert_raise(ArgumentError) do
            manual.prox(1)
        end
    end

    def test_copiar
        # Probamos el initialize
        invalid_params = [Jugada, 1, "Jugada", "Tijeras"]
        invalid_params.each do |invalid_param|
            assert_raise(ArgumentError) do
                Copiar.new(invalid_param)
            end
        end

        # Probamos que responda correctamente
        jugadas = [Tijeras, Piedra, Papel, Spock, Lagarto].map { |x| x.new }
        jugadas.each do |jugada|
            copiar = Copiar.new(jugada)
            # La primera jugada es suministrada como parametro al constructor
            assert_equal(jugada, copiar.prox(nil))
            # Las siguientes son lo que se pase como parametro a prox
            jugadas.each do |jugada|
                assert_equal(jugada, copiar.prox(jugada))
            end
        end
    end

    def test_uniforme
=begin
        Aqui aprovechamos que la semilla es fija (42) para fijar valores.
        Las siguientes longitudes de arreglos producen los siguientes numeros "aleatorios"
        fijos:
        1: 0
        2: 0
        3: 2
        4: 2
        5: 3
=end
        posibles_parametros = [:Tijeras, :Papel, :Piedra, :Spock, :Lagarto]
        indices_esperados = {
            1 => 0,
            2 => 0,
            3 => 2,
            4 => 2,
            5 => 3
        }
        retornos = {
            :Tijeras => Tijeras,
            :Papel => Papel,
            :Piedra => Piedra,
            :Spock => Spock,
            :Lagarto => Lagarto
        }

        posibles_parametros.permutation.each do |parametro|
            u = Uniforme.new(parametro)
            jugada = u.prox()
            actual = jugada
            expected = retornos[parametro[indices_esperados[parametro.length]]]
            assert_instance_of(expected, actual)
        end
    end
end
