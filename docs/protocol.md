## System Preparation
- Protein–protein complexes were prepared using CHARMM-GUI.
- Systems were solvated and ionized using the CHARMM36 force field and TIP3P water model.
- CHARMM-GUI was used to generate GROMACS-compatible input files for simulation.

## Simulation Stages
1. Energy minimization (performed using GROMACS)
2. Equilibration (NVT and NPT ensembles, performed using GROMACS)
3. Production MD simulations (100 ns) (performed using GROMACS)

## Analyses Performed
- Root mean square deviation (RMSD)
- Root mean square fluctuation (RMSF)
- Radius of gyration (Rg)
- Intramolecular Hydrogen bond analysis

## Visualization
- MD analysis plots were generated in R using ggplot2
- Structural visualizations were generated using PyMOL
