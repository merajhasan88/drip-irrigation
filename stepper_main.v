module stepper_main(clock,motors);

input clock;
output [11:0] motors; //4 pins each for three motors

stepper_test stepper_1(
.clock(clock),
.stepperPins(motors[3:0])
);

stepper_test stepper_2(
.clock(clock),
.stepperPins(motors[7:4])
);

stepper_test stepper_3(
.clock(clock),
.stepperPins(motors[11:8])
);

endmodule