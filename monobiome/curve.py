from functools import cache

import numpy as np
from coloraide import Color


def quad_bezier_rational(
    P0: float,
    P1: float,
    P2: float,
    w: float,
    t: np.ndarray,
) -> np.ndarray:
    """
    Compute the point values of a quadratic rational Bezier curve.

    Uses `P0`, `P1`, and `P2` as the three control points of the curve. `w`
    controls the weight toward the middle control point ("sharpness" of the
    curve"), and `t` is the number of sample points used along the curve.
    """

    t = np.asarray(t)[:, None]
    num = (1-t)**2*P0 + 2*w*(1-t)*t*P1 + t**2*P2
    den = (1-t)**2 + 2*w*(1-t)*t + t**2
    
    return num / den
    
def bezier_y_at_x(
    P0: float,
    P1: float,
    P2: float,
    w: float,
    x: float,
    n: int = 400,
) -> np.ndarray:
    """
    For the provided QBR parameters, provide the curve value at the given
    input.
    """

    t = np.linspace(0, 1, n)
    B = quad_bezier_rational(P0, P1, P2, w, t)
    x_vals, y_vals = B[:, 0], B[:, 1]
    
    return np.interp(x, x_vals, y_vals)

@cache
def l_maxC_h(
    _l: float,
    _h: float,
    space: str = 'srgb',
    eps: float = 1e-6,
    tol: float = 1e-9
) -> float:
    """
    Binary search for max attainable OKLCH chroma at fixed lightness and hue.

    Parameters:
        _l: lightness
        _h: hue

    Returns:
        Max in-gamut chroma at provided lightness and hue
    """

    def chroma_in_gamut(_c: float) -> bool:
        color = Color('oklch', [_l/100, _c, _h])
        return color.convert(space).in_gamut(tolerance=tol)

    lo, hi = 0.0, 0.1
    while chroma_in_gamut(hi):
        hi *= 2
    while hi - lo > eps:
        m = (lo + hi) / 2
        lo, hi = (m, hi) if chroma_in_gamut(m) else (lo, m)

    return lo
