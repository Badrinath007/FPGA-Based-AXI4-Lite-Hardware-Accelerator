module vector_add_with_fifo_accel #(
    parameter DATA_W = 24
)(
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire valid_in,
    input  wire [DATA_W-1:0] A,
    input  wire [DATA_W-1:0] B,
    output reg done,
    output reg [DATA_W-1:0] result
);

    reg [DATA_W-1:0] A_reg, B_reg;
    reg start_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A_reg <= 0;
            B_reg <= 0;
            result <= 0;
            done <= 0;
            start_d <= 0;
        end else begin

            // capture inputs
            if (valid_in) begin
                A_reg <= A;
                B_reg <= B;
            end

            // delay start
            start_d <= start;

            // compute once and HOLD done
            if (start_d && !done) begin
                result <= A_reg + B_reg;
                done <= 1;   // stays HIGH
            end
        end
    end

endmodule