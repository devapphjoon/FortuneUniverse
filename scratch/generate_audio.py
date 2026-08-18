import wave, struct, math, random

sample_rate = 44100

def save_wav(filename, samples):
    with wave.open(filename, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sample_rate)
        for s in samples:
            w.writeframesraw(struct.pack('<h', int(max(-32768, min(32767, s)))))

# 1. Cookie crack (crunch noise)
samples = []
for i in range(int(sample_rate * 0.4)): # 0.4 seconds
    env = 1.0 - (i / (sample_rate * 0.4))
    s = random.uniform(-1, 1) * 20000 * (env ** 2)
    samples.append(s)
save_wav(r'D:\AppDev\FortuneUniverse\assets\audio\sfx_cookie_crack.wav', samples)

# 2. Pop
samples = []
for i in range(int(sample_rate * 0.15)):
    env = 1.0 - (i / (sample_rate * 0.15))
    freq = 600 + env * 400
    s = math.sin(2 * math.pi * freq * i / sample_rate) * 20000 * env
    samples.append(s)
save_wav(r'D:\AppDev\FortuneUniverse\assets\audio\sfx_pop.wav', samples)

# 3. Card flip (swish)
samples = []
for i in range(int(sample_rate * 0.2)):
    env = math.sin(math.pi * i / (sample_rate * 0.2))
    s = random.uniform(-1, 1) * 8000 * env
    samples.append(s)
save_wav(r'D:\AppDev\FortuneUniverse\assets\audio\sfx_card_flip.wav', samples)

# 4. BGM (simple arpeggio loop, 8-bit style)
samples = []
notes = [261.63, 329.63, 392.00, 523.25] # C, E, G, C
for n in range(16):
    freq = notes[n % 4]
    for i in range(int(sample_rate * 0.25)):
        env = 1.0 - (i / (sample_rate * 0.25))
        s = math.sin(2 * math.pi * freq * i / sample_rate) * 8000 * (env ** 0.5)
        samples.append(s)
save_wav(r'D:\AppDev\FortuneUniverse\assets\audio\bgm.wav', samples)

print("Audio files generated successfully!")
