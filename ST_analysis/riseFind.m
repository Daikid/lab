function rise = riseFind(p,down)
%%
%p インパルス応答
%down 何dB落ちを直接音到来とみなすか

%rise 直接音到来時刻のpのサンプル番号

%%

idx = find(abs(p) == max(abs(p))); %音圧のmax値のindexを取得
p_chk = 20*log10(abs(p(1:idx)));

rise = (p_chk < (p_chk(end) - down));
%rise = (p_chk < (p(idx) - down));でも同じ
%rise(idx-10:idx);
rise = find(rise(1:end-1) - rise(2:end) == 1,1,'first'); %直接音のサンプル番号

%{
clc
close all
clear all

%%
file_pass = "./../IRData/HallData/Venue_B/";
file_type = ".wav";
file_name = "Venue_B_S01";
subject = file_pass + file_name + file_type;
data = audioread(subject);
p = data(:,1);


%%
dur = 0.1;
down = 30;
fs = 48000;

%%
idx = find(abs(p) == max(abs(p))); %音圧のmax値のindexを取得
p_chk = 20*log10(abs(p(1:idx)));

rise = (p_chk < (p_chk(end) - down));
%rise = (p_chk < (p(idx) - down));でも同じ
rise(idx-10:idx)
rise = find(rise(1:end-1) - rise(2:end) == 1,1,'first'); %直接音のサンプル番号
idx
rise
%}