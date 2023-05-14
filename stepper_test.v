//module stepper_test(start,clock,Step_EN,stepperPins,LED_test);
//module stepper_test(start,clock,Step_EN,Pin69,Pin70,Pin71,Pin72,LED_test);
module stepper_test(clock,stepperPins);
localparam FIRST_DIVIDER = 999999999; //20 SEC DELAY
localparam SECOND_DIVIDER = 50000000;//original = 50000000
localparam THIRD_DIVIDER = 500000000;  //10 sec delay
localparam FOURTH_DIVIDER = 5000000;
localparam FIFTH_DIVIDER = 500000000;
localparam PULSE_DIVIDER = 4900;
localparam N = 5;
//input start;
input clock;
//input Step_EN;
//output [3:0] Pins_stepper ;
output reg [3:0] stepperPins;
//reg [3:0] stepperPins;
reg Pin69;
reg Pin70;
reg Pin71;
reg Pin72;
reg [7:0] compare924 = 8'd74; //lesser than 80 wont work so we take 80 as '1'.
reg [7:0] compare383 = 8'd31; 
reg [7:0] compare707 = 8'd57; 
reg [31:0] clockCount1;
reg [3:0] secondsCounter;
reg [31:0] clockCount3;
reg [63:0] countPulse = 1'b0;
reg [200:0] countPulse1= 1'b0;
reg [200:0] countPulse2= 1'b0;
reg [200:0] countPulse3= 1'b0;
reg [200:0] countPulse4= 1'b0;
reg [200:0] countPulse5= 1'b0;


//output reg LED_test;
reg [255:0] time_in [N-1:0];
reg [3:0] pulse;
reg count_ONCE = 1'b0;
reg trigger;
reg CW_DIR = 1'b0;
reg pin1;
reg pin0;
//reg [3:0] Pins_stepper ;
reg [3:0] step ;
reg [3:0] step_reverse;
reg pwm_d924, pwm_q924, pwm_d383, pwm_q383, pwm_d707, pwm_q707; 
reg [7: 0] ctr_d924, ctr_q924 = 1'b0;
reg [7: 0] ctr_d383, ctr_q383 = 1'b0;
reg [7: 0] ctr_d707, ctr_q707 = 1'b0;
integer i, j;
initial
begin
//step = 0;
time_in[0]<=255'd990000000; // 20 sec with 255'd990000000. 6 minute 40 sec with 255'd20000000000 
time_in[1]<=255'd480000000; //4 sec with 255'd200000000
time_in[2]<=255'd90000000; //40 sec
time_in[3]<=255'd480000000; //4 sec
time_in[4]<=255'd20000000; //40 sec
pin1 <= 1;
pin0 <= 0;
// //8 positions for half step//initial
////LED_test <= ~start;
////Pin69 <= 0;
////Pin70 <= 0;
////Pin71 <= 0;
////Pin72 <= 0;
end

//always @(posedge clk && start)
//begin
//step <= step + 4'b0001;
//end
always @(*) 
begin 
ctr_d924 <= ctr_q924 + 1'b1;
ctr_d383 <= ctr_q383 + 1'b1;
ctr_d707 <= ctr_q707 + 1'b1;
//compare <= 8'd70; 
if (compare924 > ctr_q924) 
pwm_d924 = 1'b1; 
else pwm_d924 = 1'b0;

if (compare383 > ctr_q383) 
pwm_d383 = 1'b1; 
else pwm_d383 = 1'b0;

if (compare707 > ctr_q707) 
pwm_d707 = 1'b1; 
else pwm_d707 = 1'b0; 
end

