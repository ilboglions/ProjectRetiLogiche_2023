library ieee;
use ieee.std_logic_1164.all;

entity tb_register is
end entity;

architecture sim of tb_register is
    -- Component declaration
    component register_2bit_s_p is
        port (
            CLK   : in  std_logic;
            RST : in  std_logic;
            X    : in  std_logic;
            OUTPUT  : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Test signal declarations
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal si    : std_logic := '0';
    signal pout  : std_logic_vector(1 downto 0);

begin
    -- Instantiate the register component
    reg : register_2bit_s_p
        port map (
            CLK   => clk,
            RST => reset,
            X    => si,
            OUTPUT  => pout
        );

    -- Clock generator process
    clk_gen_proc : process
    begin
        while true loop
            clk <= '0';
            wait for 50 ns;
            clk <= '1';
            wait for 50 ns;
        end loop;
    end process;

    -- Reset process
    reset_proc : process
    begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
    end process;

    -- Test process
    test_proc : process
    begin
        -- Test input values
        wait for 250 ns;
        si <= '1';
        wait for 100 ns;
        si <= '1';
        wait for 100 ns;
        si <= '1';
        wait for 100 ns;
        si <= '1';
        wait for 100 ns;
        si <= '0';
        wait for 1000 ns;

        -- Check output values
        assert pout = "00" report "Error: Output value does not match expected value" severity error;

        wait;
    end process;

end architecture;


