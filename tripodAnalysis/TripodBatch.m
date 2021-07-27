%% Initial Segmentation
%% PATH VARIABLES
files = dir;    % Assumes '.dat' folders within working directory
leafId = {files([files.isdir]).name}; 
leafId = string(leafId(~ismember(leafId,{'.','..'}))); %Thsle working image folder
exposures = string(["canopy_lb_2020_5ms" ,"canopy_lb_2020_10ms","canopy_lb_2020_25ms"]);
imgsFolder = string(["canopy_lb_2020_5ms_000000","canopy_lb_2020_10ms_000000","canopy_lb_2020_25ms_000000"]);
dat = ["canopy_lb_2020_5ms_000000.dat","canopy_lb_2020_10ms_000000.dat","canopy_lb_2020_25ms_000000.dat"];

%% PROGRAM VARIABLES
wv = [500.0,501.7,503.3,505.0,506.7,508.4,510.0,511.7,513.4,515.1,516.7,518.4,520.1,521.8,523.4,525.1,526.8,528.5,530.1,531.8,533.5,535.1,536.8,538.5,540.2,541.8,543.5,545.2,546.9,548.5,550.2,551.9,553.6,555.2,556.9,558.6,560.3,561.9,563.6,565.3,566.9,568.6,570.3,572.0,573.6,575.3,577.0,578.7,580.3,582.0,583.7,585.4,587.0,588.7,590.4,592.1,593.7,595.4,597.1,598.7,600.4,602.1,603.8,605.4,607.1,608.8,610.5,612.1,613.8,615.5,617.2,618.8,620.5,622.2,623.8,625.5,627.2,628.9,630.5,632.2,633.9,635.6,637.2,638.9,640.6,642.3,643.9,645.6,647.3,649.0,650.6,652.3,654.0,655.6,657.3,659.0,660.7,662.3,664.0,665.7,667.4,669.0,670.7,672.4,674.1,675.7,677.4,679.1,680.8,682.4,684.1,685.8,687.4,689.1,690.8,692.5,694.1,695.8,697.5,699.2,700.8,702.5,704.2,705.9,707.5,709.2,710.9,712.6,714.2,715.9,717.6,719.2,720.9,722.6,724.3,725.9,727.6,729.3,731.0,732.6,734.3,736.0,737.7,739.3,741.0,742.7,744.4,746.0,747.7,749.4,751.0,752.7,754.4,756.1,757.7,759.4,761.1,762.8,764.4,766.1,767.8,769.5,771.1,772.8,774.5,776.2,777.8,779.5,781.2,782.8,784.5,786.2,787.9,789.5,791.2,792.9,794.6,796.2,797.9,799.6,801.3,802.9,804.6,806.3,807.9,809.6,811.3,813.0,814.6,816.3,818.0,819.7,821.3,823.0,824.7,826.4,828.0,829.7,831.4,833.1,834.7,836.4,838.1,839.7,841.4,843.1,844.8,846.4,848.1,849.8,851.5,853.1,854.8,856.5,858.2,859.8,861.5,863.2,864.9,866.5,868.2,869.9,871.5,873.2,874.9,876.6,878.2,879.9,881.6,883.3,884.9,886.6,888.3,890.0,891.6,893.3,895.0,896.7,898.3,900.0];
gain = zeros(3,240);
gain5ms = [0.000000,0.000000,0.000000,0.000000,0.000000,0.006329,0.005422,0.005014,0.005375,0.005376,0.005383,0.005425,0.005480,0.005526,0.005557,0.005558,0.005557,0.005533,0.005505,0.005448,0.005381,0.005319,0.005282,0.005254,0.005249,0.005250,0.005274,0.005275,0.005285,0.005286,0.005282,0.005270,0.005260,0.005245,0.005220,0.005194,0.005182,0.005175,0.005181,0.005191,0.005217,0.005247,0.005259,0.005284,0.005284,0.005271,0.005263,0.005244,0.005236,0.005240,0.005251,0.005268,0.005292,0.005321,0.005385,0.005443,0.005500,0.005543,0.005569,0.005578,0.005564,0.005552,0.005537,0.004404,0.004402,0.004413,0.004419,0.004432,0.004466,0.004517,0.004570,0.004638,0.004724,0.004813,0.004916,0.005048,0.005230,0.005477,0.005794,0.006173,0.006530,0.006853,0.007159,0.007610,0.007219,0.006930,0.006684,0.006422,0.006145,0.005764,0.005346,0.004934,0.004624,0.004448,0.004301,0.004214,0.004138,0.004090,0.004059,0.004032,0.004024,0.004021,0.004034,0.004060,0.004078,0.004110,0.004148,0.004183,0.004207,0.004243,0.004267,0.004284,0.004296,0.004291,0.004280,0.004270,0.004250,0.004226,0.004207,0.004186,0.004168,0.004159,0.004156,0.004153,0.004167,0.004192,0.004235,0.004288,0.004341,0.004396,0.004458,0.004501,0.004540,0.004563,0.004569,0.004560,0.004541,0.004523,0.004488,0.004456,0.004418,0.004379,0.004349,0.004325,0.004323,0.004325,0.004338,0.004362,0.004387,0.004433,0.004477,0.004535,0.004580,0.004638,0.004687,0.004733,0.004775,0.004814,0.004842,0.004874,0.004891,0.004912,0.004916,0.004912,0.004920,0.004915,0.004916,0.004913,0.004909,0.004903,0.004908,0.004916,0.004932,0.004961,0.004995,0.005046,0.005085,0.005147,0.005211,0.005298,0.005374,0.005465,0.005568,0.005672,0.005749,0.005829,0.005900,0.005961,0.005994,0.006023,0.006029,0.004325,0.004349,0.004362,0.004370,0.004388,0.004400,0.004413,0.004433,0.004462,0.004496,0.004533,0.004587,0.004652,0.004719,0.004803,0.004882,0.004968,0.005073,0.005148,0.005230,0.005328,0.005422,0.005504,0.005578,0.005640,0.005721,0.005819,0.005867,0.005929,0.005995,0.006070,0.006109,0.006152,0.006212,0.006280,0.006311,0.006345,0.006381,0.006458,0.006509,0.006547,0.006587,0.006638,0.006717,0.006789,0.006834,0.006870,0.006971,0.007097];
gain10ms = [0.000000,0.000000,0.000000,0.000000,0.000000,0.003165,0.002711,0.002507,0.002687,0.002688,0.002691,0.002713,0.002740,0.002763,0.002778,0.002779,0.002778,0.002766,0.002753,0.002724,0.002690,0.002660,0.002641,0.002627,0.002625,0.002625,0.002637,0.002637,0.002642,0.002643,0.002641,0.002635,0.002630,0.002623,0.002610,0.002597,0.002591,0.002588,0.002591,0.002596,0.002609,0.002623,0.002629,0.002642,0.002642,0.002635,0.002631,0.002622,0.002618,0.002620,0.002626,0.002634,0.002646,0.002661,0.002692,0.002722,0.002750,0.002772,0.002784,0.002789,0.002782,0.002776,0.002768,0.002202,0.002201,0.002207,0.002209,0.002216,0.002233,0.002258,0.002285,0.002319,0.002362,0.002407,0.002458,0.002524,0.002615,0.002738,0.002897,0.003086,0.003265,0.003427,0.003580,0.003805,0.003610,0.003465,0.003342,0.003211,0.003073,0.002882,0.002673,0.002467,0.002312,0.002224,0.002151,0.002107,0.002069,0.002045,0.002030,0.002016,0.002012,0.002011,0.002017,0.002030,0.002039,0.002055,0.002074,0.002092,0.002103,0.002122,0.002134,0.002142,0.002148,0.002145,0.002140,0.002135,0.002125,0.002113,0.002104,0.002093,0.002084,0.002080,0.002078,0.002076,0.002084,0.002096,0.002118,0.002144,0.002170,0.002198,0.002229,0.002250,0.002270,0.002281,0.002285,0.002280,0.002271,0.002261,0.002244,0.002228,0.002209,0.002190,0.002175,0.002162,0.002161,0.002163,0.002169,0.002181,0.002193,0.002216,0.002239,0.002268,0.002290,0.002319,0.002344,0.002367,0.002387,0.002407,0.002421,0.002437,0.002446,0.002456,0.002458,0.002456,0.002460,0.002458,0.002458,0.002456,0.002454,0.002452,0.002454,0.002458,0.002466,0.002481,0.002497,0.002523,0.002543,0.002573,0.002606,0.002649,0.002687,0.002733,0.002784,0.002836,0.002875,0.002915,0.002950,0.002980,0.002997,0.003012,0.003015,0.002162,0.002175,0.002181,0.002185,0.002194,0.002200,0.002207,0.002217,0.002231,0.002248,0.002266,0.002294,0.002326,0.002360,0.002401,0.002441,0.002484,0.002537,0.002574,0.002615,0.002664,0.002711,0.002752,0.002789,0.002820,0.002860,0.002909,0.002933,0.002965,0.002997,0.003035,0.003055,0.003076,0.003106,0.003140,0.003156,0.003172,0.003191,0.003229,0.003255,0.003274,0.003293,0.003319,0.003358,0.003394,0.003417,0.003435,0.003485,0.003549];
gain25ms = [0.000000,0.000000,0.000000,0.000000,0.000000,0.001266,0.001084,0.001003,0.001075,0.001075,0.001077,0.001085,0.001096,0.001105,0.001111,0.001112,0.001111,0.001107,0.001101,0.001090,0.001076,0.001064,0.001056,0.001051,0.001050,0.001050,0.001055,0.001055,0.001057,0.001057,0.001056,0.001054,0.001052,0.001049,0.001044,0.001039,0.001036,0.001035,0.001036,0.001038,0.001043,0.001049,0.001052,0.001057,0.001057,0.001054,0.001053,0.001049,0.001047,0.001048,0.001050,0.001054,0.001058,0.001064,0.001077,0.001089,0.001100,0.001109,0.001114,0.001116,0.001113,0.001110,0.001107,0.000881,0.000880,0.000883,0.000884,0.000886,0.000893,0.000903,0.000914,0.000928,0.000945,0.000963,0.000983,0.001010,0.001046,0.001095,0.001159,0.001235,0.001306,0.001371,0.001432,0.001522,0.001444,0.001386,0.001337,0.001284,0.001229,0.001153,0.001069,0.000987,0.000925,0.000890,0.000860,0.000843,0.000828,0.000818,0.000812,0.000806,0.000805,0.000804,0.000807,0.000812,0.000816,0.000822,0.000830,0.000837,0.000841,0.000849,0.000853,0.000857,0.000859,0.000858,0.000856,0.000854,0.000850,0.000845,0.000841,0.000837,0.000834,0.000832,0.000831,0.000831,0.000833,0.000838,0.000847,0.000858,0.000868,0.000879,0.000892,0.000900,0.000908,0.000913,0.000914,0.000912,0.000908,0.000905,0.000898,0.000891,0.000884,0.000876,0.000870,0.000865,0.000865,0.000865,0.000868,0.000872,0.000877,0.000887,0.000895,0.000907,0.000916,0.000928,0.000937,0.000947,0.000955,0.000963,0.000968,0.000975,0.000978,0.000982,0.000983,0.000982,0.000984,0.000983,0.000983,0.000983,0.000982,0.000981,0.000982,0.000983,0.000986,0.000992,0.000999,0.001009,0.001017,0.001029,0.001042,0.001060,0.001075,0.001093,0.001114,0.001134,0.001150,0.001166,0.001180,0.001192,0.001199,0.001205,0.001206,0.000865,0.000870,0.000872,0.000874,0.000878,0.000880,0.000883,0.000887,0.000892,0.000899,0.000907,0.000917,0.000930,0.000944,0.000961,0.000976,0.000994,0.001015,0.001030,0.001046,0.001066,0.001084,0.001101,0.001116,0.001128,0.001144,0.001164,0.001173,0.001186,0.001199,0.001214,0.001222,0.001230,0.001242,0.001256,0.001262,0.001269,0.001276,0.001292,0.001302,0.001309,0.001317,0.001328,0.001343,0.001358,0.001367,0.001374,0.001394,0.001419];
gain(1,:) = gain5ms;
gain(2,:) = gain10ms;
gain(3,:) = gain25ms;
avgxband = zeros(1,240);
idNames = char(leafId);
std_arr = []; %accumulator of reflectance objects
%% PROGRAM SWITCHES
analyzeStandard = true;
storeAvgMode = false;
reflectanceWrite = true;
imgWriteMode = false;
%% DATA DEPENDENCIES
refSheet = readtable("D:\assets\StSupery_Work_file",'ReadRowNames',true);
refAvg = readtable("D:\assets\Radiance Sheets\StandardRadianceAvg5ms",'ReadRowNames',true); %5ms
%% LOOP, GRAB STANDARDS
for i = 1:length(leafId)
    try
        id = idNames(:,1:32,i)
    catch
        id = "CorruptName" + string(i);
    end
    
    if isnan(refSheet{id,4}) %calibration standards marked as NaN's   %~isnan(refSheet{id,4}) == analyzeStandard
        if analyzeStandard == true
            
            rStandard = ReflectStandard(); %reflectance object
            rStandard.name = id;
            time = char(refSheet{id,3}); % The timestamp for this particular std_img
            time = datetime(time(1:19),'InputFormat','yyyy-MM-dd HH:mm:ss'); %Grab substring, convert to datetime type.
            rStandard.timeStamp = time; 
            %arrRadAvg = refAvg{id,:}; 
            for j = 1:length(wv) %This stores (reflectance_avg / avg_radiance)
                rStandard.calibrationFactor(j) = refSheet{id,6}/refAvg{id,j};
            end
            std_arr =[rStandard std_arr];
        
        else
            continue;
        end
    end
