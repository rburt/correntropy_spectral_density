%This takes a collection of trumpet notes, estimates the frequency, and classifies each note

close all
clear all


load trumpet_iowa_cell
load class_names_trumpet
load class_frequencies_trumpet

count = zeros(1,35);

for note = 1:35;
    
    x = collection{note};

    x = x(10000:10799); %Sample portion of the note
    
    x = (x-mean(x))/max(x); %Normalize

    [W1,W2,H1,H2] = CNMFS(x,5,.05,.05,11025);   %Compute correntropy decomposition

    ind_list(note) = index;
    
    [value,loc] = max(H1);

    freq(loc);  %Find frequency

    note_ind = knnsearch(log2(class_frequencies),log2(freq(loc)));  %Classify sample

    if note_ind == note
        count(note) = 1;
    end

end

sum(count)/length(count)    %Display percentage of correct notes
