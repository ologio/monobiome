from functools import cache
from collections.abc import Callable
from importlib.metadata import version

from coloraide import Color

from monobiome.util import oklch_distance
from monobiome.palette import compute_hlc_map
from monobiome.constants import (
    accent_h_map,
    monotone_h_map,
)


@cache
def compute_dma_map(
    dT: float,
    metric: Callable | None = None
) -> dict[str, dict]:
    """
    For threshold `dT`, compute the nearest accent shades that exceed that
    threshold for every monotone shade.

    Returns: map of minimum constraint satisfying accent colors for monotone
        spectra

        {
            "alpine": {
                "oklch( ... )": {
                    "red": *nearest oklch >= dT from M base*,
                    ...
                },
                ...
            },
            ...
        }
    """

    if metric is None:
        metric = oklch_distance
    
    oklch_hlc_map = compute_hlc_map("oklch")
    oklch_color_map = {
        c_name: [Color(c_str) for c_str in c_str_dict.values()]
        for c_name, c_str_dict in oklch_hlc_map.items()
    }
    
    dT_mL_acol_map = {}
    for m_name in monotone_h_map:
        mL_acol_map = {}
        m_colors = oklch_color_map[m_name]
        
        for m_color in m_colors:
            acol_min_map = {}
            
            for a_name in accent_h_map:
                a_colors = oklch_color_map[a_name]
                oklch_dists = filter(
                    lambda d: (d[1] - dT) >= 0,
                    [
                        (ac, metric(m_color, ac))
                        for ac in a_colors
                    ]
                )
                oklch_dists = list(oklch_dists)
                if oklch_dists:
                    min_a_color = min(oklch_dists, key=lambda t: t[1])[0]
                    acol_min_map[a_name] = min_a_color
    
            # make sure the current monotone level has *all* accents; o/w
            # ignore
            if len(acol_min_map) < len(accent_h_map):
                continue

            mL = m_color.coords()[0]
            mL_acol_map[int(mL*100)] = acol_min_map
        dT_mL_acol_map[m_name] = mL_acol_map

    return dT_mL_acol_map

def generate_scheme_groups(
    mode: str,
    biome: str,
    metric: str,
    distance: float,
    l_base: int,
    l_step: int,
    fg_gap: int,
    grey_gap: int,
    term_fg_gap: int,
    accent_color_map: dict[str, str],
) -> tuple[list[tuple[str, str]], ...]:
    """
    Parameters:
        mode: one of ["dark", "light"]
        biome: biome setting
        metric: one of ["wcag", "oklch", "lightness"]
    """

    metric_map = {
        "wcag": lambda mc,ac: ac.contrast(mc, method='wcag21'),
        "oklch": oklch_distance,
        "lightness": lambda mc,ac: abs(mc.coords()[0]-ac.coords()[0])*100,
    }
    
    metric_func = metric_map[metric]
    dT_mL_acol_map = compute_dma_map(distance, metric=metric_func)
    Lma_map = {
        m_name: mL_acol_dict[l_base]
        for m_name, mL_acol_dict in dT_mL_acol_map.items()
        if l_base in mL_acol_dict
    }
    
    # the `mL_acol_dict` only includes lightnesses where all accent colors were
    # within threshold. Coverage here will be partial if, at the `mL`, there is
    # some monotone base that doesn't have all accents within threshold. This
    # can happen at the edge, e.g., alpine@L15 has all accents w/in the
    # distance, but the red accent was too far under tundra@L15, so there's no
    # entry. This particular case is fairly rare; it's more likely that *all*
    # monotones are undefined. Either way, both such cases lead to partial
    # scheme coverage.
    if len(Lma_map) < len(monotone_h_map):
        print(f"Warning: partial scheme coverage for {l_base=}@{distance=}")
    if biome not in Lma_map:
        print(f"Biome {biome} unable to meet {metric} constraints")
    accent_colors = Lma_map.get(biome, {})
    
    meta_pairs = [
        ("version", version("monobiome")),
        ("mode", mode),
        ("biome", biome),
        ("metric", metric),
        ("distance", str(distance)),
        ("l_base", str(l_base)),
        ("l_step", str(l_step)),
        ("fg_gap", str(fg_gap)),
        ("grey_gap", str(grey_gap)),
        ("term_fg_gap", str(term_fg_gap)),
    ]

    # note how selection_bg steps up by `l_step`, selection_fg steps down by
    # `l_step` (from their respective bases)
    term_pairs = [
        ("background", f"f{{{{{biome}.l{l_base}}}}}"),
        ("selection_bg", f"f{{{{{biome}.l{l_base+l_step}}}}}"),
        ("selection_fg", f"f{{{{{biome}.l{l_base+term_fg_gap-l_step}}}}}"),
        ("foreground", f"f{{{{{biome}.l{l_base+term_fg_gap}}}}}"),
        ("cursor", f"f{{{{{biome}.l{l_base+term_fg_gap-l_step}}}}}"),
        ("cursor_text", f"f{{{{{biome}.l{l_base+l_step}}}}}"),
    ]

    monotone_pairs = []
    monotone_pairs += [
        (f"bg{i}", f"f{{{{{biome}.l{l_base+i*l_step}}}}}")
        for i in range(4)
    ]
    monotone_pairs += [
        (f"fg{3-i}", f"f{{{{{biome}.l{fg_gap+l_base+i*l_step}}}}}")
        for i in range(4)
    ]
 
    accent_pairs = [
        ("black", f"f{{{{{biome}.l{l_base}}}}}"),
        ("grey", f"f{{{{{biome}.l{l_base+grey_gap}}}}}"),
        ("white", f"f{{{{{biome}.l{l_base+term_fg_gap-2*l_step}}}}}"),
    ]
    for color_name, mb_accent in accent_color_map.items():
        aL = int(100*accent_colors[mb_accent].coords()[0])
        accent_pairs.append(
            (
                color_name,
                f"f{{{{{mb_accent}.l{aL}}}}}"
            )
        )
    
    return meta_pairs, term_pairs, monotone_pairs, accent_pairs

