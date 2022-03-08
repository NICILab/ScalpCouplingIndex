% Main

group_name = 'CI raw data';
num_ch = 41;
short_channels = [2,7,15,17,21,28,34,39];
fs = 5.42; %taken from homer3 info
bndps_Hz = [0.5 2.5];

%
info_cell = {};
counter = 0;
subj_array = [];
info_by_channel = {};

%extract raw data
folder_info = dir(group_name);
for i = 1:length(folder_info)
    if folder_info(i).isdir == 0
        name = folder_info(i).name;
        if contains(name, 'raw')
            counter = counter+1;
            %load raw data
            name = strcat(group_name, '\',name);
            LD = load(name);
            F= fieldnames(LD);
            field_name = F{1,1};
            raw_data = LD.(field_name);
            %display status
            txt = strcat("subject: ", num2str(counter));
            disp(txt)
            %cardiac data: raw filtered to contain only cardiac component
            cardiac_data = FilterRawSubject(raw_data,bndps_Hz); %extract cardiac comonent for each subject
            %for each subject:
            for j = 1:num_ch
            %exclude short channels
            if isempty(short_channels(short_channels(:) == j)) 
            [w1,w2] = WavesPerSubjectChannel (cardiac_data, j);
            %correlation at lag 0 
            r = xcorr(w1,w2,0,'coeff'); 
            %save to cell
            info_cell{end+1,1} = counter;
            info_cell{end,2} = j;
            info_cell{end,3} = r;
            %check correlations by two parameters
            if r < 0.6 %Zhou's parameter
                info_cell{end,4} = '<0.6';
            elseif r > 0.6 && r < 0.75 %Paollini's parameter
                info_cell{end,4} = '<0.75';
            else
                info_cell{end,4} = num2str(0);
            end
            end

            end

        end
    end
end

%create new list (for block average gui): for every channel, which subjects
%were excluded

bchannel_list = [];
bcsubject_list = [];
for i = 1:length(info_cell)
%      ~isempty(strfind(info_cell{i,4},'0.75') > 0) || 
    if   ~isempty(strfind(info_cell{i,4},'0.6') > 0) 
        bchannel_list(end+1,1) = info_cell{i,2};
        bcsubject_list(end+1,1) = info_cell{i,1};
        
    end
end


unique_ch = unique(bchannel_list);
for i = 1:length(unique_ch)
    curr_ch = unique_ch(i);
    a = find(bchannel_list == curr_ch);
    info_by_channel{end+1,1} = curr_ch;
    v = bcsubject_list(a)';
    L = length(v);
     v = join(sprintfc('%d',v),",");
    info_by_channel{end,2} = v{:};
    info_by_channel{end,3} = L; %number of subjects
end

%export to excel
title1 = ["bad channel", "subjects excluded", "number of subjects"];
info_by_channel(2:length(info_by_channel)+1,:) = info_by_channel;
info_by_channel(1,1:length(title1)) = cellstr(title1);
table_by_channel = table(info_by_channel);
xl_name = strcat(group_name," bad channels SCI new.xlsx");
writetable(table_by_channel,xl_name);





