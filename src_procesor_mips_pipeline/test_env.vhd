----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2019 07:23:00 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is


signal counter:std_logic_vector(7 downto 0):="00000000";
signal counter1:std_logic_vector(3 downto 0):="0000";
signal en,en1,sa,bgz:std_logic:='0';  --??
signal func,mux_RegDst:std_logic_vector(2 downto 0):="000";

signal DO:std_logic_vector(15 downto 0):="0000000000000000";
signal wd,rd1,rd2,ext_imm,ALURes,ALUResOut,MemData:std_logic_vector(15 downto 0):="0000000000000000";
signal rd:std_logic_vector(15 downto 0):="0000000000000000";
signal instr,instNext,instructiune:std_logic_vector(15 downto 0):=x"0000";
signal branchaddr:std_logic_vector(15 downto 0);
signal jumpaddr:std_logic_vector(15 downto 0);
signal ExtOp,RegWrite,RegDst,ALUSrc,Branch,Branch1,Jump,MemWrite,RegWrite_int,MemWrite_int,zero,bSel:std_logic:='0';
signal ALUOp,MemToReg:std_logic_vector(1 downto 0):="00";

--semnale registrii intermediari
signal IF_ID:std_logic_vector(31 downto 0);
signal ID_EX:std_logic_vector(83 downto 0);
signal EX_MEM:std_logic_vector(38 downto 0);
signal MEM_WB:std_logic_vector(37 downto 0);



component  MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component ALU1 is
    Port ( mpg_enable : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           digits : out STD_LOGIC_VECTOR (15 downto 0);
           led7 : out STD_LOGIC;
           clk : in STD_LOGIC);
end component;

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

component RAM is
      Port ( clk : in STD_LOGIC;
           ra : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd : out STD_LOGIC_VECTOR (15 downto 0);
           RegWr : in STD_LOGIC);
end component;
component IF_comp is
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
end component;

component ID_comp is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wa_int : in STD_LOGIC_VECTOR (2 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end component;

component UC_comp is
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
end component;

component EX_comp is
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
end component;

component MEM_comp is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC);
end component;

