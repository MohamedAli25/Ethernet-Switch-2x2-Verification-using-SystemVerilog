`ifndef DRIVER_H_
`define DRIVER_H_

`include "switch_interface.sv"
`include "packet.sv"
`include "common.sv"

class packet_drv_c;
    virtual SwitchIf.driver switchInterface;
    packet_c currentPacket;
    int currentPortAddr;
    mailbox_of_packets generatorToDriverMailbox;
    mailbox_of_packets driverToCheckerMailbox;

    parameter portAAddr = 1;
    parameter portBAddr = 2;

    function new(virtual SwitchIf.driver switchInterface, ref mailbox_of_packets generatorToDriverMailbox, ref mailbox_of_packets driverToCheckerMailbox);
        this.switchInterface = switchInterface;
        this.generatorToDriverMailbox = generatorToDriverMailbox;
        this.driverToCheckerMailbox = driverToCheckerMailbox;
    endfunction

    task automatic operate_on_the_packets;
        while(generatorToDriverMailbox.num() > 0) begin
            currentPacket = generatorToDriverMailbox.get();
            send_packet_to_checker();
            drive_packet_to_dut();
        end
    endtask

    function automatic void send_packet_to_checker();
        driverToCheckerMailbox.put(currentPacket);
    endfunction

    task automatic drive_packet_to_dut();
        if(currentPacket.sa == portAAddr)
            currentPortAddr = portAAddr;
        else if(currentPacket.sa == portBAddr) 
            currentPortAddr = portBAddr;
        else $error("Invalid port address");
        send_packet();
    endtask

    task automatic send_packet;
        send_da();
        send_sa();
        send_data();
        send_crc();
    endtask

    task automatic send_da();
        if(currentPortAddr == portAAddr) switchInterface.ckb.outputA = currentPacket.da;
        else if(currentPortAddr == portBAddr) switchInterface.ckb.outputB = currentPacket.da;
        #1;
    endtask

    task automatic send_sa();
        if(currentPortAddr == portAAddr) switchInterface.ckb.outputA = currentPacket.sa;
        else if(currentPortAddr == portBAddr) switchInterface.ckb.outputB = currentPacket.sa;
        #1;
    endtask

    task automatic send_data();
        foreach(currentPacket.data[i]) begin
            if(currentPortAddr == portAAddr) switchInterface.ckb.outputA = currentPacket.data[i];
            else if(currentPortAddr == portBAddr) switchInterface.ckb.outputB = currentPacket.data[i];
            #1;
        end
    endtask

    task automatic send_crc();
        if(currentPortAddr == portAAddr) switchInterface.ckb.outputA = currentPacket.crc;
        else if(currentPortAddr == portBAddr) switchInterface.ckb.outputB = currentPacket.crc;
        #1;
    endtask

    
endclass

`endif