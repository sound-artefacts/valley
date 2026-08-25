  ///Quarks.install("MathLib");

s.record(numChannels:6);
(
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=9;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
//s.makeGui(w);
s.meter;
s.freqscope;
s.scope;
);
s.waitForBoot{
Tdef(\drone, {

//////point arrays
///massive expansion coordinates
///for this array instead of simple comment out simple (tetrahedron) set frames less than 1/64 and set 32^2 iteration on rotation routine
///also on synthdef larger polytope number and more ouput channels on bus array, also more control buses matrix on synthdef
///here utilized as reverb array
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~azimuthr=[]; ~elevationr=[];

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

    ~azimuthr = ~azimuthr ++ azimuth;
    ~elevationr = ~elevationr ++ elevation;

    az1=0; el1=0;
    az2=0; el2=0;
};
}.value;
);		0.1.wait;
/////l system boolean
({
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
var word = "A";
var string_temp = "";
var iter = 16;
var dictnotes = IdentityDictionary[\A ->0, \B -> 1];
 ~lseq=[];
iter.do({
word.asArray.do({|i|string_temp = string_temp ++ dict[i.asSymbol];});
word = string_temp;string_temp = "";});
word.postln;
word.do({|i| ~lseq = ~lseq ++ dictnotes[i.asSymbol];});
~lseq.postln;
}.value);
0.1.wait;

///////tetrahedron simple setup
(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
//~elevation=[0,0,0,0];
);

///////// pan on cube arrasy
(
~azc=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~elc=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
);
0.1.wait;

///////////inputs
~rx=0;~ry=0;~rz=0;~gain=1;~fundament=0;~resonance=0;~harmonic=1;~fold=0;~room=0;~azs=0;~els=0;
~azr=1;~elr=1;
~temperament=16256;
~lagtime=1/128;
~frames=1024.reciprocal;
~x=0;~y=0;~z=0;
~ffreq=16;
~window=110;
~dur=~frames*~window;

//angle compensatiom
~s=(1+2.sqrt);
~g=((1+5.sqrt)/2);

//////////rotation
(
{var sph,az,el,n,bamk=2.pow(2);
Routine({loop{
n=0;~az=[];~el=[];
bamk.do{
az=~azimuth.[n];
el=~elevation.[n];
n=n+1;
sph=Spherical(1,az,el);
//sph=sph.rotateXY(~z.lag2(~lagtime)).asSpherical;///static z interferance
sph=sph.rotateYZ(~x.lag2(~lagtime)).rotateXZ(~y.lag2(~lagtime)).rotateXY(~z.lag2(~lagtime));//orchestral
~az=~az++[sph.theta];
~el=~el++[sph.phi];
};
(~frames).wait;
};
}).play;
}.defer
);

(
{var rot;
Routine({loop{
//rot=Spherical(~dur,~azr,~elr);
~x=(~x+(~azr*((2pi-(2pi/~g))*(~frames/8)))).wrap(0,2pi);
~y=(~y+(~azr*((2pi-(2pi/~g))*(~frames/8)))).wrap(0,2pi);
~z=(~z+(~azr*((2pi-(2pi/~g))*(~frames/8)))).wrap(0,2pi);
(~frames).wait;
};
}).play;
}.defer
);
0.1.wait;

////////////osc table
~wavec=16256;
(
~n=1.neg;~array=~wavec.collect{~n=~n+1;2.pow(~n/~wavec)};
~n=(0-(2pi/~wavec)); ~ph=~wavec.collect{~n=~n+(2pi/~wavec);};
~bufferSize = 2048*4;~signalSize = 1024*4;
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
signal=Signal.sineFill(~signalSize,~array,~ph); wt = signal.asWavetable; ~wt.loadCollection(wt);
//signal.plot;
}.value
);
0.5.wait;

////wave table
		~wavecc=56;
(
~nc=1.neg;~arrayc=~wavecc.collect{~nc=~nc+1;2.pow(~nc/~wavecc)};
~nc=(0-(2pi/~wavecc)); ~phc=~wavecc.collect{~nc=~nc+(2pi/~wavecc);};
~bufferSizec = 2048*1;~signalSizec = 1024*1;
~wtc= Buffer.alloc(s,~bufferSizec);
{
var signal,wt;
signal=Signal.sineFill(~signalSizec,~arrayc,~phc); wt = signal.asWavetable; ~wtc.loadCollection(wt);
//signal.plot;
}.value
);


(//scales
(~note=25;
~scale1=[0,5,7,12,17,19,24,29,31,48,53,55,96,55,53,48,31,29,24,19,17,12,7,5,0];
({var nn=1.neg;
~scale2=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)}}.value);
({var nn=1.neg;
~scale3=~note.collect{nn=nn+1;Scale.ionian.performDegreeToKey(nn,12)}}.value);
({var nn=1.neg;
~scale4=~note.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)}}.value);
({
var nn=1.neg,scale1,scale2;
~scale5=~note.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
nn=1.neg;
~scale6=~note.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
}.value));
~scale=[~scale2,~scale3,~scale4,~scale5,~scale6]);

