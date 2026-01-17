from pathlib import Path

import monobiome as mb
from monobiome import plotting
from monobiome.palette import compute_hlc_map

figure_dir = Path(f"images/release/{mb.__version__}")
figure_dir.mkdir(parents=True, exist_ok=True)

fig, ax = plotting.plot_hue_chroma_bounds()
fig.savefig(Path(figure_dir, "chroma-bounds.png"))

fig, ax = plotting.plot_hue_chroma_star()
fig.savefig(Path(figure_dir, "chroma-curves.png"))

# compute the palette as hex to ensure the rendering matches; using
# "oklch" causes some slight hex drift when later using an eyedropper
hlc_map = compute_hlc_map("hex") # ("oklch")

fig, ax = plotting.show_palette(hlc_map)
fig.savefig(Path(figure_dir, "palette.png"))

fig, ax = plotting.show_palette(hlc_map, show_labels=False)
fig.savefig(Path(figure_dir, "palette-bare.png"), pad_inches=0)
