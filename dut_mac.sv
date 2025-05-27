//---------------------------------------------------------------------------
// DUT - 564/464 Project
//---------------------------------------------------------------------------
`include "common.vh"

module MyDesign(
//---------------------------------------------------------------------------
//System signals
  input wire reset_n                      ,  
  input wire clk                          ,

//---------------------------------------------------------------------------
//Control signals
  input wire dut_valid                    , 
  output wire dut_ready                   ,

//---------------------------------------------------------------------------
//input SRAM interface
  output wire                           dut__tb__sram_input_write_enable  ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_input_write_address ,
  output wire [`SRAM_DATA_RANGE     ]   dut__tb__sram_input_write_data    ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_input_read_address  , 
  input  wire [`SRAM_DATA_RANGE     ]   tb__dut__sram_input_read_data     ,     

//weight SRAM interface
  output wire                           dut__tb__sram_weight_write_enable  ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_weight_write_address ,
  output wire [`SRAM_DATA_RANGE     ]   dut__tb__sram_weight_write_data    ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_weight_read_address  , 
  input  wire [`SRAM_DATA_RANGE     ]   tb__dut__sram_weight_read_data     ,     

//result SRAM interface
  output wire                           dut__tb__sram_result_write_enable  ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_result_write_address ,
  output wire [`SRAM_DATA_RANGE     ]   dut__tb__sram_result_write_data    ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_result_read_address  , 
  input  wire [`SRAM_DATA_RANGE     ]   tb__dut__sram_result_read_data     ,   

//scratchpad SRAM interface
  output wire                           dut__tb__sram_scratchpad_write_enable  ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_scratchpad_write_address ,
  output wire [`SRAM_DATA_RANGE     ]   dut__tb__sram_scratchpad_write_data    ,
  output wire [`SRAM_ADDR_RANGE     ]   dut__tb__sram_scratchpad_read_address  , 
  input  wire [`SRAM_DATA_RANGE     ]   tb__dut__sram_scratchpad_read_data  

);

localparam state_0    =  3'b000; // Reset state
localparam state_1    =  3'b001; // state 1
localparam state_2    =  3'b010; // state 2
localparam state_3    =  3'b011; // state 3
localparam state_4    =  3'b100; // state 4
localparam state_5    =  3'b101; // state 5
localparam state_6    =  3'b110; // state 6
localparam state_7    =  3'b111; // state 7
localparam state_8    =  4'b1000; // state 8
localparam state_9    =  4'b1001; // state 9
localparam state_10   =  4'b1010; // state 10
localparam state_11   =  4'b1011; // state 11
localparam state_12   =  4'b1100; // state 12
localparam state_13   =  4'b1101; // state 13
localparam state_14   =  4'b1110; // state 14
localparam state_15   =  4'b1111; // state 15

