*Note*: this document was written prior to `v1.0.0` and may not longer be an
accurate depiction of the `monobiome` internals.

# Theme constraints
The following general constraints are followed as palette options are mapped
onto concrete themes:

+ Harshness levels have monotone differences of a single shade. 
+ "Hard" themes anchor their background to the most extreme shade appropriate
  for the scheme (i.e., lightest shade for "light," darkest shade for "dark"),
  ensuring the palette's "monotone width" is fully spanned by the theme
  options.
+ App-specific monotone settings have differences of a single shade compared to
  the system monotone settings.
+ Shade differences between corresponding background/foreground settings should
  be constant (e.g., between `bg0` and `fg3`, `bg1` and `fg2`, etc)

The primary goal of these constraints is to ensure each theme in a collection
defined around a single palette is 1) sufficiently _distinct_, 2) attains
sufficient _breadth_ under the palette, and 3) upholds _relative invariance_
under key properties (e.g., lightness differences).

![How themes are created](images/theme_creation.png)

## Example
The following is a natural solution to these constraints, demonstrated on a
general example setting: a possible useful analogy is a sliding window that, on
its own spans a given theme's `bg0-fg0` settings, while globally sliding across
all available values in the palette. If associating integers `0-10` to indices
in a list of monotone shades, and `bg-fg` is the syntax used to indicate that
theme's shade range, we might have the following for dark mode themes across
harshness levels:

```
Dark (system) 0-7 ; 1-8 ; 2-9
Dark (app)    1-8 ; 2-9 ; 3-10
```

There are sliding windows at both the system-app level *and* the
harshness-level, in a sense. Constraints are followed:

+ Harshness levels, separated by semicolon, differ by a single shade from hard
  to soft.
+ The hard theme anchors its background to the darkest available shade.
+ Monotones between system and app differ by a single shade.
+ Differences between bg/fg (value of 7) remains constant across all themes.

Mapping this onto the common values used in my theme definition files: 

```
System, dark
| Hard       | Regular    | Soft
| bg0 <- l15 | bg0 <- l20 | bg0 <- l25
| fg0 <- l80 | fg0 <- l85 | fg0 <- l90

App, dark
| Hard       | Regular    | Soft
| bg0 <- l20 | bg0 <- l25 | bg0 <- l30
| fg0 <- l85 | fg0 <- l90 | fg0 <- l95

System, light
| Hard       | Regular    | Soft
| bg0 <- l95 | bg0 <- l90 | bg0 <- l85
| fg0 <- l30 | fg0 <- l25 | fg0 <- l20

App, light
| Hard       | Regular    | Soft
| bg0 <- l90 | bg0 <- l85 | bg0 <- l80
| fg0 <- l25 | fg0 <- l20 | fg0 <- l15
```

# Accent contrast
Each group of biome monotones have nearly identical (WCAG 2) contrast ratios
against white/black for all lightness levels (ratios identical between biomes).
These are selected in a heavily constrained OKLCH context, and given the
perceptual uniformity attached to lightness, we can expect very similar
contrast ratios for each accent under a given biome lightness (e.g., the `l65`
red tone will have the same ratio under the grassland, tundra, and savanna
monotones).

In terms of selecting accents for themes (by harshness and scheme), what
matters is at what lightness level all accent colors meet/exceed a particular
contrast threshold. Again, the ratios themselves are effectively constant
across biome monotones, and thus dependent entirely on the monotone lightness
being used. This of course is determined primarily by whether the theme is a
light or dark one, and what level of harshness is being used. The following are
the relevant values for making a decision. We want to ensure all accents can
reach >4.5 WCAG 2 contrast ratio (the standard requirement for small text on
the web) against all biome monotones for each theme:

+ For BG l20 (harsh, dark) -> l65 is min lightness where all accents have CR
  ≥4.5
+ For BG l25 (regular, dark) -> l65 is min lightness where all accents have CR
  ≥4.5
+ For BG l30 (soft, dark) -> l70 is min lightness where all accents have CR
  ≥4.5

+ For BG l90 (harsh, dark) -> l45 is max lightness where all accents have CR
  ≥4.5
+ For BG l85 (regular, dark) -> l45 is min lightness where all accents have CR
  ≥4.5
+ For BG l80 (soft, dark) -> l40 is min lightness where all accents have CR
  ≥4.5

For the monotone boundaries (l15 and l95, neither of which are possible
backgrounds for terminal or nvim in the current theme definitions), the
relevant lightness levels are l60 and l50, respectively.

While not necessary, it feels intuitive for us to shift the accent colors
up/down by the relative change in monotones across harshness levels. This has
led to the choice of l60 accents for the harsh-dark theme, l65 for
regular-dark, and l70 for soft-dark. This technically breaks the 4.5 ratio
requirement, though, for the harsh theme, so you ultimately need to pick one:
either soften the contrast constraint, or allow different harshness levels to
use the same accent lightness. I think either is acceptable, but for now I've
gone with the former, loosening the contrast to a ratio of >4.0 with respect to
the background. This allows for the slightly tighter group of accent
lightnesses: l45-l50-l55 for light, l60-l65-l70 for dark. Note that the "center
shade" of the l15-l95 shade group is l55, meaning these groups are very central
(the light triplet could move down by one shade step, but we want these accents
to be as bright as we can get away with; otherwise, they are extremely dull in
the light modes, and we thus don't mind bias toward a brighter lightness).

The following table shows the lightness thresholds of accent colors required to
achieve various contrast ratios under different lightness levels of monotone
backgrounds. These ratios correspond to WCAG 2.2 standards:

- WCAG AA: contrast ratio ≥3:1 for large text, ≥4.5:1 for normal text
- WCAG AAA: contrast ratio ≥4.5:1 for large text, ≥7:1 for normal text

The official theme variants treat WCAG AA for normal text as the sweet spot,
but one could redefine accent selection around a more extreme contrast
threshold as desired.

<table>
  <tr>
    <th rowspan="2">Monotone<br>lightness</th>
    <th colspan="3">Accent lightness for contrast ratio</th>
  </tr>
  <tr>
    <th>3:1</th>
    <th>4.5:1</th>
    <th>7:1</th>
  </tr>
  <tr>
    <td>=15%</td>
    <td>≥50%</td>
    <td>≥60%</td>
    <td>≥75%</td>
  </tr>
  <tr>
    <td>=20%</td>
    <td>≥55%</td>
    <td>≥65%</td>
    <td>≥75%</td>
  </tr>
  <tr>
    <td>=25%</td>
    <td>≥55%</td>
    <td>≥65%</td>
    <td>≥80%</td>
  </tr>
  <tr>
    <td>=30%</td>
    <td>≥60%</td>
    <td>≥70%</td>
    <td>≥80%</td>
  </tr>

  <tr>
    <td>=80%</td>
    <td>≤50%</td>
    <td>≤40%</td>
    <td>≤30%</td>
  </tr>
  <tr>
    <td>=85%</td>
    <td>≤50%</td>
    <td>≤45%</td>
    <td>≤30%</td>
  </tr>
  <tr>
    <td>=90%</td>
    <td>≤55%</td>
    <td>≤45%</td>
    <td>≤35%</td>
  </tr>
  <tr>
    <td>=95%</td>
    <td>≤60%</td>
    <td>≤50%</td>
    <td>≤40%</td>
  </tr>
</table>

