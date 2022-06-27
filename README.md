# PlatFOIL
PlatFOIL is an optimization algorithm developed by Rodrigo Perobeli SIlva Costa in order to obtain Master's degree in Computational Modelation at Juiz de Fora Federal University, Brazil.

### For this repo to work, please clone the PlatEMO repository, that can be found in: https://github.com/BIMK/PlatEMO.git
### Then:
* Insert the folder CustomByRPSC into PlatEMO's problems/SingleObjectiveOptimization folder;
* At Tutorial folder, in file Otimizador.m, change the addpath to a new one that references PlatEMO repo folder.
* Change the optimization conditions (Reynolds-Re, Mach-M, and alpha) in both CustomXFOIL.m (already in PlatEMO folder) and Otimizador.m files.

### After these configuration steps, run Otimizador.m to start the GA.

### If XFOIL isn't installed, by running Otimizador.m for the first time, it should download XFOIL before running the algorithm.
