----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 02:42:48 PM
-- Design Name: 
-- Module Name: UC_comp - Behavioral
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

entity UC_comp is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Branch1:out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC_VECTOR(1 downto 0);
           RegWrite : out STD_LOGIC);
end UC_comp;

architecture Behavioral of UC_comp is

begin
    process(instr)
    begin
        case instr is
        --R-format
            when "000" => RegDst<='1';
                           ExtOp<='0';
                           ALUSrc<='0';
                           Branch<='0';
                           Branch1<='0';
                           Jump<='0';
                           ALUOp<="10";
                           MemWrite<='0';
                           MemToReg<="00";
                           RegWrite<='1';
            --addi
             when "001" => RegDst<='0';
                           ExtOp<='1';
                           ALUSrc<='1';
                           Branch<='0';
                           Branch1<='0';
                           Jump<='0';
                           ALUOp<="00";
                           MemWrite<='0';
                           MemToReg<="00";
                           RegWrite<='1';
             --lw
              when "010" => RegDst<='0';
                           ExtOp<='1';
                           ALUSrc<='1';
                           Branch<='0';
                           Branch1<='0';
                           Jump<='0';
                           ALUOp<="00";
                           MemWrite<='0';
                           MemToReg<="01";
                           RegWrite<='1';
              --sw
               when "011" => RegDst<='0';
                           ExtOp<='1';
                           ALUSrc<='1';
                           Branch<='0';
                           Branch1<='0';
                           Jump<='0';
                           ALUOp<="00";
                           MemWrite<='1';
                           MemToReg<="00";
                           RegWrite<='0';
              --beq
               when "100" => RegDst<='0';
                           ExtOp<='1';
                           ALUSrc<='0';
                           Branch<='1';
                           Branch1<='0';
                           Jump<='0';
                           ALUOp<="01";
                           MemWrite<='0';
                           MemToReg<="00";
                           RegWrite<='0';
              --bgtz
               when "101" => RegDst<='0';
                           ExtOp<='1';
                           ALUSrc<='0';
                           Branch<='0';
                           Branch1<='1';
                           Jump<='0';
                           ALUOp<="11";
                           MemWrite<='0';
                           MemToReg<="00";
                           RegWrite<='0';
             --slti
               when "110" =>RegDst<='0';  
                         ExtOp<='1';
                         ALUSrc<='1';
                         Branch<='0';
                         Branch1<='0';
                         Jump<='0';
                         ALUOp<="01";
                         MemWrite<='0';
                         MemToReg<="10";
                         RegWrite<='1';
          --jump
             when "111" => RegDst<='0';
                        ExtOp<='0';
                        ALUSrc<='0';
                        Branch<='0';
                        Branch1<='0';
                        Jump<='1';
                        ALUOp<="00";
                        MemWrite<='0';
                        MemToReg<="00";
                        RegWrite<='0';
            when others =>   RegDst<='0';
                         ExtOp<='0';
                         ALUSrc<='0';
                         Branch<='0';
                         Branch1<='0';
                         Jump<='0';
                         ALUOp<="00";
                         MemWrite<='0';
                         MemToReg<="00";
                         RegWrite<='0';
        end case;
    end process; 
                           
                           
        


end Behavioral;
