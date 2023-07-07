# Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs

This repository contains the design files corresponding to the chapter "Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs" by Dina G. Mahmoud, Ognjen Glamočanin, Francesco Regazzoni, and Mirjana Stojilović.

```
Overview:
├── LICENSE
├── README.md
├── sensors/
│   ├── rds/
│   │   ├── 7Series/: Directory containing the hardware description and the constraints for the RDS sensor on AMD 7-series FPGAs
│   │   │   ├── RDS_sensor.vhd
│   │   │   └── constraints.xdc
│   │   └── UltraScale+/: Directory containing the hardware description and the constraints for the RDS sensor on AMD UltraScale+ FPGAs
│   │       ├── RDS_sensor.vhd
│   │       └── constraints.xdc
│   └── tdc/
│       ├── 7Series/: Directory containing the hardware description and the constraints for the TDC sensor on AMD 7-series FPGAs
│       │   ├── TDC_sensor.vhd
│       │   └── constraints.xdc
│       └── UltraScale+/: Directory containing the hardware description and the constraints for the TDC sensor on AMD UltraScale+ FPGAs
│           ├── TDC_sensor.vhd
│           └── constraints.xdc
└── wasters/
    ├── ERO/: Directory containing the hardware description and the constraints for the ERO power waster
    │   ├── ERO.vhd
    │   ├── ERO_block.vhd
    │   └── constraints.xdc
    └── RO/: Directory containing the hardware description and the constraints for the RO power waster
        ├── RO.vhd
        └── constraints.xdc

```

The files in the repository represent the basic building blocks of a remote exploit against multitenant FPGAs. The sensors allow for remote side-channel analysis. The power wasters enable remote fault-injection exploits.

## FPGA Voltage Sensors

In this repo, we provide the implementations of two FPGA-based voltage-drop sensors: the TDC and RDS. Their underlying working principle is similar: instead of measuring the supply voltage variations directly, these sensors measure delay variations, which correlate with voltage fluctuations. All provided implementations have been tested on Vivado 2018.3, 2020.3, and 2022.2.

The source code of typical TDC implementations (for two AMD FPGA families) can be found at `sensors/TDC/`. 

The sensor consists of three parts:

* A tapped delay line, commonly called an *observable* delay line, is implemented using fast carry propagation logic (CARRY4 or CARRY8 elements) and dedicated routing. For optimal sensor sensitivity, we use strict placement constraints and form the delay line by chaining the carry output of one FPGA slice (where a slice contains four or eight registers, depending on the FPGA family) to the carry input of the next one. The occupied slices are constrained to one vertical column of the FPGA to harness the dedicated wiring and minimize inter-slice delays. 

* The second part of the sensor is an output register used to periodically save the state of the delay line (i.e., one sensor reading or a sample). Every carry output of the observable delay line is connected to the corresponding flip-flop (FF) in the same slice. The value in the output register can be converted to the numerical value of one sensor sample using a thermometer code or by taking the Hamming weight of the bits in the output register. 

* The third part is also a chain of delay elements, but with coarser granularity (lookup tables and latches acting as multiplexers), which adjusts the phase shift between the sampling clock of the output register and the clock driving the delay line. In our implementations, these two clocks have the same frequency. The phase shift and the length of the tapped delay line are adjusted using the `ID_coarse_i` input of the sensor, which controls the number of delay elements in the initial delay line.
  
The source code of typical RDS implementations (for two AMD FPGA families) can be found at `sensors/RDS/`. 

The main difference between an RDS and a TDC is the absence of the tapped delay line. The clock that drives the tapped delay line in a TDC is routed without constraints to the output registers in the RDS. The locations of the FFs in the output registers are decided by the FPGA placer, without tight constraints, in the interest of helping the FPGA router find good quality routes to the FFs. The placement of the registers is only constrained to a pBlock described in the `sensors/RDS/*/constraints.xdc`. The absence of specific register placement constraints allows the delay difference between two sensor bits to become even lower than in the case of a TDC, further improving sensor sensitivity. Like the TDC, the RDS sensor also has a reconfigurable initial delay line used to phase shift the sampling and input clock cycles. Since RDS needs finer delay changes to achieve a correct calibration, in addition to a coarser initial delay line (LUTs and latches), RDS has a carry-chain-based fine reconfigurable delay line. The phase shift and the length of the tapped delay line are adjusted using the `ID_coarse_i` and `ID_fine_i` inputs of the sensor, which control the number of delay elements in the initial delay line.

For both sensors, we provide a `constraints.xdc` file, where we set the sensor placement, and add a false path constraint to the sensor registers since the timing is violated by default.

## FPGA Power Wasters

In this repo, we provide the implementations of two FPGA-based power wasters: ring oscillators (ROs) and enhanced ring oscillators (EROs). Both circuits aim to consume as much dynamic power as possible. All provided implementations have been tested on Vivado 2019.1.

The source code of an implementation of ROs can be found at `wasters/RO/`.

ROs generate a high-frequency signal by using the shortest combinational path within the programmable logic and creating an oscillator out of it. Specifically, an RO is a combinational loop that uses an odd number of inverters to change the value of a logical signal and then uses that same signal as input to the inverters through a feedback loop. For the highest frequency of oscillation, one inverter suffices. One FPGA lookup table (LUT) can be programmed to act as an inverter, and its output can be connected back to its input with a short routing path. When used within an FPGA design, ROs typically employ an enable signal that allows the user control over when the RO oscillates. Therefore, in practice, an LUT implements a NAND instead of a NOT functionality. The resulting FPGA-based RO can generate signals at a frequency surpassing the maximum clock frequency that an on-chip PLL can generate.

The source code of an implementation of EROs (for AMD UltraScale+ FPGAs) can be found at `wasters/ERO/`.

The implementation of EROs uses LUTs implementing ROs and connects the output of each LUT to three other LUTs, to increase the load capacitance of each RO, resulting in more power consumption.

For both power wasters, we provide a `constraints.xdc` file, where we allow combinational loops to avoid issues with the synthesis. The constraints target AMD Vivado.

**More information can be found in the book chapter.**