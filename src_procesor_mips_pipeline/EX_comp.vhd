----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2019 02:43:17 PM
-- Design Name: 
-- Module Name: EX_comp - Behavioral
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

entity EX_comp is
    Port ( rt : in STD_LOGIC_VECTOR (2 downto 0);
           rd : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : in STD_LOGIC;
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           zero : out STD_LOGIC;
           bgz:out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           mux_RegDst : out STD_LOGIC_VECTOR(2 downto 0));
end EX_comp;

architecture Behavioral of EX_comp is
signal mux,ALURes1:std_logic_vector(15 downto 0):=x"0000";
signal ALUCtrl:std_logic_vector(2 downto 0):="000";
begin
    
    mux<=rd2 when ALUSrc='0' else Ext_Imm;
    process(rd1,mux,ALUCtrl,ALUOp,sa)
    begin
        case ALUOp is 
            when "00"=> ALUCtrl<="000";  
            when "01" => ALUCtrl<="001";
            when "10" => case(func) is
                            when "000" =>  ALUCtrl<="000";
                            when "001" =>  ALUCtrl<="001";
                            when "010" =>  ALUCtrl<="010";
                            when "011" =>  ALUCtrl<="011";
                            when "100" =>  ALUCtrl<="100";
                            when "101" =>  ALUCtrl<="101";
                            when "110" =>  ALUCtrl<="110";
                            when "111" =>  ALUCtrl<="111";
                          end case;
             when others=>ALUCtrl<="000";
            
             end case;
      end process;
     process(ALUCtrl)
     begin
      case(ALUCtrl) is
        when "000" => ALURes<= rd1+mux;
        when "001" => ALURes<= rd1-mux;
                      ALURes1<= rd1-mux;
        when "010" => case(sa) is
                            when '0' => ALURes<=mux(14 downto 0) & "0";
                            when '1' => ALURes<=mux(13 downto 0) & "00";
                        end case;
        when "011" => case(sa) is
                            when '0' => ALURes<="0" & mux(15 downto 1) ;
                            when '1' => ALURes<="00" & mux(15 downto 2) ;
                            end case;
        when "100" => ALURes<= rd1 and mux;
        when "101" => ALURes<= rd1 or mux;
        when "110" => ALURes<= rd1 xor mux;
        when "111" => ALURes<= rd1(7 downto 0) * mux(7 downto 0);
       end case;
     end process;
     zero<='1' when ALURes1="0000000000000000" else '0';
     bgz<='1' when rd1>"0000000000000000" else '0';
     mux_RegDst<=rt when RegDst='0' else rd;
       
        
            
            

end Behavioral;
