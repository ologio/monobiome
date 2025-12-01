import argparse

def generate_scheme(args: argparse.Namespace) -> None:
    run_from_json(args.parameters_json, args.parameters_file)


def register_parser(subparsers: _SubparserType) -> None:
    parser = subparsers.add_parser(
        "generate",
        help="generate theme variants"
    )

    parser.add_argument(
        "-m",
        "--contrast-method",
        type=str,
        help="Raw JSON string with train parameters",
    )
    parser.add_argument(
        "-c",
        "--contrast-level",
        type=str,
        help="Raw JSON string with train parameters",
    )
    parser.add_argument(
        "-b",
        "-base-lightness",
        type=str,
        help="Minimum lightness level",
    )
    parser.set_defaults(func=generate_scheme)
