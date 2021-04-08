%this script creates a .tcl file that can be used to define optimal slope
%zones in Geovia Surpac

clear all; clc; close all

geotec_sect_var_name = 'geotech'; %name of the BM variable defining the geotechnical section 
angular_zone_var_name = 'slope_zo'; %name of BM variable defining the angular zones 

geotech = 2; %number of geotechnical sector where i define angular_zones
angular_zones = [7 8 9 10]; %it means that the ith-geotech sector is characterised by an optimal profile with n angular_zones
boundaries = [6060 6220 6340 6460 6620]; %boundaries of the angular_zones

%-------------------------------------------------------------------------
%upper and lower boundaries of the angular_zones
upper_boundary = boundaries(2:end);
lower_boundary = boundaries(1:end-1);

%import base form
ImportedData = importdata('test.tcl', '\n');

fid = fopen( 'script.tcl', 'wt' );
%change the geotechnical sector number
substitute_geot_sector = ['{ "" "=" "BLOCK" "',geotec_sect_var_name,'" "',num2str(geotech),'" "" "" "" "" "" "" }']; %change 1 with the number of the geotech sector
ImportedData{16} = substitute_geot_sector;

%change the name of the variable names
ImportedData{6} = ['opfld="',angular_zone_var_name,'"'];

%for the selected geotechnical sector assign the angular zones defined
for i = 1:numel(angular_zones)   
    ImportedData{7} = ['value="',num2str(angular_zones(i)),'"'];      
    ImportedData{17} = ['{ "" "ABOVE" "Z PLANE" " ',num2str(lower_boundary(i)),' " "" "" "" "" "" "" "" }'];
    ImportedData{18} = ['{ "NOT" "ABOVE" "Z PLANE" ',num2str(upper_boundary(i)),' "" "" "" "" "" "" "" }'];
    
    fprintf(fid,'%s\n',ImportedData{:});   %# Print the cell data
    fprintf(fid,'\n');
end
fclose(fid);       

