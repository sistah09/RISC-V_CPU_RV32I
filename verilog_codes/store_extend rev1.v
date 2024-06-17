module store_extend_rev1s(
	input [1:0] LSB_Bits, store,
	input [31:0] data, read_data,
	output reg [31:0] modified_data
);
	
	reg [31:0] temp, temp2;

	always @(*) begin

		// creating masks to get the original data present at that memory
		// For store byte, the mask should be 0x000000FF, then it should be left shifted by the 8 * LSB_bits ( can take values 0, 1, 2, 3)
		// For store word, the mask should be 0x0000FFFF, then it should be left shifted by the 8 * LSB_bits ( can take values 0, 2)
		// Negate both the masks, for sb --> 0xFFFFFF00, 0xFFFF00FF, 0xFF00FFFF, 0x00FFFFFF
		// This mask should be ANDed with the ReadData at that addess (multiple of 4)
		// The byte or word to be stored should be left shifted by 8 * LSB_bits
		// The shifted data and masked data are ORed.

		// Example : store byte 0x000000AB at addr = 0x02000005 and assume data 0x12345678 is present at addr2=0x02000004
		// RISC V is word-aligned, so the address can only be a multiple of 4.
		// Hence address should be addr[32:2], the LSB 2 bits are addr[1:0], in this case its 01
		// Hence the negated mask created will be 0xFFFF00FF (shifted by 8 bits)
		// AND the negated mask with the data already present. 0xFFFF00FF | 0x12345678 = 0x12340078
		// The data to be stored should also be left shifted.
		// shifted_data = 0x000000AB << 8*1 = 0x0000AB00
		// or the shifted data and masked original data
		// 0x0000AB00 | 0x12340078 = 0x1234AB78

		// little endian
		temp <= 32'hff << ({LSB_Bits,3'b0});
		temp2 <= 32'hffff << ({LSB_Bits,3'b0});

		// big endian
		//temp <= 32'hff << ({~LSB_Bits,3'b0});
		//temp2 <= 32'hffff << ({~LSB_Bits,3'b0});

		case(store)

			// little endian
			2'b01:	modified_data <= ((~temp) & read_data) | (temp & (data << {LSB_Bits,3'b0}));//sb
			2'b10:	modified_data <= ((~temp2) & read_data)| (temp2 & (data << ({LSB_Bits,3'b0})));//sh

			//big endian
			//2'b01:	modified_data <= ((~temp) & read_data) | (temp & (data << {~LSB_Bits,3'b0}));//sb
			//2'b10:	modified_data <= ((~temp2) & read_data)| (temp2 & (data << ({~LSB_Bits,3'b0})));//sh
			default:	modified_data <= data;	//sw
		endcase
	end
	
endmodule