////seq
~fuselim=(16256*9).neg;
~comp=3;
~distortion=0.1;
~noise=0.0001;
~complevel=1024;
~controlBus_1=Bus.control(s,1);
~controlBus_2=Bus.control(s,1);
~controlBus_3=Bus.control(s,1);
~controlBus_4=Bus.control(s,1);
~controlBus_5=Bus.control(s,1);
~controlBus_6=Bus.control(s,1);
~controlBus_7=Bus.control(s,1);
~controlBus_8=Bus.control(s,1);
~controlBus_9=Bus.control(s,1);
//~controlBus_10=Bus.control(s,1);
//~controlBus_11=Bus.control(s,1);
//~controlBus_12=Bus.control(s,1);
//~controlBus_13=Bus.control(s,1);
//~controlBus_14=Bus.control(s,1);
//~controlBus_15=Bus.control(s,1);
//~controlBus_16=Bus.control(s,1);
//~controlBus_17=Bus.control(s,1);
(
SynthDef.new(\run,{
arg set=0,az1=0,az2=0,az3=0,az4=0,el1=0,el2=0,el3=0,el4=0,az5=0,az6=0,az7=0,az8=0,el5=0,el6=0,el7=0,el8=0;

Out.kr(~controlBus_1.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+set).round(1),mul:set.sign));
Out.kr(~controlBus_2.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az1),mul:az1.sign));
Out.kr(~controlBus_3.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az2),mul:az2.sign));
Out.kr(~controlBus_4.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az3),mul:az3.sign));
Out.kr(~controlBus_5.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az4),mul:az4.sign));
Out.kr(~controlBus_6.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el1),mul:el1.sign));
Out.kr(~controlBus_7.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el2),mul:el2.sign));
Out.kr(~controlBus_8.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el3),mul:el3.sign));
Out.kr(~controlBus_9.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el4),mul:el4.sign));
//Out.kr(~controlBus_10.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az5),mul:az5.sign));
//Out.kr(~controlBus_11.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az6),mul:az6.sign));
///Out.kr(~controlBus_12.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az7),mul:az7.sign));
//Out.kr(~controlBus_13.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+az8),mul:az8.sign));
//Out.kr(~controlBus_14.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el5),mul:el5.sign));
//Out.kr(~controlBus_15.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el6),mul:el6.sign));
//Out.kr(~controlBus_16.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el7),mul:el7.sign));
//Out.kr(~controlBus_17.index,Amplitude.kr((SinOsc.kr(~ffreq).fold(~noise)+el8),mul:el8.sign));
}).add;
);
///////////////////feed
0.1.wait;

