function [ moment ] = pot2moment( pot )
%POT2MOMENT Convert from information form to moment form (i.e. get mean
%           and covariance matrix)
moment = arrayfun(@pot2moment_single, pot);

end

function [moment] = pot2moment_single( pot )
    %Simple check to see if the matric is singular or not
    if(nnz(isfinite(pot.K))==4),
	moment.S=pinv(pot.K);
    else
        error_log=fopen('singular_log.txt','w');
        fprintf(error_log,'The matrix was singular \n');
        fclose(error_log);
        moment.S=zeros(2,2);	
   end
    %disp('This function is used');
    %moment.S  = pinv(pot.K); % Not sure what to do if K is singular...
    moment.mu = moment.S*pot.b;
end
