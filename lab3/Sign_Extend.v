module Sign_Extend( data_i, data_o );

//I/O ports
input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;

//Sign extended
/*your code here*/

assign data_o = {data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15],
                 data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15],
                 data_i[15], data_i[14], data_i[13], data_i[12], data_i[11], data_i[10], data_i[ 9], data_i[ 8],
                 data_i[ 7], data_i[ 6], data_i[ 5], data_i[ 4], data_i[ 3], data_i[ 2], data_i[ 1], data_i[ 0]}; 


endmodule      
