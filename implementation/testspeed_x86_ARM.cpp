 Created by Rusydi Makarim on 25/05/23.
//

#ifdef __unix
#define fopen_s(pFile, filename, mode) ((*(pFile)) = fopen((filename), (mode))) == NULL
#endif


#include <time.h>
#define _GNU_SOURCE
#include <stdlib.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>
#include <linux/perf_event.h>



#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <vector>



// parameters for SBD and Gaston-SYM
#define Para_a0 6
#define Para_a1 10
#define Para_a2 27
#define Para_a3 41
#define Para_a4 50
#define Para_r 1
#define Para_s 36
#define Para_u 26

#define Para_e0 0
#define Para_e1 61
#define Para_e2 49
#define Para_e3 13
#define Para_e4 19

#define Para_ua0 32
#define Para_ua1 36
#define Para_ua2 53
#define Para_ua3 3
#define Para_ua4 12






// parameters for ASCON
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

// parameters for GASTON
#define GASTON_t0 25
#define GASTON_t1 32
#define GASTON_t2 52
#define GASTON_t3 60
#define GASTON_t4 63
#define GASTON_r 1
#define GASTON_s 18
#define GASTON_u 23


#define GASTON_e0 0
#define GASTON_e1 60
#define GASTON_e2 22
#define GASTON_e3 27
#define GASTON_e4 4


#define GASTON_w0 0
#define GASTON_w1 56
#define GASTON_w2 31
#define GASTON_w3 46
#define GASTON_w4 43



using namespace std;
#include <iostream>

#include <iostream>
#include <random>
#include <vector>

static  int fddev = -1;
__attribute__((constructor)) static inline void
init(void)
{
	static struct perf_event_attr attr;
	attr.type = PERF_TYPE_HARDWARE;
	attr.config = PERF_COUNT_HW_CPU_CYCLES;
	fddev = syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0);
}

__attribute__((destructor)) static void
fini(void)
{
	close(fddev);
}

static inline long long
cpucycles(void)
{
	long long result = 0;
	if (read(fddev, &result, sizeof(result)) < sizeof(result)) return 0;
	return result;
}


void Init_timer(unsigned long long *ll, unsigned long long *begintime)
{
    unsigned int lo, hi;
  	*begintime=clock(); 
  	*ll=cpucycles(); 
}
vector<uint64_t> creat_random() {
	random_device rd;
	linear_congruential_engine<std::uint_fast64_t, 48271, 0, 2147483647> lce(rd());
	uniform_int_distribution<uint64_t> dis(0, UINT64_MAX);
	vector<uint64_t> random_numbers;
	for (int i = 0; i < 5; i++) {
		uint64_t random_number = dis(lce);
		random_numbers.push_back(random_number);
		// cout << "Random 64-bit number " << i + 1 << ": " << random_number << std::endl;
	}

	return random_numbers;
}