begin
  
  
        port_map1: MPG port map(clk,btn(0),en);
        port_map2:MPG port map(clk,btn(1),en1);
       -- port_map3:IF_comp port map(clk,branchaddr,jumpaddr,Jump,bSel,instr,instNext,en,en1);
        port_map3:IF_comp port map(clk,branchaddr,jumpaddr,Jump,bSel,instr,instNext,en,en1);
       -- port_map4:ID_comp port map(clk,RegWrite_int,RegDst,ExtOp,instr,rd1,rd2,wd,ext_imm,func,sa);--led(2 downto 0),led(3));
        port_map4:ID_comp port map(clk,MEM_WB(2),ExtOp,IF_ID(31 downto 16),rd1,rd2,wd,MEM_WB(37 downto 35),ext_imm,func,sa);
        --port_map5:UC_comp port map(instr(15 downto 13),RegDst,ExtOp,AluSrc,Branch,Branch1,Jump,ALUOp,MemWrite,MemToReg,RegWrite);
        port_map5:UC_comp port map(IF_ID(31 downto 29),RegDst,ExtOp,AluSrc,Branch,Branch1,Jump,ALUOp,MemWrite,MemToReg,RegWrite);
        port_map6:SSD port map(clk,instructiune(3 downto 0),instructiune(7 downto 4),instructiune(11 downto 8),instructiune(15 downto 12),cat,an);
        --port_map7:EX_comp port map(rd1,ALUSrc,rd2,ext_imm,sa,func,ALUOp,zero,bgz,ALURes);
        port_map7:EX_comp port map(ID_EX(79 downto 77),ID_EX(82 downto 80),ID_EX(9),ID_EX(41 downto 26),ID_EX(8),ID_EX(57 downto 42),ID_EX(73 downto 58),ID_EX(83),ID_EX(76 downto 74),ID_EX(7 downto 6),zero,bgz,ALURes,mux_RegDst);
        --port_map8: MEM_comp port map(MemWrite_int,ALURes,ALUResOut,rd2,MemData,clk);
        port_map8: MEM_comp port map(EX_MEM(3),EX_MEM(19 downto 4),ALUResOut,EX_MEM(35 downto 20),MemData,clk);
        
    -- RegWrite_int<= en and RegWrite;
     --MemWrite_int<= en and MemWrite;
     
     process(sw(7 downto 5),instr,instNext,rd1,rd2,ALUResOut,MemData,wd,ext_imm)
     begin
     case sw(7 downto 5) is
        when "000" =>instructiune<=instr;
        when "001"=>instructiune<=instNext;
        when "010"=>instructiune<=rd1;
        when "011"=>instructiune<=rd2;
        when "100"=>instructiune<=ext_imm;
        when "101"=>instructiune<=ALURes;
        when "110"=>instructiune<=MemData;
        when "111"=>instructiune<=wd;
      end case;
      end process;
      
    --wd<=rd1+rd2;
    
    process(MEM_WB(1 downto 0),MEM_WB(18 downto 3),MEM_WB(34 downto 19))
    begin
    case(MEM_WB(1 downto 0)) is
        when "00" =>wd<=MEM_WB(34 downto 19);
        when "01" =>wd<=MEM_WB(18 downto 3);
        when others =>wd<="000000000000000" & MEM_WB(34);
    end case;
    end process;
    
    bSel<=(ID_EX(4) and zero) or (ID_EX(5) and bgz);
    
    branchaddr<=ID_EX(73 downto 58)+ID_EX(25 downto 10);
    jumpaddr<=IF_ID(15 downto 13) & IF_ID(28 downto 16);
    
    led(0)<=RegDst;
    led(1)<=ExtOp;
    led(2)<= ALUSrc;
    led(3)<=Branch;                 
    led(4)<=Branch1;           
    led(5)<= Jump;                       
    led(7 downto 6)<= ALUOp ;                  
    led(8)<= MemWrite;                     
    led(10 downto 9)<= MemToReg;                    
    led(11)<=RegWrite;     
    led(12)<=zero;
    led(13)<=bgz; 
    led(14)<='0';
    led(15)<='0';      
    
    --IF/ID
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                IF_ID(15 downto 0)<=instNext;  --intra in ID_EX
                IF_ID(31 downto 16)<=instr;    --intra in RF(ID)
            end if;
        end if;
    end process;
    
    --ID/EX
     process(clk)
     begin
        if rising_edge(clk) then
               if en='1' then
                    ID_EX(1 downto 0)<=MemToReg;
                    ID_EX(2)<=RegWrite;
                    ID_EX(3)<=MemWrite;
                    ID_EX(4)<=Branch;
                    ID_EX(5)<=Branch1;
                    ID_EX(7 downto 6)<=ALUOp;
                    ID_EX(8)<=ALUSrc;
                    ID_EX(9)<=RegDst;
                    ID_EX(25 downto 10)<=IF_ID(15 downto 0);
                    ID_EX(41 downto 26)<=rd1;
                    ID_EX(57 downto 42)<=rd2;
                    ID_EX(73 downto 58)<=ext_imm;
                    ID_EX(76 downto 74)<=func;
                    ID_EX(79 downto 77)<=IF_ID(25 downto 23); --rt
                    ID_EX(82 downto 80)<=IF_ID(22 downto 20); --rd
                    ID_EX(83)<=sa;
                end if;
            end if;
        end process;
        
    --EX/MEM
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                EX_MEM(1 downto 0)<=ID_EX(1 downto 0);  --MemToReg
                EX_MEM(2)<=ID_EX(2);                    --RegWrite
                EX_MEM(3)<=ID_EX(3);                    --MemWrite
                EX_MEM(19 downto 4)<=ALURes;
                EX_MEM(35 downto 20)<=ID_EX(57 downto 42); --rd2
                EX_MEM(38 downto 36)<=mux_RegDst; 
            end if;
        end if;
    end process;
    
   --MEM/WB
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' then
                MEM_WB(1 downto 0)<=EX_MEM(1 downto 0); --MemToReg 
                MEM_WB(2)<=EX_MEM(2);   --RegWrite
                MEM_WB(18 downto 3)<=MemData;
                MEM_WB(34 downto 19)<=EX_MEM(19 downto 4);   --ALURes
                MEM_WB(37 downto 35)<=EX_MEM(38 downto 36);  --mux_RegDst
            end if;
        end if;
    end process;
   
    
                    
    
    

end Behavioral;
