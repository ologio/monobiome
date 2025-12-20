import numpy as np
import matplotlib.pyplot as plt
from coloraide import Color

from monobiome.palette import compute_hlc_map
from monobiome.constants import (
    h_map,
    L_space,
    L_points,
    accent_h_map,
    monotone_h_map,
    Lspace_Cmax_Hmap,
    Lpoints_Cstar_Hmap,
)


def plot_hue_chroma_bounds() -> None:
    name_h_map = {}
    ax_h_map = {}
    fig, axes = plt.subplots(
        len(monotone_h_map),
        1,
        sharex=True,
        sharey=True,
        figsize=(4, 10)
    )

    for i, h_str in enumerate(Lpoints_Cstar_Hmap):
        _h = h_map[h_str]

        l_space_Cmax = Lspace_Cmax_Hmap[h_str]
        l_points_Cstar = Lpoints_Cstar_Hmap[h_str]
        
        if _h not in ax_h_map:
            ax_h_map[_h] = axes[i]
        ax = ax_h_map[_h]
        
        if _h not in name_h_map:
            name_h_map[_h] = []
        name_h_map[_h].append(h_str)

        # plot Cmax and Cstar
        ax.plot(L_space, l_space_Cmax, c="g", alpha=0.3, label="Cmax")
        
        cstar_label = f"{'accent' if h_str in accent_h_map else 'monotone'} C*"
        ax.plot(L_points, l_points_Cstar, alpha=0.7, label=cstar_label)
        
        ax.title.set_text(f"Hue [${_h}$] - {'|'.join(name_h_map[_h])}")
        
    axes[-1].set_xlabel("Lightness (%)")
    axes[-1].set_xticks([L_points[0], L_points[-1]])

    fig.tight_layout()
    fig.subplots_adjust(top=0.9)

    handles, labels = axes[-1].get_legend_handles_labels()
    unique = dict(zip(labels, handles, strict=True))
    fig.legend(
        unique.values(),
        unique.keys(),
        loc='lower center',
        bbox_to_anchor=(0.5, -0.06),
        ncol=3
    )

    plt.suptitle("$C^*$ curves for hue groups")
    plt.show()


def plot_hue_chroma_star() -> None:
    fig, ax = plt.subplots(1, 1, figsize=(8, 6))

    # uncomment to preview 5 core term colors
    colors = accent_h_map.keys()
    #colors = set(["red", "orange", "yellow", "green", "blue"])

    for h_str in Lpoints_Cstar_Hmap:
        if h_str not in accent_h_map or h_str not in colors:
            continue
        ax.fill_between(
            L_points,
            Lpoints_Cstar_Hmap[h_str],
            alpha=0.2,
            color='grey',
            label=h_str
        )

        x, y = L_points, Lpoints_Cstar_Hmap[h_str]
        n = int(0.45*len(x))
        ax.text(x[n], y[n]-0.01, h_str, rotation=10, va='center', ha='left')
        
    ax.set_xlabel("Lightness (%)")
    ax.set_xticks([L_points[0], 45, 50, 55, 60, 65, 70, L_points[-1]])
    plt.suptitle("$C^*$ curves (v1.4.0)")
    fig.show()


def palette_image(
    palette: dict[str, dict[int, str]],
    cell_size: int = 40,
    keys: list[str] | None = None
) -> tuple[np.ndarray, list[str], list[list[int]], int, int]:
    names = list(palette.keys()) if keys is None else keys
        
    row_count = len(names)
    col_counts = [len(palette[n]) for n in names]
    max_cols = max(col_counts)

    h = row_count * cell_size
    w = max_cols * cell_size
    img = np.ones((h, w, 3), float)

    lightness_keys_per_row = []

    for r, name in enumerate(names):
        shades = palette[name]
        lkeys = sorted(shades.keys())
        lightness_keys_per_row.append(lkeys)
        for c, k in enumerate(lkeys):
            col = Color(shades[k]).convert("srgb").fit(method="clip")
            rgb = [col["r"], col["g"], col["b"]]
            r0, r1 = r * cell_size, (r + 1) * cell_size
            c0, c1 = c * cell_size, (c + 1) * cell_size
            img[r0:r1, c0:c1, :] = rgb

    return img, names, lightness_keys_per_row, cell_size, max_cols


def show_palette(
    palette: dict[str, dict[int, str]],
    cell_size: int = 40,
    keys: list[str] | None = None,
    show_labels: bool = True,
    dpi: int = 100,
) -> tuple[plt.Figure, plt.Axes]:
    img, names, keys, cell_size, max_cols = palette_image(
        palette, cell_size, keys=keys
    )

    fig_w = img.shape[1] / 100
    fig_h = img.shape[0] / 100

    if show_labels:
        fig, ax = plt.subplots(figsize=(fig_w, fig_h), dpi=dpi)

        ax.imshow(img, interpolation="none", origin="upper")
        ax.set_xticks([])

        ytick_pos = [(i + 0.5) * cell_size for i in range(len(names))]
        ax.set_yticks(ytick_pos)
        ax.set_yticklabels(names)
        ax.set_ylim(img.shape[0], 0)  # ensures rows render w/o half-cells

        return fig, ax

    fig = plt.figure(figsize=(fig_w, fig_h), dpi=dpi, frameon=False)
    ax = fig.add_axes((0, 0, 1, 1), frame_on=False)
    ax.imshow(
        img,
        interpolation="nearest",
        origin="upper",
        extent=(0, img.shape[1], img.shape[0], 0),
        aspect="auto",
    )
    ax.set_xlim(0, img.shape[1])
    ax.set_ylim(img.shape[0], 0)
    ax.axis("off")
    fig.subplots_adjust(0, 0, 1, 1, hspace=0, wspace=0)

    return fig, ax

if __name__ == "__main__":
    keys = [
        "alpine",
        "badlands",
        "chaparral",
        "savanna",
        "grassland",
        "reef",
        "tundra",
        "heathland",
        "moorland",
        "orange",
        "yellow",
        "green",
        "cyan",
        "blue",
        "violet",
        "magenta",
        "red",
    ]
    term_keys = [
        "alpine",
        "badlands",
        "chaparral",
        "savanna",
        "grassland",
        "tundra",
        "red",
        "orange",
        "yellow",
        "green",
        "blue",
    ]

    hlc_map = compute_hlc_map("oklch")
    show_palette(hlc_map, cell_size=25, keys=keys)
    # show_palette(hlc_map, cell_size=1, keys=term_keys)
