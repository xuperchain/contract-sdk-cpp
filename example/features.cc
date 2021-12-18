#include "xchain/json/json.h"
#include "xchain/xchain.h"

struct Features : xchain::Contract {};

DEFINE_METHOD(Features, initialize) {
    xchain::Context* ctx = self.context();
    ctx->ok("init");
}

DEFINE_METHOD(Features, logging) {
    xchain::Context* ctx = self.context();
    ctx->logf("log from contract");
    ctx->ok("ok");
}

DEFINE_METHOD(Features, put) {
    xchain::Context* ctx = self.context();
    const std::string& key = ctx->arg("key");
    if (key.empty()) {
        ctx->error("missing key");
        return;
    }
    const std::string& value = ctx->arg("value");
    if (value.empty()) {
        ctx->error("missing value");
        return;
    }
    ctx->put_object(key, value);
    ctx->ok(value);
}

DEFINE_METHOD(Features, get) {
    xchain::Context* ctx = self.context();
    const std::string& key = ctx->arg("key");
    std::string value;
    if (ctx->get_object(key, &value)) {
        ctx->ok(value);
        return;
    }
    ctx->error("failed");
}

DEFINE_METHOD(Features, iterator) {
    xchain::Context* ctx = self.context();
    const std::string& start = ctx->arg("start");
    if (start.empty()) {
        ctx->error("missing start");
        return;
    }
    const std::string& limit = ctx->arg("limit");
    if (limit.empty()) {
        ctx->error("missing limit");
        return;
    }
    std::string ret;
    auto iter = ctx->new_iterator(start, limit);
    xchain::ElemType elem;
    while (iter->next()) {
        iter->get(&elem);
        ret += elem.first + ":" + elem.second + ", ";
    }
    ctx->ok(ret);
}

DEFINE_METHOD(Features, caller) {
    xchain::Context* ctx = self.context();
    ctx->ok(ctx->sender().get_name());
}

DEFINE_METHOD(Features, call) {
    xchain::Context* ctx = self.context();
    xchain::Response resp;
    const std::string contract = ctx->arg("contract");
    const std::string method = ctx->arg("method");
    bool ret = ctx->call("wasm", contract, method, ctx->args(), &resp);
    if (!ret) {
        ctx->error("call failed");
        return;
    }
    *ctx->mutable_response() = resp;
}

DEFINE_METHOD(Features, json_load_dump) {
    xchain::Context* ctx = self.context();
    const std::string v = ctx->arg("value");
    auto j = xchain::json::parse(v);
    ctx->ok(j.dump());
}

DEFINE_METHOD(Features, json_literal) {
    xchain::Context* ctx = self.context();
    xchain::json j = {
        {"int", 3},
        {"float", 3.14},
        {"string", "hello"},
        {"array", {"hello", "world"}},
        {"object", {{"key", "value"}}},
        {"true", true},
        {"false", false},
        {"null", nullptr},
    };
    ctx->ok(j.dump());
}

DEFINE_METHOD(Features, emit_event) {
    xchain::Context* ctx = self.context();
    const std::string body = "body";
    ctx->emit_event("call", body);
}

DEFINE_METHOD(Features, query_tx) {
    xchain::Context* ctx = self.context();
    const std::string tx_id = ctx->arg("tx_id");
    xchain::Transaction tx;
    ctx->query_tx(tx_id, &tx);
    ctx->ok(tx.blockid);
}

DEFINE_METHOD(Features, query_block) {
    xchain::Context* ctx = self.context();
    const std::string block_id = ctx->arg("block_id");
    xchain::Block block;
    ctx->query_block(block_id, &block);
    ctx->ok(block.pre_hash);
}

DEFINE_METHOD(Features, transfer) {
    xchain::Context* ctx = self.context();
    auto to = ctx->arg("to");
    if (to.empty()) {
        ctx->error("missing to");
        return;
    }

    auto amount = ctx->arg("amount");
    if (amount.empty()) {
        ctx->error("missing amount");
        return;
    }

    xchain::Account sender = xchain::Account(to);
    if (!sender.transfer(amount)) {
        ctx->error("transfer failed");
        return;
    }
    ctx->ok("ok");
}

DEFINE_METHOD(Features, direct_caller) {
    auto ctx = self.context();
    ctx->ok(ctx->caller());
    return;
}