LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;   
USE IEEE.STD_LOGIC_UNSIGNED.ALL;  
ENTITY PC IS
PORT (
CLKA,CLKB,CLKC,CLKD,GOT: IN STD_LOGIC;
BUSD: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
SATCK: INOUT STD_LOGIC_VECTOR(12 DOWNTO 0);
DECO:IN STD_LOGIC;
ALU: IN STD_LOGIC;        
DIR_INS:IN STD_LOGIC_VECTOR(10 DOWNTO 0);
DIRECCION:OUT STD_LOGIC_VECTOR(12 DOWNTO 0)
 );
END PC;


ARCHITECTURE NARQ OF PC IS  
signal  TEM: STD_LOGIC_VECTOR(12 DOWNTO 0):="0000000000000";  
SIGNAL PCL: STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";  
SIGNAL  PCLATH:  STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000"; 
BEGIN                               
PROCESS (CLKA,CLKB,CLKC,CLKD) 
BEGIN
      --QA incrementa
      --Q4 se pone instrucción en   
      BUSD<="ZZZZZZZZ";  
      IF(CLKA='1' AND CLKA'EVENT) THEN
      			IF(DECO='0')THEN 
	      			DIRECCION<=SATCK;   --HACE RETUN,RETFIE 
	      			TEM<=SATCK;
      			ELSE  
	      				IF DECO='1' THEN
			      		  SATCK<=TEM;   --HACE CALL
			      	
                		ELSE
	      					DIRECCION<=TEM;  
	      					TEM<=TEM+1;      
	      				END IF;
      			END IF;
      			IF(GOT='1')  THEN --CALCULA EL SALTO
      				DIRECCION<=PCLATH(4 DOWNTO 0)&DIR_INS;
      			END IF;
      			
      			
      ELSE    
	      	IF(CLKA='0' AND CLKA'EVENT) THEN
	         ELSE
		      	IF( CLKD='1' AND CLKD'EVENT) THEN
		     			IF ALU='1' THEN          --INCREMENTA SI BTS,BCF,DECFSZ
		      				TEM<=TEM+1;
		      			 END IF;
		        END IF; 
		     END IF;      	
      END IF;

END PROCESS;
END NARQ;
