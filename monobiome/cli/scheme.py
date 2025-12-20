from pathlib import Path
from argparse import Namespace, ArgumentParser

from monobiome.util import _SubparserType
from monobiome.scheme import generate_scheme
from monobiome.constants import monotone_h_map


def register_parser(subparsers: _SubparserType) -> None:
    parser = subparsers.add_parser(
        "scheme",
        help="create scheme variants"
    )

    parser.add_argument(
        "mode",
        type=str,
        choices=["dark", "light"],
        help="Scheme mode (light or dark)"
    )
    parser.add_argument(
        "biome",
        type=str,
        choices=list(monotone_h_map.keys()),
        help="Biome setting for scheme."
    )
    parser.add_argument(
        "-m",
        "--metric",
        type=str,
        default="oklch",
        choices=["wcag", "oklch", "lightness"],
        help="Metric to use for measuring swatch distances."
    )

    # e.g., wcag=4.5; oklch=0.40; lightness=40
    parser.add_argument(
        "-d",
        "--distance",
        type=float,
        default=0.40,
        help="Distance threshold for specified metric",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        help="Output file to write scheme content",
    )

    # these params remain rooted in lightness; no need to accommodate metric
    # given these are monotone adjustments. You *could* consider rooting these
    # in metric units, but along monotones, distance=lightness and WCAG isn't a
    # particularly good measure of perceptual distinction, so we'd prefer the
    # former.
    parser.add_argument(
        "-l",
        "--l-base",
        type=int,
        default=20,
        help="Minimum lightness level (default: 20)",
    )
    parser.add_argument(
        "--l-step",
        type=int,
        default=5,
        help="Lightness step size (default: 5)",
    )

    # gaps
    parser.add_argument(
        "--fg-gap",
        type=int,
        default=50,
        help="Foreground lightness gap (default: 50)",
    )
    parser.add_argument(
        "--grey-gap",
        type=int,
        default=30,
        help="Grey lightness gap (default: 30)",
    )
    parser.add_argument(
        "--term-fg-gap",
        type=int,
        default=65,
        help="Terminal foreground lightness gap (default: 60)",
    )

    parser.set_defaults(func=handle_scheme)


def handle_scheme(args: Namespace, parser: ArgumentParser) -> None:
    output = args.output

    mode = args.mode
    biome =  args.biome
    metric = args.metric
    distance = args.distance
    l_base = args.l_base
    l_step = args.l_step
    fg_gap = args.fg_gap
    grey_gap = args.grey_gap
    term_fg_gap = args.term_fg_gap

    full_color_map = {
        "red": "red",
        "orange": "orange",
        "yellow": "yellow",
        "green": "green",
        "cyan": "cyan",
        "blue": "blue",
        "violet": "violet",
        "magenta": "orange",
    }
    term_color_map = {
        "red": "red",
        "yellow": "yellow",
        "green": "green",
        "cyan": "blue",
        "blue": "blue",
        "magenta": "orange",
    }
    vim_color_map = {
        "red": "red",
        "orange": "orange",
        "yellow": "yellow",
        "green": "green",
        "cyan": "green",
        "blue": "blue",
        "violet": "blue",
        "magenta": "red",
    }
    # vim_color_map = full_color_map

    scheme_text = generate_scheme(
        mode,
        biome,
        metric,
        distance,
        l_base,
        l_step,
        fg_gap,
        grey_gap,
        term_fg_gap,
        full_color_map,
        term_color_map,
        vim_color_map,
    )

    if output is None:
        print(scheme_text)
    else:
        with Path(output).open("w") as f:
            f.write(scheme_text)
