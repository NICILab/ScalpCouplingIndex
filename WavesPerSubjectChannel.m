function [w1,w2] = WavesPerSubjectChannel (filtered_data, ch_num)
% raw_data = raw1;
% ch_num = 1;
w1 = filtered_data(:,ch_num); %760 nm
w2 = filtered_data(:,ch_num+41); %850 nm

end