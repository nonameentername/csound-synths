<CoundSynthesizer>
<CsOptions>
-odac -Ma --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1

gknum init 0
gkPreviousFreq = 0
giPrevInstrFreq = 0
gkInstrCount = 0
gaSendL init 0
gaSendR init 0

massign 0, 0
massign 1, 1

instr 11

kKeyboardModeMidi chnget "keyboard_mode"
kKeyboardMode round kKeyboardModeMidi

iInstr = 1
gknotes	init	0
kkeys[]  init   128
kcounter init   1
kstatus, kchan, kb1, kb2	midiin
kFreq mtof kb1
kAmp = kb2 / 127

if kstatus == 144 && kb2 != 0 then
    if gknotes == 0 then
        kcounter = 1
        if kKeyboardMode != 0 then
            turnoff2 iInstr, 0, 1
            schedkwhen	1, 0, 0, iInstr, 0, -1, kFreq, kAmp, gkPreviousFreq
        endif
    else
        kcounter = kcounter + 1
    endif
    gknum	=	kb1
    gknotes	=	gknotes + 1
    gknoteon = 1
    kkeys[gknum] = kcounter
    gkPreviousFreq = kFreq
elseif kstatus == 144 && kb2 == 0 || kstatus == 128 then
    kkeys[kb1] = 0
    if gknotes == 1 then
        gknum = kb1
        if kKeyboardMode != 0 then
            schedkwhen	1, 0, 0, -iInstr, 0, 0, kFreq, kAmp, -1
        endif
        kcounter = 0
    else
        klargest = 0
        kindex = 0
        until kindex == 128 do
            if kkeys[kindex] > kkeys[klargest] then
                klargest = kindex
            endif
            kindex = kindex + 1
        od
        if kkeys[klargest] > 0 then
            gknum	=	klargest
        endif
        if kKeyboardMode == 1 then
            schedkwhen	1, 0, 0, -iInstr, 0, 0, kFreq, kAmp, -1
            schedkwhen	1, 0, 0, iInstr, 0, -1, kFreq, kAmp, -1
        endif

    endif
    if gknotes > 0 then
        gknotes = gknotes - 1
        gknoteon = 0
    endif
    if gknotes == 0 then
        turnoff2 iInstr, 0, 1
    endif
    gkPreviousFreq = kFreq
endif

endin

instr 1

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99

iFreq = p4
iAmp = p5
iPreviousFreq = p6
iVelocity veloc 0, 1

i16 = 1 / 16

kKeyboardModeMidi chnget "keyboard_mode"
kKeyboardMode round kKeyboardModeMidi

kMasterVolMidi chnget "master_vol"
kMasterVol = kMasterVolMidi

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

kOsc1ShapeMidi chnget "osc1_pulsewidth"
kOsc1Shape scale kOsc1ShapeMidi, 0.01, 0.5

;OSC 2
iOsc2TypeMidi chnget "osc2_waveform"
iOsc2Type round iOsc2TypeMidi

kOsc2ShapeMidi chnget "osc2_pulsewidth"
kOsc2Shape scale kOsc2ShapeMidi, 0.02, 0.5

kOsc2OctaveMidi chnget "osc2_range"
kOsc2Octave round kOsc2OctaveMidi
kOsc2Octave octave kOsc2Octave

kOsc2SemitoneMidi chnget "osc2_pitch"
kOsc2Semitone round kOsc2SemitoneMidi
kOsc2Semitone semitone kOsc2Semitone

kOsc2DetuneMidi chnget "osc2_detune"
kOsc2Detune pow 1.25, kOsc2DetuneMidi

;LFO
iLfoTypeMidi chnget "lfo_waveform"
kLfoType round iLfoTypeMidi 

kLfoFreqMidi chnget "lfo_freq"
kLfoFreq pow kLfoFreqMidi, 2

kLfoToOscMidi chnget "freq_mod_osc"
kLfoToOsc round kLfoToOscMidi 

