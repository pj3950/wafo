function [r1, r2, ind]= rndweib2d(varargin)
%RNDWEIB2D Random numbers from the 2D Weibull distribution.
%
% CALL:  [R1 R2] = rndweib2d(a1,b1,a2,b2,c12,sz,options);
%        [R1 R2] = rndweib2d(phat,sz,options);    
%
%  R1,R2     = two matrices of simulated data of size SZ
%  A1,B1,
%  A2,B2,C12 = parameters of the distribution
%       phat = Distribution parameter struct
%              as returned from FITWEIB2D.
%  sz        = size of R1, R2 (default common size of parameters)
%  options   = struct with fieldnames:
%     .releps  : specified relative tolerance (Default 1e-3) 
%     .iter_max: Maximum number of iterations (default 500)
%
%  The samples are generated by inversion.
%
% Example:
%   par = {2,2,1,3,.8};
%   [R1 R2]=rndweib2d(par{:},2000,1);
%   plotweib(R1);
%   plot(R1,R2,'.')
%
% See also  pdfweib2d, cdfweib2d, fitweib2d, momweib2d, invcweib2d

%tested on matlab 5.1
%history:
% by Per A. Brodtkorb 19.11.98

error(nargchk(3,15,nargin))
Np = 5;
options = struct('lowertail',true,'logp',false,'releps',1e-3,'iter_max',500); % default options
[params,options,rndsize] = parsestatsinput(Np,options,varargin{:});
if numel(options)>1
  error('Multidimensional struct of distribution parameter not allowed!')
end

[a1,b1,a2, b2,c12] = deal(params{:});

if isempty(a1)||isempty(b1)||isempty(a2)||isempty(b2)||isempty(c12)
  error('Requires either 6 input arguments or that input argument 3 is FDATA.'); 
end

if isempty(rndsize),
  [csize] = comnsize(params{:});
else
  [csize] = comnsize(params{:},zeros(rndsize{:}));
end


r1=rndweib(a1,b1,0,csize);
% perform a direct inversion by newton
P=rand(csize);
[r2 ind]=invcweib2d(r1 ,P,params{:},options); % Inverse of the 2D weibull cdf given X1 . slow




