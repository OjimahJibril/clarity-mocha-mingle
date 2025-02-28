(define-non-fungible-token recipe-nft uint)

(define-data-var last-token-id uint u0)

;; Error codes
(define-constant ERR-NOT-OWNER (err u401))
(define-constant ERR-INVALID-PARAMS (err u400))

(define-map recipe-data
  uint
  {
    creator: principal,
    title: (string-utf8 100),
    ingredients: (string-utf8 500),
    instructions: (string-utf8 1000),
    timestamp: uint
  }
)

(define-public (mint-recipe (title (string-utf8 100)) (ingredients (string-utf8 500)) (instructions (string-utf8 1000)))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-some (string-utf8-length? title)) ERR-INVALID-PARAMS)
    (try! (nft-mint? recipe-nft token-id tx-sender))
    (map-set recipe-data
      token-id
      {
        creator: tx-sender,
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        timestamp: block-height
      }
    )
    (var-set last-token-id token-id)
    (print {event: "recipe-minted", token-id: token-id, creator: tx-sender})
    (ok token-id)
  )
)

(define-public (transfer-recipe (token-id uint) (recipient principal))
  (begin
    (asserts! (is-eq (some tx-sender) (nft-get-owner? recipe-nft token-id)) ERR-NOT-OWNER)
    (try! (nft-transfer? recipe-nft token-id tx-sender recipient))
    (print {event: "recipe-transferred", token-id: token-id, from: tx-sender, to: recipient})
    (ok true)
  )
)

(define-read-only (get-recipe (token-id uint))
  (map-get? recipe-data token-id)
)
