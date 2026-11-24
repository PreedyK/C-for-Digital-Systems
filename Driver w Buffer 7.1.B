#define BUFFER_SIZE 64
#define SERIAL_TXD (*(volatile unsigned int*)0x40000000)
#define SERIAL_READY (*(volatile unsigned int*)0x40000004)
#define SERIAL_INTENSET (*(volatile unsigned int*)0x40000010)

char buffer[BUFFER_SIZE];

volatile int head = 0;
volatile int tail = 0;
volatile int transmitting = 0;

void print(char* str) {
    while (*str != '\0') {
        int next = (head + 1) % BUFFER_SIZE;

        while (next == tail) {
            next = (head + 1) % BUFFER_SIZE;
        }

        buffer[head] = *str;
        head = next;

        str++;
    }

    SERIAL_INTENSET = 1;

    if (!transmitting && (SERIAL_READY & 1)) {
        transmitting = 1;

        SERIAL_TXD = buffer[tail];
        tail = (tail + 1) % BUFFER_SIZE;
    }
}

void serial_handler(void) {
    if (tail!= head) {

        SERIAL_TXD = buffer[tail];
        tail = (tail + 1) % BUFFER_SIZE;
        
    } else {
        transmitting = 0;
    }
}
