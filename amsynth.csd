<CoundSynthesizer>
<CsOptions>
-odac -Ma --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1

giInitMidi   = 0

                opcode ReadMidiCC, 0, Siii
Sname, iindex, imin, imax xin
iMidiIndex      table iindex, 3
if giInitMidi == 0 then
iMidiValue      table iindex, 2
                initc7 1, iMidiIndex, (iMidiValue - imin) / (imax - imin)
                chnset iMidiValue, Sname
endif
kMidiValue      ctrl7 1, iMidiIndex, imin, imax
                chnset kMidiValue, Sname
                endop

instr 2

giEmpty ftgen 3, 0, -100, 2, 0
ftload "midi.txt", 1, 3


giEmpty ftgen 2, 0, -100, 2, 0
ftload "patch.txt", 1, 2

gaSend init 0

endin

instr 1

;OCS 1
ReadMidiCC "osc_attack", 0, 0, 2.5
ReadMidiCC "osc_decay", 1, 0, 2.5
ReadMidiCC "osc_sustain", 2, 0, 1.0
ReadMidiCC "osc_release", 3, 0, 2.5
ReadMidiCC "osc_waveform", 4, 0, 4.0
ReadMidiCC "osc_shape", 24, 0, 1.0

;Filter
ReadMidiCC "filter_attack", 5, 0, 2.5
ReadMidiCC "filter_decay", 6, 0, 2.5
ReadMidiCC "filter_sustain", 7, 0, 1.0
ReadMidiCC "filter_release", 8, 0, 2.5
ReadMidiCC "filter_reson", 9, 0, 0.97
ReadMidiCC "filter_env_amt", 10, -16, 16
ReadMidiCC "filter_cutoff", 11, -0.5, 1.5
ReadMidiCC "filter_key_track", 38, 0, 1

giInitMidi = 1

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99

iFreq = p4
iAmp = p5
iVelocity veloc 0, 1
iCutoff = 12

iDb db 12
i16 = 1 / 16
kRes = 0

;OCS 1
iAttMidi chnget "osc_attack"
iAtt pow iAttMidi, 3
iAtt = iAtt + 0.0005

;declick
if iAtt < 0.01 then
    iAtt = 0.01
endif

iDecMidi chnget "osc_decay"
iDec pow iDecMidi, 3
iDec = iDec + 0.0005

iSusMidi chnget "osc_sustain"
iSus = iSusMidi

iRelMidi chnget "osc_release"
iRel pow iRelMidi, 3
iRel = iRel + 0.0005

;declick
if iRel < 0.05 then
    iRel = 0.05
endif

iOsc1TypeMidi chnget "osc_waveform"
iOsc1Type round iOsc1TypeMidi

kShapeMidi chnget "osc_shape"
kShape scale kShapeMidi, 0.01, 0.5

;Filter
iFAttMidi chnget "filter_attack"
iFAtt pow iFAttMidi, 3
iFAtt = iFAtt + 0.0005

iFDecMidi chnget "filter_decay"
iFDec pow iFDecMidi, 3
iFDec = iFDec + 0.0005

iFSusMidi chnget "filter_sustain"
iFSus = iFSusMidi

iFRelMidi chnget "filter_release"
iFRel pow iFRelMidi, 3
iFRel = iFRel + 0.0005

; TODO (nonameentername) reson doesn't match
kFResMidi chnget "filter_reson"
kFRes scale kFResMidi, 11.0, 1.0

kFEnvAmtMidi chnget "filter_env_amt"
kFEnvAmt = kFEnvAmtMidi

kFCutoffMidi chnget "filter_cutoff"
kFCutoff pow 16, kFCutoffMidi

kFKeyTrackMidi chnget "filter_key_track"
kFKeyTrack = kFKeyTrackMidi 


if iOsc1Type == 0 then
    ;sine wave
    aVco oscil iAmp, iFreq, 1
elseif iOsc1Type == 1 then
    ;square / pulse
    aVco vco2 iAmp, iFreq, 2, kShape
elseif iOsc1Type == 2 then
    ;triangle / saw
    aVco vco2 iAmp, iFreq, 4, kShape
elseif iOsc1Type == 3 then
    ;white noise
    aVco noise iAmp, 0.5
else
    ;noise + sample & hold
    aVco randh iAmp, iFreq
endif

kEnv linsegr 0,iAtt,1,iDec,iSus,iRel,0

;key track
kCutoffBase = iTrackBaseFreq * (1 - kFKeyTrack) + iFreq * kFKeyTrack

kFCutoff = kFCutoff * kCutoffBase * iVelocity

kFEnv linsegr 0,iFAtt,1,iFDec,iFSus,iFRel,0

if kFEnvAmt > 0 then
    kFCutoff = kFCutoff + iFreq * kFEnv * kFEnvAmt
else
    kFCutoff = kFCutoff + kFCutoff * i16 * kFEnvAmt * kFEnv
endif

kFCutoff min kFCutoff, iMiddle
kFCutoff max kFCutoff, 10

aVco lowpass2 aVco * kEnv, kFCutoff, kFRes

print iOsc1Type, iAtt, iDec, iSus, iRel
print iFAtt, iFDec, iFSus, iFRel, iVelocity
printk 1, kFResMidi, 0, 1
printk 1, kFEnvAmt, 0, 1
printk 1, kFCutoffMidi, 0, 1
printk 1, kFKeyTrack, 0, 1

;outs aVco, aVco

gaSend = gaSend + aVco

;save the patch
iSave ctrl7  1, 106, 0, 1
if iSave == 1 then
    ;OCS 1
    tablew iAttMidi, 0, 2
    tablew iDecMidi, 1, 2
    tablew iSusMidi, 2, 2
    tablew iRelMidi, 3, 2
    tablew iOsc1TypeMidi, 4, 2
    tablew kShape, 24, 2
    ;Filter
    tablew iFAttMidi, 5, 2
    tablew iFDecMidi, 6, 2
    tablew iFSusMidi, 7, 2
    tablew iFRelMidi, 8, 2
    tablew kFResMidi, 9, 2
    tablew kFEnvAmtMidi, 10, 2
    tablew kFCutoffMidi, 11, 2
    tablew kFKeyTrackMidi, 38, 2
    ftsave "patch.txt", 1, 2
    print iSave
endif

endin

instr 99

ithresh ctrl7 1, 49, -100, 100
iloknee ctrl7 1, 50, -100, 100
ihiknee ctrl7 1, 51, -100, 100
iratio ctrl7 1, 52, 1.0, 100

print ithresh, iloknee, ihiknee, iratio

ithresh = -100
iloknee = -100
ihiknee = 100
iratio = 4
iatt = 0 
irel = 0 
ilook = 0 
ablank init 1
gaSend compress2 gaSend, ablank, ithresh, iloknee, ihiknee, iratio, iatt, irel, ilook 

outs gaSend, gaSend
clear gaSend

endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1
i 2 0 0
f0 3600
i 99 0 -1
</CsScore>
</CsoundSynthesizer>
