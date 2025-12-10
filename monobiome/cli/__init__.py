import logging
import argparse

from monobiome.cli import scheme, palette

logger: logging.Logger = logging.getLogger(__name__)

def configure_logging(log_level: int) -> None:
    """
    Configure logger's logging level.
    """

    logger.setLevel(log_level)

def create_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Accent modeling CLI",
    )
    parser.add_argument(
        "--log-level",
        type=int,
        metavar="int",
        choices=[10, 20, 30, 40, 50],
        help="Log level: 10=DEBUG, 20=INFO, 30=WARNING, 40=ERROR, 50=CRITICAL",
    )

    subparsers = parser.add_subparsers(help="subcommand help")

    palette.register_parser(subparsers)
    scheme.register_parser(subparsers)

    return parser
