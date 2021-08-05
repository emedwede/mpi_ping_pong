#!/bin/bash

alias setup_mpi_path="export PATH=/home/ai4science/HPC/openmpi/4.11/bin${PATH:+:${PATH}};\
	export LD_LIBRARY_PATH=/home/ai4science/HPC/openmpi/4.11/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

module purge

module load cuda/11.0

module load cmake

module list
