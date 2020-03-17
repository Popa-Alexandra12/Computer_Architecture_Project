----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 02:46:04 PM
-- Design Name: 
-- Module Name: IF_comp - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IF_comp is
    Port (clk : in STD_LOGIC;
          -- addr : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           jumpSel : in STD_LOGIC;
           bSel : in STD_LOGIC;
           instructiune : out STD_LOGIC_VECTOR (15 downto 0);
           instrNextAddr : out STD_LOGIC_VECTOR (15 downto 0);
           en: in std_logic;
           reset: in std_logic);
end IF_comp;
architecture Behavioral of IF_comp is
type memorie is array (0 to 31) of std_logic_vector(15 downto 0);
signal rom:memorie:=(    B"000_000_000_001_0_000",  --add $1,$0,$0    i=0;
                         B"010_000_010_0000000",  --lw &2,0($0)       x=7;
                         B"001_000_011_0000001",  --addi $3,$0,1      y=1;
                         B"000_000_000_000_0_000",  --NOOP
                         B"000_000_000_000_0_000",  --NOOP
                         B"000_010_011_100_0_100",  --and $4,$2,$3    x&y
                         B"000_000_000_000_0_000",  --NOOP
                         B"000_000_000_000_0_000",  --NOOP
                         B"100_100_000_0000011", --beq $4,$0,3    if(x&y==1)--modificar
                         B"000_000_000_000_0_000",  --NOOP
                         B"000_000_000_000_0_000",  --NOOP
                         B"001_001_001_0000001",   --addi $1,$1,1  i=i+1;
                         B"000_000_010_010_0_011",   --srl $2,$2,0   x=x>>1
                         B"000_000_000_000_0_000",  --NOOP
                         B"000_000_000_000_0_000",  --NOOP
                         B"100_010_000_0000011",     --beq $2,$0,3   while(x!=0)--modificat
                         B"000_000_000_000_0_000",  --NOOP
                         B"000_000_000_000_0_000",  --NOOP
                         B"111_0000000000101",     -- j adress 5 --modificat
                         B"000_000_000_000_0_000",  --NOOP
                         B"011_000_001_0000010", --sw $1,2($0)
                         others=>x"0000");
signal adresa,output_MUX1,output_MUX2,output_sumator:std_logic_vector(15 downto 0):=x"0000";                     
begin
    --rom
    instructiune<=rom(conv_integer(adresa(4 downto 0)));
    --pc
    process(clk,reset)
    begin
     if reset='1'
            then adresa<=x"0000";
      elsif rising_edge(clk) then
            if en='1' then
            adresa<=output_MUX2;
            end if;
      end if;
      end process;
       
       --sumator
       output_sumator<=adresa+1;
       --MUX1
       output_MUX1<=output_sumator when bSel='0' else  branchAddr;
       --MUX2
       output_MUX2<=output_MUX1 when jumpSel='0' else  jumpAddr;
       
        instrNextAddr<=output_sumator;
   
            
            

end Behavioral;
