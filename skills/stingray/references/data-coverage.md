# Data Coverage

Read this file when the user asks whether a market, venue, Signal, or Replay is
supported today.

## Current Public Guidance

The public skill should not promise raw data APIs. It should ask Stingray Studio
to ground Evidence and design Signals through product actions.

Use:

- `evidence.ground` for market context and coverage checks;
- `signal.design` for Signal candidate creation;
- `signal.replay` only after a committed Signal exists;
- `signal.status` for lightweight follow-up.

## Replayable Guidance

Good first-slice examples:

- generic BTC spot movement theses;
- price-move Signals that Stingray can stage and accept;
- Hyperliquid funding-rate Signals, especially ETH funding thresholds.

## Unsupported Hyperliquid Primitives

Treat these Hyperliquid ideas as not supported in the public skill today:

- open interest and open-interest change;
- whale position changes;
- liquidation flows;
- mark-to-liquidation distance.

The agent should not draft Signals or promise Replay for these primitives. Offer
a funding-rate example or a privacy-safe product feedback note.

## Coverage Failures

If a market or primitive is unsupported, say so plainly and offer:

1. a nearest supported Signal shape;
2. a private Idea or Signal design without Replay;
3. a privacy-safe Debug report for the team.
