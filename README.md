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
├── nuevo-problema.ps1             <- plantilla para crear un problema nuevo
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

## Maven Wrapper

Para compilar y ejecutar los tests hace falta Maven. Hay dos formas de tenerlo:

| | Maven instalado en local | Maven Wrapper (lo que usa este proyecto) |
|---|---|---|
| **Comando** | `mvn test` | `.\mvnw test` (Windows) / `./mvnw test` (Linux-Mac) |
| **Instalación** | Hay que descargarlo, instalarlo y añadirlo al `PATH` | Nada: viene dentro del repositorio |
| **Versión de Maven** | La que tenga instalada cada persona | La fijada en el proyecto, igual para todos |
| **Dónde vive** | Donde se instaló (p. ej. `C:\Program Files\Maven`) | En la carpeta de usuario, gestionada por el wrapper |

Yo no tengo Maven instalado en el sistema, así que uso el **wrapper**.

### Cómo lo he generado

He usado el Maven que trae integrado **IntelliJ IDEA**. Con él he ejecutado el goal `wrapper:wrapper`, pasándole un parámetro para que el wrapper use la versión de Maven más moderna:

```bash
mvn wrapper:wrapper -Dmaven=3.9.11
```

Esto genera tres ficheros que se suben al repositorio:

- `mvnw`: script para Linux, Mac o Git Bash.
- `mvnw.cmd`: script para Windows.
- `.mvn/wrapper/maven-wrapper.properties`: indica qué versión de Maven hay que usar y de dónde descargarla.

  ```properties
  distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.11/apache-maven-3.9.11-bin.zip
  ```

### Qué hace el script al ejecutarlo

1. Lee `maven-wrapper.properties` para saber qué versión de Maven necesita.
2. Comprueba si esa versión ya está descargada en la **carpeta del usuario**: `~/.m2/wrapper/dists/apache-maven-3.9.11/...`. En Windows es `C:\Users\<usuario>\.m2\wrapper\dists\...`.
3. Si no lo está, **la descarga y la descomprime ahí**. Solo ocurre la primera vez.
4. Lanza esa copia de Maven con los argumentos que le hayas pasado (`test`, `clean`...).

Así, cualquiera puede clonar el repositorio y ejecutar los tests **sin instalar Maven**, y siempre con la misma versión. Para cambiar de versión basta con editar `distributionUrl` en el `.properties`: la próxima ejecución descargará la nueva.

### Lo que hace Maven en este proyecto

- **`pom.xml`**: define la versión de Java, las dependencias de test (JUnit y AssertJ) y los plugins que compilan el código (`maven-compiler-plugin`) y ejecutan los tests (`maven-surefire-plugin`).
- **Al ejecutar `test`**: Maven compila `src/main/java`, después compila `src/test/java` y por último Surefire lanza JUnit. Todo lo generado acaba en `target/`, que no se sube al repositorio.
- **Dependencias**: JUnit y AssertJ se descargan también en la carpeta del usuario, en `~/.m2/repository`, y se reutilizan entre proyectos.

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

## Añadir un problema nuevo: la plantilla `nuevo-problema.ps1`

Para no crear cada vez las carpetas y archivos a mano, el proyecto incluye `nuevo-problema.ps1`, un script de PowerShell que funciona como **plantilla de problema nuevo**. Se le pasa el título y la categoría:

```powershell
.\nuevo-problema.ps1 "Valid Parentheses" stack -Dificultad Easy
```

Y genera la estructura completa, ya en su sitio y con el paquete correcto:

```
src/main/java/neetcode/stack/valid_parentheses/
    Solution.java       <- clase Solution vacía, con el enlace al problema
    README.md           <- plantilla con: Enunciado, Ejemplos, Enfoque y Complejidad
src/test/java/neetcode/stack/valid_parentheses/
    SolutionTest.java   <- test parametrizado listo para añadir los casos
```

Después solo queda:

1. Pegar la solución en `Solution.java`.
2. Rellenar el `README.md` con la explicación del algoritmo y su complejidad.
3. Añadir los casos de prueba en `casos()` y la llamada al método en el test.
4. Ejecutar `.\mvnw test`.

| Parámetro     | Obligatorio | Descripción                                                                                |
|---------------|-------------|--------------------------------------------------------------------------------------------|
| Título        | Sí          | Nombre del problema. De él salen el nombre de la carpeta y del paquete.                    |
| Categoría     | Sí          | Una de las categorías de NeetCode (`arrays_hashing`, `stack`, `trees`...). Se autocompleta con Tab. |
| `-Dificultad` | No          | `Easy` (por defecto), `Medium` o `Hard`.                                                  |
| `-Url`        | No          | Enlace al problema. Si no se indica, se deduce del título.                                |

Si el problema ya existe, el script no sobrescribe nada y avisa.

Si la URL de NeetCode no coincide con el título, se puede indicar con `-Url`:

```powershell
.\nuevo-problema.ps1 "Contains Duplicate" arrays_hashing -Url https://neetcode.io/problems/duplicate-integer
```

> Si PowerShell bloquea el script: `powershell -ExecutionPolicy Bypass -File .\nuevo-problema.ps1 ...`
