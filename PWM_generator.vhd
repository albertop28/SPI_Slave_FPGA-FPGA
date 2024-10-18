library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator is port (
	clk      : in  std_logic; -- Reloj de 50 MHz
   reset    : in  std_logic; -- Señal de reset
   pwm_out  : out std_logic_vector(7 downto 0)); -- 8 señales PWM de salida
end pwm_generator;

architecture Behavioral of pwm_generator is
    -- Constantes para el cálculo de periodos
    constant CLK_FREQ      : integer := 50000000;  -- Frecuencia del reloj de entrada (50 MHz)
    constant PWM_FREQ      : integer := 50;        -- Frecuencia PWM (50 Hz)
    constant PERIOD_TICKS  : integer := CLK_FREQ / PWM_FREQ; -- Ciclos del reloj para un periodo de 50 Hz
    
    -- Anchos de pulso en microsegundos convertidos a ciclos de reloj
    constant PULSE_WIDTH_0 : integer := (1200 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_1 : integer := (1400 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_2 : integer := (1500 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_3 : integer := (1600 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_4 : integer := (1800 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_5 : integer := (6600 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_6 : integer := (13500 * CLK_FREQ) / 1000000;
    constant PULSE_WIDTH_7 : integer := (20000 * CLK_FREQ) / 1000000;
    
    -- Contador para el periodo de PWM
    signal pwm_counter : integer range 0 to PERIOD_TICKS := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pwm_counter <= 0;
            pwm_out <= (others => '0');
        elsif rising_edge(clk) then
            -- Incrementar el contador de PWM
            if pwm_counter < PERIOD_TICKS then
                pwm_counter <= pwm_counter + 1;
            else
                pwm_counter <= 0;
            end if;
            
            -- Generación de las señales PWM según los anchos de pulso
            pwm_out(0) <= '1' when pwm_counter < PULSE_WIDTH_0 else '0';
            pwm_out(1) <= '1' when pwm_counter < PULSE_WIDTH_1 else '0';
            pwm_out(2) <= '1' when pwm_counter < PULSE_WIDTH_2 else '0';
            pwm_out(3) <= '1' when pwm_counter < PULSE_WIDTH_3 else '0';
            pwm_out(4) <= '1' when pwm_counter < PULSE_WIDTH_4 else '0';
            pwm_out(5) <= '1' when pwm_counter < PULSE_WIDTH_5 else '0';
            pwm_out(6) <= '1' when pwm_counter < PULSE_WIDTH_6 else '0';
            pwm_out(7) <= '1' when pwm_counter < PULSE_WIDTH_7 else '0';
        end if;
    end process;
end Behavioral;
