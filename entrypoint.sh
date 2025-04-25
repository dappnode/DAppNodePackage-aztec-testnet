#!/usr/bin/env bash
set -euo pipefail

# — Required environment variables
: "${EXECUTION_RPC_URL?Need to set EXECUTION_RPC_URL}"
: "${CONSENSUS_HOST_URL?Need to set CONSENSUS_HOST_URL}"
: "${BLOB_SINK_URL?Need to set BLOB_SINK_URL}"
: "${VALIDATOR_PRIVATE_KEY?Need to set VALIDATOR_PRIVATE_KEY}"

# — P2P / IP
: "${_DAPPNODE_GLOBAL_PUBLIC_IP?Need to set _DAPPNODE_GLOBAL_PUBLIC_IP (your public IP)}"

# Build the command array
CMD=(
  node
  --no-warnings
  /usr/src/yarn-project/aztec/dest/bin/index.js
  start
  --network            "alpha-testnet"
  --l1-rpc-urls        "$EXECUTION_RPC_URL"
  --l1-consensus-host-urls "$CONSENSUS_HOST_URL"
  --blob-sink          "$BLOB_SINK_URL"
  --sequencer.validatorPrivateKey "$VALIDATOR_PRIVATE_KEY"
  --p2p.p2pIp          "$_DAPPNODE_GLOBAL_PUBLIC_IP"
  --archiver
  --node
  --sequencer
)

# exec replaces the shell with your node process (so signals propogate correctly)
exec "${CMD[@]}"
