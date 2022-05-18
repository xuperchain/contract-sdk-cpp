#include "xchain/xchain.h"

struct SanitizerCase : public xchain::Contract {};

DEFINE_METHOD(SanitizerCase, initialize) {
    xchain::Context* ctx = self.context();
    ctx->ok("initialize succeed");

}
//  undefined_behavior is a counterexample of cpp programing practice
//  which may cause things out of exception
//  do not use it in your code
DEFINE_METHOD(SanitizerCase, undefined_behavior) {
    xchain::Context* ctx = self.context();
    int *a = 0, b;
    b = *a;
    ctx->ok("ok");
}
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
