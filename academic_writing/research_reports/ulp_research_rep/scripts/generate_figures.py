"""Reproducible English-language figures for the ULP research report.

Figures 01-04 reconstruct the experimental displays provided as Plotly HTML
(the numerical experiments are computed again in NumPy; no network access).
Figures 05-08 follow the demonstrations and validation figures supplied in
Rocha's research manuscript and the accompanying book draft.
"""
from pathlib import Path
import math
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, LogNorm
from matplotlib.ticker import MaxNLocator

HERE=Path(__file__).resolve().parent.parent
OUT=HERE/'figs'
OUT.mkdir(parents=True,exist_ok=True)
plt.rcParams.update({'font.size':9,'figure.dpi':125,'savefig.dpi':210,
                    'axes.grid':True, 'grid.alpha':.20,
                    'axes.spines.right':False,'axes.spines.top':False})
C1='#2367A6';C2='#DD8A29';C3='#2C977F';C4='#B85751'

def evaluate(x,c,dtype=np.float64):
    # Compute and reuse exactly the same value of y on both sides.
    xv=np.asarray(x,dtype=dtype)
    cv=dtype(c)
    y=np.power(xv,10,dtype=dtype)
    return (y+cv)-y, y

def v2(c,dtype=np.float64):
    _,p=(None, 53 if dtype is np.float64 else 24)
    f,e=np.frexp(dtype(c)); m=int(float(f)*(2**p))
    t=(m&-m).bit_length()-1
    return e-p+t

def theory(c,dtype=np.float64):
    p=53 if dtype is np.float64 else 24
    c=float(dtype(c));nu=v2(c,dtype); lam=math.frexp(c)[1]-1
    return 2**((p+nu)/10),2**((p+1+lam)/10),lam-nu+1

def save(fig,name):
    fig.savefig(OUT/name,bbox_inches='tight',facecolor='white')
    plt.close(fig)

# 01: ULP jumps, as illustrated by the first experiment and the report.
x=np.linspace(12,65,2800)
y=np.power(x,10);u=np.nextafter(y,np.inf)-y
fig,ax=plt.subplots(figsize=(9.0,3.7))
ax.step(x,np.log2(u),where='mid',color=C1,lw=1.7)
ax.axhline(0,color=C4,linestyle='--',linewidth=1,label='ULP = 1')
ax.axvline(2**(53/10),color=C2,linestyle=':',lw=1.4,label=r'$x=2^{53/10}\approx39.40$')
ax.set(xlabel=r'$x$',ylabel=r'$\log_2(\mathrm{ULP}(x^{10}))$',title='Binary64 spacing grows in discrete binades')
ax.legend(loc='upper left',fontsize=8)
save(fig,'01_ulp_staircase.png')

# 02: Exact tally for k=1,...,20 and integer x=2,...,40 (source notebook).
xx=np.arange(2,41)
ks=np.arange(1,21)
state=np.empty((len(ks),len(xx)),int)
counts={0:0,1:0,2:0,3:0}
for ki,k in enumerate(ks):
    c=2.0**(-int(k))
    for xi,xv in enumerate(xx):
        r,y=evaluate(float(xv),c)
        u=np.nextafter(y,np.inf)-y
        if r==c: z=3
        elif c==u/2 and r==0: z=1
        elif c==u/2 and r==2*c: z=2
        elif r==0: z=0
        else: raise ValueError((xv,k,r,u))
        state[ki,xi]=z;counts[z]+=1
fig,ax=plt.subplots(figsize=(10,4.4))
cmap=ListedColormap([C4,C2,'#8572AB',C3])
ax.imshow(state,origin='upper',aspect='auto',interpolation='nearest',cmap=cmap,vmin=-.5,vmax=3.5,extent=[1.5,40.5,20.5,.5])
ax.set_xticks(range(2,41,2));ax.set_yticks(range(2,21,2))
ax.set(xlabel=r'$x$ (integer)',ylabel=r'$k$ in $c=2^{-k}$',title='Power-of-two increments: preserved, tied, or absorbed')
from matplotlib.patches import Patch
handles=[Patch(fc=C3,label=f'Preserved ({counts[3]})'),Patch(fc=C4,label=f'Absorbed ({counts[0]})'),Patch(fc=C2,label=f'Tie to zero ({counts[1]})'),Patch(fc='#8572AB',label=f'Tie upward ({counts[2]})')]
ax.legend(handles=handles,ncol=2,loc='upper right',fontsize=8,framealpha=.94)
save(fig,'02_power_two_map.png')
print('Power-of-two counts:',counts,'total=',sum(counts.values()))

