import sys
import tomllib
from pathlib import Path
from argparse import Namespace, ArgumentParser

from symconf.template import Template, TOMLTemplate

from monobiome.util import _SubparserType
from monobiome.palette import generate_palette


def register_parser(subparsers: _SubparserType) -> None:
    parser = subparsers.add_parser(
        "fill",
        help="fill scheme templates for applications"
    )

    parser.add_argument(
        "scheme",
        type=str,
        help="scheme file path"
    )
    parser.add_argument(
        "template",
        nargs="?",
        help="template file path (defaults to stdin)"
    )
    parser.add_argument(
        "-p",
        "--palette",
        type=str,
        help="palette file to use for color definitions",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        help="output file to write filled template",
    )

    parser.set_defaults(func=handle_fill)


def handle_fill(args: Namespace, parser: ArgumentParser) -> None:
    scheme = Path(args.scheme)
    output = args.output

    if args.template is None:
        if sys.stdin.isatty():
            parser.error("no template provided (file or stdin)")
            return
        template_content = sys.stdin.read()
    elif args.template == "-":
        template_content = sys.stdin.read()
    else:
        try:
            template_content = Path(args.template).read_text()
        except OSError as e:
            parser.error(f"cannot read template file: {e}")

    if args.palette:
        try:
            palette_toml = Path(args.palette).read_text()
        except OSError as e:
            parser.error(f"cannot read palette file: {e}")
            return
    else:
        palette_toml = generate_palette("hex", "toml")

    palette_dict = tomllib.loads(palette_toml)
    concrete_scheme = TOMLTemplate(scheme).fill_dict(palette_dict)
    filled_template = Template(template_content).fill(concrete_scheme)

    if output is None:
        print(filled_template)
    else:
        with Path(output).open("w") as f:
            f.write(filled_template)
