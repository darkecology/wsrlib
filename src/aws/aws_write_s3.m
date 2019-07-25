function aws_write_s3( local_dir, s3_dir )
%AWS_WRITE_S3 Sync a local directory to s3://darkeco-cajun
%
%   aws_write_s3( local_dir, s3_dir )
%
%   Inputs:
%      local_dir   Path to local directory
%      s3_dir      Path to remote directory
%
%   Syncs <local_dir> to s3://darkeco-cajun/<s3_dir>
    
    ld_bk = getenv('LD_LIBRARY_PATH');
    setenv('LD_LIBRARY_PATH', '');
    
    fprintf('Syncing files from %s to %s\n', local_dir, s3_dir);
    
    system( sprintf('aws s3 sync  %s s3://darkeco-cajun/%s/', local_dir, s3_dir) );
    
    fprintf('Files synced.\n');
    
    setenv('LD_LIBRARY_PATH', ld_bk);    
end
