# Pendulom_clocks
This code accompanies our draft entitled "". 
It characterises the performance of a pendulum clock. Namely, it simulates its evolution (i) conditional and (ii) unconditional, under the factorisation assumption. In the conditional case, this is a monte-carlo simulations. 
The codes can illustrate the phase-space evolution of the mechanical oscillator, the populations of the atome, or the number operator of the cavity. All in both cases (i) and (ii). For (i) we also can depict the tick times, and its statistics (histogram). We will calculate the accuracy, and the Allan Variance. We then use a filter that represents the death time of the detectors. Using this filter, our statistics can improve.

# How to run
You can run the code from run_factorisation_and_resample.m in this code, imax decides how many trajectories you simulate.
The code Factorisation.mlx contains the core of the simulation. Set the parameter values, including the couplings etc, and the time-length of the evolution here. The parameter dt, cannot be too big, the simulations may break down.
The data that comes out of Factorisation is too big. size_resample shrinks the size. Good for saving and data analysis. The code also saves the relevant information for each trajectory (after resizing).

To get the data analysis (clock performance) one can run the remaining parts of run_factorisation_and_resample.m namely, using a detector, or not using a detector. If you run the full code from the command line, these will be included automatically.

# Conditional or unconditional? 
In Factorisation.mlx set ur=1 if you want to unravel (conditional evolution). set ur=0 if not.

# If you want to see the dynamics
The code run_factorisation_and_resample.m only depicts the clock performance. You cannot see the dynamics of different observables. For that, you can manually plot them (also, some codes are commented within the Factorisation code, check there too).
