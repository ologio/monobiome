import numpy as np

# SET LIGHTNESS CONTROL POINTS
# L_points = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 98]
L_points = list(range(10, 98+1))

# FIXED MONOBIOME PARAMETERS
L_resolution = 5  # step size along lightness dim
L_space = np.arange(0, 100+L_resolution, L_resolution)

monotone_C_map = {
    "alpine": 0,
    "badlands": 0.011,
    "chaparral": 0.011,
    "savanna": 0.011,
    "grassland": 0.011,
    "tundra": 0.011,
}

h_weights = {
    "red": 3.0,
    "orange": 3.8,  # 3.6
    "yellow": 3.8,  # 4.0
    "green": 3.8,
    "blue": 3.4,  # 3.8
}
h_L_offsets = {
    "red": 0,  # -1,
    "orange": -5.5,  # -3,
    "yellow": -13.5,  # -8
    "green": -11,  # -8
    "blue": 10,  # 14
}
h_C_offsets = {
    "red": 0,  # 0
    "orange": -0.01,  # -0.02
    "yellow": -0.052,  # -0.08
    "green": -0.088,  # -0.105
    "blue": 0.0,  # 0.01
}

monotone_h_map = {
    "alpine": 0,
    "badlands": 29,
    "chaparral": 62.5,
    "savanna": 104,
    "grassland": 148,
    "tundra": 262,
}
accent_h_map = {
    "red": 29,
    "orange": 62.5,
    "yellow": 104,
    "green": 148,
    "blue": 262,
}
h_map = {**monotone_h_map, **accent_h_map}


v111_L_space = list(range(15, 95+1, 5))
v111_hC_points = {
    "red": [
        0.058,
        0.074,
        0.092,
        0.11,
        0.128,
        0.147,
        0.167,
        0.183,
        0.193,
        0.193,
        0.182,
        0.164,
        0.14,
        0.112,
        0.081,
        0.052,
        0.024,
    ],
    "orange": [
        0.030,
        0.038,
        0.046,
        0.058,
        0.07,
        0.084,
        0.1,
        0.114,
        0.125,
        0.134,
        0.138,
        0.136,
        0.128,
        0.112,
        0.092,
        0.064,
        0.032,
    ],
    "yellow": [
        0.02,
        0.024,
        0.03,
        0.036,
        0.044,
        0.05,
        0.06,
        0.068,
        0.076,
        0.082,
        0.088,
        0.088,
        0.086,
        0.082,
        0.072,
        0.058,
        0.04,
    ],
    "green": [
        0.0401,
        0.048,
        0.056,
        0.064,
        0.072,
        0.08,
        0.09,
        0.098,
        0.104,
        0.108,
        0.11,
        0.108,
        0.102,
        0.094,
        0.084,
        0.072,
        0.05,
    ],
    "blue": [
        0.06,
        0.072,
        0.084,
        0.096,
        0.106,
        0.116,
        0.124,
        0.13,
        0.132,
        0.128,
        0.122,
        0.11,
        0.096,
        0.08,
        0.064,
        0.044,
        0.023,
    ],
}
