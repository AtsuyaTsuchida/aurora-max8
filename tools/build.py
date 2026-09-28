import json, wave
from pathlib import Path
import numpy as np

ROOT=Path(__file__).resolve().parent.parent
OUT=ROOT
VER={'major':8,'minor':6,'revision':5,'architecture':'x64','modernui':1}
def patch(namespace='box'):
 return {'fileversion':1,'appversion':VER,'classnamespace':namespace,'rect':[60,60,1120,750],'default_fontsize':12,'default_fontname':'Arial','boxes':[],'lines':[]}
def box(p,id,text=None,kind='newobj',rect=None,**kw):
 b={'id':id,'maxclass':kind,'patching_rect':rect or [20,20,150,22],**kw}
 if text is not None:b['text']=text
 p['boxes'].append({'box':b});return id
def wire(p,a,ao,b,bi=0):p['lines'].append({'patchline':{'source':[a,ao],'destination':[b,bi]}})
def write(name,p): (OUT/name).write_text(json.dumps({'patcher':p},ensure_ascii=False,indent=2))

# A self-contained, original stereo source, tuned to C with evolving harmonics.
sr=48000;n=sr*12;t=np.arange(n)/sr;rng=np.random.default_rng(8173)
audio=np.zeros((n,2))
for c in range(2):
 s=np.zeros(n)
 for j,f in enumerate([130.8128,196.2192,261.6256,329.6276,392.4384,523.2511]):
  mod=np.sin(2*np.pi*(.07+j*.014)*t+c*.19)
  s+=(.1/(1+j*.28))*np.sin(2*np.pi*f*t+mod*.12)*(0.55+0.45*np.sin(2*np.pi*(.043+j*.011)*t+j+c*.3)**2)
 for j,onset in enumerate([.3,1.2,2.8,4.1,5.7,7.2,8.5,10.3]):
  age=np.maximum(t-onset,0);gate=(t>=onset)
  f=[523.251,659.255,783.991,1046.502][j%4]
  s+=gate*.18*(1-np.exp(-age*140))*np.exp(-age*2.4)*np.sin(2*np.pi*f*age+.6*np.sin(2*np.pi*f*2.756*age)*np.exp(-age*3))
 # quiet moving air, pre-smoothed so the demonstration remains gentle
 noise=rng.standard_normal(n);noise=np.convolve(noise,np.ones(19)/19,mode='same')
 s+=noise*.028*(.3+.7*np.sin(t*.9+c)**2)
 s*=np.minimum(t/.15,1)*np.minimum((12-t)/.4,1)
 audio[:,c]=s
audio*=.78/np.max(np.abs(audio))
with wave.open(str(OUT/'AURORA_Source.wav'),'wb') as w:
 w.setnchannels(2);w.setsampwidth(3);w.setframerate(sr)
 a=np.round(audio*8388607).astype(np.int32).reshape(-1)
 b=np.empty((len(a),3),np.uint8)
 for i in range(3):b[:,i]=(a>>(8*i))&255
 w.writeframes(b.tobytes())

g=patch('dsp.gen');g['rect']=[100,100,980,740]
box(g,'code',kind='codebox',rect=[30,30,910,580],numinlets=1,numoutlets=4,outlettype=['','','',''],code=(ROOT/'src/aurora_engine.genexpr').read_text())
for i in range(4):
 box(g,'out'+str(i),'out '+str(i+1),rect=[40+i*200,650,50,22]);wire(g,'code',i,'out'+str(i))
write('aurora_engine_v2.gendsp',g)

p=patch();p.update(openinpresentation=1,bglocked=1,bgcolor=[.035,.047,.061,1],presentation_rect=[0,0,1120,750],enablehscroll=0,enablevscroll=0,toolbarvisible=0,statusbarvisible=0,description='AURORA — a 64-voice stereo granular instrument for Max 8.',title='AURORA | Granular Instrument')
box(p,'panel',kind='jsui',rect=[0,0,1120,750],presentation=1,presentation_rect=[0,0,1120,750],filename='aurora_ui.js',jsarguments=['#0-source'],numinlets=1,numoutlets=2,outlettype=['',''],border=0,varname='panel')
box(p,'engine','gen~ aurora_engine_v2',rect=[30,840,190,22],numinlets=1,numoutlets=4,outlettype=['signal']*4)
box(p,'source','buffer~ #0-source AURORA_Source.wav',rect=[300,840,265,22],numinlets=1,numoutlets=2,outlettype=['float','bang'])
box(p,'loaded','loaded',kind='message',rect=[300,880,60,22]);wire(p,'source',1,'loaded');wire(p,'loaded',0,'panel')
wire(p,'panel',0,'engine')
box(p,'commands','route audio load demo save recall recopen recstop',rect=[30,780,540,22],numinlets=1,numoutlets=8,outlettype=['']*8);wire(p,'panel',1,'commands')
box(p,'limiter','limi~ 2 @threshold -1. @lookahead 128 @release 100 @dcblock 1',rect=[30,970,430,22],numinlets=2,numoutlets=2,outlettype=['signal','signal'])
wire(p,'engine',0,'limiter',0);wire(p,'engine',1,'limiter',1)
box(p,'dac','ezdac~',rect=[30,1100,45,45],numinlets=2,numoutlets=0)
wire(p,'limiter',0,'dac',0);wire(p,'limiter',1,'dac',1);wire(p,'commands',0,'dac')
box(p,'replace','replace',kind='message',rect=[610,840,70,22]);wire(p,'commands',1,'replace');wire(p,'replace',0,'source')
box(p,'demo','replace AURORA_Source.wav',kind='message',rect=[610,880,210,22]);wire(p,'commands',2,'demo');wire(p,'demo',0,'source')
box(p,'bind','loadmess source #0-source',rect=[30,900,195,22]);wire(p,'bind',0,'engine')
box(p,'init','loadbang',rect=[850,790,70,22]);box(p,'defer','deferlow',rect=[850,830,70,22]);box(p,'initmsg','loadbang',kind='message',rect=[850,870,70,22]);wire(p,'init',0,'defer');wire(p,'defer',0,'initmsg');wire(p,'initmsg',0,'panel')
box(p,'dspstate','dspstate~',rect=[600,950,75,22],numinlets=1,numoutlets=4,outlettype=['int','float','int','int']);box(p,'dspmsg','prepend dspstate',rect=[600,990,110,22]);wire(p,'dspstate',0,'dspmsg');wire(p,'dspmsg',0,'panel')
for n,engout,x in [('cursor',2,30),('voices',3,220)]:
 box(p,n+'snap','snapshot~ 50',rect=[x,930,100,22]);box(p,n+'msg','prepend '+n,rect=[x+950,930,110,22]);wire(p,'engine',engout,n+'snap');wire(p,n+'snap',0,n+'msg');wire(p,n+'msg',0,'panel')
