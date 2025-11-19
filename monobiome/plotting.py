import matplotlib.pyplot as plt
from scipy.interpolate import interp1d, CubicSpline, BSpline

from monobiome.constants import (
    L_points,
    L_space,
    h_weights,
    monotone_h_map,
    accent_h_map,
    h_map,
)
from monobiome.curves import (
    h_L_points_Cstar,
    h_Lspace_Cmax,
)

ax_h_map = {}
fig, axes = plt.subplots(
    len(monotone_h_map),
    1,
    sharex=True,
    sharey=True,
    figsize=(4, 8)
)

for i, h_str in enumerate(h_L_points_Cstar):
    _h = h_map[h_str]
    L_points_Cstar = h_L_points_Cstar[h_str]
    L_space_Cmax = h_Lspace_Cmax[h_str]
    
    if _h not in ax_h_map:
        ax_h_map[_h] = axes[i]
    ax = ax_h_map[_h]

    # plot Cmax and Cstar
    ax.plot(L_space, L_space_Cmax, c="b", alpha=0.2)
    ax.plot(L_points, L_points_Cstar, alpha=0.7)
    
    ax.title.set_text(f"Hue [${_h}$]")
    
axes[-1].set_xlabel("Lightness (%)")
axes[-1].set_xticks([L_points[0], L_points[-1]])

fig.tight_layout()
fig.subplots_adjust(top=0.9)

plt.suptitle("$C^*$ curves for hue groups")
plt.show()



ax_h_map = {}
fig, axes = plt.subplots(
    len(monotone_h_map),
    1,
    sharex=True,
    sharey=True,
    figsize=(5, 10)
)

for i, h_str in enumerate(h_L_points_Cstar):
    _h = h_map[h_str]
    L_points_Cstar = h_L_points_Cstar[h_str]
    L_space_Cmax = h_Lspace_Cmax[h_str]
    
    if _h not in ax_h_map:
        ax_h_map[_h] = axes[i]
    ax = ax_h_map[_h]

    # plot Cmax and Cstar
    ax.plot(L_space, L_space_Cmax, c="b", alpha=0.2, label='Cmax')
    ax.plot(L_points, L_points_Cstar, alpha=0.7, label='C*')

    if h_str in v111_hC_points:
        ax.scatter(v111_L_space, v111_hC_points[h_str], s=4, label='Cv111')
        
    if h_str in h_ctrl_L_C:
        cpts = h_ctrl_L_C[h_str]
        cpt_x, cpt_y = cpts[:, 0], cpts[:, 1]
        h_w = h_weights.get(h_str, 1)
        
        P0, P1, P2 = cpts[0], cpts[1], cpts[2]
        d0 = 2 * h_w * (P1 - P0)
        d2 = 2 * h_w * (P2 - P1)

        handle_scale = 0.25
        H0 = P0 + handle_scale * d0
        H2 = P2 - handle_scale * d2
    
        # ax.plot([P0[0], H0[0]], [P0[1], H0[1]], color='tab:blue', lw=1)
        # ax.plot([P2[0], H2[0]], [P2[1], H2[1]], color='tab:orange', lw=1)
        
        ax.plot(cpt_x, cpt_y, '--', color='gray', lw=1, label='Bezier polygon')
        ax.scatter(cpt_x, cpt_y, color='red', zorder=5, s=2, label='Control points')
        
    ax.title.set_text(f"Hue [${_h}$]")
    
axes[-1].set_ylabel("Chroma (C)")
axes[-1].set_xlabel("Lightness (%)")
axes[-1].set_xticks([L_points[0], 50, 65, L_points[-1]])

fig.tight_layout()
fig.subplots_adjust(top=0.9)

handles, labels = axes[-1].get_legend_handles_labels()
unique = dict(zip(labels, handles))
fig.legend(unique.values(), unique.keys(), loc='lower center', bbox_to_anchor=(0.5, -0.06), ncol=3)

plt.suptitle("$C^*$ curves for hue groups + v111 5% lightness")
plt.show()




from numpy import arctan2, degrees

fig, ax = plt.subplots(1, 1, figsize=(8, 6))

for h_str in h_L_points_Cstar:
    if h_str not in accent_h_map:
        continue
    ax.fill_between(L_points, h_L_points_Cstar[h_str], alpha=0.2, color='grey', label=h_str)

    x, y = L_points, h_L_points_Cstar[h_str]
    n = int(0.5*len(x))
    ax.text(x[n], y[n]-0.01, h_str, rotation=10, va='center', ha='left')
    
ax.set_xlabel("Lightness (%)")
ax.set_xticks([L_points[0], 45, 50, 55, 60, 65, 70, L_points[-1]])
plt.suptitle("$C^*$ curves (v1.3.0)")
fig.show()
