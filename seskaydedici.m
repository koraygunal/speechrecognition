% Record your voice for 5 seconds.

i=1; %iterator variable

while i<=10 % Recording 10 samples for a single word 

recObj = audiorecorder; % Initializing recoder object

in = input('Press Enter when ready ...','s');

disp(i);

disp('Start')

recordblocking(recObj, 1.2); % Recording speech

disp('Stop');

y = getaudiodata(recObj); % Converting the recorded speech into array

d=fdesign.highpass('Fst,Fp,Ast,Ap',8700/16000,10000/16000,40,1);% Highpass filter to remove ambient noise 

hp=design(d); % Creating filter object

x=filter(hp,y); % Applying the filter

plot(x);

fn=strcat('koray',int2str(i),'.wav'); % Creating file name to save data

audiowrite(char(fn),x,8000); % Saving recorded data to .wav file

i=i+1; % incrementing iterator
    

end
