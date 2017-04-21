function Psi = sampleStateSeq( Psi, data, objIDs )
% Draw new assignments for the discrete hidden state sequence
%  for each time series, using provided feature asgns and HMM  params.
% Uses a fast message backward, sample forwards algorithm, in MEX C code.
%  also takes advantage of cached computations of soft evidence.
%USAGE:
%  Psi = sampleStateSeq( Psi, data, objIDs*)
%    where optional arg forces sampling of only select sequences
%    when not provided all sequences are sampled
%INPUT:
%  Psi : input model config, includes HMM trans and emit params, feat asgns
%          and can also store cached likelihood computations
%  data : SeqObs data object
%  objIDs : row vector of integer IDs for specific sequences to sample
%OUTPUT
%  Psi : new model configuration with updated HMM hidden state assignments

if ~exist('objIDs','var')
    objIDs=1:data.N;
end

stateSeq = Psi.stateSeq;

% --------------------------  loop over all time series
for ii=objIDs
        
    ks = find( Psi.F(ii,:)>0 );
    
%     fprintf('For sequence %d we have sampled a state sequence with ',ii);

    % If we only have one feature set all of time-steps to this state
    if length( ks ) == 1
%         fprintf('1 feature (state)\n');
        stateSeq(ii).z = Psi.TransM.seq(ii).availFeatIDs(1)*ones(1,data.Ts(ii) );
        continue;
    end
    
    if isfield( Psi, 'cache') && isfield(Psi.cache, 'logSoftEv' )
        logSoftEv = Psi.cache.logSoftEv{ii};
    else
        logSoftEv = Psi.ThetaM.calcLogSoftEv( ii, data, ks );
    end
    logSoftEv = logSoftEv(ks,:);
    
    normC = max( logSoftEv, [], 1);
    logSoftEv = bsxfun( @minus, logSoftEv, normC );
    Lik = exp( logSoftEv );
     
    SEED = randomseed();
    randomseed( SEED+1 );
    
    % Else sample the state sequence of z1:T from the posterior z1:t ~
    % p(z1:T|x1:T) using Forwards filtering/Backwards sampling 
    z = SampleHMMStateSeqC( Psi.TransM.pi( ii ), Lik, Psi.TransM.pi_init(ii), SEED(1) );
%     fprintf('%d features (states)\n', length(unique(z)));
    stateSeq(ii).z = Psi.TransM.seq(ii).availFeatIDs(z);
    
end % loop over time series objs

Psi.stateSeq = stateSeq;

end % main function


