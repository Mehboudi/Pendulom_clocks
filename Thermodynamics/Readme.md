# Thermodynamics
Here, we want to calculate the thermodynamics quantities. We do as follows:
(i) We use the same codes as long_time. We don't want to save all parameters, this speeds up.
(ii) We first run the code without unraveling, for a fairly long time, s.t. we are at a limit cycle. Then, save the final values of the observables. We also run the phase space of the mechanical oscillators to make sure we have a limit cycle.
(iii)The final values of observables saved in (ii) will be the initial values for the unravelling case. Since we run the unravelling for many trajectories, this will save us a lot of time. Each trajectory contains order of 100 cycles.
(iv) We repeat this for many different hot bath occupation number (starting from the cold bath, to n_h=20). The cold bath n_c should be chosen properly. It cannot be too hot, or too cold. Probably something around n_c > w_m/g_c. 
(v) The code also calculates what are the heat current and the entropy production.

# How to run
Run the first section of run_.... code in order to generate data, (will be automatically saved into various subfolders).
Then run the next two sections to load and analyse the already saved data; for filtered and unfiltered scenarios. This will produce graphs of accuracy, heat current, and entropy production, vs n_h. 