reg [3:0] current_state, next_state;
reg [31:0] mac;
reg [2:0] col_a, Scratch_counter;
reg [3:0] row_a, col_b, row_counter, col_counter;
reg [5:0] counter, W_size, QKV_size, Scratch_size;
reg [6:0] S_size;
reg set_dut_ready, get_array_size, save_array_size;
reg dut__tb__sram_result_write_enable_r, dut__tb__sram_scratchpad_write_enable_r;
reg [4:0] dut__tb__sram_scratchpad_read_address_r, dut__tb__sram_scratchpad_write_address_r;
reg [5:0] dut__tb__sram_input_read_address_r;
reg [6:0] dut__tb__sram_weight_read_address_r, dut__tb__sram_result_read_address_r;
reg [7:0] dut__tb__sram_result_write_address_r;
reg [`SRAM_DATA_RANGE] dut__tb__sram_result_write_data_r, dut__tb__sram_scratchpad_write_data_r;
reg [1:0] counter_sel, row_counter_sel, col_counter_sel, Scratch_counter_sel, sram_write_enable_sel, result_write_addr_sel, scratch_write_addr_sel;
reg [2:0] weight_read_addr_sel, input_read_addr_sel, result_read_addr_sel, scratch_read_addr_sel;
reg [1:0] compute_mac, KVS_Flag;

always@(posedge clk or negedge reset_n) begin
  if(!reset_n)
    current_state <= 1'b0;
  else
    current_state <= next_state;
end

always@(*) begin
  case (current_state)
  //Initial State
  state_0:begin
    if(dut_valid) begin
      set_dut_ready = 1'b0;
      get_array_size = 1'b0;
      save_array_size = 1'b0;
      input_read_addr_sel = 2'b00;
      weight_read_addr_sel = 3'b000;
      result_read_addr_sel = 3'b000;
      scratch_read_addr_sel = 3'b000;
      result_write_addr_sel = 2'b00; 
      scratch_write_addr_sel = 2'b00;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      col_counter_sel = 2'b00;
      Scratch_counter_sel = 2'b00;
      compute_mac = 2'b00;
      sram_write_enable_sel = 1'b0;
      KVS_Flag = 2'b00;
      next_state = state_1;
    end
    else begin
      set_dut_ready = 1'b1;
      get_array_size = 1'b0;
      save_array_size = 1'b0;
      input_read_addr_sel = 2'b00;
      weight_read_addr_sel = 3'b000;
      result_read_addr_sel = 3'b000;
      scratch_read_addr_sel = 3'b000;
      result_write_addr_sel = 2'b00; 
      scratch_write_addr_sel = 2'b00;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      col_counter_sel = 2'b00;
      Scratch_counter_sel = 2'b00;
      compute_mac = 2'b00;
      sram_write_enable_sel = 1'b0;
      KVS_Flag = 2'b00;
      next_state = state_0;
    end
  end
  //Read size of input matrix & Select 1st element data
  state_1:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b1;
    save_array_size = 1'b0;
    input_read_addr_sel = 2'b01;
    weight_read_addr_sel = 3'b001;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b00; 
    scratch_write_addr_sel = 2'b00;
    counter_sel = 2'b00;
    row_counter_sel = 2'b00;
    col_counter_sel = 2'b00;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b00;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = 2'b00;
    next_state = state_2;
  end
  //Wait state for reading data
  state_2:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1; 
    input_read_addr_sel = 2'b10;
    weight_read_addr_sel = 3'b101;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_3;
  end
  //Compute 1st & nth element data of I and Wq , Wk & Wv
  state_3: begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b10;
    weight_read_addr_sel = 3'b101;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b01;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b01;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b01;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_4;
  end
  //Check If end of row
  state_4:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    if (col_counter == col_a) begin
      input_read_addr_sel = 2'b10;
      weight_read_addr_sel = 3'b101;  
      next_state = state_5;
    end
    else begin
      input_read_addr_sel = 2'b01;
      weight_read_addr_sel = 3'b100;  
      next_state = state_2;
    end
    if (counter == W_size) begin
      row_counter_sel = 2'b01;
    end
    else begin
      row_counter_sel = 2'b10;
    end
  end
  //Save the result
  state_5:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b10;
    weight_read_addr_sel = 3'b101;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    if (KVS_Flag == 1'b1 || KVS_Flag == 2'b10) 
      sram_write_enable_sel = 2'b11;
    else
      sram_write_enable_sel = 2'b01;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b11;
    KVS_Flag = KVS_Flag;
    next_state = state_6;
  end
  //Wait state for saving data
  state_6:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1; 
    input_read_addr_sel = 2'b10;
    weight_read_addr_sel = 3'b101;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b01;
    if (KVS_Flag == 1'b1 || KVS_Flag == 2'b10) 
      scratch_write_addr_sel = 2'b01;
    else 
      scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_7;
  end
  //Check if end of matrix
  state_7:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    col_counter_sel = 2'b00; 
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b00;
    sram_write_enable_sel = 2'b00;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    if (dut__tb__sram_result_write_address_r == QKV_size) begin
      input_read_addr_sel = 3'b100;
      weight_read_addr_sel = 3'b010;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      KVS_Flag = 1'b1; 
      next_state = state_2;
    end 
    else if (dut__tb__sram_result_write_address_r == 2 * QKV_size) begin
      input_read_addr_sel = 3'b100;
      weight_read_addr_sel = 3'b011;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      KVS_Flag = 2'b10;
      next_state = state_2;
    end
    else if (dut__tb__sram_result_write_address_r == Scratch_size) begin
      input_read_addr_sel = 2'b00;
      weight_read_addr_sel = 2'b00;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      KVS_Flag = 2'b00;
      next_state = state_8;
    end
    else if (counter == W_size) begin
      input_read_addr_sel = 2'b11;
      if (KVS_Flag == 2'b10)
        weight_read_addr_sel = 3'b011;
      else if (KVS_Flag == 2'b01)
        weight_read_addr_sel = 3'b010;
      else 
        weight_read_addr_sel = 3'b001;
      counter_sel = 2'b00;
      row_counter_sel = 2'b10;
      KVS_Flag = KVS_Flag;
      next_state = state_2;
    end
    else begin
      input_read_addr_sel = 2'b11;
      weight_read_addr_sel = 3'b100;
      counter_sel = 2'b10;
      row_counter_sel = 2'b10;
      KVS_Flag = KVS_Flag;
      next_state = state_2;
    end
  end
  //Wait state
  state_8:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b101;
    scratch_read_addr_sel = 3'b101;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b10;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_9;
  end
  //Compute 1st & nth element data of Q & K
  state_9: begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b101;
    scratch_read_addr_sel = 3'b101;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b01;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b01;
    Scratch_counter_sel = 2'b10;
    compute_mac = 2'b10;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_10;
  end
  //Check If end of row
  state_10:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b10;
    weight_read_addr_sel = 3'b101;  
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    if (KVS_Flag == 2'b11) begin
      if (col_counter == row_a) begin
        result_read_addr_sel = 3'b101;
        scratch_read_addr_sel = 3'b101;
        Scratch_counter_sel = 2'b01;
        next_state = state_11;
      end
      else begin
        result_read_addr_sel = 3'b100;
        scratch_read_addr_sel = 3'b111;
        Scratch_counter_sel = 2'b10;
        next_state = state_8;
      end
    end
    else begin
      if (col_counter == col_b) begin
        result_read_addr_sel = 3'b101;
        scratch_read_addr_sel = 3'b101;
        Scratch_counter_sel = 2'b00;
        next_state = state_11;
      end
      else begin
        result_read_addr_sel = 3'b100;
        scratch_read_addr_sel = 3'b100;
        Scratch_counter_sel = 2'b00;
        next_state = state_8;
      end
    end
    if (counter == QKV_size) begin
      row_counter_sel = 2'b01;
    end
    else begin
      row_counter_sel = 2'b10;
    end
  end
  //Save the result
  state_11:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b101;
    scratch_read_addr_sel = 3'b101;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    sram_write_enable_sel = 2'b01;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b10;
    compute_mac = 2'b11;
    KVS_Flag = KVS_Flag;
    next_state = state_12;
  end
  //Wait state for saving data
  state_12:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b101;
    scratch_read_addr_sel = 3'b101;
    result_write_addr_sel = 2'b01; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b10;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_13;
  end
  //Check if end of matrix
  state_13:begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 2'b00;
    col_counter_sel = 2'b00;
    compute_mac = 2'b00;
    sram_write_enable_sel = 2'b00;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    if (dut__tb__sram_result_write_address_r == 4 * QKV_size + S_size) begin
      result_read_addr_sel = 3'b000;
      scratch_read_addr_sel = 3'b000;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      Scratch_counter_sel = 2'b00;
      KVS_Flag = 2'b00;
      next_state = state_0;
    end
    else if (dut__tb__sram_result_write_address_r == Scratch_size + S_size) begin
      result_read_addr_sel = 3'b010;
      scratch_read_addr_sel = 3'b110;
      counter_sel = 2'b00;
      row_counter_sel = 2'b00;
      Scratch_counter_sel = 2'b00;
      KVS_Flag = 2'b11;
      if (row_a == 1'b1)
        next_state = state_14;
      else
        next_state = state_8;
    end
    else if (counter == QKV_size) begin
      if (KVS_Flag == 2'b11) begin
        result_read_addr_sel = 3'b110;
        scratch_read_addr_sel = 3'b110;
        counter_sel = 2'b00;
        Scratch_counter_sel = 2'b00;
        row_counter_sel = 2'b10;
      end
      else begin
        result_read_addr_sel = 3'b011;
        scratch_read_addr_sel = 3'b000;
        counter_sel = 2'b00;
        row_counter_sel = 2'b10;
        Scratch_counter_sel = 2'b00;
      end
      KVS_Flag = KVS_Flag;
      next_state = state_8;
    end
    else begin
      if (KVS_Flag == 2'b11) begin
        result_read_addr_sel = 3'b110;
        scratch_read_addr_sel = 3'b001;
        counter_sel = 2'b10;
        row_counter_sel = 2'b10;
        Scratch_counter_sel = 2'b10;
      end
      else begin
        result_read_addr_sel = 3'b011;
        scratch_read_addr_sel = 3'b100;
        counter_sel = 2'b10;
        row_counter_sel = 2'b10;
        Scratch_counter_sel = 2'b00;
      end
      KVS_Flag = KVS_Flag;
      next_state = state_8;
    end
  end
  //Wait state for row_a = 1
  state_14: begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b101;
    scratch_read_addr_sel = 3'b101;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b10;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_15;
  end
  //Wait state for row_a = 1
  state_15: begin
    set_dut_ready = 1'b0;
    get_array_size = 1'b0;
    save_array_size = 1'b1;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b101;
    scratch_read_addr_sel = 3'b101;
    result_write_addr_sel = 2'b10; 
    scratch_write_addr_sel = 2'b10;
    counter_sel = 2'b10;
    row_counter_sel = 2'b10;
    col_counter_sel = 2'b10;
    Scratch_counter_sel = 2'b10;
    compute_mac = 2'b11;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = KVS_Flag;
    next_state = state_8;
  end
  default: begin
    set_dut_ready = 1'b1;
    get_array_size = 1'b0;
    save_array_size = 1'b0;
    input_read_addr_sel = 2'b00;
    weight_read_addr_sel = 3'b000;
    result_read_addr_sel = 3'b000;
    scratch_read_addr_sel = 3'b000;
    result_write_addr_sel = 2'b00; 
    scratch_write_addr_sel = 2'b00;
    counter_sel = 2'b00;
    row_counter_sel = 2'b00;
    col_counter_sel = 2'b00;
    Scratch_counter_sel = 2'b00;
    compute_mac = 2'b00;
    sram_write_enable_sel = 1'b0;
    KVS_Flag = 2'b00;
    next_state = state_0;
  end
  endcase
end

reg compute_complete;
// DUT ready handshake logic
always @(posedge clk) begin : proc_compute_complete
  if(!reset_n) begin
    compute_complete <= 1'b0;
  end else begin
    compute_complete <= set_dut_ready;
  end
end

assign dut_ready = compute_complete;

// Find the number of array elements 
always @(posedge clk) begin : proc_array_size
  if(!reset_n) begin
    row_a <= 1'b0; 
    col_a <= 1'b0;
    col_b <= 1'b0;
    W_size <= 1'b0; 
    QKV_size <= 1'b0; 
    S_size <= 1'b0;
    Scratch_size <= 1'b0;
  end else begin
    row_a <= get_array_size ? tb__dut__sram_input_read_data[31:16] : (save_array_size ? row_a : 1'b0);
    col_a <= get_array_size ? tb__dut__sram_input_read_data[15:0] : (save_array_size ? col_a : 1'b0);
    col_b <= get_array_size ? tb__dut__sram_weight_read_data[15:0] : (save_array_size ? col_b : 1'b0);
    W_size <= get_array_size ? tb__dut__sram_weight_read_data[31:16] * tb__dut__sram_weight_read_data[15:0] : (save_array_size ? W_size : 1'b0); 
    QKV_size <= get_array_size ? tb__dut__sram_input_read_data[31:16] * tb__dut__sram_weight_read_data[15:0] : (save_array_size ? QKV_size : 1'b0); 
    S_size <= get_array_size ? tb__dut__sram_input_read_data[31:16] * tb__dut__sram_input_read_data[31:16] : (save_array_size ? S_size : 1'b0);
    Scratch_size <= save_array_size ? 3 * QKV_size : 1'b0;
  end
end

// SRAM write enable logic
always @(posedge clk) begin : proc_sram_input_write_enable_r
  if(!reset_n) begin
    dut__tb__sram_result_write_enable_r <= 1'b0;
    dut__tb__sram_scratchpad_write_enable_r <= 1'b0;
  end else begin
    if (sram_write_enable_sel == 2'b00) begin
      dut__tb__sram_result_write_enable_r <= 1'b0;
      dut__tb__sram_scratchpad_write_enable_r <= 1'b0;
    end
    else if (sram_write_enable_sel == 2'b01) begin
      dut__tb__sram_result_write_enable_r <= 1'b1;
      dut__tb__sram_scratchpad_write_enable_r <= 1'b0;
    end
    else if  (sram_write_enable_sel == 2'b10) begin
      dut__tb__sram_result_write_enable_r <= 1'b0;
      dut__tb__sram_scratchpad_write_enable_r <= 1'b1;
    end
    else if  (sram_write_enable_sel == 2'b11) begin
      dut__tb__sram_result_write_enable_r <= 1'b1;
      dut__tb__sram_scratchpad_write_enable_r <= 1'b1;
    end
  end
end

assign dut__tb__sram_input_write_enable = 1'b0;
assign dut__tb__sram_weight_write_enable = 1'b0;
assign dut__tb__sram_result_write_enable = dut__tb__sram_result_write_enable_r;
assign dut__tb__sram_scratchpad_write_enable = dut__tb__sram_scratchpad_write_enable_r;

// Input SRAM read address generator
always @(posedge clk) begin
    if (!reset_n) begin
      dut__tb__sram_input_read_address_r <= 0;
    end
    else begin
      if (input_read_addr_sel == 2'b01)
        dut__tb__sram_input_read_address_r <= dut__tb__sram_input_read_address_r + 1'b1;
      else if (input_read_addr_sel == 2'b10)
        dut__tb__sram_input_read_address_r <= dut__tb__sram_input_read_address_r;
      else if (input_read_addr_sel == 2'b11)
        dut__tb__sram_input_read_address_r <= row_counter * col_a + 1'b1;
      else if (input_read_addr_sel == 3'b100)
        dut__tb__sram_input_read_address_r <= 1'b1;
      else
        dut__tb__sram_input_read_address_r <= 1'b0;
    end
end

assign dut__tb__sram_input_read_address = dut__tb__sram_input_read_address_r;

// Weight SRAM read address generator
always @(posedge clk) begin
    if (!reset_n) begin
      dut__tb__sram_weight_read_address_r <= 0;
    end
    else begin
      if (weight_read_addr_sel == 3'b001)
        dut__tb__sram_weight_read_address_r <= 1'b1;
      else if (weight_read_addr_sel == 3'b010)
        dut__tb__sram_weight_read_address_r <= W_size + 1'b1;
      else if (weight_read_addr_sel == 3'b011)
        dut__tb__sram_weight_read_address_r <= 2 * W_size + 1'b1;
      else if (weight_read_addr_sel == 3'b100)
        dut__tb__sram_weight_read_address_r <= dut__tb__sram_weight_read_address_r + 1'b1;
      else if (weight_read_addr_sel == 3'b101)
        dut__tb__sram_weight_read_address_r <= dut__tb__sram_weight_read_address_r;
      else 
        dut__tb__sram_weight_read_address_r <= 1'b0;
    end
end

assign dut__tb__sram_weight_read_address = dut__tb__sram_weight_read_address_r;

// Result SRAM read address generator
always @(posedge clk) begin
    if (!reset_n) begin
      dut__tb__sram_result_read_address_r <= 0;
    end
    else begin
      if (result_read_addr_sel == 3'b010)
        dut__tb__sram_result_read_address_r <= Scratch_size;
      else if (result_read_addr_sel == 3'b011)
        dut__tb__sram_result_read_address_r <= row_counter * col_b;
      else if (result_read_addr_sel == 3'b100)
        dut__tb__sram_result_read_address_r <= dut__tb__sram_result_read_address_r + 1'b1;
      else if (result_read_addr_sel == 3'b101)
        dut__tb__sram_result_read_address_r <= dut__tb__sram_result_read_address_r;
      else if (result_read_addr_sel == 3'b110)
        dut__tb__sram_result_read_address_r <= row_counter * row_a + Scratch_size;
      else
        dut__tb__sram_result_read_address_r <= 1'b0;
    end
end

assign dut__tb__sram_result_read_address = dut__tb__sram_result_read_address_r;

// Scratchpad SRAM read address generator
always @(posedge clk) begin
    if (!reset_n) begin
      dut__tb__sram_scratchpad_read_address_r <= 0;
    end
    else begin
      if (scratch_read_addr_sel == 3'b001)
        dut__tb__sram_scratchpad_read_address_r <= QKV_size + Scratch_counter;
      else if (scratch_read_addr_sel == 3'b100)
        dut__tb__sram_scratchpad_read_address_r <= dut__tb__sram_scratchpad_read_address_r + 1'b1;
      else if (scratch_read_addr_sel == 3'b101)
        dut__tb__sram_scratchpad_read_address_r <= dut__tb__sram_scratchpad_read_address_r;
      else if (scratch_read_addr_sel == 3'b110)
        dut__tb__sram_scratchpad_read_address_r <= QKV_size;
      else if (scratch_read_addr_sel == 3'b111)
        dut__tb__sram_scratchpad_read_address_r <= dut__tb__sram_scratchpad_read_address_r + col_b;
      else
        dut__tb__sram_scratchpad_read_address_r <= 1'b0;
    end
end

assign dut__tb__sram_scratchpad_read_address = dut__tb__sram_scratchpad_read_address_r;

// Result SRAM write address generator
always @(posedge clk) begin : proc_sram_result_write_address_r
    if (!reset_n) begin
      dut__tb__sram_result_write_address_r <= 1'b0;
    end
    else begin
      if (result_write_addr_sel == 2'b01)
        dut__tb__sram_result_write_address_r <= dut__tb__sram_result_write_address_r + 1'b1;
      else if (result_write_addr_sel == 2'b10)
        dut__tb__sram_result_write_address_r <= dut__tb__sram_result_write_address_r;
      else
        dut__tb__sram_result_write_address_r <= 1'b0;
    end
end

assign dut__tb__sram_result_write_address = dut__tb__sram_result_write_address_r;

// Scratch SRAM write address generator
always @(posedge clk) begin : proc_sram_scratch_write_address_r
    if (!reset_n) begin
      dut__tb__sram_scratchpad_write_address_r <= 1'b0;
    end
    else begin
      if (scratch_write_addr_sel == 2'b01)
        dut__tb__sram_scratchpad_write_address_r <= dut__tb__sram_scratchpad_write_address_r + 1'b1;
      else if (scratch_write_addr_sel == 2'b10)
        dut__tb__sram_scratchpad_write_address_r <= dut__tb__sram_scratchpad_write_address_r;
      else
        dut__tb__sram_scratchpad_write_address_r <= 1'b0;
    end
end

assign dut__tb__sram_scratchpad_write_address = dut__tb__sram_scratchpad_write_address_r;

// SRAM result write data logic
always @(posedge clk) begin : proc_sram_result_write_data_r
  if(!reset_n) begin
    dut__tb__sram_result_write_data_r <= `SRAM_DATA_WIDTH'b0;
  end else begin
    dut__tb__sram_result_write_data_r <= (sram_write_enable_sel == 2'b01 || sram_write_enable_sel == 2'b11) ? mac : `SRAM_DATA_WIDTH'b0;
  end 
end

assign dut__tb__sram_result_write_data = dut__tb__sram_result_write_data_r;

// SRAM scratch write data logic
always @(posedge clk) begin : proc_sram_scratch_write_data_r
  if(!reset_n) begin
    dut__tb__sram_scratchpad_write_data_r <= `SRAM_DATA_WIDTH'b0;
  end else begin
    dut__tb__sram_scratchpad_write_data_r <= (sram_write_enable_sel == 2'b10 || sram_write_enable_sel == 2'b11) ? mac : `SRAM_DATA_WIDTH'b0;
  end
end

assign dut__tb__sram_scratchpad_write_data = dut__tb__sram_scratchpad_write_data_r;

//Counter
always @(posedge clk) begin : proc_counter
  if(!reset_n) begin
    counter <= 1'b0;
  end else begin
    if (counter_sel == 2'b00)
      counter <= 1'b0;
    else if (counter_sel == 2'b01)
      counter <= counter + 1'b1;
    else if (counter_sel == 2'b10)
      counter <= counter;
    else
      counter <= 1'b0;
  end
end

//Row Counter
always @(posedge clk) begin : proc_Row_Counter
  if(!reset_n) begin
    row_counter <= 1'b0;
  end else begin
    if (row_counter_sel == 2'b00)
      row_counter <= 1'b0;
    else if (row_counter_sel == 2'b01)
      row_counter <= row_counter + 1'b1;
    else if (row_counter_sel == 2'b10)
      row_counter <= row_counter;
    else
      row_counter <= 1'b0;
  end
end

//Col Counter
always @(posedge clk) begin : proc_Col_Counter
  if(!reset_n) begin
    col_counter <= 1'b0;
  end else begin
    if (col_counter_sel == 2'b00)
      col_counter <= 1'b0;
    else if (col_counter_sel == 2'b01)
      col_counter <= col_counter + 1'b1;
    else if (col_counter_sel == 2'b10)
      col_counter <= col_counter;
    else 
      col_counter <= 1'b0;
  end
end

//Scratch Counter
always @(posedge clk) begin : proc_Scratch_Counter
  if(!reset_n) begin
    Scratch_counter <= 1'b0;
  end else begin
    if (Scratch_counter_sel == 2'b00)
      Scratch_counter <= 1'b0;
    else if (Scratch_counter_sel == 2'b01)
      Scratch_counter <= Scratch_counter + 1'b1;
    else if (Scratch_counter_sel == 2'b10)
      Scratch_counter <= Scratch_counter;
    else 
      Scratch_counter <= 1'b0;
  end
end

wire [31:0] op_a = (compute_mac == 2'b01) ? tb__dut__sram_input_read_data[31:0] :
                   (compute_mac == 2'b10) ? tb__dut__sram_result_read_data[31:0] :
                   1'b0;

wire [31:0] op_b = (compute_mac == 2'b01) ? tb__dut__sram_weight_read_data[31:0] :
                   (compute_mac == 2'b10) ? tb__dut__sram_scratchpad_read_data[31:0] :
                   1'b0;
// MAC logic 
always @(posedge clk) begin : proc_multiplier
  if(!reset_n) begin
    mac <= 1'b0;
  end 
  else begin
    case (compute_mac)
      2'b00: mac <= 1'b0; 
      2'b01: mac <= op_a * op_b + mac;
      2'b10: mac <= op_a * op_b + mac;   
      2'b11: mac <= mac;
    endcase
  end
end

endmodule
