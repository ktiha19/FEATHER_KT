// AXI interface for FEATHEinput wire ACLK;
input wire ARESETN;

input wire [31:0] AWADDR;
input wire [7:0]  AWLEN;
input wire [2:0]  AWSIZE;
input wire [1:0]  AWBURST;
input wire        AWVALID;
output wire       AWREADY;

input wire [31:0] WDATA;
input wire [3:0]  WSTRB;
input wire        WLAST;
input wire        WVALID;
output wire       WREADY;

output wire [1:0] BRESP;
output wire       BVALID;
input wire        BREADY;

input wire [31:0] ARADDR;
input wire [7:0]  ARLEN;
input wire [2:0]  ARSIZE;
input wire [1:0]  ARBURST;
input wire        ARVALID;
output wire       ARREADY;

output wire [31:0] RDATA;
output wire [1:0]  RRESP;
output wire        RLAST;
output wire        RVALID;
input wire         RREADY;

typedef enum logic [1:0] {
    IDLE,
    WRITE_ADDR,
    WRITE_DATA,
    WRITE_RESP
} write_state_t;

write_state_t write_state;

always @(posedge ACLK) begin
    if (!ARESETN) begin
        write_state <= IDLE;
        AWREADY <= 1'b0;
        WREADY <= 1'b0;
        BVALID <= 1'b0;
    end else begin
        case (write_state)
            IDLE: begin
                if (AWVALID) begin
                    AWREADY <= 1'b1;
                    write_state <= WRITE_ADDR;
                end
            end
            WRITE_ADDR: begin
                if (WVALID) begin
                    WREADY <= 1'b1;
                    write_state <= WRITE_DATA;
                end
            end
            WRITE_DATA: begin
                if (WLAST) begin
                    WREADY <= 1'b0;
                    BVALID <= 1'b1;
                    write_state <= WRITE_RESP;
                end
            end
            WRITE_RESP: begin
                if (BREADY) begin
                    BVALID <= 1'b0;
                    write_state <= IDLE;
                end
            end
        endcase
    end
end