<CoundSynthesizer>
<CsOptions>
-odac -Ma --midi-key=4 --midi-velocity=5
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1

gaSendL init 0
gaSendR init 0

massign 0, 0
massign 1, 1
massign 3, 3

giSquarePulse[] init 128
giTriangleSaw[] init 128

iTableSize = 16384

iIndex = 0
while iIndex <= 127 do
    iScale min iIndex / 127, 0.9
    iSize = (1 - iScale) / 2
    iWidth round iSize * iTableSize
    iTableNumber ftgen 0, 0, iTableSize, 7, 1, iTableSize - iWidth, 1, 0, -1, iWidth, -1
    giSquarePulse[iIndex] = iTableNumber
    iIndex = iIndex + 1
od

iIndex = 0
while iIndex <= 127 do
    iScale = iIndex / 127
    iSize = (1 - iScale) / 2
    iWidth round iSize * iTableSize
    if iWidth % 2 == 1 then
        iWidth = iWidth - 1
    endif
    iTableNumber ftgen 0, 0, iTableSize, 7, 0, (iTableSize - iWidth) / 2, 1, iWidth, -1, (iTableSize - iWidth) / 2, 0
    giTriangleSaw[iIndex] = iTableNumber
    iIndex = iIndex + 1
od


opcode chnget, k, Si
Sname, iInstr xin

SInternalName sprintf "_%d_%s", iInstr, Sname
kValue chnget SInternalName

xout kValue
endop


opcode chnget, i, Si
Sname, iInstr xin

SInternalName sprintf "_%d_%s", iInstr, Sname
iValue chnget SInternalName

xout iValue
endop


opcode chnset, 0, kSi
kValue, Sname, iInstr xin

SInternalName sprintf "_%d_%s", iInstr, Sname
chnset kValue, SInternalName
endop


opcode GetMax, k, k[]k
kkeys[], kresult xin

kmax = 0
kindex = 0
until kindex == 128 do
    if kkeys[kindex] > kkeys[kmax] then
        kmax = kindex
    endif
    kindex = kindex + 1
od
if kkeys[kmax] > 0 then
    kresult = kmax
endif

xout kresult
endop


opcode GetMin, k, k[]k
kkeys[], kresult xin

kmin = 0
kindex = 0
until kindex == 128 do
    if kkeys[kindex] != 0 && kkeys[kmin] != 0 && kkeys[kindex] < kkeys[kmin] then
        kmin = kindex
    elseif kkeys[kmin] == 0 && kkeys[kindex] != 0 then
        kmin = kindex
    endif
    kindex = kindex + 1
od
if kkeys[kmin] > 0 then
    kresult = kmin
endif

xout kresult
endop


opcode MonoSynth, 0, i
iInstr xin

kLargest chnget "largest", iInstr
knotes chnget "number_of_notes", iInstr
kPrevNoteFreq chnget "prev_note_freq", iInstr

kKeyboardModeMidi chnget "keyboard_mode", iInstr
kKeyboardMode round kKeyboardModeMidi

kkeys[]  init   128
kcounter init   1
kstatus, kchan, kb1, kb2    midiin
kFreq mtof kb1
kAmp = kb2 / 127

if kstatus == 144 && kb2 != 0 then
    if knotes == 0 then
        if kKeyboardMode != 0 then
            turnoff2 iInstr, 0, 1
            schedkwhen  1, 0, 0, iInstr, 0, -1, kb1, kb2, kPrevNoteFreq, 1
        endif
        kcounter = 1
    else
        if kKeyboardMode == 1 then
            kPrevNoteFreq mtof kLargest
            turnoff2 iInstr, 0, 1
            schedkwhen  1, 0, 0, iInstr, 0, -1, kb1, kb2, kPrevNoteFreq
        endif
        kcounter = kcounter + 1
    endif
    kLargest   =   kb1
    knotes = knotes + 1
    gknoteon = 1
    kkeys[kLargest] = kcounter
    kPrevNoteFreq = kFreq

