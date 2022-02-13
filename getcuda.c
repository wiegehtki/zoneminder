#include <cuda.h>
#include <stdio.h>

int main(int argc, char** argv) {
    int driver_version = 0, runtime_version = 0;

    cudaDriverGetVersion(&driver_version);
    cudaRuntimeGetVersion(&runtime_version);
    if (driver_version == 11060) {
        printf("11.6");
       } 
    else
	{
	printf("NA");
        };
//#, runtime_version);
//#           "Runtime Version: %d\n",

    return 0;
}
