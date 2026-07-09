# Signal Definition Notes

Read this file when the user wants to understand what makes a good Stingray
Signal candidate.

## Signal Candidate Expectations

`signal.design` asks Stingray Studio to translate the Idea into a Signal
candidate. The candidate should make these assumptions visible when possible:

- market or venue;
- asset or market symbol;
- condition family, such as price move, threshold, technical indicator, funding,
  news, or composite condition;
- timeframe or lookback window;
- threshold and units;
- whether the condition is replayable today;
- whether the condition is supported and replayable today.

If a required assumption is missing, the correct response is `needs_input`, not
a guessed Signal.

## Replayable First Slice

The public examples should prefer Signal shapes that Stingray can replay today.
Reliable examples include generic BTC spot movement theses and Hyperliquid
funding-rate theses.

## Live-Only Boundary

Hyperliquid open interest, whale movement, liquidation, and
mark-to-liquidation primitives are not supported in the public skill today. Do
not draft Signals for them as if they were available. Offer a supported
funding-rate example or a privacy-safe product feedback note.

## Acceptance

`artifact.accept` commits only a staged `signal_candidate` artifact in the first
public slice. It should be called after a candidate is returned and the user or
caller intent clearly includes acceptance. It does not update existing Signal
versions, accept Evidence, accept Monitor candidates, or enable live monitoring.

## Monitor Boundary

Signals can express live-monitoring intent, but monitor lifecycle mutation is
outside `skills:full` for now. If the user asks to enable, pause, resume, or
retire live monitoring, explain that this is outside the public skill's current
surface.
