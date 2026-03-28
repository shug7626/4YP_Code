# 4YP Code
This git repo is for the storage and tracking of the development of a MATLAB program to simulate photovoltaic solar cells.

# Notes
## MATLAB Dependencies
Optimization Toolbox<br/>
Parallel Computing Toolbox - set the number of parallel processes as high as reasonable for the CPU<br/>
Last run on MATLAB R2024b

## Issues/Future Improvements
The method used to calculate the voltage for a given current density input doesn't vary the two parasitic resistances, $R_\text{s}$ and $R_\text{sh}$, with material thickness. The shunt resistance, $R_\text{sh}$, is used in both evaluate_PVK_V.m and evaluate_Si_V.m. The two series resistances, $R_\text{s}$ are both used in the same line of evaluate_V.m.<br/>
Both optimisation scripts take a significant time to perform the calculations. Ensure N is suitably sized for desired accuracy and computation time.

## Present Simulation and Optimisation
For both the simulation and optimisation programs, ensure parameters_template.m is copied and renamed to parameters.m. Also include the cumulative wavelength spectrum in the same folder and named Spectrum_full.xlsx.<br/>
The present simulator uses a current scanning method. It can be found in the CurrentScan folder and run using the PVK_Si_main.m script.<br/>
There are two simulators currently being used, both use the current scanning method to find the Maximum Power Point (MPP). They can both be found in the Optimisation folder.

## optimisation_main.m
optimisation_main.m calculates a grid of NxN MPPs between the limits, both set in parameters.m.<br/>
Due to the complexity of finding the MPP for each thickness and that the number of MPPs calculated increases with $\text{N}^2$, ensure N is set to the lowest suitable value. Depending on CPU performance and number of parallel processes used, N=24 will take at least 20 minutes.<br/>
It then uses the maximum MPP from the grid as the initial guess for a numerical solver to find the maximum MPP.<br/>
It also calculates the Cost per Watt from the grid of MPPs. Three different costs can be set in parameters.m: baselineCost, PVKCost, and SiCost.<br/>
Again, the minimum Cost per Watt from the grid is used as the input to a numerical solver to find the minimim Cost per Watt.

## optimisationV2_main.m
optimisationV2_main.m calculates a 5x5 grid of MPPs between the limits and 'zooms in' to the maximum of that grid. The number of 'zoom ins' is set by N in the parameters file. In the worst case scenario the search boundary will half with each loop, in the best case it will quarter.<br/>
As N sets the number of loops performed, computation time increases linearly with N. As an example, N=10 will take at least 10 minutes but will be more precise than the value found in optimisation.m<br/>
At present optimisationV2_main.m doesn't calculate the minimum cost per watt or use the result as input to a numerical solver.





# Past Simulations
## Single, Ideal Silicon Solar Cell
InitialSimulations contains IdealSimulation.m, which simulates an ideal silicon solar cell

## Single, Non-ideal Silicon Solar Cell
InitialSimulations also contains two different scripts for simulating a silicon solar cell with series and shunt resistances.<br/>
IndividualParasiticResistanceSim.m plots one non-ideal cell along with an ideal cell.<br/>
ParasiticResistanceSimulation.m plots various non-ideal cells on one plot.

## Tandem Silicon Solar Cells
BasicTandemSimulations contains BasicTandemSim.m which simulates two silicon solar cells using their ideality factors.<br/>
IdealityFactorFreeTandemSims contains NFreeSiliconTandem which replaces the ideality factors with three different recombination terms using material parameters.

## Log-based Silicon Solar Cell Simulations
In an attempt to improve simulation stability, a log-based approach was introduced to help normalise the calculations about a mid point.<br/>
LogBasedSim contains three folders for simulating the three types listed above (single ideal, single non-ideal, tandem)

## Spectrum Dependent Tandem Silicon Solar Cell Simulations
To remove dependence on knowing the short-circuit current generation of each cell, the incident photon spectrum can be used to calculate the short circuit current density of each cell.<br/>
TandemSi-SiSpectrum contains Si_Si_Spectrum_main.m, which takes a cumulative incident photon spectrum and material parameters as input, and plots the J-V curve and absorbed spectrum plot (amongst other available plots).

## Single, Ideal Perovskite Solar Cell (PSC)
SinglePVK contains SinglePVKmain.m, which takes perovskite material parameters and the cumulative photon spectrum as input and plots the current density-voltage plot.

