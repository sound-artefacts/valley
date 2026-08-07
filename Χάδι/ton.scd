
(
s.waitForBoot{
Tdef(\drone, {
//clock
~clock = TempoClock(1);

0.1.wait;
////envelope sig
(~ne=1.neg;~arraye=56.collect{~ne=~ne+1;2.pow(~ne/56)};
~signalSizee = 2048*1);
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
envenv = EnvGen.ar(envb,gate:Trig.kr(LFSaw.kr(erate),0.01));*/


(//scales
(~note=25;
~scale1=[0,0,5,7,12,17,19,24,29,31,48,53,55,96,55,53,48,31,29,24,19,17,12,7,5,0];
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
~scale=[~scale1,~scale2,~scale3,~scale4,~scale5,~scale6])



/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\tone,{
arg attack=0.01,decay=2,tone=1,rate=1;
var sig,env,trig;

trig=Trig.kr(LFSaw.kr(rate.reciprocal),0.01);
env=EnvGen.ar(Env.perc(attack,decay),gate:trig,doneAction:0);
//sig=(LPF.ar(Saw.ar(220*tone,tone.reciprocal),220)*env)*(InFeedback(0).fold(0.1)+1);
sig=(LPF.ar(Saw.ar(220*tone,tone.reciprocal),440)*env);

Out.ar(1,sig);

}).add;
);
0.6.wait;

/////////////////////////////////////////////////////////////////////////////////////////////////////////pattern
({var m1=1.neg, m2=1.neg;
var m3=1.neg,n=0,bank=4,rhythm=4,time=32.reciprocal,beat=1;
var durx=[],dury=[],durz=[],durx1=[],dury1=[],durz1=[];
var dx=[],dy=[],dz=[],bx,by,bz,durx2,dury2,durz2;
(~azrth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elrth=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad]);
~dur=[];
bank.do{m1=m1+1;m2=m2+1;m3=m3+1;
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
dx=dx++bx; dy=dy++by;dz=dz++bz;
// bx=[]; by=[]; bz=[];};
~dur=~dur++bx++by++bz;
};
//n=0;
//rhythm.do{ durx=durx++dx.[n]; n=n+1;}; n=0;
//rhythm.do{ dury=dury++dy.[n]; n=n+1;}; n=0;
//rhythm.do{ durz=durz++dz.[n]; n=n+1;}; n=1;
//(rhythm-1).do{ durx1=durx1++dx.[n]; n=n+1;}; n=1;
//(rhythm-1).do{ dury1=dury1++dy.[n]; n=n+1;}; n=1;
//(rhythm-1).do{ durz1=durz1++dz.[n]; n=n+1;}; n=0;
//durx2=[dx.[4]]++durx1.reverse;
//dury2=[dy.[4]]++dury1.reverse;
//durz2=[dz.[4]]++durz1.reverse;
//~dur=~dur++durx++dury++durz++durx2++dury2++durz2;
//=~dur++durx++dury++durz;
}.value);


//~seq= Pseq(~dur ,inf).asStream;

//~intervalt=1;
//~dur=~dur*~intervalt;
//~dursum=~dur.sum;


TempoClock.default.tempo_(1);



///randomness p control

(
~pattern = Pdef(\1,
//Pbind( \instrument,\synth,
Pmono( \tone,
\dur,Pfunc{~dur.choose},
\tone,Pseq([3/2,2,1,4/3],inf),
\attack,Pfunc{~attack},
\decay,Pfunc{~decay},
\rate,Pfunc{~dur.choose}
)););
~pattern.play;


///fixed set control

(
~seqtn=Pseq([3/2,2,1,4/3],inf).asStream;
~dur=~dur*1;
~seq=Pseq(~dur,inf).asStream;
~attack=0.01;
~decay=2;
)
~syntht=Synth.new(\tone).register;
(
{var rot;
Routine({loop{
~syntht.set(\attack,~attack,\attack,~decay,\tone,~seqtn.next,\rate,~seq.next);
(~seq.next).wait;
};
}).play;
}.defer
)

}); Tdef(\drone).play;
}
)



