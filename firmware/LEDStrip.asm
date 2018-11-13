
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
L__interrupt39:
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
L__interrupt41:
	RETFIE     %s
; end of _interrupt

_main:

;LEDStrip.c,17 :: 		void main(void) {
;LEDStrip.c,18 :: 		PIN_Initialize();
	CALL       _PIN_Initialize+0
;LEDStrip.c,19 :: 		OSCILLATOR_Initialize();
	CALL       _OSCILLATOR_Initialize+0
;LEDStrip.c,20 :: 		SPI_Initialize();
	CALL       _SPI_Initialize+0
;LEDStrip.c,21 :: 		TMR2_Initialize();
	CALL       _TMR2_Initialize+0
;LEDStrip.c,22 :: 		PWM3_Initialize();
	CALL       _PWM3_Initialize+0
;LEDStrip.c,23 :: 		CLC1_Initialize();
	CALL       _CLC1_Initialize+0
;LEDStrip.c,25 :: 		UART1_Init(115200);
	BSF        BAUDCON+0, 3
	MOVLW      68
	MOVWF      SPBRG+0
	MOVLW      0
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;LEDStrip.c,26 :: 		RCIF_bit = 0;
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;LEDStrip.c,27 :: 		RCIE_bit = 1;
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;LEDStrip.c,28 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;LEDStrip.c,29 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;LEDStrip.c,31 :: 		while(1){
L_main5:
;LEDStrip.c,32 :: 		if(setLedsColorNow == true){
	MOVF       _setLedsColorNow+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;LEDStrip.c,33 :: 		uint8_t pixelIndex = 0;
	CLRF       main_pixelIndex_L2+0
;LEDStrip.c,34 :: 		setLedsColorNow = false;
	CLRF       _setLedsColorNow+0
;LEDStrip.c,35 :: 		for(pixelIndex = 0; pixelIndex < 180; pixelIndex++){
	CLRF       main_pixelIndex_L2+0
L_main8:
	MOVLW      180
	SUBWF      main_pixelIndex_L2+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main9
;LEDStrip.c,37 :: 		SSP1BUF = leds_color[pixelIndex];
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
;LEDStrip.c,38 :: 		while(BF_bit == 0);
L_main11:
	BTFSC      BF_bit+0, BitPos(BF_bit+0)
	GOTO       L_main12
	GOTO       L_main11
L_main12:
;LEDStrip.c,35 :: 		for(pixelIndex = 0; pixelIndex < 180; pixelIndex++){
	INCF       main_pixelIndex_L2+0, 1
;LEDStrip.c,40 :: 		}
	GOTO       L_main8
L_main9:
;LEDStrip.c,41 :: 		UART1_Write_Text("OK\r\n");
	MOVLW      ?lstr1_LEDStrip+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	MOVLW      hi_addr(?lstr1_LEDStrip+0)
	MOVWF      FARG_UART1_Write_Text_uart_text+1
	CALL       _UART1_Write_Text+0
;LEDStrip.c,42 :: 		}
L_main7:
;LEDStrip.c,43 :: 		}
	GOTO       L_main5
;LEDStrip.c,44 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RxTask:

;LEDStrip.c,46 :: 		void RxTask(void){
;LEDStrip.c,53 :: 		char c = UART_Read();
	CALL       _UART_Read+0
	MOVF       R0, 0
	MOVWF      RxTask_c_L0+0
;LEDStrip.c,54 :: 		switch (state){
	GOTO       L_RxTask13
;LEDStrip.c,55 :: 		case RX_STATE_START_1:{
L_RxTask15:
;LEDStrip.c,56 :: 		if(c == 0xDE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      222
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask16
;LEDStrip.c,57 :: 		state = RX_STATE_START_2;
	MOVLW      1
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,58 :: 		}
L_RxTask16:
;LEDStrip.c,59 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,61 :: 		case RX_STATE_START_2:{
L_RxTask17:
;LEDStrip.c,62 :: 		if(c == 0xAD){
	MOVF       RxTask_c_L0+0, 0
	XORLW      173
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask18
;LEDStrip.c,63 :: 		checksum = 0;
	CLRF       RxTask_checksum_L0+0
;LEDStrip.c,64 :: 		state = RX_STATE_LENGTH;
	MOVLW      2
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,65 :: 		}
	GOTO       L_RxTask19
L_RxTask18:
;LEDStrip.c,66 :: 		else if(c != 0xDE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      222
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask20
;LEDStrip.c,67 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,68 :: 		}
L_RxTask20:
L_RxTask19:
;LEDStrip.c,69 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,71 :: 		case RX_STATE_LENGTH:{
L_RxTask21:
;LEDStrip.c,72 :: 		dataLength = c;
	MOVF       RxTask_c_L0+0, 0
	MOVWF      RxTask_dataLength_L0+0
;LEDStrip.c,73 :: 		checksum ^= c;
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 1
;LEDStrip.c,74 :: 		state = RX_STATE_CMD;
	MOVLW      3
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,75 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,77 :: 		case RX_STATE_CMD:{
L_RxTask22:
;LEDStrip.c,78 :: 		cmdBuffer = c;
	MOVF       RxTask_c_L0+0, 0
	MOVWF      RxTask_cmdBuffer_L0+0
;LEDStrip.c,79 :: 		checksum ^= c;
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 1
;LEDStrip.c,80 :: 		dataIndex = 0;
	CLRF       RxTask_dataIndex_L0+0
;LEDStrip.c,81 :: 		state = RX_STATE_DATA;
	MOVLW      4
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,82 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,84 :: 		case RX_STATE_DATA:{
L_RxTask23:
;LEDStrip.c,85 :: 		checksum ^= c;
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 1
;LEDStrip.c,86 :: 		messageBuffer[dataIndex++] = c;
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
;LEDStrip.c,87 :: 		if(dataIndex  >= dataLength){
	MOVF       RxTask_dataLength_L0+0, 0
	SUBWF      RxTask_dataIndex_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_RxTask24
;LEDStrip.c,88 :: 		state = RX_STATE_CHECKSUM;
	MOVLW      5
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,89 :: 		}
L_RxTask24:
;LEDStrip.c,90 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,92 :: 		case RX_STATE_CHECKSUM:{
L_RxTask25:
;LEDStrip.c,93 :: 		if(c == checksum){
	MOVF       RxTask_c_L0+0, 0
	XORWF      RxTask_checksum_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask26
;LEDStrip.c,94 :: 		state = RX_STATE_STOP_1;
	MOVLW      6
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,95 :: 		}
	GOTO       L_RxTask27
L_RxTask26:
;LEDStrip.c,97 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,98 :: 		}
L_RxTask27:
;LEDStrip.c,99 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,101 :: 		case RX_STATE_STOP_1:{
L_RxTask28:
;LEDStrip.c,102 :: 		if(c == 0xBE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      190
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask29
;LEDStrip.c,103 :: 		state = RX_STATE_STOP_2;
	MOVLW      7
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,104 :: 		}
	GOTO       L_RxTask30
L_RxTask29:
;LEDStrip.c,106 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,107 :: 		}
L_RxTask30:
;LEDStrip.c,108 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,110 :: 		case RX_STATE_STOP_2:{
L_RxTask31:
;LEDStrip.c,111 :: 		if(c == 0xEF){
	MOVF       RxTask_c_L0+0, 0
	XORLW      239
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask32
;LEDStrip.c,112 :: 		switch(cmdBuffer){
	GOTO       L_RxTask33
;LEDStrip.c,113 :: 		case CMD_SET_LEDS:{
L_RxTask35:
;LEDStrip.c,114 :: 		memcpy(messageBuffer,leds_color,180);
	MOVLW      RxTask_messageBuffer_L0+0
	MOVWF      FARG_memcpy_d1+0
	MOVLW      hi_addr(RxTask_messageBuffer_L0+0)
	MOVWF      FARG_memcpy_d1+1
	MOVLW      _leds_color+0
	MOVWF      FARG_memcpy_s1+0
	MOVLW      hi_addr(_leds_color+0)
	MOVWF      FARG_memcpy_s1+1
	MOVLW      180
	MOVWF      FARG_memcpy_n+0
	CLRF       FARG_memcpy_n+1
	CALL       _memcpy+0
;LEDStrip.c,115 :: 		setLedsColorNow = true;
	MOVLW      1
	MOVWF      _setLedsColorNow+0
;LEDStrip.c,116 :: 		break;
	GOTO       L_RxTask34
;LEDStrip.c,118 :: 		default:{
L_RxTask36:
;LEDStrip.c,119 :: 		break;
	GOTO       L_RxTask34
;LEDStrip.c,121 :: 		}
L_RxTask33:
	MOVF       RxTask_cmdBuffer_L0+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask35
	GOTO       L_RxTask36
L_RxTask34:
;LEDStrip.c,122 :: 		}
L_RxTask32:
;LEDStrip.c,123 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,124 :: 		break;
	GOTO       L_RxTask14
;LEDStrip.c,126 :: 		}
L_RxTask13:
	MOVF       RxTask_state_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask15
	MOVF       RxTask_state_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask17
	MOVF       RxTask_state_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask21
	MOVF       RxTask_state_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask22
	MOVF       RxTask_state_L0+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask23
	MOVF       RxTask_state_L0+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask25
	MOVF       RxTask_state_L0+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask28
	MOVF       RxTask_state_L0+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask31
L_RxTask14:
;LEDStrip.c,127 :: 		}
L_end_RxTask:
	RETURN
; end of _RxTask

_PIN_Initialize:

;LEDStrip.c,129 :: 		void PIN_Initialize(void){
;LEDStrip.c,130 :: 		ANSELA = 0;
	CLRF       ANSELA+0
;LEDStrip.c,131 :: 		ANSELB = 0;
	CLRF       ANSELB+0
;LEDStrip.c,132 :: 		ANSELC = 0;
	CLRF       ANSELC+0
;LEDStrip.c,133 :: 		TRISB5_bit = 1;
	BSF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;LEDStrip.c,134 :: 		RXPPS = 0x0D;   //RB5->EUSART:RX
	MOVLW      13
	MOVWF      RXPPS+0
;LEDStrip.c,135 :: 		RB7PPS = 0x06;   //RB7->EUSART:TX
	MOVLW      6
	MOVWF      RB7PPS+0
;LEDStrip.c,136 :: 		RA2PPS = 0x04;   //RA2->CLC1:CLC1OUT
	MOVLW      4
	MOVWF      RA2PPS+0
;LEDStrip.c,137 :: 		}
L_end_PIN_Initialize:
	RETURN
; end of _PIN_Initialize

_OSCILLATOR_Initialize:

;LEDStrip.c,139 :: 		void OSCILLATOR_Initialize(void){
;LEDStrip.c,141 :: 		OSCCON = 0x78;
	MOVLW      120
	MOVWF      OSCCON+0
;LEDStrip.c,143 :: 		OSCTUNE = 0x00;
	CLRF       OSCTUNE+0
;LEDStrip.c,145 :: 		BORCON = 0x00;
	CLRF       BORCON+0
;LEDStrip.c,148 :: 		}
L_OSCILLATOR_Initialize38:
;LEDStrip.c,149 :: 		}
L_end_OSCILLATOR_Initialize:
	RETURN
; end of _OSCILLATOR_Initialize

_SPI_Initialize:

;LEDStrip.c,151 :: 		void SPI_Initialize(void){
;LEDStrip.c,154 :: 		SSP1STAT = 0x00;
	CLRF       SSP1STAT+0
;LEDStrip.c,156 :: 		SSP1CON1 = 0x20;
	MOVLW      32
	MOVWF      SSP1CON1+0
;LEDStrip.c,158 :: 		SSP1ADD = 0x00;
	CLRF       SSP1ADD+0
;LEDStrip.c,159 :: 		}
L_end_SPI_Initialize:
	RETURN
; end of _SPI_Initialize

_CLC1_Initialize:

;LEDStrip.c,161 :: 		void CLC1_Initialize(void){
;LEDStrip.c,163 :: 		CLC1POL = 0x01;
	MOVLW      1
	MOVWF      CLC1POL+0
;LEDStrip.c,165 :: 		CLC1SEL0 = 0x0E;
	MOVLW      14
	MOVWF      CLC1SEL0+0
;LEDStrip.c,167 :: 		CLC1SEL1 = 0x27;
	MOVLW      39
	MOVWF      CLC1SEL1+0
;LEDStrip.c,169 :: 		CLC1SEL2 = 0x28;
	MOVLW      40
	MOVWF      CLC1SEL2+0
;LEDStrip.c,171 :: 		CLC1SEL3 = 0x0E;
	MOVLW      14
	MOVWF      CLC1SEL3+0
;LEDStrip.c,173 :: 		CLC1GLS0 = 0x05;
	MOVLW      5
	MOVWF      CLC1GLS0+0
;LEDStrip.c,175 :: 		CLC1GLS1 = 0x10;
	MOVLW      16
	MOVWF      CLC1GLS1+0
;LEDStrip.c,177 :: 		CLC1GLS2 = 0x08;
	MOVLW      8
	MOVWF      CLC1GLS2+0
;LEDStrip.c,179 :: 		CLC1GLS3 = 0x20;
	MOVLW      32
	MOVWF      CLC1GLS3+0
;LEDStrip.c,181 :: 		CLC1CON = 0x80;
	MOVLW      128
	MOVWF      CLC1CON+0
;LEDStrip.c,182 :: 		}
L_end_CLC1_Initialize:
	RETURN
; end of _CLC1_Initialize

_TMR2_Initialize:

;LEDStrip.c,184 :: 		void TMR2_Initialize(void){
;LEDStrip.c,187 :: 		T2CLKCON = 0x00;
	CLRF       T2CLKCON+0
;LEDStrip.c,189 :: 		T2HLT = 0x00;
	CLRF       T2HLT+0
;LEDStrip.c,191 :: 		T2RST = 0x00;
	CLRF       T2RST+0
;LEDStrip.c,193 :: 		T2PR = 0x13;
	MOVLW      19
	MOVWF      T2PR+0
;LEDStrip.c,195 :: 		T2TMR = 0x00;
	CLRF       T2TMR+0
;LEDStrip.c,197 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;LEDStrip.c,199 :: 		T2CON = 0x80;
	MOVLW      128
	MOVWF      T2CON+0
;LEDStrip.c,200 :: 		}
L_end_TMR2_Initialize:
	RETURN
; end of _TMR2_Initialize

_PWM3_Initialize:

;LEDStrip.c,202 :: 		void PWM3_Initialize(void){
;LEDStrip.c,204 :: 		PWM3CON = 0x80;
	MOVLW      128
	MOVWF      PWM3CON+0
;LEDStrip.c,206 :: 		PWM3DCH = 0x06;
	MOVLW      6
	MOVWF      PWM3DCH+0
;LEDStrip.c,208 :: 		PWM3DCL = 0x40;
	MOVLW      64
	MOVWF      PWM3DCL+0
;LEDStrip.c,209 :: 		}
L_end_PWM3_Initialize:
	RETURN
; end of _PWM3_Initialize
