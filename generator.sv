`ifndef GENERATOR_H_
`define GENERATOR_H_

`include "packet.sv"
`include "common.sv"

class packet_gen_c;
    rand packet_c packet;
    mailbox_of_packets generatorToDriverMailbox;
    
    parameter numOfPacketsCreated = 100;

    function new(mailbox_of_packets generatorToDriverMailbox);
        this.generatorToDriverMailbox = generatorToDriverMailbox;
    endfunction

    function automatic void create_random_packets;
        repeat(numOfPacketsCreated) begin
            if(this.randomize() == 1) begin
                generatorToDriverMailbox.put(packet);
            end else $error("Problem with randomizing generator object");
        end
    endfunction
endclass

`endif