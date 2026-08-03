{(LFSaw.ar(2,mul:1.neg)*Pulse.ar(2,1,mul:1,add:1)).abs}.play

{Pulse.ar(20,0.5,mul:0.1).abs}.play

	 (
		 	~senv=Buffer.alloc(s,2048);
		 	{
		 		var signal,wt;
		 		signal=Env([0,1,0.8,0,0],[0.1,0.5,0.5],[4.neg,4.neg,4.neg,0]);
				wt = signal.asSignal(1024).asWavetable;
				~senv.loadCollection(wt);
				signal.plot;
		 	}.value;
		);
(
var  signal,peak,rip,attack=1,dicay=1,env,enva,times,tremolo=32,wt;
signal = Signal.sineFill(1024, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env([0,1,1,0,0],[0.1,0.5,0.5],[4.neg,0,4.neg,0]).asSignal(1024);
rip = rip * (1 + (signal / tremolo));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(peak, attack / peak) ++ Array.fill(signal.size - peak - 1, dicay / (signal.size - peak - 1));
enva = Env(rip.asArray, times);
wt = enva.asSignal(1024).asWavetable;
~senv.loadCollection(wt);
enva.plot;

)


(
{
	var m,n;
	m=MouseX.kr(0.1,2);
n=MouseY.kr(0.1,1);
	//(SinOsc.ar(10*m,mul:1.neg,add:1)*LFPulse.ar(10*m*n,width:1,mul:1). abs)
//(Saw.ar(10*m,mul:1.neg)*LFPulse.ar(10*m,width:1,mul:1)).abs
(Osc.ar(~senv.bufnum,10*m,mul:1)*LFPulse.ar((10/2)*m,width:0.5,mul:1))
//(LFSaw.ar(2,mul:1.neg)*Pulse.ar(2,mul:1).abs)

}.play
)

(
{
	var m;
	m=MouseX.kr(0.1,8);
((LPF.ar((Osc.ar(~wt.bufnum,5*m,mul:500.neg).abs*
		SinOsc.ar(5*m)).abs,m*100,1))*(LPF.ar((Osc.ar(~wt.bufnum,5*m,mul:500).abs*
		LFPulse.ar(5*m,width:0.5)),m*100,1)).abs)

}.play
)