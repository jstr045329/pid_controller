library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.vhd_synth_tools.all;


package pid_pkg is


constant DATA_WIDTH : integer := 16;
constant ACCUMULATOR_WIDTH : integer := 64;
constant DIFF_CHAIN_LENGTH : integer := 30;
constant SUM_EARLY_IDX : integer := 14;
constant SUM_LATE_IDX : integer := 15;
type t_diff_chain is array (0 to DIFF_CHAIN_LENGTH) of signed(DATA_WIDTH-1 downto 0);


component pid is
    generic(
        kp : signed(DATA_WIDTH-1 downto 0);
        ki : signed(DATA_WIDTH-1 downto 0);
        kd : signed(DATA_WIDTH-1 downto 0)
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic := '1';
        din : in signed(DATA_WIDTH-1 downto 0);
        dout : out signed(DATA_WIDTH-1 downto 0)
    );
end component;


component pid_controller is
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
end component;


end package pid_pkg;




package body pid_pkg is

end package body pid_pkg;

