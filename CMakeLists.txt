cmake_minimum_required(VERSION 3.14)
project(contract_sdk_cpp)

set(CMAKE_CXX_STANDARD 14)

include_directories(src /usr/local/include)

set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")

set(SRC
        reserved/forbidden.cc
        reserved/unified_check.cc
        src/xchain/json/json.inc.hpp
        src/xchain/trust_operators/tf.pb.cc
        src/xchain/trust_operators/trust_operators.cc
        src/xchain/xrc01/xrc01.cc
        src/xchain/xrc01/xrc01.pb.cc
        src/xchain/account.cc
        src/xchain/basic_iterator.cc
        src/xchain/basic_iterator.h
        src/xchain/block.cc
        src/xchain/context_impl.cc
        src/xchain/contract.cc
        src/xchain/contract.pb.cc
        src/xchain/crypto.cc
        src/xchain/syscall.cc
        src/xchain/transaction.cc)

set(HEADERS  src/xchain/json/json.h
        src/xchain/json/json.inc.hpp
        src/xchain/table/table.h
        src/xchain/table/table.tpl.h
        src/xchain/table/types.h
        src/xchain/trust_operators/tf.pb.h
        src/xchain/trust_operators/trust_operators.h
        src/xchain/xrc01/xrc01.h
        src/xchain/xrc01/xrc01.pb.h
        src/xchain/account.h
        src/xchain/basic_iterator.h
        src/xchain/block.h
        src/xchain/context_impl.h
        src/xchain/contract.pb.h
        src/xchain/crypto.h
        src/xchain/error.h
        src/xchain/safemath.h
        src/xchain/syscall.h
        src/xchain/transaction.h
        src/xchain/xchain.h)


add_library(xchain STATIC ${SRC})
set_target_properties(xchain PROPERTIES PUBLIC_HEADER "${HEADERS}")


list(APPEND XCHAIN_LIBS xchain)

install(
        TARGETS ${XCHAIN_LIBS}
        EXPORT "${TARGETS_EXPORT_NAME}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
        INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
        PUBLIC_HEADER DESTINATION /usr/local/include/xchain
)