# 03: continuous curves from the second user-supplied Plotly figure.
fig,axs=plt.subplots(2,2,figsize=(10.2,6.0),sharex=False)
for ax,k in zip(axs.ravel(),[1,3,6,10]):
    c=2.0**(-k);x1,x2,L=theory(c)
    xx=np.linspace(max(8,x1-4),min(44,x2+4),11500)
    r,_=evaluate(xx,c)
    ax.plot(xx,r,'.',color=C1,markersize=1.0,rasterized=True)
    ax.axhline(c,ls='--',c=C4,lw=1,label='Exact value')
    ax.axvspan(x1,x2,color=C2,alpha=.18,label='Tie binade')
    ax.set(xlabel=r'$x$',ylabel=r'$f(x)$',title=rf'$c=2^{{-{k}}}$')
fig.tight_layout();save(fig,'03_power_two_curves.png')

# 04: odd integer curves corresponding to the user-supplied HTML.
fig,axs=plt.subplots(2,2,figsize=(10.2,6.4))
for ax,c in zip(axs.ravel(),[3,5,11,21]):
    x1,x2,L=theory(c);x=np.linspace(x1-1.3,x2+2,13500)
    z,_=evaluate(x,c)
    ax.scatter(x,z,c=C1,s=.45,rasterized=True)
    ax.axhline(c,c=C4,lw=1,ls='--')
    ax.axvspan(x1,2**(54/10),color=C2,alpha=.18)
    ax.axvline(x2,c=C3,lw=1.1,ls=':')
    ax.set(xlabel=r'$x$',ylabel=r'$f(x)$',title=f'Odd integer c = {c} (L = {L})')
fig.tight_layout();save(fig,'04_odd_integer_curves.png')

# 05: odd integers (1--255) versus x heatmap, based on the supplied research manuscript.
cs=np.arange(1,256,2,dtype=np.float64)
xs=np.linspace(36,82,1900)
err=np.empty((len(cs),len(xs)),float)
for i,c in enumerate(cs):
    z,_=evaluate(xs,c);err[i]=np.abs(z-c)/c
# Separate exact/no-error whites by forcing a small positive floor only on nonzero entries.
err=np.ma.masked_where(err==0,err)
fig,ax=plt.subplots(figsize=(10.2,4.5))
cmap=plt.get_cmap('magma_r').copy();cmap.set_bad('white')
im=ax.imshow(err,extent=[xs.min(),xs.max(),cs.max()+1,cs.min()-1],aspect='auto',cmap=cmap,norm=LogNorm(vmin=1e-3,vmax=1))
xc=[theory(c)[1] for c in cs]
ax.step(xc,cs,where='mid',lw=1.6,c=C3,label='Predicted onset of total absorption')
ax.axvline(2**(53/10),c=C1,lw=1.0,ls='--',label='Common inexactness threshold')
ax.set(xlabel=r'$x$',ylabel='Odd integer c',title='Relative error and absorption boundary in binary64')
fig.colorbar(im,ax=ax,pad=.015,label=r'$|f(x)-c|/c$ (white means exact)')
ax.legend(loc='upper left',fontsize=8,framealpha=.95)
save(fig,'05_odd_integer_heatmap.png')

