#include "LEDStrip.h"

bool setLedsColorNow = false;
uint8_t leds_color[180];

void interrupt(void){
        if(PEIE_bit == 1){
                if(RCIE_bit == 1 && RCIF_bit == 1){
                        RxTask();
                }
                else{
                        //Interruptions non g�r�es
                }
        }
}

void main(void) {
        int i = 0;

        PIN_Initialize();
        OSCILLATOR_Initialize();
        SPI_Initialize();
        TMR2_Initialize();
        PWM3_Initialize();
        CLC1_Initialize();

        UART1_Init(115200);
        RCIF_bit = 0;
        RCIE_bit = 1;
        GIE_bit = 1;
        PEIE_bit = 1;

        for(i = 0; i< 180; i++){
                leds_color[i] = (i%2 == 0 ? 16 : 0);
        }

        for(i = 0; i < 180; i++){
                uint8_t dummy;
                SSP1BUF = leds_color[i];
                while(BF_bit == 0);
                dummy = SSP1BUF;
        }

        while(1){
                if(setLedsColorNow == true){
                        uint8_t pixelIndex = 0;
                        setLedsColorNow = false;
                        for(pixelIndex = 0; pixelIndex < 180; pixelIndex++){
                                uint8_t dummy;
                                SSP1BUF = leds_color[pixelIndex];
                                while(BF_bit == 0);
                                dummy = SSP1BUF;
                        }
                        UART1_Write_Text("OK\r\n");
                }
        }
}

void RxTask(void){
        static RX_STATE_t state = RX_STATE_START_1;
        static uint8_t dataLength = 0;
        static uint8_t messageBuffer[200];
        static uint8_t cmdBuffer = 0;
        static uint8_t dataIndex = 0;
        static uint8_t checksum = 0;
        char c = UART_Read();
        switch(state){
                case RX_STATE_START_1:{
                        if(c == 0xDE){
                                state = RX_STATE_START_2;
                        }
                        break;
                }
                case RX_STATE_START_2:{
                        if(c == 0xAD){
                                checksum = 0;
                                state = RX_STATE_LENGTH;
                        }
                        else if(c != 0xDE){
                                state = RX_STATE_START_1;
                        }
                        break;
                }
                case RX_STATE_LENGTH:{
                        dataLength = c;
                        checksum ^= c;
                        state = RX_STATE_CMD;
                        break;
                }
                case RX_STATE_CMD:{
                        cmdBuffer = c;
                        checksum ^= c;
                        dataIndex = 0;
                        state = RX_STATE_DATA;
                        break;
                }
                case RX_STATE_DATA:{
                        checksum ^= c;
                        messageBuffer[dataIndex++] = c;
                        if(dataIndex  >= dataLength){
                                state = RX_STATE_CHECKSUM;
                        }
                        break;
                }
                case RX_STATE_CHECKSUM:{
                        if(c == checksum){
                                state = RX_STATE_STOP_1;
                        }
                        else{
                                state = RX_STATE_START_1;
                        }
                        break;
                }
                case RX_STATE_STOP_1:{
                        if(c == 0xBE){
                                state = RX_STATE_STOP_2;
                        }
                        else{
                                state = RX_STATE_START_1;
                        }
                        break;
                }
                case RX_STATE_STOP_2:{
                        if(c == 0xEF){
                                switch(cmdBuffer){
                                        case CMD_SET_LEDS:{
                                                memcpy(leds_color,messageBuffer,180);
                                                setLedsColorNow = true;
                                                break;
                                        }
                                        default:{
                                                break;
                                        }
                                }
                        }
                        state = RX_STATE_START_1;
                        break;
                }
        }
}

void PIN_Initialize(void){
        ANSELA = 0;
        ANSELB = 0;
        ANSELC = 0;
        TRISB5_bit = 1;
        RXPPS = 0x0D;//RB5->EUSART:RX
        RB7PPS = 0x06;//RB7->EUSART:TX
        RA2PPS = 0x04;//RA2->CLC1:CLC1OUT
        TRISA2_bit = 0;
}

