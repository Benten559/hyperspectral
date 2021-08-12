function ind = selectStandard(sheet,rArray)%refSheet{id,3},std_arr);
               t = char(sheet);
               t = datetime(t(1:19),'InputFormat','yyyy-MM-dd HH:mm:ss');
               % Calculate time difference
               difference = rArray(1).timeStamp - t;
               ind = 1; % last one pushed in is likely the latest time stamp
               if difference < 0 
                   difference = difference*(-1);
               end
               for i = 1:length(rArray)
                   tempDiff = rArray(i).timeStamp - t;
                   if tempDiff < 0 
                   tempDiff = tempDiff*(-1);
                   end
                   if tempDiff < difference
                       difference = tempDiff;
                       ind = i;
                   else
                       continue;
                   end
               end
               
                   
           end