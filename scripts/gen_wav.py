import wave

files = [
    'assets/audio/bgm.wav',
    'assets/audio/sfx_card_flip.wav',
    'assets/audio/sfx_cookie_crack.wav',
    'assets/audio/sfx_pop.wav'
]

for f in files:
    with wave.open(f, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(44100)
        w.writeframes(b'\x00' * 44100)