kLfoFreqAmountMidi chnget "freq_mod_amount"
kLfoFreqAmount pow kLfoFreqAmountMidi, 3
kLfoFreqAmount = kLfoFreqAmount - 1
kLfoFreqAmount = kLfoFreqAmount / 2 + 0.5

kLfoFilterAmountMidi chnget "filter_mod_amount"
kLfoFilterAmount = kLfoFilterAmountMidi 
kLfoFilterAmount = kLfoFilterAmount / 2 + 0.5

kLfoAmpMidi chnget "amp_mod_amount"
kLfoAmp = kLfoAmpMidi
kLfoAmp = ( kLfoAmp + 1 ) / 2

;Mix
kOscMixMidi chnget "osc_mix"
kOscMix = kOscMixMidi

kOscRingModMidi chnget "osc_mix_mode"
kOscRingMod = kOscRingModMidi

kOsc1Vol = (1 - kOscMix) / 2
kOsc1Vol = kOsc1Vol * (1 - kOscRingMod)

kOsc2Vol = (1 + kOscMix) / 2
kOsc2Vol = kOsc2Vol * (1 - kOscRingMod)

;Reverb
kReverbAmountMidi chnget "reverb_wet"
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_roomsize"
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
kFResMidi chnget "filter_resonance"
kFRes scale kFResMidi, 20.0, 1.0

kFEnvAmtMidi chnget "filter_env_amount"
kFEnvAmt = kFEnvAmtMidi

kFCutoffMidi chnget "filter_cutoff"
kFCutoff pow 16, kFCutoffMidi

kFTypeMidi chnget "filter_type"
kFType round kFTypeMidi

kFKeyTrackMidi chnget "filter_kbd_track"
kFKeyTrack = kFKeyTrackMidi 

iPortamentoTimeMidi chnget "portamento_time"
kPortamentoTime = iPortamentoTimeMidi

iPortamentoModeMidi chnget "portamento_mode"
kPortamentoMode round iPortamentoModeMidi

kPrevInstrcount = gkInstrCount
gkInstrCount active 1, 0, 1

if iPreviousFreq >= 0 then
    giPrevInstrFreq = iPreviousFreq
endif

if kKeyboardMode == 0 then
    if gkInstrCount <= 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq portk iFreq, 0.2 * kPortamentoTime, giPrevInstrFreq
else
    if gkInstrCount <= 1 && gknoteon == 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq = cpsoct((gknum / 12) + 3)
    kFreq portk kFreq, 0.2 * kPortamentoTime, giPrevInstrFreq
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

gaSendL = gaSendL + aVco * kMasterVol * 0.5
gaSendR = gaSendR + aVco * kMasterVol * 0.5

giPrevInstrFreq = iFreq

endin


instr 99

;Reverb
kReverbAmountMidi chnget "reverb_wet"
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_roomsize"
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget "reverb_width"
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget "reverb_damp"
kReverbDamp  = kReverbDampMidi

;distortion
kDistMidi chnget "distortion_crunch"
kDist = kDistMidi 

kCrunch = 1 - kDist
if kCrunch == 0 then
	kCrunch = 0.01
endif

aDistortL powershape gaSendL, kCrunch
aDistortR powershape gaSendR, kCrunch

aReverbL, aReverbR freeverb aDistortL, aDistortR, kReverbSize, kReverbDamp

kWet1 = kReverbAmount * ( kReverbWidth / 2 + 0.5 )
kWet2 = kReverbAmount * ( ( 1 - kReverbWidth ) / 2 )
kDry = 1 - kReverbAmount

aLeft = aReverbL * kWet1 + aReverbR * kWet2 + aDistortL * kDry
aRight = aReverbR * kWet1 + aReverbL * kWet2 + aDistortR * kDry

aClipL clip aLeft, 0, 0.9
aClipR clip aRight, 0, 0.9

outs aClipL, aClipR
clear gaSendL, gaSendR

endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1
f0 3600
i 11 0 3600 0 0
i 99 0 -1
</CsScore>
</CsoundSynthesizer>
