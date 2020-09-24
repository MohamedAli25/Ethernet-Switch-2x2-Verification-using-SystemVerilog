`ifndef PACKET_H_
`define PACKET_H_

typedef enum int { PACKET_DATA_SIZE_SMALL, PACKET_DATA_SIZE_MEDIUM, PACKET_DATA_SIZE_LARGE, PACKET_DATA_SIZE_ALL } packet_data_size_range;
typedef enum int { PACKET_DATA_FIXED_PATTERN, PACKET_DATA_RANDOM_PATTERN, PACKET_DATA_INCREMENTING_PATTERN } packet_data_pattern;

typedef bit [31:0] dynamic_array_of_32_bits [];

class packet_c;
    rand bit [31:0] sa;
    rand bit [31:0] da;
    dynamic_array_of_32_bits data;
    rand bit [31:0] crc;

    parameter int data_size_lower_boundary = 13;
    parameter int data_size_upper_boundary = 376;
    parameter int data_size_small_medium_boundary = 134;
    parameter int data_size_medium_large_boundary = 255;

    parameter portAAddr = 1;
    parameter portBAddr = 2;

    constraint data_size_in_valid_range { data.size() >= data_size_lower_boundary; data.size() <= data_size_upper_boundary; }
    constraint data_size_small { data.size() <= data_size_small_medium_boundary; }
    constraint data_size_medium { data.size() > data_size_small_medium_boundary; data.size() <= data_size_medium_large_boundary; }
    constraint data_size_large { data.size() > data_size_medium_large_boundary; }

    constraint sa_from_valid_values { sa inside {portAAddr, portBAddr}; }
    constraint da_from_valid_values { da inside {portAAddr, portBAddr}; }

    function new(bit [31:0] sa, bit [31:0] da, dynamic_array_of_32_bits data);
        this.sa = sa;
        this.da = da;
        this.data = data;
        this.crc = crc;
        set_data_size_range(PACKET_DATA_SIZE_ALL);
    endfunction

    function automatic bit [31:0] get_sa();
        return sa;
    endfunction

    function automatic void set_sa(bit [31:0] sa);
        this.sa = sa;
    endfunction

    function automatic bit [31:0] get_da(bit [31:0] da);
        return da;
    endfunction

    function automatic void set_da(bit [31:0] da);
        this.da = da;
    endfunction

    function automatic dynamic_array_of_32_bits get_data();
        this.data = data;
    endfunction

    function automatic set_data(dynamic_array_of_32_bits data);
        this.data = data;
    endfunction

    function automatic bit [31:0] get_crc(bit [31:0] crc);
        return crc;
    endfunction

    function automatic void set_crc(bit [31:0] crc);
        this.crc = crc;
    endfunction

    function automatic void set_data_size_range(packet_data_size_range dataSizeRange);
        disable_size_range_constraints();
        case(dataSizeRange)
            PACKET_DATA_SIZE_SMALL: begin
                data_size_small.constraint_mode(1);
            end
            PACKET_DATA_SIZE_MEDIUM: begin
                data_size_medium.constraint_mode(1);
            end
            PACKET_DATA_SIZE_LARGE: begin
                data_size_large.constraint_mode(1);
            end
            PACKET_DATA_SIZE_ALL: begin end
            default: $error("Invalid packet data size");
        endcase
    endfunction

    function automatic void disable_size_range_constraints();
        data_size_small.constraint_mode(0);
        data_size_medium.constraint_mode(0);
        data_size_large.constraint_mode(0);
    endfunction

    // TODO Finish the data pattern constraints
    function automatic void set_data_pattern(packet_data_pattern dataPattern);
        case(dataPattern)
            PACKET_DATA_FIXED_PATTERN: begin
                
            end
            PACKET_DATA_RANDOM_PATTERN: begin
                
            end
            PACKET_DATA_INCREMENTING_PATTERN: begin
                
            end
        endcase
    endfunction

endclass

`endif