int Gaston_S(int loop1, int loop2, vector<uint64_t> radom) {

	uint64_t i = 0;
	uint64_t m, n = 0;
	const uint64_t rc[] = {
		0x00000000000000F0, 0x00000000000000E1, 0x00000000000000D2,
		0x00000000000000C3, 0x00000000000000B4, 0x00000000000000A5,
		0x0000000000000096, 0x0000000000000087, 0x0000000000000078,
		0x0000000000000069, 0x000000000000005A, 0x000000000000004B
	};
	
	uint64_t tmp0,tmp1,tmp2,tmp3,tmp4;
	uint64_t P = 0, Q = 0;
	uint64_t x[5] = { 0, 0, 0, 0, 0 };
	for (i = 0; i < 5; i++) {
		x[i] = radom[i];
	}


	// 100000000000
	for (m = 0; m < loop1; m++) {
		for (n = 0; n < loop2; n++) {
			
			

		
			for (i = 0; i < 12; i++) {
				x[0] = ((x[0]) << Para_e0) | ((x[0]) >> (64-Para_e0));
				x[1] = ((x[1]) << Para_e1) | ((x[1]) >> (64-Para_e1));
				x[2] = ((x[2]) << Para_e2) | ((x[2]) >> (64-Para_e2));
				x[3] = ((x[3]) << Para_e3) | ((x[3]) >> (64-Para_e3));
				x[4] = ((x[4]) << Para_e4) | ((x[4]) >> (64-Para_e4));

				// theta
				P = x[0] ^ x[1] ^ x[2] ^ x[3] ^ x[4];
				
				P = P ^ (((P) << Para_r) | ((P) >> (64-Para_r)));
				

				Q = (((x[0]) << Para_a0) | ((x[0]) >> (64-Para_a0))) ^ (((x[1]) << Para_a1) | ((x[1]) >> (64-Para_a1))) ^ (((x[2]) << Para_a2) | ((x[2]) >> (64-Para_a2))) ^ (((x[3]) << Para_a3) | ((x[3]) >> (64-Para_a3))) ^ (((x[4]) << Para_a4) | ((x[4]) >> (64-Para_a4)));

				Q ^= ((Q) << Para_s) | ((Q) >> (64-Para_s));
				P= ((P) << Para_u) | ((P) >> (64-Para_u));
				
				x[0] ^= P ^ (((Q) << Para_ua0) | ((Q) >> (64-Para_ua0)));
				x[1] ^= P ^ (((Q) << Para_ua1) | ((Q) >> (64-Para_ua1)));
				x[2] ^= P ^ (((Q) << Para_ua2) | ((Q) >> (64-Para_ua2)));
				x[3] ^= P ^ (((Q) << Para_ua3) | ((Q) >> (64-Para_ua3)));
				x[4] ^= P ^ (((Q) << Para_ua4) | ((Q) >> (64-Para_ua4)));

				// rho-west
				
				x[0] = ((x[0]) << Para_e0) | ((x[0]) >> (64-Para_e0));
				x[1] = ((x[1]) << Para_e1) | ((x[1]) >> (64-Para_e1));
				x[2] = ((x[2]) << Para_e2) | ((x[2]) >> (64-Para_e2));
				x[3] = ((x[3]) << Para_e3) | ((x[3]) >> (64-Para_e3));
				x[4] = ((x[4]) << Para_e4) | ((x[4]) >> (64-Para_e4));
				
				x[0] = x[0] ^ rc[i];
				
				P = x[0];
				Q = x[1];
				x[0] ^= (x[2] & ~x[1]);
				x[1] ^= (x[3] & ~x[2]);
				x[2] ^= (x[4] & ~x[3]);
				x[3] ^= (P & ~x[4]);
				x[4] ^= (Q & ~P);



			}
		}
	}
	printf("\n %lu, %lu, %lu, %lu, %lu \n", x[0], x[1], x[2], x[3], x[4]);

	return 0;
}


int Gaston(int loop1, int loop2, vector<uint64_t> radom) {

	uint64_t i = 0;
	uint64_t m, n = 0;
	const uint64_t rc[] = {
		0x00000000000000F0, 0x00000000000000E1, 0x00000000000000D2,
		0x00000000000000C3, 0x00000000000000B4, 0x00000000000000A5,
		0x0000000000000096, 0x0000000000000087, 0x0000000000000078,
		0x0000000000000069, 0x000000000000005A, 0x000000000000004B
	};
	
	uint64_t P = 0, Q = 0;
	uint64_t x[5] = { 0, 0, 0, 0, 0 };
	for (i = 0; i < 5; i++) {
		x[i] = radom[i];
	}
	for (m = 0; m <loop1; m++) {
		for (n = 0; n < loop2; n++) {
			

			for (i = 0; i <12; i++) {
		
		
				// rho-east
				x[0] = ((x[0]) << GASTON_e0) | ((x[0]) >> (64-GASTON_e0));
				x[1] = ((x[1]) << GASTON_e1) | ((x[1]) >> (64-GASTON_e1));
				x[2] = ((x[2]) << GASTON_e2) | ((x[2]) >> (64 - GASTON_e2));
				x[3] = ((x[3]) << GASTON_e3) | ((x[3]) >> (64 - GASTON_e3));
				x[4] = ((x[4]) << GASTON_e4) | ((x[4]) >> (64 - GASTON_e4));
		
		
		
		
				// theta
				P = x[0] ^ x[1] ^ x[2] ^ x[3] ^ x[4];
		
		
				P ^= ((P) << GASTON_r) | ((P) >> (64 - GASTON_r));
		
				Q = (((x[0]) << GASTON_t0) | ((x[0]) >> (64 - GASTON_t0))) ^ (((x[1]) << GASTON_t1) | ((x[1]) >> (64 - GASTON_t1))) ^ (((x[2]) << GASTON_t2) | ((x[2]) >> (64 - GASTON_t2))) ^ (((x[3]) << GASTON_t3) | ((x[3]) >> (64 - GASTON_t3))) ^ (((x[4]) << GASTON_t4) | ((x[4]) >> (64 - GASTON_t4)));
		
		
				Q ^= ((Q) << GASTON_s) | ((Q) >> (64 - GASTON_s));

				Q = ((Q) << GASTON_u) | ((Q) >> (64 - GASTON_u));
				P = ((P) << GASTON_u) | ((P) >> (64 - GASTON_u));
				
				P ^= Q;
		
				x[0] ^= P;
				x[1] ^= P;
				x[2] ^= P;
				x[3] ^= P;
				x[4] ^= P;
		
				// rho-west
				x[0] = ((x[0]) << GASTON_w0) | ((x[0]) >> (64 - GASTON_w0));
				x[1] = ((x[1]) << GASTON_w1) | ((x[1]) >> (64 - GASTON_w1));
				x[2] = ((x[2]) << GASTON_w2) | ((x[2]) >> (64 - GASTON_w2));
				x[3] = ((x[3]) << GASTON_w3) | ((x[3]) >> (64 - GASTON_w3));
				x[4] = ((x[4]) << GASTON_w4) | ((x[4]) >> (64 - GASTON_w4));
		
				x[0] ^= rc[i];
		
				// chi
				P = x[0];
				Q = x[1];
				x[0] ^= (x[2] & ~x[1]);
				x[1] ^= (x[3] & ~x[2]);
				x[2] ^= (x[4] & ~x[3]);
				x[3] ^= (P & ~x[4]);
				x[4] ^= (Q & ~P);
				
			}
		}
	}
	
	printf("\n %lu, %lu, %lu, %lu, %lu \n", x[0], x[1], x[2], x[3], x[4]);
	return 0;
}





