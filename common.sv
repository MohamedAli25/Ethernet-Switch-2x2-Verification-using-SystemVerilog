`ifndef COMMON_H_
`define COMMON_H_

`include "packet.sv";

typedef mailbox #(packet_c) mailbox_of_packets;

`define PORT_A_ADDR 1
`define PORT_B_ADDR 2

`endif