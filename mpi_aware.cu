#include <mpi.h>
#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

int main(int argc, char* argv[]) {
  	MPI_Init(&argc,&argv);
	{	
	int size;

	MPI_Comm_size(MPI_COMM_WORLD, &size);

	int rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	MPI_Status stat;

	if(size != 2){
		if(rank == 0){
			printf("This program requires exactly 2 MPI ranks, but you are attempting to use %d! Exiting...\n", size);
		}
		MPI_Finalize();
		exit(0);
	}
	
	//map MPI ranks to GPU
	cudaSetDevice(rank);
	int tag1 = 10;
	int tag2 = 20;
	
	
for(int i = 0; i <= 29; i++) {
	long int N = 1 << i;	
	
	//device memoy
	double *device_buffer;
	cudaMalloc(&device_buffer, N*sizeof(double));
	
	int loop_count = 50;
	
	auto start_time = MPI_Wtime();
	//warm-up loop
	//we have the staged version here
	for(int i = 1; i <=loop_count; i++) {
		if(rank == 0) {
			MPI_Send(device_buffer, N, MPI_DOUBLE, 1, tag1, MPI_COMM_WORLD);
			MPI_Recv(device_buffer, N, MPI_DOUBLE, 1, tag2, MPI_COMM_WORLD, &stat);

		}
		else if(rank == 1) {
			MPI_Recv(device_buffer, N, MPI_DOUBLE, 0, tag1, MPI_COMM_WORLD, &stat);
			MPI_Send(device_buffer, N, MPI_DOUBLE, 0, tag2, MPI_COMM_WORLD);
		}
	}

	auto stop_time = MPI_Wtime();
	auto elapsed_time = stop_time - start_time;

	//free the memory
	cudaFree(device_buffer);

	long int num_B = 8*N;
	long int B_in_GB = 1 << 30;
	double num_GB = (double)num_B / (double)B_in_GB;
	double avg_time_per_transfer = elapsed_time / (2.0*(double)loop_count);

	if(rank == 0) {
		printf("Transfer size (B): %10li, Transfer Time (s): %15.9f, Bandwidth (GB/s): %15.9f\n", num_B, avg_time_per_transfer, num_GB/avg_time_per_transfer );
	}
}
	}
	MPI_Finalize();
}
