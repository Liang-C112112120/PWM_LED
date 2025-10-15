library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity PWM is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           o_led : out STD_LOGIC
         );
end PWM;

architecture Behavioral of PWM is

    component hw1_2cnters 
        Port (
           i_clk       : in STD_LOGIC;
           i_rst        : in STD_LOGIC;
           i_upperBound1: in STD_LOGIC_VECTOR (7 downto 0);
           i_upperBound2: in STD_LOGIC_VECTOR (7 downto 0);
           o_state        : out STD_LOGIC
             );           
    end component;
    
    type STATE2TYPE is (gettingBright, gettingDark);
    signal              state2 : STATE2TYPE;
    signal              upbnd1 : STD_LOGIC_VECTOR (7 downto 0);
    signal              upbnd2 : STD_LOGIC_VECTOR (7 downto 0);
    signal alreadyP_PWM_cycles : STD_LOGIC;
    signal              pwmCnt : STD_LOGIC_VECTOR (12 downto 0) := (others => '0');
    constant                 P : STD_LOGIC_VECTOR (12 downto 0) := (others => '1'); --加大P值
    signal        pwm_pos_edge : STD_LOGIC;
    signal                 pwm : STD_LOGIC;
    signal             pwm_old : STD_LOGIC;
    
begin

    hw1: hw1_2cnters 
        port map (
            i_clk         => i_clk,
            i_rst         => i_rst,
            i_upperBound1  => upbnd1,
            i_upperBound2  => upbnd2,
            o_state       => pwm
        );
        
    FSM2: process(i_clk, i_rst, upbnd1, upbnd2)
    begin
        if i_rst = '0' then
            state2 <= gettingBright;
        elsif i_clk'event and i_clk = '1' then
            case state2 is
                when gettingBright =>
                    if upbnd1 = "1111"&"1111" then --已經最亮 then
                        state2 <= gettingDark; --變暗
                    end if;
                when gettingDark =>
                    if upbnd1 = "0000"&"0000" then --已經最暗 then
                        state2 <= gettingBright; --變亮
                    end if;
                when others =>
                    null;
            end case;
        end if;        
    end process;

    upbnd1p: process(i_clk, i_rst, state2, alreadyP_PWM_cycles)
    begin
        if i_rst = '0' then
            upbnd1 <= "00000000"; --0
        elsif i_clk'event and i_clk = '1' then
            case state2 is
                when gettingBright =>
                   if alreadyP_PWM_cycles = '1' then
                       upbnd1 <= upbnd1 + '1';
                   end if;
                when gettingDark =>
                   if alreadyP_PWM_cycles = '1' then
                       upbnd1 <= upbnd1 - '1';
                   end if;
                when others =>
                    null;
            end case;
        end if;
    end process upbnd1p;

    upbnd2p: process(i_clk, i_rst, state2, alreadyP_PWM_cycles)
    begin
        if i_rst = '0' then
            upbnd2 <= "11111111"; --255
        elsif i_clk'event and i_clk = '1' then
            case state2 is
                when gettingBright =>
                   if alreadyP_PWM_cycles = '1' then
                       upbnd2 <= upbnd2 - '1';
                   end if;
                when gettingDark =>
                   if alreadyP_PWM_cycles = '1' then
                       upbnd2 <= upbnd2 + '1';
                   end if;
                when others =>
                    null;
            end case;
        end if;
    end process upbnd2p;
        
    P_PWM_cycles: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            pwmCnt <= (others => '0');
            alreadyP_PWM_cycles <= '0';
        elsif i_clk'event and i_clk = '1' then
            if pwm_pos_edge = '1' then
                if pwmCnt >= P - 1 then
                    pwmCnt <= (others => '0');
                    alreadyP_PWM_cycles <= '1';
                else
                    pwmCnt <= pwmCnt + 1;
                    alreadyP_PWM_cycles <= '0';
               end if;
            else
                alreadyP_PWM_cycles <= '0';
            end if;
        end if;
    end process;
    
    detect_PWM_pos_edge: process(i_clk, i_rst, pwm)
    begin
        if i_rst = '0' then
            pwm_pos_edge <= '0';
            pwm_old <='0';
        elsif i_clk'event and i_clk = '1' then    
            pwm_old <= pwm;
            if pwm_old = '0' and pwm='1' then --如果有正緣(由0轉1)
                pwm_pos_edge <= '1'; --抓到正緣
            else
                pwm_pos_edge <= '0';
            end if;
        end if;
    end process;
    
    o_led <= pwm;
    
end Behavioral;