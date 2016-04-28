#include <avr/io.h>
#include <util/delay.h>


void setup(){
	// Setup GPIO
	DDRB |= (1 << PB0);

}

void main(){
	setup();

	while(1){
		PORTB ^= (1 << PB0);
		_delay_ms(1000);
	}
}