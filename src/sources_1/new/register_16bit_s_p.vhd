library ieee;
use ieee.std_logic_1164.all;

entity register_16bit_s_p is

	port(
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic;
		OUTPUT 	: out std_logic_vector(15 downto 0)
	);	
end register_16bit_s_p;

architecture r16s_p_behav of register_16bit_s_p is
        signal curr_reg_output : std_logic_vector(15 downto 0) := (15 downto 0 => '0') ; 
	begin
	    
	    set_reset_function : process(CLK, RST)
	    begin
	    	if RST = '1' then
	    	      curr_reg_output <=  (15 downto 0 => '0') ;
	    	elsif CLK'event and CLK='1'  then
	    		curr_reg_output <= curr_reg_output(14 downto 0) & X;
	    	end if;
	     end process;
	    
	    OUTPUT <= curr_reg_output;

end r16s_p_behav;