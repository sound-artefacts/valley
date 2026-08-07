
(
s.waitForBoot{
Tdef(\drone, {
//clock
~clock = TempoClock(1);

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

/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg attack,decay,tone
var sig,env;

sig=Saw.ar(220*tone,tone.reciprocal);

Out.ar(0,sig*nv);

}).add;
);
0.6.wait;

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


//~seq= Pseq(~dur ,inf).asStream;

//~intervalt=1;
//~dur=~dur*~intervalt;
//~dursum=~dur.sum;


TempoClock.default.tempo_(1);
~attack=0.1;
~decay=1;

(
~pattern = Pdef(\1,
//Pbind( \instrument,\synth,
Pmono( \synth,
//\dur, Pseq(~dur ,inf),
\dur,~timbr_dur,
				\hold,Pseq([3/2,2,1,4/3],inf),
					\attack,Pfunc{~attack},
				\decay,Pfunc{~decay},
));
		);
~pattern.play;

}); Tdef(\drone).play;
}
)



