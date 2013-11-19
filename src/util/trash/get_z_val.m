function [ z_val,masked_dz ] = get_z_val( dz,bird_mask,az,max_direction)

%This is the function to return the required reflectivity values for
%computing bird densities. 
%Input:
%dz : the reflectivity values (142 X 720 matrix)
%bird_mask : double(abs(vr - vel) > thresh) [From Gauthreaux calculations]
%az : the azimuth values (142 X 720 matrix)
%max_direction : the direction around which the wedge is to be taken
        masked_dz = dz;
        masked_dz(~bird_mask) = nan;



        %find the closest val in azimuths that corresponds to max_direction
        az_max=abs(az(1,:)-max_direction);
        [~, max_index]=min(az_max);

        %max_index is probably the column we need. Select a 15 degree wedge on either side. Set all these pixels to a high
        %value for visualization

        boundary=size(masked_dz,2);

        %create another copy of masked_dz to calculate the reflectivity values
        masked_dz_b = masked_dz; 

        %we need to handle some boundary cases when creating the wedge
        if ( max_index < 15),               %the first case
            for i=1:max_index,
                masked_dz(:,i) = 50;
            end
            for i=boundary:-1:(boundary-(15-max_index)),    %loop backwards
                masked_dz(:,i) = 50;

            end
        end
        if (max_index + 15 > boundary),   %the second case
            for i=max_index:boundary,
                masked_dz(:,i) = 50;
            end
            for i=1:(15 - (boundary-max_index)),
                masked_dz(:,i) = 50;
            end
        end
        if( max_index + 15 <= boundary && max_index - 15 >= 0),     %the regular case
            start_ind=max_index-15;
            end_ind=max_index+15;
            if start_ind ==0,
                start_ind=1;
            end
            for i=start_ind:end_ind,
                masked_dz(:,i)=50;
            end
        end 


        z_val=zeros(size(find(masked_dz==50),1),1);     %to compute the median instead of the average
        cnt=1;
        z_sum=0;
        num_pixels=0;
        for i=1:size(masked_dz,1),
            for j=1:size(masked_dz,2),
                if(masked_dz(i,j) == 50),
                    if (isnan(masked_dz_b(i,j)) == 0),
                        z_val(cnt,1)=(10^(masked_dz_b(i,j)/10));
                        z_sum = z_sum + z_val(cnt,1);
                        cnt=cnt+1;
                        num_pixels=num_pixels+1;
                    end

                end
            end
        end

        z_val=z_val(1:(cnt-1),1);       %All the z's that we need


end

