 ///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=8;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
s.meter;
s.freqscope;
s.scope;
);
~img = Image.open("/Users/rohifes/Documents/Literary/Portfolio/SuperCollider/2026/Χάδι/img.png");
s.waitForBoot{
~clock=TempoClock.default.tempo_(2);
Tdef(\drone, {
//////point arrays
/*////l system boolean
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
0.1.wait;*/

///////tetrahedron
(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

/////////cube
(
~azc=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~elc=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
);
0.1.wait;

///////////inputs
~rx=0;~ry=0;~rz=0;~gain=1;~fundament=0;~resonance=0;~harmonic=1;~fold=0;~perspective=0;~room=0;~azs=0;~els=0;
~azr=1;~elr=1;
~temperament=16256;
~lagtime=1/128;
~rate=2048.reciprocal;
~x=0;~y=0;~z=0;
~frames=~rate;
~ffreq=16;
~window=110;
~dur=~frames*~window;

//angle compensatiom
~s=(1+2.sqrt);
~g=((1+5.sqrt)/2);

//////////rotation
(
{var sph,az,el,n;
Routine({loop{
n=0;~az=[];~el=[];
4.do{
az=~azimuth.[n];
el=~elevation.[n];
n=n+1;
sph=Spherical(1,az,el);
sph=sph.rotateXY(~z.lag2(~lagtime)).asSpherical;///static z interferance
//sph=sph.rotateYZ(~x.lag2(~lagtime)).rotateXZ(~y.lag2(~lagtime)).rotateXY(~z.lag2(~lagtime));//orchestral
~az=~az++[sph.theta];
~el=~el++[sph.phi];
};
(~dur).wait;
};
}).play;
}.defer
);

(
{var rot;
Routine({loop{
//rot=Spherical(~dur,~azr,~elr);
//~x=(~x+rot.x.abs).wrap(0,2pi);
//~y=(~y+rot.y.abs).wrap(0,2pi);
//~z=(~z+rot.z.abs).wrap(0,2pi);
~z=(~z+(~azr*((2pi-(2pi/~g))*~rate))).wrap(0,2pi);
(~dur).wait;
};
}).play;
}.defer
);
0.1.wait;

////////////osc table
(
~n=1.neg;~array=16256.collect{~n=~n+1;2.pow(~n/16256)};
~n=(0-(2pi/~temperament)); ~ph=16256.collect{~n=~n+(2pi/16256);};
~bufferSize = 2048*8;~signalSize = 1024*8;
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
signal=Signal.sineFill(~signalSize,~array,~ph); wt = signal.asWavetable; ~wt.loadCollection(wt);
//signal.plot;
}.value
);
0.5.wait;

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

///synth
~fuselim=(16256*9).neg;
~comp=0.5;
(
SynthDef.new(\synth,{

arg gain=0,az=#[0,0,0,0],el=#[0,0,0,0],fundamental=0,resonanse=0,harm=1,room=0,drive=0,mag=0,attack=0.1,
	decay=1,trig=0,tone=1,key=0,hold=0.1,scselect=0;
var level,c,res,revroom,overdrive,x,y,z,tx,ty,tz,trange,busarray2,pan1,pan2,env,pitchx,pitchy,pitch;
var freqx,freqy,freqz,ampx,ampy,ampz,tonex,toney,tonez,tune=~ffreq*(9/8),phasex,phasey,phasez;
var c1,c2,c3,sigx,sigy,sigz,azn,eln,cx,cy,cz,g1,g2,g3,g4,g5,g6,g7,g8;
var n=0,polytope=1,busarray1,harmonic,note,fund,mix,perspective=3;

///inputs
level=2.pow(gain.lag2(~lagtime)/16256)*10;
c=2.pow(fundamental.lag2(~lagtime)/16256);
res=2.pow(resonanse.lag2(~lagtime)/16256);
revroom=2.pow(room.lag2(~lagtime)/16256);
overdrive=2.pow(drive.lag2(~lagtime)/16256);
harmonic=2.pow(harm.lag2(~lagtime)/12);
trange=mag.lag2(~lagtime);
//distance=perspective;
note=2.pow(key.lag2(~lagtime)/12);

fund=c*tune;

pitch=exp(Complex(0,1)*tone);
pitchx=2.pow(Select.kr((pitch.real*~note).abs,Select.kr(scselect,~scale))/12);
pitchy=2.pow(Select.kr((pitch.imag*~note).abs,Select.kr(scselect,~scale))/12);

//env fft
env=EnvGen.ar(Env.sine(hold),gate:1,levelScale:1/64,doneAction:2);
polytope.do{
azn=az.[n].lag2(~lagtime);
eln=el.[n].lag2(~lagtime);

///cardioid
x = (harmonic*cos(eln)*cos(azn))+(cos(harmonic*(azn))*cos(harmonic*(azn)));
y = (harmonic*cos(eln)*sin(azn))+(cos(harmonic*(azn))*sin(harmonic*(azn)));
z = (harmonic*sin(eln))+(sin(harmonic*(eln)));

////cartesian
//x = (cos(eln)*cos(azn));
//y = (cos(eln)*sin(azn));
//z = (sin(eln));

////temperament
tx = (trange*x);
ty = (trange*y);
tz = (trange*z);
tonex=2.pow(tx.round(1)/~temperament);
toney=2.pow(ty.round(1)/~temperament);
tonez=2.pow(tz.round(1)/~temperament);

////osc data
freqx=(fund*pitchx)*tonex*note;
freqy=(fund*pitchy)*toney*note;
freqz=fund*tonez*note;
ampx=c.reciprocal*tonex.reciprocal*level*note.reciprocal;
ampy=c.reciprocal*toney.reciprocal*level*note.reciprocal;
ampz=c.reciprocal*tonez.reciprocal*level*note.reciprocal;
//phasex=(Complex(1,x).theta*2);
//phasey=(Complex(1,y).theta*2);
//phasez=(Complex(1,z).theta*2);
//phasex=atan2(x,y);
//phasey=atan2(y,z);
//phasez=atan2(z,x);
phasex=(x*pi);
phasey=(y*pi);
phasez=(z*pi);

//////perspective
//diameter=level*distance;
//immersion = diameter / (diameter + z.abs + (diameter/view));
//immersion=z.abs;
//ampx=ampx*immersion;
//ampy=ampy*immersion;
//phasex=(phasex*immersion).wrap(2pi.neg,2pi);
//phasey=(phasey*immersion).wrap(2pi.neg,2pi);

mix=overdrive.linlin(1,2.pow(~fuselim/16256),2.pow(~fuselim/16256),1);
/////////osc
c1=BPF.ar((Osc.ar(~wt.bufnum,freqx,phase:phasex,mul:1024).abs*
SinOsc.ar(freqx,phase:phasex)),freqx,res,ampx*x.sign);
c2=BPF.ar((Osc.ar(~wt.bufnum,freqy,phase:phasey,mul:1024).abs*
SinOsc.ar(freqy,phase:phasey)),freqy,res,ampy*y.sign);
c3=BPF.ar((Osc.ar(~wt.bufnum,freqz,phase:phasez,mul:1024).abs*
SinOsc.ar(freqz,phase:phasez)),freqz,res,ampz*z.sign);

////volts rect
c1=c1.lag2(~signalSize.reciprocal)*
(LPF.ar(Saw.ar(tune,(ampz)),tune*64*overdrive).fold2(mix*0.05)+((ampz)));
c2=c2.lag2(~signalSize.reciprocal)*
(LPF.ar(Saw.ar(tune,(ampz)),tune*64*overdrive).fold2(mix*0.05)+((ampz)));
//c3=c3.lag2(~signalSize.reciprocal)*
//(LPF.ar(Saw.ar(tune,(ampz)),tune*64*overdrive).fold2(mix*0.05)+((ampz)));

///distortion

sigx=FreeVerb.ar((c1).fold2(overdrive*5),overdrive,room);
sigy=FreeVerb.ar((c2).fold2(overdrive*5),overdrive,room);
sigz=FreeVerb.ar((c3),overdrive,room);

/////////spat
//panners
(
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
pan2=[g2,g4,g6,g8];

busarray1=[0,2,4,5];
busarray2=[1,3,6,7];

//env vca
//envp=EnvGen.ar(Env.perc(attack,decay),gate:trig,doneAction:2);

///wavefield out

Out.ar(busarray1.[n],(LeakDC.ar((sigx)*(sigz.fold2(overdrive*0.1)+(ampz)))*env).softclip(1));
Out.ar(busarray2.[n],(LeakDC.ar((sigy)*(sigz.fold2(overdrive*0.1)+(ampz)))*env).softclip(1));

///pann out
//Out.ar(busarray1.[n],(LeakDC.ar((sigx)*(sigz.fold2(overdrive*0.5)+(ampz)))*env*pan1[n]).softclip(1));
//Out.ar(busarray2.[n],(LeakDC.ar((sigy)*(sigz.fold2(overdrive*0.5)+(ampz)))*env*pan2[n])).softclip(1));
n=n+1;
}
}).add;
);
1.wait;

////////////////run
//~synth=Synth.new(\synth).register;
0.5.wait;
///////////////////feed
~clock = TempoClock(1);
(
{
Routine({loop{
//~synth.set(\az,[~az.[0],~az.[1],~az.[2],~az.[3]],\el,[~el.[0],~el.[1],~el.[2],~el.[3]]);
~azset=~az;
~elset=~el;
(~frames).wait
}
}).play;
}.defer
);

///trigger
~trig=Pseq([1,0],inf).asStream;
~sn=Pseq([7,10,8,9,11,12],inf).asStream;
~rhythm=1;
(
{
Routine({loop{
//~synth.set(\az,[~az.[0],~az.[1],~az.[2],~az.[3]],\el,[~el.[0],~el.[1],~el.[2],~el.[3]]);
~gate=~trig.next;
~setnote=~sn.next;
(~rhythm).wait
}
}).play;
}.defer
);

///data
(
~attack=0.01;
~decay=4;
~hold=~dur*~ffreq;
~fundamental=0;
~tone=0;
~gain=1;
~resonanse=1;
~harm=1;
~drive=0;
~perspective=1;
~room=0;
~mag=0;
~tone=1;
~scaleselect=0;
);

///pattern
0.1.wait;
(~pattern = Pdef(\1,
Pbind(\instrument, \synth,
\dur, Pfunc{~dur},
\gain,Pfunc{~gain},
\fundamental,Pfunc{~fundamental},
\tone,Pfunc{~tone},
\resonanse,	Pfunc{~resonanse},
\harm,Pfunc{~harm},
\drive,Pfunc{~drive},
\room,Pfunc{~room},
\mag,Pfunc{~mag},
\az,Pfunc{Ref([~azset.[0],~azset.[1],~azset.[2],~azset.[3]])},
\el,Pfunc{Ref([~elset.[0],~elset.[1],~elset.[2],~elset.[3]])},
//\attack,Pfunc{~attack},
\hold,Pfunc{~hold},
//\decay,Pfunc{~decay},
//\trig,Pfunc{~gate},
\key,Pfunc{0},
\scselect,Pfunc{~scaleselect}
)));
~pattern.play(~clock);

////////////////////////gui
(
{
var size=550,sk=(size/12),w,rol=0,sz=0.5,wd=3.5,shift=1;

w = Window("tws", Rect(50, 50, size, size/2)).front;
~vw1 = UserView(w, Rect(0,0,size,size/2)).drawFunc_({ ~img.drawInRect(~vw1.bounds)});//.background_(Color.black);
~logView1 = ListView( ~vw1, Rect(0, 0, size/4, size/2)).background_(Color.black)
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
~st1=StaticText(~vw1,Rect(50,50+sk,sk+20,sk)).string_("r_tune")
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
~st2=StaticText(~vw1,Rect(150,50+sk,sk+20,sk)).string_("scale")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl3=Knob.new(~vw1, Rect.new(250,50,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*12).neg,0).round(1).postln;
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
value=obj.value.linlin(0,1,0,16256*2).round(1).postln;
//~synth.set(\fundamental,value);
~fundamental=value;
~log1.(value.asString);
});
~st4=StaticText(~vw1,Rect(350,50+sk,sk+20,sk)).string_("fundamental")
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
value=obj.value.linlin(0,1,0,12*3).postln;
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
~st7=StaticText(~vw1,Rect(150,(50+sk+50+25+sk),sk+20,sk)).string_("fusion")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

(
~sl8=Knob.new(~vw1, Rect.new(250,50+sk+50+25,sk, sk)).background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,8).postln;
//~synth.set(\perspective,value);
~decay=value;
~log1.(value.asString);
});
~st8=StaticText(~vw1,Rect(250,(50+sk+50+25+sk),sk+20,sk)).string_("decay")
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
value=obj.value.linlin(0,1,0,~temperament).round(1).postln;
//~synth.set(\mag,value);
~mag=value;
~log1.(value.asString);
});
~st10=StaticText(~vw1,Rect(450,(50+sk+50+25+sk),sk+20,sk)).string_("magnitude")
.stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
);

}.defer
)
}); Tdef(\drone).play;
}
)



