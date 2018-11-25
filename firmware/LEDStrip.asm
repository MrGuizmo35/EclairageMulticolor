
_interrupt:

;LEDStrip.c,6 :: 		void interrupt(void){
;LEDStrip.c,7 :: 		if(PEIE_bit == 1){
	BTFSS      PEIE_bit+0, BitPos(PEIE_bit+0)
	GOTO       L_interrupt0
;LEDStrip.c,8 :: 		if(RCIE_bit == 1 && RCIF_bit == 1){
	BTFSS      RCIE_bit+0, BitPos(RCIE_bit+0)
	GOTO       L_interrupt3
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_interrupt3
L__interrupt49:
;LEDStrip.c,9 :: 		RxTask();
	CALL       _RxTask+0
;LEDStrip.c,10 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;LEDStrip.c,13 :: 		}
L_interrupt4:
;LEDStrip.c,14 :: 		}
L_interrupt0:
;LEDStrip.c,15 :: 		}
L_end_interrupt:
L__interrupt51:
	RETFIE     %s
; end of _interrupt

_main:

;LEDStrip.c,17 :: 		void main(void) {
;LEDStrip.c,18 :: 		int i = 0;
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
;LEDStrip.c,20 :: 		PIN_Initialize();
	CALL       _PIN_Initialize+0
;LEDStrip.c,21 :: 		OSCILLATOR_Initialize();
	CALL       _OSCILLATOR_Initialize+0
;LEDStrip.c,22 :: 		SPI_Initialize();
	CALL       _SPI_Initialize+0
;LEDStrip.c,23 :: 		TMR2_Initialize();
	CALL       _TMR2_Initialize+0
;LEDStrip.c,24 :: 		PWM3_Initialize();
	CALL       _PWM3_Initialize+0
;LEDStrip.c,25 :: 		CLC1_Initialize();
	CALL       _CLC1_Initialize+0
;LEDStrip.c,27 :: 		UART1_Init(115200);
	BSF        BAUDCON+0, 3
	MOVLW      68
	MOVWF      SPBRG+0
	MOVLW      0
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;LEDStrip.c,28 :: 		RCIF_bit = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;LEDStrip.c,29 :: 		RCIE_bit = 1;
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;LEDStrip.c,30 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;LEDStrip.c,31 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;LEDStrip.c,33 :: 		for(i = 0; i< 180; i++){
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
L_main5:
	MOVLW      128
	XORWF      main_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main53
	MOVLW      180
	SUBWF      main_i_L0+0, 0
L__main53:
	BTFSC      STATUS+0, 0
	GOTO       L_main6
;LEDStrip.c,34 :: 		leds_color[i] = (i%2 == 0 ? 16 : 0);
	MOVLW      _leds_color+0
	MOVWF      R0
	MOVLW      hi_addr(_leds_color+0)
	MOVWF      R1
	MOVF       main_i_L0+0, 0
	ADDWF      R0, 0
	MOVWF      FLOC__main+0
	MOVF       main_i_L0+1, 0
	ADDWFC     R1, 0
	MOVWF      FLOC__main+1
	MOVLW      2
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       main_i_L0+0, 0
	MOVWF      R0
	MOVF       main_i_L0+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVLW      0
	XORWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main54
	MOVLW      0
	XORWF      R0, 0
L__main54:
	BTFSS      STATUS+0, 2
	GOTO       L_main8
	MOVLW      16
	MOVWF      ?FLOC___mainT11+0
	GOTO       L_main9
L_main8:
	CLRF       ?FLOC___mainT11+0
L_main9:
	MOVF       FLOC__main+0, 0
	MOVWF      FSR1L
	MOVF       FLOC__main+1, 0
	MOVWF      FSR1H
	MOVF       ?FLOC___mainT11+0, 0
	MOVWF      INDF1+0
;LEDStrip.c,33 :: 		for(i = 0; i< 180; i++){
	INCF       main_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_i_L0+1, 1
;LEDStrip.c,35 :: 		}
	GOTO       L_main5
L_main6:
;LEDStrip.c,37 :: 		for(i = 0; i < 180; i++){
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
L_main10:
	MOVLW      128
	XORWF      main_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main55
	MOVLW      180
	SUBWF      main_i_L0+0, 0
L__main55:
	BTFSC      STATUS+0, 0
	GOTO       L_main11
;LEDStrip.c,39 :: 		SSP1BUF = leds_color[i];
	MOVLW      _leds_color+0
	MOVWF      R0
	MOVLW      hi_addr(_leds_color+0)
	MOVWF      R1
	MOVF       main_i_L0+0, 0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVF       main_i_L0+1, 0
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      SSP1BUF+0
;LEDStrip.c,40 :: 		while(BF_bit == 0);
L_main13:
	BTFSC      BF_bit+0, BitPos(BF_bit+0)
	GOTO       L_main14
	GOTO       L_main13
L_main14:
;LEDStrip.c,37 :: 		for(i = 0; i < 180; i++){
	INCF       main_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_i_L0+1, 1
;LEDStrip.c,42 :: 		}
	GOTO       L_main10
L_main11:
;LEDStrip.c,44 :: 		while(1){
L_main15:
;LEDStrip.c,45 :: 		if(setLedsColorNow == true){
	MOVF       _setLedsColorNow+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;LEDStrip.c,46 :: 		uint8_t pixelIndex = 0;
	CLRF       main_pixelIndex_L2+0
;LEDStrip.c,47 :: 		setLedsColorNow = false;
	CLRF       _setLedsColorNow+0
;LEDStrip.c,48 :: 		for(pixelIndex = 0; pixelIndex < 180; pixelIndex++){
	CLRF       main_pixelIndex_L2+0
L_main18:
	MOVLW      180
	SUBWF      main_pixelIndex_L2+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main19
;LEDStrip.c,50 :: 		SSP1BUF = leds_color[pixelIndex];
	MOVLW      _leds_color+0
	MOVWF      R0
	MOVLW      hi_addr(_leds_color+0)
	MOVWF      R1
	MOVF       main_pixelIndex_L2+0, 0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      SSP1BUF+0
;LEDStrip.c,51 :: 		while(BF_bit == 0);
L_main21:
	BTFSC      BF_bit+0, BitPos(BF_bit+0)
	GOTO       L_main22
	GOTO       L_main21
L_main22:
;LEDStrip.c,48 :: 		for(pixelIndex = 0; pixelIndex < 180; pixelIndex++){
	INCF       main_pixelIndex_L2+0, 1
;LEDStrip.c,53 :: 		}
	GOTO       L_main18
L_main19:
;LEDStrip.c,54 :: 		UART1_Write_Text("OK\r\n");
	MOVLW      ?lstr1_LEDStrip+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(?lstr1_LEDStrip+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;LEDStrip.c,55 :: 		}
L_main17:
;LEDStrip.c,56 :: 		}
	GOTO       L_main15
;LEDStrip.c,57 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RxTask:

;LEDStrip.c,59 :: 		void RxTask(void){
;LEDStrip.c,66 :: 		char c = UART_Read();
	CALL       _UART_Read+0
	MOVF       R0, 0
	MOVWF      RxTask_c_L0+0
;LEDStrip.c,67 :: 		switch(state){
	GOTO       L_RxTask23
;LEDStrip.c,68 :: 		case RX_STATE_START_1:{
L_RxTask25:
;LEDStrip.c,69 :: 		if(c == 0xDE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      222
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask26
;LEDStrip.c,70 :: 		state = RX_STATE_START_2;
	MOVLW      1
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,71 :: 		}
L_RxTask26:
;LEDStrip.c,72 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,74 :: 		case RX_STATE_START_2:{
L_RxTask27:
;LEDStrip.c,75 :: 		if(c == 0xAD){
	MOVF       RxTask_c_L0+0, 0
	XORLW      173
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask28
;LEDStrip.c,76 :: 		checksum = 0;
	CLRF       RxTask_checksum_L0+0
;LEDStrip.c,77 :: 		state = RX_STATE_LENGTH;
	MOVLW      2
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,78 :: 		}
	GOTO       L_RxTask29
L_RxTask28:
;LEDStrip.c,79 :: 		else if(c != 0xDE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      222
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask30
;LEDStrip.c,80 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,81 :: 		}
L_RxTask30:
L_RxTask29:
;LEDStrip.c,82 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,84 :: 		case RX_STATE_LENGTH:{
L_RxTask31:
;LEDStrip.c,85 :: 		dataLength = c;
	MOVF       RxTask_c_L0+0, 0
	MOVWF      RxTask_dataLength_L0+0
;LEDStrip.c,86 :: 		checksum ^= c;
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 1
;LEDStrip.c,87 :: 		state = RX_STATE_CMD;
	MOVLW      3
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,88 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,90 :: 		case RX_STATE_CMD:{
L_RxTask32:
;LEDStrip.c,91 :: 		cmdBuffer = c;
	MOVF       RxTask_c_L0+0, 0
	MOVWF      RxTask_cmdBuffer_L0+0
;LEDStrip.c,92 :: 		checksum ^= c;
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 1
;LEDStrip.c,93 :: 		dataIndex = 0;
	CLRF       RxTask_dataIndex_L0+0
;LEDStrip.c,94 :: 		state = RX_STATE_DATA;
	MOVLW      4
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,95 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,97 :: 		case RX_STATE_DATA:{
L_RxTask33:
;LEDStrip.c,98 :: 		checksum ^= c;
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 1
;LEDStrip.c,99 :: 		messageBuffer[dataIndex++] = c;
	MOVLW      RxTask_messageBuffer_L0+0
	MOVWF      R0
	MOVLW      hi_addr(RxTask_messageBuffer_L0+0)
	MOVWF      R1
	MOVF       RxTask_dataIndex_L0+0, 0
	ADDWF      R0, 0
	MOVWF      FSR1L
	MOVLW      0
	ADDWFC     R1, 0
	MOVWF      FSR1H
	MOVF       RxTask_c_L0+0, 0
	MOVWF      INDF1+0
	INCF       RxTask_dataIndex_L0+0, 1
;LEDStrip.c,100 :: 		if(dataIndex  >= dataLength){
	MOVF       RxTask_dataLength_L0+0, 0
	SUBWF      RxTask_dataIndex_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_RxTask34
;LEDStrip.c,101 :: 		state = RX_STATE_CHECKSUM;
	MOVLW      5
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,102 :: 		}
L_RxTask34:
;LEDStrip.c,103 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,105 :: 		case RX_STATE_CHECKSUM:{
L_RxTask35:
;LEDStrip.c,106 :: 		if(c == checksum){
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask36
;LEDStrip.c,107 :: 		state = RX_STATE_STOP_1;
	MOVLW      6
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,108 :: 		}
	GOTO       L_RxTask37
L_RxTask36:
;LEDStrip.c,110 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,111 :: 		}
L_RxTask37:
;LEDStrip.c,112 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,114 :: 		case RX_STATE_STOP_1:{
L_RxTask38:
;LEDStrip.c,115 :: 		if(c == 0xBE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      190
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask39
;LEDStrip.c,116 :: 		state = RX_STATE_STOP_2;
	MOVLW      7
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,117 :: 		}
	GOTO       L_RxTask40
L_RxTask39:
;LEDStrip.c,119 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,120 :: 		}
L_RxTask40:
;LEDStrip.c,121 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,123 :: 		case RX_STATE_STOP_2:{
L_RxTask41:
;LEDStrip.c,124 :: 		if(c == 0xEF){
	MOVF       RxTask_c_L0+0, 0
	XORLW      239
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask42
;LEDStrip.c,125 :: 		switch(cmdBuffer){
	GOTO       L_RxTask43
;LEDStrip.c,126 :: 		case CMD_SET_LEDS:{
L_RxTask45:
;LEDStrip.c,127 :: 		memcpy(leds_color,messageBuffer,180);
	MOVLW      _leds_color+0
	MOVWF      FARG_memcpy_d1+0
	MOVLW      hi_addr(_leds_color+0)
	MOVWF      FARG_memcpy_d1+1
	MOVLW      RxTask_messageBuffer_L0+0
	MOVWF      FARG_memcpy_s1+0
	MOVLW      hi_addr(RxTask_messageBuffer_L0+0)
	MOVWF      FARG_memcpy_s1+1
	MOVLW      180
	MOVWF      FARG_memcpy_n+0
	CLRF       FARG_memcpy_n+1
	CALL       _memcpy+0
;LEDStrip.c,128 :: 		setLedsColorNow = true;
	MOVLW      1
	MOVWF      _setLedsColorNow+0
;LEDStrip.c,129 :: 		break;
	GOTO       L_RxTask44
;LEDStrip.c,131 :: 		default:{
L_RxTask46:
;LEDStrip.c,132 :: 		break;
	GOTO       L_RxTask44
;LEDStrip.c,134 :: 		}
L_RxTask43:
	MOVF       RxTask_cmdBuffer_L0+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask45
	GOTO       L_RxTask46
L_RxTask44:
;LEDStrip.c,135 :: 		}
L_RxTask42:
;LEDStrip.c,136 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,137 :: 		break;
	GOTO       L_RxTask24
;LEDStrip.c,139 :: 		}
L_RxTask23:
	MOVF       RxTask_state_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask25
	MOVF       RxTask_state_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask27
	MOVF       RxTask_state_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask31
	MOVF       RxTask_state_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask32
	MOVF       RxTask_state_L0+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask33
	MOVF       RxTask_state_L0+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask35
	MOVF       RxTask_state_L0+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask38
	MOVF       RxTask_state_L0+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask41
L_RxTask24:
;LEDStrip.c,140 :: 		}
L_end_RxTask:
	RETURN
; end of _RxTask

_PIN_Initialize:

;LEDStrip.c,142 :: 		void PIN_Initialize(void){
;LEDStrip.c,143 :: 		ANSELA = 0;
	CLRF       ANSELA+0
;LEDStrip.c,144 :: 		ANSELB = 0;
	CLRF       ANSELB+0
;LEDStrip.c,145 :: 		ANSELC = 0;
	CLRF       ANSELC+0
;LEDStrip.c,146 :: 		TRISB5_bit = 1;
	BSF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;LEDStrip.c,147 :: 		RXPPS = 0x0D;//RB5->EUSART:RX
	MOVLW      13
	MOVWF      RXPPS+0
;LEDStrip.c,148 :: 		RB7PPS = 0x06;//RB7->EUSART:TX
	MOVLW      6
	MOVWF      RB7PPS+0
;LEDStrip.c,149 :: 		RA2PPS = 0x04;//RA2->CLC1:CLC1OUT
	MOVLW      4
	MOVWF      RA2PPS+0
;LEDStrip.c,150 :: 		TRISA2_bit = 0;
	BCF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;LEDStrip.c,151 :: 		}
L_end_PIN_Initialize:
	RETURN
; end of _PIN_Initialize

_OSCILLATOR_Initialize:

;LEDStrip.c,153 :: 		void OSCILLATOR_Initialize(void){
;LEDStrip.c,155 :: 		OSCCON = 0x78;
	MOVLW      120
	MOVWF      OSCCON+0
;LEDStrip.c,157 :: 		OSCTUNE = 0x00;
	CLRF       OSCTUNE+0
;LEDStrip.c,159 :: 		BORCON = 0x00;
	CLRF       BORCON+0
;LEDStrip.c,162 :: 		}
L_OSCILLATOR_Initialize48:
;LEDStrip.c,163 :: 		}
L_end_OSCILLATOR_Initialize:
	RETURN
; end of _OSCILLATOR_Initialize

_SPI_Initialize:

;LEDStrip.c,165 :: 		void SPI_Initialize(void){
;LEDStrip.c,168 :: 		SSP1STAT = 0x00;
	CLRF       SSP1STAT+0
;LEDStrip.c,170 :: 		SSP1CON1 = 0x23;
	MOVLW      35
	MOVWF      SSP1CON1+0
;LEDStrip.c,172 :: 		SSP1ADD = 0x00;
	CLRF       SSP1ADD+0
;LEDStrip.c,173 :: 		}
L_end_SPI_Initialize:
	RETURN
; end of _SPI_Initialize

_CLC1_Initialize:

;LEDStrip.c,175 :: 		void CLC1_Initialize(void){
;LEDStrip.c,177 :: 		CLC1POL = 0x01;
	MOVLW      1
	MOVWF      CLC1POL+0
;LEDStrip.c,179 :: 		CLC1SEL0 = 0x0E;
	MOVLW      14
	MOVWF      CLC1SEL0+0
;LEDStrip.c,181 :: 		CLC1SEL1 = 0x27;
	MOVLW      39
	MOVWF      CLC1SEL1+0
;LEDStrip.c,183 :: 		CLC1SEL2 = 0x28;
	MOVLW      40
	MOVWF      CLC1SEL2+0
;LEDStrip.c,185 :: 		CLC1SEL3 = 0x0E;
	MOVLW      14
	MOVWF      CLC1SEL3+0
;LEDStrip.c,187 :: 		CLC1GLS0 = 0x05;
	MOVLW      5
	MOVWF      CLC1GLS0+0
;LEDStrip.c,189 :: 		CLC1GLS1 = 0x10;
	MOVLW      16
	MOVWF      CLC1GLS1+0
;LEDStrip.c,191 :: 		CLC1GLS2 = 0x08;
	MOVLW      8
	MOVWF      CLC1GLS2+0
;LEDStrip.c,193 :: 		CLC1GLS3 = 0x20;
	MOVLW      32
	MOVWF      CLC1GLS3+0
;LEDStrip.c,195 :: 		CLC1CON = 0x80;
	MOVLW      128
	MOVWF      CLC1CON+0
;LEDStrip.c,196 :: 		}
L_end_CLC1_Initialize:
	RETURN
; end of _CLC1_Initialize

_TMR2_Initialize:

;LEDStrip.c,198 :: 		void TMR2_Initialize(void){
;LEDStrip.c,201 :: 		T2CLKCON = 0x00;
	CLRF       T2CLKCON+0
;LEDStrip.c,203 :: 		T2HLT = 0x00;
	CLRF       T2HLT+0
;LEDStrip.c,205 :: 		T2RST = 0x00;
	CLRF       T2RST+0
;LEDStrip.c,207 :: 		T2PR = 5;
	MOVLW      5
	MOVWF      T2PR+0
;LEDStrip.c,209 :: 		T2TMR = 0x00;
	CLRF       T2TMR+0
;LEDStrip.c,211 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;LEDStrip.c,213 :: 		T2CON = 0x80;
	MOVLW      128
	MOVWF      T2CON+0
;LEDStrip.c,214 :: 		}
L_end_TMR2_Initialize:
	RETURN
; end of _TMR2_Initialize

_PWM3_Initialize:

;LEDStrip.c,216 :: 		void PWM3_Initialize(void){
;LEDStrip.c,218 :: 		PWM3CON = 0x80;
	MOVLW      128
	MOVWF      PWM3CON+0
;LEDStrip.c,220 :: 		PWM3DCH = 0x03;
	MOVLW      3
	MOVWF      PWM3DCH+0
;LEDStrip.c,222 :: 		PWM3DCL = 0x00;
	CLRF       PWM3DCL+0
;LEDStrip.c,223 :: 		}
L_end_PWM3_Initialize:
	RETURN
; end of _PWM3_Initialize
