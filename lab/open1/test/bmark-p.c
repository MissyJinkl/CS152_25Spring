/*
 * NOTE: This microbenchmark is built to run in a physical environment
 */
#include <stdio.h>
#include <stdlib.h>
#define SIZE 98304

static inline unsigned long rdcycle(void)
{
    unsigned long cycles;
    __asm__ __volatile__ ("rdcycle %0" : "=r" (cycles));
    return cycles;
}

int main(void)
{
    /* TODO: Write your code here */
    register uint32_t a, b;
    volatile uint32_t* arr = (uint32_t *) calloc(SIZE, sizeof(uint32_t));
    unsigned long access_cycles_sum = 0;

    for (register uint32_t k = 0; k < 500; k++){
        for (register uint32_t j = 0; j < 8; j++) {
            a = arr[6144*j];
        }
        //b = arr[0];
        a = arr[6144*8];

        unsigned long start_cycle = rdcycle();
        a = arr[0];
        unsigned long end_cycle = rdcycle();
        unsigned long access_cycles = end_cycle - start_cycle;
        access_cycles_sum += access_cycles;

        for (register uint32_t j = 8; j < 16; j++) {
            a = arr[6144*j];
        }
    }

    printf("Access took %lu cycles on average \n ", access_cycles_sum/500);

    free((void *)arr);
        
    return 0;
}
