%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% this scripts analyse the changes in JRFs due to changes in femoral
% anteversion and compares the joint reaction forces at the knee joint with
% those measured by the eTibia.
% The comparison is done against force MAGNITUDES, i.e. all components of
% force computed by the JRFs and measured by the eTibia are considered.
%
% LIMITATION:
% the eTibia measurements are not clearly double-peaked, so results depend
% somehow on the assumed split of knee loadings, i.e. on the interval used
% to search for peaks (see variable: peak2_split).
% ----------------------------------------------------------------------- %

clear;clc; fclose all;close all;
% add functions
addpath(genpath('./MatlabFunctions_MSK'));
addpath(genpath('../../opensim-pipelines/Dynamic_pipeline/Matlab_pipeline_functions'))

%========== SUBJECTS ======================
% model names
subj_set = {'GC5_FemAntev40Deg', 'GC5_FemAntev40Deg_scaled'};

% folder where to get the Mat summaries
mat_summary_folder =  './Mat_Summaries_MuscleParams_sims';

% list of fields to retrieve the JRF from the summaries
JRF_set = {'hip_JRF', 'knee_JRF', 'ankle_JRF'};

debug_plots = 1;
%---------------------------------------------------------------------------

% looping through the JRF
for joint = 1:length(JRF_set)
    
    ref_ind = 0;
    
    % current JR to plot
    cur_jr_name = JRF_set{joint};

    % looping through the methods for estimation of Fiso
    for n_antev = 1:length(subj_set)
        
        % current model
        cur_model = subj_set{n_antev};
        
        % specify database (fix not working names)
        summary_file = [mat_summary_folder,'\','Summary_', strrep(cur_model,'-','_'),'.mat'];
        load(summary_file)
        
        % get JRF set
        JRF = SummaryBiomech.JRF;
        
        % get current jrf for current howWasComputedLoptLts
        var = getValueColumnForHeader(JRF, cur_jr_name);
        JR_gait_trials = squeeze(var);

        if strcmp(cur_model, 'GC5_FemAntev40Deg') == 1
            ref_ind = n_antev;
        end

        % metrics
        all_sims_JRFs(:,:, n_antev,joint) = JR_gait_trials;
        peak_sims(n_antev, : , joint ) = max(JR_gait_trials(:, :));
%         first_peaks_sims(n_antev, : , joint ) = max(JR_gait_trials(1:35, :));
%         second_peaks_sims(n_antev, : , joint ) = max(JR_gait_trials(35:end, :));
        
        clear SummaryBiomech var summary_file
    end
end


%% compare against in vivo measurements at the knee joint

% load eTibia data
load('eTibia_data.mat')
BW = 75*9.81;

% EXP DATA: eTibia total force [frames x trials] 
% trials order in eTibia mat file: [1, 11, 3, 8, 9]
eTibia_trials_totForce = squeeze(eTibia_data.GC5.ngait_og.data(:,3,:))/BW;

% SIM DATA: extract KJC and reorder them as in eTibia [frames x trials x femAntev]
% trials (second dimension) are adjusted to be in the same order as eTibia
% trials order in Summary Mat files from sims [11, 1, 3, 8, 9]
sims_KneeForce = squeeze(all_sims_JRFs(:,[2,1,3:end], : ,2));

% absolute error for each frame
abs_err = sims_KneeForce-eTibia_trials_totForce;

%% RMSE for each trial
RMSE = squeeze(sqrt(mean(abs_err.^2, 1)));
% mean and std
mean_RMSE = mean(RMSE)';
std_RMSE = std(RMSE)';

%% correlation coefficients
for n_antev = 1:length(subj_set)
cur_sims = sims_KneeForce(:,:,n_antev);
    for n_trial = 1:size(cur_sims, 2)
        [R(:,:,n_trial, n_antev), P(:,:,n_trial,n_antev)]= corrcoef(cur_sims(:,n_trial), eTibia_trials_totForce(:,n_trial));
    end
    R1(:,n_antev) = squeeze(R(1,2,:,n_antev));
    P1(:,n_antev) = squeeze(P(1,2,:,n_antev));
end
% mean and std
mean_corr_coeff = mean(R1)';
std_corr_coeff = std(R1)';
mean_p_val = mean(P1)';

%% R square for each trial (https://en.wikipedia.org/wiki/Coefficient_of_determination)
for n_antev = 1:length(subj_set)
    % 1 - sum_sq_resid / sum_sq_total
    y = eTibia_trials_totForce;
    yfit = sims_KneeForce(:,:,n_antev);
    % Compute the residual values:
    yresid = y - yfit; % 101 x 5
    % Square the residuals and total them to obtain the residual sum of squares:
    SSresid = sum(yresid.^2); % 101 x 5
    % Compute the total sum of squares of y by multiplying the variance of y by the number of observations minus 1:
    SStotal = var(y) * (length(y)-1);
    % Compute R2 using the formula:
    rsq(n_antev,:) = 1 - SSresid./SStotal;
end

% mean and std
mean_rsq = mean(rsq,2);
std_rsq = std(rsq,0,2);

%% percentage variations from baseline
% how much are the peaks varying?
% percent_var = (second_peaks_sims-second_peaks_sims(ref_ind,:,:))./second_peaks_sims(ref_ind,:,:)*100;
% percent_var = (first_peaks_sims-first_peaks_sims(ref_ind,:,:))./first_peaks_sims(ref_ind,:,:)*100;

% ref_ind is the index of the baseline model
percent_peak_var = (peak_sims-peak_sims(ref_ind,:,:))./peak_sims(ref_ind,:,:)*100;

% check the % variations on single joints
hip_peak_var  = percent_peak_var(:,:,1);
knee_peak_var = percent_peak_var(:,:,2);
ankle_peak_var = percent_peak_var(:,:,3);

% mean and std
mean_hip_var = mean(hip_peak_var, 2);      std_hip_var = std(hip_peak_var, 0, 2);
mean_knee_var = mean(knee_peak_var, 2);    std_knee_var = std(knee_peak_var, 0, 2);
mean_ankle_var = mean(ankle_peak_var, 2);  std_ankle_var = std(ankle_peak_var, 0, 2);

%% comparison against eTibia measurements
% peak splitters
peak1_split = 35;
peak2_split = 45;

% Note that first peak is larger in all trials of eTibia
[first_peaks_etibia, ind_p1] = max(eTibia_trials_totForce(1:peak1_split,:));
[second_peaks_etibia, ind_p2] = max(eTibia_trials_totForce(peak2_split:end,:));

first_knee_peaks_sims = squeeze(max(sims_KneeForce(1:peak1_split,:,:)))';
second_knee_peaks_sims = squeeze(max(sims_KneeForce(peak2_split:end,:,:)))';

% check plotting
if debug_plots == 1
    plot(eTibia_trials_totForce, 'k'); hold on
    plot(ind_p1, first_peaks_etibia, 'rs' );
    plot(peak2_split+ind_p2-1, second_peaks_etibia, 'rx' );
    xlim([0 100]); xlabel('Gait Cycle [%]')
    ylim([0 2.5]);    ylabel('Joint Reaction Forces [BW]')
    title('Peaks check')
end

% absolute error between peaks
% abs_error_peak1 = 100*(first_knee_peaks_sims-first_peaks_etibia)./first_peaks_etibia;
% abs_error_peak2 = 100*(second_knee_peaks_sims-second_peaks_etibia)./second_peaks_etibia;

abs_error_peak1 = first_knee_peaks_sims-first_peaks_etibia;
abs_error_peak2 = second_knee_peaks_sims-second_peaks_etibia;

% mean and std (peak 1)
mean_error_peak1 = mean(abs_error_peak1,2);
std_error_peak1 = std(abs_error_peak1,0,2);
% mean and std (peak 2)
mean_error_peak2 = mean(abs_error_peak2,2);
std_error_peak2 = std(abs_error_peak2,0,2);

% table of results
col_var = {'FemAntev+40'; 'FemAntev+40_scaled'};
results_table = table(col_var, mean_hip_var, std_hip_var, mean_knee_var, std_knee_var, mean_ankle_var, std_ankle_var,...
                        mean_error_peak1,  std_error_peak1, mean_error_peak2, std_error_peak2, mean_RMSE, std_RMSE, mean_rsq, std_rsq, mean_corr_coeff, std_corr_coeff, ...
                   'VariableNames',{'Femoral Anteversion Angle', 'Mean var (HIP) [%]', 'STD hip','Mean var (KNEE) [%]', 'STD knee', 'Mean var (ANKLE) [%]', 'STD ankle',...
                   'Mean Error Peak1 [BW]', 'STD Error Peak1 [BW]', 'Mean Error Peak2 [BW]','STD Error Peak2 [BW]','Mean RMSE [BW]', 'STD RMSE [BW]','MEAN R^2','STD R^2','Mean corr coeff', 'STD corr coeff'});

 % show it
disp(results_table)

% saving table
writetable(results_table, 'table_results_scaled_mus_sims.xls')