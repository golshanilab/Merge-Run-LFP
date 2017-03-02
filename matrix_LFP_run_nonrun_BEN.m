function matrix_LFP_run_nonrun_BEN(animal,state)

Fs = 1000; %sampling rate = 1000 Hz
numchans=128;
numshanks=2;
load('E:\Tristan\VLSE neuro 4-4\probe_data\probe128A.mat')
cd(strcat(exp_dir, '\LFP\LFP1000\')); %change directory to experimental directory; e.g., 'E:\BenA\SLAYTraining\SLAY1-3\10-27-16\cortex'

time = 1:length('LFPvoltage_ch.2.mat'); %time points; 'LFPvoltage_ch.2.mat' can be any channel, as long as it exists, i.e. is not bad / has not been removed; purpose is to get number of indices in channel
N = NaN([1,numchans]); %preallocate array N with length # of channels = 128

%%need to have TimeCorr from program: Calculating-Run-Segments.m
%%need to have LFPvecReorg matrix from program: Probe-Reorganization.m

LFPvecReorgRun = nan(length(TimeCorr),2,1); %initialize 3-D matrix

%%build array with NaN's before s(1,1), between e(n,2) and s(n+1,1), and
%%after e(n,2)

%%THIS CODE NEEDS WORK.

for n = 1:length(TimeCorr) %n = number of run segments
    startCorr = TimeCorr(n,1,:); %startCorr = start of each run segment
    endCorr = TimeCorr(n,2,:); %endCorr = end of each run segment
    length(n) = endCorr - startCorr; %length of run segment is endCorr - startCorr; length of n will change over loop (for each segment)
    LFPvecReorgRun(:,:,n) = [startCorr:endCorr];
end

%%THE CODE THAT FOLLOWS IS A FUNCTIONING ALTERNATIVE TO THE CODE ABOVE THAT NEEDS WORK. BOTH SHOULD PRODUCE THE SAME RESULT. THE CODE ABOVE WILL BE MORE EFFICIENT.

tic;
LFPvecReorgRun = LFPvecReorg;
if state == 'run'
    for z = 1:size(LFPvecReorgRun,1) %run through all channels
        for i = 1:size(LFPvecReorg,2) %run through all LFP data points
            for n = 1:length(TimeCorr)-1 %run through start/end-run matrix
                if i < TimeCorr(1,1) %if before start of first run --> NaN
                    LFPvecReorgRun(z,i) = NaN; %
                elseif i > TimeCorr(n,2) && i < TimeCorr(n+1,1)
                    LFPvecReorgRun(z,i) = NaN;
                elseif i > TimeCorr(n+1,2)
                    LFPvecReorgRun(z,i) = NaN;
                end
            end
        end
    end
end
toc; %3000 seconds
