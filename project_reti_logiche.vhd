
library ieee;
use ieee.std_logic_1164.all;
-- ENTITY OUTPUT SELECTOR REGISTER 2B --

entity register_2bit_s_p is

	port(
	    ENABLE  : in std_logic;
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic;
		OUTPUT 	: out std_logic_vector(1 downto 0)
	);	
end register_2bit_s_p;

architecture r2s_p_behav of register_2bit_s_p is
        signal curr_reg_output : std_logic_vector(1 downto 0) := (1 downto 0 => '0') ; 
	begin
	    
	    set_reset_function : process(CLK, RST, curr_reg_output,ENABLE)
	    begin
	    	if RST = '1' then
	    	      curr_reg_output <= "00";
	    	elsif CLK'event and CLK='1' and ENABLE = '1'  then
	    		curr_reg_output(1) <= curr_reg_output(0);
	    		curr_reg_output(0) <= X;
	    	end if;
	    	OUTPUT <= curr_reg_output;
	     end process;
	    
	    

end r2s_p_behav;

-- ENTITY ADDRESS REGISTER --
    library ieee;
    use ieee.std_logic_1164.all;
    
    entity register_16bit_s_p is
    
        port(
            ENABLE  : in std_logic;
            CLK		: in std_logic;
            RST 	: in std_logic;
            X 		: in std_logic;
            OUTPUT 	: out std_logic_vector(15 downto 0)
        );	
    end register_16bit_s_p;
    
   architecture r16s_p_behav of register_16bit_s_p is
            signal curr_reg_output_addr : std_logic_vector(15 downto 0) := "0000000000000000";
        begin
            
            set_reset_function : process(CLK, RST, curr_reg_output_addr, ENABLE)
            begin
                if RST = '1' then
                      curr_reg_output_addr <= "0000000000000000";
                elsif CLK'event and CLK='1' and ENABLE = '1'  then
                    curr_reg_output_addr <= curr_reg_output_addr(14 downto 0) & X;
                end if;
                OUTPUT <= curr_reg_output_addr;
             end process;
 end r16s_p_behav;


-- ENTITY OUTPUT REGISTERS--
library ieee;
use ieee.std_logic_1164.all;

entity register_8bit_p_p is

	port(
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic_vector (7 downto 0);
		OUTPUT 	: out std_logic_vector(7 downto 0)
	);	
end register_8bit_p_p;

architecture r8p_p_behav of register_8bit_p_p is
        
	begin
	    
	    set_reset_function : process(CLK, RST)
	    begin
	    	if RST = '1' then
	    	      OUTPUT <=  "00000000" ;
	    	elsif CLK'event and CLK='1'  then
	    		OUTPUT <= X;
	    	end if;
	     end process;

end r8p_p_behav;

-- ENTITY DECODER --
    library ieee;               
    use ieee.std_logic_1164.all;
    
    entity decoder_4bit is
        port(
            X 		: in std_logic_vector (1 downto 0);
            OUTPUT 	: out std_logic_vector(3 downto 0)
        );	
    end decoder_4bit;
     
    
    architecture dec_arch of decoder_4bit is
        begin
            
            set_output_decoder : process(X)
            begin
                OUTPUT(3) <= X(1) AND X(0);
                OUTPUT(2) <= X(1) AND  NOT X(0);
                OUTPUT(1) <= NOT X(1) AND X(0);
                OUTPUT(0) <= NOT X(1) AND NOT X(0);
             end process;
    
    end dec_arch;




 -- ENTITY FSM --
library ieee;               
use ieee.std_logic_1164.all;

     entity fsm_controller is 
    
        port(
            clk         : in std_logic;
            reset       : in std_logic;
            start       : in std_logic;
            dir         : out std_logic;
            wo          : out std_logic;
            done        : out std_logic;
            mem_en      : out std_logic
        );
     
      end fsm_controller;

