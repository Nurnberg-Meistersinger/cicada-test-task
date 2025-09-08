// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library AddressBook {
    // Core pool
    address constant POOL_ADDRESSES_PROVIDER  = 0x6C0133c25BAeF3D4188C26BbA3f0aC5e85FFa815;
    address constant POOL_PROXY               = 0x2a8D6a5faB9190580006187b6693f4F69Ee2b07d;
    address constant POOL_CONFIGURATOR_PROXY  = 0xbAA677f70516432C0301039975E46a6B904d1977;

    // Governance
    address constant PROXY_ADMIN              = 0xA31165684aFA01bBA6D3270c1d182919ACf539f2;
    address constant ACL_MANAGER              = 0x267781db3b81947216F74d3ee4CefF0D7156Dcfa;

    // Treasury / rewards
    address constant TREASURY_PROXY           = 0x7dbD4D91efc83Ed1BF5549c1114Decb5Dd010907;
    address constant TREASURY_IMPL            = 0x64C2f8071830CB0d0C09d20Ca9Dab4178795b0f3;
    address constant EMISSION_MANAGER         = 0x9bd5ac51FcffF3aeFAD5c349A25b8CDE1576307E;
    address constant REWARDS_CONTROLLER_PROXY = 0xf76F8fE7e3539228fE298549C5C4D959094585E1;
    address constant REWARDS_CONTROLLER_IMPL  = 0x2D2fe2D75a49Cb027cf933734134Ce4bbBD9b99c;

    // Oracles
    address constant AAVE_ORACLE              = 0x4E269bba050A1a4Ea0A0008858513faf6b0F6375;
    address constant PROTOCOL_DATA_PROVIDER   = 0xEE343bd811500ca27995Bc83D7ec2bacb63680d0;

    // pETH
    address constant PETH                     = 0x39d1F90eF89C52dDA276194E9a832b484ee45574;
    address constant PETH_sTOKEN              = 0x30Bb4B93925A6B714f8d0232C69c302541681f35;
    address constant PETH_vTOKEN              = 0x4fC4dE25377b671fA38D855b4cEF72Ae7f74F43a;

    // wETH
    address constant WETH                     = 0xca59cA09E5602fAe8B629DeE83FfA819741f14be;
    address constant WETH_sTOKEN              = 0x3a616E5e559593d26adfB7F520b2bb3fB512f90D;
    address constant WETH_vTOKEN              = 0x442E289205e925dA232f91ed447427Ed1c71a743;
}