elseif kstatus == 144 && kb2 == 0 || kstatus == 128 then
    kPrevNoteFreq mtof kLargest
    kkeys[kb1] = 0

    if knotes == 1 then
        kLargest = kb1
        if kKeyboardMode != 0 then
            schedkwhen  1, 0, 0, -iInstr, 0, 0, kb1, kb2, kPrevNoteFreq
        endif
        kcounter = 0
    else
        kLargest GetMax kkeys, kLargest
        if kKeyboardMode == 1 then
            schedkwhen  1, 0, 0, -iInstr, 0, 0, kb1, kb2, kPrevNoteFreq
            schedkwhen  1, 0, 0, iInstr, 0, -1, kb1, kb2, kPrevNoteFreq
        endif
    endif

    if knotes > 0 then
        knotes = knotes - 1
        gknoteon = 0
    endif
    if knotes == 0 then
        turnoff2 iInstr, 2, 1
    endif
endif

chnset knotes, "number_of_notes", iInstr
chnset kPrevNoteFreq, "prev_note_freq", iInstr
chnset kLargest, "largest", iInstr

endop


opcode SimpleSynth, 0, iiiiiii
p1, p2, p3, p4, p5, p6, p7 xin

iInstr = p1

kLargest chnget "largest", iInstr
iPrevInstrFreq chnget "prev_instr_freq", iInstr
knotes chnget "number_of_notes", iInstr

mididefault iPrevInstrFreq, p6
mididefault 0, p7

iInstrCount active iInstr, 0, 1

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99

ib1 = p4
ib2 = p5
iFreq mtof ib1
iAmp = ib2 / 127
iPreviousFreq = p6
iUserForMono = p7
iVelocity veloc 0, 1

i16 = 1 / 16

kKeyboardModeMidi chnget "keyboard_mode", iInstr
kKeyboardMode round kKeyboardModeMidi

kMasterVolMidi chnget "master_vol", iInstr
kMasterVol = kMasterVolMidi

;OCS 1
iAttMidi chnget "amp_attack", iInstr
iAtt pow iAttMidi, 3
iAtt = iAtt + 0.0005

;declick
if iAtt < 0.01 then
    iAtt = 0.01
endif

iDecMidi chnget "amp_decay", iInstr
iDec pow iDecMidi, 3
iDec = iDec + 0.0005

iSusMidi chnget "amp_sustain", iInstr
iSus = iSusMidi

iRelMidi chnget "amp_release", iInstr
iRel pow iRelMidi, 3
iRel = iRel + 0.0005

;declick
if iRel < 0.05 then
    iRel = 0.05
endif

iOsc1TypeMidi chnget "osc1_waveform", iInstr
iOsc1Type round iOsc1TypeMidi

kOsc1ShapeMidi chnget "osc1_pulsewidth", iInstr
kOsc1Shape scale kOsc1ShapeMidi, 126, 0
kOsc1Shape round kOsc1Shape 

;OSC 2
iOsc2TypeMidi chnget "osc2_waveform", iInstr
iOsc2Type round iOsc2TypeMidi

kOsc2ShapeMidi chnget "osc2_pulsewidth", iInstr
kOsc2Shape scale kOsc2ShapeMidi, 126, 0
kOsc2Shape round kOsc2Shape

kOsc2OctaveMidi chnget "osc2_range", iInstr
kOsc2Octave round kOsc2OctaveMidi
kOsc2Octave octave kOsc2Octave

kOsc2SemitoneMidi chnget "osc2_pitch", iInstr
kOsc2Semitone round kOsc2SemitoneMidi
kOsc2Semitone semitone kOsc2Semitone

kOsc2DetuneMidi chnget "osc2_detune", iInstr
kOsc2Detune pow 1.25, kOsc2DetuneMidi

kOsc2SyncMidi chnget "osc2_sync", iInstr
kOsc2Sync round kOsc2SyncMidi 

