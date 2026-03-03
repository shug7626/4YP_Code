# 4YP Code
This git repo is for the storage and tracking of the development of a MATLAB program to simulate photovoltaic solar cells.

## Single, Ideal Silicon Solar Cell
InitialSimulations contains IdealSimulation.m, which simulates an ideal silicon solar cell

## Single, Non-ideal Silicon Solar Cell
InitialSimulations also contains two different scripts for simulating a silicon solar cell with series and shunt resistances.
IndividualParasiticResistanceSim.m plots one non-ideal cell along with an ideal cell.
ParasiticResistanceSimulation.m plots various non-ideal cells on one plot.

## Tandem Silicon Solar Cells
BasicTandemSimulations contains BasicTandemSim.m which simulates two silicon solar cells using their ideality factors.
IdealityFactorFreeTandemSims contains NFreeSiliconTandem which replaces the ideality factors with three different recombination terms using material parameters.

## Log-based Silicon Solar Cell Simulations
In an attempt to improve simulation stability, a log-based approach was introduced to help normalise the calculations about a mid point.
LogBasedSim contains three folders for simulating the three types listed above (single ideal, single non-ideal, tandem)

## Spectrum Dependent Tandem Silicon Solar Cell Simulations
To remove dependence on knowing the short-circuit current generation of each cell, the incident photon spectrum can be used to calculate the short circuit current density of each cell.
TandemSi-SiSpectrum contains Si_Si_Spectrum_main.m, which takes a cumulative incident photon spectrum and material parameters as input, and plots the J-V curve and absorbed spectrum plot (amongst other available plots).

## Single, Ideal Perovskite Solar Cell (PSC)
SinglePVK contains SinglePVKmain.m, which takes perovskite material parameters and the cumulative photon spectrum as input and plots the current density-voltage plot.
