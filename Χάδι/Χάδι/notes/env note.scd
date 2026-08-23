(
~ne=1.neg;~arraye=56.collect{~ne=~ne+1;2.pow(~ne/56)};
~signalSizee = 2048*1;
)

(

signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.perc(0.5,0.5).asSignal(~signalSizee);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(peak, attack / peak) ++ Array.fill(signal.size - peak - 1, dicay / (signal.size - peak - 1));
enva = Env(rip.asArray, times).plot;
//env = EnvGen.ar(enva,doneAction:2)*gain;

)

(
Buffer.freeAll;
~wave=992;
~n=1.neg;~array=~wave.collect{~n=~n+1;2.pow(~n/~wave)};
~n=(0-(2pi/~wave)); ~ph=~wave.collect{~n=~n+(2pi/~wave);};
~bufferSize = 2048*1;~signalSize = 1024*1;
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
var peak,rip,env,enva,times,tremolo=32,sigsize,sig;
signal=Signal.sineFill(~signalSize,~array,~ph); wt = signal.asWavetable; ~wt.loadCollection(wt);
signal.plot;
/*peak = signal.maxIndex.max(1);
peak = peak.min(signal.size - 2).max(1);
sigsize = signal.asArray.size/8;
times = Array.fill(sigsize,~signalSize.reciprocal);
sig = Array.fill(sigsize,signal.asArray);
enva = Env(sig, times).plot;*/
}.value
);

{Osc.ar(~wt.bufnum,2,phase:0,mul:1)}.play
{BPF.ar((Osc.ar(~wt.bufnum,100,phase:0,mul:1024).abs*
SinOsc.ar(100,phase:0)),100,1,1)}.play
{BPF.ar((Osc.ar(~wt.bufnum,1,phase:0,mul:64).abs*Saw.ar(20,mul:1.neg)),55,0.1)!2}.play