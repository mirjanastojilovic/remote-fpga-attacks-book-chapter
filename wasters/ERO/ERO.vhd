-- Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
-- Copyright 2023, School of Computer and Communication Sciences, EPFL.
--
-- All rights reserved. Use of this source code is governed by a
-- BSD-style license that can be found in the LICENSE.md file.
--
-- ERO instance description
-- This code uses the LUT primitives to specify the connections between the different LUTs to form an ERO.
-- The outputs might need to be marked as virtual to avoid the synthesis tool optimizing away the entire entity.

library ieee;
use ieee.std_logic_1164.all;
-- Using AMD primitives
library UNISIM;
use UNISIM.VComponents.all;

entity ERO is
   port( 
      --en: enable signal for the ERO
      --output: output of the ERO
      en       : in std_logic;
      output   : out std_logic_vector(3 downto 0));
   --dont_touch: attribute to avoid the ERO being optimized away 
   attribute dont_touch: string;
	attribute dont_touch of ERO: entity is "true";
end ERO;

architecture LUT_instantiation of ERO is

signal A, B, C, D : std_logic;

--keep and dont_touch: attributes to avoid the LUTs being optimized away
attribute keep : string;
attribute keep of LUTA : label is "true";
attribute keep of LUTB : label is "true";
attribute keep of LUTC : label is "true";
attribute keep of LUTD : label is "true";
attribute dont_touch of LUTA : label is "true";
attribute dont_touch of LUTB : label is "true";
attribute dont_touch of LUTC : label is "true";
attribute dont_touch of LUTD : label is "true";
attribute dont_touch of A : signal is "true";
attribute dont_touch of B : signal is "true";
attribute dont_touch of C : signal is "true";
attribute dont_touch of D : signal is "true";

begin
   LUTA : LUT6 
   -- filling the LUT with values to ensure the RO functionality is maintained
   -- The values to fill might differ depending on the order of the inputs (e.g., Intel vs. AMD FPGA)
   generic map ( INIT => X"00000000FFFF0000")
   port map (
      O => A,
      I0 => A,
      I1 => B,
      I2 => C,
      I3 => D,
      I4 => en,
      I5 => A
   );

   LUTB : LUT6 
   generic map ( INIT => X"00000000FFFF0000")
   port map (
      O => B,
      I0 => B,
      I1 => C,
      I2 => D,
      I3 => A,
      I4 => en,
      I5 => B
   );

   LUTC : LUT6 
   generic map ( INIT => X"00000000FFFF0000")
   port map (
      O => C,
      I0 => C,
      I1 => D,
      I2 => A,
      I3 => B,
      I4 => en,
      I5 => C
   );

   LUTD : LUT6 
   generic map ( INIT => X"00000000FFFF0000")
   port map (
      O => D,
      I0 => D,
      I1 => C,
      I2 => B,
      I3 => A,
      I4 => en,
      I5 => D
   );

   output <= A & B & C & D;

end LUT_instantiation;
