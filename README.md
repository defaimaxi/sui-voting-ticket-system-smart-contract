# Sui Voting Ticket Smart Contract

This Move module implements a simple and secure voting system on the **Sui blockchain**, where users receive or purchase voting tickets that can be used to vote on predefined options. Each ticket represents a single vote, and the system enforces **one-time use per ticket**, preventing double voting.

---

## Features

-  Mint voting tickets (1 ticket = 1 vote)
- Create voting sessions with multiple options
- Vote on any option using a ticket
- Automatic vote counting and event logging
- Test coverage for all core functions
- Written in **Move 2024 syntax**

---

##  Functions

### `mint_ticket(ctx: &mut TxContext): VotingTicket`
Mints a new voting ticket, emits a `TicketMintedEvent`.

### `create_session(option_names: Vec<String>, ctx: &mut TxContext): VotingSession`
Creates a new voting session with custom option names. Emits `SessionCreatedEvent`.

### `vote(session: &mut VotingSession, option_index: u64, ticket: VotingTicket, ctx: &mut TxContext)`
Casts a vote on a selected option using a ticket (which is consumed). Emits `VoteCastEvent`.

---

## Events

| Event                 | Description                          |
|-----------------------|--------------------------------------|
| `TicketMintedEvent`   | Emitted when a user mints a ticket   |
| `VoteCastEvent`       | Emitted when a vote is cast          |
| `SessionCreatedEvent` | Emitted when a voting session starts |

---

## Tests

Included unit tests:

- `test_mint_ticket()`: Ensures tickets are correctly minted.
- `test_create_session()`: Validates creation of a session with options.
- `test_vote()`: Confirms correct vote logic and counting.

Run tests with:

```bash
sui move test

```
## Contract
- Telegram: [@defai_maxi](https://t.me/defai_maxi)
- Twitter: [@defai_maxi](https://x.com/dfai_maxi)
