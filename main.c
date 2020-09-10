#include <stdio.h>
#include <stdint.h>
#include <limits.h>
#include <math.h>
#include <time.h>

// get different parts of floating point number
const uint32_t MANTISSA_MASK  = 0x007fffff;
const uint32_t EXPONENT_MASK  = 0x7f800000;
const uint32_t SIGN_MASK      = 0x80000000;

// mantissa assumes 1 bit in 24th pos- need to set to multiply
const uint32_t HIDDEN_BIT                 = 1 << 23;

// check to see if mantissa overflows for normalization
const uint64_t MANT_PROD_HIDDEN_BIT_MASK  = 1L << 47;

// to round the mantissa if bit below first bit is set when truncating
const uint64_t MANTISSA_ROUND_BIT         = 1 << 22;
const uint64_t MANTISSA_LOW_BIT           = 1 << 23;

// how many times we do recursion
const int BINMUL_ITERS = 64;

float fmul(float, float);
int mul(int, int);

uint64_t binmul_recursive(uint64_t, uint64_t, uint64_t, uint64_t);

typedef union _float_as_int {
  float f;
  uint32_t u;
} f2u;

int main(void) {
  printf("the answer to life is... %d!\n", mul(6, 7));

  printf("try it yourself! input 2 floats: ");
  float f, g;
  scanf("%f %f", &f, &g);
  printf("thinking...\n");
  clock_t start = clock();
  float res = fmul(f, g);
  clock_t end = clock();
  printf("your value is %f (in %lf sec)", res, ((double) end - start) / CLOCKS_PER_SEC);

  return 0;
}

float fmul(float lhs, float rhs) {

  // check for NANs
  if (isnan(lhs) || isnan(rhs)) {
    return NAN;
  }

  f2u lhsu;
  f2u rhsu;
  lhsu.f = lhs;
  rhsu.f = rhs;

  // get the sign bit of the result
  uint32_t sign = (lhsu.u ^ rhsu.u) & SIGN_MASK;

  // zero check after sign to get -0.0f
  if (lhs == 0.0f || rhs == 0.0f) {
    if (fabsf(lhs) == INFINITY || fabsf(rhs) == INFINITY) {
      return NAN;
    }
    return sign == 0 ? 0.0f : -0.0f;
  }

  // get the exponent part 
  uint8_t lhs_exp = (uint8_t) ((lhsu.u & EXPONENT_MASK) >> 23);
  uint8_t rhs_exp = (uint8_t) ((rhsu.u & EXPONENT_MASK) >> 23);
  
  // don't shift yet, we might still need to add bc of mantissa
  uint32_t res_exp = (uint32_t) (lhs_exp + rhs_exp - 127);

  // if our exponent overflows, we're at infinity
  if (res_exp > 255) {
    return sign == 0 ? INFINITY : -INFINITY;
  }

  // get mantissa part
  // need to check for subnormals- if it's normal (exponent != 0) we OR the leading 1 bit
  uint64_t lhs_mant = (uint64_t) ((lhsu.u & MANTISSA_MASK) | (lhs_exp != 0 ? HIDDEN_BIT : 0));
  uint64_t rhs_mant = (uint64_t) ((rhsu.u & MANTISSA_MASK) | (rhs_exp != 0 ? HIDDEN_BIT : 0));

  // binary multiplication on the mantissa
  uint64_t res_mant = binmul_recursive(lhs_mant, rhs_mant, 0, 0);
  
  // we also need to handle the case where the mantissa overflows, turn off that bit
  // and add that to the exponent
  if ((res_mant & MANT_PROD_HIDDEN_BIT_MASK) != 0) {
    res_mant &= ~MANT_PROD_HIDDEN_BIT_MASK;
    res_mant >>= 1;
    res_exp += 1;
  }

  // now, we can shift the exponent into position
  res_exp <<= 23;
  
  // ROUND the mantissa
  if ((res_mant & MANTISSA_ROUND_BIT) > 0) {
    res_mant |= MANTISSA_LOW_BIT;
  }
  uint32_t trunc_mant = (uint32_t) (res_mant >> 23);

  // turn off the hidden bit
  trunc_mant &= ~(1 << 23);

  // now we can put our number back together- no overlapping
  f2u res;
  res.u = sign | res_exp | trunc_mant;
  
  return res.f;
}

// int version
int mul(int lhs, int rhs) {
  return (int) fmul(lhs, rhs);
}

// tail call recursion so no loops
uint64_t binmul_recursive(uint64_t lhs, uint64_t rhs, uint64_t sum, uint64_t depth) {
  if ((lhs >> depth) & 1) {
    sum += (rhs << depth);
  }

  depth++;
  if (depth >= BINMUL_ITERS) {
    return sum;
  }
  else {
    return binmul_recursive(lhs, rhs, sum, depth);
  }
}
