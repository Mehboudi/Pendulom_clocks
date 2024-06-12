%% Simulate trajectories.
% % If you have done it already, comment for further analysis
imax=10;
for i1=2:1:imax
    [i1,imax]
    Factorisation;
    tvec_dN1=jump_times;
    fname=(['new_data_down_resloved_',num2str(i1)]);
    save(fname)
end
%%
% %-----------------
% %   Tick stats; No filter
% %-----------------
det_filt=0;
imin=1;
%imax=10;
dtj=[];
dtj_stable=[];
muvec=zeros(1,imax);
varvec=zeros(1,imax);
for i1=imin:1:imax
    myVars = {"tvec_dN1",'w_m'};
    load(['new_data_down_resloved_',num2str(i1)],myVars{:})
    %Let's renormalise everything!
    tvec_dN1=tvec_dN1*w_m/pi;
    %%%%This line will be passed only if you want to filter (detector dead time)
    if det_filt==1
        Detector_Filter;
        tvec_dN1=tvec_dN1_I2(1:end);
    end
    %%%%Otherwise carryout as usual
    dtjump=[diff([0,tvec_dN1])];sdtj=length(dtjump)
    size(dtjump)
    dtjump_stable=dtjump(floor(sdtj/2):end);
    dtj=[dtj,dtjump];
    dtj_stable=[dtj_stable,dtjump_stable];
    muvec(1,i1)=mean(dtjump);
    varvec(1,i1)=std(dtjump)^2;
end
%res=mean(dtj);
% res_stable=mean(dtj_stable)
%std_2=std(dtj)^2
% std_stable=std(dtj_stable)
mu_=mean(muvec)
var_=mean(varvec)%Note we take mean of the var over different rounds. 
N=mu_.^2./var_
%% 
bin=200;
figure
hold on
histogram(dtj,bin)
% Create xline
xline([0 1 2]);
tname=(['$\omega_m =$',num2str(w_m),';~~~$\mu=$',num2str(mu_),',~~$\sigma^2=$',num2str(var_),',~~$N=$',num2str(N)]);
title(tname,'Interpreter','latex')
% Create xlabel
xlabel('$\omega_m t/\pi$','Interpreter','latex');
Allan
% figure
% histogram(dtj_stable,bin)
%% Now, Take the ticks, and consider the dead-time of the detectors
%Detector_Filter;
% %-----------------
% %   Tick stats; Filter
% %-----------------
det_filt=1;
imin=1;
%imax=10;
dtj=[];
dtj_stable=[];
muvec=zeros(1,imax);
varvec=zeros(1,imax);
for i1=imin:1:imax
    myVars = {"tvec_dN1",'w_m'};
    load(['new_data_down_resloved_',num2str(i1)],myVars{:})
    %%%%This line will be passed only if you want to filter (detector dead time)
    %%%The detector parameters are set on the other code, check it out
    %%%there.
    if det_filt==1
        Detector_Filter;
        tvec_dN1=tvec_dN1_I2(1:end);
    end
    %Let's renormalise everything!
    tvec_dN1=tvec_dN1*w_m/pi;
    %%%%Otherwise carryout as usual
    dtjump=[diff([0,tvec_dN1])];sdtj=length(dtjump);
    dtjump_stable=dtjump(floor(sdtj/2):end);
    dtj=[dtj,dtjump];
    dtj_stable=[dtj_stable,dtjump_stable];
    muvec(1,i1)=mean(dtjump);
    varvec(1,i1)=std(dtjump)^2;
end
% res=mean(dtj)
% res_stable=mean(dtj_stable)
% std_=std(dtj)
% std_stable=std(dtj_stable)
mu_=mean(muvec)
var_=mean(varvec)
N=mu_.^2./var_
%% 
bin=200;
figure
hold on
histogram(dtj,bin)
% Create xline
xline([0 1 2]);
tname=(['$\omega_m =$',num2str(w_m),';~~~$\mu=$',num2str(mu_),',~~$\sigma^2=$',num2str(var_),',~~$N=$',num2str(N)]);
title(tname,'Interpreter','latex')
% Create xlabel
xlabel('$\omega_m t/\pi$','Interpreter','latex');
Allan
% figure
% histogram(dtj_stable,bin)