architecture arch_controller of fsm_controller is
    
    type S is ( s_firstbit, s_secondbit, s_address, s_readmem, s_saveresult, s_writeout );
    signal current_state : S;
    
    begin  
        
        comb_process: process(current_state)
            begin   
                wo <= '0';    
                dir <= '1';   
                done <= '0';  
                mem_en <= '0'; 
                case current_state is
               
                    when s_firstbit =>
                        wo <= '0';
                        dir <= '1';
                        done <= '0';
                        mem_en <= '0';
                    when s_secondbit =>
                        wo <= '0';
                        dir <= '1';
                        done <= '0';
                        mem_en <= '0';
                    when s_address =>
                        wo <= '0';
                        dir <= '0';
                        done <= '0';
                        mem_en <= '0'; 
                    when s_readmem =>
                        wo <= '0';
                        dir <= '0';
                        done <= '0';
                        mem_en <= '1'; 
                    when s_saveresult =>
                        wo <= '1';
                        dir <= '0';
                        done <= '0';
                        mem_en <= '1'; 
                    when s_writeout =>
                        wo <= '0';
                        dir <= '0';
                        done <= '1';
                        mem_en <= '0';
                end case;
        end process;
    seq_process: process(clk, reset)
        begin 
            if reset ='1' then
                current_state <= s_firstbit;
            elsif (rising_edge(clk)) then

                case current_state is
            
                    
                    when s_firstbit =>
                        if start = '1' then
                            current_state <= s_secondbit;
                        else
                            current_state <= s_firstbit;
                        end if;

                    when s_secondbit =>
                             current_state <= s_address;
                    when s_address =>
                        if start = '1' then
                            current_state <= s_address;
                        else
                            current_state <= s_readmem;
                        end if;

                    when s_readmem =>
                        current_state <= s_saveresult;
 
                    when s_saveresult =>
                        current_state <= s_writeout;
                    when s_writeout =>
                        if start = '1' then
                            current_state <= s_firstbit;
                        else
                            current_state <= s_firstbit;
                        end if;
                end case;
            end if;
        end process;
end architecture;

-- PROJECT ENTITY --
library ieee;               
use ieee.std_logic_1164.all;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_w : in std_logic;
        o_z0 : out std_logic_vector(7 downto 0);
        o_z1 : out std_logic_vector(7 downto 0);
        o_z2 : out std_logic_vector(7 downto 0);
        o_z3 : out std_logic_vector(7 downto 0);
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic
    
    );
end project_reti_logiche;


architecture project_reti_logiche_arch of project_reti_logiche is

-- USEFUL SIGNALS --
    -- register_2bit_s_p signals --
     signal out_selection : std_logic_vector(1 downto 0) := (1 downto 0 => '0'); 
     
     signal enable_rso : std_logic := '0'; -- i_clk AND i_start AND director
    -- register_16bit_s_p signals --    
     signal enable_ram : std_logic := '0'; -- i_clk AND i_start AND NOT director
     
     signal rst_cnd_ram: std_logic := '0'; --  i_rst AND director

    -- output signals --
    signal out_z0_signal : std_logic_vector(7 downto 0) := (7 downto 0 => '0'); 
    signal out_z1_signal : std_logic_vector(7 downto 0) := (7 downto 0 => '0'); 
    signal out_z2_signal : std_logic_vector(7 downto 0) := (7 downto 0 => '0'); 
    signal out_z3_signal : std_logic_vector(7 downto 0) := (7 downto 0 => '0'); 
     
     
     signal enable_z0_reg : std_logic := '0';-- i_clk AND decoder_out[0] AND write_output
     signal enable_z1_reg : std_logic := '0';
     signal enable_z2_reg : std_logic := '0';
     signal enable_z3_reg : std_logic := '0';
     
     -- decoder signals --
     
    signal  decoder_out: std_logic_vector(3 downto 0) := (3 downto 0 => '0'); 
     
     -- fsm signals
     
         -- output signals --  
            signal director :  std_logic := '0';
            signal write_output  :  std_logic := '0';
            signal done_signal : std_logic := '0';
   
     
-- 2BIT REGISTER  FOR OUT SELECTION S-P --
component register_2bit_s_p is

	port(
	    ENABLE  : in std_logic;
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic;
		OUTPUT 	: out std_logic_vector(1 downto 0)
	);	
end component;

-- 16BIT REGISTER FOR STORING MEMORY ADDRESS S-P -- 
component register_16bit_s_p is

	port(
	    ENABLE  : in std_logic;
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic;
		OUTPUT 	: out std_logic_vector(15 downto 0)
	);	
