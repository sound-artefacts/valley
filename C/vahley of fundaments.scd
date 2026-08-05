///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
//s.makeGui(w);
//s.meter;
//s.freqscope;
//s.scope;
);
s.waitForBoot{
Tdef(\drone, {
~frames=0.1;
/////axis array
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~azi=[]; ~eli=[];
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
~azi = ~azi ++ azimuth;
~eli = ~eli ++ elevation;
az1=0; el1=0; az2=0; el2=0;
};
}.value;
~vertices = 1024;
);
	1.wait;
////animation buses
(
(
~controlBus_s = Bus.control(s, 1);
~controlBus_s1 = Bus.control(s, 1);
~controlBus_s2 = Bus.control(s, 1);
~controlBus_r = Bus.control(s, 1);
~controlBus_shx = Bus.control(s, 1);
~controlBus_shy = Bus.control(s, 1);
~controlBus_shz = Bus.control(s, 1);
~controlBus_wx = Bus.control(s, 1);
~controlBus_wy = Bus.control(s, 1);
~controlBus_wz = Bus.control(s, 1);
~controlBus_points = Bus.control(s, 1);
~controlBus_sh = Bus.control(s, 1);
~scale=Buffer.alloc(s,2048);
~scale1= Buffer.alloc(s,2048);
~scale2= Buffer.alloc(s,2048);
~rotation= Buffer.alloc(s,2048);
~harmx= Buffer.alloc(s,2048);
~harmy= Buffer.alloc(s,2048);
~harmz= Buffer.alloc(s,2048);
~wx= Buffer.alloc(s,2048);
~wy= Buffer.alloc(s,2048);
~wz= Buffer.alloc(s,2048);
~sh= Buffer.alloc(s,2048);
~ps= Buffer.alloc(s,2048);
);
(
{
var signal,wt;
signal=Env([2000,2000],[1]);
wt = signal.asSignal(1024).asWavetable;
~scale.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1,1000,1000,1],[1,1,1],[2,0,2.neg]);
wt = signal.asSignal(1024).asWavetable;
~scale1.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1,1,1000,1],[1,1,1],[2,0,2.neg]);
wt = signal.asSignal(1024).asWavetable;
~scale2.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([1,6,6],[1,1,1],[2,0,2.neg]);
wt = signal.asSignal(1024).asWavetable;
~ps.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt,r;
r=(2pi-(2pi/((1+5.sqrt)/2)));
signal=Env([r/512,0.001,r/512],[1,1],[2.neg,2]);
wt = signal.asSignal(1024).asWavetable;
~rotation.loadCollection(wt);
//signal.plot;
}.value;
{
var signal,wt;
signal=Env([100,1,100],[1,1],[4,0,4.neg]);
wt = signal.asSignal(1024).asWavetable;
~sh.loadCollection(wt);
//signal.plot;
}.value;
);
(
SynthDef.new(\run,{
arg cor=0;
var p,az,el,f1,f2,f3,f=0.1;
//az=Select.kr(cor,~azi);
//el=Select.kr(cor,~eli);
p=Spherical(16256,0,0);
f1=2.pow(p.x.round(1)/16256)*0.01;
f2=2.pow(p.y.round(1)/16256)*0.01;
f3=2.pow(p.x.round(1)/16256)*0.01;
Out.kr(~controlBus_s.index,(Osc.kr(~scale.bufnum,f).abs));
Out.kr(~controlBus_s1.index,(Osc.kr(~scale1.bufnum,f).abs));
Out.kr(~controlBus_s2.index,(Osc.kr(~scale2.bufnum,f).abs));
//Out.kr(~controlBus_r.index,(Osc.kr(~rotation.bufnum,f.rand).abs));
//Out.kr(~controlBus_s1.index,(SinOsc.kr(TExpRand.kr(0.01,0.1,Impulse.kr(f.rand))).range(1,1000)));
//Out.kr(~controlBus_s2.index,(SinOsc.kr(TExpRand.kr(0.01,0.1,Impulse.kr(f.rand))).range(1,1000)));
//Out.kr(~controlBus_r.index,(SinOsc.kr(TExpRand.kr(0.01,0.1,Impulse.kr(f.rand))).range(0.001,0.01)));
Out.kr(~controlBus_shx.index,(SinOsc.kr(f1,f1*pi).range(pi.neg,pi)));
Out.kr(~controlBus_shy.index,(SinOsc.kr(f2,f2*pi).range(pi.neg,pi)));
Out.kr(~controlBus_shz.index,(SinOsc.kr(f3,f3*pi).range(0.5pi.neg,0.5pi)));
//Out.kr(~controlBus_wx.index,(LFNoise0.kr(f1).abs));
//Out.kr(~controlBus_wy.index,(LFNoise0.kr(f2).abs));
//Out.kr(~controlBus_wz.index,(LFNoise0.kr(f3).abs));
//Out.kr(~controlBus_wx.index,(Amplitude.kr(InFeedback.ar(0)))); ////distribution control array period feedback
//Out.kr(~controlBus_wy.index,(Amplitude.kr(InFeedback.ar(1))));
//Out.kr(~controlBus_wz.index,(Amplitude.kr(InFeedback.ar(2))));
Out.kr(~controlBus_points.index,(Osc.kr(~ps.bufnum,f).abs));
//Out.kr(~controlBus_points.index,(SinOsc.kr(TExpRand.kr(0.01,0.1,Impulse.kr(f.rand))).range(10,600)));
//Out.kr(~controlBus_sh.index,(Osc.kr(~sh.bufnum,f).abs));
//Out.kr(~controlBus_sh.index,(SinOsc.kr(TExpRand.kr(0.01,0.1,Impulse.kr(f.rand))).range(1,4)));
}).add;
);
);
	1.wait;
