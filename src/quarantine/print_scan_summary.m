function [  ] = print_scan_summary( radar, scan_dir )
%PRINT_SCAN_SUMMART Print out summary information of this scan which makes
%it easy to compute statistics on the whole dataset. 

 
    summary_file = fopen(sprintf('%s/summary.txt', scan_dir),'w');
    num_dz_sweeps = numel(radar.dz.sweeps);
    num_vr_sweeps = numel(radar.vr.sweeps);
    
    %scan-level summary
    fprintf(summary_file,'VCP : %d\n', radar.vcp);
    fprintf(summary_file,'HEIGHT : %d\n',radar.height);
    
    %reflectivity summary for all sweeps
    fprintf(summary_file,'DZ_SWEEPS_NBINS :');
    for sweep_num=1:num_dz_sweeps,
        fprintf(summary_file, '%d,',radar.dz.sweeps(sweep_num).nbins);
    end
    fprintf(summary_file,'\n');
    fprintf(summary_file,'DZ_SWEEPS_NRAYS :');
    for sweep_num=1:num_dz_sweeps,
        fprintf(summary_file, '%d,',radar.dz.sweeps(sweep_num).nrays);
    end
    fprintf(summary_file,'\n');
    fprintf(summary_file,'DZ_SWEEPS_GATESIZE :');
    for sweep_num=1:num_dz_sweeps,
        fprintf(summary_file, '%d,',radar.dz.sweeps(sweep_num).gate_size);
    end
    fprintf(summary_file,'\n');
        fprintf(summary_file,'DZ_SWEEPS_RANGEBIN1 :');
    for sweep_num=1:num_dz_sweeps,
        fprintf(summary_file, '%d,',radar.dz.sweeps(sweep_num).range_bin1);
    end
    fprintf(summary_file,'\n');
    
    %radial velocity summary for all sweeps
    fprintf(summary_file,'VR_SWEEPS_NBINS :');
    for sweep_num=1:num_vr_sweeps,
        fprintf(summary_file, '%d,',radar.vr.sweeps(sweep_num).nbins);
    end
    fprintf(summary_file,'\n');
    fprintf(summary_file,'VR_SWEEPS_NRAYS :');
    for sweep_num=1:num_vr_sweeps,
        fprintf(summary_file, '%d,',radar.vr.sweeps(sweep_num).nrays);
    end
    fprintf(summary_file,'\n');
    fprintf(summary_file,'VR_SWEEPS_GATESIZE :');
    for sweep_num=1:num_vr_sweeps,
        fprintf(summary_file, '%d,',radar.vr.sweeps(sweep_num).gate_size);
    end
    fprintf(summary_file,'\n');
        fprintf(summary_file,'VR_SWEEPS_RANGEBIN1 :');
    for sweep_num=1:num_vr_sweeps,
        fprintf(summary_file, '%d,',radar.vr.sweeps(sweep_num).range_bin1);
    end
    fprintf(summary_file,'\n');
    
    fclose(summary_file);

end

