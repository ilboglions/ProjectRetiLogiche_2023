library ieee;
use ieee.std_logic_1164.all;

entity decoder_4bit is

	port(
		X 		: in std_logic_vector (1 downto 0);
		OUTPUT 	: out std_logic_vector(3 downto 0)
	);	
end decoder_4bit;

architecture r16s_p_behav of decoder_4bit is
	begin
	    
	    set_output_decoder : process(X)
	    begin
	    	OUTPUT(3) <= X(1) AND X(0);
	    	OUTPUT(2) <= X(1) AND  NOT X(0);
	    	OUTPUT(1) <= NOT X(1) AND X(0);
	    	OUTPUT(0) <= NOT X(1) AND NOT X(0);
	     end process;

end r16s_p_behav;