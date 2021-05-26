module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o , lr, sllv);

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
output     [0:0]lr;
output     [0:0]sllv;
     
//Internal Signals
reg		[4-1:0] ALU_operation_o;
reg		[2-1:0] FURslt_o;
reg     lr;
reg     sllv;

//Main function
/*your code here*/

always @ (ALUOp_i, funct_i) begin
    sllv <= 1'b0;
    if(ALUOp_i == 3'b010)begin
        if(funct_i == 6'b010011) begin
            ALU_operation_o <= 4'b0000;
            FURslt_o <= 2'b00;
        end
        else if(funct_i == 6'b010001) begin
            ALU_operation_o <= 4'b0001;
            FURslt_o <= 2'b00;
        end
        else if(funct_i == 6'b010100) begin
            ALU_operation_o <= 4'b0010;
            FURslt_o <= 2'b00;
        end
        else if(funct_i == 6'b010110) begin
            ALU_operation_o <= 4'b0011;
            FURslt_o <= 2'b00;
        end
        else if(funct_i == 6'b010101) begin
            ALU_operation_o <= 4'b0100;
            FURslt_o <= 2'b00;
        end
        else if(funct_i == 6'b110000) begin
            ALU_operation_o <= 4'b0101;
            FURslt_o <= 2'b00;
        end
        else if(funct_i == 6'b000000) begin
            ALU_operation_o <= 4'b1111;
            FURslt_o <= 2'b01;
            lr <= 1'b1;
        end
        else if(funct_i == 6'b000010) begin
            ALU_operation_o <= 4'b1111;
            FURslt_o <= 2'b01;
            lr <= 1'b0;
        end
        else if(funct_i == 6'b000110) begin
            ALU_operation_o <= 4'b1111;
            FURslt_o <= 2'b01;
            sllv<=1'b1;
            lr <= 1'b1;
        end
        else if(funct_i == 6'b000100) begin
            ALU_operation_o <= 4'b1111;
            FURslt_o <= 2'b01;
            sllv<=1'b1;
            lr <= 1'b0;
        end
    end
    else if (ALUOp_i == 3'b000) begin
        ALU_operation_o <= 4'b0000;
        FURslt_o <= 2'b00;
    end
end


endmodule     
