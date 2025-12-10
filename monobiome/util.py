import math
from types import GenericAlias
from argparse import ArgumentParser, _SubParsersAction

from coloraide import Color

_SubParsersAction.__class_getitem__ = classmethod(GenericAlias)
_SubparserType = _SubParsersAction[ArgumentParser]

def oklch_distance(xc: Color, yc: Color) -> float:
    """
    Compute the distance between two colors in OKLCH space.

    Note: `xc` and `yc` are presumed to be OKLCH colors already, such that
    `.coords()` yields an `(l, c, h)` triple directly rather than first
    requiring conversion. When we can make this assumption, we save roughly an
    order of magnitude in runtime.

    1. `xc.distance(yc, space="oklch")`: 500k evals takes ~2s
    2. This method: 500k evals takes ~0.2s
    """

    l1, c1, h1 = xc.coords()
    l2, c2, h2 = yc.coords()

    rad1 = h1 / 180 * math.pi
    rad2 = h2 / 180 * math.pi
    x1, y1 = c1 * math.cos(rad1), c1 * math.sin(rad1)
    x2, y2 = c2 * math.cos(rad2), c2 * math.sin(rad2)
    
    dx = x1 - x2
    dy = y1 - y2
    dz = l1 - l2
    
    return (dx**2 + dy**2 + dz**2)**0.5