;LFO
iLfoTypeMidi chnget "lfo_waveform", iInstr
kLfoType round iLfoTypeMidi 

kLfoFreqMidi chnget "lfo_freq", iInstr
kLfoFreq pow kLfoFreqMidi, 2

kLfoToOscMidi chnget "freq_mod_osc", iInstr
kLfoToOsc round kLfoToOscMidi 

kLfoFreqAmountMidi chnget "freq_mod_amount", iInstr
kLfoFreqAmount pow kLfoFreqAmountMidi, 3
kLfoFreqAmount = kLfoFreqAmount - 1
kLfoFreqAmount = kLfoFreqAmount / 2 + 0.5

kLfoFilterAmountMidi chnget "filter_mod_amount", iInstr
kLfoFilterAmount = kLfoFilterAmountMidi 
kLfoFilterAmount = kLfoFilterAmount / 2 + 0.5

kLfoAmpMidi chnget "amp_mod_amount", iInstr
kLfoAmp = kLfoAmpMidi
kLfoAmp = ( kLfoAmp + 1 ) / 2

;Mix
kOscMixMidi chnget "osc_mix", iInstr
kOscMix = kOscMixMidi

kOscRingModMidi chnget "osc_mix_mode", iInstr
kOscRingMod = kOscRingModMidi

kOsc1Vol = (1 - kOscMix) / 2
kOsc1Vol = kOsc1Vol * (1 - kOscRingMod)

kOsc2Vol = (1 + kOscMix) / 2
kOsc2Vol = kOsc2Vol * (1 - kOscRingMod)

;Reverb
kReverbAmountMidi chnget "reverb_wet", iInstr
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_roomsize", iInstr
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget "reverb_width", iInstr
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget "reverb_damp", iInstr
kReverbDamp  = kReverbDampMidi

;Filter
iFAttMidi chnget "filter_attack", iInstr
iFAtt pow iFAttMidi, 3
iFAtt = iFAtt + 0.0005

iFDecMidi chnget "filter_decay", iInstr
iFDec pow iFDecMidi, 3
iFDec = iFDec + 0.0005

iFSusMidi chnget "filter_sustain", iInstr
iFSus = iFSusMidi

iFRelMidi chnget "filter_release", iInstr
iFRel pow iFRelMidi, 3
iFRel = iFRel + 0.0005

; TODO (nonameentername) reson doesn't match
kFResMidi chnget "filter_resonance", iInstr
kFRes scale kFResMidi, 20.0, 1.0

kFEnvAmtMidi chnget "filter_env_amount", iInstr
kFEnvAmt = kFEnvAmtMidi

kFCutoffMidi chnget "filter_cutoff", iInstr
kFCutoff pow 16, kFCutoffMidi

kFTypeMidi chnget "filter_type", iInstr
kFType round kFTypeMidi

kFKeyTrackMidi chnget "filter_kbd_track", iInstr
kFKeyTrack = kFKeyTrackMidi 

iPortamentoTimeMidi chnget "portamento_time", iInstr
kPortamentoTime = iPortamentoTimeMidi

iPortamentoModeMidi chnget "portamento_mode", iInstr
kPortamentoMode round iPortamentoModeMidi

kInstrCount active iInstr, 0, 1

if iPreviousFreq >= 0 then
    iPrevInstrFreq = iPreviousFreq
endif

if kKeyboardMode == 0 then
    if kInstrCount <= 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq portk iFreq, 0.2 * kPortamentoTime, iPrevInstrFreq
else
    if knotes <= 1 && gknoteon == 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq = cpsoct((kLargest / 12) + 3)
    kFreq portk kFreq, 0.2 * kPortamentoTime, iPrevInstrFreq
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
    aLfoOsc noise 1, 0.0
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

kOsc1Freq = kFreq

if kLfoToOsc == 0 || kLfoToOsc == 1 then
    kOsc1Lfo = kFreq * ( kLfoFreqAmount * ( aLfoOsc + 1 ) + 1 - kLfoFreqAmount )
    kOsc1Freq min kOsc1Lfo, sr / 2
