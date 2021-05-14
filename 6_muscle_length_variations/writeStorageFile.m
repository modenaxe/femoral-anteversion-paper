%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %

function writeStorageFile(data_struct, sto_file, str_data_description)

% check on the data structure
if ~isfield(data_struct,'data') || ~isfield(data_struct,'colheaders') 
    error(['The function writeStorageFile needs as input a dataStruct with fields ''colheaders'' and ''data''.',...
        'The number of columns of DataStruct.data has to equalize the number of headers.']);
end

% defines local variables and their size
colheaders  = data_struct.colheaders;
data        = data_struct.data;

% sizes of data
[N_rows, N_columns] = size(data);

% check on consistency of the structure data
if size(colheaders,2)~=N_columns
    error('The number of column headers is not consistent with the number of data rows.')
end

% file name
[~,name,ext] = fileparts(sto_file);
sto_file_name = [name,ext];

% open file
fid = fopen(sto_file,'w');

% % Write Header
fprintf(fid,'%s\n',sto_file_name);
fprintf(fid,'%s\n','version=1');
fprintf(fid,'%s\n',['nRows=',num2str(N_rows)]);
fprintf(fid,'%s\n',['nColumns=',num2str(N_columns)]);
fprintf(fid,'%s\n','inDegrees=no');
fprintf(fid,'\n');
fprintf(fid,'%s\n',['This file contains ',str_data_description, '.']);
fprintf(fid,'\n');
fprintf(fid,'%s\n','endheader');

% writing the column headers while generating the format for printing the
% data
format_string ='';
for n_headers = 1:N_columns
    if n_headers == N_columns
        % prints header
        fprintf(fid,'%s\n',colheaders{N_columns});
        % builds up format string
        format_string = [format_string,'%-14.14f\n']; %#ok<*AGROW>
    else
        fprintf(fid,'%s\t', colheaders{n_headers});
        format_string = [format_string,'%-14.14f\t'];
    end
end

% writing the data in OpenSim format
fprintf(fid, format_string, data');
fclose all;

end