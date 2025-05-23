#!/usr/bin/env bash
set -euo pipefail

# — Required environment variables
: "${ETHEREUM_HOSTS?Need to set ETHEREUM_HOSTS}"
: "${L1_CONSENSUS_HOST_URLS?Need to set L1_CONSENSUS_HOST_URLS}"
: "${VALIDATOR_PRIVATE_KEY?Need to set VALIDATOR_PRIVATE_KEY}"
: "${COINBASE?Need to set COINBASE}"
: "${_DAPPNODE_GLOBAL_PUBLIC_IP?Need to set _DAPPNODE_GLOBAL_PUBLIC_IP (your public IP)}"

# — Optional environment variables
BLOB_SINK_ARGS=()
SEQ_MIN_TX_BLOCK_ARG=()
SEQ_MAX_TX_BLOCK_ARG=()

if [[ -n "${BLOB_SINK_URL:-}" ]]; then
  BLOB_SINK_ARGS=(--blob-sink "$BLOB_SINK_URL")
fi

if [[ -n "${SEQ_MIN_TX_BLOCK:-}" ]]; then
  SEQ_MIN_TX_BLOCK_ARG=(--seqMinTxBlock "$SEQ_MIN_TX_BLOCK")
fi

if [[ -n "${SEQ_MAX_TX_BLOCK:-}" ]]; then
  SEQ_MAX_TX_BLOCK_ARG=(--seqMaxTxBlock "$SEQ_MAX_TX_BLOCK")
fi

# — Build the command array
CMD=(
  node
  --no-warnings
  /usr/src/yarn-project/aztec/dest/bin/index.js
  start
  --network            "alpha-testnet"
  --l1-rpc-urls        "$ETHEREUM_HOSTS"
  --l1-consensus-host-urls "$L1_CONSENSUS_HOST_URLS"
  --sequencer.validatorPrivateKey "$VALIDATOR_PRIVATE_KEY"
  --sequencer.coinbase "$COINBASE"
  --p2p.p2pIp          "$_DAPPNODE_GLOBAL_PUBLIC_IP"
  "${BLOB_SINK_ARGS[@]}"
  "${SEQ_MIN_TX_BLOCK_ARG[@]}"
  "${SEQ_MAX_TX_BLOCK_ARG[@]}"
  --archiver
  --node
  --sequencer
)

# exec replaces the shell with the node process (so signals propagate correctly)
exec "${CMD[@]}"
