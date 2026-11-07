// Self-checking testbench: deterministic pseudo-random inputs, reference product computed here (not by gemm()),
// exit code = number of mismatches (capped at 255). Bambu's co-simulation replaces the gemm() call with the RTL.
#include <stdio.h>
#include "gemm.h"

static TYPE m1[N], m2[N], prod[N];

static uint32_t lcg(uint32_t *s) {
    *s = *s * 1103515245u + 12345u;
    return *s >> 8;
}

int main() {
    uint32_t s = 2024;
    for (int i = 0; i < N; i++) {
        m1[i] = (TYPE)(lcg(&s) % 2001) - 1000;  // [-1000, 1000]
        m2[i] = (TYPE)(lcg(&s) % 2001) - 1000;
        prod[i] = 0;
    }
    gemm(m1, m2, prod);
    int errors = 0;
    long long checksum = 0;
    for (int i = 0; i < row_size; i++)
        for (int j = 0; j < col_size; j++) {
            uint32_t ref = 0;  // wrap-around like the kernel's int32 arithmetic
            for (int k = 0; k < row_size; k++)
                ref += (uint32_t)m1[i * col_size + k] * (uint32_t)m2[k * col_size + j];
            if ((uint32_t)prod[i * col_size + j] != ref) {
                if (errors < 5) printf("mismatch prod[%d][%d]: got %d expected %d\n", i, j, prod[i * col_size + j], (int32_t)ref);
                errors++;
            }
            checksum += prod[i * col_size + j];
        }
    printf("gemm_int32: %d errors, checksum %lld\n", errors, checksum);
    return errors > 255 ? 255 : errors;
}
