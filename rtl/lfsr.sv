module lfsr #(
                // Parameters
                parameter LFSR_LENGTH = 4,
                parameter LFSR_PRIM_POLY = 4'b1101,  // tap on 3 i.e. 1+x^3+x^4
                parameter LFSR_SEED_VAL = 4'b1011
            )(
                // IO ports
                input logic lfsr_clk,
                input logic resetn,
                input logic lfsr_en,
                output logic [LFSR_LENGTH-1:0] lfsr_state_out,
                output logic lfsr_out
            );
    
    logic [LFSR_LENGTH-1:0] lfsr;
    logic lfsr_feedback;

    assign lfsr_out = lfsr[LFSR_LENGTH-1];
    //assign lfsr_feedback = lfsr[3] ^ lfsr[2];  // hard coded will change later
    assign lfsr_state_out = lfsr;
    
    always @(posedge lfsr_clk or negedge resetn) begin
        if(!resetn) begin
            lfsr = LFSR_SEED_VAL; 
        end
        else begin
            if(lfsr_en) begin
                // calculate feedback according to polynomial tap
                foreach(LFSR_PRIM_POLY[i]) begin
                    //$display("LFSR_PRIM_POLY[%0d]: %0d, lfsr:%0b", i, LFSR_PRIM_POLY[i], lfsr);
                    if(i== LFSR_LENGTH-1) begin
                        lfsr_feedback = lfsr[i];
                        //$display("lfsr_feedback:%0b", lfsr[i]);
                    end
                    else if(i !=0) begin
                        if(LFSR_PRIM_POLY[i]) begin
                            lfsr_feedback = lfsr_feedback ^ lfsr[i];
                        end
                    end
                end 
                // perform shift operation
                lfsr = {lfsr[LFSR_LENGTH-2:0], lfsr_feedback};
            end
        end
    end
endmodule
