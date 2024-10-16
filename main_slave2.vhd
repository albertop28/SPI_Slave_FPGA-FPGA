library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_slave is port(
    clk, serial_data_in : in std_logic;
	 start_detected_out : out std_logic;
	 received_data : out std_logic_vector(15 downto 0)
);
end main_slave;

architecture Behavioral of main_slave is
    signal bit_index : integer range 0 to 30 := 0;
    signal serial_data : std_logic := '1';
    signal clk_signal, clock_commFpga, start_detected : std_logic := '0';
    signal cont : integer := 1;
    constant div_freq_val : integer := 10000;
begin

clk_signal <= clk;
serial_data <= serial_data_in;
start_detected_out <= start_detected;

process(clk_signal) begin
    if clk_signal'event and clk_signal = '1' then
        if cont = div_freq_val then
            clock_commFpga <= not clock_commFpga;
            cont <= 1;
        else       
            cont <= cont + 1;
        end if;
    end if;
end process;

-- Proceso de recepción de datos
process(clock_commFpga) begin
    if rising_edge(clock_commFpga) then
        if start_detected = '0' then
            -- Verificar el código de inicio
            if bit_index = 0 then
               if serial_data = '0' then
						bit_index <= bit_index + 1;
					else
                  bit_index <= 0;  -- Reiniciar si no coincide
               end if;
            else
                start_detected <= '1';  -- Código de inicio recibido correctamente
                bit_index <= 0;
					 received_data(bit_index) <= serial_data;
            end if;
        else
				if bit_index < 15 then -- Recibir los 16 bits de datos después de detectar el código de inicio
                received_data(bit_index + 1) <= serial_data;
                bit_index <= bit_index + 1;	
            else
               -- Finalización exitosa
               start_detected <= '0';
               bit_index <= 0;
            end if;
        end if;
    end if;
end process;

end Behavioral;
