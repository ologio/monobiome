from types import GenericAlias
from argparse import ArgumentParser, _SubParsersAction

from coloraide import Color

_SubParsersAction.__class_getitem__ = classmethod(GenericAlias)
_SubparserType = _SubParsersAction[ArgumentParser]

def oklch_distance(mc: Color, ac: Color) -> float:
    return mc.distance(ac, space="oklch")
