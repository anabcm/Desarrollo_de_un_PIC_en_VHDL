--MUXMUTANTE                 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ADDMUX IS  
PORT (      
RESET,CLKB,CLKD,CLKC,CLKA: IN STD_LOGIC;
DIRADD:IN STD_LOGIC_VECTOR(6 DOWNTO 0); 		 --DIRECTO
--INDADD:IN STD_LOGIC_VECTOR(7 DOWNTO 0);           --INDIRECTO     
BUSD:INOUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
STATIN:IN STD_LOGIC_VECTOR(2 DOWNTO 0);           --ENTRADA A STATUS
DIRECCION: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);      --DIRECCION GENERADA
E: IN STD_LOGIC;            
E_RAM:OUT STD_LOGIC;
 LEER: IN STD_LOGIC;
 ESCRIBIR: IN STD_LOGIC
);
END ADDMUX;


ARCHITECTURE NARQ OF ADDMUX IS  
signal STATUS: STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";         --!irp!rp1!rp0!  to!pd!z!dc!c
signal FSR: STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";        
signal  PCL: STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";     
BEGIN  
PROCESS (CLKA,CLKB,CLKD,CLKC,STATIN,E)     --CALCULA LA DIRECCION  a buscar en RAM  
VARIABLE AUX:STD_LOGIC_VECTOR(8 DOWNTO 0); 
BEGIN     

    IF(STATIN 'EVENT ) THEN                      
	           STATUS(2 DOWNTO 0)<=STATIN;
		ELSE  
		IF(CLKA'EVENT AND CLKA='1')  THEN  
		CASE DIRADD IS
					WHEN "0000000" => --DIRECCINAMIENTO INDIRECTO 
							   AUX(7 DOWNTO 0):=FSR(7 DOWNTO 0);
					           AUX(8):=STATUS(7);E_RAM<='1';                          
					           --END CASE;
							   DIRECCION<=AUX;
					           BUSD<="ZZZZZZZZ"; 
					WHEN "0000011"=>E_RAM<='0';BUSD<="ZZZZZZZZ"; --STATUS
					WHEN "0000100"=>E_RAM<='0';BUSD<="ZZZZZZZZ"; --FSR
					 WHEN OTHERS =>    
					           DIRECCION(6 DOWNTO 0)<=DIRADD(6 DOWNTO 0);
					           DIRECCION(7)<=STATUS(5);   
					           DIRECCION(8)<=STATUS(6);
					             E_RAM<='1';     
					             BUSD<="ZZZZZZZZ"; 
	   END CASE;


		
		ELSE

		IF(CLKB'EVENT AND CLKB='1') THEN  
	        IF(ESCRIBIR='1') THEN
	    		--E_RAM<='0';
	            
				CASE DIRADD IS
			        WHEN "0000000" =>E_RAM<='0';
			        		   CASE FSR IS
							   WHEN "00000000"=>BUSD<="00000000" ;E_RAM<='0'; --BUSD<="ZZZZZZZZ"; 
							   WHEN "00000011"=>BUSD<=STATUS;  E_RAM<='0';
							   WHEN "00000100"=>BUSD<=FSR ; E_RAM<='0';
							   WHEN "00000010"=>BUSD<=PCL ; E_RAM<='0';
				               WHEN      OTHERS=> E_RAM<='1';  BUSD<="ZZZZZZZZ"; 
                               END CASE;
			                    BUSD<="ZZZZZZZZ";
					WHEN "0000010" =>BUSD<=FSR;E_RAM<='0';--PCL      
					WHEN "0000011"=>BUSD<=STATUS;E_RAM<='0';--STATUS
					--WHEN "0000100"=>BUSD<=FSR;E_RAM<='0';--FSR  --deco no le diga cuando sea movwf y sea FRS
					
				    WHEN OTHERS =>    
					           E_RAM<='1';     
					             BUSD<="ZZZZZZZZ";
				END CASE;
			ELSE
			    BUSD<="ZZZZZZZZ";
			
				IF(CLKD 'EVENT AND CLKD='1') THEN
					IF(LEER='0') THEN 
						E_RAM<='0';
				    	CASE DIRADD IS  
				    	     WHEN "0000000" =>E_RAM<='0';
			        		   CASE FSR IS
								   
								   WHEN "00000011"=>STATUS<=BUSD;  E_RAM<='0';
								   WHEN "00000100"=>FSR<=BUSD; E_RAM<='0';
								   WHEN "00000010"=>PCL<=BUSD ; E_RAM<='0';
					               WHEN      OTHERS=> E_RAM<='1';
                               END CASE;

						    WHEN "0000010" =>PCL<=BUSD;--PCL      
							WHEN "0000011"=>STATUS<=BUSD;--STATUS
							WHEN "0000100"=>FSR<=BUSD;--FSR 
							WHEN OTHERS => E_RAM<='1';
			        	END CASE;
				 	END IF;
				ELSE 
						BUSD<="ZZZZZZZZ";
						IF(CLKC='1' AND CLKC'EVENT) THEN  
							BUSD<="ZZZZZZZZ"; 
						END IF;
	            END IF; 
		  		--	BUSD<="ZZZZZZZZ";
			END IF;                          --ENDCLKD
         	END IF; 			   --END CLKB
		END IF;          --END CLKA
	END IF;  --END STATUS
	
                          
 
		
END PROCESS; 


END NARQ;                                                                     
