#define UART_EV_TX  0x1
#define UART_BASE 0xe0001800
#define CSR_UART_RXTX_ADDR       (UART_BASE + 0x00)
#define CSR_UART_TXFULL_ADDR     (UART_BASE + 0x04)
#define CSR_UART_EV_PENDING_ADDR (UART_BASE + 0x10)
#define CSR_UART_EV_ENABLE_ADDR  (UART_BASE + 0x14)

void putc(unsigned char c);
void puts(char *str);

void putc(unsigned char c) {
    unsigned char r;
    /* pending */
    r = *(volatile unsigned int*)CSR_UART_EV_PENDING_ADDR;
    *(volatile unsigned int*)CSR_UART_EV_PENDING_ADDR = r;

    /* enable */
    *(volatile unsigned int*)CSR_UART_EV_ENABLE_ADDR = UART_EV_TX;

    /* wait for space */
    do {
        r = *(volatile unsigned int*)CSR_UART_TXFULL_ADDR;
    } while (r);
    /* write */
    *(volatile unsigned int*)CSR_UART_RXTX_ADDR = c;
}

void puts(char *str) {
    while (*str != '\0') putc(*(str++));
}

int main(void) {
    puts("Hello World!\n");
    for (int i = 0; i < 30; i++) {
        puts("hello World again!\n");
    }
    puts("The end.\n");
    return 0;
}

