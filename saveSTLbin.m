function saveSTLbin(filename,vertices,polygons)
%Usage: saveSTLbin(filename,vertices,polygons).
%
%Where:
%*Filename is a string containing the name of the output file.
%*Vertices is a Vx3 matrix containing V rows with each the x,y,z
%coordinates of a vertex. The vertex-ID is defined as the row-number.
%*Polygons is a Px3 matrix containing P rows with 3 vertex-IDs of the
%vertices that make up the polygon.

%Prepare an empty header
header=zeros(1,80,'uint8');


fid=fopen(filename,'wb');
fwrite(fid,header,'uint8');
fwrite(fid,size(polygons,1),'uint32');
for i=1:size(polygons,1)
    %Compute normal, used by some STL renderers for shading
    v1=[vertices(polygons(i,2),1)-vertices(polygons(i,1),1);...
        vertices(polygons(i,2),2)-vertices(polygons(i,1),2);...
        vertices(polygons(i,2),3)-vertices(polygons(i,1),3)];
    
    v2=[vertices(polygons(i,3),1)-vertices(polygons(i,1),1);...
        vertices(polygons(i,3),2)-vertices(polygons(i,1),2);...
        vertices(polygons(i,3),3)-vertices(polygons(i,1),3)];
    
    normal=cross(v1,v2);
    Nnormal=normal./dot(normal,normal);
    fwrite(fid,Nnormal,'single');
    fwrite(fid,vertices(polygons(i,1),:),'single');
    fwrite(fid,vertices(polygons(i,2),:),'single');
    fwrite(fid,vertices(polygons(i,3),:),'single');
    fwrite(fid,0,'uint16');
end

fclose(fid);



end