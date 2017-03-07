Fs = 1000; %sampling rate = 1000 Hz
numchans=128;
numshanks=2;
load('E:\Tristan\VLSE neuro 4-4\probe_data\probe128A.mat') %load probe geometry for probe 128A
cd(strcat(exp_dir, '\LFP\LFP1000\')); %change directory to experimental directory; e.g., 'E:\BenA\SLAYTraining\SLAY1-3\10-27-16\cortex'

time = 1:length('LFPvoltage_ch.2.mat'); %time points; 'LFPvoltage_ch.2.mat' can be any channel, as long as it exists, i.e. is not bad / has not been removed; purpose is to get number of indices in channel
N = NaN([1,numchans]); %preallocate array N with length # of channels = 128

%%need to have TimeCorr from program: Calculating-Run-Segments.m
%%need to have LFPvecReorg matrix from program: Probe-Reorganization.m

LFPgeri = nan(size(LFPvecReorg),'single'); %initialize 2-D matrix that will contain LFP values for 'run' segments
for n = 1:size(TimeCorr,1) %cycle through number of run segments
    startCorr = TimeCorr(n,1); %identify start indices for run segments
    endCorr = TimeCorr(n,2); %identify end indices for run segments
    LFPgeri(:,[startCorr:endCorr]) = LFPvecReorg(:,[startCorr:endCorr]); %populate LFPgeri with run segments; non-run segments remain NaN (from initialization)
end

LFPgeri(isnan(LFPgeri)) = []; %concatenate run segments by removing NaN (non-movement indices); matrix now smaller than LFPvecReorg