///synth
//az=#[0,0,0,0],el=#[0,0,0,0]
(
SynthDef.new(\synth,{

arg gain=0,fundamental=0,resonanse=0,harm=1,room=0,drive=0,mag=0,dist=1,lsystem=1,
	tone=1,hold=0.1,scselect=0,rate=1,attack=0.01,curve=4.neg,key=0,klevel=8;
var level,c,res,revroom,overdrive,x,y,z,tx,ty,tz,trange,busarray2,pan1,pan2,env,pitchx,pitchy,pitch;
var freqx,freqy,freqz,ampx,ampy,ampz,tonex,toney,tonez,tune=~ffreq,phasex,phasey,phasez,snt;
var c1,c2,c3,sigx,sigy,sigz,azn,eln,cx,cy,cz,g1,g2,g3,g4,g5,g6,g7,g8,thresholdk,note,senv,gate1;
var n=0,polytope=1,busarray1,harmonic,fund,mix,a,b,immersion,busarray,gate,threshold,kenv,kpitch,kfm;
var az1=0,az2=0,az3=0,az4=0,el1=0,el2=0,el3=0,el4=0,az,el,xp,yp,zp,kx,ky,kz;
var az5=0,az6=0,az7=0,az8=0,el5=0,el6=0,el7=0,el8=0,rbank=14,raz,rel,rx,ry,rz,r=0;

///inputs
level=2.pow(gain.lag2(~lagtime)/16256)/(5);
c=2.pow(fundamental.lag2(~lagtime)/16256);
res=2.pow(resonanse.lag2(~lagtime)/16256);
revroom=2.pow(room.lag2(~lagtime)/16256);
overdrive=2.pow(drive.lag2(~lagtime)/16256);

harmonic=harm;
trange=mag.lag2(~lagtime);
level=level;
//sequencer
//snt=In.kr(~controlBus_1.index);
note=2.pow(key.lag2(~lagtime)/12);
//note=2.pow(snt/12);

///coordinates
az1=In.kr(~controlBus_2.index);
az2=In.kr(~controlBus_3.index);
az3=In.kr(~controlBus_4.index);
az4=In.kr(~controlBus_5.index);
el1=In.kr(~controlBus_6.index);
el2=In.kr(~controlBus_7.index);
el3=In.kr(~controlBus_8.index);
el4=In.kr(~controlBus_9.index);
//az5=In.kr(~controlBus_10.index);
//az6=In.kr(~controlBus_11.index);
//az7=In.kr(~controlBus_12.index);
//az8=In.kr(~controlBus_13.index);
//el5=In.kr(~controlBus_14.index);
//el6=In.kr(~controlBus_15.index);
//el7=In.kr(~controlBus_16.index);
//el8=In.kr(~controlBus_17.index);

//az=[az1,az2,az3,az4,az5,az6,az7,az8];
//el=[el1,el2,el3,el4,el5,el6,el7,el8];

az=[az1,az2,az3,az4];
el=[el1,el2,el3,el4];

///pitch
fund=c*tune;
pitch=exp(Complex(0,1)*tone);
pitchx=2.pow(Select.kr((pitch.real*~note).abs,Select.kr(scselect,~scale))/12);
pitchy=2.pow(Select.kr((pitch.imag*~note).abs,Select.kr(scselect,~scale))/12);

rbank.do{
n=0;
r=~azimuthr.size.rand;
///reverb
raz=~azimuthr.[r];
rel=~elevationr.[r];
rx=(((harmonic)*cos(rel)*cos(raz))+(cos((harmonic)*(rel))*cos((harmonic)*(raz))))/harmonic;
ry=(((harmonic)*cos(rel)*sin(raz))+(cos((harmonic)*(rel))*sin((harmonic)*(raz))))/harmonic;
rz=(((harmonic)*sin(rel))+(sin((harmonic)*(rel))))/harmonic;

polytope.do{

//env fft
//senv=EnvGen.kr(Env([0,1,0],[attack,rate+(attack*2)],[32.neg,32]),gate:lsystem);
//env=EnvGen.ar(Env.new([0,1,0,1,0,1,0],
//[attack,(rate/3),attack,(rate/3),attack,(rate/3)],[curve]),doneAction:2);
env=EnvGen.ar(Env.perc(attack,rate*curve.abs),doneAction:2);
senv=1;
azn=az.[n].lag2(~lagtime);
eln=el.[n].lag2(~lagtime);

///spat
xp = ((harmonic*cos(eln)*cos(azn))+(cos(harmonic*(eln))*cos(harmonic*(azn))))/harmonic;
yp = ((harmonic*cos(eln)*sin(azn))+(cos(harmonic*(eln))*sin(harmonic*(azn))))/harmonic;
zp = ((harmonic*sin(eln))+(sin(harmonic*(eln))))/harmonic;

kx=((Complex(cos(azn*harmonic),cos(azn*harmonic)).rho/(2.sqrt))*(Complex(cos(eln),cos(eln)).rho/(2.sqrt)));
ky=((Complex(sin(azn*harmonic),sin(azn*harmonic)).rho/(2.sqrt))*(Complex(cos(eln),cos(eln)).rho/(2.sqrt)));
kz=(Complex(sin(eln*harmonic),sin(eln*harmonic))).rho/(2.sqrt);

x = (cos(eln)*cos(azn));
y = (cos(eln)*sin(azn));
z = (sin(eln));

//////perspective
immersion = (level/dist) / ((level/dist) + kz + ((level/dist)/2));

////temperament
tx = (trange*kx);
ty = (trange*ky);
tz = (trange*kz);
tonex=2.pow(tx.round(1)/~temperament);
toney=2.pow(ty.round(1)/~temperament);
tonez=2.pow(tz.round(1)/~temperament);

////osc data
freqx=(fund*pitchx)*tonex*note;
freqy=(fund*pitchy)*toney*note;
freqz=fund*tonez*note;
ampx=c.reciprocal*tonex.reciprocal*level*immersion;
ampy=c.reciprocal*toney.reciprocal*level*immersion;
ampz=c.reciprocal*tonez.reciprocal*level;
//phasex=(Complex(1,x).theta*2);
//phasey=(Complex(1,y).theta*2);
//phasez=(Complex(1,z).theta*2);
//phasex=atan2(x,y);
//phasey=atan2(y,z);
//phasez=atan2(z,x);
phasex=(x*pi);
phasey=(y*pi);
phasez=(z*pi);


/////////osc
c1=BPF.ar((Osc.ar(~wt.bufnum,freqx,phase:phasex,mul:~complevel).abs*
SinOsc.ar(freqx,phase:phasex)),freqx,res,ampx*x.sign);
c2=BPF.ar((Osc.ar(~wt.bufnum,freqy,phase:phasey,mul:~complevel).abs*
SinOsc.ar(freqy,phase:phasey)),freqy,res,ampy*y.sign);
c3=BPF.ar((Osc.ar(~wt.bufnum,freqz,phase:phasez,mul:~complevel).abs*
SinOsc.ar(freqz,phase:phasez)),freqz,res,ampz*z.sign);

///distortion
mix=overdrive.linlin(1,2.pow(~fuselim/16256),2.pow(~fuselim/16256),1);

c1=c1.lag2(~signalSize.reciprocal)*
(LPF.ar(Saw.ar(tune,(ampx)),tune*64*mix).fold2(mix*~distortion)+((ampx)));
c2=c2.lag2(~signalSize.reciprocal)*
(LPF.ar(Saw.ar(tune,(ampy)),tune*64*mix).fold2(mix*~distortion)+((ampy)));
//c3=c3.lag2(~signalSize.reciprocal)*
//(LPF.ar(Saw.ar(tune,(ampz)),tune*64*overdrive).fold2(mix*0.05)+((ampz)));

///rev
sigx=FreeVerb.ar((c1).fold2(overdrive*~comp),rx.abs,revroom);
sigy=FreeVerb.ar((c2).fold2(overdrive*~comp),ry.abs,revroom);
sigz=FreeVerb.ar((c3).fold2(~comp),rz.abs,revroom);

//vbap panner
/*(
g1=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[0])*cos(~azc.[0]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[0])*sin(~azc.[0]))
+
(sin(eln*harmonic)*
sin(~elc.[0])));

g2=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[1])*cos(~azc.[1]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[1])*sin(~azc.[1]))
+
(sin(eln*harmonic)*
sin(~elc.[1])));

g3=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[2])*cos(~azc.[2]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[2])*sin(~azc.[2]))
+
(sin(eln*harmonic)*
sin(~elc.[2])));

g4=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[3])*cos(~azc.[3]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[3])*sin(~azc.[3]))
+
(sin(eln*harmonic)*
sin(~elc.[3])));

g5=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[4])*cos(~azc.[4]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[4])*sin(~azc.[4]))
+
(sin(eln*harmonic)*
sin(~elc.[4])));

g6=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[5])*cos(~azc.[5]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[5])*sin(~azc.[5]))
+
(sin(eln*harmonic)*
sin(~elc.[5])));

g7=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[6])*cos(~azc.[6]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[6])*sin(~azc.[6]))
+
(sin(eln*harmonic)*
sin(~elc.[6])));

g8=((cos(eln)*cos(azn*harmonic)*
cos(~elc.[7])*cos(~azc.[7]))
+
(cos(eln)*sin(azn*harmonic)*
 cos(~elc.[7])*sin(~azc.[7]))
+
(sin(eln*harmonic)*
sin(~elc.[7])));
			);

pan1=[g1,g3,g5,g7];
pan2=[g2,g4,g6,g8];*/

///sig
a=HPF.ar((LeakDC.ar((sigx)*((sigz).fold2(overdrive*~distortion)+(ampz)))),32);
b=HPF.ar((LeakDC.ar((sigy)*((sigz).fold2(overdrive*~distortion)+(ampz)))),32);
//a=(a*pan1[n]).softclip(3.dbamp);
//b=(b*pan2[n]).softclip(3.dbamp);

threshold=(((343/0.3)/tune).reciprocal.ampdb/2.sqrt).dbamp;
a=Compander.ar(a,sigx,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
b=Compander.ar(b,sigy,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

busarray1=[0,2,4,6,8,10,12,14];
busarray2=[1,3,5,7,9,11,13,15];
//busarray=[0,1,2,3];

///wavefield out
Out.ar(busarray1.[n],a.softclip(5)*env*senv);
Out.ar(busarray2.[n],b.softclip(5)*env*senv);

//pan stereo out
//Out.ar(busarray1.[n],Pan2.ar(a.softclip(5)*env*senv,(xp*rx)*immersion));
//Out.ar(busarray1.[n],Pan2.ar(b.softclip(5)*env*senv,(yp*ry)*immersion));

//quad out
Out.ar(busarray1.[n],Pan4.ar(a.softclip(5),(xp*rx)*immersion,(yp*ry)*immersion,env*senv));
Out.ar(busarray1.[n],Pan4.ar(b.softclip(5),(xp*rx)*immersion,(yp*ry)*immersion,env*senv));

//formants
/*(
Out.ar(busarray1.[n],BPF.ar(a.softclip(5),730,0.01,0.dbamp)*env*senv);
Out.ar(busarray2.[n],BPF.ar(b.softclip(5),730,0.01,0.dbamp)*env*senv);
Out.ar(busarray1.[n],BPF.ar(a.softclip(5),1090,0.01,0.neg.dbamp)*env*senv);
Out.ar(busarray2.[n],BPF.ar(b.softclip(5),1090,0.01,0.neg.dbamp)*env*senv);
Out.ar(busarray1.[n],BPF.ar(a.softclip(5),2440,0.01,0.neg.dbamp)*env*senv);
Out.ar(busarray2.[n],BPF.ar(b.softclip(5),2440,0.01,0.neg.dbamp)*env*senv);
					)*/

n=n+1;
};
/*///kick////
kenv=EnvGen.kr(Env.perc(attack, rate+(attack*2),curve:4.neg),1,levelScale:level*klevel*2);
kpitch=EnvGen.kr(Env([tune, tune/2], [rate+(attack*2)/10],[-16]));
kfm=EnvGen.kr(Env([tune*8, 2], [rate+(attack*2)/10], [-16]));

gate=FreeVerb.ar(HPF.ar(SinOsc.ar(kpitch+(SinOsc.ar(kpitch,phase:0)*kfm),phase:0,mul:level),16),rz.abs,revroom);
gate1=FreeVerb.ar(HPF.ar(SinOsc.ar(kpitch+(SinOsc.ar(kpitch,phase:0.5pi)*kfm),phase:0.5pi,mul:level),16),rz.abs,revroom);

thresholdk=(((343/0.3)/tune).reciprocal.ampdb/2.sqrt).dbamp;
gate=Compander.ar(gate,gate,thresholdk,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
gate1=Compander.ar(gate,gate1,thresholdk,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

Out.ar(busarray1.[0],LeakDC.ar(gate.softclip(2.dbamp)*kenv));
Out.ar(busarray2.[0],LeakDC.ar(gate1.softclip(2.dbamp)*kenv));
//Out.ar(busarray1.[1],LeakDC.ar(gate.softclip(2.dbamp)*kenv));
//Out.ar(busarray2.[1],LeakDC.ar(gate1.softclip(2.dbamp)*kenv));
//quad out
///Out.ar(0,Pan4.ar(gate.softclip(2.dbamp),rx,rz,kenv));
//Out.ar(0,Pan4.ar(gate1.softclip(2.dbamp),rz,ry,kenv));*/
};

}).add;
);

3.wait;

///data
(
~time=1;
~clock=TempoClock.default.tempo_(1);
~attack=0.000001/~time;
);
(
~setnote=0;
~fundamental=0;
~tone=0;
~gain=1;
~resonanse=1;
~harm=1;
~drive=0;
~room=0;
~mag=1;
~tone=1;
~scaleselect=0;
~curve=1.neg;
~klevel=0.1;
~dist=1;

//~lseq=[1];
);

///melody
~sn=10;~sn1=0;~sn2=0;~sn3=0;~sn4=0;~sn5=0;~sn6=0;~sn7=0;~sn8=0;
~s9=10;~sn10=0;~sn11=0;~sn12=0;~sn13=0;~sn14=0;~sn15=0;~sn16=0;~sn17=0;
~sn18=10;~sn19=0;~sn20=0;~sn21=0;~sn22=0;~sn23=0;~sn24=0;
//~sn=Pseq([7,10,8,9,11,12],inf).asStream;
//~sn=Pseq([0,5,7,12,17,19,24],inf).asStream;
//~sn=Pseq([7,19,22,10,19,22,14,26],inf).asStream;
//~sn=Pseq([2,7,4,9],inf).asStream;
~snt=Synth.new(\run).register;
(
{
Routine({loop{
//~azset=~az;
//~elset=~el;

~snt.set(\az1,~az.[0],\az2,~az.[1],\az3,~az.[2],\az4,~az.[3],\el1,~el.[0],\el2,~el.[1],\el3,~el.[2],\el4,~el.[3],
	\az5,~az.[4],\az6,~az.[5],\az7,~az.[6],\az8,~az.[7],\el5,~el.[4],\el6,~el.[5],\el7,~el.[6],\el8,~el.[7]);
(~frames).wait
}
}).play;
}.defer
);
		~r=0;
(
{Routine({loop{
//~sn=Pseq([~sn1,~sn2,~sn3,~sn4,~sn5,~sn6,~sn7,~sn8],inf).asStream;
~setnote=[~sn1,~sn2,~sn3,~sn4,~sn5,~sn6,~sn7,~sn8,~sn9,~sn10,~sn11,~sn12,~sn13,~sn14,~sn15,~sn16,~sn17,~sn18,~sn19,
~sn20,~s21,~sn22,~sn23,~sn24].[~r];
~r=(~r+1).wrap(0,23);
~snt.set(\set,~setnote);
(((1/~time)/1)+(~attack*1)).wait}
}).play;}.defer
);
~ttt=0.999.rand;
///pattern
(~pattern1 = Pdef(\1,
Pbind(\instrument, \synth,
//Pmono( \synth,
\dur,Pfunc{(1/~time)*~ttt},
\gain,Pfunc{~gain},
\fundamental,Pfunc{~fundamental},
\tone,Pfunc{~tone},
\resonanse,	Pfunc{~resonanse},
\harm,Pfunc{~harm},
\drive,Pfunc{~drive},
\room,Pfunc{~room},
\mag,Pfunc{~mag},
//\az,Pfunc{Ref([~azset.[0],~azset.[1],~azset.[2],~azset.[3]])},
//\el,Pfunc{Ref([~elset.[0],~elset.[1],~elset.[2],~elset.[3]])},
\scselect,Pfunc{~scaleselect},
\rate,Pfunc{(1/~time)},
\attack,Pfunc{~attack},
\curve,Pfunc{~curve},
\key,Pseq([7,10,12,9,14,2,10,14,9,12,10,2,9,14,2,10,14,10,12,9,14,7,10,2],inf),
\klevel,Pfunc{~klevel},
\dist,Pfunc{~dist},
\lsystem,Pseq([1],inf),
)));
(~pattern2 = Pdef(\2,
Pbind(\instrument, \synth,
//Pmono( \synth,
\dur,Pfunc{(1/~time)*~ttt/(2/1)},
\gain,Pfunc{~gain},
\fundamental,Pfunc{~fundamental},
\tone,Pfunc{~tone},
\resonanse,	Pfunc{~resonanse},
\harm,Pfunc{~harm},
\drive,Pfunc{~drive},
\room,Pfunc{~room},
\mag,Pfunc{~mag},
//\az,Pfunc{Ref([~azset.[0],~azset.[1],~azset.[2],~azset.[3]])},
//\el,Pfunc{Ref([~elset.[0],~elset.[1],~elset.[2],~elset.[3]])},
\scselect,Pfunc{~scaleselect},
\rate,Pfunc{(1/~time)},
\attack,Pfunc{~attack},
\curve,Pfunc{~curve},
\key,Pseq([10.neg,5.neg,2.neg,2,5.neg,0,10.neg,2.neg,5.neg,0,10.neg,5.neg],inf),
\klevel,Pfunc{~klevel},
\dist,Pfunc{~dist},
\lsystem,Pseq([1],inf),
)));
~pattern1.play;
//~pattern2.play;
/*(
~pattern1.stop;
~pattern2.stop;

		)*/
		//s.record(numChannels:4);
////////////////////////gui
(
{
var size=550,sk=(size/12),w,rol=0,sz=0.5,wd=3.5,shift=1;

w = Window("tws", Rect(50, 50, size, size)).front;
~vw1 = UserView(w, Rect(0,0,size,size)).background_(Color.black);
~logView1 = ListView( ~vw1, Rect(0, 0, size/4, size)).background_(Color.black)
.stringColor_(Color.white).font_(Font('Arial', 18)).items_([]);

~logItems1 = List.new;
~log1 = { |msg| {~logItems1.add(msg); if(~logItems1.size > 200) { ~logItems1.removeAt(0);  };
~logView1.items_(~logItems1.asArray); ~logView1.value_(~logItems1.size - 1); }.defer;};

(
~sl1=Knob.new(~vw1, Rect.new(50,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,pi.neg,pi).postln;
//value=obj.value.linlin(0,1,1/4,4).round(1/16).postln;
~azr=value;
~elr=value/2;
//~clock.tempo_(value);
~log1.(value.asString);
});
~st1=StaticText(~vw1,Rect(50,50+sk,sk+20,sk)).string_("rot")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl2=Knob.new(~vw1, Rect.new(150,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,pi.neg,pi).postln;
//value=obj.value.linlin(0,1,0,~note).round(1).postln;
//~elr=value;
//~nset=value;
//~synth.set(\tone,value);
~tone=value;
~log1.(value.asString);
});
~st2=StaticText(~vw1,Rect(150,50+sk,sk+20,sk)).string_("tone")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl3=Knob.new(~vw1, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*4).neg,16256*2).round(1).postln;
//~synth.set(\gain,value);
~gain=value;
~log1.(value.asString);
});
~st3=StaticText(~vw1,Rect(250,50+sk,sk+20,sk)).string_("gain")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl4=Knob.new(~vw1, Rect.new(350,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,16256*3.neg,16256*2).round(1).postln;
//~synth.set(\fundamental,value);
~fundamental=value;
~log1.(value.asString);
});
~st4=StaticText(~vw1,Rect(350,50+sk,sk+20,sk)).string_("fund")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl5=Knob.new(~vw1, Rect.new(450,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*8).neg,16256*4).round(1).postln;
//~synth.set(\resonanse,value);
~resonanse=value;
~log1.(value.asString);
});

