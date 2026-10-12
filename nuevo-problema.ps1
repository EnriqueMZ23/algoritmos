<#
.SYNOPSIS
    Crea el esqueleto de un nuevo problema de NeetCode.
.EXAMPLE
    .\nuevo-problema.ps1 "Valid Parentheses" stack -Dificultad Easy
    -> src/main/java/neetcode/stack/valid_parentheses/{Solution.java, README.md}
    -> src/test/java/neetcode/stack/valid_parentheses/SolutionTest.java
.EXAMPLE
    .\nuevo-problema.ps1 "Contains Duplicate" arrays_hashing -Url https://neetcode.io/problems/duplicate-integer
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][string]$Titulo,
    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateSet("arrays_hashing", "two_pointers", "sliding_window", "stack", "binary_search",
            "linked_list", "trees", "heap", "backtracking", "tries", "graphs", "advanced_graphs",
            "dp_1d", "dp_2d", "greedy", "intervals", "math_geometry", "bit_manipulation")]
    [string]$Categoria,
    [ValidateSet("Easy", "Medium", "Hard")][string]$Dificultad = "Easy",
    # Enlace del problema en neetcode.io (por defecto se deduce del título, pero NeetCode a veces usa otro nombre)
    [string]$Url
)

$nombresCategoria = @{
    arrays_hashing = "Arrays & Hashing"; two_pointers = "Two Pointers"; sliding_window = "Sliding Window"
    stack = "Stack"; binary_search = "Binary Search"; linked_list = "Linked List"; trees = "Trees"
    heap = "Heap / Priority Queue"; backtracking = "Backtracking"; tries = "Tries"; graphs = "Graphs"
    advanced_graphs = "Advanced Graphs"; dp_1d = "1-D Dynamic Programming"; dp_2d = "2-D Dynamic Programming"
    greedy = "Greedy"; intervals = "Intervals"; math_geometry = "Math & Geometry"; bit_manipulation = "Bit Manipulation"
}

$slug = ($Titulo.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
$nombrePkg = $slug -replace '-', '_'
if ($nombrePkg -match '^[0-9]') { $nombrePkg = "p_$nombrePkg" }
$paquete = "neetcode.$Categoria.$nombrePkg"
if (-not $Url) { $Url = "https://neetcode.io/problems/$slug" }

$mainDir = Join-Path $PSScriptRoot "src/main/java/neetcode/$Categoria/$nombrePkg"
$testDir = Join-Path $PSScriptRoot "src/test/java/neetcode/$Categoria/$nombrePkg"

if (Test-Path $mainDir) {
    Write-Error "Ya existe: $mainDir"
    exit 1
}
New-Item -ItemType Directory -Force $mainDir, $testDir | Out-Null

$utf8 = New-Object System.Text.UTF8Encoding $false

$solution = @"
package $paquete;

/**
 * $Titulo - $Url
 * Explicación en README.md de esta misma carpeta.
 */
public class Solution {

    // TODO: pega aquí el método de tu solución
}
"@

$readme = @"
# $Titulo

- **Categoría:** $($nombresCategoria[$Categoria])
- **Dificultad:** $Dificultad
- **Enlace:** $Url

## Enunciado

TODO

## Ejemplos

| Entrada | Salida |
|---------|--------|
|         |        |

## Enfoque

TODO

## Complejidad

- **Tiempo:** O(?)
- **Espacio:** O(?)
"@

$test = @"
package $paquete;

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
"@

[IO.File]::WriteAllText((Join-Path $mainDir "Solution.java"), $solution, $utf8)
[IO.File]::WriteAllText((Join-Path $mainDir "README.md"), $readme, $utf8)
[IO.File]::WriteAllText((Join-Path $testDir "SolutionTest.java"), $test, $utf8)

Write-Host "Creado $paquete"
Write-Host "  $mainDir"
Write-Host "  $testDir"
