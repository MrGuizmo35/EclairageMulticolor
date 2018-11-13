#line 1 "C:/Users/mrgui/Documents/projets/EclairageMulticolor/firmware/LEDStrip.c"
#line 1 "c:/users/mrgui/documents/projets/eclairagemulticolor/firmware/ledstrip.h"
#line 1 "c:/users/mrgui/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 1 "c:/users/mrgui/documents/mikroelektronika/mikroc pro for pic/include/stdbool.h"



 typedef char _Bool;
#line 9 "c:/users/mrgui/documents/projets/eclairagemulticolor/firmware/ledstrip.h"
typedef enum{
 RX_STATE_START_1,
 RX_STATE_START_2,
 RX_STATE_LENGTH,
 RX_STATE_CMD,
 RX_STATE_DATA,
 RX_STATE_CHECKSUM,
 RX_STATE_STOP_1,
 RX_STATE_STOP_2
}RX_STATE_t;

void RxTask(void);
void PIN_Initialize(void);
void CLC1_Initialize(void);
void OSCILLATOR_Initialize(void);
void SPI_Initialize(void);
void TMR2_Initialize(void);
void PWM3_Initialize(void);
#line 3 "C:/Users/mrgui/Documents/projets/EclairageMulticolor/firmware/LEDStrip.c"
 _Bool  setLedsColorNow =  0 ;
uint8_t leds_color[180];

void interrupt(void){
 if(PEIE_bit == 1){
 if(RCIE_bit == 1 && RCIF_bit == 1){
 RxTask();
 }
 else{

 }
 }
}

void main(void) {
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

 while(1){
 if(setLedsColorNow ==  1 ){
 uint8_t pixelIndex = 0;
 setLedsColorNow =  0 ;
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
 switch (state){
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
 if(dataIndex >= dataLength){
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
 case  10 :{
 memcpy(messageBuffer,leds_color,180);
 setLedsColorNow =  1 ;
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
 RXPPS = 0x0D;
 RB7PPS = 0x06;
 RA2PPS = 0x04;
}

void OSCILLATOR_Initialize(void){

 OSCCON = 0x78;

 OSCTUNE = 0x00;

 BORCON = 0x00;

 while(PLLR == 0){
 }
}

void SPI_Initialize(void){


 SSP1STAT = 0x00;

 SSP1CON1 = 0x20;

 SSP1ADD = 0x00;
}

void CLC1_Initialize(void){

 CLC1POL = 0x01;

 CLC1SEL0 = 0x0E;

 CLC1SEL1 = 0x27;

 CLC1SEL2 = 0x28;

 CLC1SEL3 = 0x0E;

 CLC1GLS0 = 0x05;

 CLC1GLS1 = 0x10;

 CLC1GLS2 = 0x08;

 CLC1GLS3 = 0x20;

 CLC1CON = 0x80;
}

void TMR2_Initialize(void){


 T2CLKCON = 0x00;

 T2HLT = 0x00;

 T2RST = 0x00;

 T2PR = 0x13;

 T2TMR = 0x00;

 TMR2IF_bit = 0;

 T2CON = 0x80;
}

void PWM3_Initialize(void){

 PWM3CON = 0x80;

 PWM3DCH = 0x06;

 PWM3DCL = 0x40;
 }