~st5=StaticText(~vw1,Rect(450,50+sk,sk+20,sk)).string_("resonance")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl6=Knob.new(~vw1, Rect.new(50,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,1,16).round(1).postln;
//~synth.set(\harm,value);
~harm=value;
~log1.(value.asString);
});
~st6=StaticText(~vw1,Rect(50,(50+sk+50+25+sk),sk+20,sk)).string_("harmonic")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl7=Knob.new(~vw1, Rect.new(150,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,~fuselim).round(1).postln;
//~synth.set(\drive,value);
~drive=value;
~log1.(value.asString);
});
~st7=StaticText(~vw1,Rect(150,(50+sk+50+25+sk),sk+20,sk)).string_("drive")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl8=Knob.new(~vw1, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,8.neg,64).postln;
//~synth.set(\perspective,value);
~curve=value;
~log1.(value.asString);
});
~st8=StaticText(~vw1,Rect(250,(50+sk+50+25+sk),sk+20,sk)).string_("gate")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl9=Knob.new(~vw1, Rect.new(350,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*12).neg,0).round(1).postln;
//~synth.set(\room,value);
~room=value;
~log1.(value.asString);
});
~st9=StaticText(~vw1,Rect(350,(50+sk+50+25+sk),sk+20,sk)).string_("room")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl10=Knob.new(~vw1, Rect.new(450,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,~temperament/2).round(1).postln;
//~synth.set(\mag,value);
~mag=value;
~log1.(value.asString);
});
~st10=StaticText(~vw1,Rect(450,(50+sk+50+25+sk),sk+20,sk)).string_("magnitude")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl11=Knob.new(~vw1, Rect.new(50,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var sc;
sc=obj.value.linlin(0,1,0,4).round(1);
sc.postln;
~scaleselect=sc;
~log1.(sc.asString);
});
~st11=StaticText(~vw1,Rect(50,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("scale")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s12=Knob.new(~vw1, Rect.new(150,(50+sk+50+sk+25+25+50), sk)).background_(Color.black).action_({
arg obj;
var note;
note=obj.value.linlin(0,1,0,24).round(1);
note.postln;
~sn1=note;
~log1.(note.asString);
});
~st12=StaticText(~vw1,Rect(150,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("n1")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl13=Knob.new(~vw1, Rect.new(250,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var k;
k=obj.value.linexp(0,1,0.0001,16);
k.postln;
~klevel=k;
~log1.(k.asString);
});
~st13=StaticText(~vw1,Rect(250,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("kick")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl14=Knob.new(~vw1, Rect.new(350,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var k;
k=obj.value.linexp(0,1,0.000001,1);
k.postln;
~attack=k/~time;
~log1.(k.asString);
});
~st14=StaticText(~vw1,Rect(350,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("attack")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl15=Knob.new(~vw1, Rect.new(450,(50+sk+50+sk+25+25+50),sk, sk)).background_(Color.black).action_({
arg obj;
var tempo;
	tempo=obj.value.linlin(0,1,1,128).round(1/8);
tempo.postln;
~time=tempo;
~log1.(tempo.asString);
});
~st15=StaticText(~vw1,Rect(450,(50+sk+50+sk+25+25+sk+50),sk+20,sk)).string_("tempof")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl16=Knob.new(~vw1, Rect.new(50,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var dist;
dist=obj.value.linlin(0,1,1,10);
dist.postln;
~dist=dist;
~log1.(dist.asString);
});
~st16=StaticText(~vw1,Rect(50,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("distance")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s117=Knob.new(~vw1, Rect.new(150,(50+sk+50+sk+25+25+sk+50+sk+50), sk)).background_(Color.black).action_({
arg obj;
var note;
note=obj.value.linlin(0,1,0,24).round(1);
note.postln;
~sn2=note;
~log1.(note.asString);
});
~s117=StaticText(~vw1,Rect(150,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("n2")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s118=Knob.new(~vw1, Rect.new(250,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var note;
note=obj.value.linlin(0,1,0,24).round(1);
note.postln;
~sn3=note;
~log1.(note.asString);
});
~s118=StaticText(~vw1,Rect(250,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("n3")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~s119=Knob.new(~vw1, Rect.new(350,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var note;
note=obj.value.linlin(0,1,0,24).round(1);
note.postln;
~sn4=note;
~log1.(note.asString);
});
~s119=StaticText(~vw1,Rect(350,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("n4")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
(
~sl20=Knob.new(~vw1, Rect.new(450,(50+sk+50+sk+25+25+sk+50+sk+50),sk, sk)).background_(Color.black).action_({
arg obj;
var note;
note=obj.value.linlin(0,1,0,24).round(1);
note.postln;
~sn5=note;
~log1.(note.asString);
});
~sl20=StaticText(~vw1,Rect(450,(50+sk+50+sk+25+25+sk+50+sk+50+sk),sk+20,sk)).string_("n5")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);
}.defer
);

////midi
(
MIDIClient.init;
MIDIIn.connectAll;
(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
var gain;
gain=val.linlin(0,127,(16256*4).neg,16256*2).round(1);
gain.postln;
~gain=gain;
},1);
);
(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
var fund;
fund=val.linlin(0,127,16256*3.neg,16256*2).round(1);
fund.postln;
~fundamental=fund;
},2);
);
(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
var res;
res=val.linlin(0,127,(16256*8).neg,16256*4).round(1);
res.postln;
~resonanse=res;
},3);
);
(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
var drive;
drive=val.linlin(0,127,0,~fuselim).round(1);
drive.postln;
~drive=drive;
},4);
);
(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
var harm;
harm=val.linlin(0,127,1,31).round(1).postln;
harm.postln;
~harm=harm;
},5);
);
(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
var hold;
hold=val.linlin(0,127,16.neg,64).postln;
hold.postln;
~curve=hold;
},6);
);
(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
var r;
r=val.linlin(0,127,pi.neg,pi);
~azr=r;
~elr=r/2;
r.postln;
},7);
);
(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
var tone;
tone=val.linlin(0,127,pi.neg,pi);
tone.postln;
~tone=tone;
},8);
);
(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
var room;
room=val.linlin(0,127,(16256*12).neg,0).round(1);
room.postln;
~room=room;
},9);
);
(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
var mag;
mag=val.linlin(0,127,0,~temperament/2).round(1);
mag.postln;
~mag=mag;
},10);
);
(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
var sc;
sc=val.linlin(0,127,0,4).round(1);
sc.postln;
~scaleselect=sc;
},11);
);
(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
var k;
k=val.linexp(0,127,0.0001,16);
k.postln;
~klevel=k;
},12);
);
(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
var k;
k=val.linexp(0,127,0.0001,1);
k.postln;
~attack=k/~time;
},13);
);
~timu=1;
(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
var tempo;
tempo=val.linlin(0,127,1,128);
tempo.postln;
~time=tempo;
},14);
);
(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
var dist;
dist=val.linlin(0,127,1,10);
dist.postln;
~dist=dist;
},15);
);
(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
var tempo;
tempo=val.linlin(0,127,1/4,4).round(1/4);
tempo.postln;
~time=tempo;
//~clock=TempoClock.default.tempo_(~time);
},16);
);
			// (
			// 	MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn1=note;
			// 	},1);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn2=note;
			// 	},2);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn3=note;
			// 	},3);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn4=note;
			// 	},4);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn5=note;
			// 	},5);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn6=note;
			// 	},6);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn7=note;
			// 	},7);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn8=note;
			// 	},8);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn9=note;
			// 	},9);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn10=note;
			// 	},10);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn11=note;
			// 	},11);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn12=note;
			// 	},12);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn13=note;
			// 	},13);
			// );
			// ~timu=1;
			// (
			// 	MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn14=note;
			// 	},14);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn15=note;
			// 	},15);
			// );
			// (
			// 	MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
			// 		var note;
			// 		note=val.linlin(0,127,0,24).round(1);
			// 		note.postln;
			// 		~sn16=note;
			// 	},16);
			// );
