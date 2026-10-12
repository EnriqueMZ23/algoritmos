# Two Sum

- **Categoría:** Arrays & Hashing
- **Dificultad:** Easy
- **Enlace:** https://neetcode.io/problems/two-integer-sum

## Enunciado

Dado un array de enteros `nums` y un entero `target`, devuelve los índices de los dos
números que suman `target`. Se garantiza que existe exactamente una solución y no se
puede usar el mismo elemento dos veces.

## Ejemplos

| Entrada                          | Salida  |
|----------------------------------|---------|
| `nums = [2,7,11,15], target = 9` | `[0,1]` |
| `nums = [3,2,4], target = 6`     | `[1,2]` |
| `nums = [3,3], target = 6`       | `[0,1]` |

## Enfoque

Recorremos el array una sola vez guardando en un `HashMap` cada valor con su índice.
Para cada `nums[i]` calculamos su complemento `target - nums[i]`; si ya lo hemos visto,
tenemos la respuesta.

## Complejidad

- **Tiempo:** O(n)
- **Espacio:** O(n)
