EXECUTABLE := kmeans.exe
SRC := kmeans.cpp

# INPUT_DIR needs to be set according to your local file placement
INPUT_DIR := input

CXX ?= icpc
BULK_INCLUDE=ext/bulk/include
FLAGS_FAST = -std=c++17 -O3 -ip -xSSE4.2 -axCORE-AVX2,AVX -fp-model fast=2 -Wall -Wextra
FLAGS_DEBUG = -g -O0 -std=c++17 -Wall -Wextra




build: help

help:
	@echo
	@echo '  Usage:'
	@echo '    make <target>'
	@echo
	@echo '  Targets:'
	@echo '    debug         Build for debugging'
	@echo '    release       Build for performance'
	@echo '    run-small     Run kmeans for the small data set'
	@echo '    run-large     Run kmeans for the large data set'
	@echo '    vis-small     Generate cluster.gif for the small data set'
	@echo '    vis-large     Generate cluster.gif for the large data set'
	@echo '    install-vis   Install requirements for the R visualization script'
	@echo '    clean         Clean-up of generated files'
	@echo

debug:
	${CXX} ${FLAGS_DEBUG} -I${BULK_INCLUDE} -I${MPI_INCLUDE} -L${MPI_LIBDIR} -lmpi ${SRC} -o ${EXECUTABLE}

release: ${EXECUTABLE}

${EXECUTABLE}: ${SRC}
	${CXX} ${FLAGS_FAST} -I${BULK_INCLUDE} -I${MPI_INCLUDE} -L${MPI_LIBDIR} -lmpi ${SRC} -o ${EXECUTABLE}

run-small: release
	mpirun -np 5 ./${EXECUTABLE} ./input/small.in 1000 5 20

run-large: release
	mpirun -np 48 ./${EXECUTABLE} ./input/large.in 1000000 5000 50

vis-small:
	R_LIBS_USER=~/R ./utils/vis.R ./input/small.in result.out

vis-large:
	R_LIBS_USER=~/R ./utils/vis.R ./input/large.in result.out

install-vis:
	./utils/install-prerequisites.sh

clean:
	${RM} ${EXECUTABLE} *.out *.gif

.PHONY: clean build debug release run-small run-large vis-small vis-large