////midi
(
MIDIClient.init;
MIDIIn.connectAll;

(
(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
var az;
az=val.linlin(0,127,pi.neg,pi).round(0.0001);
az.postln;
},1);
);
(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|

},2);
);
(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|

},3);
);
(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|

},4);
);
(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|

},5);
);
(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|

},6);
);
(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|

},7);
);
(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|

},8);
);
(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|

},9);
);
(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|

},10);
);
(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
var a;
if(val>0,a=1);
a.postln;
},11);
);
(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
},12);
);
(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
},13);
);
(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
},14);
);
(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
},15);
);
(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
},21);
);
(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
},22);
);
(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
},23);
);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
},24);
);
(
MIDIdef.cc(\midi_slider5,{ |val, num, chan, src|
},25);
);
(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
},26);
);
(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
},27);
);
(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
},28);
);
(
MIDIdef.cc(\midi_slider9,{ |val, num, chan, src|
},29);
);
(
MIDIdef.cc(\midi_filterpot1,{ |val, num, chan, src|

},30);
);
(
MIDIdef.cc(\midi_filterpot2,{ |val, num, chan, src|

},31);
);
(
MIDIdef.cc(\midi_filterpot3,{ |val, num, chan, src|

},32);
);
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



/*({var x,y,z,n=0,time=32.reciprocal,bx,by,bz,beat=4;~dursum=0;
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