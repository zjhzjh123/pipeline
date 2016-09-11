`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:15:31 09/04/2016 
// Design Name: 
// Module Name:    top_pipeline 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
/* DON'T FORGET TO:
a. add reset to all intermedia_reg and mainctr etc.
b. post the branch to ID level(FAILED)
c. first instruction should be a nop in order to fill the pipeline
d. 
*/
/*
NAME RULE:
1. Control sygnal is captial only in the first letter
2. Other data name is Camel Form
3. First letters tell the position
*/
module top_pipeline(
    input Clock,
    input Reset
    );
//Definition
	 //IF state
	 reg [31:0] IF_PC;
	 wire[31:0]IF_PCPlusFour;
	 wire[31:0] InstMem_Inst;
	 wire [31:0] Mux_IF_ID_Flush;
	 wire [31:0] Mux_PCsrc;
    wire [31:0] Mux_Jump;
	 //IF_ID_Reg
	 reg [31:0]IF_ID_PCP4;
	 reg [31:0]IF_ID_Inst;
	 
	 //ID
    	  //Ctr
	     wire Ctr_Regdst;
	     wire Ctr_Jump;
	     wire Ctr_Branch;
	     wire Ctr_Memread;
	     wire Ctr_Memtoreg;
	     wire [2:0] Ctr_Aluop;
        wire Ctr_Memwrite;
	     wire Ctr_Alusrc;
	     wire Ctr_Regwrite; 
		  //MUX_ID_EX_Stall
		  wire Mux_ID_EX_Stall_Regdst;
		  wire Mux_ID_EX_Stall_Branch;
		  wire Mux_ID_EX_Stall_Memread;
		  wire Mux_ID_EX_Stall_Memwrite;
		  wire Mux_ID_EX_Stall_Memtoreg;
		  wire [2:0] Mux_ID_EX_Stall_Aluop;
		  wire Mux_ID_EX_Stall_Alusrc;
		  wire Mux_ID_EX_Stall_Regwrite;
		  //Hazard Ctr
		  wire HazardCtr_PCwrite;
		  wire HazardCtr_IF_ID_Write;
		  wire HazardCtr_IF_ID_Flush;
		  wire HazardCtr_EX_MEM_Stall;
		  wire HazardCtr_ID_EX_Stall;
		  //RegFile
		  wire [31:0] RegFile_ReadData1;
	     wire [31:0] RegFile_ReadData2;
		  //SignExt
		  wire [31:0] SignExt_SignExt;
	 //ID_EX_Reg
	     //WB
	     reg ID_EX_Regwrite;
	     reg ID_EX_Memtoreg;
		  //MEM
	     reg ID_EX_Branch;
	     reg ID_EX_Memread;
	     reg ID_EX_Memwrite;
		  //EX
		  reg ID_EX_Alusrc;
		  reg [2:0] ID_EX_Aluop;
		  reg ID_EX_Regdst;
	 reg [31:0] ID_EX_PCP4;
	 reg [31:0] ID_EX_ReadData1;
	 reg [31:0] ID_EX_ReadData2;
	 reg [31:0] ID_EX_SignExt;
	 reg [4:0] ID_EX_Rs;
	 reg [4:0] ID_EX_Rt;
	 reg [4:0] ID_EX_Rd;
	 
	 //EX
	     //Mux_EX_MEM_Stall
		  wire Mux_EX_MEM_Stall_Regwrite;
		  wire Mux_EX_MEM_Stall_Memtoreg;
		  wire Mux_EX_MEM_Stall_Memread;
		  wire Mux_EX_MEM_Stall_Memwrite;
		  wire Mux_EX_MEM_Stall_Branch;
	 wire [31:0] EX_PCBranch;
	 wire [31:0] Mux_ForwardA;
	 wire [31:0] Mux_ForwardB;
	 wire [31:0] Mux_Alusrc;
	 wire [4:0] Mux_Regdst;
	     //Alu Ctr
	     wire [3:0] AluCtr_AluCtr;
	     //Forward Ctr
	     wire [1:0] ForwardCtr_ForwardA;
	     wire [1:0] ForwardCtr_ForwardB;
	     //Alu
	     wire Alu_Zero;
	     wire [31:0] Alu_AluRes;
		  
	 //EX_MEM_Reg
	      //WB
			reg EX_MEM_Regwrite;
			reg EX_MEM_Memtoreg;
			//MEM
			reg EX_MEM_Memread;
			reg EX_MEM_Memwrite;
			reg EX_MEM_Branch;
	  reg [31:0] EX_MEM_PCBranch;		
	  reg EX_MEM_Zero;
	  reg [31:0] EX_MEM_AluRes;
	  reg [31:0] EX_MEM_ReadData2;
	  reg [4:0] EX_MEM_Regdst;
	  
	  //MEM
	  wire MEM_PCSrc;
	  wire [31:0]DataMem_MemReadData;
	  
	  //MEM_WB_Reg
	      //WB
			reg MEM_WB_Regwrite;
			reg MEM_WB_Memtoreg;
	  reg [31:0] MEM_WB_MemReadData;
	  reg [31:0] MEM_WB_AluRes;
	  reg [4:0] MEM_WB_Regdst;
	  
	  //WB
	  wire [31:0] Mux_Memtoreg;

//Module&Assign
    //IF
    inst_memory InstMem(
    .address(IF_PC),
	 
    .instruction(InstMem_Inst)
	 );
	 
	 assign IF_PCPlusFour = IF_PC + 4;
	 assign Mux_IF_ID_Flush = (HazardCtr_IF_ID_Flush)?32'hfc000000:InstMem_Inst;
	 assign Mux_PCsrc = (MEM_PCSrc)?EX_MEM_PCBranch:IF_PCPlusFour;
	 assign Mux_Jump = (Ctr_Jump)?{IF_ID_PCP4[31:28],IF_ID_Inst[25:0],2'b00}:Mux_PCsrc;
	 
	 //ID
	 register RegFile(
	 .clk(Clock),
	 .reset(Reset),
    .readRes1(IF_ID_Inst[25:21]),
    .readRes2(IF_ID_Inst[20:16]),
    .writeRes(MEM_WB_Regdst),
    .writeData(Mux_Memtoreg),
	 .regWrite(MEM_WB_Regwrite),
	 
    .readData1(RegFile_ReadData1),
    .readData2(RegFile_ReadData2)
	 );
	 
	 signext SignExt(
	 .inst(IF_ID_Inst[15:0]),
    .data(SignExt_SignExt)
	 );
	 
	 Ctr MainCtr(
	 .opCode(IF_ID_Inst[31:26]),
	 
    .regDst(Ctr_Regdst),
    .aluSrc(Ctr_Alusrc),
    .memToReg(Ctr_Memtoreg),
    .regWrite(Ctr_Regwrite),
    .memRead(Ctr_Memread),
    .memWrite(Ctr_Memwrite),
    .branch(Ctr_Branch),
    .aluOp(Ctr_Aluop),
    .jump(Ctr_Jump)
	 );
	 
	 HazardCtr MainHazardCtr(
    //Data Hazard
    .If_Id_readReg1(IF_ID_Inst[25:21]),
    .If_Id_readReg2(IF_ID_Inst[20:16]),
    .Id_Ex_memRead(ID_EX_Memread),
    .Id_Ex_regdst(ID_EX_Rt),
	 //Ctr Hazard
	 .jump(Ctr_Jump),
	 .PCsource(MEM_PCSrc),
	 
    .PCWrite(HazardCtr_PCwrite),
    .If_Id_write(HazardCtr_IF_ID_Write),
	 .Ex_Mem_stall(HazardCtr_EX_MEM_Stall),
    .Id_Ex_stall(HazardCtr_ID_EX_Stall),
	 .If_Id_flush(HazardCtr_IF_ID_Flush)
    );
	 
	 assign Mux_ID_EX_Stall_Regdst = HazardCtr_ID_EX_Stall?1'b0:Ctr_Regdst;
	 assign Mux_ID_EX_Stall_Branch = HazardCtr_ID_EX_Stall?1'b0:Ctr_Branch;
	 assign Mux_ID_EX_Stall_Memread = HazardCtr_ID_EX_Stall?1'b0:Ctr_Memread;
	 assign Mux_ID_EX_Stall_Memwrite = HazardCtr_ID_EX_Stall?1'b0:Ctr_Memwrite;
    assign Mux_ID_EX_Stall_Memtoreg = HazardCtr_ID_EX_Stall?1'b0:Ctr_Memtoreg;
	 assign Mux_ID_EX_Stall_Aluop = HazardCtr_ID_EX_Stall?3'b000:Ctr_Aluop;
	 assign Mux_ID_EX_Stall_Alusrc = HazardCtr_ID_EX_Stall?1'b0:Ctr_Alusrc;
	 assign Mux_ID_EX_Stall_Regwrite = HazardCtr_ID_EX_Stall ? 1'b0 : Ctr_Regwrite;
	 
	 //EX
	 AluCtr MainAluCtr(
	 .funct(ID_EX_SignExt[5:0]),
    .aluOp(ID_EX_Aluop),
	 
    .aluCtr(AluCtr_AluCtr)
	 );
	 
	 Alu MainAlu(
	 .input1(Mux_ForwardA),
    .input2(Mux_Alusrc),
    .aluCtr(AluCtr_AluCtr),
	 
    .zero(Alu_Zero),
    .aluRes(Alu_AluRes)
	 );
	 
	 ForwardCtr MainFWC(
    .Ex_Mem_regWrite(EX_MEM_Regwrite),
	 .Mem_Wb_regWrite(MEM_WB_Regwrite),
    .Ex_Mem_writeRegAdd(EX_MEM_Regdst),
    .Mem_Wb_writeRegAdd(MEM_WB_Regdst),
    .Id_Ex_readReg1(ID_EX_Rs),
    .Id_Ex_readReg2(ID_EX_Rt),
	 
    .ForwardA(ForwardCtr_ForwardA),
    .ForwardB(ForwardCtr_ForwardB)
    );
	 
	 Mux_3to1_32bits MuxFA(
    .Input0(ID_EX_ReadData1),
    .Input1(Mux_Memtoreg),
    .Input2(EX_MEM_AluRes),
    .Select(ForwardCtr_ForwardA),
    .Output(Mux_ForwardA)
    );
	 
	 Mux_3to1_32bits MuxFB(
    .Input0(ID_EX_ReadData2),
    .Input1(Mux_Memtoreg),
    .Input2(EX_MEM_AluRes),
    .Select(ForwardCtr_ForwardB),
    .Output(Mux_ForwardB)
    );
	 
	 assign Mux_EX_MEM_Stall_Regwrite = HazardCtr_EX_MEM_Stall?1'b0:ID_EX_Regwrite;
	 assign Mux_EX_MEM_Stall_Memtoreg = HazardCtr_EX_MEM_Stall?1'b0:ID_EX_Memtoreg;
	 assign Mux_EX_MEM_Stall_Memread = HazardCtr_EX_MEM_Stall?1'b0:ID_EX_Memread;
	 assign Mux_EX_MEM_Stall_Memwrite = HazardCtr_EX_MEM_Stall?1'b0:ID_EX_Memwrite;
	 assign Mux_EX_MEM_Stall_Branch = HazardCtr_EX_MEM_Stall?1'b0:ID_EX_Branch;
	 
	 assign EX_PCBranch = (ID_EX_SignExt << 2) + ID_EX_PCP4;//Braket is imdispensible
	 assign Mux_Alusrc = ID_EX_Alusrc?ID_EX_SignExt:Mux_ForwardB;
	 assign Mux_Regdst = ID_EX_Regdst?ID_EX_Rd:ID_EX_Rt;
	 
	 //MEM
	 data_memory DataMem(
	 .clk(Clock),
    .address(EX_MEM_AluRes),
    .writeData(EX_MEM_ReadData2),
	 .memWrite(EX_MEM_Memwrite),
    .memRead(EX_MEM_Memread),
	 	 
    .readData(DataMem_MemReadData)
	 );
	 assign MEM_PCSrc = EX_MEM_Branch & EX_MEM_Zero;
	 
	 //WB
	 assign Mux_Memtoreg = MEM_WB_Memtoreg?MEM_WB_MemReadData:MEM_WB_AluRes;

//clock posedge
always @ ( posedge Clock )
begin
//NOT RESET
    if( Reset == 0 )
	 begin
    //PC
	 if(HazardCtr_PCwrite )
	     IF_PC <= Mux_Jump;
	 //IF_ID_Reg
	 if( HazardCtr_IF_ID_Write )
	     begin
	     IF_ID_PCP4 <= IF_PCPlusFour;
	     IF_ID_Inst <= Mux_IF_ID_Flush;
		  end
	 //ID_EX
	 	  //WB
	     ID_EX_Regwrite <= Mux_ID_EX_Stall_Regwrite;
	     ID_EX_Memtoreg <= Mux_ID_EX_Stall_Memtoreg;
		  //MEM
	     ID_EX_Branch <= Mux_ID_EX_Stall_Branch;
	     ID_EX_Memread <= Mux_ID_EX_Stall_Memread;
	     ID_EX_Memwrite <= Mux_ID_EX_Stall_Memwrite;
		  //EX
		  ID_EX_Alusrc <= Mux_ID_EX_Stall_Alusrc;
		  ID_EX_Aluop <= Mux_ID_EX_Stall_Aluop;
		  ID_EX_Regdst <= Mux_ID_EX_Stall_Regdst;
	 ID_EX_PCP4 <= IF_ID_PCP4;
	 ID_EX_ReadData1 <= RegFile_ReadData1;
	 ID_EX_ReadData2 <= RegFile_ReadData2;
	 ID_EX_SignExt <= SignExt_SignExt;
	 ID_EX_Rs <= IF_ID_Inst[25:21];
	 ID_EX_Rt <= IF_ID_Inst[20:16];
	 ID_EX_Rd <= IF_ID_Inst[15:11];
	 //EX_MEM
	      //WB
	      EX_MEM_Regwrite <= Mux_EX_MEM_Stall_Regwrite;
	      EX_MEM_Memtoreg <= Mux_EX_MEM_Stall_Memtoreg;
			//MEM
			EX_MEM_Memread <= Mux_EX_MEM_Stall_Memread;
			EX_MEM_Memwrite <= Mux_EX_MEM_Stall_Memwrite;
			EX_MEM_Branch <= Mux_EX_MEM_Stall_Branch;
	  EX_MEM_PCBranch <= EX_PCBranch;		
	  EX_MEM_Zero <= Alu_Zero;
	  EX_MEM_AluRes <= Alu_AluRes;
	  EX_MEM_ReadData2 <= Mux_ForwardB;
	  EX_MEM_Regdst <= Mux_Regdst;
	  //MEM_WB
	      //WB
			MEM_WB_Regwrite <= EX_MEM_Regwrite;
			MEM_WB_Memtoreg <= EX_MEM_Memtoreg;
	  MEM_WB_MemReadData <= DataMem_MemReadData;
	  MEM_WB_AluRes <= EX_MEM_AluRes;
	  MEM_WB_Regdst <= EX_MEM_Regdst;
	  end
//Reset
     else
	  begin
	  //PC
	  IF_PC <= 0;
	 //IF_ID_Reg
	  begin
	  IF_ID_PCP4 <= 0;
	  IF_ID_Inst <= 32'hfc000000;
	  end
	 //ID_EX
	 	  //WB
	     ID_EX_Regwrite <= 0;
	     ID_EX_Memtoreg <= 0;
		  //MEM
	     ID_EX_Branch <= 0;
	     ID_EX_Memread <= 0;
	     ID_EX_Memwrite <= 0;
		  //EX
		  ID_EX_Alusrc <= 0;
		  ID_EX_Aluop <= 0;
		  ID_EX_Regdst <= 0;
	 ID_EX_PCP4 <= IF_ID_PCP4;
	 ID_EX_ReadData1 <= RegFile_ReadData1;
	 ID_EX_ReadData2 <= RegFile_ReadData2;
	 ID_EX_SignExt <= SignExt_SignExt;
	 ID_EX_Rs <= IF_ID_Inst[25:21];
	 ID_EX_Rt <= IF_ID_Inst[20:16];
	 ID_EX_Rd <= IF_ID_Inst[15:11];
	 //EX_MEM
	      //WB
	      EX_MEM_Regwrite <= 0;
	      EX_MEM_Memtoreg <= 0;
			//MEM
			EX_MEM_Memread <= 0;
			EX_MEM_Memwrite <= 0;
			EX_MEM_Branch <= 0;
	  EX_MEM_PCBranch <= EX_PCBranch;		
	  EX_MEM_Zero <= Alu_Zero;
	  EX_MEM_AluRes <= Alu_AluRes;
	  EX_MEM_ReadData2 <= Mux_ForwardB;
	  EX_MEM_Regdst <= Mux_Regdst;
	  //MEM_WB
	      //WB
			MEM_WB_Regwrite <= 0;
			MEM_WB_Memtoreg <= 0;
	  MEM_WB_MemReadData <= DataMem_MemReadData;
	  MEM_WB_AluRes <= EX_MEM_AluRes;
	  MEM_WB_Regdst <= EX_MEM_Regdst;
	  end
end	 
endmodule
