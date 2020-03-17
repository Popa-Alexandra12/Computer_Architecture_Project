----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2019 08:17:31 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is

signal counter:std_logic_vector(15 downto 0):="0000000000000000";
signal q1:std_logic;
signal q2:std_logic;
signal q3:std_logic;

begin
    
     process(clk)
    begin
        if( rising_edge(clk)) then
            counter<=counter+1;
         end if;
     end process;
     
     process(clk)
     begin
        if(rising_edge(clk)) then
             if(counter="1111111111111111") then
                q1<=btn;
            end if;
        end if;
      end process;
      
      process(clk)
      begin
        if( rising_edge(clk) ) then
            q2<=q1;
            q3<=q2;
         end if;
       end process;
       
       enable<=q2 and (not q3);

end Behavioral;
