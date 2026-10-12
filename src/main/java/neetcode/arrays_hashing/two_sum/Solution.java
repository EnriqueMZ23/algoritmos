package neetcode.arrays_hashing.two_sum;

import java.util.HashMap;
import java.util.Map;

/**
 * Two Sum - https://neetcode.io/problems/two-integer-sum
 * Explicación en README.md de esta misma carpeta.
 */
public class Solution {

    public int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> vistos = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complemento = target - nums[i];
            if (vistos.containsKey(complemento)) {
                return new int[]{vistos.get(complemento), i};
            }
            vistos.put(nums[i], i);
        }
        return new int[0];
    }
}
