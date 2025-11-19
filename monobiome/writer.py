
# put together objects for output formats
toml_lines = []
oklch_hL_dict = {}

for h_str, L_points_Cstar in h_L_points_Cstar.items():
    _h = h_map[h_str]
    toml_lines.append(f"[{h_str}]")
    oklch_hL_dict[h_str] = {}
    
    for _L, _C in zip(L_points, L_points_Cstar):
        oklch = Color('oklch', [_L/100, _C, _h])
        srgb = oklch.convert('srgb')
        
        hex_str = srgb.to_string(hex=True)
        
        l, c, h = oklch.convert('oklch').coords()
        # oklch_str = oklch.to_string(percent=False)
        oklch_str = f"oklch({l*100:.1f}% {c:.4f} {h:.1f})"
        
        toml_lines.append(f'l{_L} = "{hex_str}"')
        oklch_hL_dict[h_str][_L] = oklch_str
        
    toml_lines.append("")



# write files -- QBR = "quadratic bezier rational"
PALETTE_DIR = "palettes"

toml_content = '\n'.join(toml_lines)
with Path(PALETTE_DIR, 'monobiome-vQBRsn-130.toml').open('w') as f:
    f.write(toml_content)
print("[TOML] written")
    
with Path(PALETTE_DIR, 'monobiome-vQBRsn-130-oklch.json').open('w') as f:
    json.dump(oklch_hL_dict, f)
print("[JSON] written")

