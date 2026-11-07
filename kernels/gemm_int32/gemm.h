// MachSuite gemm_ncubed with int32_t elements (the original uses double); sizes unchanged.
#include <stdint.h>

#define row_size 64
#define col_size 64
#define N (row_size * col_size)
#define TYPE int32_t

void gemm(TYPE m1[N], TYPE m2[N], TYPE prod[N]);
