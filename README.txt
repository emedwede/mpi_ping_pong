To run and build, follow these steps:

cd [to this project dir]

source ./scripts/setup.sh

#run the alias
setup_mpi_path

#to build
./scripts/construct-gpu.sh

#to run
cd gpu_build

mpirun -np 2 ./staged

mpirun -np 2 ./aware 
