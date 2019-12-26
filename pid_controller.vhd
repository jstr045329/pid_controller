library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.vhd_synth_tools_pkg.all;


entity pid_controller is
    generic(
        kp : signed(DATA_WIDTH-1 downto 0); 
        ki : signed(DATA_WIDTH-1 downto 0); 
        kd : signed(DATA_WIDTH-1 downto 0)
    );
export PYTHONPATH=$PYTHONPATH:'/home/jamie/lambda_crusher_2/py'
    port(
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic := '1';
        measurement : in signed(DATA_WIDTH-1 downto 0);
        setpoint : in signed(DATA_WIDTH-1 downto 0);
        effort : out signed(DATA_WIDTH-1 downto 0)
    );
end pid_controller;


architecture behavioral of pid_controller is
    signal error_sig : signed(DATA_WIDTH-1 downto 0);
    signal effort0 : signed(DATA_WIDTH-1 downto 0);
begin

error_sig <= setpoint - measurement;

pid_calc: pid
    generic map(
        kp => kp,
        ki => ki,
        kd => kd
    )
    port map(
        clk => clk,
        rst => rst,
        en => en,
        din => error_sig,
        dout => effort0
    );

effort <= effort0; 

end behavioral;

