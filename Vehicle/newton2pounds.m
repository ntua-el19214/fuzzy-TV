function pounds = newton2pounds(newtons)
% NEWTONSTOPOUNDS Converts force from newtons to pounds.
%   pounds = NEWTONSTOPOUNDS(newtons) converts the input value in
%   newtons to pounds.
%
%   1 newton is approximately 0.224809 pounds.

conversionFactor = 0.224809; % 1 newton is approximately 0.224809 pounds
pounds = newtons * conversionFactor;
end
