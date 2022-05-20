
var assert = require("assert");

Test("null_dereference", function (t) {
    var contract;
    t.Run("deploy", function (tt) {
        contract = xchain.Deploy({
            name: "sanitizer_case",
            code: "../sanitizer_case.wasm",
            lang: "c",
            init_args: {},
            options: { "account": "XC1111111111111111@xuper" }
        })
    });

    t.Run("invoke", function (tt) {
        resp = contract.Invoke("null_dereference", {});
    })
})

Test("buffer_overflow", function (t) {
    var contract;
    t.Run("deploy", function (tt) {
        contract = xchain.Deploy({
            name: "sanitizer_case",
            code: "../sanitizer_case.wasm",
            lang: "c",
            init_args: {},
            options: { "account": "XC1111111111111111@xuper" }
        })
    });

    t.Run("invoke", function (tt) {
        resp = contract.Invoke("buffer_overflow", {});
    })
})
Test("double_delete", function (t) {
    var contract;
    t.Run("deploy", function (tt) {
        contract = xchain.Deploy({
            name: "sanitizer_case",
            code: "../sanitizer_case.wasm",
            lang: "c",
            init_args: {},
            options: { "account": "XC1111111111111111@xuper" }
        })
    });

    t.Run("invoke", function (tt) {
        resp = contract.Invoke("double_delete", {});
    })
})

Test("int_overflow", function (t) {
    var contract;
    t.Run("deploy", function (tt) {
        contract = xchain.Deploy({
            name: "sanitizer_case",
            code: "../sanitizer_case.wasm",
            lang: "c",
            init_args: {},
            options: { "account": "XC1111111111111111@xuper" }
        })
    });

    t.Run("invoke", function (tt) {
        resp = contract.Invoke("int_overflow", {});
    })
})

Test("float_cast_overflow", function (t) {
    var contract;
    t.Run("deploy", function (tt) {
        contract = xchain.Deploy({
            name: "sanitizer_case",
            code: "../sanitizer_case.wasm",
            lang: "c",
            init_args: {},
            options: { "account": "XC1111111111111111@xuper" }
        })
    });

    t.Run("invoke", function (tt) {
        resp = contract.Invoke("float_cast_overflow", {});
    })
})

Test("divide_by_zero", function (t) {
    var contract;
    t.Run("deploy", function (tt) {
        contract = xchain.Deploy({
            name: "sanitizer_case",
            code: "../sanitizer_case.wasm",
            lang: "c",
            init_args: {},
            options: { "account": "XC1111111111111111@xuper" }
        })
    });

    t.Run("invoke", function (tt) {
        resp = contract.Invoke("divide_by_zero", {});
    })
})