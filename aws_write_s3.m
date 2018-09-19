function aws_write_s3( local_dir, s3_dir )
%AWS_WRITE_S3 Summary of this function goes here
%   Detailed explanation goes here
%
    
    ld_bk = getenv('LD_LIBRARY_PATH');
    setenv('LD_LIBRARY_PATH', '');
    
    fprintf('Syncing files from %s to %s\n', local_dir, s3_dir);
    
    %{
    for i = 1:numel(output.files)
        
        file = output.files{i};
        
        fprintf('Uploading %s\n', file);
                
        system( sprintf('aws s3 cp  %s s3://darkeco-cajun/%s/', file, output.dir ) );
        fprintf('Uploaded %s\n', file);
    end
    %}
    system( sprintf('aws s3 sync  %s s3://darkeco-cajun/%s/', local_dir, s3_dir) );
    
    fprintf('Files synced.\n');
    
    setenv('LD_LIBRARY_PATH', ld_bk);    
end

