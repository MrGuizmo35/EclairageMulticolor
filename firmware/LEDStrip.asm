
_interrupt:

;LEDStrip.c,5 :: 		void interrupt(void){
;LEDStrip.c,6 :: 		if(PEIE_bit == 1){
	BTFSS      PEIE_bit+0, BitPos(PEIE_bit+0)
	GOTO       L_interrupt0
;LEDStrip.c,7 :: 		if(RCIE_bit == 1 && RCIF_bit == 1){
	BTFSS      RCIE_bit+0, BitPos(RCIE_bit+0)
	GOTO       L_interrupt3
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_interrupt3
L__interrupt22:
;LEDStrip.c,8 :: 		RxTask();
	CALL       _RxTask+0
;LEDStrip.c,9 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;LEDStrip.c,12 :: 		}
L_interrupt4:
;LEDStrip.c,13 :: 		}
L_interrupt0:
;LEDStrip.c,14 :: 		}
L_end_interrupt:
L__interrupt24:
	RETFIE     %s
; end of _interrupt

_main:

;LEDStrip.c,16 :: 		void main(void) {
;LEDStrip.c,17 :: 		PIN_Initialize();
	CALL       _PIN_Initialize+0
;LEDStrip.c,18 :: 		OSCILLATOR_Initialize();
	CALL       _OSCILLATOR_Initialize+0
;LEDStrip.c,19 :: 		SPI_Initialize();
	CALL       _SPI_Initialize+0
;LEDStrip.c,20 :: 		TMR2_Initialize();
	CALL       _TMR2_Initialize+0
;LEDStrip.c,21 :: 		PWM3_Initialize();
	CALL       _PWM3_Initialize+0
;LEDStrip.c,22 :: 		CLC1_Initialize();
	CALL       _CLC1_Initialize+0
;LEDStrip.c,24 :: 		UART1_Init(115200);
	BSF        BAUDCON+0, 3
	MOVLW      68
	MOVWF      SPBRG+0
	MOVLW      0
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;LEDStrip.c,26 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;LEDStrip.c,27 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;LEDStrip.c,28 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RxTask:

;LEDStrip.c,30 :: 		void RxTask(void){
;LEDStrip.c,33 :: 		char c = UART_Read();
	CALL       _UART_Read+0
	MOVF       R0, 0
	MOVWF      RxTask_c_L0+0
;LEDStrip.c,34 :: 		switch (state){
	GOTO       L_RxTask5
;LEDStrip.c,35 :: 		case RX_STATE_START_1:{
L_RxTask7:
;LEDStrip.c,36 :: 		if(c == 0xDE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      222
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask8
;LEDStrip.c,37 :: 		state = RX_STATE_START_2;
	MOVLW      1
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,38 :: 		}
L_RxTask8:
;LEDStrip.c,39 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,41 :: 		case RX_STATE_START_2:{
L_RxTask9:
;LEDStrip.c,42 :: 		if(c == 0xAD){
	MOVF       RxTask_c_L0+0, 0
	XORLW      173
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask10
;LEDStrip.c,43 :: 		state = RX_STATE_LENGTH;
	MOVLW      2
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,44 :: 		}
	GOTO       L_RxTask11
L_RxTask10:
;LEDStrip.c,45 :: 		else if(c != 0xDE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      222
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask12
;LEDStrip.c,46 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,47 :: 		}
L_RxTask12:
L_RxTask11:
;LEDStrip.c,48 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,50 :: 		case RX_STATE_LENGTH:{
L_RxTask13:
;LEDStrip.c,52 :: 		state = RX_STATE_CMD;
	MOVLW      3
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,53 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,55 :: 		case RX_STATE_CMD:{
L_RxTask14:
;LEDStrip.c,57 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,59 :: 		case RX_STATE_DATA:{
L_RxTask15:
;LEDStrip.c,60 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,62 :: 		case RX_STATE_STOP_1:{
L_RxTask16:
;LEDStrip.c,63 :: 		if(c == 0xBE){
	MOVF       RxTask_c_L0+0, 0
	XORLW      190
	BTFSS      STATUS+0, 2
	GOTO       L_RxTask17
;LEDStrip.c,64 :: 		state = RX_STATE_STOP_2;
	MOVLW      7
	MOVWF      RxTask_state_L0+0
;LEDStrip.c,65 :: 		}
	GOTO       L_RxTask18
L_RxTask17:
;LEDStrip.c,67 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,68 :: 		}
L_RxTask18:
;LEDStrip.c,69 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,71 :: 		case RX_STATE_STOP_2:{
L_RxTask19:
;LEDStrip.c,72 :: 		state = RX_STATE_START_1;
	CLRF       RxTask_state_L0+0
;LEDStrip.c,73 :: 		break;
	GOTO       L_RxTask6
;LEDStrip.c,75 :: 		}
L_RxTask5:
	MOVF       RxTask_state_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask7
	MOVF       RxTask_state_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask9
	MOVF       RxTask_state_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask13
	MOVF       RxTask_state_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask14
	MOVF       RxTask_state_L0+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask15
	MOVF       RxTask_state_L0+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask16
	MOVF       RxTask_state_L0+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_RxTask19
L_RxTask6:
;LEDStrip.c,76 :: 		}
L_end_RxTask:
	RETURN
; end of _RxTask

_PIN_Initialize:

;LEDStrip.c,78 :: 		void PIN_Initialize(void){
;LEDStrip.c,79 :: 		ANSELA = 0;
	CLRF       ANSELA+0
;LEDStrip.c,80 :: 		ANSELB = 0;
	CLRF       ANSELB+0
;LEDStrip.c,81 :: 		ANSELC = 0;
	CLRF       ANSELC+0
;LEDStrip.c,83 :: 		TRISB5_bit = 1;
	BSF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;LEDStrip.c,84 :: 		RXPPS = 0x0D;   //RB5->EUSART:RX
	MOVLW      13
	MOVWF      RXPPS+0
;LEDStrip.c,85 :: 		RB7PPS = 0x06;   //RB7->EUSART:TX
	MOVLW      6
	MOVWF      RB7PPS+0
;LEDStrip.c,86 :: 		RA2PPS = 0x04;   //RA2->CLC1:CLC1OUT
	MOVLW      4
	MOVWF      RA2PPS+0
;LEDStrip.c,87 :: 		}
L_end_PIN_Initialize:
	RETURN
; end of _PIN_Initialize

_OSCILLATOR_Initialize:

;LEDStrip.c,89 :: 		void OSCILLATOR_Initialize(void){
;LEDStrip.c,91 :: 		OSCCON = 0x78;
	MOVLW      120
	MOVWF      OSCCON+0
;LEDStrip.c,93 :: 		OSCTUNE = 0x00;
	CLRF       OSCTUNE+0
;LEDStrip.c,95 :: 		BORCON = 0x00;
	CLRF       BORCON+0
;LEDStrip.c,98 :: 		}
L_OSCILLATOR_Initialize21:
;LEDStrip.c,99 :: 		}
L_end_OSCILLATOR_Initialize:
	RETURN
; end of _OSCILLATOR_Initialize

_SPI_Initialize:

;LEDStrip.c,101 :: 		void SPI_Initialize(void){
;LEDStrip.c,104 :: 		SSP1STAT = 0x00;
	CLRF       SSP1STAT+0
;LEDStrip.c,106 :: 		SSP1CON1 = 0x20;
	MOVLW      32
	MOVWF      SSP1CON1+0
;LEDStrip.c,108 :: 		SSP1ADD = 0x00;
	CLRF       SSP1ADD+0
;LEDStrip.c,109 :: 		}
L_end_SPI_Initialize:
	RETURN
; end of _SPI_Initialize

_CLC1_Initialize:

;LEDStrip.c,111 :: 		void CLC1_Initialize(void){
;LEDStrip.c,113 :: 		CLC1POL = 0x01;
	MOVLW      1
	MOVWF      CLC1POL+0
;LEDStrip.c,115 :: 		CLC1SEL0 = 0x0E;
	MOVLW      14
	MOVWF      CLC1SEL0+0
;LEDStrip.c,117 :: 		CLC1SEL1 = 0x27;
	MOVLW      39
	MOVWF      CLC1SEL1+0
;LEDStrip.c,119 :: 		CLC1SEL2 = 0x28;
	MOVLW      40
	MOVWF      CLC1SEL2+0
;LEDStrip.c,121 :: 		CLC1SEL3 = 0x0E;
	MOVLW      14
	MOVWF      CLC1SEL3+0
;LEDStrip.c,123 :: 		CLC1GLS0 = 0x05;
	MOVLW      5
	MOVWF      CLC1GLS0+0
;LEDStrip.c,125 :: 		CLC1GLS1 = 0x10;
	MOVLW      16
	MOVWF      CLC1GLS1+0
;LEDStrip.c,127 :: 		CLC1GLS2 = 0x08;
	MOVLW      8
	MOVWF      CLC1GLS2+0
;LEDStrip.c,129 :: 		CLC1GLS3 = 0x20;
	MOVLW      32
	MOVWF      CLC1GLS3+0
;LEDStrip.c,131 :: 		CLC1CON = 0x80;
	MOVLW      128
	MOVWF      CLC1CON+0
;LEDStrip.c,132 :: 		}
L_end_CLC1_Initialize:
	RETURN
; end of _CLC1_Initialize

_TMR2_Initialize:

;LEDStrip.c,134 :: 		void TMR2_Initialize(void){
;LEDStrip.c,137 :: 		T2CLKCON = 0x00;
	CLRF       T2CLKCON+0
;LEDStrip.c,139 :: 		T2HLT = 0x00;
	CLRF       T2HLT+0
;LEDStrip.c,141 :: 		T2RST = 0x00;
	CLRF       T2RST+0
;LEDStrip.c,143 :: 		T2PR = 0x13;
	MOVLW      19
	MOVWF      T2PR+0
;LEDStrip.c,145 :: 		T2TMR = 0x00;
	CLRF       T2TMR+0
;LEDStrip.c,147 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;LEDStrip.c,149 :: 		T2CON = 0x80;
	MOVLW      128
	MOVWF      T2CON+0
;LEDStrip.c,150 :: 		}
L_end_TMR2_Initialize:
	RETURN
; end of _TMR2_Initialize

_PWM3_Initialize:

;LEDStrip.c,152 :: 		void PWM3_Initialize(void){
;LEDStrip.c,155 :: 		PWM3CON = 0x80;
	MOVLW      128
	MOVWF      PWM3CON+0
;LEDStrip.c,157 :: 		PWM3DCH = 0x06;
	MOVLW      6
	MOVWF      PWM3DCH+0
;LEDStrip.c,159 :: 		PWM3DCL = 0x40;
	MOVLW      64
	MOVWF      PWM3DCL+0
;LEDStrip.c,160 :: 		}
L_end_PWM3_Initialize:
	RETURN
; end of _PWM3_Initialize
