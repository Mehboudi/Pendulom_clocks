%% Simulate trajectories.
% % If you have done it already, comment for further analysis
imin=1;
imax=100;%The number of simulations (After reaching the steady state)
w_c=120;
%T_c=120;
%n_c=1./(exp(w_c./T_c)-1);
n_c=1e-3;T_c=w_c/(log((n_c+1)/n_c));
iTmax=10;
n_hmax=20;
n_h_vec=linspace(n_c,n_hmax,iTmax);
figure
for iT=1:iTmax
    n_h=n_h_vec(1,iT);
    sub_folder_name=['n_h',num2str(iT)];
    mkdir(sub_folder_name)
    for ur=0:1
        if ur==0
            Factorisation;
            myVars = {"p1","p2","p3","na","re_ad_s12","im_ad_s12","na_p3","x_m","p_m", ...
                'x_m_vec','p_m_vec',"J_h",'Q_h','Q_h_f'};
            save([sub_folder_name,'/in_cond_n_h',num2str(iT)],myVars{:});
            subplot(4,5,iT);
            plot(x_m_vec,1i*p_m_vec);
            title('nh=',num2str(n_h));
            [iT iTmax]
        else
            for i1=imin:imax
                [i1,imax; iT, iTmax]
                Factorisation;
                tvec_dN1=jump_times;
                myVars2={"tvec_dN1","w_m","n_h","J_h","T_c",'Q_h','Q_h_f'};
                save([sub_folder_name,'/in_cond_n_h',num2str(iT),'traj',num2str(i1)],myVars2{:});
            end
        end
    end
end
%% 
% imin=1;
% imax=100;%The number of simulations (After reaching the steady state)
% w_c=4;
% T_c=1e-2;
% n_c=1./(exp(w_c./T_c)-1);
% iTmax=20;
% n_hmax=20;
% n_h_vec=linspace(n_c,n_hmax,iTmax);
% figure
% for iT=1:iTmax
%     n_h=n_h_vec(1,iT);
%     %sub_folder_name=['n_h',num2str(iT)];
%     %mkdir(sub_folder_name)
%     for ur=0:0
%         if ur==0
%             [iT, iTmax]
%             Factorisation;
%             subplot(4,5,iT);
%             plot(x_m_vec,1i*p_m_vec);
%             title('nh=',num2str(n_h));
%         else
%             for i1=imin:imax
%                 [i1,imax; iT, iTmax]
%                 Factorisation;
%                 tvec_dN1=jump_times;
%             end
%         end
%     end
% end
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
for iT=1:iTmax
    sub_folder_name=['n_h',num2str(iT)];
    dtj=[];
    muvec=zeros(1,imax);
    varvec=zeros(1,imax);
    for i1=imin:1:imax
        myVars = {"tvec_dN1",'w_m',"J_h"};
        load([sub_folder_name,'/in_cond_n_h',num2str(iT),'traj',num2str(i1)],myVars{:})
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
    end
    %res=mean(dtj);
    % res_stable=mean(dtj_stable)
    %std_2=std(dtj)^2
    % std_stable=std(dtj_stable)
    mu_(1,iT)=mean(muvec)
    var_(1,iT)=mean(varvec)%Note we take mean of the var over different rounds.
    N(1,iT)=mu_(1,iT).^2./var_(1,iT);
    % %%
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
plot(n_h_vec,N)
%%%HEAT CURRENT
Jhmean=mean(Jhmat,2,'omitnan');
Jhstd=std(Jhmat','omitnan');
T_h_vec=w_h./(log((1+n_h_vec)./n_h_vec));
ent_prod=w_h*Jhmean'.*(1./T_h_vec-1/T_c);
figure
fill([n_h_vec, flip(n_h_vec)], [Jhmean'+Jhstd, flip(Jhmean'-Jhstd)], [0.8 0.8 0.8])
hold on
plot(n_h_vec,Jhmean)
figure
semilogy(n_h_vec,ent_prod)
%Allan
% figure
% histogram(dtj_stable,bin)
%% Now, Take the ticks, and consider the dead-time of the detectors
%Detector_Filter;
% %-----------------
% %   Tick stats; Filter
% %-----------------
det_filt=1;
imin=100;
%imax=10;
dtj=[];
muvec=zeros(1,imax);
varvec=zeros(1,imax);
N=zeros(1,iTmax);
Qhfmat=zeros(iTmax,imax);
for iT=20:iTmax
    sub_folder_name=['n_h',num2str(iT)];
    for i1=imin:1:imax
        myVars = {"tvec_dN1",'w_m','Q_h_f'};
        load([sub_folder_name,'/in_cond_n_h',num2str(iT),'traj',num2str(i1)],myVars{:})
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
plot(n_h_vec,N)
%%%HEAT CURRENT
Qhfmean=mean(Qhfmat,2,'omitnan');
Qhfstd=std(Qhfmat','omitnan');
T_h_vec=w_h./(log((1+n_h_vec)./n_h_vec));
ent_prod=w_h*Qhfmean'.*(1./T_h_vec-1/T_c);
figure
plot(n_h_vec,Qhfmean)
figure
plot(n_h_vec,ent_prod)
%Allan
% figure
% histogram(dtj_stable,bin)