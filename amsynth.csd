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


opcode chnget, k, Sip
SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
kValue chnget SInternalName

xout kValue
endop


opcode chnget, i, Sip
SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
iValue chnget SInternalName

xout iValue
endop


opcode chnset, 0, kSip
kValue, SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
chnset kValue, SInternalName
endop


opcode GetMax, k, k[]k
kKeys[], kValue xin

kMax = 0
kIndex = 0
until kIndex == 128 do
    if kKeys[kIndex] > kKeys[kMax] then
        kMax = kIndex
    endif
    kIndex = kIndex + 1
od
if kKeys[kMax] > 0 then
    kValue = kMax
endif

xout kValue
endop


opcode GetMin, k, k[]k
kKeys[], kValue xin

kmin = 0
kIndex = 0
until kIndex == 128 do
    if kKeys[kIndex] != 0 && kKeys[kmin] != 0 && kKeys[kIndex] < kKeys[kmin] then
        kmin = kIndex
    elseif kKeys[kmin] == 0 && kKeys[kIndex] != 0 then
        kmin = kIndex
    endif
    kIndex = kIndex + 1
od
if kKeys[kmin] > 0 then
    kValue = kmin
endif

xout kValue
endop


opcode MonoSynth, 0, i
iInstr xin

kLargest chnget "largest", iInstr
kNotes chnget "number_of_notes", iInstr
kPrevNoteFreq chnget "prev_note_freq", iInstr
kNoteOn chnget "note_on", iInstr

kKeyboardModeMidi chnget "keyboard_mode", iInstr
kKeyboardMode round kKeyboardModeMidi

kKeys[]  init   128
kCounter init   1
kStatus, kChannel, kb1, kb2    midiin
kFreq mtof kb1
kAmp = kb2 / 127

if kStatus == 144 && kb2 != 0 then
    if kNotes == 0 then
        if kKeyboardMode != 0 then
            turnoff2 iInstr, 0, 1
            schedkwhen  1, 0, 0, iInstr, 0, -1, kb1, kb2, kPrevNoteFreq, 1
        endif
        kCounter = 1
    else
        if kKeyboardMode == 1 then
            kPrevNoteFreq mtof kLargest
            turnoff2 iInstr, 0, 1
            schedkwhen  1, 0, 0, iInstr, 0, -1, kb1, kb2, kPrevNoteFreq
        endif
        kCounter = kCounter + 1
    endif
    kLargest   =   kb1
    kNotes = kNotes + 1
    kNoteOn = 1
    kKeys[kLargest] = kCounter
    kPrevNoteFreq = kFreq

elseif kStatus == 144 && kb2 == 0 || kStatus == 128 then
    kPrevNoteFreq mtof kLargest
    kKeys[kb1] = 0

    if kNotes == 1 then
        kLargest = kb1
        if kKeyboardMode != 0 then
            schedkwhen  1, 0, 0, -iInstr, 0, 0, kb1, kb2, kPrevNoteFreq
        endif
        kCounter = 0
    else
        kLargest GetMax kKeys, kLargest
        if kKeyboardMode == 1 then
            schedkwhen  1, 0, 0, -iInstr, 0, 0, kb1, kb2, kPrevNoteFreq
            schedkwhen  1, 0, 0, iInstr, 0, -1, kb1, kb2, kPrevNoteFreq
        endif
    endif

    if kNotes > 0 then
        kNotes = kNotes - 1
        kNoteOn = 0
    endif
    if kNotes == 0 then
        turnoff2 iInstr, 2, 1
    endif
endif

chnset kNotes, "number_of_notes", iInstr
chnset kPrevNoteFreq, "prev_note_freq", iInstr
chnset kLargest, "largest", iInstr
chnset kNoteOn, "note_on", iInstr

endop


opcode ASynthOsc, aa, iiika
iInstr, iNum, iAmp, kFreq, aSyncIn xin

kTypeMidi chnget "osc_waveform", iInstr, iNum
kType round kTypeMidi

kShapeMidi chnget "osc_pulsewidth", iInstr, iNum
kShape scale kShapeMidi, 126, 0
kShape round kShape

kSyncMidi chnget "osc_sync", iInstr, iNum
kSync round kSyncMidi 

if kSync == 1 then
    aSync diff 1 - aSyncIn
endif

kPhase = 0
aPhasor phasor kFreq

if kType == 0 then
    ;sine wave
    aOut oscilikts iAmp, kFreq, 1, aSync, kPhase
elseif kType == 1 then
    ;square / pulse
    aOut oscilikts iAmp, kFreq, giSquarePulse[kShape], aSync, kPhase
elseif kType == 2 then
    ;triangle / saw
    aOut oscilikts iAmp, kFreq, giTriangleSaw[kShape], aSync, kPhase
elseif kType == 3 then
    ;white noise
    aOut noise iAmp, 0.0
else
    ;noise + sample & hold
    aOut randh iAmp, kFreq
