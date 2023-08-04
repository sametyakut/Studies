function matAnsys(recordedScriptName,modifiedScriptName,projectName,designName,Do,Dr,airgap,Ls,iter,dir)
    % Reading Recorded Script and Creating the Modified Script File
    scrOrg = fopen(recordedScriptName,'r');
    scrMod = fopen(modifiedScriptName,'w');
    
    if scrOrg < 0
        error('Cannot open original script')
    end
    
    if scrMod < 0
        error('Cannot open modified script')
    end
    
    % Updating the Modified Script File
    while true
    
        if feof(scrOrg)  % checking the end of the file, if reached -> break the loop
            fclose(scrOrg);
            fclose(scrMod);
            break;
        end
    
        str = fgetl(scrOrg); % reading the original script line-by-line
    
        if strcmpi(str(2:end),'matlab') % writing the parameters from MATLAB
            fprintf(scrMod, 'projectName = "%s" \n', projectName);
            fprintf(scrMod, 'designName = "%s" \n', designName);
            fprintf(scrMod, "Do = %f \n", Do);
            fprintf(scrMod, "Dr = %f \n", Dr);
            fprintf(scrMod, "airgap = %f \n", airgap);
            fprintf(scrMod, "Ls = %f \n", Ls);
            fprintf(scrMod, "iter = %d \n", iter);
            fprintf(scrMod, 'dir = "%s" \n', dir);
            fprintf(scrMod, 'fname = "designSheet_iter%d" \n',iter);
    
        else % copying the rest of the code from the original script
            fprintf(scrMod, "%s \n", str);
        end
    
    end
    
    % Run FEA Model
    system('script.vbs');
end