def generate_scheme(
    mode: str,
    biome: str,
    metric: str,
    distance: float,
    l_base: int,
    l_step: int,
    fg_gap: int,
    grey_gap: int,
    term_fg_gap: int,
    full_color_map: dict[str, str],
    term_color_map: dict[str, str],
    vim_color_map: dict[str, str],
) -> str:
    l_sys = l_base
    l_app = l_base + l_step

    term_bright_offset = 10

    # negate gaps if mode is light
    if mode == "light":
        l_step *= -1
        fg_gap *= -1
        grey_gap *= -1
        term_fg_gap *= -1
        term_bright_offset *= -1

    meta, _, mt, ac = generate_scheme_groups(
        mode, biome, metric, distance,
        l_sys, l_step,
        fg_gap, grey_gap, term_fg_gap,
        full_color_map
    )

    _, term, _, term_norm_ac = generate_scheme_groups(
        mode, biome, metric, distance,
        l_app, l_step,
        fg_gap, grey_gap, term_fg_gap,
        term_color_map
    )
    _, _, _, term_bright_ac = generate_scheme_groups(
        mode, biome, metric, distance,
        l_app + term_bright_offset, l_step,
        fg_gap, grey_gap, term_fg_gap,
        term_color_map
    )

    _, _, vim_mt, vim_ac = generate_scheme_groups(
        mode, biome, metric, distance,
        l_app, l_step,
        fg_gap, grey_gap, term_fg_gap,
        vim_color_map
    )

    def pair_strings(pair_list: list[tuple[str, str]]) -> list[str]:
        return [
            f"{lhs:<12} = \"{rhs}\""
            for lhs, rhs in pair_list
        ]

    mb_version = version("monobiome")
    scheme_pairs = [
        "# ++ monobiome scheme file ++",
        f"# ++ generated CLI @ {mb_version} ++",
    ]
    scheme_pairs += pair_strings(meta)
    scheme_pairs += pair_strings(mt)
    scheme_pairs += pair_strings(ac)

    scheme_pairs += ["", "[term]"]
    scheme_pairs += pair_strings(term)

    scheme_pairs += ["", "[term.normal]"]
    scheme_pairs += pair_strings(term_norm_ac)

    scheme_pairs += ["", "[term.bright]"]
    scheme_pairs += pair_strings(term_bright_ac)

    scheme_pairs += ["", "[vim]"]
    scheme_pairs += pair_strings(vim_mt)
    scheme_pairs += pair_strings(vim_ac)

    return "\n".join(scheme_pairs)
