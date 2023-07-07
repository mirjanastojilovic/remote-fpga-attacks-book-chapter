# Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
# Copyright 2023, School of Computer and Communication Sciences, EPFL.
#
# All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE.md file.
#
# This file contains the placement and timing constraints for the RDS sensor on AMD 7-Series devices.
# In this example, the sensor is used on an Alveo U200 board, and placed with the origin at X=56, Y=200.
# The registers are constrained to a pblock between X=58, Y=200 and X=61, Y=207.
# hierachical/path/to/sensor/RDS_sensor should be replaced with the actual hierarchical path.

# Placement constraints
create_pblock pblock_SENSOR
resize_pblock [get_pblocks pblock_SENSOR] -add  {SLICE_X56Y200:SLICE_X56Y249}
add_cells_to_pblock [get_pblocks pblock_SENSOR] [get_cells {hierachical/path/to/sensor/RDS_sensor/*}]
set_property LOC SLICE_X56Y200 [get_cells hierachical/path/to/sensor/RDS_sensor/fine_init]
set_property DONT_TOUCH true [get_cells hierachical/path/to/sensor/RDS_sensor/*]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_SENSOR]

create_pblock pblock_REGISTERS
add_cells_to_pblock [get_pblocks pblock_REGISTERS] [get_cells hierachical/path/to/sensor/RDS_sensor/sensor_o_regs[*].obs_regs]
resize_pblock [get_pblocks pblock_REGISTERS] -add {SLICE_X58Y200:SLICE_X61Y207}   
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_REGISTERS]

# Timing constraint
set_false_path -from [get_clocks *] -to [get_pins {hierachical/path/to/sensor/RDS_sensor/sensor_o_regs[*].obs_regs/D}]
