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
def L_maxC_h(L, h, space='srgb', eps=1e-6, tol=1e-9):
    """
    Binary search for max attainable OKLCH chroma at fixed lightness and hue.

    Parameters:
        L: lightness percentage
    """

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
    
def bezier_y_at_x(P0, P1, P2, w, x_query, n=400):
    """
    For the provided QBR parameters, provide the curve value at the given
    input.
    """

    t = np.linspace(0, 1, n)
    B = quad_bezier_rational(P0, P1, P2, w, t)
    x_vals, y_vals = B[:, 0], B[:, 1]
    
    return np.interp(x_query, x_vals, y_vals)

def Lspace_Cmax_Hmap(h_map: dict[str, float], L_space):
    """
    Compute chroma maxima at provided lightness levels across hues.

    Parameters:
        h_map: map from hue names to hue values
        L_space: array-like set of lightness values

    Returns:
        A map with max chroma values for each hue across lightness space

        {
           "red": [ Cmax@L=10, Cmax@L=11, Cmax@L=12, ... ],
           "orange": [ Cmax@L=10, Cmax@L=11, Cmax@L=12, ... ],
           ...
        }
    """
    # compute C max values over each point in L space

    h_Lspace_Cmax = {
        h_str: [max_C_Lh(_L, _h) for _L in L_space]
        for h_str, _h in h_map.items()
    }

    return h_Lspace_Cmax

def ():
    """
    

    raw bezier chroma values for each hue across the lightness space
    h_L_points_C = {
       "red": [ Bezier@L=10, Bezier@L=11, Bezier@L=12, ... ],
       ...
    }
    
    three bezier control points for each hue's chroma curve
    h_ctrl_L_C = {
       "red": np.array([
           [ x1, y1 ],
           [ x2, y2 ],
           [ x3, y3 ]
        ]),
       ...
    }
    """

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


def ():
    """
    bezier chroma values, but bounded to attainable gamut colors (bezier fit can produce invalid chroma values)
    h_L_points_Cstar = {
       "red": [ bounded-bezier@L=10, bounded-bezier@L=11, ... ],
       ...
    }
    """

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
