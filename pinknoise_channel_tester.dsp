import("stdfaust.lib");

// number of output channels
nchannels = 14;
// max-like gate
// note: if n == 0, gate is closed (which is not the case with ba.selectoutn) */
gate(o,n,s) = par(i,o, s*((n!=0)&(n==i+1)));

// resettable counter
rcounter(t,r) = (t > mem(t)) : (+ : *(r)) ~ _;
ms2samples(ms) = ms/1000*ma.SR;

pn = no.pink_noise * active * gain;

active = checkbox("on/off");
length = hslider("burst-length", 500, 250, 1000, 1);
offset = nentry("channel offset", 0, 0, nchannels, 1);
reset  = 1-button("reset");

channel = _ <: attach(_: vbargraph("channel[style:numerical]",-60,0));
gain = hslider("gain", 0, -12, 0, 0.1) : si.smooth(0.5) : ba.db2linear;

nsamples = ms2samples(length);

// we count from 0 to 2nsamples
// if <= nsamples, signal passes
// otherwise we output 0
phase = ba.sweep(active*reset, nsamples*2);
burst = phase <= nsamples;

// we increment channel index whenever sample counter reaches nsamples-1
// we wrap it around nchannels and add the offset
index = rcounter(burst, reset) % nchannels + offset + 1 : channel;
// process = index: printer;
process = gate(nchannels, index*burst, pn);


