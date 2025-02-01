(define-fungible-token coffee-tips)

(define-public (send-tip (amount uint) (recipient principal))
  (begin
    (try! (ft-transfer? coffee-tips amount tx-sender recipient))
    (ok true)
  )
)

(define-public (mint-tips (amount uint))
  (ft-mint? coffee-tips amount tx-sender)
)

(define-read-only (get-tip-balance (user principal))
  (ft-get-balance coffee-tips user)
)
