"""Reproduction of the original manuscript's per-binade validation protocol.

Runs a computationally substantial validation at N=3000 samples per binade.
The claim of 1,611 increments per precision in the report comes from the
supplied research document; this script is provided for reproducibility.
"""
import math
import numpy as np
from ulp_core import P, floor_log2, theory, sample_binade, predict_binade

rng = np.random.default_rng(42)


def cases(dtype):
    odds = [float(k) for k in range(1, 2002, 2)]
    dyadics = []
    for _ in range(300):
        j = int(rng.integers(1, 9))
        m = (int(rng.integers(1, 2**int(rng.integers(1, 10))))*2+1
             if rng.random() < .9 else 1)
        dyadics.append(m/2**j)
    non_dyadics = [0.1, 0.2, 0.3, 1/3, 0.7, 0.6, 0.9,
                   math.pi, math.e, 2/3]
    non_dyadics += [float(v) for v in rng.uniform(0.01, 50, 300)]
    return dict(odd=odds, dyadic=dyadics, non_dyadic=non_dyadics)


def check(c, n, dtype, N=3000):
    predicted = theory(c, n, dtype)
    ok = True
    checked = 0
    discrepancies = []
    crossings, samples = 0, 0
    for E in range(max(predicted['E1']-2, floor_log2(c, dtype)+1),
                   predicted['E2']+3):
        real_exp, result, y = sample_binade(c, E, n, dtype, N, rng)
        for actual_E in np.unique(real_exp):
            if actual_E != E:
                continue
            boundary_crossed = ((y.astype(np.float64)+float(dtype(c))) >=
                                2.0**(actual_E+1))
            select = (real_exp==actual_E) & ~boundary_crossed
            crossings += int(((real_exp==actual_E) & boundary_crossed).sum())
            samples += int((real_exp==actual_E).sum())
            if not select.any():
                continue
            observed = set(np.unique(result[select]).tolist())
            possible = ({float(dtype(c))} if actual_E < predicted['E1'] else
                        predict_binade(c, actual_E, dtype))
            checked += int(select.sum())
            if (not observed <= possible or
                    (predicted['E1'] <= actual_E <= predicted['E2'] and
                     observed != possible and len(possible)==2 and
                     N>1000 and len(observed)==1)):
                ok = False
                discrepancies.append((actual_E, sorted(observed),
                                      sorted(possible)))
    return ok, checked, discrepancies, (crossings, samples)


def main():
    boundary_counts = {'float64':[0,0], 'float32':[0,0]}
    for dtype in (np.float64,np.float32):
        for group,inputs in cases(dtype).items():
            count=0
            passed=0
            failures=[]
            for c in inputs:
                if dtype is np.float32 and c>1e6:
                    continue
                ok,ncheck,bad,border = check(c, 10, dtype)
                b=boundary_counts[dtype.__name__]
                b[0]+=border[0]
                b[1]+=border[1]
                count+=1
                passed+=int(ok)
                if not ok:
                    failures.append((c,bad[:2]))
            print(f'{dtype.__name__} | {group}: {passed}/{count} '
                  'increments fully consistent with the model')
            for row in failures[:3]:
                print('  discrepancy:',row)
    for k,v in boundary_counts.items():
        print(k,'binade crossings:',v[0], 'out of',v[1],
              f'({v[0]/max(v[1],1):.2e})')


if __name__=='__main__':
    main()
