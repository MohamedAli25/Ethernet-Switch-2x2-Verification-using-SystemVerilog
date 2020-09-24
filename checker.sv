`ifndef CHECKER_H_
`define CHECKER_H_

`include "common.sv"
`include "packet.sv"

class packet_check_c;
    mailbox_of_packets driverToCheckerMailbox;
    mailbox_of_packets monitorToCheckerMailbox;
    mailbox_of_packets expectedOutPortAPackets;
    mailbox_of_packets expectedOutPortBPackets;

    parameter portAAddr = 1;
    parameter portBAddr = 2;

    function new(ref mailbox_of_packets driverToCheckerMailbox, ref mailbox_of_packets monitorToCheckerMailbox);
        this.driverToCheckerMailbox = driverToCheckerMailbox;
        this.monitorToCheckerMailbox = monitorToCheckerMailbox;
        this.expectedOutPortAPackets = new;
        this.expectedOutPortBPackets = new;
    endfunction

    function automatic void filter_packets_from_driver_to_expected_out_ports;
        packet_c currentPacket;
        while(driverToCheckerMailbox.num() > 0) begin
            currentPacket = driverToCheckerMailbox.get();
            if(currentPacket.da == portAAddr) expectedOutPortAPackets.put(currentPacket);
            else if(currentPacket.da == portBAddr) expectedOutPortBPackets.put(currentPacket);
        end
    endfunction

    function automatic void check_for_correctness;
        packet_c currentPacketComingFromMonitor;
        packet_c topPacketInOutPortMailbox;
        while(monitorToCheckerMailbox.num() > 0) begin
            currentPacketComingFromMonitor = monitorToCheckerMailbox.get();
            if(currentPacket.da == portAAddr) topPacketInOutPortMailbox = expectedOutPortAPackets;
            else if(currentPacket.da == portBAddr) topPacketInOutPortMailbox = expectedOutPortBPackets;
            if(!are_packets_equal(currentPacketComingFromMonitor, topPacketInOutPortMailbox)) $error("Packets are not equal");
        end
    endfunction

    function automatic bit are_packets_equal(ref packet_c packet1, ref packet_c packet2);
        bit result = 1;
        if(packet1.data.size() !== packet2.data.size()) result = 0;
        else begin
            foreach(packet1.data[i]) begin
                result = result & (packet1.data[i] === packet2.data[i]);
            end
        end
        return result;
    endfunction
endclass

`endif