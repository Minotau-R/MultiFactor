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
    multiples <- split(deck, f = rep(ranks, length(suits)))
    flushes   <- split(deck, f = rep(names(suits), each = length(ranks)))

    # Convert to LinkMaps
    card2rank <- as.LinkMap(multiples, edge.names = c("card", "rank"))
    card2suit <- as.LinkMap(flushes, edge.names = c("card", "suit"))

    x <- list(
        card2rank,
        card2suit
    )
    levels <- list(
        card = deck,
        rank = ranks,
        suit = names(suits)
        )
    MultiFactor(x, levels)
}

