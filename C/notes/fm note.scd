



(
{
	var mod,car=400;
	mod=SinOsc.ar(car/4,mul:MouseY.kr(0.1,car/4));
	SinOsc.ar(car+mod,mul:0.1);
}.play;
)