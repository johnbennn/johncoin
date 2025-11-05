;; JohnCoin - a simple fungible token implemented with Clarity built-ins

(define-fungible-token johncoin)

(define-constant ERR_UNAUTHORIZED u401)
(define-constant ERR_ALREADY_INITIALIZED u100)
(define-constant ERR_INVALID_AMOUNT u102)

(define-data-var admin (optional principal) none)
(define-data-var total-supply uint u0)

(define-read-only (get-admin)
  (ok (var-get admin)))

(define-read-only (get-name)
  (ok "John Coin"))

(define-read-only (get-symbol)
  (ok "JOHN"))

(define-read-only (get-decimals)
  (ok u6))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance johncoin who)))

(define-private (is-admin (who principal))
  (is-eq (var-get admin) (some who)))

(define-public (initialize)
  (if (is-some (var-get admin))
      (err ERR_ALREADY_INITIALIZED)
      (begin
        (var-set admin (some tx-sender))
        (ok true))))

(define-public (mint (amount uint) (recipient principal))
  (begin
    (if (not (is-admin tx-sender))
        (err ERR_UNAUTHORIZED)
        (if (is-eq amount u0)
            (err ERR_INVALID_AMOUNT)
            (match (ft-mint? johncoin amount recipient)
              okv (begin
                     (var-set total-supply (+ (var-get total-supply) amount))
                     (ok true))
              errv (err errv))))))

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (if (or (is-admin tx-sender) (is-eq tx-sender sender))
      (match (ft-transfer? johncoin amount sender recipient)
        okv (ok true)
        errv (err errv))
      (err ERR_UNAUTHORIZED)))