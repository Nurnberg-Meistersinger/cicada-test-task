# Cicada Test Task – Solera Audit

Author: **Lev Menshchikov**  
Role: Blockchain Security Researcher  
Date: September 2025  

## Overview

This repository contains the deliverables for the Cicada Capital test task.  
The focus is a **risk analysis of the Solera Markets protocol on Plume Network**, combining documentation review, on-chain validation, and structured risk reporting.

## Repository Structure

├── Audit/                  # Foundry-based test environment
│   ├── src/                # Interfaces & helper contracts
│   └── test/               # Unit tests, fork tests, ACL checks
│
├── Research/               # Supporting research materials
│   ├── images/             # Dashboards & diagrams for report
│   └── risk-report.md      # Main risk assessment report

## How to Read

1. **Start with the report** → `Research/risk-report.md`  
   - TL;DR and conclusions in Section 1.  
   - Risk methodology in Section 3.  
   - Deep-dive into contracts, audits, and risk scoring (Sections 7–11).  

2. **Check supporting images** → `Research/images/`  
   - Contains DefiLlama snapshots, Tenderly traces, and system diagrams.  

3. **Review the tests** → `Audit/test/`  
   - Solidity tests used to validate ACLManager, reserves, proxies.  
   - Confirm protocol state on Plume fork.

## Requirements

- [Foundry](https://book.getfoundry.sh/) (forge + cast)  
- [jq](https://stedolan.github.io/jq/) for JSON parsing  
- RPC access to **Plume Network**

## Notes

- This repository is self-contained and reproducible: all tests run on a fork of Plume RPC.  
- Sensitive keys are excluded (`.env`).  
- Report conclusions are valid **as of September 2025**; protocol parameters may change.
