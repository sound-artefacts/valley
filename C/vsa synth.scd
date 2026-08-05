///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=13;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
s.meter;
//s.freqscope;
s.scope;
);
~controlBus_1 = Bus.control(s, 1);
~controlBus_2 = Bus.control(s, 1);
~controlBus_3 = Bus.control(s, 1);
~controlBus_4 = Bus.control(s, 1);
~controlBus_5 = Bus.control(s, 1);
~controlBus_6 = Bus.control(s, 1);
~controlBus_x = Bus.control(s, 1);
~controlBus_y = Bus.control(s, 1);
~controlBus_z = Bus.control(s, 1);
~controlBus_ra1 = Bus.control(s, 1);
~controlBus_re1 = Bus.control(s, 1);
~controlBus_ra2 = Bus.control(s, 1);
~controlBus_re2 = Bus.control(s, 1);
s.waitForBoot{
Tdef(\drone, {


////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre///////////////////////////////////////


///tensor data
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~azth=[]; ~elth=[];

32.do{
    azimuth = 32.collect{
        az1 = (az1 + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);
        el1 = (el1 + (pi-(pi/g))).wrap((pi/2).neg,(pi/2));
        (az1 + angle).wrap(pi.neg,pi)
    };

    elevation = 32.collect{
        az2 = (az2 + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);
        el2 = (el2 + (pi-(pi/g))).wrap((pi/2).neg,(pi/2));
        (el2 + angle).wrap((pi/2).neg,(pi/2))
    };

    angle = (angle + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);

    ~azth = ~azth ++ azimuth;
    ~elth = ~elth ++ elevation;

    az1=0; el1=0;
    az2=0; el2=0;
};
}.value;
);
~timbr_dur=(1/16);
~octaves=2;
~vertices = 32*32;
~count=[1,1,2,4,4,4];
~set=(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]);
~fuse1=1;~fuse2=1;~harm=1;~mod=0;~fuse=1000;


/////sph harm mod
(
~sph=Spherical(pi,0,0.5pi.rand2);
{Out.kr(~controlBus_x.index,SinOsc.kr(0.05,~sph.x,pi))}.play;
{Out.kr(~controlBus_y.index,SinOsc.kr(0.05,~sph.y,pi))}.play;
{Out.kr(~controlBus_z.index,SinOsc.kr(0.05,~sph.z,pi))}.play;
);

