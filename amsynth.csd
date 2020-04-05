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
giPreviousFreq = 0
gkInstrCount = 0

                opcode ReadMidiCC, 0, Siii
Sname, iindex, imin, imax xin
iMidiIndex      table iindex, 3
if giInitMidi == 0 then
iMidiValue      table iindex, 2
iValue          = (iMidiValue - imin) / (imax - imin)
iValue          max iValue, 0.0
iValue          min iValue, 1.0
                initc7 1, iMidiIndex, iValue
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

gaSendL init 0
gaSendR init 0

endin

instr 1

;AMP
ReadMidiCC "amp_attack", 0, 0, 2.5
ReadMidiCC "amp_decay", 1, 0, 2.5
ReadMidiCC "amp_sustain", 2, 0, 1.0
ReadMidiCC "amp_release", 3, 0, 2.5

;OCS 1
ReadMidiCC "osc1_waveform", 4, 0, 4.0
ReadMidiCC "osc1_shape", 24, 0, 1.0

;OSC 2
ReadMidiCC "osc2_waveform", 13, 0, 4.0
ReadMidiCC "osc2_shape", 25, 0, 1.0
ReadMidiCC "osc2_octave", 18, -3, 4
ReadMidiCC "osc2_semitone", 34, -12, 12
ReadMidiCC "osc2_detune", 12, -1, 1

ReadMidiCC "osc_mix", 19, -1, 1
ReadMidiCC "osc_ring_mod", 23, 0, 1


ReadMidiCC "osc_portamento_time", 32, 0, 1
ReadMidiCC "osc_portamento_mode", 41, 0, 1

;Filter
ReadMidiCC "filter_attack", 5, 0, 2.5
ReadMidiCC "filter_decay", 6, 0, 2.5
ReadMidiCC "filter_sustain", 7, 0, 1.0
ReadMidiCC "filter_release", 8, 0, 2.5
ReadMidiCC "filter_reson", 9, 0, 0.97
ReadMidiCC "filter_env_amt", 10, -16, 16
ReadMidiCC "filter_cutoff", 11, -0.5, 1.5
ReadMidiCC "filter_type", 35, 0, 4.0
ReadMidiCC "filter_key_track", 38, 0, 1

;LFO
ReadMidiCC "lfo_waveform", 17, 0, 6.0
ReadMidiCC "lfo_freq", 16, 0, 7.5
ReadMidiCC "lfo_to_osc", 37, 0, 2.0
ReadMidiCC "lfo_freq_amount", 20, 0, 1.25992105
ReadMidiCC "lfo_filter_amount", 21, -1, 1
ReadMidiCC "lfo_amp_amount", 22, -1, 1

;Reverb
ReadMidiCC "reverb_amount", 28, 0, 1
ReadMidiCC "reverb_size", 26, 0, 1
ReadMidiCC "reverb_width", 29, 0, 1
ReadMidiCC "reverb_damp", 27, 0, 1

giInitMidi = 1

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99

iFreq = p4
iAmp = p5
iVelocity veloc 0, 1

i16 = 1 / 16

;OCS 1
iAttMidi chnget "amp_attack"
iAtt pow iAttMidi, 3
iAtt = iAtt + 0.0005

;declick
if iAtt < 0.01 then
    iAtt = 0.01
endif

iDecMidi chnget "amp_decay"
iDec pow iDecMidi, 3
iDec = iDec + 0.0005

iSusMidi chnget "amp_sustain"
iSus = iSusMidi

iRelMidi chnget "amp_release"
iRel pow iRelMidi, 3
iRel = iRel + 0.0005

;declick
if iRel < 0.05 then
    iRel = 0.05
endif

iOsc1TypeMidi chnget "osc1_waveform"
iOsc1Type round iOsc1TypeMidi

kOsc1ShapeMidi chnget "osc1_shape"
kOsc1Shape scale kOsc1ShapeMidi, 0.01, 0.5

;OSC 2
iOsc2TypeMidi chnget "osc2_waveform"
iOsc2Type round iOsc2TypeMidi

kOsc2ShapeMidi chnget "osc2_shape"
kOsc2Shape scale kOsc2ShapeMidi, 0.02, 0.5

kOsc2OctaveMidi chnget "osc2_octave"
kOsc2Octave round kOsc2OctaveMidi
kOsc2Octave octave kOsc2Octave

kOsc2SemitoneMidi chnget "osc2_semitone"
kOsc2Semitone round kOsc2SemitoneMidi
kOsc2Semitone semitone kOsc2Semitone

kOsc2DetuneMidi chnget "osc2_detune"
kOsc2Detune pow 1.25, kOsc2DetuneMidi

;LFO
iLfoTypeMidi chnget "lfo_waveform"
kLfoType round iLfoTypeMidi 

kLfoFreqMidi chnget "lfo_freq"
kLfoFreq pow kLfoFreqMidi, 2

kLfoToOscMidi chnget "lfo_to_osc"
kLfoToOsc round kLfoToOscMidi 

kLfoFreqAmountMidi chnget "lfo_freq_amount"
kLfoFreqAmount pow kLfoFreqAmountMidi, 3
kLfoFreqAmount = kLfoFreqAmount - 1
kLfoFreqAmount = kLfoFreqAmount / 2 + 0.5

