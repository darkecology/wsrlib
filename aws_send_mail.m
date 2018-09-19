function aws_send_mail(msg, exp_tag)
    
    ld_bk = getenv('LD_LIBRARY_PATH');
    setenv('LD_LIBRARY_PATH', '');
    %addr = 'pbhambhani@cs.umass.edu';
    addr = 'inboxaws@gmail.com'
    %subject = sprintf('Cajun: %s Batch Run Error', exp_tag);
    subject = sprintf('Cajun: %s Batch Run Stats', exp_tag);
     
    fprintf('Sending email via aws to %s\n', addr);
                
    system( sprintf(['aws ses send-email ',...
                        '--from \"%s\" --destination \"ToAddresses=%s\" ',...
                        '--message \"Subject={Data=''%s'', Charset=utf8}, ',...
                        'Body={Text={Data=''%s'', Charset=utf8}}\"'],...
                    addr, addr, subject, msg ) );
    fprintf('Sent email via aws to %s\n', addr);
    
    setenv('LD_LIBRARY_PATH', ld_bk);    
end