# 06: fractions, including user-provided reciprocal family and book's dyadic examples.
fig,axs=plt.subplots(2,2,figsize=(10.4,6.7))
for ax,(c,label,is_non) in zip(axs.ravel(),[(.75,r'$c=3/4$',False),(5/16,r'$c=5/16$',False),(.1,r'$c=0.1$',True),(1/3,r'$c=1/3$',True)]):
    x1,x2,L=theory(c)
    x=np.linspace(max(.3,x1*.7 if is_non else x1-1.5),x2+1.5,24000)
    z,_=evaluate(x,c);r=(z-c)/c
    ax.axvspan(x1,x2,color=C2,alpha=.15)
    ax.axvline(x1,c=C2,lw=1,ls=':')
    ax.axvline(x2,c=C4,lw=1,ls=':')
    if is_non:
        nz=np.abs(r)>0
        ax.scatter(x[nz],np.abs(r[nz]),c=np.where(r[nz]>0,C1,C4),s=.5,rasterized=True)
        ax.set_yscale('log');ax.set_ylim(1e-16,2)
        ax.set_ylabel(r'$|f-c|/c$ (log scale)')
    else:
        ax.scatter(x,r,c=C1,s=.5,rasterized=True);ax.set_ylabel(r'$(f-c)/c$')
    ax.set(xlabel=r'$x$',title=label+f' (L = {L})')
fig.tight_layout();save(fig,'06_fraction_behaviour.png')

# 07: precision comparison and predicted noisy intervals.
vals=[(1,'1'),(3,'3'),(101,'101'),(.5,'1/2'),(.75,'3/4'),(.1,'0.1'),(1/3,'1/3')]
fig,axs=plt.subplots(1,2,figsize=(11.2,4.7),sharey=True)
for ax,dtype,name in zip(axs,[np.float64,np.float32],['binary64 (p = 53)','binary32 (p = 24)']):
    for i,(c,lab) in enumerate(vals):
        x1,x2,L=theory(c,dtype)
        ax.barh(i,x2-x1,left=x1,height=.57,color=C1 if c==int(c) else C2,alpha=.75)
        ax.plot([x1,x2],[i,i],'|',c='#111',markersize=9)
        ax.text(x2*1.03,i,f'L={L}',va='center',fontsize=7)
    ax.set(xscale='log',xlabel=r'$x$ (log scale)',title=name)
    ax.grid(axis='y',visible=False)
    ax.invert_yaxis()
axs[0].set_yticks(np.arange(len(vals)));axs[0].set_yticklabels([lab for c,lab in vals])
axs[0].set_ylabel(r'Increment $c$')
fig.tight_layout();save(fig,'07_precision_comparison.png')

# 08: exact nearest-grid rule as a conceptual plot, not new experimental claims.
q=np.linspace(0,4,2500)
e=np.floor(q+.5)-q
fig,ax=plt.subplots(figsize=(8.1,3.5))
ax.plot(q,e,c=C1,lw=1.5)
for j in range(4):
    ax.plot([j+.5,j+.5],[-.5,.5],c=C2,lw=.8,ls=':')
ax.axhline(.5,c=C4,ls='--',lw=.8);ax.axhline(-.5,c=C4,ls='--',lw=.8)
ax.set(ylim=(-.62,.62),xlabel=r'$q = c / \mathrm{ULP}(y)$',ylabel=r'$\epsilon = (f-c)/\mathrm{ULP}(y)$',title='Nearest-grid rounding: normalized sawtooth error')
ax.text(2.35,.43,'Half-integer ties depend on the parity of the stored significand',fontsize=8)
save(fig,'08_ulp_sawtooth.png')

# 09: directly matching reciprocal odd denominators from the fourth HTML file.
fig,axs=plt.subplots(2,2,figsize=(10.2,6.3))
for ax,d in zip(axs.ravel(),[3,5,9,15]):
    c=1/d;x=np.linspace(1,40,16000);z,_=evaluate(x,c)
    ax.scatter(x,z,s=.4,c=C1,rasterized=True)
    ax.axhline(c,c=C4,ls='--',lw=1)
    ax.set(xlabel=r'$x$',ylabel=r'$f(x)$',title=rf'$c=1/{d}$')
fig.tight_layout();save(fig,'09_reciprocal_odd_fractions.png')
