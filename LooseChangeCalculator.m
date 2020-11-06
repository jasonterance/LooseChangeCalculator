% Jason Moran
%ENGR 114O
%Final Project
clear;
clc;
clf;
fprintf('Welcome to the Loose Change Calculator \n')
fprintf('Instructions: \n')
fprintf('All you need is a clear picture of your change spread out(No half dollars) \n') 
fprintf('Please make sure there are no other round objects in the image \n')
fprintf('Please select a solid background for the image \n')
I = input('Please type the full name of an image file in the current folder.\n'...
,'s');
%error statement
Z = 1; 
while Z
    try
Image = imread(I);
Z = 0;
catch 
    warning('Image not found');
    pause(1);
    I = input('Please try again.\n','s');
    end   
end
%asks for biggest coin so we know the scale (for later)
fprintf('What is the biggest coin (in regards to size) in the picture? \n')
BigCoin = input('Enter 1 for a quarter, 2 for a nickel, 3 for a penny, or 4 for a dime. \n');
[Scale] =  ScaleFinder(BigCoin);
b = rgb2gray(Image); %converts to grayscale
level = graythresh(b);
bw = imbinarize(b,level);%converts to binary image
bw2 = imfill(bw,'holes'); %fills holes in each identified region
bw3 = bwareaopen(bw2, 1000);%deletes small images
figure(1)
imshow(bw3); hold on;
[B,L,n,A] = bwboundaries(bw3); %creates boundary aorund each region
%manipulate data about center of each region
c = regionprops(bw3,'Centroid');
centroids = cat(1,c.Centroid);
Cx = centroids(:,1);
Cy = centroids(:,2);
%manipulate data about area of each region
area1 = regionprops(bw3, 'Area'); 
area = cat(1,area1.Area);
%manipulate data about how circular each region is
circularity = regionprops(bw3,'Circularity');
circly = cat(1,circularity.Circularity);
for k=1:length(B), %plots center of every region identified clue
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);
 plot(Cx,Cy,'b*')
end
Quarters = 0;
Nickels = 0;
Dimes = 0;
Pennies = 0;
for z = 1:length(Cx) %neglects areas that are not circles
    if circly(z) < .45
    area(z) = 0;
    end
end
AreaMax =max(area);
Y = AreaMax/ Scale;
%labels and counts each region as quarter, nickel, dime, penny or NA
%coins are labels red; other objects are labeled blue
for t = 1:length(B)
    if circly(t) > .45
        plot(Cx(t),Cy(t),'r*')
        if area(t) > ((.72 * Y)-6000) & area(t) < ((.72 * Y)+4000)
            text(Cx(t),Cy(t),'Q','Color','red');
            Quarters = Quarters +1;
        elseif area(t) > ((.55 * Y)-6000) & area(t) < ((.55 * Y)+4000)
            text(Cx(t),Cy(t),'N','Color','red');
            Nickels = Nickels +1;
        elseif area(t) > ((.44 * Y)-6000) & area(t) < ((.44 * Y)+4000)
            text(Cx(t),Cy(t),'P','Color','red');
            Pennies = Pennies +1;
        elseif area(t) > ((.39 * Y)-6000) & area(t) < ((.39 * Y)+1000)
            text(Cx(t),Cy(t),'D','Color','red');
            Dimes = Dimes +1; 
        end
    else
        text(Cx(t),Cy(t),'NA','FontSize',7,'Color','blue');
    end
end
numcoins = Quarters + Pennies + Nickels + Dimes; %adds number of coins all together
change = (Quarters *.25) + (Dimes *.10) +...
    (Pennies *.01) + (Nickels * .05); %calculates total amount of change
weight =  (Quarters * 5.67) + (Dimes * 2.268) +...
    (Pennies * 2.5) + (Nickels * 5);%calculates total weight of change
if numcoins == 0
     fprintf('No coins were detected. Please try again')
else
    %prints stats on coins found
    fprintf('You have %3.0f quarters,%3.0f dimes,%3.0f nickels,and %3.0f pennies. \n',...
    Quarters,Dimes,Nickels, Pennies)
    fprintf('You have a total of %3.0f coins. \n', numcoins)
    fprintf('You have %5.2f dollars in coins. \n', change)
    fprintf('The coins weigh %4.6f grams. \n', weight) 
end
%if program missed a coin enter here
undetected = input('Count total change in your image that went undetected \n');
%gives option to count cash
fprintf('Do you want to see how much cash you have, too? \n')
yesorno = input(' Type Y for Yes or N for No. \n','s');
if yesorno == 'Y'
    prompt = {'Number of 50 Cent Coins','Number of 1 Dollar Bills',...
        'Number of 5 Dollar Bills','Number of 10 Dollar Bills',...
        'Number of 20 Dollar Bills','Number of 50 Dollar Bills',... 
        'Number of 100 Dollar Bills'};
       Numbills = inputdlg(prompt, 'Cash Calculator');
       halves = str2num(Numbills{1});
       singles = str2num(Numbills{2});
       fives = str2num(Numbills{3});
       tens = str2num(Numbills{4});
       twenties = str2num(Numbills{5});
       fifties = str2num(Numbills{6});
       benjis = str2num(Numbills{7});
       cash = (singles)+(fives*5)+...
           (tens*10)+(twenties*20)+(fifties*50)+(benjis*100);
       total = cash + change + (halves*.50) + undetected;
        fprintf('You have %5.2f dollars in cash and %5.2f dollars total \n',...
            cash, total)
else
    fprintf('I''ll take that as a no \n')
    total = change + undetected;
    fprintf('You have %5.2f in change \n',total)
    pause(3)
end
 %Tells you one random fun fact or piece of advice
funfact = randi(3,1);
if total < 1.00
    fprintf('Not much you can do with that in today''s economy \N')
elseif funfact == 1
    toiletpaper = total/.84;
    fprintf('Fun Fact: You can afford about %3.0f rolls of toilet paper\n',toiletpaper)
elseif funfact == 2
    CD = total * (1.018);
    fprintf('Fun Fact: Invest in a Certificate of Deposit with an 1.8 percent APY\n ') 
    fprintf(' Next year, you will have %5.2f dollars\n',CD)
    fprintf('For more information, visit Investopedia at the link below\n')
    url = 'https://www.investopedia.com/';
    sitename = 'Investopedia';
    fprintf('<a href = "%s">%s</a>\n',url,sitename)
elseif funfact == 3
    fprintf('"Money and power don''t change you, they just further expose your true self."-Jay Z\n')
end
%end
fprintf('"Money is just a barbell racked with the weight of your own choosing"-Unknown\n')
pause(3)
disp('The End')
