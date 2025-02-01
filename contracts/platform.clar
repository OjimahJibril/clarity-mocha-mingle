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
    (asserts! (<= rating u5) (err u100))
    (map-set recipe-ratings
      { recipe-id: recipe-id, user: tx-sender }
      { rating: rating }
    )
    (ok true)
  )
)

(define-public (review-recipe (recipe-id uint) (review (string-utf8 500)))
  (begin
    (map-set recipe-reviews
      { recipe-id: recipe-id, user: tx-sender }
      { review: review }
    )
    (ok true)
  )
)

(define-read-only (get-recipe-rating (recipe-id uint) (user principal))
  (map-get? recipe-ratings { recipe-id: recipe-id, user: user })
)

(define-read-only (get-recipe-review (recipe-id uint) (user principal))
  (map-get? recipe-reviews { recipe-id: recipe-id, user: user })
)
