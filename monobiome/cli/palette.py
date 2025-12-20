from pathlib import Path
from argparse import Namespace, ArgumentParser

from monobiome.util import _SubparserType
from monobiome.palette import generate_palette


def register_parser(subparsers: _SubparserType) -> None:
    parser = subparsers.add_parser(
        "palette",
        help="generate primary palette"
    )

    parser.add_argument(
        "-n",
        "--notation",
        type=str,
        default="hex",
        choices=["hex", "oklch"],
        help="Color notation to export (either hex or oklch)",
    )
    parser.add_argument(
        "-f",
        "--format",
        type=str,
        default="toml",
        choices=["json", "toml"],
        help="Format of palette file (either JSON or TOML)",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        help="Output file to write palette content",
    )

    parser.set_defaults(func=handle_palette)


def handle_palette(args: Namespace, parser: ArgumentParser) -> None:
    notation = args.notation
    file_format = args.format
    output = args.output

    palette_text = generate_palette(notation, file_format)

    if output is None:
        print(palette_text)
    else:
        with Path(output).open("w") as f:
            f.write(palette_text)