endif

kOsc2Freq = kFreq * kOsc2Octave * kOsc2Semitone * kOsc2Detune

if kLfoToOsc == 0 || kLfoToOsc == 2 then
    kOsc2Lfo = kOsc2Freq * ( kLfoFreqAmount * ( aLfoOsc + 1 ) + 1 - kLfoFreqAmount )
    kOsc2Freq min kOsc2Lfo, sr / 2
endif

async init 0
kPhase = 0
aOsc1Sync phasor kOsc1Freq

if iOsc1Type == 0 then
    ;sine wave
    aOsc1 oscilikts iAmp, kOsc1Freq, 1, async, kPhase
elseif iOsc1Type == 1 then
    ;square / pulse
    aOsc1 oscilikts iAmp, kOsc1Freq, giSquarePulse[kOsc1Shape], async, kPhase
elseif iOsc1Type == 2 then
    ;triangle / saw
    aOsc1 oscilikts iAmp, kOsc1Freq, giTriangleSaw[kOsc1Shape], async, kPhase
elseif iOsc1Type == 3 then
    ;white noise
    aOsc1 noise iAmp, 0.0
else
    ;noise + sample & hold
    aOsc1 randh iAmp, kOsc1Freq
endif


if kOsc2Sync == 1 then
    async diff 1 - aOsc1Sync
endif

if iOsc2Type == 0 then
    ;sine wave
    aOsc2 oscilikts iAmp, kOsc2Freq, 1, async, kPhase
elseif iOsc2Type == 1 then
    ;square / pulse
    aOsc2 oscilikts iAmp, kOsc2Freq, giSquarePulse[kOsc2Shape], async, kPhase
elseif iOsc2Type == 2 then
    ;triangle / saw
    aOsc2 oscilikts iAmp, kOsc2Freq, giTriangleSaw[kOsc2Shape], async, kPhase
elseif iOsc2Type == 3 then
    ;white noise
    aOsc2 noise iAmp, 0.0
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
    aVco rbjeq aVco * kEnv, 1 - kFCutoff, 1, kFRes, 1, 2
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

aClipL clip aVco, 0, 0.9, 0.4
aClipR clip aVco, 0, 0.9, 0.4

if kKeyboardMode == 0 then
    kInstrCount active iInstr, 0, 0
    kInstrCountScale port kInstrCount^0.5, 0.01
else
    kInstrCountScale = 1
endif

if kKeyboardMode == 0 || kKeyboardMode == 1 || iUserForMono == 1 then
    if kInstrCountScale != 0 then
        gaSendL sum gaSendL, (aClipL * kMasterVol * 0.7) / kInstrCountScale
        gaSendR sum gaSendR, (aClipR * kMasterVol * 0.7) / kInstrCountScale
    endif
endif

iPrevInstrFreq = iFreq
chnset iPrevInstrFreq, "prev_instr_freq", iInstr

endop


instr 11
    MonoSynth 1
endin

instr 1
    SimpleSynth p1, p2, p3, p4, p5, p6, p7
endin

instr 31
    MonoSynth 3
endin

instr 3
    SimpleSynth p1, p2, p3, p4, p5, p6, p7
endin



instr 99

iInstr = 1

;Reverb
kReverbAmountMidi chnget "reverb_wet", iInstr
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_roomsize", iInstr
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget "reverb_width", iInstr
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget "reverb_damp", iInstr
kReverbDamp  = kReverbDampMidi

;distortion
kDistMidi chnget "distortion_crunch", iInstr
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

outs aLeft, aRight
clear gaSendL, gaSendR

endin

</CsInstruments>
<CsScore>
f 1 0 16384 10 1 ;sine
f 0 3600
i 11 0 -1
i 31 0 -1
i 99 0 -1
</CsScore>
</CsoundSynthesizer>
