%% Simulate trajectories.
% % If you have done it already, comment for further analysis
imax=1;
for i1=1:1:imax
    [i1,imax]
    Factorisation;
    size_resample;
end
%% Load and analyze the data
% The standard plots
% imax=6;imin=imax;
% for i1=imin:1:imax
%     load(['new_data_down_resloved_',num2str(i1)])
%     figure
%     plot(tvec_down,[t_p1_down;t_p2_down;t_p3_down])
%     hold on
%     xline(tvec_dN1,'-k','FontSize',2,'HandleVisibility','off')
%     %----
%     figure
%     hold on
%     plot(tvec_down,[t_x_m_down;1i*t_p_m_down])
%     xline(tvec_dN1,'-k','FontSize',2,'HandleVisibility','off')
%     %----
%     figure
%     plot(t_x_m_down,1i*t_p_m_down)
% end
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
        Detector_Filter;tvec_dN1=tvec_dN1_I2(1:end);
    end
    %%%%Otherwise carryout as usual
    dtjump=[diff([0,tvec_dN1])];sdtj=length(dtjump);
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
        Detector_Filter;tvec_dN1=tvec_dN1_I2(1:end);
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
%% Allan Variance
%% UPDATE: Run "Allan" insterad!
% avar=cell(1,10);
% tau=cell(1,10);
% for ii=1:10
% imin=ii;
% imax=ii;
% dtj=[];
% dtj_stable=[];
% for i1=imin:1:imax
%     myVars = {"tvec_dN1"};
%     load(['new_data_down_resloved_',num2str(i1)],myVars{:})
%     %%%%This line will be passed only if you want to filter (detector dead time)
%     %%%The detector parameters are set on the other code, check it out
%     %%%there.
%     if det_filt==1
%         Detector_Filter;tvec_dN1=tvec_dN1_I2(1:end);
%     end
%     %%%%Otherwise carryout as usual
%     dtjump=[diff([0,tvec_dN1])];sdtj=length(dtjump);
%     dtjump_stable=dtjump(floor(sdtj/2):end);
%     dtj=[dtj,dtjump];
%     dtj_stable=[dtj_stable,dtjump_stable];
% end
% [avar{1,ii},tau{1,ii}]=allanvar(dtj','octave',pi);
% end
% stau=length(tau{1,1});
% for ii=2:10
%     if stau>length(tau{1,ii})
%         stau=length(tau{1,ii});
%     end
% end
% avarmat=zeros(10,stau);
% for ii=1:10
%     dummy=avar{1,ii};
%     avarmat(ii,:)=dummy(1:stau);
% end
% tau=tau{1,1}(1:stau);
% avarav=mean(avarmat,1);
% figure
% hold on
% loglog(tau*w_m/pi,sqrt(avarmat),'bl:','LineWidth',.1,'HandleVisibility','off')
% loglog(tau*w_m/pi,sqrt(avarav),'b-','LineWidth',2)
% xlabel('Averaging Time (\tau\omega_m/\pi)')
% ylabel('\sigma')
% title('Allan Deviation')
% grid on
% %%%%%%
% %According to Mitchison's paper, the Allan Variance at long times should
% %converge to avar-->mu/(NT), where N=mu^2/var. with mu and var being the
% %usual mean and variance. Let's check this for our signal
% %mu=mean(dtj);var=std(dtj)^2;
% avar_asym=mu./(tau*mu^2/var);
% loglog(tau*w_m/pi,sqrt(avar_asym),'r--','LineWidth',2)
% legend('$\sigma_A$','$\sigma_{\rm asym}$','interpreter','latex')
