function grabdeformedSTL(name, start, step, stop, single) 

%% import COMSOL class and load mph model 
import com.comsol.model.*
import com.comsol.model.util.* 
model = mphload(name); 
range = append('range( ', num2str(start), ',' , num2str(step), ',', num2str(stop), ')', ' ', num2str(single)); 

% ok it doesnt really show up on the COMSOL GUI, but 
% changing the scale does change the STL file that is exported, confirmed. 
model.result('pg1').feature('surf1').feature('def1').set('scaleactive', 'on');
model.result('pg1').feature('surf1').feature('def1').set('scale', '10000');

model.study('std1').feature('stat').setIndex('plistarr', range, 0); %sets list of parameters THIS WORKS WHEN YOU LAUNCH THE MODEL SIMULTANEOUSLY 

model.study('std1').run
mphlaunch(model) %in case you want to check through the COMSOL API

N = length(start:step:stop) + 1; 

for m = 1: N
model.result('pg1').feature('surf1').feature('def1').set('scale', '0'); %exaggerate scale to easily confirm that bridge is deforming 
model.result('pg1').setIndex('looplevel', num2str(m) , 0);
model.result('pg1').run;
% the only reason why this works is because you are working with a mph file
% that already has plot1 set up manually 
model.result.export('plot1').set('filename', strcat('deformedSTL', num2str(m)));
model.result.export('plot1').set('structSTL', 'stlbin');
model.result.export('plot1').run;
end 
end 
