library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.vhd_synth_tools_pkg.all;
use work.pid_pkg.all;

entity pid is
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
end pid;


architecture behavioral of pid is

signal integral : signed(ACCUMULATOR_WIDTH-1 downto 0); 
signal derivative : signed(ACCUMULATOR_WIDTH-1 downto 0); 
signal diff_chain : t_diff_chain;
signal sum_early : signed(ACCUMULATOR_WIDTH-1 downto 0); 
signal sum_late : signed(ACCUMULATOR_WIDTH-1 downto 0); 

signal effort_prop : signed(DATA_WIDTH-1 downto 0);
signal effort_int : signed(DATA_WIDTH-1 downto 0);
signal effort_diff : signed(DATA_WIDTH-1 downto 0);
signal effort0 : signed(DATA_WIDTH-1 downto 0);
signal effort1 : signed(DATA_WIDTH-1 downto 0);

signal intermediate_prop : signed(DATA_WIDTH*2-1 downto 0);
signal intermediate_int0 : signed(ACCUMULATOR_WIDTH + DATA_WIDTH - 1 downto 0);
signal intermediate_int1 : signed(DATA_WIDTH-1 downto 0);
signal intermediate_diff : signed(DATA_WIDTH*2-1 downto 0);

begin

intermediate_prop <= kp * din;

differentiator: process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            derivative <= (others => '0');
            diff_chain <= (others => (others => '0'));
            sum_early <= (others => '0');
            sum_late <= (others => '0');

        else
            if en = '1' then
                diff_chain <= din & diff_chain(0 to DIFF_CHAIN_LENGTH-2);
                
                sum_early <= (others => '0');
                for i in 0 to SUM_EARLY_IDX loop sum_early <= sum_early + diff_chain(i);
                end loop;
        
                sum_late <= (others => '0');
                for i in SUM_LATE_IDX to DIFF_CHAIN_LENGTH-1 loop
                    sum_late <= sum_late + diff_chain(i);
                end loop;
    
                derivative <= sum_late - sum_early;
            end if;
        end if;
    end if;
end process;

intermediate_diff <= derivative * kp;
effort_diff <= intermediate_diff(DATA_WIDTH*2-1 downto DATA_WIDTH);

integrator: process(clk)
    variable pad_sign_bit : signed(ACCUMULATOR_WIDTH - DATA_WIDTH);
begin
    if rising_edge(clk) then
        if rst = '1' then
            integral <= (others => '0');
        else
            if en = '1' then
                pad_sign_bit := (others => din(DATA_WIDTH-1));
                integral <= integral + (pad_sign_bit & din);
            end if;
        end if;
    end if;
end process;

intermediate_int0 <= integral * kp;
intermediate_int1 <= intermediate_int0(ACCUMULATOR_WIDTH-1 downto ACCUMULATOR_WIDTH-DATA_WIDTH);
effort_int <= intermediate_int1;

effort0 <= effort_prop + effort_diff + effort_int;

effort_driver: one_delay_signed
    generic map(
        w => DATA_WIDTH
    )
    port map(
        clk => clk,
        rst => rst,
        en => en,
        din => effort0,
        dout => effort1
    );

dout <= effort1;

end behavioral;