void OSCILLATOR_Initialize(void){
        // SCS FOSC; SPLLEN disabled; IRCF 16MHz_HF;
        OSCCON = 0x78;
        // TUN 0;
        OSCTUNE = 0x00;
        // SBOREN disabled; BORFS disabled;
        BORCON = 0x00;
        // Wait for PLL to stabilize
        while(PLLR == 0){
        }
}

void SPI_Initialize(void){
        // Set the SPI module to the options selected in the User Interface
        // R_nW write_noTX; P stopbit_notdetected; S startbit_notdetected; BF RCinprocess_TXcomplete; SMP Middle; UA dontupdate; CKE Idle to Active; D_nA lastbyte_address;
        SSP1STAT = 0x00;
        // SSPEN enabled; WCOL no_collision; CKP Idle:Low, Active:High; SSPM TMR2; SSPOV no_overflow;
        SSP1CON1 = 0x23;
        // SSP1ADD 0;
        SSP1ADD = 0x00;
}

void CLC1_Initialize(void){
        // LC1G1POL inverted; LC1G2POL not_inverted; LC1G3POL not_inverted; LC1G4POL not_inverted; LC1POL not_inverted;
        CLC1POL = 0x01;
        // LC1D1S PWM3_out;
        CLC1SEL0 = 0x0E;
        // LC1D2S SCK from MSSP;
        CLC1SEL1 = 0x27;
        // LC1D3S SDO from MSSP;
        CLC1SEL2 = 0x28;
        // LC1D4S PWM3_out;
        CLC1SEL3 = 0x0E;
        // LC1G1D3N disabled; LC1G1D2N enabled; LC1G1D4N disabled; LC1G1D1T disabled; LC1G1D3T disabled; LC1G1D2T disabled; LC1G1D4T disabled; LC1G1D1N enabled;
        CLC1GLS0 = 0x05;
        // LC1G2D2N disabled; LC1G2D1N disabled; LC1G2D4N disabled; LC1G2D3N enabled; LC1G2D2T disabled; LC1G2D1T disabled; LC1G2D4T disabled; LC1G2D3T disabled;
        CLC1GLS1 = 0x10;
        // LC1G3D1N disabled; LC1G3D2N disabled; LC1G3D3N disabled; LC1G3D4N disabled; LC1G3D1T disabled; LC1G3D2T enabled; LC1G3D3T disabled; LC1G3D4T disabled;
        CLC1GLS2 = 0x08;
        // LC1G4D1N disabled; LC1G4D2N disabled; LC1G4D3N disabled; LC1G4D4N disabled; LC1G4D1T disabled; LC1G4D2T disabled; LC1G4D3T enabled; LC1G4D4T disabled;
        CLC1GLS3 = 0x20;
        // LC1EN enabled; INTN disabled; INTP disabled; MODE AND-OR;
        CLC1CON = 0x80;
}

void TMR2_Initialize(void){
        // Set TMR2 to the options selected in the User Interface
        // T2CS FOSC/4;
        T2CLKCON = 0x00;
        // T2PSYNC Not Synchronized; T2MODE Software control; T2CKPOL Rising Edge; T2CKSYNC Not Synchronized;
        T2HLT = 0x00;
        // T2RSEL T2IN;
        T2RST = 0x00;
        // T2PR 19;
        T2PR = 5;
        // TMR2 0;
        T2TMR = 0x00;
        // Clearing IF flag.
        TMR2IF_bit = 0;
        // T2CKPS 1:1; T2OUTPS 1:1; TMR2ON on;
        T2CON = 0x80;
}

void PWM3_Initialize(void){
        // PWM3POL active_hi; PWM3EN enabled;
        PWM3CON = 0x80;
        // DC 6;
        PWM3DCH = 0x03;
        // DC 1;
        PWM3DCL = 0x00;
 }