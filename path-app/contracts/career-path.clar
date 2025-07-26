;; Constants
(define-constant err-already-chosen (err u100))
(define-constant err-role-not-found (err u101))
(define-constant err-no-role-selected (err u102))

;; Maps
(define-map user-roles principal (string-ascii 20))
(define-map completed-modules {user: principal, module: (string-ascii 30)} bool)

;; Function 1: Choose a role
(define-public (choose-role (role (string-ascii 20)))
  (begin
    (asserts! (is-none (map-get? user-roles tx-sender)) err-already-chosen)
    ;; Accept any non-empty role name
    (asserts! (> (len role) u0) err-role-not-found)
    (map-set user-roles tx-sender role)
    (ok (some role))))

;; Function 2: Complete a module
(define-public (complete-module (module-name (string-ascii 30)))
  (let ((role (map-get? user-roles tx-sender)))
    (begin
      (asserts! (is-some role) err-no-role-selected)
      (map-set completed-modules {user: tx-sender, module: module-name} true)
      (ok {user: tx-sender, module: module-name, status: "completed"}))))
