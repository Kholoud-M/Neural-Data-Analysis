function ripples = ripple_detection(lfp_filt,sr,params)

% envelop
[up,~] = envelope(lfp_filt);

% z score
zscore = (up.^2 - mean(up.^2))/std(up.^2);

% parameters for ripple detection
min_duration = params.minimum_duration/1000; % second
cutoff = params.zscore_cutoff;
min_interval = params.minimum_interval/1000; % second

% detect ripples
sig_index = find(zscore>=cutoff);
i = 1;n=1;
ripples = struct();
while i<=length(sig_index)
rip_start = sig_index(i);
zscore_rest = zscore(rip_start:end);
rip_end = rip_start + find(zscore_rest if rip_end-rip_start+1 > min_duration*sr
ripples(n).start_time = rip_start/sr;
ripples(n).end_time = rip_end/sr;
n = n+1;
end
i = find(sig_index>rip_end,1);
end

% merge ripples
i = 1;
while i < length(ripples)
interval = ripples(i+1).start_time - ripples(i).end_time;
if interval > min_interval
i = i+1;
else
ripples(i).end_time = ripples(i+1).end_time;
ripples(i+1) = [];
end
end

%
for i = 1:length(ripples)
ripples(i).duration = ripples(i).end_time - ripples(i).start_time;
ripples(i).data = lfp_filt(floor(ripples(i).start_time*sr):floor(ripples(i).end_time*sr));
end