%% Simulate trajectories.
% % If you have done it already, comment for further analysis
imin=1;
imax=100;%The number of simulations (After reaching the steady state)
w_cold=120;w_hot=240;
%T_c=120;
%n_c=1./(exp(w_c./T_c)-1);
n_h=10;T_h=w_hot/(log((n_h+1)/n_h));
%iTmax=12;n_c_vec=[logspace(-5,0,iTmax/2),linspace(1,n_h,iTmax/2)];
iTmax=6;n_c_vec=[logspace(-1,0,iTmax),linspace(.11,1,iTmax)];
n_c_vec=unique(n_c_vec);n_c_vec=sort(n_c_vec);
iTmax=length(n_c_vec);
figure
for iT=1:iTmax
    n_c=n_c_vec(1,iT);
    sub_folder_name=['n_c',num2str(iT)];
    mkdir(sub_folder_name)
    for ur=0:1
        if ur==0
            Factorisation;
            myVars = {"p1","p2","p3","na","re_ad_s12","im_ad_s12","na_p3","x_m","p_m", ...
                'x_m_vec','p_m_vec','J_h','J_cold','J_cav','w_hot','w_cold','w_cav','n_c_vec'};
            save([sub_folder_name,'/in_cond_n_c',num2str(iT)],myVars{:});
            subplot(5,5,iT);
            plot(x_m_vec,1i*p_m_vec);
            title('nc=',num2str(n_c));
            [iT iTmax]
        else
            for i1=imin:imax
                [i1,imax; iT, iTmax]
                Factorisation;
                tvec_dN1=jump_times;
                myVars2={"tvec_dN1","w_m",'w_hot','w_cold','w_cav',"n_h", 'Q_h','Q_h_f',...
                    'J_h','J_cold','J_cav','n_c_vec'};
                save([sub_folder_name,'/in_cond_n_c',num2str(iT),'traj',num2str(i1)],myVars2{:});
            end
        end
    end
end
%% Load and Plot the asymptotic limit cycles
figure
myVars0={'n_c_vec'};
sub_folder_name='n_c1';
load([sub_folder_name,'/in_cond_n_c1','traj1'],myVars0{:});%Just pick the n_c_vec from the first available mat file
iTmax=length(n_c_vec);
for iT=1:iTmax
    n_c=n_c_vec(1,iT);
    sub_folder_name=['n_c',num2str(iT)];
    myVars = {'x_m_vec','p_m_vec'};
    load([sub_folder_name,'/in_cond_n_c',num2str(iT)],myVars{:})
    subplot(4,5,iT);
    plot(real(x_m_vec),real(1i*p_m_vec));
    title('nc=',num2str(n_c));
    [iT iTmax]
end

figure
myVars0={'n_c_vec'};
sub_folder_name='n_c1';
load([sub_folder_name,'/in_cond_n_c1'],myVars0{:});%Just pick the n_c_vec from the first available mat file
sTmax=length(n_c_vec);
J_hot_vec=zeros(1,iTmax);
J_cold_vec=zeros(1,iTmax);
J_cav_vec=zeros(1,iTmax);
for iT=1:iTmax
    n_c=n_c_vec(1,iT);
    sub_folder_name=['n_c',num2str(iT)];
    myVars = {'J_h','J_cold','J_cav','w_hot','w_cold','w_cav'};
    load([sub_folder_name,'/in_cond_n_c',num2str(iT)],myVars{:})
    J_hot_vec(1,iT)=J_h;
    J_cold_vec(1,iT)=J_cold;
    J_cav_vec(1,iT)=J_cav;
end
plot(n_c_vec,[-J_hot_vec/w_hot;J_cold_vec/w_cold;J_cav_vec/w_cav])
%% Load and analyze the data
% The standard plots
% imax=6;imin=imax;
% for i1=imin:1:imax
% load(['new_data_down_resloved_',num2str(i1)])
% figure
% plot(tvec_down,[t_p1_down;t_p2_down;t_p3_down;t_na_down])
% hold on
% %xline(tvec_dN1,'-k','FontSize',2,'HandleVisibility','off')
% %----
% figure
% hold on
% plot(tvec_down,[t_x_m_down;1i*t_p_m_down])
% %xline(tvec_dN1,'-k','FontSize',2,'HandleVisibility','off')
% %----
% figure
% plot(t_x_m_down,1i*t_p_m_down)
% end
% %-----------------
% %   Tick stats; No filter
% %-----------------
det_filt=0;
N=zeros(1,iTmax);
mu_=zeros(1,iTmax);
Var_=zeros(1,iTmax);
Jhmat=zeros(iTmax,imax);
Jcoldmat=zeros(iTmax,imax);
Jcavmat=zeros(iTmax,imax);
click_num=zeros(iTmax,imax);
%for iT=1:iTmax
for iT=40:45
    sub_folder_name=['n_c',num2str(iT)];
    dtj=[];
    muvec=zeros(1,imax);
    varvec=zeros(1,imax);
    for i1=imin:1:imax
        myVars = {"tvec_dN1",'w_m','w_hot','w_cold','w_cav','J_h','J_cold','J_cav','n_c_vec','Q_h','Q_h_f'};
        load([sub_folder_name,'/in_cond_n_c',num2str(iT),'traj',num2str(i1)],myVars{:})
        %Let's renormalise everything!
        tvec_dN1=tvec_dN1*w_m/pi;
        %%%%This line will be passed only if you want to filter (detector dead time)
        if det_filt==1
            Detector_Filter;
            tvec_dN1=tvec_dN1_I2(1:end);
        end
        %%%%Otherwise carryout as usual
        dtjump=[diff([0,tvec_dN1])];sdtj=length(dtjump);
        size(dtjump);
        dtj=[dtj,dtjump];
        muvec(1,i1)=mean(dtjump);
        varvec(1,i1)=std(dtjump)^2;
        %%%HEAT CURRENT
        Jhmat(iT,i1)=J_h;
        Jcoldmat(iT,i1)=J_cold;
        Jcavmat(iT,i1)=J_cav;
        click_num(iT,i1)=length(tvec_dN1);
        %%%Other currents
    end
    %res=mean(dtj);
    % res_stable=mean(dtj_stable)
    %std_2=std(dtj)^2
    % std_stable=std(dtj_stable)
    mu_(1,iT)=mean(muvec)
    var_(1,iT)=mean(varvec)%Note we take mean of the var over different rounds.
    N(1,iT)=mu_(1,iT).^2./var_(1,iT);
    % %%
    bin=200;
    figure
    % hold on
    histogram(dtj(2:end),bin)
    % Create xline
    xline([0 1 2]);
    tname=(['$\omega_m =$',num2str(w_m),';~~~$\mu=$',num2str(mu_),',~~$\sigma^2=$',num2str(var_),',~~$N=$',num2str(N)]);
    title(tname,'Interpreter','latex')
    % Create xlabel
    xlabel('$\omega_m t/\pi$','Interpreter','latex');
