def compute_dma_map(dT, metric=None):
    """
    For threshold `dT`, compute the nearest accent shades
    that exceed that threshold for every monotone shade.

    Returns:

    Map like
    { "alpine": {
        "oklch( ... )": {
            "red": *nearest oklch >= dT from M base*
    """

    if metric is None:
        metric = lambda mc,ac: mc.distance(ac, space="oklch")
    
    oklch_color_map = {
        c_name: [Color(c_str) for c_str in c_str_dict.values()]
        for c_name, c_str_dict in oklch_hL_dict.items()
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
                    lambda d: (d[1] - dT) > 0,
                    [
                        (ac, metric(m_color, ac))
                        for ac in a_colors
                    ]
                )
                oklch_dists = list(oklch_dists)
                if oklch_dists:
                    min_a_color = min(oklch_dists, key=lambda t: t[1])[0]
                    acol_min_map[a_name] = min_a_color
    
            # make sure the current monotone level has *all* accents; o/w ignore
            if len(acol_min_map) < len(accent_h_map):
                continue

            mL = m_color.coords()[0]
            mL_acol_map[int(mL*100)] = acol_min_map
        dT_mL_acol_map[m_name] = mL_acol_map
    return dT_mL_acol_map



    


mode = "dark"  # ["dark", "light"]
biome = "alpine"  # [ ... ]
metric = "wcag"  # ["wcag", "oklch"]
metric_map = {
    "wcag": lambda mc,ac: ac.contrast(mc, method='wcag21'),
    "oklch": lambda mc,ac: mc.distance(ac, space="oklch"),
}
metric_func = metric_map[metric]

term_color_map = {
    "red": "red",
    "organge": "orange",
    "yellow": "yellow",
    "green": "green",
    "cyan": "green",
    "blue": "blue",
    "violet": "blue",
    "magenta": "red",
}

L = 20
d = 4.5
I = 5
fg_gap = 50
grey_gap = 30

dT_mL_acol_map = compute_dma_map(d, metric=metric_func)
Lma_map = {
    m_name: mL_acol_dict[L]
    for m_name, mL_acol_dict in dT_mL_acol_map.items()
    if L in mL_acol_dict
}

# the `mL_acol_dict` only includes lightnesses where all accent
# colors were within threshold. Coverage here will be partial if,
# at the `mL`, there is some monotone base that doesn't have all
# accents within threshold. This can happen at the edge, e.g., alpine@L15
# has all accents w/in the distance, but the red accent was too far under
# tundra@L15, so there's no entry. This particular case is fairly rare; it's
# more likely that *all* monotones are undefined. Either way, both such
# cases lead to partial scheme coverage.
if len(Lma_map) < len(monotone_h_map):
    print(f"Warning: partial scheme coverage for {mL=}@{dT=}")
if biome not in Lma_map:
    print(f"Biome {biome} unable to meet {metric} constraints")
accent_colors = Lma_map.get(biome, {})

scheme_pairs = []
for i in range(4):
    scheme_pairs.append(
        (
            f"bg{i}",
            f"f{{{{{biome}.l{L+i*I}}}}}"
        )
    )
for i in range(4):
    scheme_pairs.append(
        (
            f"fg{3-i}",
            f"f{{{{{biome}.l{fg_gap+L+i*I}}}}}"
        )
    )
for term_color, mb_accent in term_color_map.items():
    aL = int(100*accent_colors[mb_accent].coords()[0])
    scheme_pairs.append(
        (
            f"{term_color}",
            f"f{{{{{mb_accent}.l{aL}}}}}"
        )
    )

term_fg_gap = 60
scheme_pairs.extend([
    ("background", f"f{{{{{biome}.l{L}}}}}"),
    ("selection_bg", f"f{{{{{biome}.l{L+I}}}}}"),
    ("selection_fg", f"f{{{{{biome}.l{L+term_fg_gap}}}}}"),
    ("foreground", f"f{{{{{biome}.l{L+term_fg_gap+I}}}}}"),
])

scheme_toml = [
    f"{lhs:<12} = {rhs:<16}"
    for lhs, rhs in scheme_pairs
] 
