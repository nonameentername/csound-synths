<Cabbage>
form caption("AMSynth") size(885,495), pluginid("amsynth") style("legacy")

; main container
#define	SLIDER_STYLE trackercolour(150,150,255)
#define	CHECKBOX_STYLE colour(255,255,100)

image bounds(0, 0, 885, 495), colour(0, 0, 0, 0), outlinethickness(3) corners(5)

; OSCILLATOR 1
image      bounds(4, 4, 140, 130), plant("Oscillator1"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 130, 12), text(". OSCILLATOR 1 ."), fontcolour(255, 255, 100, 255)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Waveform"), channel("_1_1_osc_waveform"),  range(0, 4, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Shape"), channel("_1_1_osc_pulsewidth"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; OSCILLATOR MIX
image      bounds(146, 4, 140, 130), plant("OscillatorMix"), colour(0,0,0,0), outlinecolour("white"), outlinethickness(1), shape("sharp") {
label      bounds(5, 2, 130, 12), text(". OSCILLATOR MIX ."), fontcolour(255,255,100)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("OSC1 - OSC2"), channel("_1_1_osc_mix"),  range(-1, 1, 0, 1), $SLIDER_STYLE
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Ring Mod"), channel("_1_1_osc_mix_mode"),  range(0, 1, 0, 1), $SLIDER_STYLE
}

; OSCILLATOR 2
image      bounds(288, 4, 327, 130), plant("Oscillator2"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 317, 12), text(". OSCILLATOR 2 ."), fontcolour(255, 255, 100, 255)
checkbox   bounds(15, 25, 100, 10), text("Sync to OSC1"), channel("_1_2_osc_sync"), value(0), $CHECKBOX_STYLE
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Waveform"), channel("_1_2_osc_waveform"),  range(0, 4, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Shape"), channel("_1_2_osc_pulsewidth"),  range(0, 1, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(120, 40, 80, 80), valuetextbox(1), textbox(1), text("OCT"), channel("_1_2_osc_range"),  range(-3, 4, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(180, 40, 80, 80), valuetextbox(1), textbox(1), text("SEMITONE"), channel("_1_2_osc_pitch"),  range(-12, 12, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(240, 40, 80, 80), valuetextbox(1), textbox(1), text("DETUNE"), channel("_1_2_osc_detune"),  range(-1, 1, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; LFO
image      bounds(4, 136, 377, 130), plant("LFO"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 367, 12), text(". LFO ."), fontcolour(255, 255, 100, 255)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Waveform"), channel("_1_1_lfo_waveform"),  range(0, 6, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Speed"), channel("_1_1_lfo_freq"),  range(0, 7.5, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(120, 40, 80, 80), valuetextbox(1), textbox(1), text("Osc 1"), channel("_1_1_freq_mod_amount"),  range(0, 1.25992, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(180, 40, 80, 80), valuetextbox(1), textbox(1), text("Osc 2"), channel("_1_2_freq_mod_amount"),  range(0, 1.25992, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(240, 40, 80, 80), valuetextbox(1), textbox(1), text("Filter"), channel("_1_1_filter_mod_amount"),  range(-1, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(300, 40, 80, 80), valuetextbox(1), textbox(1), text("AMP"), channel("_1_1_amp_mod_amount"),  range(-1, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; AMP
image      bounds(618, 4, 262, 130), plant("AMPENVELOPE"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 252, 12), text(". AMP ENVELOPE ."), fontcolour(255, 255, 100, 255)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Attack"), channel("_1_1_amp_attack"),  range(0, 2.5, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Decay"), channel("_1_1_amp_decay"),  range(0, 2.5, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(120, 40, 80, 80), valuetextbox(1), textbox(1), text("Sustain"), channel("_1_1_amp_sustain"),  range(0, 1, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(180, 40, 80, 80), valuetextbox(1), textbox(1), text("Release"), channel("_1_1_amp_release"),  range(0, 2.5, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; FILTER
image      bounds(384, 136, 496, 130), plant("FILTER"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 486, 12), text(". FILTER ."), fontcolour(255, 255, 100, 255)
combobox   bounds(15, 15, 100, 20), channel("_1_1_filter_type"), items("Lowpass", "highpass", "bandpass", "band-reject", "peaking-eq"), fontcolour(255, 255, 100, 255)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Reson"), channel("_1_1_filter_resonance"),  range(0, 0.97, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Cutoff"), channel("_1_1_filter_cutoff"),  range(-0.5, 1.5, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(120, 40, 80, 80), valuetextbox(1), textbox(1), text("Key Track"), channel("_1_1_filter_kbd_track"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(180, 40, 80, 80), valuetextbox(1), textbox(1), text("Env AMT"), channel("_1_1_filter_env_amount"),  range(-16, 16, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(240, 40, 80, 80), valuetextbox(1), textbox(1), text("Attack"), channel("_1_1_filter_attack"),  range(0, 2.5, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(300, 40, 80, 80), valuetextbox(1), textbox(1), text("Decay"), channel("_1_1_filter_decay"),  range(0, 2.5, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(360, 40, 80, 80), valuetextbox(1), textbox(1), text("Sustain"), channel("_1_1_filter_sustain"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(420, 40, 80, 80), valuetextbox(1), textbox(1), text("Release"), channel("_1_1_filter_release"),  range(0, 2.5, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; Reverb
image      bounds(288, 268, 282, 130), plant("Reverb"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 272, 12), text(". REVERB ."), fontcolour(255, 255, 100, 255)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Amount"), channel("_1_1_reverb_wet"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Size"), channel("_1_1_reverb_roomsize"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(140, 40, 80, 80), valuetextbox(1), textbox(1), text("Stereo"), channel("_1_1_reverb_width"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(200, 40, 80, 80), valuetextbox(1), textbox(1), text("Damping"), channel("_1_1_reverb_damp"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; Portamento
image      bounds(4, 268, 282, 130), plant("Portamento"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 272, 12), text(". PORTAMENTO ."), fontcolour(255, 255, 100, 255)
rslider    bounds(20, 40, 80, 80), valuetextbox(1), textbox(1), text("Amount"), channel("_1_1_portamento_time"),  range(0, 1, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(100, 40, 80, 80), valuetextbox(1), textbox(1), text("Always/Legato"), channel("_1_1_portamento_mode"),  range(0, 1, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(180, 40, 80, 80), valuetextbox(1), textbox(1), text("Poly/Mono/Legato"), channel("_1_1_keyboard_mode"),  range(0, 2, 0, 1, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; OSCILLATOR 1
image      bounds(572, 268, 140, 130), plant("Amp"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 130, 12), text(". AMP ."), fontcolour(255, 255, 100, 255)
rslider    bounds(0, 40, 80, 80), valuetextbox(1), textbox(1), text("Volume"), channel("_1_1_master_vol"),  range(0, 1, 0, 1), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
rslider    bounds(60, 40, 80, 80), valuetextbox(1), textbox(1), text("Drive"), channel("_1_1_distortion_crunch"),  range(0, 0.9, 0, 1, 0.001), $SLIDER_STYLE trackercolour(150, 150, 255, 255)
}

; PRESETS
image      bounds(714, 268, 165, 130), plant("Presets"), colour(0, 0, 0, 0), , outlinethickness(1),  {
label      bounds(5, 2, 155, 12), text(". PRESETS ."), fontcolour(255, 255, 100, 255)
combobox   bounds(22, 44, 100, 25), channeltype("string"), populate("*.snaps") value("1")
filebutton bounds(62, 78, 60, 25), text("Save", "Save"), mode("snapshot")
}

keyboard   bounds(4, 402, 885, 89)
</Cabbage>

<CsoundSynthesizer>

<CsOptions>
-dm0 -n -+rtmidi=null -M0
;-odac -Ma --midi-key=4 --midi-velocity=5
</CsOptions>

<CsInstruments>

sr = 48000
ksmps = 256
nchnls = 2
0dbfs = 1

massign 0, 0

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


                opcode ReadMidiCC, 0, Siiiii
Sname, imin, imax, ichannel, iindex, ivalue xin
iValue          = (ivalue - imin) / (imax - imin)
iValue          max iValue, 0.0
iValue          min iValue, 1.0
                initc7 ichannel, iindex, iValue
                chnset ivalue, Sname
kMidiValue      ctrl7 ichannel, iindex, imin, imax
                chnset kMidiValue, Sname
                endop


opcode chnget, a, Sii
SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
aValue chnget SInternalName

xout aValue
endop


opcode chnget, k, Sii
SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
kValue chnget SInternalName

xout kValue
endop


opcode chnget, i, Sii
SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
iValue chnget SInternalName

xout iValue
endop


opcode chnset, 0, aSii
aValue, SName, iInstr, iIndex xin

SInternalName sprintf "_%d_%d_%s", iInstr, iIndex, SName
chnset aValue, SInternalName
endop


opcode chnset, 0, kSii
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


opcode FSynthOsc, aa, iiika
iInstr, iNum, iAmp, iFreq, aSyncIn xin

iShapeMidi chnget "osc_pulsewidth", iInstr, iNum
iShape = iShapeMidi * 127
iShape round iShape

kSyncMidi chnget "osc_sync", iInstr, iNum
kSync round kSyncMidi 

if kSync == 1 then
    aSync diff 1 - aSyncIn
    aPhasor phasor iFreq
else
    aSync init 0
    aPhasor init 0
endif

iNote = 69+12*log2(iFreq/440)
kAmp = 1/15000
aOut sfplaym iAmp, iNote, kAmp*iAmp, iFreq, iShape, 1

xout aOut, aPhasor
endop


opcode AMonoSynth, 0, ii
iInstr, iChannel xin

iNum = 1
iNumVoices = 16
iMaxVoice = 1000

kStatus, kChannel, kb1, kb2    midiin

if kChannel == iChannel then

kSmallest chnget "smallest", iInstr, iNum
kLargest chnget "largest", iInstr, iNum
kNotes chnget "number_of_notes", iInstr, iNum
kPrevNoteFreq chnget "prev_note_freq", iInstr, iNum
kNoteOn chnget "note_on", iInstr, iNum

kKeyboardModeMidi chnget "keyboard_mode", iInstr, iNum
kKeyboardMode round kKeyboardModeMidi

kKeys[]  init   128
kCurrentVoice init 0
kActiveVoices[] init iNumVoices
kActiveNote[] init 128
kCounter init   1
kFreq mtof kb1
kAmp = kb2 / 127

if kKeyboardMode == 0 then
    kInstrCount active iInstr, 0, 0
    kInstrnum = iInstr + kCurrentVoice / (iMaxVoice * 10)
    kCurrentVoiceIndex = kCurrentVoice % iNumVoices
    if kStatus == 144 && kb2 != 0 then
        if kInstrCount > iNumVoices - 1 then
            if kActiveVoices[kCurrentVoiceIndex] != 0 then
                kOldestInstrnum = kActiveVoices[kCurrentVoiceIndex]
                kInstrnum = kOldestInstrnum
            endif
        endif

        kActiveVoices[kCurrentVoiceIndex] = kInstrnum
        kCurrentVoice = kCurrentVoice + 1
        iMaxVoiceNumber = iMaxVoice - (iMaxVoice % iNumVoices)
        if kCurrentVoice == iMaxVoiceNumber then
            kCurrentVoice = 0
        endif

        if kInstrnum == kOldestInstrnum then
            turnoff2 kInstrnum, 4, 0
        endif
        event "i", kInstrnum, 0, -1, kb1, kb2, kPrevNoteFreq
        kActiveNote[kb1] = kInstrnum
    elseif kStatus == 144 && kb2 == 0 || kStatus == 128 then
        kInstrnum = kActiveNote[kb1]
        event "i", -kInstrnum, 0, 0, kb1, kb2, kPrevNoteFreq
    endif
endif

if kStatus == 144 && kb2 != 0 then
    kInstrCount active iInstr, 0, 0
    if kKeyboardMode != 0 then
        turnoff2 kInstrnum, 4, 0
    endif
    if kNotes == 0 then
        if kKeyboardMode != 0 then
            turnoff2 iInstr, 0, 0
            event "i", iInstr, 0, -1, kb1, kb2, kPrevNoteFreq, 1
        endif
        kCounter = 1
    else
        if kKeyboardMode == 1 then
            kPrevNoteFreq mtof kLargest
            event "i", iInstr, 0, -1, kb1, kb2, kPrevNoteFreq
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
            event "i", -iInstr, 0, 0, kb1, kb2, kPrevNoteFreq
        endif
        kCounter = 0
    else
        kLargest GetMax kKeys, kLargest
        if kKeyboardMode == 1 then
            event "i", iInstr, 0, -1, kb1, kb2, kPrevNoteFreq
        endif
    endif

    if kNotes > 0 then
        kNotes = kNotes - 1
        kNoteOn = 0
    endif
    if kKeyboardMode != 0 && kNotes == 0 then
        turnoff2 iInstr, 0, 1
    endif
endif

chnset kNotes, "number_of_notes", iInstr, iNum
chnset kPrevNoteFreq, "prev_note_freq", iInstr, iNum
chnset kLargest, "largest", iInstr, iNum
chnset kNoteOn, "note_on", iInstr, iNum

endif

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
    aPhasor phasor kFreq
else
    aSync init 0
    aPhasor init 0
endif

kPhase = 0

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

kTypeMidi chnget "lfo_waveform", iInstr, iNum
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


opcode ASynthFilter, a, iiaakk
iInstr, iNum, aIn, aLfo, kFreq, kVelocity xin

iTrackBaseFreq = 261.626
iMiddle = sr / 2 * 0.99
i16 = 1 / 16

;Filter
iAttackMidi chnget "filter_attack", iInstr, iNum
iAttack pow iAttackMidi, 3
iAttack = iAttack + 0.0005

iDecayMidi chnget "filter_decay", iInstr, iNum
iDecay pow iDecayMidi, 3
iDecay = iDecay + 0.0005

iSustainMidi chnget "filter_sustain", iInstr, iNum
iSustain = iSustainMidi

iReleaseMidi chnget "filter_release", iInstr, iNum
iRelease pow iReleaseMidi, 3
iRelease = iRelease + 0.0005

kResonanceMidi chnget "filter_resonance", iInstr, iNum
kResonance scale kResonanceMidi, 20.0, 1.0

kEnvAmountMidi chnget "filter_env_amount", iInstr, iNum
kEnvAmount = kEnvAmountMidi

kCutoffMidi chnget "filter_cutoff", iInstr, iNum
kCutoff pow 16, kCutoffMidi

kTypeMidi chnget "filter_type", iInstr, iNum
kType round kTypeMidi
kType = kType - 1

kKeyTrackMidi chnget "filter_kbd_track", iInstr, iNum
kKeyTrack = kKeyTrackMidi 

kLfoFilterAmountMidi chnget "filter_mod_amount", iInstr, iNum
kLfoFilterAmount = kLfoFilterAmountMidi 
kLfoFilterAmount = kLfoFilterAmount / 2 + 0.5

kCutoffLfo = ( aLfo * 0.5 + 0.5 ) * kLfoFilterAmount + 1 - kLfoFilterAmount

kCutoffBase = iTrackBaseFreq * (1 - kKeyTrack) + kFreq * kKeyTrack

kCutoff = kCutoff * kCutoffBase * kVelocity * kCutoffLfo

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
    kResonance scale kResonanceMidi, 25.0, 1.0
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

iAttackMidi chnget "amp_attack", iInstr, iNum
iAttack pow iAttackMidi, 3
iAttack = iAttack + 0.0005

;declick
if iAttack < 0.01 then
    iAttack = 0.01
endif

iDecayMidi chnget "amp_decay", iInstr, iNum
iDecay pow iDecayMidi, 3
iDecay = iDecay + 0.0005

iSustainMidi chnget "amp_sustain", iInstr, iNum
iSustain = iSustainMidi

iReleaseMidi chnget "amp_release", iInstr, iNum
iRelease pow iReleaseMidi, 3
iRelease = iRelease + 0.0005

;declick
if iRelease < 0.05 then
    iRelease = 0.05
endif

kLfoAmpMidi chnget "amp_mod_amount", iInstr, iNum
kLfoAmp = kLfoAmpMidi
kLfoAmp = ( kLfoAmp + 1 ) / 2

kEnvLfo = ( ( aLfo * 0.5 + 0.5 ) * kLfoAmp + 1 - kLfoAmp )

kEnv linsegr 0,iAttack,1,iDecay,iSustain,iRelease,0
kEnv = kEnv * kEnvLfo
aOut = aIn * kEnv

xout aOut
endop


opcode ASynthOverDrive, a, iia
iInstr, iNum, aIn xin

kDistMidi chnget "distortion_crunch", iInstr, iNum
kDist = kDistMidi 

kCrunch = 1 - kDist
if kCrunch == 0 then
    kCrunch = 0.01
endif

aOut powershape aIn, kCrunch

xout aOut
endop

opcode ASynthOverDrive, aa, iiaa
iInstr, iNum, aInLeft, aInRight xin

aOutLeft ASynthOverDrive iInstr, iNum, aInLeft
aOutRight ASynthOverDrive iInstr, iNum, aInRight

xout aOutLeft, aOutRight
endop

opcode ASynthReverb, aa, iiaa
iInstr, iNum, aInLeft, aInRight xin

kReverbAmountMidi chnget "reverb_wet", iInstr, iNum
kReverbAmount = kReverbAmountMidi 

kReverbSizeMidi chnget "reverb_roomsize", iInstr, iNum
kReverbSize = kReverbSizeMidi 

kReverbWidthMidi chnget "reverb_width", iInstr, iNum
kReverbWidth = kReverbWidthMidi 

kReverbDampMidi chnget "reverb_damp", iInstr, iNum
kReverbDamp  = kReverbDampMidi

aReverbL, aReverbR freeverb aInLeft, aInRight, kReverbSize, kReverbDamp

kWet1 = kReverbAmount * ( kReverbWidth / 2 + 0.5 )
kWet2 = kReverbAmount * ( ( 1 - kReverbWidth ) / 2 )
kDry = 1 - kReverbAmount

aInput = aInLeft + aInRight * 0.015

aOutLeft = aReverbL * kWet1 + aReverbR * kWet2 + aInput * kDry
aOutRight = aReverbR * kWet1 + aReverbL * kWet2 + aInput * kDry

xout (aOutLeft + aInLeft) / 2, (aOutRight + aInRight) / 2
endop


opcode ASynthChannelGet, aa, ii
iInstr, iNum xin

aSendL chnget "send_left", iInstr, iNum
aSendR chnget "send_right", iInstr, iNum

xout aSendL, aSendR
endop


opcode ASynthOut, 0, iiaa
iInstr, iNum, aSendL, aSendR xin

outs aSendL, aSendR
clear aSendL, aSendR

chnset aSendL, "send_left", iInstr, iNum
chnset aSendR, "send_right", iInstr, iNum

endop


opcode ASynthEffects, 0, i
iInstr xin

iNum = 1

aSendL, aSendR ASynthChannelGet iInstr, iNum
aSendL, aSendR ASynthOverDrive iInstr, iNum, aSendL, aSendR
aSendL, aSendR ASynthReverb iInstr, iNum, aSendL, aSendR

ASynthOut iInstr, iNum, aSendL, aSendR

endop


opcode ASynthPortamento, k, iiki
iInstr, iNum, kFreq, iPreviousFreq xin

kKeyboardModeMidi chnget "keyboard_mode", iInstr, iNum
kKeyboardMode round kKeyboardModeMidi

iPortamentoTimeMidi chnget "portamento_time", iInstr, iNum
kPortamentoTime = iPortamentoTimeMidi

iPortamentoModeMidi chnget "portamento_mode", iInstr, iNum
kPortamentoMode round iPortamentoModeMidi

kLargest chnget "largest", iInstr, iNum
kNotes chnget "number_of_notes", iInstr, iNum
kNoteOn chnget "note_on", iInstr, iNum

kInstrCount active iInstr, 0, 1

if kKeyboardMode == 0 then
    if kInstrCount <= 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq portk kFreq, 0.2 * kPortamentoTime, iPreviousFreq
else
    if kNotes <= 1 && kNoteOn == 1 && kPortamentoMode == 1 then
        kPortamentoTime = 0
    endif

    kFreq = cpsoct((kLargest / 12) + 3)
    kFreq portk kFreq, 0.2 * kPortamentoTime, iPreviousFreq
endif

xout kFreq
endop


opcode ASynthLfoFreq, k, iika
iInstr, iNum, kFreq, aLfo xin

kLfoToOscMidi chnget "freq_mod_osc", iInstr, iNum
kLfoToOsc round kLfoToOscMidi 

kLfoFreqAmountMidi chnget "freq_mod_amount", iInstr, iNum
kLfoFreqAmount pow kLfoFreqAmountMidi, 3
kLfoFreqAmount = kLfoFreqAmount - 1
kLfoFreqAmount = kLfoFreqAmount / 2 + 0.5

if kLfoToOsc == 0 || kLfoToOsc == iNum then
    kOsc = kFreq * ( kLfoFreqAmount * ( aLfo + 1 ) + 1 - kLfoFreqAmount )
    kFreq min kOsc, sr / 2
endif

xout kFreq
endop


opcode ASynthRender, aa, iiai
iInstr, iNum, aVco, iUserForMono xin

kMasterVolMidi chnget "master_vol", iInstr, iNum
kMasterVol = kMasterVolMidi

kKeyboardModeMidi chnget "keyboard_mode", iInstr, iNum
kKeyboardMode round kKeyboardModeMidi

aClipL clip aVco, 0, 0.9
aClipR clip aVco, 0, 0.9

kInstrCount active iInstr, 0, 1

if kKeyboardMode == 0 then
    kInstrCount active iInstr, 0, 0
    kInstrCountScale = kInstrCount^0.5
else
    kInstrCountScale = 1
endif

if kKeyboardMode == 0 || kKeyboardMode == 1 || iUserForMono == 1 then
    if kInstrCountScale != 0 then
        aLeft = (aVco * kMasterVol) / kInstrCountScale
        aRight = (aVco * kMasterVol) / kInstrCountScale
    else
        aLeft init 0
        aRight init 0
    endif
endif

xout aLeft, aRight
endop


opcode ASynthChannelSet, 0, iiaa
iInstr, iNum, aLeft, aRight xin

aSendL chnget "send_left", iInstr, iNum
aSendR chnget "send_right", iInstr, iNum

aSendL sum aSendL, aLeft
aSendR sum aSendR, aRight

chnset aSendL, "send_left", iInstr, iNum
chnset aSendR, "send_right", iInstr, iNum

endop


opcode ASynth, aa, iiiiiip
p1, p2, p3, p4, p5, p6, p7 xin

iInstr = p1

ib1 = p4
ib2 = p5
kFreq mtof ib1
iAmp = ib2 / 127
iPreviousFreq = p6
iUserForMono = p7

kFreq ASynthPortamento iInstr, 1, kFreq, iPreviousFreq

aLfoOsc ASynthLfo iInstr, 1, kFreq

kOsc1Freq ASynthLfoFreq iInstr, 1, kFreq, aLfoOsc

kOsc2Freq ASynthDetune iInstr, 2, kFreq

kOsc2Freq ASynthLfoFreq iInstr, 2, kOsc2Freq, aLfoOsc

aNone init 0

aOsc1, aOsc1Sync ASynthOsc iInstr, 1, iAmp, kOsc1Freq, aNone

aOsc2, aOsc2Sync ASynthOsc iInstr, 2, iAmp, kOsc2Freq, aOsc1Sync

aVco ASynthMix iInstr, 1, aOsc1, aOsc2

aVco ASynthAmp iInstr, 1, aVco, aLfoOsc

aVco ASynthFilter iInstr, 1, aVco, aLfoOsc, kFreq, iAmp

aSendL, aSendR ASynthRender iInstr, 1, aVco, iUserForMono

xout aSendL, aSendR
endop

maxalloc 1, 16
prealloc 1, 16
maxalloc 3, 16
prealloc 3, 16

instr 1
    aSendL, aSendR ASynth p1, p2, p3, p4, p5, p6, p7
    ASynthChannelSet p1, 1, aSendL, aSendR
endin

instr 11
    iInstr = 1
    iChannel = 1
    AMonoSynth iInstr, iChannel
    ASynthEffects iInstr
endin

instr 3
    aSendL, aSendR ASynth p1, p2, p3, p4, p5, p6, p7
    ASynthChannelSet p1, 1, aSendL, aSendR
endin

instr 31
    iInstr = 3
    iChannel = 3
    AMonoSynth iInstr, iChannel
    ASynthEffects iInstr
endin


instr 101

    ReadMidiCC "_1_1_amp_attack", 0, 2.5, 1, 13, 0.0333329997956753
    ReadMidiCC "_1_1_amp_decay", 0, 2.5, 1, 14, 1.70000994205475
    ReadMidiCC "_1_1_amp_sustain", 0, 1.0, 1, 15, 0
    ReadMidiCC "_1_1_amp_release", 0, 2.5, 1, 16, 0.648586988449097
    ReadMidiCC "_1_1_osc_waveform", 0, 4.0, 1, 17, 2
    ReadMidiCC "_1_1_filter_attack", 0, 2.5, 1, 29, 0.0916669964790344
    ReadMidiCC "_1_1_filter_decay", 0, 2.5, 1, 30, 0.649999976158142
    ReadMidiCC "_1_1_filter_sustain", 0, 1.0, 1, 31, 0.786666989326477
    ReadMidiCC "_1_1_filter_release", 0, 2.5, 1, 32, 1.22500002384186
    ReadMidiCC "_1_1_filter_resonance", 0, 0.97, 1, 33, 0.712141990661621
    ReadMidiCC "_1_1_filter_env_amount", -16, 16, 1, 36, 11.8400001525879
    ReadMidiCC "_1_1_filter_cutoff", -0.5, 1.5, 1, 34, -0.279527992010117
    ReadMidiCC "_1_2_osc_detune", -1, 1, 1, 53, 0.0333329997956753
    ReadMidiCC "_1_2_osc_waveform", 0, 4.0, 1, 49, 1
    ReadMidiCC "_1_1_master_vol", 0, 1, 1, 20, 0.72530198097229
    ReadMidiCC "_1_1_lfo_freq", 0, 7.5, 1, 79, 7.5
    ReadMidiCC "_1_1_lfo_waveform", 0, 6.0, 1, 78, 1
    ReadMidiCC "_1_2_osc_range", -3, 4, 1, 51, 0
    ReadMidiCC "_1_1_osc_mix", -1, 1, 1, 55, -0.098302997648716
    ReadMidiCC "_1_1_freq_mod_amount", 0, 1.25992105, 1, 81, 0
    ReadMidiCC "_1_2_freq_mod_amount", 0, 1.25992105, 1, 81, 0
    ReadMidiCC "_1_1_filter_mod_amount", -1, 1, 1, 82, -0.446666985750198
    ReadMidiCC "_1_1_amp_mod_amount", -1, 1, 1, 83, -1
    ReadMidiCC "_1_1_osc_mix_mode", 0, 1, 2, 56, 0
    ReadMidiCC "_1_1_osc_pulsewidth", 0, 1.0, 1, 18, 0.983332991600037
    ReadMidiCC "_1_2_osc_pulsewidth", 0, 1.0, 1, 50, 0.146667003631592
    ReadMidiCC "_1_1_reverb_roomsize", 0, 1, 2, 78, 0.74666702747345
    ReadMidiCC "_1_1_reverb_damp", 0, 1, 2, 80, 0.879999995231628
    ReadMidiCC "_1_1_reverb_wet", 0, 1, 2, 77, 0.333332985639572
    ReadMidiCC "_1_1_reverb_width", 0, 1, 2, 79, 1
    ReadMidiCC "_1_1_distortion_crunch", 0, 0.9, 2, 20, 0
    ReadMidiCC "_1_1_osc_sync", 0, 1, 2, 55, 0
    ReadMidiCC "_1_2_osc_sync", 0, 1, 2, 55, 0
    ReadMidiCC "_1_1_portamento_time", 0, 1, 1, 54, 0
    ReadMidiCC "_1_1_keyboard_mode", 0, 2, 1, 56, 0
    ReadMidiCC "_1_2_osc_pitch", -12, 12, 1, 52, 0
    ReadMidiCC "_1_1_filter_type", 0, 4.0, 1, 19, 0
    ReadMidiCC "_1_1_freq_mod_osc", 0, 2.0, 1, 80, 0
    ReadMidiCC "_1_2_freq_mod_osc", 0, 2.0, 1, 80, 0
    ReadMidiCC "_1_1_filter_kbd_track", 0, 1, 1, 35, 0.509999990463257
    ReadMidiCC "_1_1_portamento_mode", 0, 1, 1, 77, 1

endin


instr 99
endin

</CsInstruments>

<CsScore>
f 1 0 16384 10 1 ;sine
f 0 3600
i 11 0 -1
i 31 0 -1
i 99 0 -1
i 101, 0, -1
</CsScore>

</CsoundSynthesizer>
