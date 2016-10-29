--MUX DE DATOS PARA ALU
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX IS  
PORT   (  
ENTRADA_A: IN STD_LOGIC_VECTOR(7 DOWNTO 0);    --CONSTANTE DIRECTA
ENTRADA_B: IN STD_LOGIC_VECTOR(7 DOWNTO 0);    --ENTRADA DEL BUS
DD:IN STD_LOGIC;    
CLKC: IN STD_LOGIC;
SALIDA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END MUX;
 
ARCHITECTURE NARQ OF MUX IS
BEGIN
PROCESS (CLKC)      --DIRECCIONAMIENTO INMEDIATO
  BEGIN
	IF CLKC='1' AND CLKC'EVENT THEN 
		IF (DD='0') THEN   
			SALIDA<=ENTRADA_B;    --DEL BUS

		ELSE  
			SALIDA<=ENTRADA_A; --CONSTANTE
		END IF;  
	END IF;
  END PROCESS;

  END NARQ;