for c,x in [(0,300),(1,450)]:
 box(p,'peak'+str(c),'peakamp~ 50',rect=[x,1020,100,22]);wire(p,'limiter',c,'peak'+str(c))
box(p,'levels','pak 0. 0.',rect=[300,1060,100,22]);wire(p,'peak0',0,'levels');wire(p,'peak1',0,'levels',1)
box(p,'levelmsg','prepend levels',rect=[300,1100,100,22]);wire(p,'levels',0,'levelmsg');wire(p,'levelmsg',0,'panel')
box(p,'savedialog','savedialog WAVE',rect=[600,1190,145,22]);wire(p,'commands',5,'savedialog')
box(p,'saveorder','t b s',rect=[600,1230,50,22]);wire(p,'savedialog',0,'saveorder')
box(p,'openwav','open $1 wave',kind='message',rect=[730,1230,100,22]);wire(p,'saveorder',1,'openwav')
box(p,'recorddelay','delay 100',rect=[600,1270,80,22]);wire(p,'saveorder',0,'recorddelay')
box(p,'recordone','1',kind='message',rect=[600,1310,30,22]);wire(p,'recorddelay',0,'recordone')
box(p,'reczero','0',kind='message',rect=[690,1310,30,22]);wire(p,'commands',6,'reczero')
box(p,'recorder','sfrecord~ 2 @bitdepth 24',rect=[300,1230,180,22],numinlets=2,numoutlets=1,outlettype=['signal'])
wire(p,'limiter',0,'recorder',0);wire(p,'limiter',1,'recorder',1);wire(p,'openwav',0,'recorder');wire(p,'recordone',0,'recorder');wire(p,'reczero',0,'recorder')
box(p,'recordstatus','recstarted',kind='message',rect=[780,1310,80,22]);wire(p,'recorddelay',0,'recordstatus');wire(p,'recordstatus',0,'panel')
box(p,'note','AURORA / Audio path: 64-voice Gen → linked stereo limiter → output & 24-bit recorder.\nEdit aurora_engine_v2.gendsp for DSP and aurora_ui.js for the interface. No third-party externals.',kind='comment',rect=[30,1190,245,100])

box(p,'key','key',rect=[30,1370,50,22])
box(p,'active','active',rect=[100,1370,50,22])
box(p,'keygate','gate',rect=[30,1410,50,22]);wire(p,'active',0,'keygate');wire(p,'key',0,'keygate',1)
box(p,'keysel','sel 32 102 49 50 51 52 53',rect=[30,1450,220,22]);wire(p,'keygate',0,'keysel')
for i,txt in enumerate(['action run','action freeze','preset 0','preset 1','preset 2','preset 3','preset 4']):
 box(p,'keymsg'+str(i),txt,kind='message',rect=[30+i*120,1490,110,22]);wire(p,'keysel',i,'keymsg'+str(i));wire(p,'keymsg'+str(i),0,'panel')

# JSON state dialogs connect directly to the UI serializer.
box(p,'stsave','savedialog JSON',rect=[600,1050,140,22]);wire(p,'commands',3,'stsave')
box(p,'stsavepath','prepend savestatepath',rect=[600,1090,170,22]);wire(p,'stsave',0,'stsavepath');wire(p,'stsavepath',0,'panel')
box(p,'stload','opendialog JSON',rect=[800,1050,140,22]);wire(p,'commands',4,'stload')
box(p,'stloadpath','prepend loadstatepath',rect=[800,1090,170,22]);wire(p,'stload',0,'stloadpath');wire(p,'stloadpath',0,'panel')
write('AURORA.maxpat',p)


print('Built',OUT)
