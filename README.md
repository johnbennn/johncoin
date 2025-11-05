# JohnCoin

A simple fungible token for Stacks built with Clarity and managed via Clarinet.

## Features
- Define a fungible token `johncoin` with symbol `JOHN`
- One-time `initialize` to set the admin (the first caller)
- Admin-only `mint` to issue new tokens
- `transfer` with sender- or admin-authorization
- Read-only helpers: `get-admin`, `get-name`, `get-symbol`, `get-decimals`, `get-total-supply`, `get-balance`

## Repo structure
- `Clarinet.toml` – Clarinet project config
- `contracts/johncoin.clar` – Clarity smart contract
- `settings/*.toml` – Clarinet network settings
- `tests/` – Place integration/unit tests here (JS/TS via Vitest)

## Prerequisites
- Clarinet CLI
  - Check: `clarinet --version`
  - Install (via npm): `npm i -g @hirosystems/clarinet`
  - Docs: https://docs.hiro.so/clarinet/introduction

## Quickstart
```bash
clarinet check
```

## Using Clarinet Console
Start an interactive REPL loaded with your contract:
```bash
clarinet console
```
Example interactions in the console (replace `STX...` with real principals):
```lisp
;; set admin (run once)
(contract-call? .johncoin initialize)

;; mint 1,000 JOHN to Alice (admin only)
(contract-call? .johncoin mint u1000 'STX_ALICE)

;; transfer 100 JOHN from Alice to Bob (tx-sender must be Alice or admin)
(contract-call? .johncoin transfer u100 'STX_ALICE 'STX_BOB)

;; read balances and metadata
(contract-call? .johncoin get-balance 'STX_ALICE)
(contract-call? .johncoin get-total-supply)
(contract-call? .johncoin get-name)
(contract-call? .johncoin get-symbol)
(contract-call? .johncoin get-decimals)
```

## Development
- Format contracts: `clarinet format contracts/*.clar`
- Lint/typecheck TS tests: `npm run lint` (add ESLint) / `npm run test`
- Add more contracts: `clarinet contract new <name>`

## Testing
This template includes a Vitest setup (see `package.json`, `vitest.config.js`).
- Install deps: `npm install`
- Run tests: `npm test`

## Deployment (overview)
Use Clarinet deployments to promote contracts to Devnet/Testnet/Mainnet.
- Simnet/Devnet: `clarinet integrate`
- Manage deployments: `clarinet deployments --help`

## Errors
- `u100` – already initialized
- `u401` – unauthorized
- `u102` – invalid amount

## License
See `LICENSE`.