kLfoFilterAmountMidi chnget "lfo_filter_amount"
kLfoFilterAmount = kLfoFilterAmountMidi 
kLfoFilterAmount = kLfoFilterAmount / 2 + 0.5

kLfoAmpMidi chnget "lfo_amp_amount"
kLfoAmp = kLfoAmpMidi
kLfoAmp = ( kLfoAmp + 1 ) / 2

;Mix
kOscMixMidi chnget "osc_mix"
kOscMix = kOscMixMidi

kOscRingModMidi chnget "osc_ring_mod"
kOscRingMod = kOscRingModMidi

kOsc1Vol = (1 - kOscMix) / 2
kOsc1Vol = kOsc1Vol * (1 - kOscRingMod)

kOsc2Vol = (1 + kOscMix) / 2
kOsc2Vol = kOsc2Vol * (1 - kOscRingMod)

;Reverb
kReverbAmountMidi chnget "reverb_amount"
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_size"
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget "reverb_width"
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget "reverb_damp"
kReverbDamp  = kReverbDampMidi

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

kFTypeMidi chnget "filter_type"
kFType round kFTypeMidi

kFKeyTrackMidi chnget "filter_key_track"
kFKeyTrack = kFKeyTrackMidi 

iPortamentoTimeMidi chnget "osc_portamento_time"
kPortamentoTime = iPortamentoTimeMidi

iPortamentoModeMidi chnget "osc_portamento_mode"
kPortamentoMode round iPortamentoModeMidi

gkInstrCount active 1, 0, 1

if gkInstrCount <= 1 && kPortamentoMode == 1 then
    kFreq = iFreq
else
    kFreq portk iFreq, kPortamentoTime / 4, giPreviousFreq
endif

if kLfoType == 0 then
    ;sine
    aLfoOsc lfo 1, kLfoFreq, 0
elseif kLfoType == 1 then
    ;square
    aLfoOsc lfo 1, kLfoFreq, 2
elseif kLfoType == 2 then
    ;triangle
    aLfoOsc lfo 1, kLfoFreq, 1
elseif kLfoType == 3 then
    ;white noise
    aLfoOsc noise 1, 0.5
elseif kLfoType == 4 then
    ;noise + sample & hold
    if kLfoFreq == 0 then
        kLfoFreq = kFreq
    endif
    aLfoOsc randh 1, kLfoFreq
elseif kLfoType == 5 then
    ;sawtooth up
    aLfoOsc lfo 1, kLfoFreq, 4
else
    ;sawtooth down
    aLfoOsc lfo 1, kLfoFreq, 5
endif

if kLfoToOsc == 0 || kLfoToOsc == 1 then
    kOsc1Lfo = kFreq * ( kLfoFreqAmount * ( aLfoOsc + 1 ) + 1 - kLfoFreqAmount )
    kOsc1Freq min kOsc1Lfo, sr / 2
endif

if iOsc1Type == 0 then
    ;sine wave
    aOsc1 oscil iAmp, kOsc1Freq, 1
elseif iOsc1Type == 1 then
    ;square / pulse
    aOsc1 vco2 iAmp, kOsc1Freq, 2, kOsc1Shape
elseif iOsc1Type == 2 then
    ;triangle / saw
    aOsc1 vco2 iAmp, kOsc1Freq, 4, kOsc1Shape
elseif iOsc1Type == 3 then
    ;white noise
    aOsc1 noise iAmp, 0.5
else
    ;noise + sample & hold
    aOsc1 randh iAmp, kOsc1Freq
endif

kOsc2Freq = kFreq * kOsc2Octave * kOsc2Semitone * kOsc2Detune

if kLfoToOsc == 0 || kLfoToOsc == 2 then
    kOsc2Lfo = kOsc2Freq * ( kLfoFreqAmount * ( aLfoOsc + 1 ) + 1 - kLfoFreqAmount )
    kOsc2Freq min kOsc2Lfo, sr / 2
endif

if iOsc2Type == 0 then
    ;sine wave
    aOsc2 oscil iAmp, kOsc2Freq, 1
elseif iOsc2Type == 1 then
    ;square / pulse
    aOsc2 vco2 iAmp, kOsc2Freq, 2, kOsc2Shape
elseif iOsc2Type == 2 then
    ;triangle / saw
    aOsc2 vco2 iAmp, kOsc2Freq, 4, kOsc2Shape
elseif iOsc2Type == 3 then
    ;white noise
    aOsc2 noise iAmp, 0.5
else
    ;noise + sample & hold
    aOsc2 randh iAmp, kOsc2Freq
endif

aVco = aOsc1 * kOsc1Vol + aOsc2 * kOsc2Vol + kOscRingMod * aOsc1 * aOsc2

kEnvLfo = ( ( aLfoOsc * 0.5 + 0.5 ) * kLfoAmp + 1 - kLfoAmp )

kEnv linsegr 0,iAtt,1,iDec,iSus,iRel,0
kEnv = kEnv * kEnvLfo