int SBD(int loop1, int loop2, vector<uint64_t> radom) {


	uint64_t i = 0;
	uint64_t m, n = 0;
	const uint64_t rc[] = {
		0x00000000000000F0, 0x00000000000000E1, 0x00000000000000D2,
		0x00000000000000C3, 0x00000000000000B4, 0x00000000000000A5,
		0x0000000000000096, 0x0000000000000087
	};
	
	uint64_t P = 0, Q = 0;
	uint64_t x[5] = { 0, 0, 0, 0, 0 };
	uint64_t tmp0,tmp1,tmp2,tmp3,tmp4; 
	for (i = 0; i < 5; i++) {
		x[i] = radom[i];
	}


	// 100000000000
	for (m = 0; m < loop1; m++) {
		for (n = 0; n < loop2; n++) {

			for (i =0; i < 8; i++) {
				
				x[0] = ((x[0]) << Para_e0) | ((x[0]) >> (64-Para_e0));
				x[1] = ((x[1]) << Para_e1) | ((x[1]) >> (64-Para_e1));
				x[2] = ((x[2]) << Para_e2) | ((x[2]) >> (64-Para_e2));
				x[3] = ((x[3]) << Para_e3) | ((x[3]) >> (64-Para_e3));
				x[4] = ((x[4]) << Para_e4) | ((x[4]) >> (64-Para_e4));

				// theta
				P = x[0] ^ x[1] ^ x[2] ^ x[3] ^ x[4];
				
				P = P ^ (((P) << Para_r) | ((P) >> (64-Para_r)));
				
				Q = (((x[0]) << Para_a0) | ((x[0]) >> (64-Para_a0))) ^ (((x[1]) << Para_a1) | ((x[1]) >> (64-Para_a1))) ^ (((x[2]) << Para_a2) | ((x[2]) >> (64-Para_a2))) ^ (((x[3]) << Para_a3) | ((x[3]) >> (64-Para_a3))) ^ (((x[4]) << Para_a4) | ((x[4]) >> (64-Para_a4)));

				Q ^= ((Q) << Para_s) | ((Q) >> (64-Para_s));
				P= ((P) << Para_u) | ((P) >> (64-Para_u));
				
				x[0] ^= P ^ (((Q) << Para_ua0) | ((Q) >> (64-Para_ua0)));
				x[1] ^= P ^ (((Q) << Para_ua1) | ((Q) >> (64-Para_ua1)));
				x[2] ^= P ^ (((Q) << Para_ua2) | ((Q) >> (64-Para_ua2)));
				x[3] ^= P ^ (((Q) << Para_ua3) | ((Q) >> (64-Para_ua3)));
				x[4] ^= P ^ (((Q) << Para_ua4) | ((Q) >> (64-Para_ua4)));


				// rho-west
				x[0] = x[0] ^ rc[i];
				x[0] = ((x[0]) << Para_e0) | ((x[0]) >> (64-Para_e0));
				x[1] = ((x[1]) << Para_e1) | ((x[1]) >> (64-Para_e1));
				x[2] = ((x[2]) << Para_e2) | ((x[2]) >> (64-Para_e2));
				x[3] = ((x[3]) << Para_e3) | ((x[3]) >> (64-Para_e3));
				x[4] = ((x[4]) << Para_e4) | ((x[4]) >> (64-Para_e4));
				

				tmp0 = ~(x[0] & (~x[2]) & (x[4]));
				tmp1 = (~(x[4] & (~x[1]) & x[3]));
				tmp2 = (~(x[3] & (~x[2]) & x[0]));
				tmp3 = (~(x[4] & (~x[2]) & (~x[1])));
				tmp4 = (~(x[3] & (~x[1]) & x[0]));
				
				tmp0 = tmp0 & (~(x[0] & x[1]));
				tmp1 = tmp1 & (~(x[4] & (~x[0])));
				tmp2 = tmp2 & (~(x[3] & (~x[4])));
				tmp3 = tmp3 & (~((~x[2]) & (~x[3])));
				tmp4 = tmp4 & (~(x[2] & (~x[1])));
				
				tmp0 = tmp0 & (~(x[2] & x[3]));
				tmp1 = tmp1 & (~(x[1] & (~x[2])));
				tmp2 = tmp2 & (~((~x[1]) & (~x[0])));
				tmp3 = tmp3 & (~(~(x[4]) & (x[0])));
				tmp4 = tmp4 & (~(x[4] & (~x[3])));
				
				x[0] = ~tmp0;
				x[1] = ~tmp1;
				x[2] = ~tmp2;
				x[3] = ~tmp3;
				x[4] = ~tmp4;


			}
		}
	}
	printf("\n %lu, %lu, %lu, %lu, %lu \n", x[0], x[1], x[2], x[3], x[4]);

	return 0;
}


