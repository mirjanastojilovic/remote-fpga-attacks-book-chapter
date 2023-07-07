# Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
# Copyright 2023, School of Computer and Communication Sciences, EPFL.
#
# All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE.md file.
#
# This file contains the placement and timing constraints for the RDS sensor on AMD UltraScale+ devices.
# In this example, the sensor is used on an Alveo U200 board, and placed with the origin at X=86, Y=780.
# The pblock for the registers is in a pblock between X=88, Y=780 and X=91, Y=787 .
# hierachical/path/to/sensor/RDS_sensor should be replaced with the actual hierarchical path.

# Placement constraints
create_pblock sensor_0
resize_pblock sensor_0 -add {SLICE_X86Y780:SLICE_X86Y815}
add_cells_to_pblock sensor_0 [get_cells [list hierachical/path/to/sensor/RDS_sensor]] -clear_locs
set_property LOC SLICE_X86Y780 [get_cells [list hierachical/path/to/sensor/RDS_sensor/fine_init]]
set_property DONT_TOUCH true [get_cells [list hierachical/path/to/sensor/RDS_sensor/*]]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks sensor_0]

create_pblock pblock_REGISTERS
add_cells_to_pblock [get_pblocks pblock_REGISTERS] [get_cells hierachical/path/to/sensor/RDS_sensor/sensor_o_regs[*].obs_regs]
resize_pblock [get_pblocks pblock_REGISTERS] -add {SLICE_X88Y780:SLICE_X91Y787}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_REGISTERS]

# Timing constraint
set_false_path -from [get_clocks *] -to [get_pins {hierachical/path/to/sensor/RDS_sensor/sensor_o_regs[*].obs_regs/D}]
