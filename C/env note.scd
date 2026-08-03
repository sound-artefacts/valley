{(LFSaw.ar(2,mul:1.neg)*Pulse.ar(2,0.5,mul:1).abs)}.play

{Pulse.ar(20,0.5,mul:0.1).abs}.play

(
{
	var m;
	m=MouseX.kr(0.1,2);
	(Saw.ar(10*m,mul:1.neg)*LFPulse.ar(10*m,0.5,mul:1))

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