end component;


-- 8BIT REGISTER Z0-1-2-3-4 P-P --


component register_8bit_p_p is

	port(
		CLK		: in std_logic;
		RST 	: in std_logic;
		X 		: in std_logic_vector (7 downto 0);
		OUTPUT 	: out std_logic_vector(7 downto 0)
	);	
end component;

 -- DECODER 4BIT --
component decoder_4bit is

	port(
		X 		: in std_logic_vector (1 downto 0);
		OUTPUT 	: out std_logic_vector(3 downto 0)
	);	
end component;


-- FSM --
component fsm_controller is 
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        start       : in std_logic;
        dir         : out std_logic;
        wo          : out std_logic;
        done        : out std_logic;
        mem_en      : out std_logic
    );
end component;


begin 
    
    o_mem_we <= '0';
    -- PORT MAPPING --
        reg_sel_output: register_2bit_s_p port map (
            CLK	=> i_clk,  
            ENABLE => enable_rso,               
            RST => i_rst,	                   
            X 	=> i_w,                
            OUTPUT => out_selection
         );
         enable_reg_uscita: process(  i_start, director)
            begin
                enable_rso <= i_start AND director;
            end process;
         
         reg_address: register_16bit_s_p port map (
            ENABLE => enable_ram,  
            CLK	=> i_clk,
            RST => rst_cnd_ram,
            X 	=> i_w,
            OUTPUT => o_mem_addr
             
         ); 
         
         
         en_reg_address: process( i_start, director)
             begin 
                 enable_ram  <= i_start AND (NOT director);
             end process;
         rst_reg_address: process(i_rst, director)
            begin
                rst_cnd_ram <= i_rst OR director;
            end process;
     -- OUTPUT REGISTERS ENTITIES --

         z0_reg_out: register_8bit_p_p  port map(
            CLK		=> enable_z0_reg,
            RST 	=> i_rst,
            X 		=> i_mem_data,
            OUTPUT 	=> out_z0_signal
        );

        z1_reg_out: register_8bit_p_p  port map(
            CLK		=> enable_z1_reg,
            RST 	=> i_rst,
            X 		=> i_mem_data,
            OUTPUT 	=> out_z1_signal
         );

        z2_reg_out: register_8bit_p_p  port map(
            CLK		=> enable_z2_reg,
            RST 	=> i_rst,
            X 		=> i_mem_data,
            OUTPUT 	=> out_z2_signal
         );

        z3_reg_out: register_8bit_p_p  port map(
            CLK		=> enable_z3_reg,
            RST 	=> i_rst,
            X 		=> i_mem_data,
            OUTPUT 	=> out_z3_signal
        );
        
        
        enable: process(i_clk, decoder_out, write_output)
            begin
                 enable_z0_reg <= i_clk AND decoder_out(0) AND write_output;
                 enable_z1_reg <= i_clk AND decoder_out(1) AND write_output;
                 enable_z2_reg <= i_clk AND decoder_out(2) AND write_output;
                 enable_z3_reg <= i_clk AND decoder_out(3) AND write_output;
            end process;
	-- DECODER --

        decoder :  decoder_4bit port map(
            X       => out_selection,
            OUTPUT 	=> decoder_out
        );	

     -- FSM --
     
    fsm : fsm_controller port map(
            clk     => i_clk, 
            reset   => i_rst,
            start   => i_start,
            dir     => director,
            wo      => write_output,
            done    => done_signal,
            mem_en  => o_mem_en
    );
    -- END PORT MAPPING --

    -- PROCESSES --
    set_output : process (out_z0_signal, out_z1_signal, out_z2_signal, out_z3_signal, done_signal) 
        begin 
            if( done_signal = '1') then
                o_z0 <= out_z0_signal;
                o_z1 <= out_z1_signal;
                o_z2 <= out_z2_signal;
                o_z3 <= out_z3_signal;
            else
                o_z0 <= "00000000";
                o_z1 <= "00000000";
                o_z2 <= "00000000";
                o_z3 <= "00000000";
            end if;
        end process;
    
    set_o_done: process (done_signal)
        begin
            o_done <= done_signal;
        end process;

    
    

end project_reti_logiche_arch;
