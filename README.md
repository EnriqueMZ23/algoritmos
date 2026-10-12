# Algoritmos

Colección de problemas de algoritmos de tipo **LeetCode** que he ido resolviendo en **Java**, siguiendo el roadmap de [NeetCode](https://neetcode.io/roadmap).

Cada problema tiene:

- **La solución** (`Solution.java`).
- **Un README propio** donde explico el enunciado, cómo lo he resuelto, cómo funciona el algoritmo en general y su complejidad en tiempo y espacio.
- **Tests unitarios** con varios casos de prueba para comprobar que la solución es correcta.

## Problemas resueltos

| Categoría        | Problema                                                | Dificultad | Solución                                                  |
|------------------|---------------------------------------------------------|------------|-----------------------------------------------------------|
| Arrays & Hashing | [Two Sum](https://neetcode.io/problems/two-integer-sum) | Easy       | [two_sum](src/main/java/neetcode/arrays_hashing/two_sum/) |

## Cómo está montado el proyecto

Es un proyecto **Maven** estándar con Java 21, [JUnit 5](https://junit.org/junit5/) para los tests y [AssertJ](https://assertj.github.io/doc/) para las comprobaciones.

```
algoritmos/
├── pom.xml                        <- configuración de Maven (Java, dependencias, plugins)
├── mvnw / mvnw.cmd                <- Maven Wrapper (Linux-Mac / Windows)
├── .mvn/
│   ├── wrapper/maven-wrapper.properties   <- versión de Maven que usa el wrapper
│   └── jvm.config                 <- opciones de la JVM para Maven
├── nuevo-problema.ps1             <- script para crear un problema nuevo
└── src/
    ├── main/java/neetcode/
    │   └── <categoria>/
    │       └── <problema>/
    │           ├── Solution.java  <- la solución
    │           └── README.md      <- explicación del problema y del algoritmo
    └── test/java/neetcode/
        └── <categoria>/
            └── <problema>/
                └── SolutionTest.java  <- tests unitarios
```

- Los problemas se agrupan por las **categorías de NeetCode** (`arrays_hashing`, `two_pointers`, `sliding_window`, `stack`, `binary_search`, `trees`, `graphs`, `dp_1d`...).
- Cada problema vive en **su propio paquete**, así todas las clases pueden llamarse `Solution`, igual que en LeetCode.
- El test de cada problema está en la carpeta "espejo" de `src/test/java`, en el mismo paquete que su solución.
- En el proyecto no hay ningún método `main`. Las soluciones son clases normales, y quien las ejecuta es JUnit, igual que el corrector de LeetCode ejecuta tu `Solution`.

## Cómo están hechos los tests

Cada `SolutionTest` usa un **test parametrizado** de JUnit 5. Los casos de prueba se definen como datos en un método `casos()` y el mismo test se ejecuta una vez por cada caso:

```java
class SolutionTest {

    private final Solution solution = new Solution();

    static Stream<Arguments> casos() {
        return Stream.of(
                //           nums                       target  esperado
                Arguments.of(new int[]{2, 7, 11, 15},   9,      new int[]{0, 1}),
                Arguments.of(new int[]{3, 2, 4},        6,      new int[]{1, 2}),
                Arguments.of(new int[]{3, 3},           6,      new int[]{0, 1}),
                Arguments.of(new int[]{-1, -2, -3, -4, -5}, -8, new int[]{2, 4})
        );
    }

    @ParameterizedTest
    @MethodSource("casos")
    void twoSum(int[] nums, int target, int[] esperado) {
        assertThat(solution.twoSum(nums, target)).containsExactly(esperado);
    }
}
```

- `@ParameterizedTest` + `@MethodSource("casos")`: JUnit llama a `casos()` y ejecuta el test con cada `Arguments.of(...)`.
- Los casos incluyen los ejemplos del enunciado y casos límite: números negativos, elementos repetidos, arrays mínimos...
- `assertThat(...)` (AssertJ) compara el resultado con el esperado y, si falla, muestra un mensaje claro con la diferencia.
- Añadir un caso nuevo es tan fácil como añadir una línea más a `casos()`.

## Aprendiendo Maven

Este proyecto también me ha servido para **aprender Maven**:

- **`pom.xml`**: aquí se define la versión de Java, las dependencias de test (JUnit y AssertJ) y los plugins que compilan el código (`maven-compiler-plugin`) y ejecutan los tests (`maven-surefire-plugin`).
- **Ciclo de vida**: al ejecutar `test`, Maven compila `src/main/java`, después compila `src/test/java` y por último Surefire lanza JUnit. Todo lo generado acaba en la carpeta `target/`, que no se sube al repositorio.
- **Maven Wrapper**: no tengo Maven instalado en el sistema. Uso un **wrapper** (`mvnw` / `mvnw.cmd`) que he generado con el Maven que trae integrado **IntelliJ IDEA**, ejecutando el goal `wrapper:wrapper` con un parámetro para fijar la versión de Maven más moderna:

  ```bash
  mvn wrapper:wrapper -Dmaven=3.9.11
  ```

  Esto crea los scripts `mvnw`/`mvnw.cmd` y el fichero `.mvn/wrapper/maven-wrapper.properties`, donde queda guardada la versión. La primera vez que se ejecuta, el wrapper descarga esa versión de Maven automáticamente, así que cualquiera puede clonar el repositorio y lanzar los tests **sin instalar Maven** y siempre con la misma versión.

## Comandos para lanzar los tests

Desde la carpeta raíz del proyecto:

| Qué quiero hacer                    | Windows (PowerShell)                                      | Linux / Mac / Git Bash                                   |
|-------------------------------------|-----------------------------------------------------------|----------------------------------------------------------|
| Ejecutar todos los tests            | `.\mvnw test`                                             | `./mvnw test`                                            |
| Tests de una categoría              | `.\mvnw test -Dtest="neetcode.arrays_hashing.**"`         | `./mvnw test -Dtest="neetcode.arrays_hashing.**"`        |
| Tests de un solo problema           | `.\mvnw test -Dtest="neetcode.arrays_hashing.two_sum.*"`  | `./mvnw test -Dtest="neetcode.arrays_hashing.two_sum.*"` |
| Borrar lo compilado (`target/`)     | `.\mvnw clean`                                            | `./mvnw clean`                                           |
| Limpiar y ejecutar todo desde cero  | `.\mvnw clean test`                                       | `./mvnw clean test`                                      |

> **Nota:** `mvn test` (sin la `w`) solo funciona si tienes Maven instalado en el sistema. Con `mvnw` no hace falta.

También se pueden lanzar desde **IntelliJ**, con la pestaña *Maven* → *Lifecycle* → *test*, o con el botón ▶ que aparece junto a cada clase de test.

El resultado aparece al final de la salida:

```
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

## Añadir un problema nuevo

El script `nuevo-problema.ps1` crea las tres plantillas (solución, README y test) en su sitio:

```powershell
.\nuevo-problema.ps1 "Valid Parentheses" stack -Dificultad Easy
```

Si la URL de NeetCode no coincide con el título, se puede indicar con `-Url`:

```powershell
.\nuevo-problema.ps1 "Contains Duplicate" arrays_hashing -Url https://neetcode.io/problems/duplicate-integer
```

> Si PowerShell bloquea el script: `powershell -ExecutionPolicy Bypass -File .\nuevo-problema.ps1 ...`
