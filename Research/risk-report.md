# Solera Risk Assessment Report

## Contents

1. TL;DR
2. Introduction
3. Research Methodology
4. Research References
5. Project Overview
6. Due Diligence
7. Code Overview
8. Audits & Security
9. Governance & Access Control
10. On-chain Addresses
11. On-chain Monitoring
12. Risk Estimation
13. Risk Assessment Summary

## 1. TL;DR

TODO

## 2. Introduction

This report provides a structured assessment of the risks associated with supplying liquidity to the **Solera Markets** protocol.  
The scope of the analysis covers:

- **Technical risks** — smart contract code quality, upgradeability patterns, use of external dependencies.  
- **Integration risks** — reliance on oracles, bridges, and third-party protocols.  
- **Economic risks** — market design, liquidation mechanisms, collateral soundness, and potential systemic vulnerabilities.  
- **Governance and centralization risks** — roles, privileges, and key management practices.  

The goal of this report is to determine whether providing WETH or pETH on Plume as collateral in Solera is advisable.  
Risks are categorized by severity and likelihood, and a final recommendation is given on whether Cicada should enter a position.  

**Limitations**: this is a point-in-time assessment based on publicly available information, code repositories, and on-chain data at the moment of research. Future changes in contracts, governance, or market conditions may affect the conclusions.

## 3. Research Methodology

### 3.1. Analytical Approach

Our approach is structured in clear stages, with each stage producing concrete evidence or findings.  
All conclusions are backed by documentation, code references, or on-chain data.

**Stage 0 — Scope**  
Define the exact scenario: supplying WETH or pETH on Plume, ideally in an isolated market.  

**Stage 1 — Due Diligence**  
Check legitimacy: official docs, audits, addresses, team/funding signals, and market presence.  

**Stage 2 — Protocol Review**  
Understand Solera’s market design, liquidation mechanics, oracle dependencies, and governance model.  

**Stage 3 — Smart Contracts**  
Review key contracts: deposits, borrowing, liquidations. Focus on upgradeability, access control, and admin powers.  

**Stage 4 — On-Chain Validation**  
Verify that documentation matches deployments. Confirm addresses, parameters, and current balances.  

**Stage 5 — External Data Cross-Check**  
Compare Solera’s reported metrics with independent sources (DefiLlama, Nansen, explorers).  

**Stage 6 — Risk Assessment**  
Classify risks into Smart-Contract, Integration, Economic, and Centralization. Score by severity × likelihood, and decide:

- Enter
- Enter with conditions
- Do not enter

**Stage 7 — Monitoring**  
Define what to track if we enter: contract changes, role shifts, pool balances, oracle freshness. Outline runbooks for emergency response.

### 3.2. Tools Used

