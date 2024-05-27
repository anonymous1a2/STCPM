//
// Created by Rusydi Makarim on 25/05/23.
//
#ifdef __unix
#define fopen_s(pFile, filename, mode) ((*(pFile)) = fopen((filename), (mode))) == NULL
#endif

#include <iomanip>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <vector>
#include <iostream>

// parameters for theta
#define Cipher_a0 6
#define Cipher_a1 10
#define Cipher_a2 27
#define Cipher_a3 41
#define Cipher_a4 50

#define Cipher_r 1
#define Cipher_s 36
#define Cipher_u 26

// rho-east rotation offsets
#define Cipher_e0 0
#define Cipher_e1 61
#define Cipher_e2 49
#define Cipher_e3 13
#define Cipher_e4 19



#define ASCON_0 19
#define ASCON_1 61
#define ASCON_2 1
#define ASCON_3 10
#define ASCON_4 7

#define ASCONB_0 28
#define ASCONB_1 39
#define ASCONB_2 6
#define ASCONB_3 17
#define ASCONB_4 41

#define GASTON_t0 25
#define GASTON_t1 32
#define GASTON_t2 52
#define GASTON_t3 60
#define GASTON_t4 63
#define GASTON_r 1
#define GASTON_s 18
#define GASTON_u 23

// rho-east rotation offsets
#define GASTON_e0 0
#define GASTON_e1 60
#define GASTON_e2 22
#define GASTON_e3 27
#define GASTON_e4 4

// rho-west rotation offsets
#define GASTON_w0 0
#define GASTON_w1 56
#define GASTON_w2 31
#define GASTON_w3 46
#define GASTON_w4 43

using namespace std;
#include <iostream>
#include <random>



int SBD(uint64_t x[]) {

	uint64_t i = 0;
	uint64_t m, n = 0;
	const uint64_t rc[] = {
		0x00000000000000F0, 0x00000000000000E1, 0x00000000000000D2,
		0x00000000000000C3, 0x00000000000000B4, 0x00000000000000A5,
		0x0000000000000096, 0x0000000000000087
	};
	uint64_t tmp;
	uint64_t P = 0, Q = 0;
	uint64_t sboxin[5] = { 0, 0, 0, 0, 0 };



	for (i = 0; i < 8; i++) {

		/*x[0] = ((x[0]) << Cipher_e0) | ((x[0]) >> (Cipher_e0));*/
		x[1] = ((x[1]) << Cipher_e1) | ((x[1]) >> (64 - Cipher_e1));
		x[2] = ((x[2]) << Cipher_e2) | ((x[2]) >> (64 - Cipher_e2));
		x[3] = ((x[3]) << Cipher_e3) | ((x[3]) >> (64 - Cipher_e3));
		x[4] = ((x[4]) << Cipher_e4) | ((x[4]) >> (64 - Cipher_e4));

		// theta
		P = x[0] ^ x[1] ^ x[2] ^ x[3] ^ x[4];


		P = P ^ (((P) << Cipher_r) | ((P) >> (64 - Cipher_r)));

		Q = (((x[0]) << Cipher_a0) | ((x[0]) >> (64 - Cipher_a0))) ^ (((x[1]) << Cipher_a1) | ((x[1]) >> (64 - Cipher_a1))) ^ (((x[2]) << Cipher_a2) | ((x[2]) >> (64 - Cipher_a2))) ^ (((x[3]) << Cipher_a3) | ((x[3]) >> (64 - Cipher_a3))) ^ (((x[4]) << Cipher_a4) | ((x[4]) >> (64 - Cipher_a4)));



		Q = Q ^ (((Q) << Cipher_s) | ((Q) >> (64 - Cipher_s)));





		//
		P = ((P) << Cipher_u) | ((P) >> (64 - Cipher_u));


		Q = ((Q) << Cipher_u) | ((Q) >> (64 - Cipher_u));
		x[0] = x[0] ^ P ^ (((Q) << Cipher_a0) | ((Q) >> (64 - Cipher_a0)));
		x[1] = x[1] ^ P ^ (((Q) << Cipher_a1) | ((Q) >> (64 - Cipher_a1)));
		x[2] = x[2] ^ P ^ (((Q) << Cipher_a2) | ((Q) >> (64 - Cipher_a2)));
		x[3] = x[3] ^ P ^ (((Q) << Cipher_a3) | ((Q) >> (64 - Cipher_a3)));
		x[4] = x[4] ^ P ^ (((Q) << Cipher_a4) | ((Q) >> (64 - Cipher_a4)));
		// rho-west
		sboxin[0] = x[0];
		sboxin[1] = ((x[1]) << Cipher_e1) | ((x[1]) >> (64 - Cipher_e1));
		sboxin[2] = ((x[2]) << Cipher_e2) | ((x[2]) >> (64 - Cipher_e2));
		sboxin[3] = ((x[3]) << Cipher_e3) | ((x[3]) >> (64 - Cipher_e3));
		sboxin[4] = ((x[4]) << Cipher_e4) | ((x[4]) >> (64 - Cipher_e4));


		sboxin[0] = sboxin[0] ^ rc[i];

		// degree4 sbox

		x[0] = ~((~(sboxin[0] & (~sboxin[2]) & (sboxin[4]))) & (~(sboxin[0] & sboxin[1])) & (~(sboxin[2] & sboxin[3])));
		x[1] = ~((~(sboxin[4] & (~sboxin[0]))) & (~(sboxin[1] & (~sboxin[2]))) & (~(sboxin[4] & (~sboxin[1]) & sboxin[3])));
		x[2] = ~((~(sboxin[3] & (~sboxin[4]))) & (~((~sboxin[1]) & (~sboxin[0]))) & (~(sboxin[3] & (~sboxin[2]) & sboxin[0])));
		x[3] = ~((~((~sboxin[2]) & (~sboxin[3]))) & (~((~sboxin[4]) & sboxin[0])) & (~(sboxin[4] & (~sboxin[2]) & (~sboxin[1]))));
		x[4] = ~((~(sboxin[2] & (~sboxin[1]))) & (~(sboxin[4] & (~sboxin[3]))) & (~(sboxin[3] & (~sboxin[1]) & sboxin[0])));
	}


	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[0]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[1]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[2]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[3]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[4]
		 << endl;

	return 0;
}


