
(

~controlBus_1 = Bus.control(s, 1);
~controlBus_2 = Bus.control(s, 1);
~controlBus_3 = Bus.control(s, 1);
~controlBus_4 = Bus.control(s, 1);
~controlBus_5 = Bus.control(s, 1);
~controlBus_6 = Bus.control(s, 1);
~controlBus_x = Bus.control(s, 1);
~controlBus_y = Bus.control(s, 1);
~controlBus_z = Bus.control(s, 1);

s.waitForBoot{
Tdef(\drone, {
//clock
~clock = TempoClock(1);
~erate=1;

0.1.wait;
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
~note=25;
(
{
var nn=1.neg;
~scale2=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg;
~scale3=~note.collect{nn=nn+1;Scale.ionian.performDegreeToKey(nn,12)};
}.value;
);

(
{
var nn=1.neg;
~scale4=~note.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg,scale1,scale2;
~scale5=~note.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
nn=1.neg;
~scale6=~note.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
//~scale10=[scale1,scale2];
~scale=[~scale1,~scale2,~scale3,~scale4,~scale5,~scale6];
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
~gain=1;~drive=0;~c=0;~attack=0.01;~decay=0.5;~s_size=1;
~lowend=20;~room=0;~sscb=26;~pan1=0.001;~pan2=0.001;
~gainb=1;~driveb=0;~cb=0;~attackb=0.01;~decayb=1;
~s_sizeb=1;~lowendb=20;~roomb=0;~scb=1;~lim1=1;~lim2=1;
~incr1=0;~incr2=0;~sc=1;~gold=((1+5.sqrt)/2);
~silver=(1+2.sqrt);~mixb=0;~rectb=16;~dist1=1;~dist2=1;~mr1=1;~mr2=1;
~incr=0;~ssc=26;~mix=0;~rect=16;~s=0;~azimuth=1;~elevation=1;~azimuth1=1;~elevation1=1;
~alternating=[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];
~hor=0;~lat=0;~shape1=1;~shape2=1;
~tempo=1;
TempoClock.default.tempo_(1);

///feed

/*(
{
Routine({loop{
~nn=~set.rand;
~nnn=~set.rand;
(~dursum).wait; // frame duration
};
}).play(~clock);
}.defer
);*/
~nn=~set.rand;
~nnn=~set.rand;

0.1.wait;

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
//~synths.set(\az,~azimuth,\el,~elevation,\az1,~azimuth1,\el1,~elevation1);
(~timbr_dur).wait;}
}).play;
}.defer
);

~pattern = Pdef(\1,
//Pbind( \instrument,\synth,
Pmono( \synth,
//\dur, Pseq(~dur ,inf),
\dur,~timbr_dur,
\hold,Pseq(~dur ,inf),
\s_size,Pfunc { ~s_size },
\lowend,Pfunc { ~lowend },
\room,Pfunc { ~room },
\gain,Pfunc { ~gain },
\au,Pseq([2],inf),
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

}); Tdef(\drone).play;
}
)



