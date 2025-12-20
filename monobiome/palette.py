import json
from typing import Any
from functools import cache
from importlib.metadata import version

from coloraide import Color

from monobiome.constants import (
    h_map,
    L_points,
    Lpoints_Cstar_Hmap,
)


@cache
def compute_hlc_map(notation: str) -> dict[str, Any]:
    hlc_map = {}

    for h_str, Lpoints_Cstar in Lpoints_Cstar_Hmap.items():
        _h = h_map[h_str]
        hlc_map[h_str] = {}
        
        for _l, _c in zip(L_points, Lpoints_Cstar, strict=True):
            oklch = Color('oklch', [_l/100, _c, _h])

            if notation == "hex":
                srgb = oklch.convert('srgb')
                c_str = srgb.to_string(hex=True)
            elif notation == "oklch":
                ol, oc, oh = oklch.convert('oklch').coords()
                c_str = f"oklch({ol*100:.1f}% {oc:.4f} {oh:.1f})"
            
            hlc_map[h_str][_l] = c_str

    return hlc_map

def generate_palette(
    notation: str,
    file_format: str,
) -> str:
    mb_version = version("monobiome")
    hlc_map = compute_hlc_map(notation)
            
    if file_format == "json":
        hlc_map["version"] = mb_version
        return json.dumps(hlc_map, indent=4)
    else:
        toml_lines = [f"version = \"{mb_version}\"", ""]
        for _h, _lc_map in hlc_map.items():
            toml_lines.append(f"[{_h}]")
            for _l, _c in _lc_map.items():
                toml_lines.append(f'l{_l} = "{_c}"')
            toml_lines.append("")

        return "\n".join(toml_lines)
