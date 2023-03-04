library ieee;
use ieee.std_logic_1164.all;

entity register_8it_p_p is

	port(
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic_vector (7 downto 0);
		OUTPUT 	: out std_logic_vector(7 downto 0)
	);	
end register_8it_p_p;

architecture r8p_p_behav of register_8it_p_p is
        signal curr_reg_output : std_logic_vector(7 downto 0) := (7 downto 0 => '0') ; 
	begin
	    
	    set_reset_function : process(CLK, RST)
	    begin
	    	if RST = '1' then
	    	      curr_reg_output <=  (7 downto 0 => '0') ;
	    	elsif CLK'event and CLK='1'  then
	    		curr_reg_output <= X;
	    	end if;
	     end process;
	    
	    OUTPUT <= curr_reg_output;

end r8p_p_behav;