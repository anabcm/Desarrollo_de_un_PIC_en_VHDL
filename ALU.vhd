LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;   
USE IEEE.STD_LOGIC_UNSIGNED.ALL;      
USE IEEE.NUMERIC_BIT.ALL       ;

ENTITY ALU IS  
PORT   (      
 CLKC,CLKA: IN   STD_LOGIC;
 INP: IN   STD_LOGIC_VECTOR(4 DOWNTO 0);
 ENTRADA: IN   STD_LOGIC_VECTOR(7 DOWNTO 0);     
 SALIDA: OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);           
 BIT_OPERAR: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  
 SALTA:OUT STD_LOGIC;
 WREG: IN STD_LOGIC_VECTOR(7 DOWNTO 0);       
  STATUSA:OUT STD_LOGIC_VECTOR(2 DOWNTO 0) --SALIDA AL STATUS DE CARRY,Z,DC    
  
);
END ALU;
ARCHITECTURE NARQ OF ALU IS
BEGIN    

PROCESS (CLKC,CLKA) 

	VARIABLE AUX: STD_LOGIC_VECTOR(7 DOWNTO 0); 
	VARIABLE AUX2: STD_LOGIC_VECTOR(3 DOWNTO 0); 
	VARIABLE A,B,C:STD_LOGIC_VECTOR(8 DOWNTO 0);     
	VARIABLE D,E,F:STD_LOGIC_VECTOR(4 DOWNTO 0);   
	VARIABLE S: STD_LOGIC_VECTOR(2 DOWNTO 0):="000"; 
   BEGIN    
   SALTA<='0';                      
  IF CLKA='1' AND CLKA'EVENT THEN
   			SALIDA<="ZZZZZZZZ";
  ELSE
  IF(CLKC='1' AND CLKC'EVENT) THEN
	--STATUSA<="000";
	CASE   INP IS    
   		 WHEN "00001"=>NULL;              --NOP
   		 WHEN "00010"=>SALIDA<=WREG;   --MOVWF
   		 WHEN "00011"=>SALIDA<="00000000";  
   		 				S(2):='1'; 	--CLRF  
   		 WHEN "00100"=>SALIDA<="00000000";  
   		 				S(2):='1';	--CLRW
         WHEN "00101" =>SALIDA<= WREG-ENTRADA;
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --ZERO
         					     A(7 DOWNTO 0):=ENTRADA;B(7 DOWNTO 0):=WREG;C:=A-B;IF (C(8)='1') THEN S(0):='1';END IF;--CARRY   --SUBWF 
         					     D(3 DOWNTO 0):=ENTRADA(3 DOWNTO 0); E(3 DOWNTO 0):=WREG(3 DOWNTO 0);  F:=D-E;         --DC
         						IF(F(4)='1') THEN S(1):='1';END IF;

         WHEN "00110" =>SALIDA<=ENTRADA-1;
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --DECF      
         WHEN "00110" =>SALIDA<=ENTRADA-1;
         						IF(SALIDA="00000000") THEN SALTA<='1'; END IF; --DECF  						
         WHEN "00111" =>SALIDA<=ENTRADA OR WREG;IF(SALIDA="00000000") THEN S(2):='1'; END IF;--IORWF 
         WHEN "01000" =>SALIDA<=ENTRADA AND WREG;IF(SALIDA="00000000") THEN S(2):='1'; END IF;--ANDwf     
                  WHEN "01001" =>SALIDA<=(WREG XOR  ENTRADA);IF(SALIDA="00000000") THEN STATUSA(2)<='1'; END IF; --xORLW    
         WHEN "01010" =>SALIDA<=ENTRADA+WREG; 
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --ZERO
         					     A(7 DOWNTO 0):=ENTRADA;B(7 DOWNTO 0):=WREG;C:=A+B;IF (C(8)='1') THEN S(0):='1';END IF;--CARRY   --SUBWF 
         					     D(3 DOWNTO 0):=ENTRADA(3 DOWNTO 0); E(3 DOWNTO 0):=WREG(3 DOWNTO 0);  F:=D+E;         --DC
         						IF(F(4)='1') THEN S(1):='1';END IF;

         WHEN "01011" =>SALIDA<=ENTRADA ;
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --MOVF  
         WHEN "01100" =>SALIDA<=NOT( ENTRADA ); 
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF;  --COMF
         WHEN "01101" =>SALIDA<=ENTRADA+1 ;    
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --INCF
         WHEN "01110" =>SALIDA<=ENTRADA-1;  --FALTA SKIP IF 0
         WHEN "01111" =>                
                                A(7 DOWNTO 0):=ENTRADA;B:=A ROR 1;IF (B(8)='1') THEN S(0):='1';END IF; --RRF   
                  				AUX:=   ENTRADA ROR 1;
                  				SALIDA<=AUX;

         WHEN "10000" =>
                  				A(7 DOWNTO 0):=ENTRADA;B:=A ROL 1;IF (B(8)='1') THEN S(0):='1';END IF;--RLF 
                  				AUX:=   ENTRADA ROL 1;
                  				SALIDA<= AUX;

         WHEN "10001" =>AUX(7 DOWNTO 4):=ENTRADA(3 DOWNTO 0);AUX(3 DOWNTO 0):=ENTRADA(7 DOWNTO 4);SALIDA<=AUX;    --SWAPF
         WHEN "10010" =>SALIDA<=  ENTRADA+1;IF(SALIDA="00000000") THEN SALTA<='1'; END IF;--INCFSZ FALTA SKIP IF 0
         WHEN "10011" =>  --BCF  
                  CASE  BIT_OPERAR IS  
                  WHEN "000"=>ENTRADA(0)<='0';SALIDA<=ENTRADA; 
                  WHEN "001"=>ENTRADA(1)<='0';SALIDA<=ENTRADA;  
                  WHEN "010"=>ENTRADA(2)<='0';SALIDA<=ENTRADA;
				  WHEN "011"=>ENTRADA(3)<='0';SALIDA<=ENTRADA;
				  WHEN "100"=>ENTRADA(4)<='0';SALIDA<=ENTRADA;
				  WHEN "101"=>ENTRADA(5)<='0';SALIDA<=ENTRADA;
				  WHEN "110"=>ENTRADA(6)<='0';SALIDA<=ENTRADA;
				  WHEN "111"=>ENTRADA(7)<='0';SALIDA<=ENTRADA; 
                  END CASE;    --BCF
          WHEN "10100" =>  --BSF  
                  CASE  BIT_OPERAR IS  
                  WHEN "000"=>ENTRADA(0)<='1';SALIDA<=ENTRADA; 
                  WHEN "001"=>ENTRADA(1)<='1';SALIDA<=ENTRADA;  
                  WHEN "010"=>ENTRADA(2)<='1';SALIDA<=ENTRADA;
				  WHEN "011"=>ENTRADA(3)<='1';SALIDA<=ENTRADA;
				  WHEN "100"=>ENTRADA(4)<='1';SALIDA<=ENTRADA;
				  WHEN "101"=>ENTRADA(5)<='1';SALIDA<=ENTRADA;
				  WHEN "110"=>ENTRADA(6)<='1';SALIDA<=ENTRADA;
				  WHEN "111"=>ENTRADA(7)<='1';SALIDA<=ENTRADA; 
                  END CASE;  
         WHEN "10101" =>  --BTFSC     
         CASE  BIT_OPERAR IS  
                  WHEN "000"=>IF(ENTRADA(0) ='0') THEN  SALTA<='1';END IF;
                  WHEN "001"=>IF(ENTRADA(1) ='0') THEN SALTA<='1'; END IF;
                  WHEN "010"=>IF(ENTRADA(2) ='0') THEN SALTA<='1'; END IF;
                  WHEN "011"=>IF(ENTRADA(3) ='0') THEN SALTA<='1';END IF; 
                  WHEN "100"=>IF(ENTRADA(4) ='0') THEN SALTA<='1';END IF; 
                  WHEN "101"=>IF(ENTRADA(5) ='0') THEN SALTA<='1';END IF; 
                  WHEN "110"=>IF(ENTRADA(6) ='0') THEN SALTA<='1';END IF;
                  WHEN "111"=>IF(ENTRADA(7) ='0') THEN SALTA<='1';END IF; 
          END CASE;    
                                           
 
         WHEN "10110" =>  --BTFSS      
       CASE  BIT_OPERAR IS  
                  WHEN "000"=>IF(ENTRADA(0) ='1') THEN SALTA<='1';END IF; 
                  WHEN "001"=>IF(ENTRADA(1) ='1') THEN SALTA<='1';END IF;      --SUMAMOS 1 AL PC PARA QUE SALTE UNA INSTRUCCION
                  WHEN "010"=>IF(ENTRADA(2) ='1') THEN SALTA<='1';END IF; 
                  WHEN "011"=>IF(ENTRADA(3) ='1') THEN SALTA<='1';END IF; 
                  WHEN "100"=>IF(ENTRADA(4) ='1') THEN SALTA<='1';END IF; 
                  WHEN "101"=>IF(ENTRADA(5) ='1') THEN SALTA<='1';END IF; 
                  WHEN "110"=>IF(ENTRADA(6) ='1') THEN SALTA<='1'; END IF;
                  WHEN "111"=>IF(ENTRADA(7) ='1') THEN SALTA<='1'; END IF;
          END CASE;  
           
          --FALTA CALL Y GOTO PARA PROGRAM CONUNTER 
                                                                                                                  
         WHEN "11001" =>SALIDA<=  ENTRADA+WREG;--ADDLW 
        					 IF(SALIDA="00000000") THEN S(2):='1'; END IF; --ZERO
           					     A(7 DOWNTO 0):=ENTRADA;B(7 DOWNTO 0):=WREG;C:=A+B;IF (C(8)='1') THEN S(0):='1';END IF;--CARRY   --SUBWF 
         					     D(3 DOWNTO 0):=ENTRADA(3 DOWNTO 0); E(3 DOWNTO 0):=WREG(3 DOWNTO 0);  F:=D+E;         --DC
         						IF(F(4)='1') THEN S(1):='1';END IF;
--AdDLW 
                                                        
         WHEN "11101" =>SALIDA<= ( ENTRADA AND WREG);
         						
         WHEN "11110" =>SALIDA<= ENTRADA; --MOVLW      
         WHEN "11100" =>SALIDA<=(WREG OR  ENTRADA);
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --IORLW      
         WHEN "11010" =>SALIDA<= ENTRADA-WREG;  
        					 IF(SALIDA="00000000") THEN S(2):='1'; END IF; --ZERO
           					     A(7 DOWNTO 0):=ENTRADA;B(7 DOWNTO 0):=WREG;C:=A-B;IF (C(8)='1') THEN S(0):='1';END IF;--CARRY   --SUBWF 
         					     D(3 DOWNTO 0):=ENTRADA(3 DOWNTO 0); E(3 DOWNTO 0):=WREG(3 DOWNTO 0);  F:=D-E;         --DC
         						IF(F(4)='1') THEN S(1):='1';END IF;

         WHEN "11011" =>SALIDA<=(WREG XOR  ENTRADA);
         						IF(SALIDA="00000000") THEN S(2):='1'; END IF; --xORLW     
   
   END CASE; 
  END IF;     
  END IF;
          STATUSA<=S;
   END PROCESS;
   END   NARQ;