int main() {

	FILE* pFile;
	int nRt = fopen_s(&pFile, "clock.txt", "a");
	int pownum1 = 5;
	int pownum2 = 5;
	int m;
	
	uint64_t loop1 = pow(10, pownum1);
	uint64_t loop2 = pow(10, pownum2);
	

	fprintf(pFile, "10^{%d} * 12\n", pownum1 + pownum2);
	


	unsigned long long t1, t2;
    unsigned long long cp0,cp1;
	unsigned long long c1; 	

	vector<uint64_t> radom_n ={0,0,0,0,0};
	
	
	for (m = 0; m < 1; m++) {
	

		Init_timer(&cp0, &t1);
		Gaston(loop1, loop2, radom_n);
		Init_timer(&cp1, &t2);
		c1 = cp1-cp0;
		printf("Gaston: all_CLOCK %lld, clock/per round: %f\n", c1, (float)c1 / (float)loop1/(float)loop2/12);
		fprintf(pFile,"Gaston: all_CLOCK %lld, clock/per round: %f\n", c1, (float)c1 / (float)loop1/(float)loop2/12);
		
		
		Init_timer(&cp0, &t1);
		Gaston_SYM(loop1, loop2, radom_n);
		Init_timer(&cp1, &t2);
		c1 = cp1-cp0;
		printf("Gaston-S: all_CLOCK %lld, clock/per round: %f\n", c1, (float)c1 / (float)loop1/(float)loop2/12);
		fprintf(pFile,"Gaston-S: all_CLOCK %lld, clock/per round: %f\n", c1, (float)c1 / (float)loop1/(float)loop2/12);
		
		
		Init_timer(&cp0, &t1);
		SBD(loop1, loop2, radom_n);
		Init_timer(&cp1, &t2);
		c1 = cp1-cp0;
		printf("SBD: all_CLOCK %lld, clock/per round: %f\n", c1, (float)c1 / (float)loop1/(float)loop2/8);
		fprintf(pFile,"SBD: all_CLOCK %lld, clock/per round: %f\n", c1, (float)c1 / (float)loop1/(float)loop2/8);
	}
		
	fclose(pFile);
	return 0;
}
