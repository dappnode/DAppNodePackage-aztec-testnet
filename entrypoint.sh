#!/usr/bin/env bash
set -euo pipefail

# — Required environment variables
: "${EXECUTION_RPC_URL?Need to set EXECUTION_RPC_URL}"
: "${CONSENSUS_HOST_URL?Need to set CONSENSUS_HOST_URL}"
: "${VALIDATOR_PRIVATE_KEY?Need to set VALIDATOR_PRIVATE_KEY}"
: "${_DAPPNODE_GLOBAL_PUBLIC_IP?Need to set _DAPPNODE_GLOBAL_PUBLIC_IP (your public IP)}"

# — Optional environment variables
BLOB_SINK_ARGS=()
if [[ -n "${BLOB_SINK_URL:-}" ]]; then
  BLOB_SINK_ARGS=(--blob-sink "$BLOB_SINK_URL")
fi

# — Build the command array
CMD=(
  node
  --no-warnings
  /usr/src/yarn-project/aztec/dest/bin/index.js
  start
  --network            "alpha-testnet"
  --l1-rpc-urls        "$EXECUTION_RPC_URL"
  --l1-consensus-host-urls "$CONSENSUS_HOST_URL"
  --sequencer.validatorPrivateKey "$VALIDATOR_PRIVATE_KEY"
  --p2p.p2pIp          "$_DAPPNODE_GLOBAL_PUBLIC_IP"
  "${BLOB_SINK_ARGS[@]}"
  --archiver
  --node
  --sequencer
)

# exec replaces the shell with the node process (so signals propagate correctly)
exec "${CMD[@]}"