always @(posedge clock)
begin
//time_in[0]<=10000000; //1 sec delay
//time_in[1]<=490000; //too fast to be seen
//time_in[2]<=216'd200000000; //4 sec delay
//time_in[3]<=216'd2000000000; //38 second delay
//time_in[4]<=216'd200000000000; //also 40 second delay. try nested if with five different timers
//time_in[0]<=216'd200000000; //40 sec 
//time_in[1]<=216'd20000000; //8 sec
//time_in[2]<=216'd900000000; //40 sec
//time_in[3]<=216'd20000000; //8 sec
//time_in[4]<=216'd200000000; //40 sec
if(pulse==4'b0101)
begin
pulse<= 4'b0000;
end

if(countPulse1 == time_in[0])
begin
countPulse1 <= 200'b0;
pulse <= pulse + 1'b1;
//pulse <= ~pulse;
//if(countPulse2 == time_in[1])
//begin
//countPulse2 <= 200'b0;
//pulse <= ~pulse;
//if(countPulse3 == time_in[2])
//begin
//countPulse3 <= 200'b0;
//pulse <= ~pulse;
//if(countPulse4 == time_in[3])
//begin
//countPulse4 <= 200'b0;
//pulse <= ~pulse;
//if(countPulse5 == time_in[4])
//begin
//countPulse5 <= 200'b0;
//pulse <= ~pulse;
//end
//else
//begin
//countPulse5 <= countPulse5 + 1'b1;
//end
//
//end
//else
//begin
//countPulse4 <= countPulse4 + 1'b1;
//end
//
//end
//else
//begin
//countPulse3 <= countPulse3 + 1'b1;
//end
//
//end
//else
//begin
//countPulse2 <= countPulse2 + 1'b1;
//end
//
end
else 
begin
countPulse1 <= countPulse1 + 1'b1;
end

//end
stepperPins[3] <= Pin69;
stepperPins[2] <= Pin70;
stepperPins[1] <= Pin71;
stepperPins[0] <= Pin72;
//LED_test <= pulse;
end
always @(posedge clock && pulse)
begin
case(pulse)
0: trigger <= pin0;
1: begin
	if(countPulse3 == time_in[1])
	begin
	trigger <= pin0;
	count_ONCE <= 1'b1;
	countPulse3 <= 200'b0;
	end
	else if(count_ONCE == 1'b0)
	begin
	trigger <= pin1;
	countPulse3 <= countPulse3 + 1'b1;
	end
	end
2: begin trigger <= pin0; count_ONCE <= 1'b0; end
3: begin
	if(countPulse3 == time_in[3])
	begin
	trigger <= pin0;
	count_ONCE <= 1'b1;
	countPulse3 <= 200'b0;
	end
	else if(count_ONCE == 1'b0)
	begin
	trigger <= pin1;
	countPulse3 <= countPulse3 + 1'b1;
	end
	end
4: begin
	trigger <= pin0;
	count_ONCE <= 1'b0;
	end
endcase
//LED_test <= trigger;
end

always @(posedge clock && trigger)
begin
countPulse <= countPulse + 1'b1;
//if (compare383 > countPulse) 
//pulse= 1; 
//else pulse = 0;

//if(countPulse == SECOND_DIVIDER*3) countPulse <= 1'b0;

//LED_test <= pulse;
if(countPulse == SECOND_DIVIDER*5)
	begin
	countPulse <= 1'b0;
	for(i=0;i<PULSE_DIVIDER;i=i+1)
	begin
	//pulse <=  ~pulse;
	CW_DIR <= ~CW_DIR;
	end
	end
	else
	begin
	
	countPulse <= countPulse + 1'b1;
	end
	
//LED_test <= CW_DIR;
end
always @(posedge clock && trigger)
//always @(posedge clock && ~Step_EN)
//always @ (start)
begin

//if(secondsCounter == 4'b1111) //no need for this
  //    secondsCounter <= 1'b0;
 
    clockCount1 = clockCount1 + 1'b1;
	 
	 if(clockCount1 == 180000)//with steps populated here, speed of steps of motor
													//can be precisely controlled. 180k being optimal
   // if(clockCount1 == SECOND_DIVIDER) 
        begin
            clockCount1 <= 1'b0;
				step <= step + 1'b1;
				step_reverse <= step_reverse + 1'b1;
            //secondsCounter <= secondsCounter + 1'b1;
        end
		  
ctr_q924 <= ctr_d924; 
ctr_q383 <= ctr_d383; 
ctr_q707 <= ctr_d707; 
 
pwm_q924 <= pwm_d924;
pwm_q383 <= pwm_d383;
pwm_q707 <= pwm_d707; 		  
//LED_test = start;
//if (start)
//begin
//if(step<9)
//begin
//step = step + 1;
//end
//else
//begin
//step = 1;
//end
//end
//This below works with posedge clk && start, just before end
//LED_test <= start;
//Pin69 <= ~start;
//Pin70 <= ~start;
//Pin71 <= start;
//Pin72 <= start;
end
//parameter STEPPER_DIVIDER = 50000; // every 1ms
//always @ (posedge clock && ~Step_EN)
//begin
//    if(~Step_EN && clockCount3 >= STEPPER_DIVIDER * (secondsCounter + 1)) //FInishing this secondsCounter here
//																									// means motor turns fast and smooth without steps
//		//if(~Step_EN && clockCount3 >= STEPPER_DIVIDER)
//        begin
////            step <= step + 1'b1;
////				step_reverse <= step_reverse + 1'b1; //Commenting them here and putting them
//																//in above block results in very slow steps
//            clockCount3 <= 1'b0;
//				
//        end
//    else
//        begin
//		  clockCount3 <= clockCount3 + 1'b1;
//		  
//		  end
//
////ctr_q924 <= ctr_d924; 
////ctr_q383 <= ctr_d383; 
////ctr_q707 <= ctr_d707; 
//// 
////pwm_q924 <= pwm_d924;
////pwm_q383 <= pwm_d383;
////pwm_q707 <= pwm_d707; 
//end
always @ ((step || step_reverse) && (CW_DIR || ~CW_DIR))
begin
//Pin69<=pwm_q;
if(~CW_DIR)
begin
case (step)
//Half-step:
//0: stepperPins <= 4'b1000;
//1: stepperPins <= 4'b1100;
//2: stepperPins <= 4'b0100;
//3: stepperPins <= 4'b0110;
//4: stepperPins <= 4'b0010;
//5: stepperPins <= 4'b0011;
//6: stepperPins <= 4'b0001;
//7: stepperPins <= 4'b1001;
//Full step:
//0: stepperPins <= 4'b1000;
//1: stepperPins <= 4'b0100;
//2: stepperPins <= 4'b0010;
//3: stepperPins <= 4'b0001;
//CCW Full step
//0: stepperPins <= 4'b0001;
//1: stepperPins <= 4'b0010;
//2: stepperPins <= 4'b0100;
//3: stepperPins <= 4'b1000;
//turn 90 degree
//0: stepperPins <= 4'b1100;
//1: stepperPins <= 4'b0110;
//2: stepperPins <= 4'b0011;
//3: stepperPins <= 4'b1001;
//180 to 210 degrees
//0: stepperPins <= 4'b1000;
//1: stepperPins <= 4'b0100;
//2: stepperPins <= 4'b0010;
//3: stepperPins <= 4'b0001;
//4: stepperPins <= 4'b1000;
//5: stepperPins <= 4'b0100;
//6: stepperPins <= 4'b0010;
//7: stepperPins <= 4'b0001;
//90 degrees
//0: stepperPins <= 4'b1110;
//1: stepperPins <= 4'b0111;
//2: stepperPins <= 4'b1011;
//3: stepperPins <= 4'b1101;
//180
//0: stepperPins <= 4'b1100;
//1: stepperPins <= 4'b1110;
//2: stepperPins <= 4'b0110;
//3: stepperPins <= 4'b0111;
//4: stepperPins <= 4'b0011;
//5: stepperPins <= 4'b1011;
//6: stepperPins <= 4'b1001;
//7: stepperPins <= 4'b1101;
//turn 30 degree cw with step_reverse below
//0: stepperPins <= 4'b1100;
//1: stepperPins <= 4'b0110;
//2: stepperPins <= 4'b0011;
//3: stepperPins <= 4'b1001;
//7: stepperPins <= 4'b0011;
//8: stepperPins <= 4'b0110;



//To an angle?
//0: stepperPins <= 4'b1100;
//1: stepperPins <= 4'b0011;

//0: begin Pin69 <= pin1; Pin71 <= pin0; Pin70 <= pin0; Pin72 <= pin0;end
//1: begin Pin69 <= pin1; Pin71 <= pin1; Pin70 <= pin0; Pin72 <= pin0;end
//2: begin Pin69 <= pin0; Pin71 <= pin1; Pin70 <= pin0; Pin72 <= pin0;end
//3: begin Pin69 <= pin0; Pin71 <= pin1; Pin70 <= pin1; Pin72 <= pin0;end
//4: begin Pin69 <= pin0; Pin71 <= pin0; Pin70 <= pin1; Pin72 <= pin0;end
//5: begin Pin69 <= pin0; Pin71 <= pin0; Pin70 <= pin1; Pin72 <= pin1;end
//6: begin Pin69 <= pin0; Pin71 <= pin0; Pin70 <= pin0; Pin72 <= pin1;end
//7: begin Pin69 <= pin1; Pin71 <= pin0; Pin70 <= pin0; Pin72 <= pin1;end

0: begin Pin69 <= pin1; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin0;end
1: begin Pin69 <= pwm_q924; Pin70 <= pwm_q383; Pin71 <= pin0; Pin72 <= pin0;end
2: begin Pin69 <= pwm_q707; Pin70 <= pwm_q707; Pin71 <= pin0; Pin72 <= pin0;end
3: begin Pin69 <= pwm_q383; Pin70 <= pwm_q924; Pin71 <= pin0; Pin72 <= pin0;end
4: begin Pin69 <= pin0; Pin70 <= pin1; Pin71 <= pin0; Pin72 <= pin0;end
5: begin Pin69 <= pin0; Pin70 <= pwm_q924; Pin71 <= pwm_q383; Pin72 <= pin0;end
6: begin Pin69 <= pin0; Pin70 <= pwm_q707; Pin71 <= pwm_q707; Pin72 <= pin0;end
7: begin Pin69 <= pin0; Pin70 <= pwm_q383; Pin71 <= pwm_q924; Pin72 <= pin0;end
8: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin1; Pin72 <= pin0;end
9: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q924; Pin72 <= pwm_q383;end
10: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q707; Pin72 <= pwm_q707;end
11: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q383; Pin72 <= pwm_q924;end
12: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin1;end
13: begin Pin69 <= pwm_q383; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q924;end
14: begin Pin69 <= pwm_q707; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q707;end
15: begin Pin69 <= pwm_q924; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q383;end

//2: begin Pin69 <= pin0; Pin70 <= pin1; Pin71 <= pin0; Pin72 <= pin0;end
//3: begin Pin69 <= pin0; Pin70 <= pwm_q; Pin71 <= pwm_q; Pin72 <= pin0;end
//4: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin1; Pin72 <= pin0;end
//5: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q; Pin72 <= pwm_q;end
//6: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin1;end
//7: begin Pin69 <= pwm_q; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q;end
//0: begin Pin69 <= 1;end
//1: begin Pin71 <= 1;end
//2: begin Pin70 <= 0;end
//3: begin Pin72 <= 1;end
//0: begin Pin69 <= 1;Pin70 <= 0;Pin71 <= 0;Pin72 <= 0;end
//1: begin Pin69 <= 1;Pin70 <= 1;Pin71 <= 0;Pin72 <= 0;end
//2: begin Pin69 <= 0;Pin70 <= 1;Pin71 <= 0;Pin72 <= 0;end
//3: begin Pin69 <= 0;Pin70 <= 1;Pin71 <= 1;Pin72 <= 1;end
//4: begin Pin69 <= 0;Pin70 <= 0;Pin71 <= 1;Pin72 <= 0;end
//5: begin Pin69 <= 0;Pin70 <= 0;Pin71 <= 1;Pin72 <= 1;end
//6: begin Pin69 <= 0;Pin70 <= 0;Pin71 <= 0;Pin72 <= 1;end
//7: begin Pin69 <= 1;Pin70 <= 0;Pin71 <= 0;Pin72 <= 1;end
//8: begin step <= 4'b0000; end
//if (step == 4'b1000)
//begin
//step = 4'b0000;
//end
endcase
end
else
begin
case (step_reverse)
0: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin1;end
1: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q383; Pin72 <= pwm_q924;end
2: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q707; Pin72 <= pwm_q707;end
3: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q924; Pin72 <= pwm_q383;end
4: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin1; Pin72 <= pin0;end
5: begin Pin69 <= pin0; Pin70 <= pwm_q383; Pin71 <= pwm_q924; Pin72 <= pin0;end
6: begin Pin69 <= pin0; Pin70 <= pwm_q707; Pin71 <= pwm_q707; Pin72 <= pin0;end
7: begin Pin69 <= pin0; Pin70 <= pwm_q924; Pin71 <= pwm_q383; Pin72 <= pin0;end
8: begin Pin69 <= pin0; Pin70 <= pin1; Pin71 <= pin0; Pin72 <= pin0;end
9: begin Pin69 <= pwm_q383; Pin70 <= pwm_q924; Pin71 <= pin0; Pin72 <= pin0;end
10: begin Pin69 <= pwm_q707; Pin70 <= pwm_q707; Pin71 <= pin0; Pin72 <= pin0;end
11: begin Pin69 <= pwm_q924; Pin70 <= pwm_q383; Pin71 <= pin0; Pin72 <= pin0;end
12: begin Pin69 <= pin1; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin0;end
13: begin Pin69 <= pwm_q924; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q383;end
14: begin Pin69 <= pwm_q707; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q707;end
15: begin Pin69 <= pwm_q383; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q924;end
endcase
end
//case(step_reverse)
////turns 30 degrees with 90 degree hs cw above
//7: stepperPins <= 4'b0011;
//8: stepperPins <= 4'b0110;
//
//endcase
end


//always @(step_reverse && ~CW_DIR)
//begin
//case (step_reverse)
//0: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin1;end
//1: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q383; Pin72 <= pwm_q924;end
//2: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q707; Pin72 <= pwm_q707;end
//3: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pwm_q924; Pin72 <= pwm_q383;end
//4: begin Pin69 <= pin0; Pin70 <= pin0; Pin71 <= pin1; Pin72 <= pin0;end
//5: begin Pin69 <= pin0; Pin70 <= pwm_q383; Pin71 <= pwm_q924; Pin72 <= pin0;end
//6: begin Pin69 <= pin0; Pin70 <= pwm_q707; Pin71 <= pwm_q707; Pin72 <= pin0;end
//7: begin Pin69 <= pin0; Pin70 <= pwm_q924; Pin71 <= pwm_q383; Pin72 <= pin0;end
//8: begin Pin69 <= pin0; Pin70 <= pin1; Pin71 <= pin0; Pin72 <= pin0;end
//9: begin Pin69 <= pwm_q383; Pin70 <= pwm_q924; Pin71 <= pin0; Pin72 <= pin0;end
//10: begin Pin69 <= pwm_q707; Pin70 <= pwm_q707; Pin71 <= pin0; Pin72 <= pin0;end
//11: begin Pin69 <= pwm_q924; Pin70 <= pwm_q383; Pin71 <= pin0; Pin72 <= pin0;end
//12: begin Pin69 <= pin1; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pin0;end
//13: begin Pin69 <= pwm_q924; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q383;end
//14: begin Pin69 <= pwm_q707; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q707;end
//15: begin Pin69 <= pwm_q383; Pin70 <= pin0; Pin71 <= pin0; Pin72 <= pwm_q924;end
//endcase
//end
//always @(negedge clk && start)
//always @ (start)
//begin
//LED_test = start;
//if (start)
//begin
//step <= step + 4'b0001;
//LED_test <= ~start;
//Pin69 <= ~start;
//Pin70 <= ~start;
//Pin71 <= start;
//Pin72 <= ~start;
//end
//
//if (step == 4'b1000)
//begin
//step = 4'b0000;
//end
//end
//always @ (step) 
//begin
//case (step)
//0: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 0;Pin72 <= 0;end
//1: begin Pin69 <= 1;Pin71 <= 1;Pin70 <= 0;Pin72 <= 0;end
//2: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 1;Pin72 <= 0;end
//3: begin Pin69 <= 1;Pin71 <= 0;Pin70 <= 0;Pin72 <= 1;end
//4: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 0;Pin72 <= 0;end
//5: begin Pin69 <= 1;Pin71 <= 1;Pin70 <= 0;Pin72 <= 0;end
//6: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 1;Pin72 <= 0;end
//7: begin Pin69 <= 1;Pin71 <= 0;Pin70 <= 0;Pin72 <= 1;end
////0: begin Pin69 <= 1;Pin71 <= 0;Pin70 <= 0;Pin72 <= 0;end
////1: begin Pin69 <= 0;Pin71 <= 1;Pin70 <= 0;Pin72 <= 0;end
////2: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 1;Pin72 <= 0;end
////3: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 0;Pin72 <= 1;end
////4: begin Pin69 <= 1;Pin71 <= 0;Pin70 <= 0;Pin72 <= 0;end
////5: begin Pin69 <= 0;Pin71 <= 1;Pin70 <= 0;Pin72 <= 0;end
////6: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 1;Pin72 <= 0;end
////7: begin Pin69 <= 0;Pin71 <= 0;Pin70 <= 0;Pin72 <= 1;end
//endcase
//
//end

endmodule