----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:19:09 11/16/2018 
-- Design Name: 
-- Module Name:    lift - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lift is
port( R, Clk_in, call0, call1, call2, enable, bs, mps, mms, ts: in std_logic;
            ind0, ind1, ind2, tp, b, m, mp, mm, upOut, downOut, cout: out std_logic:='0');	
end lift;

architecture Behavioral of lift is
type state is (top,bottom,middle, mplus, mmin);
	signal PS,NS : state := bottom;
	signal C,cdir, up, down:std_logic :='0';
	signal in0,in1, in2 :std_logic :='0';
	signal listen:std_logic :='1';
	shared variable cnt: Integer :=0;	

begin
process(Clk_in)
	begin
		if(rising_edge(Clk_in)) then
			cnt := cnt + 1;
			if(cnt > 5000) then
				cnt:=0;
			end if;
		end if;
		
		if(cnt < 2500) then
			C <= '0';
		else
			C <='1';
		end if;
		cout <= C;
	end process;
	--C <= Clk_in;
	process (C)
	begin
--	if (enable ='1') then
--		PS <= bottom;
--		move :=2;
	if (rising_edge(C)) then
		PS <= NS;
	end if;
	end process;
	
	process(C)
	begin


		if(R = '1') then
			ind0 <= '1';
			in0 <= '1';
			listen <= '0';
			up<='0';
			down<='1';
			
		end if;



		if(listen = '1') then
		ind0 <= '0';
		in0 <= '0';
		ind1 <= '0';
		in1 <= '0';
		ind2 <= '0';
		in2 <= '0';
			if(call0='1') then
				ind0 <= '1';
				in0 <= '1';
				if(PS = top) then
					listen <= '0';
					up<='0';
					down<='1';
				end if;
				
				if(PS=middle) then
					listen <= '0';
					up<='0';
					down<='1';
				end if;
			end if;
			
			if(call1='1') then
				ind1 <= '1';
				in1 <= '1';
				if(PS = top) then
					listen <= '0';
					up<='0';
					down<='1';
				end if;
				
				if(PS=bottom) then
					listen <= '0';
					up<='1';
					down<='0';
				end if;
			end if;
			
			if(call2='1') then
				ind2 <= '1';
				in2 <= '1';
				if(PS = bottom) then
					listen <= '0';
					up<='1';
					down<='0';
			end if;
				
				if(PS=middle) then
					listen <= '0';
					up<='1';
					down<='0';
				end if;
			end if;
			
		end if;
		if( bs = '1') then
			NS <= bottom;

			if(in0 = '1') then
			ind0 <= '0';
			in0 <= '0';
			listen<='1';
			end if;
		end if;	
 		
		if( mms = '1') then
			NS <= mmin;
			tp<='0';
			m<='0';
			b<='0';
			mp <= '0';
			mm <= '1';
		end if;
		
		
		if( mps = '1') then
			NS <= mplus;
			tp<='0';
			m<='0';
			b<='0';
			mp <= '1';
			mm <= '0';
		end if;
		
		if( mms = '1' and mps = '1') then
			NS <= middle;
			
			if(in1 = '1') then 
			ind1 <= '0';
			in1 <= '0';
			listen<='1';
			end if;
 			
		end if;
		
		if(ts = '1') then
			NS <= top;
			
			if(in2 = '1') then 
			ind2 <= '0';
			in2 <= '0';
			listen<='1';
 			end if;
			
		end if;	
		
		
		
		if(PS=top ) then
			tp<='1';
			m<='0';
			b<='0';
			mp <= '0';
			mm <= '0';
			if( in0 = '0' and in1 = '0' and in2 = '0') then  
					listen<='1';
					up<='0';
					down<='0';
		end if;
			
		elsif(PS=middle) then
				m<='1';
				b<='0';
				tp<='0';
				mp <= '0';
				mm <= '0';
				if( in0 = '0' and in1 = '0' and in2 = '0') then  
					listen<='1';
					up<='0';
					down<='0';
		end if;
				
		elsif(PS=bottom ) then
				b<='1';
				m<='0';
				tp<='0';
				mp <= '0';
				mm <= '0';
				if( in0 = '0' and in1 = '0' and in2 = '0') then  
					listen<='1';
					up<='0';
					down<='0';
		end if;
				
		end if;


		upOut <= up and enable;
		downOut <= down and enable;
	end process;
	
	
	

end Behavioral;
