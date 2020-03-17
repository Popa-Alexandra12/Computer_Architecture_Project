----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 02:16:06 PM
-- Design Name: 
-- Module Name: ID_comp - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_comp is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           --RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wa_int : in STD_LOGIC_VECTOR (2 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
           --mux_RegDst: out STD_LOGIC_VECTOR (2 downto 0)
end ID_comp;

architecture Behavioral of ID_comp is
--signal wa_int:std_logic_vector(2 downto 0):="000";
component RF is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           RegWr : in STD_LOGIC);
end component;
begin
     

  process(ExtOp)
  begin
   if(ExtOp='0') then
            ext_imm<="000000000" & Instr(6 downto 0);
          else if(Instr(6)='0') then
                            ext_imm<="000000000" & Instr(6 downto 0);
                            else ext_imm<="111111111" & Instr(6 downto 0);
                            end if;
   end if;
   end process;
                            
                            
  --mux_RegDst<=Instr(9 downto 7) when RegDst='0' else Instr(6 downto 4);
  p:RF port map(clk=>clk,ra1=>Instr(12 downto 10),ra2=> Instr(9 downto 7),wa=>wa_int,wd=>wd,rd1=>rd1,rd2=>rd2,RegWr=>RegWrite);
   func<=Instr(2 downto 0);
   sa<=Instr(3);

end Behavioral;
