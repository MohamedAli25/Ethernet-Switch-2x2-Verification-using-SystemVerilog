`ifndef MONITOR_H_
`define MONITOR_H_

`include "switch_interface.sv"
`include "packet.sv"
`include "common.sv"

class Monitor;
    virtual SwitchIf.monitor switchInterface;
    bit [31:0] incomingDataFromPortA [];
    bit [31:0] incomingDataFromPortB [];
    mailbox_of_packets monitorToCheckerMailbox; 

    parameter portAAddr = 1;
    parameter portBAddr = 2;

    function new(virtual SwitchIf.monitor switchInterface, ref mailbox_of_packets monitorToCheckerMailbox);
        this.switchInterface = switchInterface;
        this.monitorToCheckerMailbox = monitorToCheckerMailbox;
        this.incomingDataFromPortA = new[0];
        this.incomingDataFromPortB = new[0];
    endfunction

    task automatic sample_data_from_port_A;
        packet_c packet;
        forever begin
            @(posedge switchInterface.outsopA);
            do begin
                incomingDataFromPortA = new[incomingDataFromPortA.size() + 1](incomingDataFromPortA);
                incomingDataFromPortA[incomingDataFromPortA.size() - 1] = switchInterface.ckb.outputA;
                #1;
            end while(switchInterface.ckb.outeopA === 0);
            packet = new(0, portAAddr, incomingDataFromPortA);
            $display("Data: %p", packet);
        end
    endtask

    task automatic sample_data_from_port_B;
        packet_c packet;
        forever begin
            @(posedge switchInterface.outsopB);
            do begin
                incomingDataFromPortB = new[incomingDataFromPortB.size() + 1](incomingDataFromPortB);
                incomingDataFromPortB[incomingDataFromPortB.size() - 1] = switchInterface.ckb.outputB;
                #1;
            end while(switchInterface.ckb.outeopB === 0);
            packet = new(0, portBAddr, incomingDataFromPortB);
            $display("Data: %p", packet);
        end
    endtask
endclass

`endif