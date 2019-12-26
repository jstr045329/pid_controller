library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.vhd_synth_tools_pkg.all;


entity pid_tb is
    generic(
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic := '1';
    );
end pid_tb;


architecture behavioral of pid_tb is

signal clk : std_logic;
signal rst : std_logic;
signal sim_done : std_logic := '0';


begin


stim_process: process
begin
    sync_wait(clk, 20);
    -- Do stuff here

    -- Uncomment the following when you're done:
    --sim_done <= '1';
    wait;
end process;


clk_rst_driver: clk_rst_tb
    generic map(
        period => clk_per
    )
    port map(
        clk0 => clk,
        clk1 => open,
        clk2 => open,
        clk3 => open,
        rst_p => rst,
        rst_n => open,
        sim_done => sim_done
    );


uut: pid
    port map(
        clk => clk,
        rst => rst,
        en => en,
        din => din,
        dout => dout
    );


end behavioral;

