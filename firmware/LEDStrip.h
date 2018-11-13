#ifndef __LEDSTRIP_H__
#define __LEDSTRIP_H__

#include <stdint.h>
#include <stdbool.h>

#define CMD_SET_LEDS 10

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

#endif