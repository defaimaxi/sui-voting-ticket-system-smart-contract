/*
/// Module: voting
module voting::voting;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module voting::voting_system;


use std::string::String;


/// Ticket = 1 vote
public struct VotingTicket has key {
    id: UID,
}

/// Option to vote on
public struct VotingOption has key, store {
    id: UID,
    name: string,
    votes: u64,
}

/// Global voting session
public struct VotingSession has key {
    id: UID,
    options: vector<VotingOption>,
}

///---Event Definitions ---
public struct TicketMintedEvent has copy, drop {
    ticket_id: ID,
    owner: address,
}

public struct VoteCastEvent has copy, drop {
    voter: address,
    option_index: u64,
}

public struct SessionCreatedEvent has copy, drop {
    creator: address,
    option_names: vector<String>,
}

/// Mint a voting ticket
public entry fun mint_ticket(ctx: &mut TxContext): VotingTicket {
    let id = UID::new(ctx);
    let ticket = VotingTicket { id };
    event::emit(TicketMintedEvent {
        ticket_id: ticket.id.id,
        owner: tx_context::sender(ctx),
    });
    ticket
}

/// Vote with a ticket (burn it after use)
public entry fun vote(
    session: &mut VotingSession,
    option_index: u64,
    ticket: VotingTicket,
    ctx: &mut TxContext,
) {
    assert!(option_index < vector::length(&session.options), 100);
    let mut opt = &mut session.options[option_index];
    opt.votes = opt.votes + 1;

    event::emit(VoteCastEvent {
        voter: tx_context::sender(ctx),
        option_index,
    });

    // Ticket is consumed
    // No transfer: dropped by default
}

/// Create a voting session
public entry fun create_session(
    option_names: vector<string::String>,
    ctx: &mut TxContext,
): VotingSession {
    let id = UID::new(ctx);
    let mut opts = vector::empty<VotingOption>();
    let i = 0;
    while (i < vector::length(&option_names)) {
        let name = vector::borrow(&option_names, i);
        vector::push_back(
            &mut opts,
            VotingOption {
                id: UID::new(ctx),
                name: *name,
                votes: 0,
            },
        );
        i = i + 1;
    };

    event::emit(SessionCreatedEvent {
        creator: tx_context::sender(ctx),
        option_names,
    });

    VotingSession {
        id,
        options: opts,
    }
}



#[test]
    public fun test_mint_ticket(ctx: &mut TxContext) {
        let ticket = mint_ticket(ctx);
        assert!(ticket.id.id != object::ID_ZERO, 100);
    }

    #[test]
    public fun test_create_session(ctx: &mut TxContext) {
        let names = vec::singleton(string::utf8(b"Option A"));
        let session = create_session(names, ctx);
        assert!(vec::length(&session.options) == 1, 101);
    }

    #[test]
    public fun test_vote(ctx: &mut TxContext) {
        let names = vec::singleton(string::utf8(b"Option A"));
        let mut session = create_session(names, ctx);
        let ticket = mint_ticket(ctx);
        vote(&mut session, 0, ticket, ctx);
        let votes = session.options[0].votes;
        assert!(votes == 1, 102);
    }