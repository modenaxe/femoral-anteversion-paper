%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
clear;clc; fclose all;close all;
% add functions
addpath(genpath('./MatlabFunctions_MSK'));
addpath(genpath('../../opensim-pipelines/Dynamic_pipeline/Matlab_pipeline_functions'))

% %========== SUBJECTS ======================
% root folder for placing the folders for each subject
database_root_folder = [pwd,'/2_Dataset'];

% model names
subj_set = {'GC5_FemAntev-2Deg',...
    'GC5_FemAntev5Deg',...
    'GC5_FemAntev12Deg',...
    'GC5_FemAntev19Deg',...
    'GC5_FemAntev26Deg',...
    'GC5_FemAntev33Deg',...
    'GC5_FemAntev40Deg'};

% folder where to get the Mat summaries
mat_summary_folder =  './Results_Mat_Summaries';

% folder where to save figures
figure_folder = './Figure_2';

% axis labels
AxisFontSize = 16; 
AxisFontWeight = 'normal';

% list of fields to retrieve the JRF from the summaries
JRF_set = {'hip_JRF', 'knee_JRF', 'ankle_JRF'};
cur_joint_title_set = {'Hip', 'Knee', 'Ankle'};
%---------------------------------------------------------------------------

% check folder existance
if ~isfolder(figure_folder); mkdir(figure_folder); end

% setting the figure
figure_handle = figure('Position', [ 71 549  1520 330]);

steps = linspace(1, 0, length(subj_set));
steps2 = linspace(0.4, 1, length(subj_set));


% looping through the JRF
for j = 1:length(JRF_set)
    ref_ind = 0;
    % current JR to plot
    cur_jr_name = JRF_set{j};
    cur_joint_title = cur_joint_title_set{j};
    
    
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

        subplot(1, 3, j)
        if j == 2 && n_antev ==1
            load('eTibia_data.mat')
            force = eTibia_data.GC5.ngait_og.data(:,:,1);
            BW = 75*9.81;
            plot(0:100, force(:,3)/BW,'r','LineWidth',2); hold on
        end
        
        
        if strcmp(cur_model, 'GC5_FemAntev12Deg') == 1
            % plot: no_gait 1 (order: 11 - 1 - 3 - 8 -9)
            plot(0:100, squeeze(var(:,2)), 'Color','k','LineWidth',2); hold on
            ref_ind = n_antev;
        else
            if ref_ind>0
                plot(0:100,squeeze(var(:,2)), 'Color',[0,  0, steps2(n_antev)],'LineWidth',1); hold on
            else
                plot(0:100,squeeze(var(:,2)), 'Color',[0,  steps2(n_antev), 0],'LineWidth',1); hold on
            end
        end

        if j ==2
            ylim( [ 0 3.5])
        end
        xlim( [ 0 100])
        ax = gca; % current axes
        ax.FontSize = 13;
        ax.TickDir = 'out';
        xlabel('Gait Cycle [%]','FontWeight',AxisFontWeight,'FontSize',AxisFontSize,'FontName','Arial')
        title([cur_joint_title,' Joint' ],'FontSize',AxisFontSize,'FontName','Arial')
        if j==1
        ylabel({[' Joint Reaction Force [BW]']},'FontWeight',AxisFontWeight,'FontSize',AxisFontSize,'FontName','Arial')
        end
        box off
        
        % metrics
        first_peaks(n_antev, : , j ) = max(JR_gait_trials(1:35, :));
        second_peaks(n_antev, : , j ) = max(JR_gait_trials(35:end, :));
        
        clear SummaryBiomech var summary_file
    end
end
set(gcf,'PaperPositionMode','Auto');
saveas(gcf, fullfile(figure_folder, 'JRF_dependency.fig'));
% saveas(gcf, fullfile(figure_folder,'JRF_dependency.emf'));
% saveas(gcf, fullfile(figure_folder,'JRF_dependency.png'));
% saveas(H_JMom, fullfile(figure_folder,'Figure5_kinetics_comparison.png'));