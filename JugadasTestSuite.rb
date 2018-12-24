require "test/unit"
load "Jugadas.rb"


class TestJugadas < Test::Unit::TestCase
    def test_draw
        jugadas = [Papel, Tijeras, Piedra, Spock, Lagarto]
        jugadas.each do |jugada|
            assert_equal([0, 0], jugada.new.puntos(jugada.new))
        end
    end

    def test_papel
        jugada = Papel.new
        # Victorias
        assert_equal([1, 0], jugada.puntos(Piedra.new))
        assert_equal([1, 0], jugada.puntos(Spock.new))
        # Derrotas
        assert_equal([0, 1], jugada.puntos(Tijeras.new))
        assert_equal([0, 1], jugada.puntos(Lagarto.new))
    end

    def test_tijeras
        jugada = Tijeras.new
        # Victorias
        assert_equal([1, 0], jugada.puntos(Papel.new))
        assert_equal([1, 0], jugada.puntos(Lagarto.new))
        # Derrotas
        assert_equal([0, 1], jugada.puntos(Piedra.new))
        assert_equal([0, 1], jugada.puntos(Spock.new))
    end

    def test_piedra
        jugada = Piedra.new
        # Victorias
        assert_equal([1, 0], jugada.puntos(Lagarto.new))
        assert_equal([1, 0], jugada.puntos(Tijeras.new))
        # Derrotas
        assert_equal([0, 1], jugada.puntos(Spock.new))
        assert_equal([0, 1], jugada.puntos(Papel.new))
    end

    def test_spock
        jugada = Spock.new
        # Victorias
        assert_equal([1, 0], jugada.puntos(Piedra.new))
        assert_equal([1, 0], jugada.puntos(Tijeras.new))
        # Derrotas
        assert_equal([0, 1], jugada.puntos(Papel.new))
        assert_equal([0, 1], jugada.puntos(Lagarto.new))
    end

    def test_lagarto
        jugada = Lagarto.new
        # Victorias
        assert_equal([1, 0], jugada.puntos(Spock.new))
        assert_equal([1, 0], jugada.puntos(Papel.new))
        # Derrotas
        assert_equal([0, 1], jugada.puntos(Piedra.new))
        assert_equal([0, 1], jugada.puntos(Tijeras.new))
    end

    def test_maliciosos
        assert_raise(ArgumentError) do
            jugada = Jugada.new
            jugada.puntos(jugada)
        end
        assert_raise(ArgumentError) do
            jugada = Jugada.new
            papel = Papel.new
            jugada.puntos(papel)
        end
        assert_raise(ArgumentError) do
            papel = Papel.new
            papel.puntos(Jugada.new)
        end
        papel = Papel.new
        papel.puntos(papel)
    end
end
