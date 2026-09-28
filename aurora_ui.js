autowatch = 1;
inlets = 1;
outlets = 2;
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
var W=1120, H=750;
var C={bg:[0.035,0.047,0.061,1],panel:[0.065,0.080,0.100,1],edge:[0.14,0.18,0.21,1],ink:[0.91,0.95,0.95,1],muted:[0.45,0.54,0.59,1],mint:[0.49,0.94,0.76,1],lilac:[0.72,0.66,0.98,1],amber:[1,0.73,0.43,1]};
var defs=[
 ['position','POSITION',0,1,0.18,'%',0,'Waveform position. Drag the waveform to move here.'],
 ['scan','SCAN',-2,2,0.12,'x',0,'Travel speed through the source. Zero holds position.'],
 ['spray','SPRAY',0,1,0.12,'%',0,'Random position spread around the playhead.'],
 ['size','GRAIN SIZE',10,500,160,'ms',1,'Duration per grain; sampled when each grain begins.'],
 ['density','DENSITY',2,100,28,'/s',1,'Grains per second. Up to 64 simultaneous grains.'],
 ['jitter','SCATTER',0,1,0.35,'%',0,'Random spacing between grain onsets.'],
 ['pitch','PITCH',-24,24,0,'st',0,'Transpose independently of scan speed.'],
 ['detune','DETUNE',0,12,0.12,'st',0,'Random pitch spread per grain, in semitones.'],
 ['reverse','REVERSE',0,1,0,'%',0,'Probability of a grain playing backwards.'],
 ['width','WIDTH',0,1,0.8,'%',0,'Random equal-power stereo placement.'],
 ['shape','CONTOUR',0,1,0.3,'%',0,'Hann window at 0; increasingly focused at 100.'],
 ['cutoff','LOWPASS',80,18000,12000,'Hz',1,'Smooth stereo state-variable low-pass filter.'],
 ['resonance','RESONANCE',0,0.95,0.1,'%',0,'Filter emphasis at the cutoff frequency.'],
 ['drive','WARMTH',0,1,0.1,'%',0,'Soft saturation before the filter.'],
 ['space','SPACE',0,1,0.35,'%',0,'Stereo feedback-network reverb level.'],
 ['decay','DECAY',0,1,0.65,'%',0,'Reverb feedback / tail length.'],
 ['echo','ECHO',0,1,0.15,'%',0,'Stereo ping-pong echo level.'],
 ['echotime','TIME',50,1200,375,'ms',1,'Echo time; right repeats at a 4:3 ratio.'],
 ['feedback','FEEDBACK',0,0.85,0.3,'%',0,'Echo feedback, bounded for stable repeats.'],
 ['gain','OUTPUT',-60,0,-15,'dB',0,'Master output gain before the linked limiter.']
];
var v={}, knobs=[], buttons=[], hover='', drag=-1, lastY=0, startY=0, startV=0;
var running=0, frozen=0, dsp=0, recording=0, active=0, head=0.18, levelL=0,levelR=0;
var sourceName='AURORA / Glass Garden', seconds=12, peaks=[], status='READY  /  press AUDIO, then PLAY';
var presetIndex=0, ticks=0, bname=jsarguments.length>1?jsarguments[1]:'aurora_source';
var presets=[
 ['GLASS GARDEN',{position:.18,scan:.12,spray:.12,size:160,density:28,jitter:.35,pitch:0,detune:.12,reverse:0,width:.8,shape:.3,cutoff:12000,resonance:.1,drive:.1,space:.35,decay:.65,echo:.15,echotime:375,feedback:.3}],
 ['VELVET CLOUD',{position:.48,scan:.035,spray:.35,size:420,density:44,jitter:.65,pitch:-12,detune:.32,reverse:.3,width:1,shape:.1,cutoff:4200,resonance:.18,drive:.22,space:.65,decay:.88,echo:.12,echotime:610,feedback:.38}],
 ['PRISM RAIN',{position:.3,scan:.55,spray:.55,size:35,density:62,jitter:.8,pitch:12,detune:7,reverse:.2,width:1,shape:.65,cutoff:14000,resonance:.35,drive:.08,space:.42,decay:.72,echo:.38,echotime:190,feedback:.45}],
 ['TAPE ORBIT',{position:.62,scan:-.22,spray:.065,size:230,density:18,jitter:.3,pitch:-7,detune:.18,reverse:.7,width:.75,shape:.3,cutoff:6500,resonance:.25,drive:.35,space:.3,decay:.6,echo:.55,echotime:420,feedback:.56}],
 ['MICRO BLOOM',{position:.12,scan:.18,spray:.028,size:18,density:88,jitter:.1,pitch:7,detune:.03,reverse:0,width:.55,shape:.75,cutoff:9500,resonance:.45,drive:.26,space:.2,decay:.48,echo:.18,echotime:125,feedback:.23}]
];
for(var i=0;i<defs.length;i++)v[defs[i][0]]=defs[i][4];
function rgba(c){mgraphics.set_source_rgba(c);}
function rect(x,y,w,h,c){rgba(c);mgraphics.rectangle(x,y,w,h);mgraphics.fill();}
function line(x,y,x2,y2,c,width){rgba(c);mgraphics.set_line_width(width||1);mgraphics.move_to(x,y);mgraphics.line_to(x2,y2);mgraphics.stroke();}
function text(s,x,y,size,c){rgba(c);mgraphics.select_font_face('Arial');mgraphics.set_font_size(size);mgraphics.move_to(x,y);mgraphics.show_text(s);}
function circle(x,y,r,c){rgba(c);mgraphics.arc(x,y,r,0,Math.PI*2);mgraphics.fill();}
function clamp(x,a,b){return Math.max(a,Math.min(b,x));}
function fmt(d,n){var u=d[5];if(u=='%')return Math.round(n*100)+' %';if(u=='Hz')return n>=1000?(n/1000).toFixed(1)+' kHz':Math.round(n)+' Hz';if(u=='ms')return Math.round(n)+' ms';if(u=='/s')return Math.round(n)+' /s';if(u=='st')return(n>0?'+':'')+n.toFixed(d[0]=='pitch'?1:2)+' st';if(u=='dB')return n.toFixed(1)+' dB';return(n>0?'+':'')+n.toFixed(2)+' x';}
function normal(d){return d[6]?Math.log(v[d[0]]/d[2])/Math.log(d[3]/d[2]):(v[d[0]]-d[2])/(d[3]-d[2]);}
function denormal(d,n){return d[6]?d[2]*Math.pow(d[3]/d[2],n):d[2]+n*(d[3]-d[2]);}
function button(id,label,x,y,w,on,c){buttons.push({id:id,x:x,y:y,w:w,h:30});rect(x,y,w,30,on?c:C.panel);text(label,x+12,y+20,10,on?C.bg:C.ink);}
function section(label,num,x,y,w,c){rect(x,y,w,170,C.panel);text(num,x+16,y+24,10,c);text(label,x+43,y+24,11,C.ink);line(x+16,y+37,x+w-16,y+37,C.edge,1);}
function knob(n,x,y,c){var d=defs[n],r=23,t=.75*Math.PI,nt=normal(d);knobs[n]={x:x,y:y,r:43};rgba(C.edge);mgraphics.set_line_width(3);mgraphics.arc(x,y,r,t,2.25*Math.PI);mgraphics.stroke();rgba(c);mgraphics.arc(x,y,r,t,t+Math.max(.001,nt)*1.5*Math.PI);mgraphics.stroke();circle(x,y,18,C.bg);var a=t+nt*1.5*Math.PI;line(x+Math.cos(a)*10,y+Math.sin(a)*10,x+Math.cos(a)*17,y+Math.sin(a)*17,c,2);text(d[1],x-37,y+43,8,C.muted);text(fmt(d,v[d[0]]),x-37,y+62,12,C.ink);}
function paint(){
 var width=box.rect[2]-box.rect[0],height=box.rect[3]-box.rect[1];
 mgraphics.save();mgraphics.scale(width/W,height/H);buttons=[];
 rect(0,0,W,H,C.bg);rect(0,0,4,H,C.mint);
 text('A U R O R A',30,45,26,C.ink);text('G R A N U L A R   I N S T R U M E N T',32,66,8,C.muted);
 text('64 VOICES  /  GEN~  /  STEREO',385,44,10,C.muted);
 button('audio',dsp?'AUDIO  ON':'AUDIO  OFF',726,27,112,dsp,C.mint);
 button('run',running?'STOP':'PLAY',850,27,98,running,C.mint);
 button('freeze',frozen?'FROZEN':'FREEZE',960,27,130,frozen,C.lilac);
 line(30,85,1090,85,C.edge,1);
 text('PALETTE',30,116,9,C.muted);
 for(var j=0;j<5;j++)button('preset'+j,presets[j][0],115+j*174,96,162,j==presetIndex,C.mint);
 button('mutate','MUTATE',995,96,95,0,C.mint);
 rect(30,145,1060,154,C.panel);
 text('SOURCE',46,168,9,C.muted);text(sourceName,111,168,11,C.ink);
 text(seconds.toFixed(2)+' SEC',756,168,10,C.muted);
 button('demo','DEMO',844,151,70,0,C.mint);button('load','LOAD SAMPLE',926,151,148,0,C.mint);
 var x0=46,y0=227,ww=1028;
 line(x0,y0,x0+ww,y0,C.edge,1);
 rect(x0+clamp(head-v.spray/2,0,1)*ww,187,Math.min(v.spray,1)*ww,78,[.49,.94,.76,.035]);
 if(peaks.length){rgba([.35,.63,.57,1]);mgraphics.set_line_width(1);for(j=0;j<peaks.length;j++){var xx=x0+j/peaks.length*ww,aa=peaks[j]*34;mgraphics.move_to(xx,y0-aa);mgraphics.line_to(xx,y0+aa);}mgraphics.stroke();}
 for(j=0;j<Math.min(active,40);j++){var seed=Math.sin(j*23.31+ticks*.012)*.5+.5;var gx=wrap01(head+(seed-.5)*v.spray)*ww+x0;circle(gx,192+((j*17)%68),1.4,[.65,.92,.8,.45]);}
 line(x0+head*ww,184,x0+head*ww,266,C.mint,1.5);circle(x0+head*ww,184,3,C.mint);
 text('DRAG TO EXPLORE',46,286,8,C.muted);text('SHIFT + DRAG  /  FINE',230,286,8,C.muted);text(active+' / 64 GRAINS',956,286,9,C.mint);
 section('SOURCE MOTION','01',30,318,304,C.mint);
 section('GRAIN CLOUD','02',347,318,304,C.mint);
 section('PITCH & STEREO','03',664,318,426,C.lilac);
 knob(0,86,397,C.mint);knob(1,183,397,C.mint);knob(2,280,397,C.mint);
 knob(3,403,397,C.mint);knob(4,500,397,C.mint);knob(5,597,397,C.mint);
 knob(6,720,397,C.lilac);knob(7,822,397,C.lilac);knob(8,924,397,C.lilac);knob(9,1030,397,C.lilac);
 section('SHAPE & COLOR','04',30,506,426,C.amber);
 section('SPACE & TIME','05',469,506,513,C.lilac);
 rect(995,506,95,170,C.panel);text('OUTPUT',1009,530,10,C.ink);
 knob(10,86,585,C.amber);knob(11,188,585,C.amber);knob(12,290,585,C.amber);knob(13,397,585,C.amber);
 knob(14,525,585,C.lilac);knob(15,626,585,C.lilac);knob(16,727,585,C.lilac);knob(17,828,585,C.lilac);knob(18,929,585,C.lilac);knob(19,1043,585,C.mint);
 line(30,693,1090,693,C.edge,1);
 button('save','SAVE STATE',30,706,110,0,C.mint);button('recall','LOAD STATE',148,706,110,0,C.mint);
 button('record',recording?'STOP REC':'REC WAV',271,706,105,recording,C.amber);
 text(hover||status,392,725,10,C.muted);
 rect(968,710,122,5,C.edge);rect(968,721,122,5,C.edge);
 rect(968,710,122*clamp((20*Math.log(Math.max(levelL,.000001))/Math.LN10+60)/60,0,1),5,C.mint);
 rect(968,721,122*clamp((20*Math.log(Math.max(levelR,.000001))/Math.LN10+60)/60,0,1),5,C.lilac);
 mgraphics.restore();
}
function wrap01(n){return n-Math.floor(n);}
function change(n,value){var d=defs[n];v[d[0]]=clamp(value,d[2],d[3]);outlet(0,d[0],v[d[0]]);}
function sendall(){for(var i=0;i<defs.length;i++)outlet(0,defs[i][0],v[defs[i][0]]);outlet(0,'freeze',frozen);outlet(0,'run',running);}
function loadbang(){outlet(0,'source',bname);sendall();loaded();}
function loaded(){try{var b=new Buffer(bname);seconds=b.length()/1000;var f=b.framecount();if(f>0&&seconds>0){outlet(0,'sourcesr',f/seconds);peaks=[];for(var j=0;j<720;j++){var st=Math.floor(j*f/720),count=Math.max(1,Math.floor(f/720));var p=b.peek(1,st,count),pk=0;if(typeof p=='number')pk=Math.abs(p);else for(var k=0;k<p.length;k++)pk=Math.max(pk,Math.abs(p[k]));peaks.push(pk);}var mx=0;for(j=0;j<peaks.length;j++)mx=Math.max(mx,peaks[j]);if(mx>0)for(j=0;j<peaks.length;j++)peaks[j]/=mx;status='SOURCE READY  /  '+b.channelcount()+' CH';}}catch(e){status='LOAD A SAMPLE TO BEGIN';}mgraphics.redraw();}
function userloaded(){sourceName='USER SAMPLE';loaded();}
function preset(n){presetIndex=n;var p=presets[n][1];for(var key in p)v[key]=p[key];frozen=0;sendall();status=presets[n][0]+'  /  drag knobs to shape';mgraphics.redraw();}
function action(id){
 if(id.indexOf('preset')==0){preset(parseInt(id.substr(6)));return;}
 if(id=='audio'){outlet(1,'audio',dsp?0:1);return;}
 if(id=='run'){running=1-running;if(running&&!dsp)outlet(1,'audio',1);outlet(0,'run',running);status=running?'PLAYING  /  double-click a knob to reset':'STOPPED';}
 if(id=='freeze'){frozen=1-frozen;outlet(0,'freeze',frozen);status=frozen?'FROZEN  /  grain motion continues':'SCAN RESUMED';}
 if(id=='load'){sourceName='USER SAMPLE';outlet(1,'load');}
 if(id=='demo'){sourceName='AURORA / Glass Garden';outlet(1,'demo');}
 if(id=='mutate'){var names=['position','spray','size','density','detune','width','shape','space','echo'];for(var j=0;j<defs.length;j++)if(names.indexOf(defs[j][0])>=0)change(j,denormal(defs[j],clamp(normal(defs[j])+(Math.random()-.5)*.32,0,1)));presetIndex=-1;status='MUTATED  /  small changes, new texture';}
 if(id=='save'){outlet(1,'save');status='SAVE PARAMETER STATE';}
 if(id=='recall'){outlet(1,'recall');}
 if(id=='record'){if(recording){recording=0;outlet(1,'recstop');status='RECORDING SAVED';}else{outlet(1,'recopen');status='CHOOSE A WAV FILE  /  recording starts after save';}}
 mgraphics.redraw();
}
function coords(x,y){return[x*W/(box.rect[2]-box.rect[0]),y*H/(box.rect[3]-box.rect[1])];}
function onclick(x,y,but,cmd,shift){var p=coords(x,y);x=p[0];y=p[1];drag=-1;for(var j=0;j<buttons.length;j++){var b=buttons[j];if(x>=b.x&&x<=b.x+b.w&&y>=b.y&&y<=b.y+b.h){action(b.id);return;}}if(x>=46&&x<=1074&&y>=183&&y<=268){drag=-2;change(0,wrap01(v.position+(x-46)/1028-head));head=(x-46)/1028;mgraphics.redraw();return;}for(j=0;j<knobs.length;j++){var k=knobs[j];if(Math.abs(x-k.x)<42&&Math.abs(y-k.y)<40){drag=j;startY=y;startV=normal(defs[j]);hover=defs[j][7];mgraphics.redraw();return;}}}
function ondrag(x,y,but,cmd,shift){var p=coords(x,y);x=p[0];y=p[1];if(!but){drag=-1;hover='';mgraphics.redraw();return;}if(drag==-2){change(0,wrap01(v.position+clamp((x-46)/1028,0,1)-head));head=clamp((x-46)/1028,0,1);}else if(drag>=0){var n=clamp(startV+(startY-y)/(shift?1400:180),0,1);change(drag,denormal(defs[drag],n));presetIndex=-1;}mgraphics.redraw();}
function ondblclick(x,y){var p=coords(x,y);for(var j=0;j<knobs.length;j++){var k=knobs[j];if(Math.abs(p[0]-k.x)<42&&Math.abs(p[1]-k.y)<40){change(j,defs[j][4]);mgraphics.redraw();return;}}}
function onidle(x,y){var p=coords(x,y);hover='';for(var j=0;j<knobs.length;j++){var k=knobs[j];if(Math.abs(p[0]-k.x)<42&&Math.abs(p[1]-k.y)<40){hover=defs[j][7];break;}}mgraphics.redraw();}
function onidleout(){hover='';mgraphics.redraw();}
function cursor(n){head=n;ticks++;mgraphics.redraw();}
function voices(n){active=Math.round(n);}
function levels(a,b){levelL=a;levelR=b;}
function dspstate(n){dsp=n;mgraphics.redraw();}
function recstarted(){recording=1;status='RECORDING  /  24-BIT STEREO WAV';mgraphics.redraw();}
function getvalueof(){var state={values:v,preset:presetIndex,freeze:frozen};return JSON.stringify(state);}
function setvalueof(){try{var s=JSON.parse(arrayfromargs(arguments).join(' '));for(var j=0;j<defs.length;j++){var d=defs[j];if(s.values[d[0]]!==undefined)v[d[0]]=clamp(s.values[d[0]],d[2],d[3]);}presetIndex=s.preset;frozen=s.freeze||0;sendall();status='STATE RESTORED';mgraphics.redraw();}catch(e){post('AURORA: invalid state\n');}}

function savestatepath(path){
 var f=new File(path,'write','TEXT');
 if(f.isopen){f.eof=0;f.writestring(getvalueof());f.close();status='STATE SAVED';}else status='COULD NOT SAVE STATE';
 mgraphics.redraw();
}
function loadstatepath(path){
 var f=new File(path,'read','TEXT');
 if(f.isopen){var content=f.readstring(f.eof);f.close();setvalueof(content);}else{status='COULD NOT OPEN STATE';mgraphics.redraw();}
}
