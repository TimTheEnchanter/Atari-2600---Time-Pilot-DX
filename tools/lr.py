"""Minimal ctypes libretro frontend for the Stella core (testing 2600 ROMs).
from lr import Emu; e = Emu('rom.a26'); e.run(60, joy=0); e.ram(); e.lines(); e.shot('a.png')
joy bits: up=1 down=2 left=4 right=8 fire=16 ; e.switches(reset=, select=, ...)
"""
import ctypes as C, os

CORE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'stella_libretro.so')

class GameInfo(C.Structure):
    _fields_ = [('path', C.c_char_p), ('data', C.c_void_p), ('size', C.c_size_t), ('meta', C.c_char_p)]
class Variable(C.Structure):
    _fields_ = [('key', C.c_char_p), ('value', C.c_char_p)]

ENV = C.CFUNCTYPE(C.c_bool, C.c_uint, C.c_void_p)
VID = C.CFUNCTYPE(None, C.c_void_p, C.c_uint, C.c_uint, C.c_size_t)
AUD = C.CFUNCTYPE(None, C.c_int16, C.c_int16)
AUDB = C.CFUNCTYPE(C.c_size_t, C.c_void_p, C.c_size_t)
POLL = C.CFUNCTYPE(None)
INP = C.CFUNCTYPE(C.c_int16, C.c_uint, C.c_uint, C.c_uint, C.c_uint)

# RETRO_DEVICE_ID_JOYPAD: B=0 Y=1 SELECT=2 START=3 UP=4 DOWN=5 LEFT=6 RIGHT=7 A=8 X=9 L=10 R=11 L2=12 R2=13 L3=14 R3=15
class Emu:
    def __init__(self, rom, opts=None):
        import shutil, tempfile
        Emu._n = getattr(Emu, '_n', 0) + 1
        core = CORE if Emu._n == 1 else shutil.copy(CORE, os.path.join(tempfile.gettempdir(), 'stella_%d_%d.so' % (os.getpid(), Emu._n)))
        self.lib = C.CDLL(core)
        self.joy = [0, 0]; self.btn = {}  # extra joypad ids (port0)
        self.frame = None; self.w = self.h = self.pitch = 0
        self.opts = {b'stella_console': b'auto', b'stella_palette': b'standard', b'stella_filter': b'disabled',
                     b'stella_phosphor': b'off'}
        self._sysdir = C.c_char_p(b'/tmp')
        def env(cmd, data):
            cmd &= 0xFFFF
            if cmd in (9, 31):  # system dir / save dir
                C.cast(data, C.POINTER(C.c_char_p))[0] = self._sysdir; return True
            if cmd == 10: return True  # pixel format
            if cmd == 15:
                v = C.cast(data, C.POINTER(Variable))[0]
                if v.key in self.opts:
                    C.cast(data, C.POINTER(Variable))[0].value = C.c_char_p(self.opts[v.key]); return True
                return False
            if cmd == 17:
                C.cast(data, C.POINTER(C.c_bool))[0] = False; return True
            return False
        def vid(data, w, h, pitch):
            if data:
                self.w, self.h, self.pitch = w, h, pitch
                self.frame = C.string_at(data, pitch * h)
        def inp(port, dev, idx, id_):
            if port > 1: return 0
            j = self.joy[port]
            m = {4: 1, 5: 2, 6: 4, 7: 8, 0: 16}
            if id_ in m: return 1 if j & m[id_] else 0
            return 1 if self.btn.get((port, id_)) else 0
        self._cb = [ENV(env), VID(vid), AUD(lambda l, r: None), AUDB(lambda d, n: n), POLL(lambda: None), INP(inp)]
        L = self.lib
        L.retro_set_environment(self._cb[0]); L.retro_init()
        L.retro_set_video_refresh(self._cb[1]); L.retro_set_audio_sample(self._cb[2])
        L.retro_set_audio_sample_batch(self._cb[3]); L.retro_set_input_poll(self._cb[4]); L.retro_set_input_state(self._cb[5])
        L.retro_dbg_scanlines.restype = C.c_uint
        L.retro_get_memory_data.restype = C.c_void_p
        self.data = open(rom, 'rb').read()
        self._buf = C.create_string_buffer(self.data, len(self.data))
        gi = GameInfo(rom.encode(), C.cast(self._buf, C.c_void_p), len(self.data), None)
        assert L.retro_load_game(C.byref(gi)), 'load failed'

    def run(self, n=1, joy=None, joy2=None, btn=None):
        if joy is not None: self.joy[0] = joy
        if joy2 is not None: self.joy[1] = joy2
        if btn is not None: self.btn = btn
        out = []
        for _ in range(n):
            self.lib.retro_run(); out.append(self.lines())
        return out

    def press(self, id_, frames=6, port=0):
        """console switches via joypad ids: SELECT=2, START(reset)=3, L/R difficulty=10/11, L2/R2=12/13 colour"""
        self.btn = {(port, id_): 1}; self.run(frames); self.btn = {}; self.run(2)

    def lines(self): return self.lib.retro_dbg_scanlines()
    def ram(self): return bytes(C.string_at(self.lib.retro_get_memory_data(2), 128))
    def r(self, a): return self.ram()[a - 0x80]

    def shot(self, path, scale=2):
        from PIL import Image
        img = Image.frombuffer('RGBX', (self.pitch // 4, self.h), self.frame, 'raw', 'BGRX', 0, 1).crop((0, 0, self.w, self.h)).convert('RGB')
        img = img.resize((self.w * scale, self.h * scale), Image.NEAREST)
        img.save(path); return path
