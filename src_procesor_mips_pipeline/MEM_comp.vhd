----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2019 03:41:43 PM
-- Design Name: 
-- Module Name: MEM_comp - Behavioral
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

entity MEM_comp is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC);
end MEM_comp;

architecture Behavioral of MEM_comp is
type RAM is array(0 to 31) of std_logic_vector(15 downto 0);
signal data:RAM:=("0000000000000111",others=>x"0000");
begin
    
   process(clk,MemWrite)
    begin
        if rising_edge(clk) then
            if(MemWrite='1') then
                data(conv_integer(ALURes))<=rd2 ;
            end if;
        end if;
      end process;
     MemData <= data( conv_integer(ALURes));
     ALUResOut<=ALURes;
     

end Behavioral;
