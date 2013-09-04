%RSL2MAT
cd rsl2mat/rsl/
system('make')
cd ..
make
cd ..

%Add Paths
install
cd all_viz

%Compile using mcc
compile_gen
