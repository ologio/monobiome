from monobiome.cli import create_parser, configure_logging


def main() -> None:
    parser = create_parser()
    args = parser.parse_args()

    # skim off log level to handle higher-level option
    if hasattr(args, "log_level") and args.log_level is not None:
        configure_logging(args.log_level)

    if "func" in args:
        args.func(args, parser)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
