(require 'notmuch)
(require 'notmuch-address)
(notmuch-address-message-insinuate)

;;(setq
;;	notmuch-command
;;	"/home/aperez/.local/bin/notmuch-locked")

(setq notmuch-address-command        "/home/aperez/.local/bin/notmuch-addrlookup")
(setq message-kill-buffer-on-exit    t)
(setq mail-specify-envelope-from     t)
(setq message-sendmail-envelope-from 'header)
(setq mail-envelope-from             'header)

(add-hook 'message-setup-hook
					'mml-secure-message-sign-pgpmime)

;;(add-hook 'message-setup-hook
;;					'(lambda () (footnote-mode t)))

(define-key notmuch-search-mode-map "d"
						(lambda ()
							"toggle deleted tag for thread"
							(interactive)
							(if (member "deleted" (notmuch-search-get-tags))
								(notmuch-search-tag "-deleted")
								(notmuch-search-tag '("+deleted" "-inbox" "-unread")))))

(define-key notmuch-show-mode-map "d"
						(lambda ()
							"toggle deleted tag for message"
							(interactive)
							(if (member "deleted" (notmuch-show-get-tags))
								(notmuch-show-tag "-deleted")
								(notmuch-show-tag '("+deleted" "-inbox" "-unread")))))

(define-key notmuch-search-mode-map "j"
						(lambda ()
							"toggle the spam (junk) tag for thread"
							(interactive)
							(if (member "spam" (notmuch-search-get-tags))
								(notmuch-search-tag "-spam")
								(notmuch-search-tag '("+spam" "-ham" "-inbox" "-unread")))))

(define-key notmuch-show-mode-map "j"
						(lambda ()
							"toggle the spam (junk) tag for message"
							(interactive)
							(if (member "spam" (notmuch-show-get-tags))
								(notmuch-show-tag "-spam")
								(notmuch-show-tag '("+spam" "-ham" "-inbox" "-unread")))))

(define-key notmuch-search-mode-map "H"
						(lambda ()
							"toggle the ham tag for thread"
							(interactive)
							(if (member "ham" (notmuch-search-get-tags))
								(notmuch-search-tag "-ham")
								(notmuch-search-tag '("+ham" "-spam")))))

(define-key notmuch-show-mode-map "H"
						(lambda ()
							"toggle the ham tag for message"
							(interactive)
							(if (member "ham" (notmuch-show-get-tags))
								(notmuch-show-tag "-ham")
								(notmuch-show-tag '("+ham" "-ham")))))

(define-key notmuch-search-mode-map "F"
						(lambda ()
							"toggle the flagged tag for thread"
							(interactive)
							(if (member "flagged" (notmuch-search-get-tags))
								(notmuch-search-tag "-flagged")
								(notmuch-search-tag "+flagged"))))

(define-key notmuch-show-mode-map "F"
						(lambda ()
							"toggle the flagged tag for message"
							(interactive)
							(if (member "flagged" (notmuch-show-get-tags))
								(notmuch-show-tag "-flagged")
								(notmuch-show-tag "+flagged"))))

(define-key notmuch-search-mode-map "i"
						(lambda ()
							"toggle the ignore tag for thread"
							(interactive)
							(if (member "ignore" (notmuch-search-get-tags))
								(notmuch-search-tag "-ignore")
								(notmuch-search-tag '("+ignore" "-inbox" "-unread")))))

(define-key notmuch-show-mode-map "i"
						(lambda ()
							"toggle the ignore tag for message"
							(interactive)
							(if (member "ignore" (notmuch-show-get-tags))
								(notmuch-show-tag "-ignore")
								(notmuch-show-tag '("+ignore" "-inbox" "-unread")))))

