;; Constants for validation
(define-constant ERR-INVALID-RATING (err u100))
(define-constant ERR-RECIPE-NOT-FOUND (err u101))
(define-constant ERR-DUPLICATE-RATING (err u102))
(define-constant MAX-RATING u5)

(define-map recipe-ratings
  { recipe-id: uint, user: principal }
  { rating: uint }
)

(define-map recipe-reviews
  { recipe-id: uint, user: principal }
  { review: (string-utf8 500) }
)

(define-public (rate-recipe (recipe-id uint) (rating uint))
  (begin
    ;; Validate rating value
    (asserts! (<= rating MAX-RATING) ERR-INVALID-RATING)
    ;; Validate recipe exists
    (asserts! (is-some (contract-call? .recipe-nft get-recipe recipe-id)) ERR-RECIPE-NOT-FOUND)
    ;; Check for duplicate rating
    (asserts! (is-none (map-get? recipe-ratings { recipe-id: recipe-id, user: tx-sender })) ERR-DUPLICATE-RATING)
    
    (map-set recipe-ratings
      { recipe-id: recipe-id, user: tx-sender }
      { rating: rating }
    )
    (print {event: "recipe-rated", recipe-id: recipe-id, user: tx-sender, rating: rating})
    (ok true)
  )
)

(define-public (review-recipe (recipe-id uint) (review (string-utf8 500)))
  (begin
    ;; Validate recipe exists
    (asserts! (is-some (contract-call? .recipe-nft get-recipe recipe-id)) ERR-RECIPE-NOT-FOUND)
    ;; Validate review text
    (asserts! (is-some (string-utf8-length? review)) ERR-INVALID-PARAMS)
    
    (map-set recipe-reviews
      { recipe-id: recipe-id, user: tx-sender }
      { review: review }
    )
    (print {event: "recipe-reviewed", recipe-id: recipe-id, user: tx-sender})
    (ok true)
  )
)

(define-read-only (get-recipe-rating (recipe-id uint) (user principal))
  (map-get? recipe-ratings { recipe-id: recipe-id, user: user })
)

(define-read-only (get-recipe-review (recipe-id uint) (user principal))
  (map-get? recipe-reviews { recipe-id: recipe-id, user: user })
)
