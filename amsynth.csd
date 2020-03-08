<CsoundSynthesizer>
<CsOptions>
-odac -Ma --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1

instr 2

giEmpty ftgen 2, 0, -100, 2, 0
ftload "patch.txt", 1, 2

iAttMidi table 0, 2
iDecMidi table 1, 2
iSus table 2, 2
iRelMidi table 3, 2
iOsc1TypeMidi table 4, 2

initc7 1, 13, iAttMidi / 2.5
initc7 1, 14, iDecMidi / 2.5
initc7 1, 15, iSus
initc7 1, 16, iRelMidi / 2.5
initc7 1, 17, iOsc1TypeMidi / 4

endin

instr 1

iFreq = p4
iAmp = p5
iCutoff = 12

iDb db 12
kRes = 0

iAttMidi = ctrl7(1, 13, 0.0, 2.5)
iAtt pow iAttMidi, 3
iAtt = iAtt + 0.0005

iDecMidi ctrl7  1, 14, 0.0, 2.5
iDec pow iDecMidi, 3
iDec = iDec + 0.0005

iSus ctrl7  1, 15, 0.0, 1

iRelMidi ctrl7  1, 16, 0.0, 2.5
iRel pow iRelMidi, 3
iRel = iRel + 0.0005

iOsc1TypeMidi ctrl7  1, 17, 0, 4
iOsc1Type round iOsc1TypeMidi

kPw ctrl7  1, 56, 0.0, 1.0
kPw scale kPw, 0.01, 0.5

;OCS 1

if iOsc1Type == 0 then
    ;sine wave
    aVco oscil iAmp, iFreq, 1
elseif iOsc1Type == 1 then
    ;square / pulse
    aVco vco2 iAmp, iFreq, 2, kPw
elseif iOsc1Type == 2 then
    ;triangle / saw
    aVco vco2 iAmp, iFreq, 4, kPw
elseif iOsc1Type == 3 then
    ;white noise
    aVco noise iAmp, 0.5
else
    ;noise + sample & hold
    aVco randh iAmp, iFreq
endif

print iOsc1Type, iAtt, iDec, iSus, iRel
printk2 kPw

kEnv linsegr 0,iAtt,1,iDec,iSus,iRel,0
outs aVco * kEnv, aVco * kEnv

;save the patch
iSave ctrl7  1, 106, 0, 1
if iSave == 1 then
    tablew iAttMidi, 0, 2
    tablew iDecMidi, 1, 2
    tablew iSus, 2, 2
    tablew iRelMidi, 3, 2
    tablew iOsc1TypeMidi, 4, 2
    ftsave "patch.txt", 1, 2
    print iSave
endif

endin

</CsInstruments>
<CsScore>
f1 0 4096 10   1
i 2 0 0
f0 3600
</CsScore>
</CsoundSynthesizer>
