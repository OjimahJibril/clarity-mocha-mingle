(define-fungible-token coffee-tips)

(define-constant contract-owner tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u403))
(define-constant ERR-INSUFFICIENT-BALANCE (err u402))

(define-public (send-tip (amount uint) (recipient principal))
  (begin
    (asserts! (>= (ft-get-balance coffee-tips tx-sender) amount) ERR-INSUFFICIENT-BALANCE)
    (try! (ft-transfer? coffee-tips amount tx-sender recipient))
    (print {event: "tip-sent", amount: amount, from: tx-sender, to: recipient})
    (ok true)
  )
)

(define-public (mint-tips (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) ERR-NOT-AUTHORIZED)
    (try! (ft-mint? coffee-tips amount tx-sender))
    (print {event: "tips-minted", amount: amount, recipient: tx-sender})
    (ok true)
  )
)

(define-read-only (get-tip-balance (user principal))
  (ft-get-balance coffee-tips user)
)
