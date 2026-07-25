#' @importFrom utils data
.load_playing_cards <- function() local({
    utils::data("playing_cards", package = "MultiFactor", envir = environment())
    playing_cards <- get("playing_cards", mode = "list")
    names(playing_cards) <- c("suits", "ranks")
    return(playing_cards)
})

#' Generate and optionally draw from a poker deck.
#' @rdname randomMultiFactor
#' @name draw_cards
#' @param draw Optional `integer`. How many cards to draw from the deck.
#' @seealso [playing_cards]
#' @export
#'
draw_cards <- function(draw = NULL) {
    deck <- .create_deck()
    if(length(draw)) {
        return(sample(deck, draw))
    } else {
        return(deck)
    }
}

.create_deck <- function(
        x = .load_playing_cards()
) with(x, paste0( rep(ranks, length(suits)), rep(suits, each = length(ranks)) ))

#' Generate a small demo MultiFactor dataset containing different poker scorings
#' @rdname randomMultiFactor
#' @name poker_scores
#' @export
#'
poker_scores <- function() {
    pq <- .load_playing_cards()
    deck <- .create_deck(pq)
    ranks <- pq$ranks
    suits <- pq$suits

    # Define scores as lists
    multiples <- split(
        deck,
        f = factor(rep(ranks, length(suits)), levels = ranks)
        )
    flushes   <- split(deck, f = rep(names(suits), each = length(ranks)))
    straights <- lapply(
        seq_len(10L),
        function(i) ranks[pmax(1L, (seq(from = 0L, to = 4L) + i) %% 14)]
        )
    names(straights) <- lapply(straights, function(x) paste(x[1L], "to", x[5L]))
    names(straights)[10L] <- "Royal straight"

    # Convert to LinkMaps
    card2rank <- stack(multiples)
    colnames(card2rank) <- c("card", "rank")
    levels(card2rank$card) <- deck

    card2suit <- stack(flushes)
    colnames(card2suit) <- c("card", "suit")
    levels(card2suit$card) <- deck

    rank2straights <- stack(straights)
    colnames(rank2straights) <- c("rank", "straight")

    x <- list(
        card2rank,
        card2suit,
        rank2straights
    )
    levels <- list(
        card = deck,
        rank = ranks,
        suit = names(suits),
        straight = names(straights)
        )
    MultiFactor(x, levels)
}

