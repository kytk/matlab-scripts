%% generate_connectome_figure.m
% script to generate connectome map from mrtrix-generated connectome.txt
% This also generates symmetrical matrices
% Sym_*_connectome.txt: Symmetrical matrices
% Log_Sym_*_connectome.txt: Log conversion of Symmetrical matrices

% Usage: type 'generate_connectome_figure' in Matlab and 
% Select connectome.txt(s)

% 8 Mar 2019 K.Nemoto and M.Yamamoto


%% make results directory
dircheck=exist('results','dir');
if dircheck~=7
    mkdir('results')
end

%% Select connectome text
[file path]=uigetfile('.txt','Select connectome text','MultiSelect','on');

% if only one file is selected, convert the file to cell array
if iscell(file)==0
    file={file};
end

for i=1:size(file,2)
    fname=file{1,i};
    ID=fname(1:end-4);
    
    % generate symmetrical matrix
    raw=load(fname);
    rawtrans=raw';
    tri_low=tril(rawtrans,-1);
    symmetrical=raw + tri_low;
    
    % save symmetrical matrix as a text
    symname=strcat('Sym_',fname);
    symfile=fullfile(path,'results',symname);
    dlmwrite(symfile,symmetrical,'\t');
    
    % generate connectome figure with raw value
    figure;
    colormap('jet');
    imagesc(symmetrical);
    axis square;
    colorbar;

    % save map with raw value
    pngfilename1=[ID '_raw.png'];
    pngfile1=fullfile(path,'results',pngfilename1);
    saveas(gcf,pngfile1);
    close(gcf);
    
    % generate connectome figure with log values
    symlog=log(symmetrical);
    figure;
    colormap('jet');
    imagesc(symlog);
    axis square;
    colorbar;

    % save log converted matrix as text 
    logname=strcat('Log_',symname);
    symlogfile=fullfile(path,'results',logname);
    dlmwrite(symlogfile,symlog,'\t');
    
    % save map with log value
    pngfilename2=[ID '_log.png'];
    pngfile2=fullfile(path,'results',pngfilename2);
    saveas(gcf,pngfile2);
    close(gcf);
    
 end

display('Done. Please check the results directory.');
