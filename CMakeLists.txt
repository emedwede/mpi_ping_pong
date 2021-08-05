cmake_minimum_required(VERSION 3.18)

project(TestMPI LANGUAGES CXX CUDA)

#find_package(Kokkos REQUIRED)

find_package(MPI REQUIRED)

add_executable(staged mpi_staged.cu)
target_link_libraries(staged MPI::MPI_CXX)

add_executable(aware mpi_aware.cu)
target_link_libraries(aware MPI::MPI_CXX)




