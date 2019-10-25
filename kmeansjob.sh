#!/usr/bin/env zsh

#SBATCH -J bulk_kmeans
#SBATCH -A lect0034
#SBATCH --output=bulk_kmeans.%j

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --time=00:01:00

module switch intel gcc/8
module load intel

$MPIEXEC $FLAGS_MPI_BATCH ./kmeans.exe ./input/large.in 1000000 5000 50