////animation routine
~countf=[2,2,3,3,2,2];
~sc=((1+5.sqrt)/2);
~harmm=3;
~animation=Synth.new(\run).register;
(
//~countf=[4,3,2,2,2,2];
			{
var pla=0,az=0,el=0;
var sph,mag,r,run = true;
var scale=1,scale1=10,scale2=10,harm,perspective;
var axis=~countf.[0],cloud=~countf.[1],axis1=~countf.[2],gravity1=~countf.[3],axis2=~countf.[4],gravity2=~countf.[5];
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
var waveSpeed = 0.5,waveFreq = 3,amp=0.5,pointcount;
var theta,phi,wave,anglex,angley,anglez,ratio1,ratio2,ratio3;

~azf=[];~elf=[];~magxf=[];~magyf=[];~magzf=[];~qxf=[];~azu=[];~elu=[];~rx=0;~ry=0;~rz=0;
g=s=~sc;
~treef= Routine({loop{

pointcount=~controlBus_points.getSynchronous;
//~countf=[pointcount,pointcount,pointcount,pointcount,pointcount,pointcount]
~verticef=(~countf.[0]*~countf.[1]*~countf.[2]*~countf.[3]*~countf.[4]*~countf.[5]);
scale=~controlBus_s.getSynchronous;
scale1=~controlBus_s1.getSynchronous;
scale2=~controlBus_s2.getSynchronous;
//scale=~fuse;
///scale1=~fuse1;
//scale2=~fuse2;
//rotation=~controlBus_r.getSynchronous;
//harm=~controlBus_sh.getSynchronous;
anglex=~controlBus_shx.getSynchronous;
angley=~controlBus_shy.getSynchronous;
anglez=~controlBus_shz.getSynchronous;
rotation=0.1;
harm=~harmm;
anglex=0;
angley=0;
anglez=0;
//ratio=~controlBus_wx.getSynchronous+~controlBus_wy.getSynchronous+~controlBus_wz.getSynchronous;
ratio1=~controlBus_wx.getSynchronous;
ratio2=~controlBus_wy.getSynchronous;
ratio3=~controlBus_wz.getSynchronous;
m_x=m_y=m_z=harm;
mq=harm+1;
axis=~countf.[0];cloud=~countf.[1];axis1=~countf.[2];
gravity1=~countf.[3];axis2=~countf.[4];gravity2=~countf.[5];

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
{~azu=[];~elu=[];
~azf=[];~elf=[];~magxf=[];~magyf=[];~magzf=[];~magqxf=[];~azimuthf=[];~elevationf=[];
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
~azf=~azf++azimuth;
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
~elf=~elf++elevation;
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
~magxf=~magxf++magnitudex;
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
~magyf=~magyf++magnitudey;
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
el77=(el77+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
az77=(az77+(2pi-(2pi/s))).wrap(pi.neg,pi);

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
~magzf=~magzf++magnitudez;
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
~magqxf=~magqxf++magnitudeqx;
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
~magxbf = ~magxf.collect { |val, i|
theta = ~azf[i];
phi = ~elf[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magybf = ~magyf.collect { |val, i|
theta = ~azf[i];
phi = ~elf[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
~magzbf = ~magzf.collect { |val, i|
theta = ~azf[i];
phi = ~elf[i];
wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
val * wave;
};
);
(
~verticef.do{
az=~azf.[pla];
el=~elf.[pla];
mag=(Cartesian(~magxf.[pla],~magyf.[pla],~magzf.[pla]).rho)/2.sqrt;
//mag=1;
pla=pla+1;
sph=Spherical(mag,az,el);
sph=sph.rotateYZ(0.5pi).asSpherical;
sph=sph.rotateYZ(~rx).rotateXZ(~ry).rotateXY(~rz);
~azu=~azu++[sph.theta];
~elu=~elu++[sph.phi];
});
(~frames).wait;
};};
);
}.value
);
	1.wait;
//object rot
(
{var sph,rot;
Routine({loop{
(
~rx=(~rx +0.01).wrap(0,2pi);
~ry=(~ry +0.01).wrap(0,2pi);
~rz=(~rz +0.01).wrap(0,2pi);
);
(~frames).wait;
};
}).play;
}.defer
);


///////////plot
(
~shade=20;
~llinee1=50;
~harmm=1;
~diameter=400;
~distpers=500;
~limitc=300;
~frame=50.neg;
~treef.play;
);
///image plotter
({
var w,u,size=1000,diameter=400,n=0,m=0,k=0,harm=2;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=600,depth=2,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0,rate=0.01;
var plane,pointx,pointy,x,y,z;
var d_o=4,lined=25,run = true,tilt=0.15pi;
var wave=12,sph,ratio1,ratio2,ratio3,azh,elh,px,py,pz;


w = Window("3d Plotter", Rect(400,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);
v.drawFunc = {

Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
~point_cloud=[];
diameter=~diameter;//*~harmm.reciprocal;
harm=~harmm;
d_o=1;
wave=~shade;
dist=~distpers;
lined=~llinee1;
n=0;

(~verticef).do {

az=~azu.[n];el=~elu.[n];
mag=(Cartesian(~magxf.[n],~magyf.[n],~magzf.[n]).rho/(2.sqrt));
sph = Spherical(1,az,el).asCartesian;

azh=sph.theta;
elh=sph.phi;
x = (harm*cos(elh)*cos(azh))+(cos(harm*elh)*cos(harm*azh));
y = (harm*cos(elh)*sin(azh))+(cos(harm*elh)*sin(harm*azh));
z = (harm*sin(elh))+(sin(harm*elh));

x = x*diameter*mag;
y = y*diameter*mag;
z = z*diameter*mag;

(
px = x.clip2(~limitc+~frame);
py = y.clip2(~limitc+~frame);
pz = z.clip2(~limitc+~frame);
		);

point=Cartesian(x,y,z);
(
point.x = point.x.wrap2(~limitc);
point.y = point.y.wrap2(~limitc);
point.z = point.z.wrap2(~limitc);
		);
		/*(
point.x = point.x.clip2(~limitc);
point.y = point.y.clip2(~limitc);
point.z = point.z.clip2(~limitc);
		)*/
					/*(
point.x = point.x.fold2(~limitc);
point.y = point.y.fold2(~limitc);
point.z = point.z.fold2(~limitc);
		)*/

point = point.rotateYZ(rx); point = point.rotateXZ(ry); point = point.rotateXY(rz);
//////remaping
//plane=Complex(point.x,point.y);
//cp=Polar(point.z,plane.theta);
cp=point;
////////////////////perspective
perspective = dist / (dist + point.z + (dist/2));
///color
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));
//////points
pointx=cp.x*perspective;
pointy=cp.y*perspective;
~point_cloud=~point_cloud++Point(pointx,pointy);
///point_oval
Pen.addOval(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective,d_o*perspective));
Pen.fillStroke;
n=n+1;
};
n=0;
////////mesh
(
n = 0;m=0;k = 0;
(~point_cloud.size).do {
var m = n + 1;
(~point_cloud.size - n - 1).do {
Pen.width = perspective.clip(2,1.0)*d_o/wave;
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));
(if(~point_cloud[n].dist(~point_cloud[m]) < lined)
{Pen.line( ~point_cloud.[n], ~point_cloud.[m])};);
Pen.fillStroke;
//~c_dsitance=~point_cloud.[n].dist(~point_cloud.[m]);
m=m+1;k=k+1
};n=n+1;
};
)
};
{ while { run } {v.background_(Color.black); v.refresh; (~frames).wait } }.fork(AppClock);
w.front;
Routine({
inf.do {
(
rx=(rx +0.01).wrap(0,2pi);
ry=(ry +0.01).wrap(0,2pi);
rz=(rz +0.01).wrap(0,2pi);
);
/*(
rx=(rx +~rotationx).wrap(0,2pi);
ry=(ry +~rotationy).wrap(0,2pi);
rz=(rz +~rotationz).wrap(0,2pi);
)*/
{v.refresh}.defer;
(~frames).wait;
};
}).play;
}.defer)
}); Tdef(\drone).play;
}
)
