# DoF-Allocation
The code is a MATLAB implementation of the optimal depth of field (DoF) allocation, which is proposed in

- A. Aghasi, B. Heshmat, L. Wei, M. Tian, S. Cholewiak, "Optimal Allocation of Quantized Human Eye Depth Perception for Light Field Display Design", under review, 2020

Our code uses Gurobi as the MBP/LP solver, which comes with a free license for academic use. Gurobi can be downloaded at:
https://www.gurobi.com/
After installing the software, it can be conveniently linked to MATLAB. For example, Mac users can use the link below to connect Gurobi and MATLAB:
https://www.gurobi.com/documentation/9.0/quickstart_mac/matlab_setting_up_grb_for_.html


In the following we briefly overview the main functions and scripts that need to be executed one after the other to perform a complete allocation. 

-- \texttt{createDoFTrain:}
This script allows the user to create a train of DoF profiles as functions of the depth and age. The code uses some basic parameters such as the pupil diameter,  minimum diopter range, and parameters controlling the resolution of the train knolls, to perform this task. Running \texttt{createDoFTrain} would produce the variables \texttt{profileTrain} and \texttt{centers}, which correspond to the train of DoF profiles and their corresponding centers. These files are encapsulated and saved as \texttt{RawProfileTrains.mat} to be used in the subsequent steps. The code also produces a snapshot of the profile trains, similar to Figure \ref{figDoFs}(a). 

-- \texttt{hypoGen:} Once the DoF profile train is generated, this function can be called to generate the binary matrix $\bPi$. While the matrix $\bPi$ can be readily used in the MBP program, the condensing process discussed in the next section can significantly reduce its size and produce an equivalent matrix with significantly fewer rows. 

-- \texttt{LPMBP:} This is the function that solves the main MBP, and uses the function \texttt{Gurobi\_LP\_Solver} to call the Gurobi optimizer. The \texttt{LPMBP} function first tries to solve the LP relaxation (which is faster), and if the solution is not binary, it then tries to call the Gurobi integer programming routines. 

-- \texttt{Demo:} To present a complete example of DoF allocation, the code \texttt{Demo} makes use of the functions described above in order, and perform two sets of DoF allocation for $T=1,\ldots,9$ that produce a result similar to Figure \ref{figOpt}(b).  