(
MIDIdef.cc(\midi_pot17,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn17=note;
},17);
);
(
MIDIdef.cc(\midi_pot18,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn18=note;
},18);
);
(
MIDIdef.cc(\midi_pot19,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn19=note;
},19);
);
(
MIDIdef.cc(\midi_pot20,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn20=note;
},20);
);
(
MIDIdef.cc(\midi_pot21,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn21=note;
},21);
);
(
MIDIdef.cc(\midi_pot22,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn22=note;
},22);
);
(
MIDIdef.cc(\midi_pot23,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn23=note;
},23);
);
(
MIDIdef.cc(\midi_pot24,{ |val, num, chan, src|
var note;
note=val.linlin(0,127,0,24).round(1);
note.postln;
~sn24=note;
},24);
);
			// (
			// 	MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
			// 		var sc;
			// 		if(val>0,sc=0);
			// 		sc.postln;
			// 		~sn=sc;
			// 	},11);
			// );
)
}); Tdef(\drone).play;
}
)






////envelope sig
//(~ne=1.neg;~arraye=56.collect{~ne=~ne+1;2.pow(~ne/56)};
//~signalSizee = 2048*1);
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



/*///rhythm
({var x,y,z,n=0,time=32.reciprocal,bx,by,bz,beat=4;~dursum=0;
beat.do{
x=beat*cos(~elevation.[n])*cos(~azimuth.[n]);
y=beat*cos(~elevation.[n])*sin(~azimuth.[n]);
z=beat*sin(~elevation.[n]);
bx=2.pow(x).round(time);
by=2.pow(y).round(time);
bz=2.pow(z).round(time);
~dursum=~dursum+bx+by+bz;
n=n+1};
}.value
);	*/
//0.1.wait;
/*(
{var rrot,n=0,beats=4,r=0;
Routine({loop{
~azry=[];~elry=[];n=0;
beats.do{
rrot=Spherical(~rate,~azimuth.[n],~elevation.[n]).rotateXY(r.lag2(~frames));
r=(r+128.reciprocal).wrap(0,2pi);
~azry=~azry++rrot.theta;
~elry=~elry++rrot.phi;
n=n+1};
(15).wait;
};
}).play;
}.defer
);*/
/*(
{var x,y,z,beat=4,bx,by,bz,time=32.reciprocal,n=0;
Routine({loop{
~dur=[];n=0;
beat.do{
x=beat*cos(~elry.[n])*cos(~azry.[n]);
y=beat*cos(~elry.[n])*sin(~azry.[n]);
z=beat*sin(~elry.[n]);
bx=2.pow(x).round(time);
by=2.pow(y).round(time);
bz=2.pow(z).round(time);
~dur=~dur++bx++by++bz;
n=n+1};
~dur=~dur/8;
~seq=Pseq(~dur,inf).asStream;
(~frames).wait;
};
}).play;
}.defer
);*/
/*(
{var rot;
Routine({loop{
~synth.set(\attack,~attack,\decay,~decay,\rate,~seq.next);
(~seq.next).wait;
};
}).play;
}.defer);*/


/////other arrays
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