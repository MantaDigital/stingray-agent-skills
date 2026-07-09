# Stingray Prompt Index

Copy these into a SKILL.md-compatible agent after installing Stingray.

## First Run

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the Studio Idea and Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

```text
What can Stingray Skills do from this agent? Use the current public skill surface, not legacy account API routes.
```

## Idea Intake

```text
Use Stingray to turn this into a Studio Idea: BTC may mean-revert after sharp intraday selloffs because forced selling tends to cluster. Keep it private for now.
```

```text
Create a Studio Idea from this X post and tell me what Evidence or Signal details are still missing. Do not publish anything yet: <paste public post text here>
```

## Evidence Grounding

```text
Ground the current Idea with Stingray Evidence. Tell me which market, venue, timeframe, and dataset assumptions matter before we design a Signal.
```

```text
For the current Idea, check whether the data coverage is enough for a Replay. If not, tell me the nearest supported Signal shape.
```

## Signal Design

```text
Design a Signal for the current Idea. If anything important is missing, ask only the blocking questions. Otherwise stage a Signal candidate I can inspect.
```

```text
Turn this thesis into a Signal candidate: when BTCUSDT drops 3% or more in 24h, test what happened next over the last 365 days.
```

## Accept And Replay

```text
If the staged Signal candidate is coherent and matches the current Idea, accept it as a committed Signal and run a private Replay. Do not publish.
```

```text
Run a private Replay for the selected Signal. If the run is still in progress, use Stingray status lookup until you can summarize the result or tell me what is blocked.
```

```text
Read the selected Signal status and latest Replay status without asking Stingray to redesign the Signal.
```

## Publication

```text
Publish a public Studio demo link for the current Idea using the committed Signal and Replay. Only publish if the current Idea is generic enough to share.
```

```text
Keep the Replay private. Summarize the result and tell me what would be included if I later ask for a public Studio Publication.
```

## Hyperliquid

```text
Use Stingray to test this Hyperliquid thesis privately: ETH funding heat check. Trigger when ETH funding on Hyperliquid rises above 0.75 bps/hr. Replay the last 365 days and report event count, average gap, and whether forward-return samples are available. Do not enable monitoring and do not publish a public Studio link.
```

```text
Check whether Stingray currently supports Hyperliquid OI, whale, liquidation, or mark-to-liquidation Signals. If not, tell me they are not supported today and offer the nearest supported funding-rate example.
```

## Recovery

```text
I think the previous Stingray action timed out. Use the last run id or client request id you recorded to recover the result before retrying.
```

```text
The previous response asked for missing input. Answer those questions and continue the same Stingray action in the same Idea context.
```

## Debug And Product Feedback

```text
If Stingray cannot support this thesis, give me a privacy-safe Debug report I can send to the team. Do not include my API token, private account data, or full prompt text.
```

```text
File a product feedback note in plain language: I want this external-agent workflow to support full strategy backtesting later, including entry, exit, and risk management.
```
