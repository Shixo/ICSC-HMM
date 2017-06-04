function [data, TruePsi, Data, True_states] = load_rolling_dataset( data_path, type, display, full, normalize)

label_range = [1 2 3];
 
switch type

    case 'raw'
        load(strcat(data_path,'Rolling/raw-data.mat')) 
        
        % Make fake labels
        for i=1:length(Data)
            True_states{i} = ones(1,length(Data{i}));
        end
        
    case 'proc'
        load(strcat(data_path,'Rolling/proc-data-labeled.mat'))
                        
        if normalize
            for i=1:length(Data)
                X = Data{i};
                mean_X     = mean(X,1);
                X_zeroMean = bsxfun( @minus, X, mean_X );
                Data{i} = X_zeroMean;
            end
        end
        
        
end

if full == 1 % Load the 15 time-series
    
    if display == 1
        ts = [1:5];
        figure('Color',[1 1 1])
        for i=1:length(ts)
            X = Data{ts(i)};
            true_states = True_states{ts(i)};
            
            % Plot time-series with true labels
            subplot(length(ts),1,i);
            data_labeled = [X ; true_states];
            plotLabeledData( data_labeled, [], strcat('Time-Series (', num2str(ts(i)),') with true labels'), [], label_range)
        end
        
        
        figure('Color',[1 1 1])
        ts = [6:10];
        for i=1:length(ts)
            X = Data{ts(i)};
            true_states = True_states{ts(i)};
            
            % Plot time-series with true labels
            subplot(length(ts),1,i);
            data_labeled = [X ; true_states];
            plotLabeledData( data_labeled, [], strcat('Time-Series (', num2str(ts(i)),') with true labels'), [], label_range)
        end
        
        figure('Color',[1 1 1])
        ts = [11:15];
        for i=1:length(ts)
            X = Data{ts(i)};
            true_states = True_states{ts(i)};
            
            % Plot time-series with true labels
            subplot(length(ts),1,i);
            data_labeled = [X ; true_states];
            plotLabeledData( data_labeled, [], strcat('Time-Series (', num2str(ts(i)),') with true labels'), [], label_range)
        end
    end
else % Load 5 time-series

    Data_ = Data; True_states_ = True_states;
    clear Data True_states
    iter = 1;
    for i=1:3:length(Data_)
        Data{iter} = Data_{i};
        True_states{iter} = True_states_{i};
        iter = iter + 1;
    end
    
    if display == 1
        ts = [1:length(Data)];
        figure('Color',[1 1 1])
        for i=1:length(ts)
            X = Data{ts(i)};
            true_states = True_states{ts(i)};
            
            % Plot time-series with true labels
            subplot(length(ts),1,i);
            data_labeled = [X ; true_states];
            plotLabeledData( data_labeled, [], strcat('Time-Series (', num2str(ts(i)),') with true labels'), [], label_range)
        end
    end
    
end


% Data structures for ibp-hmm / icsc-hmm
data = SeqData();
N = length(Data);
for iter = 1:N    
    X = Data{iter};
    labels = True_states{iter};
    data = data.addSeq( X, num2str(iter), labels );
    
    Data{iter} = Data{iter}';
    True_states{iter} = True_states{iter}';
end

TruePsi = [];



end


