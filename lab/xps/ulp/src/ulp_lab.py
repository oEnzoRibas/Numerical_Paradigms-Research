"""Reproducible numerical experiments for (x**10 + c) - x**10.

Research inputs: Lucas Martins Rocha, 2026, ulp research article/report/book draft.
This module is original supporting code; `reference_*` files preserve prior sources.
No Internet access required. IEEE 754 round-to-nearest, ties-to-even assumed.
"""
from __future__ import annotations
from dataclasses import dataclass
import math
import numpy as np

PRECISION = {np.float64: 53, np.float32: 24}


def evaluate(x, c, dtype=np.float64, n=10):
    """Compute y once; re-use the *stored* y in both operations. Avoid promotion.

    This mirrors the source experiment and is NOT a symbolic evaluation of c.
    """
    xv = np.asarray(x, dtype=dtype)
    cv = dtype(c)
    y = np.power(xv, n, dtype=dtype)
    result = np.subtract(np.add(y, cv, dtype=dtype), y, dtype=dtype)
    return result, y


def ulp(y, dtype=np.float64):
    yy = np.asarray(y, dtype=dtype)
    return np.nextafter(yy, dtype(np.inf), dtype=dtype) - yy


def v2(c, dtype=np.float64):
    """Exponent of least-significant set bit in the STORED positive float c."""
    v = dtype(c)
    if not (np.isfinite(v) and v > 0):
        raise ValueError('c must be finite and positive')
    m, exp = np.frexp(v)
    p = PRECISION[dtype]
    mm = int(float(m) * (1 << p))
    tz = (mm & -mm).bit_length() - 1
    return int(exp - p + tz)


def floor_log2(c, dtype=np.float64):
    return int(np.frexp(dtype(c))[1]) - 1


@dataclass(frozen=True)
class Theory:
    c: float
    p: int
    nu: int
    k: int
    E1: int
    E2: int
    L: int
    x1: float
    x2: float


def theory(c, dtype=np.float64, n=10):
    cv = dtype(c)
    p = PRECISION[dtype]
    nu = v2(cv, dtype)
    k = floor_log2(cv, dtype)
    E1, E2 = p + nu, p + k
    return Theory(float(cv), p, nu, k, E1, E2, E2-E1+1,
                  2.0**(E1/n), 2.0**((E2+1)/n))


def possible_results(c, E, dtype=np.float64):
    """Same-binade nearest-grid rule, excluding upward binade crossings.

    Returns the set of possible values as x varies within a binade.
    A half-ULP tie can yield both outcomes depending on the parity of y/u.
    """
    t = theory(c, dtype=dtype)
    if E < t.E1:
        return {t.c}
    u = math.ldexp(1.0, E - (t.p - 1))
    q = t.c / u
    m = math.floor(q)
    if q - m == 0.5:
        return {m*u, (m+1)*u}
    return {math.floor(q + 0.5)*u}


def sample_binade(c, E, dtype=np.float64, n=10, count=1500, rng=None):
    """Sample x from nominal binade, report the real binade of computed y."""
    if rng is None:
        rng = np.random.default_rng(0)
    lo, hi = 2.0**(E/n), 2.0**((E+1)/n)
    x = dtype(lo) + (dtype(hi)-dtype(lo))*rng.random(count).astype(dtype)
    res, y = evaluate(x, c, dtype, n=n)
    real_E = np.frexp(y)[1].astype(np.int32) - 1
    return x, res, y, real_E


def valid_same_binade_mask(y, c, E, dtype=np.float64):
    """Domain of the paper's proposition: y>=c, no addition across the binade.

    np.longdouble is used only in this *diagnostic* mask, never in the
    arithmetic being studied. Supports Linux extended precision; for
    environments with 64-bit longdouble, this is an approximation near edges.
    """
    yy = np.asarray(y)
    boundary = np.longdouble(2.0) ** (E+1)
    crosses = (yy.astype(np.longdouble) + np.longdouble(dtype(c))) >= boundary
    too_small = yy < dtype(c)
    return ~(crosses | too_small), crosses, too_small


def generate_cases(seed=42):
    """Source paper's 1,001 odd + 300 dyadic + 310 other numerical inputs.

    Uses one deterministic list for *both* precisions, which makes
    precision comparisons paired. Non-dyadic inputs are FLOATS, not exact
    rationals; duplicates among the 300 dyadics are possible.
    """
    rng = np.random.default_rng(seed)
    odd = [float(i) for i in range(1,2002,2)]
    dy = []
    for _ in range(300):
        j = int(rng.integers(1,9))
        m = (int(rng.integers(1, 2**int(rng.integers(1,10))))*2+1
             if rng.random() < .9 else 1)
        dy.append(m/2**j)
    nd = [0.1, 0.2, 0.3, 1/3, 0.7, 0.6, 0.9, math.pi, math.e, 2/3]
    nd += [float(v) for v in rng.uniform(.01,50,300)]
    assert len(odd)==1001 and len(dy)==300 and len(nd)==310
    return {'odd integers':odd, 'dyadic fractions':dy, 'non-dyadic examples':nd}


def validate_one(c, dtype=np.float64, n=10, samples=1500, rng=None):
    """Test observed outputs against predicted sets, with exclusions counted.

    For the claim 'all 1,611 inputs passed' use validity-domain accounting;
    do not infer that unmatched out-of-domain points disprove the model.
    """
    if rng is None:
        rng = np.random.default_rng(42)
    t = theory(c, dtype=dtype, n=n)
    examined = matched = excluded_edge = excluded_small = 0
    mismatches = []
    seen_tie_variants = set()
    for E in range(max(t.E1-2, t.k+1), t.E2+3):
        x, r, y, realE = sample_binade(c,E,dtype,n,count=samples,rng=rng)
        # source protocol: only keep points whose computed y belongs to sampled binade
        in_binade = realE == E
        valid, crossing, small = valid_same_binade_mask(y,c,E,dtype)
        excluded_edge += int(np.count_nonzero(in_binade & crossing))
        excluded_small += int(np.count_nonzero(in_binade & small))
        selected = in_binade & valid
        nsel = int(np.count_nonzero(selected))
        examined += nsel
        if nsel == 0:
            continue
        observed = set(np.unique(r[selected].astype(np.float64)).tolist())
        expected = possible_results(c, E, dtype)
        if E == t.E1:
            seen_tie_variants.update(observed)
        if not observed.issubset(expected):
            mismatches.append((E,sorted(observed),sorted(expected)))
        else:
            matched += nsel
        # Cross-check the stated half-ULP bound on the accepted domain.
        if nsel:
            bound = 0.5*math.ldexp(1.0,E-(t.p-1))
            if np.any(np.abs(r[selected].astype(np.float64)-t.c) > bound*(1+1e-12)):
                mismatches.append((E,'exceeded 0.5 ULP','domain mask or model error'))
    return {'pass':not mismatches, 'matched':matched, 'examined':examined,
            'excluded_edge':excluded_edge, 'excluded_y_lt_c':excluded_small,
            'tie_variants_seen':len(seen_tie_variants), 'mismatches':mismatches[:3]}
