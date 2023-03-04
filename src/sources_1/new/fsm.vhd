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
end entity;

architecture arch_controller of fsm_controller is
    type S is ( s_firstbit, s_secondbit, s_address, s_readmem, s_saveresult, s_writeout );
    signal current_state, next_state : S;
begin
    comb_process: process(current_state, start)
    begin
        case current_state is
            when s_firstbit =>
                if start = '1' then
                    next_state <= s_secondbit;
                else
                    next_state <= s_firstbit;
                end if;
                wo <= '0';
                dir <= '1';
                done <= '0';
                mem_en <= '0';
            when s_secondbit =>
                next_state <= s_address;
                wo <= '0';
                dir <= '1';
                done <= '0';
                mem_en <= '0';
            when s_address =>
                if start = '1' then
                    next_state <= s_address;
                else
                    next_state <= s_readmem;
                end if;
                wo <= '0';
                dir <= '0';
                done <= '0';
                mem_en <= '0'; 
            when s_readmem =>
                next_state <= s_saveresult;
                wo <= '0';
                dir <= '0';
                done <= '0';
                mem_en <= '1'; 
            when s_saveresult =>
                next_state <= s_writeout;
                wo <= '1';
                dir <= '0';
                done <= '0';
                mem_en <= '1'; 
            when s_writeout =>
                next_state <= s_firstbit;
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
        elsif (clk'event and clk='1') then
            current_state <= next_state;
        end if;
    end process;
end architecture;