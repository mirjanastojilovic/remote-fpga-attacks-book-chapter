-- Practical Implementations of Remote Power Side-Channel and Fault-Injection Attacks on Multitenant FPGAs
-- Copyright 2023, School of Computer and Communication Sciences, EPFL.
--
-- All rights reserved. Use of this source code is governed by a
-- BSD-style license that can be found in the LICENSE.md file.
--
-- ERO block code 
-- This code instantiates the desired number of LUTs as EROs. 
-- Each ERO already contains 4 LUTs so the code generates N/4 EROs.
-- All of the instantiated EROs share the enable signal.

library ieee;
use ieee.std_logic_1164.all;

entity ERO_block is
   generic(
      --N: Number of LUTs to instantiate, maps to the number of outputs
      N        : integer);
   port ( 
      --en: enable signal for the block
      --output: output of the EROs
      en       : in std_logic; 
      output   : out std_logic_vector(N-1 downto 0)
   );
   --dont_touch: attribute to avoid the ERO block being optimized away
   attribute dont_touch: string;
   attribute dont_touch of ERO_block: entity is "true";
end ERO_block;

architecture ero_arch of ERO_block is

component ERO
   Port(
      en       : in std_logic;
      output   : out std_logic_vector(3 downto 0)
   );
end component;

--keep: attribute to ensure the ERO instances are not optimized away
attribute keep : string;
attribute keep of ERO_insts : label is "true";

begin
                      
    ERO_insts : for i in 0 to N/4-1 generate
        ERO_i : ERO 
        port map ( 
            en => en, 
            output => output(((i+1)*4)-1 downto i*4)
         );
    end generate;

end ero_arch;