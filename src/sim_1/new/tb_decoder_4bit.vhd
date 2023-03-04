library ieee;
use ieee.std_logic_1164.all;

entity tb_decoder is
end entity;

architecture sim of tb_decoder is
    -- Component declaration
    component decoder_4bit is
        port(
            X 		: in std_logic_vector (1 downto 0);
            OUTPUT 	: out std_logic_vector(3 downto 0)
        );
    end component;

    -- Test signal declarations
    signal out_reg    : std_logic_vector(1 downto 0) := (1 downto 0 => '0');
    signal pout  : std_logic_vector(3 downto 0) := (3 downto 0 => '0');

begin
    -- Instantiate the register component
    dec : decoder_4bit
        port map (
            X => out_reg,
            OUTPUT  => pout
        );


    -- Test process
    test_proc : process
    begin
        -- Test input values
        wait for 250 ns;
        out_reg <= "10";
        wait for 25 ns;
        assert pout = "0100" report "Error: Output value does not match expected value 0100" severity error;
        wait for 100 ns;
        out_reg <= "11";
        wait for 25 ns;
        assert pout = "1000" report "Error: Output value does not match expected value 1000" severity error;
        wait for 100 ns;
        out_reg <= "00";
        wait for 25 ns;
        assert pout = "0001" report "Error: Output value does not match expected value 0001" severity error;
        wait for 100 ns;
        out_reg <= "01";
        wait for 25 ns;
        assert pout = "0010" report "Error: Output value does not match expected value 0010" severity error;
        wait for 100 ns;
        out_reg <= "10";
        wait for 25 ns;
        assert pout = "0100" report "Error: Output value does not match expected value 0100" severity error;
        wait for 1000 ns;

        wait;
    end process;

end architecture;