end
figure
plot(n_c_vec,mu_)
xlabel('$n_c$','Interpreter','latex')
ylabel('$\mu$','Interpreter','latex')
title('Resolution')
grid on
figure
plot(n_c_vec,N)
xlabel('$n_c$','Interpreter','latex')
ylabel('$N$','Interpreter','latex')
title('Accuracy')
grid on
%%%HEAT CURRENT
Jhmean=mean(Jhmat,2,'omitnan');%The heat current (instantaniuous)
Jcoldmean=mean(Jcoldmat,2,'omitnan');%This is collective heat instead of the instantanious one
Jcavmean=mean(Jcavmat,2,'omitnan');
Q_click=-w_hot*mean(click_num,2,'omitnan');%This is the dissipated heat, with some approximation valid for low n_c (for some reason).
figure
plot(n_c_vec,[Jhmean/w_hot,Jcoldmean/w_cold,Jcavmean/w_cav])
xlabel('$n_c$','Interpreter','latex')
ylabel('$J_\alpha/\omega_\alpha$','Interpreter','latex')
title('Heat current to frequency rate')
legend('$J_{\rm hot}/\omega_{\rm hot}$','$J_{\rm cold}/\omega_{\rm cold}$' ...
    ,'$J_{\rm cav}/\Omega_{\rm cav}$','interpreter','latex')
grid on
%%%%%%%%%%%%%%%
Jhstd=std(Jhmat','omitnan');
T_c_vec=w_cold./(log((1+n_c_vec)./n_c_vec));
ent_prod=w_hot*Jhmean'.*(1./T_h-1./T_c_vec);
figure
hold on
fill([n_c_vec, flip(n_c_vec)], [Jhmean'+Jhstd, flip(Jhmean'-Jhstd)], [0.8 0.8 0.8])
plot(n_c_vec,Jhmean)
xlabel('$n_c$','Interpreter','latex')
ylabel('$J_h$','Interpreter','latex')
title('Heat current from trajectories')
grid on
figure
plot(n_c_vec,ent_prod)
xlabel('$n_c$','Interpreter','latex')
ylabel('Ent. Prod.')
title('Entropy Production')
grid on
%Allan
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
muvec=zeros(1,imax);
varvec=zeros(1,imax);
N=zeros(1,iTmax);
Qhfmat=zeros(iTmax,imax);
for iT=1:iTmax
    sub_folder_name=['n_c',num2str(iT)];
    for i1=imin:1:imax
        myVars = {"tvec_dN1",'w_m','w_hot','w_cold','w_cav','Q_h_f','n_c_vec'};
        load([sub_folder_name,'/in_cond_n_c',num2str(iT),'traj',num2str(i1)],myVars{:})
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
        dtj=[dtj,dtjump];
        muvec(1,i1)=mean(dtjump(2:end));
        varvec(1,i1)=std(dtjump(2:end))^2;
        [i1 imax;iT iTmax]
    end
    dtj=dtj(2:end);
    % res=mean(dtj)
    % res_stable=mean(dtj_stable)
    % std_=std(dtj)
    % std_stable=std(dtj_stable)
    mu_=mean(muvec)
    var_=mean(varvec)
    N(1,iT)=mu_.^2./var_
    %%%Total HEAT including f
    Qhfmat(iT,i1)=Q_h_f;
    %%%
    % bin=200;
    % figure
    % hold on
    % histogram(dtj(2:end),bin)
    % % Create xline
    % xline([0 1 2]);
    % tname=(['$\omega_m =$',num2str(w_m),';~~~$\mu=$',num2str(mu_),',~~$\sigma^2=$',num2str(var_),',~~$N=$',num2str(N)]);
    % title(tname,'Interpreter','latex')
    % % Create xlabel
    % xlabel('$\omega_m t/\pi$','Interpreter','latex');
end
figure
plot(n_c_vec,N)
%%%HEAT CURRENT
Qhfmean=mean(Qhfmat,2,'omitnan');
Qhfstd=std(Qhfmat','omitnan');
T_c_vec=w_cold./(log((1+n_c_vec)./n_c_vec));
ent_prod=w_hot*Qhfmean'.*(1./T_h-1/T_c_vec);
figure
plot(n_c_vec,Qhfmean)
figure
plot(n_c_vec,ent_prod)
%Allan
% figure
% histogram(dtj_stable,bin)