`include "switch_interface.sv"
`include "monitor.sv"
`include "checker.sv"
`include "common.sv"
`include "driver.sv"
`include "generator.sv"
`include "packet.sv"
`include "switch.v"

module packet_tb_top;
    reg clock = 1;

    always #5 clock = ~clock;

    SwitchIf switch_if(clock);
    Switch switch(
        .clk(switch_if.clk),
        .rstN(switch_if.rstN),
        .inDataA(switch_if.inDataA),
        .insopA(switch_if.insopA),
        .ineopA(switch_if.ineopA),
        .inDataB(switch_if.inDataB),
        .insopB(switch_if.insopB),
        .ineopB(switch_if.ineopB),
        .outDataA(switch_if.outDataA),
        .outsopA(switch_if.outsopA),
        .outeopA(switch_if.outeopA),
        .outDataB(switch_if.outDataB),
        .outsopB(switch_if.outsopB),
        .outeopB(switch_if.outeopB),
        .portAStall(switch_if.portAStall),
        .portBStall(switch_if.portBStall)
    );

mailbox_of_packets generatorToDriverMailbox;
packet_gen_c pkt_gen;
mailbox_of_packets driverToCheckerMailbox;
packet_drv_c pkt_drv;
mailbox_of_packets monitorToCheckerMailbox;
Monitor monitor;
packet_check_c packet_checker;

    initial begin
        
	generatorToDriverMailbox = new;
        pkt_gen=new(generatorToDriverMailbox);

        driverToCheckerMailbox = new;
        
        pkt_drv = new(switch_if, generatorToDriverMailbox, driverToCheckerMailbox);

        monitorToCheckerMailbox = new;
        monitor = new(switch_if, monitorToCheckerMailbox);

        packet_checker = new(driverToCheckerMailbox, monitorToCheckerMailbox);


        pkt_gen.create_random_packets();

        monitor.sample_data_from_port_A();
        monitor.sample_data_from_port_B();

        pkt_drv.operate_on_the_packets();

        packet_checker.filter_packets_from_driver_to_expected_out_ports();
        packet_checker.check_for_correctness();
    end
endmodule
