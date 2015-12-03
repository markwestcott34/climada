function hazard=climada_hazard_load(hazard_file)
% climada
% NAME:
%   climada_hazard_load
% PURPOSE:
%   load a hazard event set (just to avoid typing long paths and
%   filenames in the cmd window)
% CALLING SEQUENCE:
%   hazard=climada_hazard_load(hazard_file)
% EXAMPLE:
%   hazard=climada_hazard_load(hazard_file)
% INPUTS:
%   hazard_file: the filename (and path, optional) of a previously saved hazard event set
%       If no path provided, default path ../data/hazards is used (and name
%       can be without extension .mat) 
%       > promted for if not given
% OPTIONAL INPUT PARAMETERS:
% OUTPUTS:
%   hazard: a struct, see e.g. climada_tc_hazard_set
% MODIFICATION HISTORY:
% David N. Bresch, david.bresch@gmail.com, 20140302
% David N. Bresch, david.bresch@gmail.com, 20150804, allow for name without path on input
% David N. Bresch, david.bresch@gmail.com, 20150820, check for correct filename
% Lea Mueller, muellele@gmail.com, 20151127, enhance to work with complete hazard as input
% Lea Mueller, muellele@gmail.com, 20151127, set hazard_file to empty if a struct without .lon
%-

hazard=[]; % init output

global climada_global
if ~climada_init_vars,return;end % init/import global variables

% poor man's version to check arguments
if ~exist('hazard_file','var'),hazard_file=[];end

% PARAMETERS

% if already a complete hazard, return
if isfield(hazard_file,'lon'), hazard = hazard_file; return, end
if isstruct(hazard_file), hazard_file = ''; end


% prompt for hazard_file if not given
if isempty(hazard_file) % local GUI
    hazard_file=[climada_global.data_dir filesep 'hazards' filesep '*.mat'];
    [filename, pathname] = uigetfile(hazard_file, 'Load hazard event set:');
    if isequal(filename,0) || isequal(pathname,0)
        return; % cancel
    else
        hazard_file=fullfile(pathname,filename);
    end
end

% complete path, if missing
[fP,fN,fE]=fileparts(hazard_file);
if isempty(fP),hazard_file=[climada_global.data_dir filesep 'hazards' filesep fN fE];end

load(hazard_file);  % contains hazard, the only line that really matters ;-)

% check for valid/correct hazard.filename
if ~strcmp(hazard_file,hazard.filename)
    hazard.filename=hazard_file;
    save(hazard_file,'hazard')
end

return
