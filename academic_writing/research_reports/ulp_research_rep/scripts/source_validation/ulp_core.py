"""Floating-point ULP model, translated from the code in the supplied book draft.

Source provenance: the experiment code associated with the research manuscript
of Lucas Martins Rocha (dated 4 November 2026). Intended for reproducing the
reported per-binade experiments, not as a general-purpose IEEE 754 simulator.
"""
import math
import numpy as np

P = {np.float64: 53, np.float32: 24}  # Precision in bits, including hidden bit


def v2(c, dtype=np.float64):
    """Exponent of c's least significant nonzero bit: c = m * 2**v2, m odd."""
    p = P[dtype]
    mantissa, exponent = np.frexp(dtype(c))
    integer_mantissa = int(float(mantissa) * 2**p)
    trailing_zeros = (integer_mantissa & -integer_mantissa).bit_length() - 1
    return exponent - p + trailing_zeros


def floor_log2(c, dtype=np.float64):
    return int(np.frexp(dtype(c))[1]) - 1


def theory(c, n=10, dtype=np.float64):
    """Predict the first and last inexact binades and corresponding x boundaries."""
    p = P[dtype]
    c = dtype(c)
    E1 = p + v2(c, dtype)
    E2 = p + floor_log2(c, dtype)
    return dict(E1=E1, E2=E2, L=E2-E1+1,
                x1=2.0**(E1/n), x2=2.0**((E2+1)/n))


def f_fl(x, c, n=10):
    y = x**n  # Reused exactly in the following two operations
    return (y+c)-y, y


def predict_binade(c, E, dtype=np.float64):
    """Set of possible f values in binade E, excluding an upper-edge crossing."""
    p = P[dtype]
    c = float(dtype(c))
    u = 2.0**(E-(p-1))
    q = c/u
    lower = math.floor(q)
    if q-lower == 0.5:  # Rounding tie: depends on parity of y's significand
        return {lower*u, (lower+1)*u}
    return {math.floor(q+0.5)*u}


def sample_binade(c, E, n=10, dtype=np.float64, N=4000, rng=None):
    """Uniformly sample x in the theoretical x interval for binade E."""
    rng = rng if rng is not None else np.random.default_rng(0)
    lo, hi = 2.0**(E/n), 2.0**((E+1)/n)
    x = (lo+(hi-lo)*rng.random(N)).astype(dtype)
    values, y = f_fl(x, dtype(c), n)
    E_real = np.frexp(y)[1].astype(int)-1
    return E_real, values.astype(np.float64), y
