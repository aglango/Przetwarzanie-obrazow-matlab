close all; clear all; clc;
a=imread('1N00.jpg');
b=imread('NX00.jpg');
[y x] = size(a(:,:,1));
SE=strel('disk',2);
SE2=strel('disk',10);
SE3=strel('disk',5);

% Glaukonit
glaukonit_temp=zeros(y,x);
glaukonit=zeros(y,x);
for ky=1:y
        for kx=1:x
            if ( a(ky,kx,1)>160  & a(ky,kx,2)>150 & a(ky,kx,2)<230 & a(ky,kx,3)>100 & a(ky,kx,3)<200 & a(ky,kx,3)+30<a(ky,kx,2))
                glaukonit_temp(ky,kx)=1;
            end
        end
end
for ky=1:y
    for kx=1:x
        if (b(ky,kx,1)<80 & b(ky,kx,2)+10>b(ky,kx,1)*2 & b(ky,kx,3)+10>b(ky,kx,1) & b(ky,kx,2)>20 )
                glaukonit_temp(ky,kx)=1;
        end
    end
end
glaukonit_temp=imerode(glaukonit_temp,SE);
glaukonit_temp=bwmorph(glaukonit_temp,'clean',100);
glaukonit_temp=imdilate(glaukonit_temp,SE2);
glaukonit_temp=imfill(glaukonit_temp,'holes');
imopen(glaukonit_temp,SE2);
aseg=bwlabel(glaukonit_temp);
region=regionprops(aseg,'all');
N=max(aseg(:));
pole=zeros(N);
pole_glauk=0;
for i=1:N
    temp=(aseg==i);
    pole(i)=bwarea(temp);
    if pole(i)>2000;
        glaukonit=glaukonit | temp;
        pole_glauk = pole_glauk + pole(i);
    end
end     

% Kwarc
kwarc_temp= (a(:,:,3)>a(:,:,2) & a(:,:,3)>a(:,:,1)  | (a(:,:,1)>100 & a(:,:,2)>100 & a(:,:,3)>100));
kwarc_temp=bwareaopen(kwarc_temp,20);
kwarc_temp=bwmorph(kwarc_temp,'bridge');
for ky=1:y
    for kx=1:x
        if glaukonit(ky,kx) == 1
            kwarc_temp(ky,kx)=0;
        end
    end
end
kwarc_temp=imerode(kwarc_temp,SE);
kwarc_temp=bwmorph(kwarc_temp,'clean');
kwarc_temp=imfill(kwarc_temp,'holes');
aseg=bwlabel(kwarc_temp);
region=regionprops(aseg,'all');
N=max(aseg(:));
pole=zeros(N);
pole_kwarc=0;
kwarc=zeros(y,x);
for i=1:N
    temp=(aseg==i);
    pole(i)=bwarea(temp);
    if pole(i)>2000;
        kwarc=kwarc | temp;
        pole_kwarc = pole_kwarc + pole(i);
    end
end     

% Miki
c=imrotate(imread('NX30.jpg'),-30,'crop');
miki_temp= c(:,:,1)>100 & c(:,:,3)<100;
miki_temp=imclose(miki_temp,SE3); 
miki_temp=imfill(miki_temp,'holes');
for ky=1:y
    for kx=1:x
        if glaukonit(ky,kx) == 1 | kwarc(ky,kx) == 1
            miki_temp(ky,kx)=0;
        end
    end
end
aseg=bwlabel(miki_temp);
region=regionprops(aseg,'all');
N=max(aseg(:));
pole=zeros(N);
pole_miki=0;
miki=zeros(y,x);
for i=1:N
    temp=(aseg==i);
    pole(i)=bwarea(temp);
    if pole(i)>2000;
        miki=miki | temp;
        pole_miki = pole_miki + pole(i);
    end
end     

% Minera³y nieprzezroczyste
mn_temp= a(:,:,1) & a(:,:,2) & a(:,:,3) < 50;
mn_temp=imclose(mn_temp,SE);
mn_temp=imopen(mn_temp,SE3); 
mn_temp=imfill(mn_temp,'holes');
for ky=1:y
    for kx=1:x
        if glaukonit(ky,kx) == 1 | kwarc(ky,kx) == 1 | miki(ky,kx) == 1
            mn_temp(ky,kx)=0;
        end
    end
end
aseg=bwlabel(mn_temp);
region=regionprops(aseg,'all');
N=max(aseg(:));
pole=zeros(N);
pole_mn=0;
mn=zeros(y,x);
for i=1:N
    temp=(aseg==i);
    pole(i)=bwarea(temp);
    if pole(i)>2000;
        mn=mn | temp;
        pole_mn = pole_mn + pole(i);
    end
end     

% Pory
pory_temp=ones(y,x);
pory_temp=imopen(pory_temp,SE3);
for ky=1:y
    for kx=1:x
        if glaukonit(ky,kx) == 1 | kwarc(ky,kx) == 1 | miki(ky,kx) == 1 | mn(ky,kx)
            pory_temp(ky,kx)=0;
        end
    end
end
aseg=bwlabel(pory_temp);
region=regionprops(aseg,'all');
N=max(aseg(:));
pole=zeros(N);
pole_pory=0;
pory=zeros(y,x);
for i=1:N
    temp=(aseg==i);
    pole(i)=bwarea(temp);
    if pole(i)>2000;
        pory = pory | temp;
        pole_pory = pole_pory + pole(i);
    end
end     

% Pola powierzchni w mm2
cale=x*y;
mm2=1870*1870;
pole_cale=cale/mm2
pole_glauk=pole_glauk/mm2
pole_kwarc=pole_kwarc/mm2
pole_miki=pole_miki/mm2
pole_mn=pole_mn/mm2
pole_pory=pole_pory/mm2

% Procenty
ppole_glauk=(pole_glauk/pole_cale)*100
ppole_kwarc=(pole_kwarc/pole_cale)*100
ppole_miki=(pole_miki/pole_cale)*100
ppole_mn=(pole_mn/pole_cale)*100
ppole_pory=(pole_pory/pole_cale)*100

% Obrazy
subplot(241), imshow(a);
subplot(242), imshow(b);
subplot(243), imshow(c);
subplot(244), imshow(glaukonit);
subplot(245), imshow(kwarc);
subplot(246), imshow(miki);
subplot(247), imshow(mn);
subplot(248), imshow(pory);