endif

xout aOut, aPhasor
endop


opcode ASynthDetune, k, iik
iInstr, iNum, kFreq xin

kOctaveMidi chnget "osc_range", iInstr, iNum
kOctave round kOctaveMidi
kOctave octave kOctave

kSemitoneMidi chnget "osc_pitch", iInstr, iNum
kSemitone round kSemitoneMidi
kSemitone semitone kSemitone

kDetuneMidi chnget "osc_detune", iInstr, iNum
kDetune pow 1.25, kDetuneMidi

kValue = kFreq * kOctave * kSemitone * kDetune

xout kValue
endop


opcode ASynthLfo, a, iik
iInstr, iNum, kFreq xin

kTypeMidi chnget "lfo_waveform", iInstr
kType round kTypeMidi 

kLfoFreqMidi chnget "lfo_freq", iInstr, iNum
kLfoFreq pow kLfoFreqMidi, 2

if kType == 0 then
    ;sine
    aOut lfo 1, kLfoFreq, 0
elseif kType == 1 then
    ;square
    aOut lfo 1, kLfoFreq, 2
elseif kType == 2 then
    ;triangle
    aOut lfo 1, kLfoFreq, 1
elseif kType == 3 then
    ;white noise
    aOut noise 1, 0.0
elseif kType == 4 then
    ;noise + sample & hold
    if kLfoFreq == 0 then
        kLfoFreq = kFreq
    endif
    aOut randh 1, kLfoFreq
elseif kType == 5 then
    ;sawtooth up
    aOut lfo 1, kLfoFreq, 4
else
    ;sawtooth down
    aOut lfo 1, kLfoFreq, 5
endif

xout aOut
endop


opcode ASynthFilter, a, iiaak
iInstr, iNum, aIn, aLfo, kFreq xin

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99
iVelocity veloc 0, 1
i16 = 1 / 16

;Filter
iAttackMidi chnget "filter_attack", iInstr
iAttack pow iAttackMidi, 3
iAttack = iAttack + 0.0005

iDecayMidi chnget "filter_decay", iInstr
iDecay pow iDecayMidi, 3
iDecay = iDecay + 0.0005

iSustainMidi chnget "filter_sustain", iInstr
iSustain = iSustainMidi

iReleaseMidi chnget "filter_release", iInstr
iRelease pow iReleaseMidi, 3
iRelease = iRelease + 0.0005

kResonanceMidi chnget "filter_resonance", iInstr
kResonance scale kResonanceMidi, 20.0, 1.0

kEnvAmountMidi chnget "filter_env_amount", iInstr
kEnvAmount = kEnvAmountMidi

kCutoffMidi chnget "filter_cutoff", iInstr
kCutoff pow 16, kCutoffMidi

kTypeMidi chnget "filter_type", iInstr
kType round kTypeMidi

kKeyTrackMidi chnget "filter_kbd_track", iInstr
kKeyTrack = kKeyTrackMidi 

kLfoFilterAmountMidi chnget "filter_mod_amount", iInstr
kLfoFilterAmount = kLfoFilterAmountMidi 
kLfoFilterAmount = kLfoFilterAmount / 2 + 0.5

kCutoffLfo = ( aLfo * 0.5 + 0.5 ) * kLfoFilterAmount + 1 - kLfoFilterAmount

kCutoffBase = iTrackBaseFreq * (1 - kKeyTrack) + kFreq * kKeyTrack

kCutoff = kCutoff * kCutoffBase * iVelocity * kCutoffLfo

kFilterEnv linsegr 0,iAttack,1,iDecay,iSustain,iRelease,0

if kEnvAmount > 0 then
    kCutoff = kCutoff + kFreq * kFilterEnv * kEnvAmount
else
    kCutoff = kCutoff + kCutoff * i16 * kEnvAmount * kFilterEnv
endif

kCutoff min kCutoff, iMiddle
kCutoff max kCutoff, 10

if kType == 0 then
    ;lowpass
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 0
elseif kType == 1 then
    ;highpass
    aOut rbjeq aIn, 1 - kCutoff, 1, kResonance, 1, 2
elseif kType == 2 then
    ;bandpass
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 4
elseif kType == 3 then
    ;band-reject
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 6
else
    ;peaking eq
    aOut rbjeq aIn, kCutoff, 1, kResonance, 1, 8
endif

xout aOut
endop


opcode ASynthMix, a, iiaa
iInstr, iNum, aOsc1, aOsc2 xin

kOscMixMidi chnget "osc_mix", iInstr, iNum
kOscMix = kOscMixMidi

kOscRingModMidi chnget "osc_mix_mode", iInstr, iNum
kOscRingMod = kOscRingModMidi

kOsc1Vol = (1 - kOscMix) / 2
kOsc1Vol = kOsc1Vol * (1 - kOscRingMod)

kOsc2Vol = (1 + kOscMix) / 2
kOsc2Vol = kOsc2Vol * (1 - kOscRingMod)

