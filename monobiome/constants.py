import tomllib
from importlib.resources import files

import numpy as np

from monobiome.curve import (
    l_maxC_h,
    bezier_y_at_x,
)

parameters_file = files("monobiome.data") / "parameters.toml"
parameters = tomllib.load(parameters_file.open("rb"))

L_min: int = parameters.get("L_min", 10)
L_max: int = parameters.get("L_max", 98)
L_step: int = parameters.get("L_step", 5)

L_points: list[int] = list(range(L_min, L_max+1))

# L-space just affects accuracy of chroma max
L_space = np.arange(0, 100 + L_step, L_step)

monotone_C_map = parameters.get("monotone_C_map", {})
h_weights = parameters.get("h_weights", {})
h_L_offsets = parameters.get("h_L_offsets", {})
h_C_offsets = parameters.get("h_C_offsets", {})
monotone_h_map = parameters.get("monotone_h_map", {})
accent_h_map = parameters.get("accent_h_map", {})
h_map = {**monotone_h_map, **accent_h_map}

"""
Compute chroma maxima at provided lightness levels across hues.

A map with max chroma values for each hue across lightness space

{
   "red": [ Cmax@L=10, Cmax@L=11, Cmax@L=12, ... ],
   "orange": [ Cmax@L=10, Cmax@L=11, Cmax@L=12, ... ],
   ...
}
"""
Lspace_Cmax_Hmap = {
    h_str: [l_maxC_h(_L, _h) for _L in L_space]
    for h_str, _h in h_map.items()
}


"""
Set QBR curves, *unbounded* chroma curves for all hues

1. Raw bezier chroma values for each hue across the lightness space

   Lpoints_Cqbr_Hmap = {
      "red": [ Bezier@L=10, Bezier@L=11, Bezier@L=12, ... ],
      ...
   }

2. Three bezier control points for each hue's chroma curve

   QBR_ctrl_Hmap = {
      "red": np.array([
          [ x1, y1 ],
          [ x2, y2 ],
          [ x3, y3 ]
       ]),
      ...
   }
"""
Lpoints_Cqbr_Hmap = {}
QBR_ctrl_Hmap = {}

for h_str, _h in monotone_h_map.items():
    Lpoints_Cqbr_Hmap[h_str] = np.array(
        [monotone_C_map[h_str]]*len(L_points)
    )
    
for h_str, _h in accent_h_map.items():
    Lspace_Cmax = Lspace_Cmax_Hmap[h_str]
    
    # get L value of max chroma; will be a bezier control
    L_Cmax_idx = np.argmax(Lspace_Cmax)
    L_Cmax = L_space[L_Cmax_idx]

    # offset control point by any preset x-shift
    L_Cmax += h_L_offsets[h_str]

    # and get max C at the L offset
    Cmax = l_maxC_h(L_Cmax, _h)

    # set 3 control points; shift by any global linear offest
    C_offset = h_C_offsets.get(h_str, 0)
    
    p_0 = np.array([0, 0])
    p_Cmax = np.array([L_Cmax, Cmax + C_offset])
    p_100 = np.array([100, 0])
    
    B_L_points = bezier_y_at_x(
        p_0, p_Cmax, p_100,
        h_weights.get(h_str, 1),
        L_points
    )
    Lpoints_Cqbr_Hmap[h_str] = B_L_points
    QBR_ctrl_Hmap[h_str] = np.vstack([p_0, p_Cmax, p_100])


"""
Bezier chroma values, but bounded to attainable gamut colors (bezier fit
can produce invalid chroma values)

h_L_points_Cstar = {
   "red": [ bounded-bezier@L=10, bounded-bezier@L=11, ... ],
   ...
}
"""
Lpoints_Cstar_Hmap = {}

for h_str, L_points_C in Lpoints_Cqbr_Hmap.items():
    _h = h_map[h_str]

    Lpoints_Cstar_Hmap[h_str] = [
        max(0, min(_C, l_maxC_h(_L, _h)))
        for _L, _C in zip(L_points, L_points_C, strict=True)
    ]
