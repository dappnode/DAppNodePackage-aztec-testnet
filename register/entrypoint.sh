#!/usr/bin/env bash
set -euo pipefail

# — Required environment variables
: "${ETHEREUM_HOSTS?Need to set ETHEREUM_HOSTS}"
: "${VALIDATOR_PRIVATE_KEY?Need to set VALIDATOR_PRIVATE_KEY}"
: "${COINBASE?Need to set COINBASE}"

# Staking asset handler for Sepolia (fixed value from documentation)
STAKING_ASSET_HANDLER="0xF739D03e98e23A7B65940848aBA8921fF3bAc4b2"
# Sepolia Chain ID 
L1_CHAIN_ID="11155111"

echo "Attempting to register as a validator..."
echo "This may fail if today's validator quota has been reached. If so, try again later."

# Execute the validator registration command
node \
  --no-warnings \
  /usr/src/yarn-project/aztec/dest/bin/index.js \
  add-l1-validator \
  --l1-rpc-urls "$ETHEREUM_HOSTS" \
  --private-key "$VALIDATOR_PRIVATE_KEY" \
  --attester "$COINBASE" \
  --proposer-eoa "$COINBASE" \
  --staking-asset-handler "$STAKING_ASSET_HANDLER" \
  --l1-chain-id "$L1_CHAIN_ID"

# Sleep to keep container running for logs inspection
echo "Validator registration attempt complete. Container will exit in 30 seconds."
sleep 30