;key track
kCutoffBase = iTrackBaseFreq * (1 - kFKeyTrack) + kFreq * kFKeyTrack

kFCutoffLfo = ( aLfoOsc * 0.5 + 0.5 ) * kLfoFilterAmount + 1 - kLfoFilterAmount

kFCutoff = kFCutoff * kCutoffBase * iVelocity * kFCutoffLfo

kFEnv linsegr 0,iFAtt,1,iFDec,iFSus,iFRel,0

if kFEnvAmt > 0 then
    kFCutoff = kFCutoff + kFreq * kFEnv * kFEnvAmt
else
    kFCutoff = kFCutoff + kFCutoff * i16 * kFEnvAmt * kFEnv
endif

kFCutoff min kFCutoff, iMiddle
kFCutoff max kFCutoff, 10

if kFType == 0 then
    ;lowpass
    aVco rbjeq aVco * kEnv, kFCutoff, 1, kFRes, 1, 0
elseif kFType == 1 then
    ;highpass
    aVco rbjeq aVco * kEnv, kFCutoff, 1, kFRes, 1, 2
elseif kFType == 2 then
    ;bandpass
    aVco rbjeq aVco * kEnv, kFCutoff, 1, kFRes, 1, 4
elseif kFType == 3 then
    ;band-reject
    aVco rbjeq aVco * kEnv, kFCutoff, 1, kFRes, 1, 6
else
    ;peaking eq
    aVco rbjeq aVco * kEnv, kFCutoff, 1, kFRes, 1, 8
endif

gaSendL = gaSendL + aVco
gaSendR = gaSendR + aVco

;save the patch
iSave ctrl7  1, 106, 0, 1
if iSave == 1 then
    ;OCS 1
    tablew iAttMidi, 0, 2
    tablew iDecMidi, 1, 2
    tablew iSusMidi, 2, 2
    tablew iRelMidi, 3, 2
    tablew iOsc1TypeMidi, 4, 2
    tablew kOsc1ShapeMidi, 24, 2
    ;OCS 2
    tablew iOsc2TypeMidi, 13, 2
    tablew kOsc2ShapeMidi, 25, 2
    tablew kOsc2OctaveMidi, 18, 2
    tablew kOsc2SemitoneMidi, 34, 2
    tablew kOsc2DetuneMidi, 12, 2
    tablew kOscMixMidi, 19, 2
    tablew kOscRingModMidi, 23, 2
    ;LFO
    tablew iLfoTypeMidi, 17, 2
    tablew kLfoFreqMidi, 16, 2
    tablew kLfoToOscMidi, 37, 2
    tablew kLfoFreqAmountMidi, 20, 2
    tablew kLfoFilterAmountMidi, 21, 2
    tablew kLfoAmpMidi, 22, 2
    ;Reverb
    tablew kReverbAmountMidi, 28, 2
    tablew kReverbSizeMidi, 26, 2
    tablew kReverbWidthMidi, 29, 2
    tablew kReverbDampMidi, 27, 2
    ;Filter
    tablew iFAttMidi, 5, 2
    tablew iFDecMidi, 6, 2
    tablew iFSusMidi, 7, 2
    tablew iFRelMidi, 8, 2
    tablew kFResMidi, 9, 2
    tablew kFEnvAmtMidi, 10, 2
    tablew kFCutoffMidi, 11, 2
    tablew iPortamentoTimeMidi, 32, 2
    tablew iPortamentoModeMidi, 41, 2
    tablew kFTypeMidi, 35, 2
    tablew kFKeyTrackMidi, 38, 2
    ftsave "patch.txt", 1, 2
    print iSave
endif

giPreviousFreq init iFreq

endin

instr 99

;Reverb
kReverbAmountMidi chnget "reverb_amount"
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_size"
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget "reverb_width"
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget "reverb_damp"
kReverbDamp  = kReverbDampMidi

ithresh ctrl7 1, 49, -100, 100
iloknee ctrl7 1, 50, -100, 100
ihiknee ctrl7 1, 51, -100, 100
iratio ctrl7 1, 52, 1.0, 100

ithresh = -100
iloknee = -100
ihiknee = 100
iratio = 4
iatt = 0 
irel = 0 
ilook = 0 
ablank init 1

aReverbL, aReverbR freeverb gaSendL, gaSendR, kReverbSize, kReverbDamp

kWet1 = kReverbAmount * ( kReverbWidth / 2 + 0.5 )
kWet2 = kReverbAmount * ( ( 1 - kReverbWidth ) / 2 )
kDry = 1 - kReverbAmount

aLeft = aReverbL * kWet1 + aReverbR * kWet2 + gaSendL * kDry
aRight = aReverbR * kWet1 + aReverbL * kWet2 + gaSendR * kDry

aCompressL compress2 aLeft, ablank, ithresh, iloknee, ihiknee, iratio, iatt, irel, ilook 
aCompressR compress2 aRight, ablank, ithresh, iloknee, ihiknee, iratio, iatt, irel, ilook 

outs aCompressL, aCompressR
clear gaSendL, gaSendR

endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1
i 2 0 0
f0 3600
i 99 0 -1
</CsScore>
</CsoundSynthesizer>
