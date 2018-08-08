module dataMemory(output reg [31:0]data, 
						output reg missFlag, 
						input [31:0]addr, 
						input [31:0]inputData,
						input writeData,
						input readData); //inputData and writeData would be used if we had an imperfect cache that would go to a lower level and get more data to load into this iCache.  Here we include but ignore it.

	reg [28:0]set0Address[0:15];
	reg [31:0]set0Data[0:15]; 
	reg [14:0]i;
	wire [28:0]blockAddress = addr[31:3];
	wire setID = blockAddress % 2;

	always@(blockAddress, inputData, setID, writeData, readData) begin : search
		if(setID) begin //set 1
				for(i = 0; i < 16; i=i+1) begin //how many lines there are
					if(blockAddress == set0Address[i]) begin
						if(readData) begin
							data = set0Data[i];
						end //if
						else if(writeData) begin
							set0Data[i] = inputData;
							data = set0Data[i];
						end //else
					
						missFlag = 0;
						disable search;
					end //if PC==
					else begin
						missFlag = 1;
						data = 32'bx;
						
					end
				end //for
		end //if

		else begin
				for(i = 0; i < 16; i=i+1) begin //how many lines there are
					if(blockAddress == set0Address[i]) begin
						if(readData) begin
							data = set0Data[i];
						end //if
						else if (writeData) begin
							set0Data[i] = inputData;
							data = set0Data[i];
						end //else
					
						missFlag = 0;
						disable search;
					end //if PC==
					else begin
						missFlag = 1;
						data = 32'bx;
					end //else
				end //for
			end //else
	end //always


	initial begin
		set0Address[0] = 29'h00000202; set0Data[0] = 32'h01010101;
		set0Address[1] = 29'h00000204; set0Data[1] = 32'h02020202;
		set0Address[2] = 29'h00000206; set0Data[2] = 32'h03030303;
		set0Address[3] = 29'h00000208; set0Data[3] = 32'h04040404;
		set0Address[4] = 29'h0000020A; set0Data[4] = 32'h05050505;
		set0Address[5] = 29'h0000020C; set0Data[5] = 32'h06060606;
		set0Address[6] = 29'h0000020E; set0Data[6] = 32'h07070707;
		set0Address[7] = 29'h00000210; set0Data[7] = 32'h08080808;

		set0Address[0] = 29'h00000201; set0Data[0] = 32'h99999999;
		set0Address[1] = 29'h00000203; set0Data[1] = 32'hAAAAAAAA;
		set0Address[2] = 29'h00000205; set0Data[2] = 32'hBBBBBBBB;
		set0Address[3] = 29'h00000207; set0Data[3] = 32'hCCCCCCCC;
		set0Address[4] = 29'h00000209; set0Data[4] = 32'hDDDDDDDD;
		set0Address[5] = 29'h0000020B; set0Data[5] = 32'hEEEEEEEE;
		set0Address[6] = 29'h0000020D; set0Data[6] = 32'hFFFFFFFF;
		set0Address[7] = 29'h0000020F; set0Data[7] = 32'h01234567;
	end

endmodule

