% Hypergraph Attention
% V2
% Natalia Peña Serrano
% 28 - 05 - 2025
% Main script to run full connectivity analysis
clear all
clc
subjects = [2]; 
condition = 'MRV'; % MI, MLV, MRV
epochtime = 'MRV'; % MI_1, MI_2, MLV, MRV
interval = 'One_I'; % One_I, Two_I_f1, Two_I_f2

run_pipeline(subjects, condition, epochtime, interval);
brainstorm stop