- **[GitHub](https://github.com/)**: repo & commit review  
- **[GitBook](https://www.gitbook.com/)**: documentation cross-check  
- **[Slither](https://github.com/crytic/slither)**: static analysis  
- **[Foundry](https://book.getfoundry.sh/)**: unit tests, fuzzing, invariants, coverage  
- **[Hardhat](https://hardhat.org/)**: coverage (solidity-coverage), integration scripts  
- **[Tenderly](https://tenderly.co/)**: tx simulations  
- **[Blockscout](https://blockscout.com/)**: address & role validation  
- **[DefiLlama](https://defillama.com/)**: TVL & liquidity metrics  
- **[Nansen](https://www.nansen.ai/)** / **[Dune](https://dune.com/)**: flows & activity

## 4. Research References

### 4.1. Official & Documentation

- [Website](https://solera.market)
- [Application](https://app.solera.market/)
- [Documentation](https://docs.solera.market/)
- [Solera Labs Twitter](https://x.com/SoleraLabs)
- [Solera Markets Twitter](https://x.com/SoleraMarkets)
- [GitHub Organization](https://github.com/soleramarkets)
- [Discord Community](https://discord.com/invite/jAdmVMEhJr)
- [Medium Blog](https://medium.com/@SoleraMarkets)

### 4.2. Security audits

- [Zenith Audit Report (Dec 2024)](https://2550339912-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FxnKyOKJHYcrZeGHpRuHg%2Fuploads%2FLPus8JS8WGA5412Nf2eH%2FSolera%20-%20Zenith%20Audit%20Report%20-%2012-18-2024.pdf?alt=media&token=ade0f7c6-2105-422f-8411-f099cf71e00f)
- [Zellic Audit Report (Feb 2025)](https://2550339912-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FxnKyOKJHYcrZeGHpRuHg%2Fuploads%2FtSEQnq1GRItGbgiUcoFm%2FSolera%20-%20Zellic%20Audit%20Report%20-%2002-04-2025.pdf?alt=media&token=f5b48e43-6c77-4591-ac94-3a0754c54ca9)
- [Zellic Audit Report (March 2025)](https://2550339912-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FxnKyOKJHYcrZeGHpRuHg%2Fuploads%2F4UT7XaqETfzun5TSBrKU%2FSolera%20-%20Zellic%20Audit%20Report%20-%2005-19-2025.pdf?alt=media&token=065cf5fc-0f75-4e83-b061-c12e251c8c79)

### 4.3. Explorers & Analytics

- [DefiLlama: Solera](https://defillama.com/protocol/solera)
- [Dune: Solera](https://dune.com/whale_hunter/solera)
- [Dune: Plume Network](https://dune.com/kosyokmin/plume-network)

### 4.4. Media & Community

- [Medium: "Introducing Solera"](https://medium.com/@SoleraMarkets/introducing-solera-a6c857213569)
- [Medium: "Solera’s Complete RWAfi Solution built on Plume’s Infrastructure"](https://medium.com/@SoleraMarkets/soleras-comple-rwafi-solution-built-on-plume-s-infrastructure-0491cdea520e)

## 5. Project Overview

### 5.1. High-level Description

**Solera Markets** is a decentralized lending protocol deployed on **Plume Network**, an EVM-compatible blockchain designed to host tokenized real-world assets (RWA). Plume positions itself as a specialized Layer-1 for compliant RWA infrastructure, offering native integrations for tokenized treasuries, stablecoins, and other off-chain collateral. While this creates opportunities for institutional DeFi, it also introduces **network-level risks**, as Plume is a relatively new chain with limited validator decentralization compared to Ethereum mainnet or established L2s.  

Solera is a **fork of Aave v3** with an extended market design:  

- **Main Market:** a shared pool of liquidity where multiple assets can be supplied and borrowed against each other, similar to Aave’s pooled architecture.  
- **Isolated Markets:** powered by the Morpho stack, each market is a single collateral–single borrow pair. Risks are fully confined to that pair, and once deployed, an isolated market is immutable.  

When users supply assets, they receive **sTokens** — interest-bearing ERC-20 receipts that grow automatically as interest accrues (rebase-style). When borrowing, the protocol mints **vTokens** to represent variable debt; their balances increase as interest accrues, but unlike sTokens, they are non-transferable.  

Currently, Solera supports WETH and pETH on Plume, as well as stablecoins and other collateral types. Investors can either act as liquidity suppliers (earning yield via sTokens) or borrowers (taking on vToken debt). Returns are determined by dynamic interest rates set by market utilization.  

### 5.2. Key Features

1. **Dual market architecture:** Main pooled market (Aave fork) + isolated markets (Morpho stack).  

2. **Oracle diversification:** Multiple providers (Stork, eOracle, Chronicle) to reduce single-point-of-failure risk.  

3. **Risk parameters:** Asset-level LTV, liquidation thresholds, borrow/supply caps, and eMode for correlated assets.  

4. **Immutable isolated markets:** Once deployed, an isolated market cannot be modified, limiting governance risk.

5. **sTokens / vTokens model:** sTokens rebase to reflect supplier yield; vTokens track borrower debt.

6. **Governance & security:** Admin actions and upgrades controlled by a multisig setup, reducing centralization risk.

7. **Permissioned vs permissionless pools:** Optional access-controlled markets for institutional participants.

8. **Liquidity fragmentation trade-off:** Isolated markets localize risk but may reduce available liquidity for liquidations.

9. **Core collateral integration**: WETH and pETH as foundational assets on Plume.

### 5.3. Supported Assets / Markets

#### 5.3.1. Market types

- **Main Market (Aave v3 fork):** pooled, multi-asset lending/borrowing with eMode for correlated assets.
- **Isolated Markets (Morpho stack):** immutable 1:1 collateral–borrow pairs; risks are siloed per market.

#### 5.3.2. Main Market - Overview

The main market in Solera is a shared liquidity pool inherited from the Aave v3 model.  
It currently supports core assets on Plume such as **WETH, pETH, pUSD**, and **PLUME tokens**, alongside additional vault tokens (e.g., nALPHA, nINSTO, nETF, nBASIS).  

Each asset has defined **risk parameters** including:  

- **Max LTV and Liquidation Thresholds:** e.g., WETH and pETH both use 70% / 72.5%, with higher thresholds (up to 90%) under eMode for ETH-correlated assets.  
- **Supply and Borrow Caps:** to limit systemic exposure.  
- **eMode:** allowing correlated assets (e.g., ETH variants) to be leveraged more efficiently.  

The main advantage of this structure is **deep liquidity** across multiple assets, but the drawback is **shared risk**: instability of a single asset (e.g., depeg of pUSD) can propagate to the entire pool.  

**Live snapshot (September 2025):**

![solera-dashboard](../Research/images/solera-dashboard.png)

This distribution shows that the market is currently concentrated in Plume USD and Nest Alpha Vault, while ETH-related assets (WETH, pETH) represent only a small share of supplied and borrowed balances.

#### 5.3.3. Main Market – Keypoints

Reference: [Solera App – Main Market Dashboard](https://app.solera.market/markets/?marketName=proto_plume_v3) (September 2025).

![solera-assets](../Research/images/solera-assets.png)

1. **Total liquidity check.**  
   - Data: ~$46.6K supplied, ~$22.3K borrowed.  
   - Observation: this is extremely low TVL for an institutional-grade protocol. Even moderate deposits/withdrawals would distort utilization and APYs.  
   - Conclusion: liquidity is insufficient for meaningful institutional positions.  

2. **Asset concentration.**  
   - Data: Plume USD (pUSD) ≈ $20.8K supplied / $17.6K borrowed; Nest Alpha Vault (nALPHA) ≈ $19.9K supplied / $4.1K borrowed. Together >85% of market activity.  
   - Observation: ETH-linked assets (WETH, pETH) together account for <4% of supply and <$100 borrowed.  
   - Conclusion: the market is dominated by Plume-native tokens, while ETH assets remain marginal.  

3. **ETH markets untested.**  
   - Data: WETH supply ~$930 / borrow ~$23; pETH supply ~$927 / borrow ~$45.  
   - Observation: positions are negligible compared to stablecoin activity.  
   - Conclusion: liquidation and collateral mechanics for ETH are unproven under real stress.  

4. **Collateral parameters.**  
   - Data: LTV = 0% for most assets.  
   - Observation: these assets cannot currently be used as effective collateral.  
   - Conclusion: the main market functions more like a liquidity sandbox than a full-featured credit market.  

5. **Borrow rates.**  
   - Data: pUSD borrow APY ≈ 10.5%; nINSTO borrow APY ≈ 10.6%.  
   - Observation: such elevated yields are caused by thin liquidity and small utilization shocks.  
   - Conclusion: current rates are unstable and not representative of sustainable demand.  

6. **Asset freezes.**  
   - Data: several assets are flagged as *“frozen/paused by Aave community decisions”*.  
   - Observation: in practice, this disables new supply/borrow, leaving only withdrawals and repayments.  
   - Conclusion: reliance on governance/ops interventions highlights early-stage maturity and centralization of risk management.  

7. **Systemic dependency.**  
   - Data: most activity in pUSD, nALPHA, and other Plume-native tokens.  
   - Observation: protocol health is tied to the stability of Plume’s stablecoins and the Ethereum ↔ Plume bridge (via pETH).  
   - Conclusion: systemic risk is strongly coupled with Plume infrastructure.  

**Overall conclusion:**  
The Main Market is shallow, highly concentrated in Plume-native assets, and not yet functional for ETH collateral. Governance-level freezes and 0% LTV parameters further limit usability. For institutional investors, this underlines both the early-stage nature of the protocol and its dependency on Plume-native infrastructure.

#### 5.3.4. Isolated Markets

TODO

## 6. Due Diligence

### 6.1 Team

TODO

### 6.2 Funding & Investors

TODO

### 6.3 Social Media Presence

TODO

### 6.4 Listings & Market Metrics

TODO

## 7. Code Overview

### 7.1 Repository Structure

TODO

### 7.2 Core Contracts

TODO

### 7.3 External Dependencies

TODO

### 7.4 Code Quality & Style

TODO

## 8. Audits & Security

### 8.1 Existing Audits

TODO

### 8.2 Audit Findings

TODO

### 8.3 Remediations & Commit History

TODO

### 8.4 Bug Bounty / Security Practices

TODO

## 9. Governance & Access Control
### 9.1 Governance Model
### 9.2 Critical Roles
### 9.3 Timelock / Multisig
### 9.4 Centralization Risks

## 10. On-chain Addresses
### 10.1 Contract Addresses
### 10.2 Admin / EOA Addresses
### 10.3 Observed Activity

## 11. On-chain Monitoring
### 11.1 Events & Parameters to Track
### 11.2 Balance & Liquidity Tracking
### 11.3 Governance / Role Changes
### 11.4 Suggested Monitoring Tools

## 12. Risk Estimation
### 12.1 Smart Contract Risks
### 12.2 Integration Risks
### 12.3 Economic Risks
### 12.4 Centralization Risks

## 13. Risk Assessment Summary
### 13.1 Risk Matrix
### 13.2 Final Recommendation
