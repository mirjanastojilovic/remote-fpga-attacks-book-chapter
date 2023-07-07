# Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
# Copyright 2023, School of Computer and Communication Sciences, EPFL.
#
# All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE.md file.
#
# This file contains the placement and timing constraints for the TDC sensor on AMD 7-Series devices.
# In this example, the sensor is used on a Sakura-X board, and placed with the origin at X=56, Y=200.
# hierachical/path/to/sensor/TDC_sensor should be replaced with the actual hierarchical path.

# Placement constraints
create_pblock pblock_SENSOR
resize_pblock [get_pblocks pblock_SENSOR] -add {SLICE_X56Y200:SLICE_X56Y249}
add_cells_to_pblock [get_pblocks pblock_SENSOR] [get_cells {hierachical/path/to/sensor/TDC_sensor/*}]
set_property LOC SLICE_X56Y200 [get_cells sensor_top/sensor/sensor_instance/coarse_init]
set_property DONT_TOUCH true [get_cells sensor_top/sensor/sensor_instance/*]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_SENSOR]

# Timing constraint
set_false_path -from [get_clocks *] -to [get_pins {hierachical/path/to/sensor/TDC_sensor/sensor_o_regs[*].obs_regs/D}]
