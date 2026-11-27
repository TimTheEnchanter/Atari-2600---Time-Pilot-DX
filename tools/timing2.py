import sys, random, collections, subprocess, os
sys.path.insert(0,'/home/claude/tools')
env=dict(os.environ, DEBUGT='1', OUTROM='/tmp/dbg.a26')
r=subprocess.run([sys.executable,'-I','/home/claude/tp/mk_dx.py'],capture_output=True,text=True,env=env)
assert 'built' in r.stdout, r.stdout+r.stderr
from lr import Emu
N=int(sys.argv[1]) if len(sys.argv)>1 else 15000
for seed in (5,9):
    e=Emu('/tmp/dbg.a26'); e.run(30); e.press(3)
    rr=random.Random(seed); j=16; H={k:collections.Counter() for k in ('vb_end','vb_enemy','os_lf0ab','os_build')}; bad=[]
    for i in range(N):
        if i%40==0: j=16|rr.choice([0,1,2,4,8,5,6,9,10])
        n=sum(1 for k in range(4) if e.r(0xA5+k))+sum(1 for v in e.sc(0,2) if v)
        l=e.run(1,joy=j)[0]
        vals=dict(vb_end=e.r(0xB9),vb_enemy=e.r(0xB7),os_build=e.r(0xB8),os_lf0ab=e.r(0xBC))
        for k,v in vals.items(): H[k][v]+=1
        if l!=262 and i>20 and len(bad)<5: bad.append((i,l,n,vals))
        if e.r(0xA0)==0xFF: e.press(3)
    for k,c in H.items():
        print(seed,k,'lowest',[(a,b) for a,b in sorted(c.items()) if a<60][:5],'wrapped',sum(b for a,b in c.items() if a>=60))
    print('bad',bad)
