# Intent Rubrics

Read this file when the prompt is phrased in product language and more than one PAT-safe route family seems plausible.

Use it to decide what the user is actually trying to accomplish before you choose endpoints.

## Table of Contents

1. Account readiness vs product mutation
2. Asset research vs watchlist or portfolio mutation
3. Alert management vs account readiness
4. Chat usage vs linked-channel management
5. Attachment retrieval vs generic file handling
6. Referral management vs attribution capture
7. Credits and usage vs billing
8. Token hygiene vs token creation
9. Dependency recovery vs auth failure
10. Underspecified alert or portfolio write
11. Global anti-patterns

## 1. Account readiness vs product mutation

Signals:

- "What can this account do?"
- "Am I set up yet?"
- "Can alerts be activated?"
- "How far through onboarding am I?"

Interpret as:

- Account readiness, onboarding, linked-state, credits, usage, or growth state

Start with:

- `GET /me/access`
- then the smallest account-state route that answers the question

Do not misread as:

- permission to create or edit alerts
- permission to mutate watchlist or portfolio

## 2. Asset research vs watchlist or portfolio mutation

Signals:

- "Look up this asset"
- "Find the right entity"
- "Give me the id"
- "Show the best match"

Interpret as:

- KG-backed research and disambiguation

Start with:

- `GET /kg/search`
- `POST /kg/resolve` only if stable ids are needed

Do not misread as:

- a request to create a watchlist item
- a request to open a portfolio position
- a request to create an alert

Mutation starts only after the user explicitly asks for it.

## 3. Alert management vs account readiness

Signals:

- "Add an alert"
- "Turn this alert on"
- "List my active alerts"

Interpret as:

- alert CRUD or alert activation

Start with:

- `GET /me/access` when delivery readiness matters
- then the matching `/alerts*` route

Do not misread as:

- a generic account-health question
- a chat request

## 4. Chat usage vs linked-channel management

Signals for chat:

- "Start a chat"
- "Send a Telegram message"
- "Show chat history"

Signals for linked-channel management:

- "Is Telegram linked?"
- "Check my WhatsApp status"
- "Create a WhatsApp link code"
- "Disconnect WhatsApp"

Interpret as:

- chat when the user wants to converse with the assistant
- linked-channel management when the user wants connection state or linking actions

Do not misread:

- channel-state questions as chat-creation requests
- chat requests as WhatsApp or Telegram linking requests

## 5. Attachment retrieval vs generic file handling

Signals:

- "Download the attachment"
- "Open the image from chat"

Interpret as:

- chat attachment retrieval scoped by the owning chat

Start with:

- `GET /v1/attachments/:attachmentId`

Do not misread as:

- a generic file-storage or upload API
- a reason to use `/v1/tools*`

## 6. Referral management vs attribution capture

Signals for referrals:

- "Create my referral code"
- "What referral code do I have?"
- "Attribute me to this referral code"

Signals for attribution:

- "Record this attribution payload"
- "Save this source or campaign data"

Interpret as:

- referrals for invite or referral-code state
- attribution for marketing or source metadata capture

Do not misread:

- attribution capture as referral-code creation
- referral-code questions as public leaderboard requests unless the user asks for leaderboard data

## 7. Credits and usage vs billing

Signals:

- "How many credits do I have?"
- "What has this account used?"
- "What is my remaining balance?"

Interpret as:

- credit-balance and usage reporting

Do not misread as:

- a billing checkout request
- a subscription-management request

If the user asks for invoices, checkout, plan upgrades, or billing portal actions, that is outside PAT scope.

## 8. Token hygiene vs token creation

Signals for hygiene:

- "List my tokens"
- "Revoke old integrations"
- "Clean up PATs"

Signals for creation:

- "Create a PAT"
- "Mint a new token"

Interpret as:

- hygiene when listing and revoking existing tokens
- blocked boundary when creating a new PAT from a PAT-authenticated client

Do not misread:

- token cleanup as token minting
- token minting as allowed PAT behavior

## 9. Dependency recovery vs auth failure

Signals:

- KG route returns `502` or `503`
- the user says a backend dependency failed but PAT auth might still be valid

Interpret as:

- dependency recovery

Start with:

- a small read-only PAT-safe request such as `GET /me/access`

Do not misread as:

- evidence that the PAT is unauthorized
- a reason to expand into blocked surfaces

## 10. Underspecified alert or portfolio write

Signals:

- "Add an alert for ETH."
- "Set up an alert for when the market is bearish."
- "Alert me about Bitcoin."
- "Track my SOL."

Interpret as:

- a write intent that is missing required details

Start with:

- Ask the user to specify the missing details before creating anything. For alerts: which asset, what condition type (price change, TA indicator, news, or composite), and what threshold. For portfolio: which asset, what quantity, and what cost basis.

Do not misread as:

- a request to create with guessed defaults. "Add an alert for ETH" does not mean "create a 5% price alert for ETHUSDT." The user might want an RSI alert, a news alert, or a multi-condition composite.
- a research-only request. The verb "add" or "set up" signals write intent — but the write cannot proceed without the missing parameters.

## 11. Global Anti-Patterns

- Do not jump from a business request directly to the most destructive write when a read or capability check should happen first.
- Do not collapse distinct product intents into the same route family just because the nouns overlap.
- Do not use billing, guest lifecycle, internal admin, webhook, or `/v1/tools*` routes as fallbacks.
- Do not confuse "channel is linked" with "channel chat should be opened now".
- Do not confuse "look up an asset" with "mutate watchlist, portfolio, or alerts".