end
%% LOOP, CALCULATE REFLECTANCE AVERAGES
for i = 1:length(leafId)
    try
        id = idNames(:,1:32,i)
    catch
        id = "CorruptName" + string(i);
    end
    if isnan(refSheet{id,4}) %IGNORE THE STANDARDS
        continue;
    end
    datPath = fullfile(leafId(i),exposures(1),imgsFolder(1),dat(1));
    % load image
    Cube = multibandread(datPath,[1024,1024,240],'uint16',0','bsq','ieee-be'); % 5ms initially, to save memory
    hCube = hypercube(Cube,wv);
    % color composite
    cirIMG = colorize(hCube, "Method","cir","ContrastStretching",true); % better for NIR
    % segment mask
    [mask, maskedImg] = edgeGraphSegment(cirIMG);
    
    %store average radiance of each band
    if storeAvgMode == true
        for j = 1:length(wv)
            img = hCube.DataCube(:,:,j).*mask;
            img = img.*gain(j);
            
            sumRadiance = sum(nonzeros(img));%(img([img~=0]));
            leafPixels = length(nonzeros(img));%(img([img~=0]));
            avgxband(j) = sumRadiance/leafPixels;
        end
        %store in dir:
        writematrix([id string(avgxband)],'D:\assets\Radiance Sheets\StandardRadianceAvg25ms.csv','WriteMode','append');
    end
   %Calculate reflectance
   if reflectanceWrite == true
       refArrIndex = selectStandard(refSheet{id,3},std_arr);  % choose which reflectance offset to use
       
       for j = 1:length(wv)           
           img = hCube.DataCube(:,:,j).*mask;
           img = img.*gain(1,j);
           img = img.*std_arr(refArrIndex).calibrationFactor(j);%(refSheet{std_arr(refArrIndex).name,6})
           sumReflect = sum(nonzeros(img));
           
           leafPixels = length(nonzeros(img));
           avgxband(j) = sumReflect/leafPixels;
       end
       writematrix([id string(avgxband)],'D:\assets\Reflectance\StandardReflectanceAvg5ms.csv','WriteMode','append');
   end
   
    %image write mode
    if imgWriteMode == true
        imwrite([cirIMG, maskedImg],fullfile('D:\assets\Standard Segmentations\',id + ".jpg")) ;
    end
    
    
end