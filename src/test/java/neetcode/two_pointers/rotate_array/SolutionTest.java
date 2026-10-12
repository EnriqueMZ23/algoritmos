package neetcode.two_pointers.rotate_array;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class SolutionTest {

    private final Solution solution = new Solution();

    static Stream<Arguments> casos() {
        return Stream.of(
                // Arguments.of(entrada..., esperado)
        );
    }

    @ParameterizedTest
    @MethodSource("casos")
    void resolver(Object entrada, Object esperado) {
        // TODO: assertThat(solution.metodo(entrada)).isEqualTo(esperado);
    }
}