int Gaston_S(uint64_t x[]) {

	uint64_t i = 0;
	uint64_t m, n = 0;
	const uint64_t rc[] = {
		0x00000000000000F0, 0x00000000000000E1, 0x00000000000000D2,
		0x00000000000000C3, 0x00000000000000B4, 0x00000000000000A5,
		0x0000000000000096, 0x0000000000000087, 0x0000000000000078,
		0x0000000000000069, 0x000000000000005A, 0x000000000000004B
	};
	uint64_t tmp;
	uint64_t P = 0, Q = 0;



	for (i = 0; i < 12; i++) {


		/*x[0] = ((x[0]) << Cipher_e0) | ((x[0]) >> (Cipher_e0));*/
		x[1] = ((x[1]) << Cipher_e1) | ((x[1]) >> (64 - Cipher_e1));
		x[2] = ((x[2]) << Cipher_e2) | ((x[2]) >> (64 - Cipher_e2));
		x[3] = ((x[3]) << Cipher_e3) | ((x[3]) >> (64 - Cipher_e3));
		x[4] = ((x[4]) << Cipher_e4) | ((x[4]) >> (64 - Cipher_e4));

		// theta
		P = x[0] ^ x[1] ^ x[2] ^ x[3] ^ x[4];

		P = P ^ (((P) << Cipher_r) | ((P) >> (64 - Cipher_r)));

		Q = (((x[0]) << Cipher_a0) | ((x[0]) >> (64 - Cipher_a0))) ^ (((x[1]) << Cipher_a1) | ((x[1]) >> (64 - Cipher_a1))) ^ (((x[2]) << Cipher_a2) | ((x[2]) >> (64 - Cipher_a2))) ^ (((x[3]) << Cipher_a3) | ((x[3]) >> (64 - Cipher_a3))) ^ (((x[4]) << Cipher_a4) | ((x[4]) >> (64 - Cipher_a4)));

		Q = Q ^ (((Q) << Cipher_s) | ((Q) >> (64 - Cipher_s)));


		//
		P = ((P) << Cipher_u) | ((P) >> (64 - Cipher_u));
		Q = ((Q) << Cipher_u) | ((Q) >> (64 - Cipher_u));
		x[0] = x[0] ^ P ^ (((Q) << Cipher_a0) | ((Q) >> (64 - Cipher_a0)));
		x[1] = x[1] ^ P ^ (((Q) << Cipher_a1) | ((Q) >> (64 - Cipher_a1)));
		x[2] = x[2] ^ P ^ (((Q) << Cipher_a2) | ((Q) >> (64 - Cipher_a2)));
		x[3] = x[3] ^ P ^ (((Q) << Cipher_a3) | ((Q) >> (64 - Cipher_a3)));
		x[4] = x[4] ^ P ^ (((Q) << Cipher_a4) | ((Q) >> (64 - Cipher_a4)));


		// rho-west
		x[1] = ((x[1]) << Cipher_e1) | ((x[1]) >> (64 - Cipher_e1));
		x[2] = ((x[2]) << Cipher_e2) | ((x[2]) >> (64 - Cipher_e2));
		x[3] = ((x[3]) << Cipher_e3) | ((x[3]) >> (64 - Cipher_e3));
		x[4] = ((x[4]) << Cipher_e4) | ((x[4]) >> (64 - Cipher_e4));

		x[0] = x[0] ^ rc[i];

		// degree4 sbox
		P = x[0];
		Q = x[1];
		x[0] ^= (x[2] & ~x[1]);
		x[1] ^= (x[3] & ~x[2]);
		x[2] ^= (x[4] & ~x[3]);
		x[3] ^= (P & ~x[4]);
		x[4] ^= (Q & ~P);
	}
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[0]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[1]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[2]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[3]
		 << endl;
	cout << "0x"
		 << uppercase << hex << setw(16) << setfill('0') << x[4]
		 << endl;

	return 0;
}



int main() {
	/*uint64_t x[5] = { 0xFFFFFFFFFFFFFFFF, 0x0123456789ABCDEF, 0xFEDCBA9876543210, 0xAAAAAAAAAAAAAAAA, 0x0101010101010101 };*/
	uint64_t x[5] = { 0x0, 0x0, 0x0, 0x0, 0x0 };

	Gaston_S(x);
	
	//SBD(x);
	
	return 0;
}
