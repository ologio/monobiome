import json
from pathlib import Path
from functools import cache

import numpy as np

from pprint import pprint
from coloraide import Color

from monobiome.constants import (
    L_points,
    L_resolution,
    L_space,

    monotone_C_map,
    h_weights,
    h_L_offsets,
    h_C_offsets,

    monotone_h_map,
    accent_h_map,
    h_map,
)


@cache
def max_C_Lh(L, h, space='srgb', eps=1e-6, tol=1e-9):
    '''
    Binary search for max chroma at fixed lightness and hue

    Parameters:
        L: lightness percentage
    '''
    def C_in_gamut(C):
        return Color('oklch', [L/100, C, h]).convert(space).in_gamut(tolerance=tol)

    lo, hi = 0.0, 0.1
    while C_in_gamut(hi):
        hi *= 2
    while hi - lo > eps:
        m = (lo + hi) / 2
        lo, hi = (m, hi) if C_in_gamut(m) else (lo, m)

    Cmax = lo
    # c_oklch = Color('oklch', [L, Cmax, h])
    # c_srgb  = c_oklch.convert('srgb')
    
    return Cmax

def quad_bezier_rational(P0, P1, P2, w, t):
    t = np.asarray(t)[:, None]
    num = (1-t)**2*P0 + 2*w*(1-t)*t*P1 + t**2*P2
    den = (1-t)**2 + 2*w*(1-t)*t + t**2
    
    return num/den
    
def bezier_y_at_x(P0, P1, P2, w, x_query, n=400):
    t = np.linspace(0, 1, n)
    B = quad_bezier_rational(P0, P1, P2, w, t)
    x_vals, y_vals = B[:, 0], B[:, 1]
    
    return np.interp(x_query, x_vals, y_vals)


# compute C max values over each point in L space
h_Lspace_Cmax = {
    h_str: [max_C_Lh(_L, _h) for _L in L_space]
    for h_str, _h in h_map.items()
}

# compute *unbounded* chroma curves for all hues
h_L_points_C = {}
h_ctrl_L_C = {}

for h_str, _h in monotone_h_map.items():
    h_L_points_C[h_str] = np.array([monotone_C_map[h_str]]*len(L_points))
    
for h_str, _h in accent_h_map.items():
    Lspace_Cmax = h_Lspace_Cmax[h_str]
    
    # get L value of max chroma; will be a bezier control
    L_Cmax_idx = np.argmax(Lspace_Cmax)
    L_Cmax = L_space[L_Cmax_idx]

    # offset control point by any preset x-shift
    L_Cmax += h_L_offsets[h_str]

    # and get max C at the L offset
    Cmax = max_C_Lh(L_Cmax, _h)

    # set 3 control points; shift by any global linear offest
    C_offset = h_C_offsets.get(h_str, 0)
    
    p_0 = np.array([0, 0])
    p_Cmax = np.array([L_Cmax, Cmax + C_offset])
    p_100 = np.array([100, 0])
    
    B_L_points = bezier_y_at_x(p_0, p_Cmax, p_100, h_weights.get(h_str, 1), L_points)
    h_L_points_C[h_str] = B_L_points
    h_ctrl_L_C[h_str] = np.vstack([p_0, p_Cmax, p_100])

# compute full set of final chroma curves; limits every point to in-gamut max
h_LC_color_map = {}
h_L_points_Cstar = {}

for h_str, L_points_C in h_L_points_C.items():
    _h = h_map[h_str]

    h_L_points_Cstar[h_str] = [
        max(0, min(_C, max_C_Lh(_L, _h)))
        for _L, _C in zip(L_points, L_points_C)
    ]

# if __name__ == "__main__":
