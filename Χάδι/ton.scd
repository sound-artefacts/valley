
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



///fixed set control rhythm

(~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad])

TempoClock.default.tempo_(8);
(
(
~seqtn=Pseq([3/2,2,1,4/3],inf).asStream;
~attack=0.01;
~decay=4;
);
~syntht=Synth.new(\tone).register;
(
{var x,y,z,beat=4,bx,by,bz,time=32.reciprocal;
Routine({loop{
~dur=[];
x=beat*cos(~el.[0])*cos(~az.[0]);
y=beat*cos(~el.[0])*sin(~az.[0]);
z=beat*sin(~el.[0]);
bx=2.pow(x).round(time);
by=2.pow(y).round(time);
bz=2.pow(z).round(time);
~dur=~dur++bx++by++bz;
~seq=Pseq(~dur,inf).asStream;
(0.0001).wait;
};
}).play;
}.defer
);
(
{var rot;
Routine({loop{
~syntht.set(\attack,~attack,\attack,~decay,\tone,~seqtn.next,\rate,~seq.next);
(~seq.next).wait;
};
}).play;
}.defer
)
)

}); Tdef(\drone).play;
}
)
