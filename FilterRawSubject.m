function cardiac_data = FilterRawSubject (raw_data,bndps_Hz)

fs = 5.425347256022363;
filtered_data = bandpass(raw_data,bndps_Hz,fs);
cardiac_data = filtered_data;



%spectrum check
% a = filtered_data(:,1);
% 
% n = length(a);
% t = ((0:n-1)/fs)';
% 
% ttable1 = timetable(seconds(t),a);
% [pxx1,f1] = pspectrum(ttable1);
% pwr_dB = pow2db(pxx1);
% figure;plot(f1,pwr_dB);
% title('filtered data');
% 
% b = raw_data(:,1);
% ttable2 = timetable(seconds(t),b);
% [pxx2,f2] = pspectrum(ttable2);
% pwr_dB2 = pow2db(pxx2);
% figure;plot(f2,pwr_dB2);
% title('raw data');
% 
% c = cardiac_data(:,1);
% ttable3 = timetable(seconds(t),c);
% [pxx3,f3] = pspectrum(ttable3);
% pwr_dB3 = pow2db(pxx3);
% figure;plot(f3,pwr_dB3);
% title('cardiac data');