library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stack2 is
port(   CLKB : in std_logic;  --EN CLKA EL PC SE INCREMENTA Y EN CLKB SI ES UN CALL O GOTO SE HABILITA EL STACK
        DATO : INOUT std_logic_vector(12 downto 0);  --DATO DE DATOS
        --DATO : out std_logic_vector(12 downto 0);  --DATO DE DATOS
        PP : in std_logic;  --DECIDE SI ES PUSH O POP
        PILA_LLENA : out std_logic;  --DICE SI LA PILA ESYA LLENA
        PILA_VACIA : out std_logic  --DICE SI LA PILA ESTA VACIA.
        );
end stack2;

architecture NARQ of stack2 is

type MEMORIA is array (8 downto 0) of std_logic_vector(12 downto 0);
signal MEMORIA_PILA : MEMORIA := (others => (others => '0'));
signal POSICION : integer := 8;
signal LLENA,VACIA : std_logic := '0';

begin

PILA_LLENA <= LLENA; 
PILA_VACIA <= VACIA;

process(ClKB,PP)
begin
    if(ClKB='1') then
        --PUSH .
        if (PP = '1' and LLENA = '0') then
             --GUARDANDO DATOS
            MEMORIA_PILA(POSICION) <= DATO; 
            if(POSICION /= 0) then
                POSICION <= POSICION - 1;
            end if; 
            --BANDERAS
            if(POSICION = 0) then
                LLENA <= '1';
                VACIA <= '0';
            elsif(POSICION = 8) then
                LLENA <= '0';
                VACIA <= '1';
            else
                LLENA <= '0';
                VACIA <= '0';
            end if;
            
        end if;
        --POP 
        if (PP = '0' and VACIA = '0') then
   
            if(POSICION /= 8) then   
                DATO <= MEMORIA_PILA(POSICION+1); 
                POSICION <= POSICION + 1;
            end if; 
            if(POSICION = 0) then
                LLENA <= '1';
                VACIA <= '0';
            elsif(POSICION = 8) then
                LLENA <= '0';
                VACIA <= '1';
            else
                LLENA <= '0';
                VACIA <= '0';
            end if; 
            
        end if;
        
    end if; 
end process;

end NARQ;