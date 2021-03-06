%Record your sound command

w=1;
while(1)

recObj = audiorecorder; % Initialised speech recorder object 

in=input('Press a to command and x to exit...','s');

if in == 'a'
disp('Start')
recordblocking(recObj, 1.2); % Recording speech
disp('Stop');

y = getaudiodata(recObj); % Converting recorded speech to array

d=fdesign.highpass('Fst,Fp,Ast,Ap',8700/16000,10000/16000,40,1); % Highpass filter

hp=design(d); % Highpass filter object

x=filter(hp,y); % Filter applied to data

%Set Variables

NoOfSamples = 10;

Letters = {'zeki','ahmet','ceren','koray'}; % Samples that are in the Voice templates directory

% LPC parameters

NoOfLPCFilters = 5; % Setting number of LPC filters

% LPC Training for all letters

for ii = 1:size(Letters,2);
    ll = 1;
        for kk = 1:NoOfSamples            
            file_name = strcat(Letters(ii),int2str(kk),'.wav');
            Samples = audioread(char(file_name));
            zz = find(Samples) < max(Samples/3);%Threshold speech regions
            Samples(zz) = 0;
            zz = find(Samples);
            Speech_Region = Samples(zz)/norm(Samples(zz));            
            %lpccoeff(ii,ll,:) 
            lpccoeff(ii,ll,:) = lpc(Speech_Region,NoOfLPCFilters); 
            ll = ll + 1;
        end
end
% Prepare Gaussian distribution for LPC coeffs of all samples
tempStorage = zeros(1*NoOfSamples,NoOfLPCFilters);
tempStorage(:,:) = lpccoeff(1,:,2:end);
obj_A2 = gmdistribution.fit(tempStorage,1);
tempStorage(:,:) = lpccoeff(2,:,2:end);
obj_B2 = gmdistribution.fit(tempStorage,1);
tempStorage(:,:) = lpccoeff(3,:,2:end);
obj_C2 = gmdistribution.fit(tempStorage,1);
tempStorage(:,:) = lpccoeff(4,:,2:end);
obj_D2 = gmdistribution.fit(tempStorage,1);
%tempStorage(:,:) = lpccoeff(5,:,2:end);
%obj_E2 = gmdistribution.fit(tempStorage,1);


% Extract LPC for test data
    
Samples = x;
zz = find(Samples) < max(Samples/3);%Threshold speech regions
Samples(zz) = 0;
zz = find(Samples);
Speech_Region = Samples(zz);  
lpc_test = lpc(Speech_Region,NoOfLPCFilters);


% Classify LPC test data based on Mahanalobis distance

D2(1) = mahal(obj_A2,lpc_test(2:end));
D2(2) = mahal(obj_B2,lpc_test(2:end));
D2(3) = mahal(obj_C2,lpc_test(2:end));
D2(4) = mahal(obj_D2,lpc_test(2:end));
%D2(5) = mahal(obj_E2,lpc_test(2:end));
plot(x);

m2 = min(D2);
if m2==D2(1)
    disp('Zeki');
    %fprintf(s,'Zeki');
elseif m2==D2(2) 
    disp('Ahmet');
elseif m2==D2(3)
    disp('Ceren');
elseif m2==D2(4)
    disp('Koray'); 
end
end

if in == 'x'
   break;
end
w=w+1;
end        
    