///sound tensor nest
({
var pla=0,az=0,el=0;
var sph,mag,r,run = true;
var scale=1,scale1=10,scale2=10,harm,perspective;
var axis=~count.[0],cloud=~count.[1],axis1=~count.[2],gravity1=~count.[3],axis2=~count.[4],gravity2=~count.[5];
var m_x=1,m_y=1,m_z=1,mq=m_x+1;
var sph1,sph2,sph3,sph4,sph7,sph6,sph11,sph22,sph33,sph44,sph77,sph66;
var sph_1,sph_2,sph_3,sph_4,sph_7,sph_6,sph_11,sph_22,sph_33,sph_44,sph_77,sph_66;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,az4=0,el4=0,az7=0,el7=0,az6=0,el6=0;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az77=0,el77=0,az66=0,el66=0;
var az_1=0,el_1=0,az_2=0,el_2=0,az_3=0,el_3=0,az_4=0,el_4=0,az_7=0,el_7=0,az_6=0,el_6=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,magnitudeqx;
var magx,magy,magz,magqx,rotation;
var angle=0,angle1=0,angle11=0;
var g=((1+5.sqrt)/2),s=(1+2.sqrt),ott=pi.rand2,temp,space,mod_el=0;
var waveSpeed = 0.5,waveFreq = 3,amp=0.5;
var n=0,rx=0,ry=0,rz=0;
var theta,phi,wave,anglex,angley,anglez;

~rotation=1;~rotationx=0;~rotationy=0;~rotationz=0;~rx=0;~ry=0;~rz=0;~rotationx1=0;~rotationy1=0;~rotationz1=0;
~azr=[];~elr=[];~magx=[];~magy=[];~magz=[];~qx=[];
~cx = [];~cy = [];~cz = [];
//g=7;s=7;
~tree= Routine({loop{
scale=~fuse;
scale1=~fuse1;
scale2=~fuse2;
harm=~harm;
anglex=~controlBus_x.getSynchronous;
angley=~controlBus_y.getSynchronous;
anglez=~controlBus_z.getSynchronous;
m_x=m_y=m_z=harm;
mq=harm+1;
axis=~count.[0];cloud=~count.[1];axis1=~count.[2];
gravity1=~count.[3];axis2=~count.[4];gravity2=~count.[5];

az1=0; el1=0;az2=0; el2=0;
az3=0; el3=0;az4=0; el4=0;
az7=0; el7=0;az6=0; el6=0;
angle = 0;angle1 = 0;angle11 = 0;
az11=0; el11=0;az22=0; el22=0;
az33=0; el33=0;az44=0; el44=0;
az77=0; el77=0;az66=0; el66=0;
az_1=0; el_1=0;az_2=0; el_2=0;
az_3=0; el_3=0;az_4=0; el_4=0;
az_7=0; el_7=0;az_6=0; el_6=0;
pla = 0;

(
{
~azr=[];~elr=[];~magx=[];~magy=[];~magz=[];~magqx=[];
~cx = [];~cy = [];~cz = [];
axis.do{
//////////////////////////// AZ
cloud.do{
az1=(az1+(2pi-(2pi/s))).wrap(pi.neg,pi);
el1=(el1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph1=Spherical(1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az11=sph1.theta;
el11=sph1.phi;

gravity1.do{
az11=(az11+(2pi-(2pi/s))).wrap(pi.neg,pi);
el11=(el11+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;
sph11=Spherical(1/scale1,(az11+angle1).wrap(pi.neg,pi),(el11+angle1).wrap((pi/2).neg,(pi/2)));
sph_1=(sph1.asCartesian+sph11.asCartesian);

axis2.do{
az_1=sph11.theta;
el_1=sph11.phi;

azimuth=gravity2.collect{
az_1=(az_1+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_1=(el_1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_11=Spherical(1/scale2,(az_1+angle11).wrap(pi.neg,pi),(el_1+angle11).wrap((pi/2).neg,(pi/2)));
(sph_1+sph_11.asCartesian).asSpherical.theta
};
~azr=~azr++azimuth;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};

//////////////////////////// EL
cloud.do{
az2=(az2+(2pi-(2pi/s))).wrap(pi.neg,pi);
el2=(el2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph2=Spherical(1,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az22=sph2.theta;
el22=sph2.phi;

gravity1.do{
az22=(az22+(2pi-(2pi/s))).wrap(pi.neg,pi);
el22=(el22+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;
sph22=Spherical(1/scale1,(az22+angle1).wrap(pi.neg,pi),(el22+angle1).wrap((pi/2).neg,(pi/2)));
sph_2=(sph2.asCartesian+sph22.asCartesian);

axis2.do{
az_2=sph22.theta;
el_2=sph22.phi;

elevation=gravity2.collect{
az_2=(az_2+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_2=(el_2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_22=Spherical(1/scale2,(az_2+angle11).wrap(pi.neg,pi),(el_2+angle11).wrap((pi/2).neg,(pi/2)));
(sph_2+sph_22.asCartesian).asSpherical.phi
};
~elr=~elr++elevation;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
//////////////////////////// MAG X
cloud.do{
az3=(az3+(2pi-(2pi/s))).wrap(pi.neg,pi);
el3=(el3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph3=Spherical(1,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az33=sph3.theta;
el33=sph3.phi;

gravity1.do{
az33=(az33+(2pi-(2pi/s))).wrap(pi.neg,pi);
el33=(el33+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle11=angle1;
sph33=Spherical(1/scale1,(az33+angle1).wrap(pi.neg,pi),(el33+angle1).wrap((pi/2).neg,(pi/2)));
sph_3=(sph3.asCartesian+sph33.asCartesian);

axis2.do{
az_3=sph33.theta;
el_3=sph33.phi;

magnitudex=gravity2.collect{
az_3=(az_3+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_3=(el_3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_33=Spherical(1/scale2,(az_3+angle11).wrap(pi.neg,pi),(el_3+angle11).wrap((pi/2).neg,(pi/2)));
magx=((Complex(cos(((sph3.theta+anglex)*m_x)),cos(((sph3.theta+anglex)*m_x))).rho/(2.sqrt))*
(Complex(cos((sph3.phi)),cos((sph3.phi))).rho/(2.sqrt)));

(Spherical(magx,sph3.theta,sph3.phi).asCartesian
+Spherical(magx/scale2,sph_33.theta,sph_33.phi).asCartesian).asSpherical.rho
};
~magx=~magx++magnitudex;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
//////////////////////////// MAG Y
cloud.do{
az4=(az4+(2pi-(2pi/s))).wrap(pi.neg,pi);
el4=(el4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph4=Spherical(1,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az44=sph4.theta;
el44=sph4.phi;

gravity1.do{
az44=(az44+(2pi-(2pi/s))).wrap(pi.neg,pi);
el44=(el44+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle11=angle1;
sph44=Spherical(1/scale1,(az44+angle1).wrap(pi.neg,pi),(el44+angle1).wrap((pi/2).neg,(pi/2)));
sph_4=(sph4.asCartesian+sph44.asCartesian);

axis2.do{
az_4=sph44.theta;
el_4=sph44.phi;

magnitudey=gravity2.collect{
az_4=(az_4+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_4=(el_4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_44=Spherical(1/scale2,(az_4+angle11).wrap(pi.neg,pi),(el_4+angle11).wrap((pi/2).neg,(pi/2)));
magy=((Complex(sin(((sph4.theta+angley)*m_x)),sin(((sph4.theta+angley)*m_x))).rho/(2.sqrt))*
(Complex(cos((sph4.phi)),cos((sph4.phi))).rho/(2.sqrt)));

(Spherical(magy,sph4.theta,sph4.phi).asCartesian
+Spherical(magy/scale2,sph_44.theta,sph_44.phi).asCartesian).asSpherical.rho
};
~magy=~magy++magnitudey;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
//////////////////////////// MAG Z
cloud.do{
az7=(az7+(2pi-(2pi/s))).wrap(pi.neg,pi);
el7=(el7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph7=Spherical(1,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az77=sph7.theta;
el77=sph7.phi;

gravity1.do{
az77=(az77+(2pi-(2pi/s))).wrap(pi.neg,pi);
el77=(el77+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;
sph77=Spherical(1/scale1,(az77+angle1).wrap(pi.neg,pi),(el77+angle1).wrap((pi/2).neg,(pi/2)));
sph_7=(sph7.asCartesian+sph77.asCartesian);

axis2.do{
az_7=sph77.theta;
el_7=sph77.phi;

magnitudez=gravity2.collect{
az_7=(az_7+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_7=(el_7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_77=Spherical(1/scale2,(az_7+angle11).wrap(pi.neg,pi),(el_7+angle11).wrap((pi/2).neg,(pi/2)));
magz=(Complex(sin(((sph7.phi+anglez)*m_z)),sin((sph7.phi*m_z))).rho/(2.sqrt));

(Spherical(magz,sph7.theta,sph7.phi).asCartesian
+Spherical(magz/scale2,sph_77.theta,sph_77.phi).asCartesian).asSpherical.rho
};
~magz=~magz++magnitudez;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
/////////////////////////////////MAG QX
cloud.do{
az6=(az6+(2pi-(2pi/s))).wrap(pi.neg,pi);
el6=(el6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;
sph6=Spherical(1,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{
az66=sph6.theta;
el66=sph6.phi;

gravity1.do{
az66=(az66+(2pi-(2pi/s))).wrap(pi.neg,pi);
el66=(el66+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle11=angle1;
sph66=Spherical(1/scale1,(az66+angle1).wrap(pi.neg,pi),(el66+angle1).wrap((pi/2).neg,(pi/2)));
sph_6=(sph6.asCartesian+sph66.asCartesian);

axis2.do{
az_6=sph66.theta;
el_6=sph66.phi;

magnitudeqx=gravity2.collect{
az_6=(az_6+(2pi-(2pi/s))).wrap(pi.neg,pi);
el_6=(el_6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph_66=Spherical(1/scale2,(az_6+angle11).wrap(pi.neg,pi),(el_6+angle11).wrap((pi/2).neg,(pi/2)));
magqx=((((Complex(cos(((sph6.theta)*mq).wrap(pi.neg,pi)),cos(((sph6.theta)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi).wrap((pi/2).neg,(pi/2))),cos((sph6.phi).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));

(Spherical(magqx,sph6.theta,sph6.phi).asCartesian
+Spherical(magqx/scale2,sph_66.theta,sph_66.phi).asCartesian).asSpherical.rho
};
~magqx=~magqx++magnitudeqx;
angle11=(angle11+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);
};
};
angle=(angle+(2pi-(2pi/s))).wrap(0,2pi);
az1=0;el1=0;az2=0;el2=0;
az3=0;el3=0;az4=0;el4=0;
az7=0;el7=0;az6=0;el6=0;
};
}.value;
);
(
~magxb = ~magx.collect { |val, i|
theta = ~azr[i];
phi = ~elr[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magyb = ~magy.collect { |val, i|
theta = ~azr[i];
phi = ~elr[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magzb = ~magz.collect { |val, i|
theta = ~azr[i];
phi = ~elr[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
);

n=0;
~set.do{
var az, el,rr;
var x, y, z,rot,mag=1;

az = ~azr.[n];
el = ~elr.[n];
mag=1;
mag=Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho;
rr=Spherical(1,az,el).rotateYZ(0.5pi);
rot=Spherical(mag,rr.theta,rr.phi).rotateYZ(~rx).rotateXZ(~ry).rotateXY(~rz);
//x = cos(el) * cos(az);
//y = cos(el) * sin(az);
//z = sin(el);
x=rot.x; y=rot.y; z=rot.z;

~cx = ~cx ++ x; ~cy = ~cy ++ y; ~cz = ~cz ++ z;
//~cx = ~cx.clip2(0.5); ~cy =~cy.clip2(0.5); ~cz =~cz.fold2(0.1);
n = n + 1;
};
(~timbr_dur).wait;
};});
~tree.play
}.defer;
);
0.1.wait;
///tensor rotation
		~erate=1;
(
{var sph,rot;
Routine({loop{
(
~rx=(~rx +(~rotationx)).wrap(0,2pi);
~ry=(~ry +(~rotationy)).wrap(0,2pi);
~rz=(~rz +(~rotationz)).wrap(0,2pi);
);
(~timbr_dur).wait; // frame duration
};
}).play(~clock);
}.defer
);0.1.wait;
////envelope sig
		(
~ne=1.neg;~arraye=56.collect{~ne=~ne+1;2.pow(~ne/56)};
~signalSizee = 2048*1;
);

(
~n=1.neg;~array=16256.collect{~n=~n+1;2.pow(~n/16256)};
~n=(0-(2pi/16256)); ~ph=16256.collect{~n=~n+(2pi/16256);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);
(
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
signal=Signal.sineFill(~signalSize,~array,~ph);
wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
}.value;
);
0.5.wait;
(
~scale1=[0,0,5,7,12,17,19,24,29,31,48,53,55,96];
~note=13;
(
{
var nn=1.neg;
~scale2=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg;
~scale5=~note.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg,scale1,scale2;
~scale3=~note.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
nn=1.neg;
~scale4=~note.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
//~scale10=[scale1,scale2];
~scale=[~scale1,~scale2,~scale3,~scale4,~scale5];
}.value;
);
);

////spat
~az=[0pi,0.25pi,0.75pi.neg,pi];
~el=[0.125pi,0.125pi,0.125pi,0.125pi];
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
0.5.wait;

///amp env
~senv=Buffer.alloc(s,2048);
({
var  signal,peak,rip,attack=1,dicay=1,env,enva,times,tremolo=32,wt;
signal = Signal.sineFill(1024, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env([0,1,0.8,0,0],[0.1,0.5,0.5],[4.neg,4.neg,4.neg,0]).asSignal(1024);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(peak, attack / peak) ++ Array.fill(signal.size - peak - 1, dicay / (signal.size - peak - 1));
enva = Env(rip.asArray, times);
wt = enva.asSignal(1024).asWavetable;
~senv.loadCollection(wt);
//enva.plot;
		}.value;
);
0.3.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{

arg gain=1,lowend=20,s_size=1,room=1,drive=0,au=0,sb=0,mag1=1,mag2=1,elosc=1,
erate=1,azrot=0,elrot=0,azrot1=1,elrot1=1,az1=0,el1=0,
c=0,timbr=1,az=0,el=0,dicay=16,attack=2,sc=10,ssc=5,mix=0,rect=4,s1,s2,s3,s4,
busArray = #[0,1,2,3,4,5,6,7],dist=1,harm=1,rx=0,ry=0,rz=0,mrange=1,lim=1,hold=4;

var fund,fu=8,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0,tremolo=32;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy,pen;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,envf,pan,pan11,pan22,pan33,pan44;
var g_ch1,g_ch2,g_ch3,g_ch4,mp,mps,mpf,x,y,z,mag_x,mag_y,mag_z,cm,cm1,cm2;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;
var peak, times,signal,rip,enva,key,tx,ty,tz,view,x1,y1,z1;
var	peak1,times1,signal1,rip1,envb,pan1,pan2,pan3,pan4,xc,yc,zc,xc1,yc1,zc1;
var vanish=2,perspective,revm,rot,r1,r2,r3,th,ph,aaz,eel,rrr,select;
var synthx,synthy,freq,sigx,sigy,mdistance,th1,ph1,sumaz,sumel;
var mp_x1,mp_y1,mp_z1,mps_x1,mps_y1,mps_z1,mpf_x1,mpf_y1,mpf_z1;
var b_x1,b_y1,b_z1,s_x1,s_y1,s_z1,freq11,freq22,freq33,amp11,amp22;
var amp33,sig11,sig22,sig33,phasex1,phasey1,phasez1,envenv,p1,p2,p3,wt,perspective1;
var c11,c22,c33,siga,sigb,mag_x1,mag_y1,mag_z1,decay=4,synthx1,synthy1,sigx1,sigy1;
var ths,phs,ths1,phs1,azpls,elpls,azpls1,elpls1,azpl,elpl,azpl1,elpl1,c1a,c2a,c3a,c11a,c22a,c33a;
var freq1fm,freq2fm,freq3fm,amp1fm,amp2fm,amp3fm,freq11fm,freq22fm,freq33fm,amp11fm,amp22fm,amp33fm;
var c1ar,c2ar,c3ar,c11ar,c22ar,c33ar,c1br,c2br,c3br,c11br,c22br,c33br;


///fund
expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);
gain=gain*harm.reciprocal;
gain=gain*100;

//////////pbind stack env
/*signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env([0,1,1,0],[1,1,1],[4.neg,0,4]).asSignal(~signalSizee);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(signal.size - peak - 1, hold / (signal.size - peak - 1));
enva = Env(rip.asArray, times);
env = EnvGen.ar(enva,levelScale:gain,doneAction:2);*/
env=gain;
//osc data pbind

//aaz=atan2(r1,r2);
//eel=atan2(r3, hypot(r1,r2));

////oscilarot bank select not cpu friendly
/*xx = (~set * cos(el) * cos(az)).round(1).asInteger.abs;
yy = (~set * cos(el) * sin(az)).round(1).asInteger.abs;
zz = (~set * sin(el)).round(1).asInteger.abs;
px=Select.kr(xx,~cx);
py=Select.kr(yy,~cy);
pz=Select.kr(zz,~cz);
azs=atan2(px,py);
els=atan2(pz, hypot(px,py));*/

/*azpl=In.kr(~controlBus_ra1.index).lag(0.01)/10;
elpl=In.kr(~controlBus_re1.index).lag(0.01)/10;
azpl1=In.kr(~controlBus_ra2.index).lag(0.01)/10;
elpl1=In.kr(~controlBus_re2.index).lag(0.01)/10;
azpls=In.kr(~controlBus_ra1.index).lag(0.01);
elpls=In.kr(~controlBus_re1.index).lag(0.01);
azpls1=In.kr(~controlBus_ra1.index).lag(0.01);
elpls1=In.kr(~controlBus_re2.index).lag(0.01);*/

/*azpl=azrot.lag(0.01)/rect;
elpl=elrot.lag(0.01)/rect;
azpl1=azrot1.lag(0.01)/rect;
elpl1=elrot1.lag(0.01)/rect;
azpls=azrot.lag(0.01);
elpls=elrot.lag(0.01);
azpls1=azrot1.lag(0.01);
elpls1=elrot1.lag(0.01);

th=(az+azpl).wrap(pi.neg,pi);
ph=(el+elpl).wrap(0.5pi.neg,0.5pi);

th1=(az1+azpl1).wrap(pi.neg,pi);
ph1=(el1+elpl1).wrap(0.5pi.neg,0.5pi);

ths=(az+azpls).wrap(pi.neg,pi);
phs=(el+elpls).wrap(0.5pi.neg,0.5pi);

ths1=(az1+azpls1).wrap(pi.neg,pi);
phs1=(el1+elpls1).wrap(0.5pi.neg,0.5pi);*/

/////osc data
th=(az).wrap(pi.neg,pi);
ph=(el).wrap(0.5pi.neg,0.5pi);

th1=(az1).wrap(pi.neg,pi);
ph1=(el1).wrap(0.5pi.neg,0.5pi);

ths=(az).wrap(pi.neg,pi);
phs=(el).wrap(0.5pi.neg,0.5pi);

ths1=(az1).wrap(pi.neg,pi);
phs1=(el1).wrap(0.5pi.neg,0.5pi);

///cardioid
x = (harm*cos(ph)*cos(th))+(cos(harm*ph)*cos(harm*th));
y = (harm*cos(ph)*sin(th))+(cos(harm*ph)*sin(harm*th));
z = (harm*sin(ph))+(sin(harm*ph));

x1 = (harm*cos(ph1)*cos(th1))+(cos(harm*ph1)*cos(harm*th1));
y1 = (harm*cos(ph1)*sin(th1))+(cos(harm*ph1)*sin(harm*th1));
z1 = (harm*sin(ph1))+(sin(harm*ph1));

xc = (harm*cos(phs)*cos(ths))+(cos(harm*phs)*cos(harm*ths));
yc = (harm*cos(phs)*sin(ths))+(cos(harm*phs)*sin(harm*ths));
zc = (harm*sin(phs))+(sin(harm*phs));

xc1 = (harm*cos(phs1)*cos(ths1))+(cos(harm*phs1)*cos(harm*ths1));
yc1 = (harm*cos(phs1)*sin(ths1))+(cos(harm*phs1)*sin(harm*ths1));
zc1 = (harm*sin(phs1))+(sin(harm*phs1));

///xyz
/*x = (cos(ph)*cos(th));
y = (cos(ph)*sin(th));
z = (sin(ph));

x1 = (cos(ph1)*cos(th1));
y1 = (cos(ph1)*sin(th1));
z1 = (sin(ph1));

xc = (cos(phs)*cos(ths));
yc = (cos(phs)*sin(ths));
zc = (sin(phs));

xc1 = (cos(phs1)*cos(ths1));
yc1 = (cos(phs1)*sin(ths1));
zc1 = (sin(phs1));*/


mdistance = ((x - x1).squared + (y - y1).squared + (z - z1).squared).sqrt;

///osc
mp_x = (sc)  * x;
mp_y = (sc)  * y;
mp_z = (sc)  * z;
mps_x = (ssc) * xc;
mps_y = (ssc) * yc;
mps_z = (ssc) * zc;
mpf_x =pi* x;
mpf_y =pi* y;
mpf_z =pi* z;

mp_x1 = (sc)  * x1;
mp_y1 = (sc)  * y1;
mp_z1 = (sc)  * z1;
mps_x1 = (ssc) * xc1;
mps_y1 = (ssc) * yc1;
mps_z1 = (ssc) * zc1;
mpf_x1 =pi* x1;
mpf_y1 =pi* y1;
mpf_z1 =pi* z1;

key=Select.kr(au,~scale);

b_x=2.pow(mp_x.round(1)/16256);
b_y=2.pow(mp_y.round(1)/16256);
b_z=2.pow(mp_z.round(1)/16256);

s_x=2.pow(Select.kr(mps_x.round(1).abs,key).asInteger /12);
s_y=2.pow(Select.kr(mps_y.round(1).abs,key).asInteger /12);
s_z=2.pow(Select.kr(mps_z.round(1).abs,key).asInteger /12);

b_x1=2.pow(mp_x1.round(1)/16256);
b_y1=2.pow(mp_y1.round(1)/16256);
b_z1=2.pow(mp_z1.round(1)/16256);

s_x1=2.pow(Select.kr(mps_x1.round(1).abs,key).asInteger /12);
s_y1=2.pow(Select.kr(mps_y1.round(1).abs,key).asInteger /12);
s_z1=2.pow(Select.kr(mps_z1.round(1).abs,key).asInteger /12);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;

amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

freq11=(fund)*b_x1*s_x1;
freq22=(fund)*b_y1*s_y1;
freq33=(fund)*b_z1*s_z1;

amp11=b_x1.reciprocal*expansion.reciprocal*s_x1.reciprocal;
amp22=b_y1.reciprocal*expansion.reciprocal*s_y1.reciprocal;
amp33=b_z1.reciprocal*expansion.reciprocal*s_z1.reciprocal;

//fm
freq1fm=((fund)*b_x*s_x)/rect;
freq2fm=((fund)*b_y*s_y)/rect;
freq3fm=((fund)*b_z*s_z)/rect;

amp1fm=freq1fm*0.1;
amp2fm=freq2fm*0.1;
amp3fm=freq3fm*0.1;

freq11fm=((fund)*b_x1*s_x1)/rect;
freq22fm=((fund)*b_y1*s_y1)/rect;
freq33fm=((fund)*b_z1*s_z1)/rect;

amp11fm=freq11fm*0.1;
amp22fm=freq22fm*0.1;
amp33fm=freq33fm*0.1;

///other phase sets
//phasex=(Complex(1,mod_x).theta*2);
//phasey=(Complex(1,mod_y).theta*2);
//phasez=(Complex(1,mod_z).theta*2);
//phasex=atan2(mod_x,mod_y);
//phasey=atan2(mod_y,mod_z);
//phasez=atan2(mod_z,mod_x);
phasex=mpf_x;
phasey=mpf_y;
phasez=mpf_z;

phasex1=mpf_x1;
phasey1=mpf_y1;
phasez1=mpf_z1;

//osc
c1a=(SinOsc.ar(freq1fm,phase:phasex,mul:amp1fm));
c2a=(SinOsc.ar(freq2fm,phase:phasey,mul:amp2fm));
c3a=(SinOsc.ar(freq3fm,phase:phasez,mul:amp3fm));

c11a=(SinOsc.ar(freq11fm,phase:phasex,mul:amp11fm));
c22a=(SinOsc.ar(freq22fm,phase:phasey,mul:amp22fm));
c33a=(SinOsc.ar(freq33fm,phase:phasez,mul:amp33fm));

//c1a=0;c2a=0;c3a=0;c11a=0;c22a=0;c33a=0;

c1=BPF.ar((Osc.ar(~wt.bufnum,freq1+c1a,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1+c1a,phase:phasex)),freq1+c1a,heavy,amp1);
c2=BPF.ar((Osc.ar(~wt.bufnum,freq2+c2a,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2+c2a,phase:phasey)),freq2+c2a,heavy,amp2);
//c3=BPF.ar((Osc.ar(~wt.bufnum,freq3+c3a,phase:phasez,mul:1200).abs*
//SinOsc.ar(freq3+c3a,phase:phasez)),freq3+c3a,heavy,amp3);

c11=BPF.ar((Osc.ar(~wt.bufnum,freq11+c11a,phase:phasex1,mul:1200).abs*
SinOsc.ar(freq11+c11a,phase:phasex1)),freq11+c11a,heavy,amp11);
c22=BPF.ar((Osc.ar(~wt.bufnum,freq22+c22a,phase:phasey1,mul:1200).abs*
SinOsc.ar(freq22+c22a,phase:phasey1)),freq22+c22a,heavy,amp22);
//c33=BPF.ar((Osc.ar(~wt.bufnum,freq33+c33a,phase:phasez1,mul:1200).abs*
//SinOsc.ar(freq33+c33a,phase:phasez)),freq33+c33a,heavy,amp33);


//////rectifier
c1ar=(SinOsc.ar(freq1fm*(rect*2),phase:phasex,mul:amp1fm*(rect*2)));
c2ar=(SinOsc.ar(freq2fm*(rect*2),phase:phasey,mul:amp1fm*(rect*2)));
//c3ar=(SinOsc.ar(freq3fm*(rect*2),phase:phasez,mul:amp1fm*(rect*2)));
c1br=(SinOsc.ar(freq1fm*(rect),phase:phasex,mul:amp1fm*(rect)));
c2br=(SinOsc.ar(freq2fm*(rect),phase:phasey,mul:amp2fm*(rect)));
//c3br=(SinOsc.ar(freq3fm*(rect),phase:phasez,mul:amp3fm*(rect)));

c11ar=(SinOsc.ar(freq11fm*(rect*2),phase:phasex1,mul:amp11fm*(rect*2)));
c22ar=(SinOsc.ar(freq22fm*(rect*2),phase:phasey1,mul:amp22fm*(rect*2)));
//c33ar=(SinOsc.ar(freq33fm*(rect*2),phase:phasez1,mul:amp33fm*(rect*2)));
c11br=(SinOsc.ar(freq11fm*(rect),phase:phasex1,mul:amp11fm*(rect)));
c22br=(SinOsc.ar(freq22fm*(rect),phase:phasey1,mul:amp22fm*(rect)));
//c33br=(SinOsc.ar(freq33fm*(rect),phase:phasez1,mul:amp33fm*(rect)));

//c1ar=0;c2ar=0;c3ar=0;c11ar=0;c22ar=0;c33ar=0;c1br=0;c2br=0;c3br=0;c11br=0;c22br=0;c33br=0;

sig1=((((SinOsc.ar(freq1*(rect*2)+c1ar,phase:phasex,mul:amp1)).abs+(amp1))*
(SinOsc.ar(freq1*(rect)+c1br,phase:phasex,mul:amp1))).abs+(amp1))*c1*5;
sig2=((((SinOsc.ar(freq2*(rect*2)+c2ar,phase:phasey,mul:amp2)).abs+(amp2))*
(SinOsc.ar(freq2*(rect)+c2br,phase:phasey,mul:amp2))).abs+(amp2))*c2*5;
//sig3=((((SinOsc.ar(freq3*(rect*2)+c3ar,phase:phasez,mul:amp3)).abs+(amp3))*
//(SinOsc.ar(freq3*(rect)+c3br,phase:phasez,mul:amp3))).abs+(amp3))*c3*5;

sig11=((((SinOsc.ar(freq11*(rect*2)+c11ar,phase:phasex1,mul:amp11)).abs+(amp11))*
(SinOsc.ar(freq11*(rect)+c11br,phase:phasex1,mul:amp11))).abs+(amp11))*c11*5;
sig22=((((SinOsc.ar(freq22*(rect*2)+c22ar,phase:phasey1,mul:amp22)).abs+(amp22))*
(SinOsc.ar(freq22*(rect)+c22br,phase:phasey1,mul:amp22))).abs+(amp22))*c22*5;
//sig33=((((SinOsc.ar(freq33*(rect*2)+c33ar,phase:phasez1,mul:amp33)).abs+(amp33))*
//(SinOsc.ar(freq33*(rect)+c33br,phase:phasez1,mul:amp33))).abs+(amp33))*c33*5;

/*sig1=c1;
sig2=c2;
sig11=c11;
sig22=c22;*/

//////propagation///perspective
view=harm/dist;
perspective = view / (view + z + (view/vanish));
perspective1 = view / (view + z1 + (view/vanish));

sig1=sig1*mp_x.sign*perspective*env;
sig2=sig2*mp_y.sign*perspective*env;

sig11=sig11*mp_x1.sign*perspective1*env;
sig22=sig22*mp_y1.sign*perspective1*env;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);

/////compresion
threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig11=Compander.ar(sig11,c11,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig22=Compander.ar(sig22,c22,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);


///reverb
revm=perspective.linlin(0,0.6,0,1);
sig1=FreeVerb.ar(sig1,revm+(mix/10),room,perspective);
sig2=FreeVerb.ar(sig2,revm+(mix/10),room,perspective);
sig11=FreeVerb.ar(sig11,revm+(mix/10),room,perspective);
sig22=FreeVerb.ar(sig22,revm+(mix/10),room,perspective);

/////////spat
///pan
/*select=Spherical(~vertices,az,el);
//rrr=Spherical(pi,0.5pi,0.125pi);
rrr=Spherical(pi,Select.kr(select.x.abs.round(1),~azth),Select.kr(select.x.abs.round(1),~elth));
r1 = SinOsc.kr(rx.lag(0.01),rrr.x,0.57735026918963);
r2 = SinOsc.kr(ry.lag(0.01),rrr.y,0.57735026918963);
r3 = SinOsc.kr(rz.lag(0.01),rrr.z,0.57735026918963);
//pan=LFNoise1.ar(elosc,pi);
pan=((r1+r2)*r3)/mix.reciprocal/2;
pan=pan.abs;
pan1=SinOsc.ar(pan,~az.[0]).range(pi.neg,pi).lag(0.01);
pan2=SinOsc.ar(pan,~az.[1]).range(pi.neg,pi).lag(0.01);
pan3=SinOsc.ar(pan,~az.[2]).range(pi.neg,pi).lag(0.01);
pan4=SinOsc.ar(pan,~az.[3]).range(pi.neg,pi).lag(0.01);
pan11=SinOsc.ar(pan,~el.[0]).range(0.5pi.neg,0.5pi).lag(0.01);
pan22=SinOsc.ar(pan,~el.[1]).range(0.5pi.neg,0.5pi).lag(0.01);
pan33=SinOsc.ar(pan,~el.[2]).range(0.5pi.neg,0.5pi).lag(0.01);
pan44=SinOsc.ar(pan,~el.[3]).range(0.5pi.neg,0.5pi).lag(0.01);
				*/
////spherical harmonics
/*mag_x=((Complex(cos(az*harm),cos(az*harm)).rho/(2.sqrt))*(Complex(cos(el),cos(el)).rho/(2.sqrt)));
mag_y=((Complex(sin(az*harm),sin(az*harm)).rho/(2.sqrt))*(Complex(cos(el),cos(el)).rho/(2.sqrt)));
mag_z=(Complex(sin(el*harm),sin(el*harm)).rho/(2.sqrt));

mag_x1=((Complex(cos(az1*harm),cos(az1*harm)).rho/(2.sqrt))*(Complex(cos(el1),cos(el1)).rho/(2.sqrt)));
mag_y1=((Complex(sin(az1*harm),sin(az1*harm)).rho/(2.sqrt))*(Complex(cos(el1),cos(el1)).rho/(2.sqrt)));
mag_z1=(Complex(sin(el1*harm),sin(el1*harm)).rho/(2.sqrt));


p1=((c11+c1)*mag_x)/(2.sqrt);
p2=((c22+c2)*mag_y)/(2.sqrt);
p3=((c33+c3)*mag_z)/(2.sqrt);*/

/*sumaz=(th+th1).wrap(pi.neg,pi);
sumel=(ph+ph1).wrap(0.5pi.neg,0.5pi);
(
g_ch1=
(p1.abs.range(0.001,1)*cos(sumel+pan11)*cos((sumaz+pan1).wrap(pi.neg,pi))*
p1.range(0.001,1)*cos(~el.[0])*cos(~az.[0]))
+
(p2.abs.range(0.001,1)*cos(sumel+pan11)*sin((sumaz+pan1).wrap(pi.neg,pi))*
 p2.range(0.001,1)*cos(~el.[0])*sin(~az.[0]))
+
(p3.abs.range(0.001,1)*sin(sumel+pan11)*
 p3.range(0.001,1)*sin(~el.[0]));

g_ch2=
(p1.abs.range(0.001,1)*cos(sumel+pan22)*cos((sumaz+pan2).wrap(pi.neg,pi))*
 p1.range(0.001,1)*cos(~el.[1])*cos(~az.[1]))
+
(p2.abs.range(0.001,1)*cos(sumel+pan22)*sin((sumaz+pan2).wrap(pi.neg,pi))*
 p2.range(0.001,1)*cos(~el.[1])*sin(~az.[1]))
+
(p3.abs.range(0.001,1)*sin(sumel+pan22)*
 p3.range(0.001,1)*sin(~el.[1]));

g_ch3=
(p1.abs.range(0.001,1)*cos(sumel+pan33)*cos((sumaz+pan3).wrap(pi.neg,pi))*
 p1.range(0.001,1)*cos(~el.[2])*cos(~az.[2]))
+
(p2.abs.range(0.001,1)*cos(sumel+pan33)*sin((sumaz+pan3).wrap(pi.neg,pi))*
 p2.range(0.001,1)*cos(~el.[2])*sin(~az.[2]))
+
(p3.abs.range(0.001,1)*sin(sumel+pan33)*
 p3.range(0.001,1)*sin(~el.[2]));

g_ch4=
(p1.abs.range(0.001,1)*cos(ph+pan44)*cos((sumaz+pan4).wrap(pi.neg,pi))*
 p1.range(0.001,1)*cos(~el.[3])*cos(~az.[3]))
+
(p2.abs.range(0.001,1)*cos(ph+pan44)*sin((sumaz+pan4).wrap(pi.neg,pi))*
 p2.range(0.001,1)*cos(~el.[3])*sin(~az.[3]))
+
(p3.abs.range(0.001,1)*sin(sumel+pan44)*
 p3.range(0.001,1)*sin(~el.[3]));
);*/

///amp distortion
synthx=Pulse.ar(220,mix.linexp(0,1,0.999999,0.5),1,1)*sig1;
synthy=Pulse.ar(220,mix.linexp(0,1,0.999999,0.5),1,1)*sig2;
synthx1=Pulse.ar(220,mix.linexp(0,1,0.999999,0.5),1,1)*sig11;
synthy1=Pulse.ar(220,mix.linexp(0,1,0.999999,0.5),1,1)*sig22;
//synthx=sig1;
//synthy=sig2;
//synthx1=sig11;
//synthy1=sig22;

synthx=(synthx).fold2((mrange*mdistance));
synthy=(synthy).fold2(mrange*mdistance);
synthx1=(synthx1).fold2((mrange*mdistance));
synthy1=(synthy1).fold2(mrange*mdistance);
//synthx=(synthx*gain.linli.n(0,1,0.1,2)).fold2((mrange*mdistance));
//synthy=(synthy*gain.linlin(0,1,0.1,2)).fold2(mrange*mdistance);

///vca env///dont burn out, vca and env can ba applied via eurorack modular external
/*signal1 = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal1 = signal1.rotate(signal1.size div: 2);
peak1 = signal1.abs.maxIndex.max(1);
rip1 = Env.perc(0.5,0.5).asSignal(~signalSizee);
rip1 = rip1 * (1 + (signal1 / tremolo));
rip1 = rip1.normalize;
peak1 = peak1.min(signal1.size - 2).max(1);
times1 =Array.fill(peak1, attack / peak1) ++ Array.fill(signal1.size - peak1 - 1, dicay / (signal1.size - peak1 - 1));
envb = Env(rip1.asArray, times1);
envenv = EnvGen.ar(envb,gate:LFPulse.kr(erate,width:0.01));*/
envenv=1;

sigx=Limiter.ar(LPF.ar(HPF.ar(synthx*envenv,lowend),18000),lim);
sigy=Limiter.ar(LPF.ar(HPF.ar(synthy*envenv, lowend),18000),lim);
sigx1=Limiter.ar(LPF.ar(HPF.ar(synthx1*envenv,lowend),18000),lim);
sigy1=Limiter.ar(LPF.ar(HPF.ar(synthy1*envenv, lowend),18000),lim);

Out.ar(busArray.[0],LeakDC.ar(sigx));
Out.ar(busArray.[1],LeakDC.ar(sigy));
Out.ar(busArray.[0],LeakDC.ar(sigx1));
Out.ar(busArray.[1],LeakDC.ar(sigy1));

////pan
//Out.ar(busArray.[0],LeakDC.ar(sig1*env));
//Out.ar(busArray.[1],LeakDC.ar(sig2*env));
//Out.ar(busArray.[0],LeakDC.ar(sig1*env*g_ch1));
//Out.ar(busArray.[0],LeakDC.ar(sig2*env*g_ch1));
//Out.ar(busArray.[1],LeakDC.ar(sig1*env*g_ch2));
//Out.ar(busArray.[1],LeakDC.ar(sig2*env*g_ch2));
//Out.ar(busArray.[2],LeakDC.ar(sig1*env*g_ch3));
//Out.ar(busArray.[2],LeakDC.ar(sig2*env*g_ch3));
//Out.ar(busArray.[3],LeakDC.ar(sig1*env*g_ch4));
//Out.ar(busArray.[3],LeakDC.ar(sig2*env*g_ch4));
//no pan mono
//Out.ar(busArray.[2],LeakDC.ar(sig3*env*mag_z))
//Out.ar(busArray.[0],LeakDC.ar(sig1*env)/2.sqrt);
//Out.ar(busArray.[0],LeakDC.ar(sig2*env)/2.sqrt);

///animation send buses
//Out.kr(~controlBus_1.index,Amplitude.kr((c1),mul:env));
//Out.kr(~controlBus_2.index,Amplitude.kr((c2),mul:env));
//Out.kr(~controlBus_3.index,Amplitude.kr((c3),mul:env));

}).add;
);
0.6.wait;
~erate=1;
/////////////////////////////////////////////////////////////////////////////////////////////////////////pattern
({
var m1=1.neg, m2=1.neg;
var m3=1.neg,n=0,bank=4,rhythm=4,time=32.reciprocal,beat=1;
var durx=[],dury=[],durz=[],durx1=[],dury1=[],durz1=[];
var dx=[],dy=[],dz=[],bx,by,bz,durx2,dury2,durz2;

(
~azrth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elrth=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

(
~kol=~vertices.rand;~kol1=~vertices.rand;~kol2=~vertices.rand;~kol3=~vertices.rand;
~azrth=[~azth.[~kol],~azth.[~kol1],~azth.[~kol2],~azth.[~kol3]];
~elrth=[~elth.[~kol],~elth.[~kol1],~elth.[~kol2],~elth.[~kol3]];
);

~dur=[];

bank.do{
   // m1=m2=m3=~vertices.rand;
m1=m1+1;m2=m2+1;m3=m3+1;
    bx=1.collect{
        var az, el, x, y, z;
        az = ~azrth.[m1];
        el = ~elrth.[m1];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(x).round(time)};

   by=1.collect{
        var az, el, x, y, z;
        az = ~azrth.[m2];
        el = ~elrth.[m2];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(y).round(time)};

    bz=1.collect{
        var az, el, x, y, z;
        az = ~azrth.[m3];
        el = ~elrth.[m3];
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);
        2.pow(z).round(time)};

   // m1=1.neg; m2=1.neg; m3=1.neg;

    dx=dx++bx;
    dy=dy++by;
    dz=dz++bz;

   // bx=[]; by=[]; bz=[];
};

n=0;
rhythm.do{ durx=durx++dx.[n]; n=n+1;}; n=0;
rhythm.do{ dury=dury++dy.[n]; n=n+1;}; n=0;
rhythm.do{ durz=durz++dz.[n]; n=n+1;}; n=1;
(rhythm-1).do{ durx1=durx1++dx.[n]; n=n+1;}; n=1;
(rhythm-1).do{ dury1=dury1++dy.[n]; n=n+1;}; n=1;
(rhythm-1).do{ durz1=durz1++dz.[n]; n=n+1;}; n=0;
durx2=[dx.[4]]++durx1.reverse;
dury2=[dy.[4]]++dury1.reverse;
durz2=[dz.[4]]++durz1.reverse;
//~dur=~dur++durx++dury++durz++durx2++dury2++durz2;
~dur=~dur++durx++dury++durz;
}.value);

({
var a,b,c,d;
a=[~dur.[0]+~dur.[1]+~dur.[2]];
b=[~dur.[3]+~dur.[4]+~dur.[5]];
c=[~dur.[6]+~dur.[7]+~dur.[8]];
d=[~dur.[9]+~dur.[10]+~dur.[11]];
~durt=a++b++c++d;
}.value);
~seqt= Pseq(~durt ,inf).asStream;
~seqt= Pseq(~dur ,inf).asStream;

~intervalt=4;
~dur=~dur*~intervalt;
~dursum=~dur.sum;

////l system boolean
({
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
var word = "A";
var string_temp = "";
var iter = 5;
var dictnotes = IdentityDictionary[\A ->0, \B -> 1];
 ~lseq=[];
iter.do({
word.asArray.do({|i|string_temp = string_temp ++ dict[i.asSymbol];});
word = string_temp;string_temp = "";});
word.postln;
word.do({|i| ~lseq = ~lseq ++ dictnotes[i.asSymbol];});
~lseq.postln;
}.value);

////args globals
~gain=1;~drive=0;~c=0;~attack=0.01;~decay=0.5;~s_size=1;~erate=1;
~lowend=20;~room=0;~sscb=26;~pan1=0.001;~pan2=0.001;
~gainb=1;~driveb=0;~cb=0;~attackb=0.01;~decayb=1;
~s_sizeb=1;~lowendb=20;~roomb=0;~scb=1;~lim1=1;~lim2=1;
~incr1=0;~incr2=0;~sc=1;~gold=((1+5.sqrt)/2);
~silver=(1+2.sqrt);~mixb=0;~rectb=16;~dist1=1;~dist2=1;~mr1=1;~mr2=1;
~incr=0;~ssc=26;~mix=0;~rect=16;~s=0;~azimuth=1;~elevation=1;~azimuth1=1;~elevation1=1;
~alternating=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];
~hor=0;~lat=0;~shape1=1;~shape2=1;
~tempo=1;
~clock = TempoClock(1);
TempoClock.default.tempo_(1);

///feed

(
{
Routine({loop{
~nn=~set.rand;
~nnn=~set.rand;
(~dursum).wait; // frame duration
};
}).play(~clock);
}.defer
);
(
SynthDef.new(\run,{
arg az=0,el=0,az1=0,el1=0;
Out.kr(~controlBus_ra1.index,Pulse.kr(1,1,az,az));
Out.kr(~controlBus_re1.index,Pulse.kr(1,1,el,el));
Out.kr(~controlBus_ra2.index,Pulse.kr(1,1,az1,az1));
Out.kr(~controlBus_re2.index,Pulse.kr(1,1,el1,el1));
}).add;
);
0.1.wait;
~synths=Synth.new(\run).register;

(
{
var x,y,z,px,py,pz,x1,y1,z1,px1,py1,pz1;
Routine({loop{
x=~nn;
x1=~nnn;
px=~cx.[x];
py=~cy.[x];
pz=~cz.[x];
px1=~cx.[x1];
py1=~cy.[x1];

pz1=~cz.[x1];
~shape1=(Cartesian(~magx.[x],~magy.[x],~magz.[x]).rho/(2.sqrt));
~shape2=(Cartesian(~magx.[x1],~magy.[x1],~magz.[x1]).rho/(2.sqrt));
~azimuth=Cartesian(px,py,pz).theta;
~elevation=Cartesian(px,py,pz).phi;
~azimuth1=Cartesian(px1,py1,pz1).theta;
~elevation1=Cartesian(px1,py1,pz1).phi;
~synths.set(\az,~azimuth,\el,~elevation,\az1,~azimuth1,\el1,~elevation1);
(~timbr_dur).wait;}
}).play;
}.defer
);

~pattern = Pdef(\1,
//Pbind( \instrument,\synth,
Pmono( \synth,
//\dur, Pseq(~dur ,inf),
\dur,~timbr_dur*2,
\hold,Pseq(~dur ,inf),
\s_size,Pfunc { ~s_size },
\lowend,Pfunc { ~lowend },
\room,Pfunc { ~room },
\gain,Pfunc { ~gain },
\au,Pseq([0,0],inf),
\sc, Pfunc { ~sc },
\ssc, Pfunc{~ssc},
\c, Pfunc { ~c },
\drive, Pfunc { ~drive },
\dist, Pfunc { ~dist1 },
\rect,Pfunc{~rect},
\mrange,Pfunc{ ~mr1},
\lim,Pfunc{ ~lim1},
\mix, Pfunc{~mix},
\az, Pfunc{ ~azimuth},
\el,Pfunc{ ~elevation},
\az1, Pfunc{ ~azimuth1},
\el1,Pfunc{ ~elevation1},
//\azrot,Pfunc{~incr1},
//\elrot,Pfunc{~incr2},
\harm,Pfunc{ ~harm},
\rx,Pfunc{~rotationx},
\ry,Pfunc{ ~rotationy},
\rz,Pfunc{ ~rotationz},
//\s1,Pfunc{(~vertices-1).rand.round(1).asInteger},\s2,Pfunc{(~vertices-1).rand.round(1).asInteger}
//,\s3,Pfunc{(~vertices-1).rand.round(1).asInteger},\s4,Pfunc{(~vertices-1).rand.round(1).asInteger},
\attack,  Pfunc { ~attack },
\dicay, Pfunc { ~decay },
\erate,	Pfunc { ~erate },
\sb,Pseq(~alternating,inf),\mag1,Pfunc{~shape1},\mag2,Pfunc{~shape2},\elosc, Pfunc { ~pan1 };
));
~pattern.play(~clock);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size=550,sk=(size/12),w,rol=0,sz=0.5,wd=3.5,shift=1;
var v1,v2,v3,p1,p2,p3,tx1=2,tx2=2,tx3=2;
var lined=40,run=true,g=((1+5.sqrt)/2);

w = Window("tws", Rect(50, 50, size, size)).front;
~vw1 = UserView(w, Rect(0,0,size,size)).background_(Color.black);
~logView1 = ListView( ~vw1, Rect(0, 0, size, size))
.background_(Color.black).stringColor_(Color.white)
.font_(Font('Arial', 18))
.items_([]);
~logItems1 = List.new;
~log1 = { |msg| {~logItems1.add(msg); if(~logItems1.size > 200) { ~logItems1.removeAt(0);  };
 ~logView1.items_(~logItems1.asArray); ~logView1.value_(~logItems1.size - 1); }.defer;};

(
~sl1=Knob.new(~vw1, Rect.new(50,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1/32,4).round(1/32).postln;
~clock.tempo_(value);
~log1.(value.asString);
});
~st1=StaticText(~vw1,Rect(50,50+sk,sk+20,sk)).string_("tempo")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl2=Knob.new(~vw1, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.00001,0.1).postln;
//~rotation=value;
~pan1=obj.value.linlin(0,1,0.000001,0.5);
~rotationz=value;
~log1.(value.asString);
});
~st2=StaticText(~vw1,Rect(150,50+sk,sk+20,sk)).string_("rz")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl3=Knob.new(~vw1, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value1;
~log1.(value1.asString);
});
~st3=StaticText(~vw1,Rect(250,50+sk,sk+20,sk)).string_("s_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl4=Knob.new(~vw1, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,1,16256*~octaves).round(1).asInteger.postln;
~sc=value2;
~log1.(value2.asString);
});
~st4=StaticText(~vw1,Rect(350,50+sk,sk+20,sk)).string_("t_range")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl5=Knob.new(~vw1, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linlin(0,1,1,8).postln;
~rect=value2;
~log1.(value2.asString);
});
~st5=StaticText(~vw1,Rect(450,50+sk,sk+20,sk)).string_("overdrive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl6=Knob.new(~vw1, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linlin(0,1,(16256*4).neg,0).round(1).asInteger.postln;
~drive=value1;
~log1.(value1.asString);
});
~st6=StaticText(~vw1,Rect(50,(50+sk+50+25+sk),sk+20,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl7=Knob.new(~vw1, Rect.new(150,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,0.03,0.3).postln;
~s_size=value1;
value2=obj.value.linexp(0,1,100,20).postln;
~lowend=value2;
~lim1=obj.value.linexp(0,1,0.001,0.8).postln;
~log1.(value2.asString);
});
~st7=StaticText(~vw1,Rect(150,(50+sk+50+25+sk),sk+20,sk)).string_("comp")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl8=Knob.new(~vw1, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.01,8).postln;
~attack=value2;
~log1.(value2.asString);
});
~st8=StaticText(~vw1,Rect(250,(50+sk+50+25+sk),sk+20,sk)).string_("attack")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl9=Knob.new(~vw1, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value1=obj.value.linexp(0,1,1,16).postln;
~decay=value1;
~log1.(value1.asString);
});
~st9=StaticText(~vw1,Rect(350,(50+sk+50+25+sk),sk+20,sk)).string_("decay")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl10=Knob.new(~vw1, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2,g=((1+5.sqrt)/2),s=(1+2.sqrt);
value1=obj.value.linexp(0,1,0.00001,0.1).postln;
~incr1=obj.value.linexp(0,1,0.0001,(2pi-(2pi/s)));
~rotationx=value1;
~log1.(value1.asString);
});
~st10=StaticText(~vw1,Rect(450,(50+sk+50+25+sk),sk+20,sk)).string_("rx")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl11=Knob.new(~vw1, Rect.new(50,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value1,value2;
value2=obj.value.linexp(0,1,0.00001,0.1).postln;
~incr2=obj.value.linexp(0,1,0.0001,(pi-(pi/g)));
~rotationy=value2;
~log1.(value2.asString);
});
~st11=StaticText(~vw1,Rect(50,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("ry")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s12=Knob.new(~vw1, Rect.new(150,(50+sk+50+sk+25+25+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*~octaves).round(1).asInteger.postln;
~c=value;
~log1.(value.asString);
});
~st12=StaticText(~vw1,Rect(150,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl13=Knob.new(~vw1, Rect.new(250,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,2pi).postln;
~gain=value;
~log1.(value.asString);
});
~st13=StaticText(~vw1,Rect(250,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl14=Knob.new(~vw1, Rect.new(350,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room=value;
~log1.(value.asString);
});
~st14=StaticText(~vw1,Rect(350,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("room")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl15=Knob.new(~vw1, Rect.new(450,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,1).postln;
~mix=value;
~log1.(value.asString);
});
~st15=StaticText(~vw1,Rect(450,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("fmix")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl16=Knob.new(~vw1, Rect.new(50,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse1=value;
~log1.(value.asString);
});
~st16=StaticText(~vw1,Rect(50,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("fuse1")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s117=Knob.new(~vw1, Rect.new(150,(50+sk+50+sk+25+25+sk+50+sk+50), sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1.01,1000).postln;
~fuse2=value;
~log1.(value.asString);
});
~s117=StaticText(~vw1,Rect(150,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("fuse2")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s118=Knob.new(~vw1, Rect.new(250,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,16256,1);
~fuse=value;
~mr1=obj.value.linexp(0,1,1,0.01).postln;
~log1.(~mr1.asString);
});
~s118=StaticText(~vw1,Rect(250,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("mlimit")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s119=Knob.new(~vw1, Rect.new(350,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1,7).round(1).postln;
~harm=value;
~log1.(value.asString);
});
~s119=StaticText(~vw1,Rect(350,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("harm")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl20=Knob.new(~vw1, Rect.new(450,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var value,v;
value=obj.value.linexp(0,1,100.01,0.01).postln;
~dist1=value;
~log1.(value.asString);
});
~sl20=StaticText(~vw1,Rect(450,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("perspective")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
}.defer
);
}); Tdef(\drone).play;
}
)



////midi









/////space symmetric, for rhythm, music keys, timbre or vbap
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////spaces
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////tetrahedron
(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////cube
(
~azimuth=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////octahedron
(
~azimuth=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~elevation=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////icosahedron
(
~azimuth=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~elevation=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////dodecahedron
(
~azimuth=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~elevation=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Rhombic dodecahedron
(
~azimuth=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~elevation=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////cuboctahedron
(
~azimuth=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~elevation=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Rhombic Triacontahedron
(
~azimuth=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~elevation=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////icosidodecahedron
(
~azimuth=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~elevation=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];
)*/