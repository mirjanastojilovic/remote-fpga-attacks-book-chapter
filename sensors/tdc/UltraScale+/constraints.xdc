# Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
# Copyright 2023, School of Computer and Communication Sciences, EPFL.
#
# All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE.md file.
#
# This file contains the placement and timing constraints for the TDC sensor on AMD UltraScale+ devices.
# In this example, the sensor is used on an Alveo U200 board, and placed with the origin at X=86, Y=780.
# hierachical/path/to/sensor/TDC_sensor should be replaced with the actual hierarchical path.

# Placement constraints
create_pblock sensor_0
resize_pblock sensor_0 -add {SLICE_X86Y780:SLICE_X86Y815}
add_cells_to_pblock sensor_0 [get_cells [list hierachical/path/to/sensor/TDC_sensor]] -clear_locs
set_property LOC SLICE_X86Y780 [get_cells [list hierachical/path/to/sensor/TDC_sensor/coarse_init]]
set_property DONT_TOUCH true [get_cells [list hierachical/path/to/sensor/TDC_sensor/*]]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks sensor_0]

# Timing constraint
set_false_path -from [get_clocks *] -to [get_pins {hierachical/path/to/sensor/TDC_sensor/sensor_o_regs[*].obs_regs/D}]
