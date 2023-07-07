# Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
# Copyright 2023, School of Computer and Communication Sciences, EPFL.
#
# All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE.md file.
#
# The constraints here are synthesis tool-specific.
# They are used to allow the instantiation of ROs in Vivado.
# hierachical/path/to/waster/RO_block should be replaced with the actual hierarchical path.

set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets hierachical/path/to/waster/RO_block/output[*]]  