aOut = aOsc1 * kOsc1Vol + aOsc2 * kOsc2Vol + kOscRingMod * aOsc1 * aOsc2

xout aOut
endop


opcode ASynthAmp, a, iiaa
iInstr, iNum, aIn, aLfo xin

iAttackMidi chnget "amp_attack", iInstr
iAttack pow iAttackMidi, 3
iAttack = iAttack + 0.0005

;declick
if iAttack < 0.01 then
    iAttack = 0.01
endif

iDecayMidi chnget "amp_decay", iInstr
iDecay pow iDecayMidi, 3
iDecay = iDecay + 0.0005

iSustainMidi chnget "amp_sustain", iInstr
iSustain = iSustainMidi

iReleaseMidi chnget "amp_release", iInstr
iRelease pow iReleaseMidi, 3
iRelease = iRelease + 0.0005

;declick
if iRelease < 0.05 then
    iRelease = 0.05
endif

kLfoAmpMidi chnget "amp_mod_amount", iInstr
kLfoAmp = kLfoAmpMidi
kLfoAmp = ( kLfoAmp + 1 ) / 2

kEnvLfo = ( ( aLfo * 0.5 + 0.5 ) * kLfoAmp + 1 - kLfoAmp )

kEnv linsegr 0,iAttack,1,iDecay,iSustain,iRelease,0
kEnv = kEnv * kEnvLfo
aOut = aIn * kEnv

xout aOut
endop


opcode ASynth, 0, iiiiiii
p1, p2, p3, p4, p5, p6, p7 xin

iInstr = p1

kLargest chnget "largest", iInstr
iPrevInstrFreq chnget "prev_instr_freq", iInstr
kNotes chnget "number_of_notes", iInstr
kNoteOn chnget "note_on", iInstr

mididefault iPrevInstrFreq, p6
mididefault 0, p7

ib1 = p4
ib2 = p5
iFreq mtof ib1
iAmp = ib2 / 127
iPreviousFreq = p6
iUserForMono = p7

kKeyboardModeMidi chnget "keyboard_mode", iInstr
kKeyboardMode round kKeyboardModeMidi

kMasterVolMidi chnget "master_vol", iInstr
kMasterVol = kMasterVolMidi

kLfoToOscMidi chnget "freq_mod_osc", iInstr
kLfoToOsc round kLfoToOscMidi 

kLfoFreqAmountMidi chnget "freq_mod_amount", iInstr
kLfoFreqAmount pow kLfoFreqAmountMidi, 3
kLfoFreqAmount = kLfoFreqAmount - 1
kLfoFreqAmount = kLfoFreqAmount / 2 + 0.5

kInstrCount active iInstr, 0, 1

if iPreviousFreq >= 0 then
    iPrevInstrFreq = iPreviousFreq
endif

iPortamentoTimeMidi chnget "portamento_time", iInstr
kPortamentoTime = iPortamentoTimeMidi

iPortamentoModeMidi chnget "portamento_mode", iInstr
kPortamentoMode round iPortamentoModeMidi

if kKeyboardMode == 0 then
    if kInstrCount <= 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq portk iFreq, 0.2 * kPortamentoTime, iPrevInstrFreq
else
    if kNotes <= 1 && kNoteOn == 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq = cpsoct((kLargest / 12) + 3)
    kFreq portk kFreq, 0.2 * kPortamentoTime, iPrevInstrFreq
endif

aLfoOsc ASynthLfo iInstr, 1, kFreq

kOsc1Freq = kFreq

if kLfoToOsc == 0 || kLfoToOsc == 1 then
    kOsc1Lfo = kFreq * ( kLfoFreqAmount * ( aLfoOsc + 1 ) + 1 - kLfoFreqAmount )
    kOsc1Freq min kOsc1Lfo, sr / 2
endif

kOsc2Freq ASynthDetune iInstr, 2, kFreq

if kLfoToOsc == 0 || kLfoToOsc == 2 then
    kOsc2Lfo = kOsc2Freq * ( kLfoFreqAmount * ( aLfoOsc + 1 ) + 1 - kLfoFreqAmount )
    kOsc2Freq min kOsc2Lfo, sr / 2
endif

aNone init 0

aOsc1, aOsc1Sync ASynthOsc iInstr, 1, iAmp, kOsc1Freq, aNone

aOsc2, aOsc2Sync ASynthOsc iInstr, 2, iAmp, kOsc2Freq, aOsc1Sync

aVco ASynthMix iInstr, 1, aOsc1, aOsc2

aVco ASynthAmp iInstr, 1, aVco, aLfoOsc

aVco ASynthFilter iInstr, 1, aVco, aLfoOsc, kFreq

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
    ASynth p1, p2, p3, p4, p5, p6, p7
endin

instr 31
    MonoSynth 3
endin

instr 3
    ASynth p1, p2, p3, p4, p5, p6, p7
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
