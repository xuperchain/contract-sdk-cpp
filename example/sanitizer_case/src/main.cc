#include "xchain/xchain.h"

struct SanitizerCase : public xchain::Contract {};

DEFINE_METHOD(SanitizerCase, initialize) {
    xchain::Context* ctx = self.context();
    ctx->ok("initialize succeed");

}

//  null_dereference is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, null_dereference) {
    xchain::Context* ctx = self.context();
    int *a = 0, b;
    b = *a;
    ctx->ok("ok");
}

//  double_delete is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, double_delete) {
    xchain::Context* ctx = self.context();
     auto a  = new std::string();
	delete(a);
	delete(a);
    ctx->ok("ok");
}

//  buffer_overflow is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, buffer_overflow) {
    xchain::Context* ctx = self.context();
    int a[10];
    int b = 10;
    int c = a[b];
    ctx->ok("ok");
}

//  int_overflow is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, int_overflow) {
    xchain::Context* ctx = self.context();
    int a = 2147483647;
    int b = a + 1;
    ctx->ok("ok");
}

//  divide_by_zero is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, divide_by_zero) {
    xchain::Context* ctx = self.context();
    int a = 2147483647;
    int b = 0;
    int c = a / b;
    ctx->ok("ok");
}

//  float_cast_overflow is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, float_cast_overflow) {
    xchain::Context* ctx = self.context();
    double a = 2147483699.1;
    int b = int(a);
    ctx->ok("ok");
}