
var assert = require("assert");

Test("undefined_behavior", function (t) {
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
        resp = contract.Invoke("undefined_behavior", {});
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
