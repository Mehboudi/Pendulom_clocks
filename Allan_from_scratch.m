xt=tvec_dN1;
t_max=max(xt);
%%
%min number of devisions, 2;
tauvec=0:floor(log2(t_max/2));
%tauvec=linspace(-5,log2(10),30);
tauvec=2.^floor(tauvec);
stau_=length(tauvec);
allvar=zeros(1,stau_);
for itau=1:stau_
    tau_=tauvec(1,itau);
    nmax=floor(t_max/tau_);
    yvec=zeros(1,nmax-1);
    for n=1:nmax-1
        xnm1=sum(xt<=(n-1)*tau_);
        xn=sum(xt<=n*tau_);
        xnp1=sum(xt<=(n+1)*tau_);
        yvec(1,n)=(xnp1-2*xn+xnm1)^2;
    end
    allvar(1,itau)=mean(yvec)/(2*tau_^2);
end