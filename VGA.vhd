library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA is
    Port(
        clk : in std_logic;
        H_sync, V_sync : out std_logic;
        R_in, G_in, B_in : in std_logic_vector(3 downto 0);
        R_out, G_out, B_out : out std_logic_vector(3 downto 0)
        );
end VGA;

architecture Behavioral of VGA is

signal H_counter, V_counter, clk_counter : integer := 0;
signal sub_clk : std_logic := '0';

begin
process(clk) begin
    if(rising_edge(clk)) then
        if(clk_counter < 1) then
            clk_counter <= clk_counter + 1;
        else
            clk_counter <= 0;
            sub_clk <= not sub_clk;
        end if;
    end if;
end process;
process(sub_clk) begin
    if(rising_edge(sub_clk)) then
        if((V_counter < 480) and (H_counter < 640)) then
            R_out <= R_in;
            G_out <= G_in;
            B_out <= B_in;
        else
            R_out <= (others => '0');
            G_out <= (others => '0');
            B_out <= (others => '0');
        end if; 
        -- Updating the Scanline and the Frame.
        if(H_counter < 800) then
            H_counter <= H_counter + 1;
            if(H_counter >= 656 and H_counter < 752) then
                H_sync <= '0';
            else
                H_sync <= '1';
            end if;
        else
            V_counter <= V_counter + 1;
            H_counter <= 0;
        end if;
        if(V_counter < 525) then
            if(V_counter >= 490 and V_counter < 492) then
                V_sync <= '0';
            else
                V_sync <= '1';
            end if;
        else
            V_counter <= 0;
        end if;
    end if;
end process;
end Behavioral;