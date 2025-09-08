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
- **[Explorer](https://explorer.plume.org/)**: address & role validation  
- **[DefiLlama](https://defillama.com/)**: TVL & liquidity metrics  
- **[Nansen](https://www.nansen.ai/)** / **[Dune](https://dune.com/)**: flows & activity

## 4. Research References

### 4.1. Official & Documentation

- [Website](https://solera.market)
- [Application](https://app.solera.market/)
- [Morpho dApp](https://morpho.solera.market/)
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

9. **Core collateral integration**: WETH and pETH (note: pETH is a bridged asset, introducing bridge risk tied to Ethereum ↔ Plume).

### 5.3. Supported Assets / Markets

#### 5.3.1. Market types

- **Main Market (Aave v3 fork):** pooled, multi-asset lending/borrowing with eMode for correlated assets.
- **Isolated Markets (Morpho stack):** immutable 1:1 collateral–borrow pairs; risks are siloed per market.

#### 5.3.2. Main Market - Overview

The main market in Solera is a shared liquidity pool inherited from the Aave v3 model. While the market lists core assets like WETH and pETH, in practice it is dominated by Plume-native tokens such as pUSD and Nest vault assets, with ETH exposure remaining marginal.

Each asset has defined risk parameters in documentation — including Maximum Loan-to-Value (LTV), Liquidation Threshold, Liquidation Penalty, Borrow Cap, and Supply Cap. For example, WETH and pETH are specified with Max LTV = 70% and Liquidation Threshold = 72.5%, with higher thresholds (up to 90%) under eMode for ETH-correlated assets. However, as of September 2025 the live dashboard displays LTV = 0% for most assets, reflecting that many markets are currently frozen.

Solera offers one-click recursive borrowing (“looping”) on selected assets (e.g., pUSD, nALPHA, nINSTO), allowing positions up to 10x leverage. While this boosts nominal yields and TVL, it greatly amplifies liquidation risk, especially given the thin liquidity of underlying assets.

Architecturally, this structure is designed to provide deep pooled liquidity. In practice, as of September 2025, liquidity is negligible (~$46K TVL), so the market cannot yet be considered deep or robust.

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
   - Data: several assets are flagged as “frozen/paused”. The wording (“by Aave community decisions”) is inherited from the Aave v3 fork. In Solera this reflects an internal governance/admin decision.
   - Observation: in practice, this disables new supply/borrow, leaving only withdrawals and repayments.  
   - Conclusion: reliance on governance/ops interventions highlights early-stage maturity and centralization of risk management.  

7. **Market composition.**  
   - Data: most activity in pUSD, nALPHA, and other Plume-native tokens.  
   - Observation: ETH-linked assets are marginal (<4% of balances).  
   - Conclusion: the main market is currently dominated by Plume-native tokens rather than widely recognized crypto assets.

**Overall conclusion:**  
The Main Market is shallow, highly concentrated in Plume-native assets, and not yet functional for ETH collateral. Governance-level freezes and 0% LTV parameters further limit usability. For institutional investors, this underlines both the early-stage nature of the protocol and its dependency on Plume-native infrastructure. Additionally, reliance on pETH introduces bridge risk tied to Plume ↔ Ethereum infrastructure.

#### 5.3.4. Isolated Markets – Overview

Solera’s isolated markets are implemented on the **Morpho stack**, where each market is a single collateral–borrow pair (e.g., nETF–pUSD, WETH–pUSD), where the loan asset is consistently pUSD. Once deployed, these markets are **immutable**, meaning parameters cannot be changed later. This design centralizes systemic exposure on the stability of Plume’s native stablecoin.

Deposits are funneled into **vaults**, which then allocate liquidity across a set of whitelisted isolated markets. For example, the **Re7 pUSD vault** aggregates deposits and routes them into pUSD-denominated markets. Users receive yield-bearing positions from the vault, while the vault enforces loan-to-value ratios (LLTV) and oracle configurations.

The key benefit is **risk containment**: failures in one market cannot propagate across the protocol. The trade-off is **liquidity fragmentation** and dependency on vault operators, since each vault defines which markets are supported and how funds are distributed.

#### 5.3.5. Isolated Markets – Keypoints

Reference: [Solera Morpho App](https://morpho.solera.market) (September 2025).

![morpho-earn](../Research/images/morpho-earn.png)

![morpho-borrow](../Research/images/morpho-borrow.png)

1. **Liquidity snapshot.**  
   - Data: ~$36.55M supplied, ~$33.52M borrowed.  
   - Observation: liquidity in isolated markets is ~800x higher than in the main market (~$46K TVL).  
   - Conclusion: the effective protocol activity is concentrated in Morpho-based isolated markets, while the main market is effectively dormant.  

2. **Vault concentration.**  
   - Data: all deposits concentrated in a single **Re7 pUSD vault** (≈$36.5M).  
   - Observation: this creates a single point of failure; vault misconfiguration or curator failure could impact the entire isolated markets segment.  
   - Conclusion: diversification across multiple vaults is absent; systemic exposure is concentrated.  

3. **Systemic dependency on pUSD.**  
   - Data: all loans are denominated in **pUSD**; collateral assets include nETF, wPLUME, nALPHA, nCREDIT, WETH, nTBILL, and others.  
   - Observation: since pUSD is the sole loan currency, the entire isolated markets segment is fully exposed to its stability.  
   - Conclusion: any depeg, oracle failure, or contract issue with pUSD would directly impact all isolated markets simultaneously, creating a systemic single point of failure.  

4. **Very high LLTV parameters.**  
   - Data: many markets operate with **LLTV = 86–91.5%** (vs 70–80% typical in Aave).  
   - Observation: safety margins are thin; even minor price moves or oracle glitches could trigger liquidations.  
   - Conclusion: elevated liquidation risk relative to established lending protocols.  

5. **Borrow APY dispersion.**  
   - Data:  
     - Low APY (≈0–1%) for collateral like nETF, wPLUME.  
     - Moderate APY (≈6–7%) for some stable derivatives (sdeUSD, nBASIS, wsrUSD).  
     - **Extreme APY spikes in thin markets**: WETH ≈ 227%, nALPHA ≈ 154%.  
   - Observation: these outliers are not sustainable yields, but artifacts of **very low liquidity**, where a handful of loans drive utilization sharply upward.  
   - Conclusion: borrowing costs are highly volatile and unpredictable. Such behavior highlights that some isolated markets are effectively non-functional for institutional flows.

6. **Governance/curation risk.**  
   - Data: Re7 vault displays “No curator” in the UI. It is unclear whether this reflects true centralization or incomplete UI data. At minimum, curator governance is opaque, introducing uncertainty for depositors.
   - Observation: participants cannot choose allocation; vaults decide which isolated markets to support.  
   - Conclusion: introduces governance risk and dependency on vault operators.  

**Overall conclusion:**  
While Solera’s isolated markets show significantly higher TVL than the main market, they are fragile: liquidity is hyper-concentrated in a single vault, safety margins are stretched with 86–91.5% LLTV, borrowing rates are highly uneven, and systemic dependency on pUSD is absolute. For institutional participants, this design amplifies both **counterparty risk (vault curator)** and **systemic risk (Plume stablecoin + bridge).**

## 6. Due Diligence

The Solera project presents itself as a credit hub on Plume, but the broader due diligence raises several concerns about maturity and long-term viability.  

**Team.** The developers behind Solera remain fully anonymous. No names, LinkedIn profiles, or GitHub activity are disclosed. While anonymity is not unusual in DeFi, it reduces accountability and makes it difficult to assess the competence of the team compared to protocols like Aave or Morpho where track record is public.  

**Funding and investors.** There is no evidence of venture backing or institutional investors. The only visible affiliation is with the Plume ecosystem itself, as Solera is exclusively deployed on Plume and relies on Morpho’s stack. This creates some ecosystem credibility but also ties Solera’s success entirely to the fate of a single emerging L1.  

**Documentation.** The project maintains relatively structured docs with risk parameters, addresses, and audit links. However, discrepancies exist between the documentation and live deployment: for instance, WETH/pETH are described with LTV values around 70%, yet the dashboard currently shows LTV = 0% due to frozen assets. Such gaps suggest that live configuration lags behind specifications, a sign of operational immaturity.  

**Listings and market metrics.** Solera is listed on DefiLlama but absent from other major aggregators like CoinGecko, CMC, or Token Terminal. According to DefiLlama (Sep 2025), TVL is ~$24.5K with ~$22.3K borrowed. Earlier in June, TVL briefly spiked above $16M before collapsing back near zero, indicating either testing by a single large depositor or temporary inflation through incentives. Such volatility undermines confidence in the stability of the user base.  

**Social presence.** The project maintains a website and a Twitter/X account, but community engagement is weak and no active Discord/Telegram hubs were found. The limited visibility makes it unlikely that Solera can attract sustained user adoption without stronger outreach.  

Overall, the due diligence paints Solera as an **early-stage, high-risk protocol**: the team is anonymous, there is no clear investor backing, documentation and live configuration diverge, and traction remains limited. Its close link to the Plume ecosystem gives some credibility, but also concentrates systemic risk on a single chain and its native stablecoin (pUSD).

## 7. Code Overview

## 7. Code Overview

As of September 2025, **Solera does not maintain a public GitHub repository** or otherwise disclose its smart contract source code. This prevents any independent review of repository structure, contract implementation, test coverage, or development practices.  

- **Repository Structure:** Not available (closed-source).  
- **Core Contracts:** Observable only through on-chain deployments on Plume Explorer and Tenderly. While contract addresses are published and verified, interaction logic must be reverse-engineered from transaction traces rather than source code.  
- **External Dependencies:** Based on documentation and UI, Solera relies on an Aave v3 fork for its main market, the Morpho stack for isolated markets, and oracle providers such as Stork, eOracle, and Chronicle. These integrations cannot be validated without open repositories.

However, we have **reconstructed Solera’s architecture** by mapping verified contracts and transaction flows.

Three primary diagram flows are proposed:  

1. **Core Lending Contracts & Flow** — how deposits, borrows, and tokenization (sTokens/vTokens) work in practice.  

![]()

2. **Governance, Admin Control & Treasury Architecture** — upgrade paths, admin roles, custody of reserves and emissions.  

![]()

3. **Oracle & External Integration Layer** — dependencies on price feeds, stablecoins, and cross-chain bridges.  

![]()

**Conclusion:** TODO


## 8. Audits & Security

### 8.1 Existing audits

Solera has undergone three external reviews: a short assessment by Zenith (Dec 2024) of listing scripts and market operations, and two audits by Zellic (Feb and Mar 2025) covering the staking module and the looping extension. Reported severities vary, but overall scope was narrow and time-boxed. No audit of the full protocol has been published.

### 8.2 Core themes

Across the reports, one pattern is clear: the critical risks are not low-level coding errors but **the concentration of admin powers**.

- In the staking vault, auditors showed that fee and vesting admins could manipulate prices, set confiscatory fees, or drain funds outright.  
- In listing scripts, Zenith noted that markets could be deployed without safeguards, leaving users exposed.  
- In looping, the issues were formally “informational,” but auditors stressed weak testing and reliance on trusted operators.  

In some cases the labeling was inconsistent: findings marked *Critical* in detail were reported as *High* in summaries. Regardless of taxonomy, the substance is that **privileged roles remain capable of harming investors**.

### 8.3 Summary

The audit trail suggests that Solera’s main risk is not external exploitation but **internal abuse or mismanagement**.  
While individual issues have been patched, the underlying model leaves investors dependent on the goodwill of administrators. With no open-source code, limited testing, and opaque governance, Solera cannot be considered trust-minimized.  

For institutional allocators this amounts to a **high scam-risk profile**: funds are secure only insofar as Solera’s operators choose not to use their powers against users.

## 9. Governance & Access Control



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
