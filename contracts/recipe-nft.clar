(define-non-fungible-token recipe-nft uint)

(define-data-var last-token-id uint u0)

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
    (ok token-id)
  )
)

(define-public (transfer-recipe (token-id uint) (recipient principal))
  (nft-transfer? recipe-nft token-id tx-sender recipient)
)

(define-read-only (get-recipe (token-id uint))
  (map-get? recipe-data token-id)
)
