(require 'notmuch)
(require 'notmuch-address)
(notmuch-address-message-insinuate)

;;(setq
;;	notmuch-command
;;	"/home/aperez/.local/bin/notmuch-locked")

(setq notmuch-address-command        "/usr/bin/addrlookup")
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
								(notmuch-search-tag-thread "-deleted")
								(notmuch-search-tag-thread "+deleted" "-inbox" "-unread"))))

(define-key notmuch-show-mode-map "d"
						(lambda ()
							"toggle deleted tag for message"
							(interactive)
							(if (member "deleted" (notmuch-show-get-tags))
								(notmuch-show-tag-message "-deleted")
								(notmuch-show-tag-message "+deleted" "-inbox" "-unread"))))

(define-key notmuch-search-mode-map "j"
						(lambda ()
							"toggle the spam (junk) tag for thread"
							(interactive)
							(if (member "spam" (notmuch-search-get-tags))
								(notmuch-search-tag-thread "-spam")
								(notmuch-search-tag-thread "+spam" "-ham" "-inbox" "-unread"))))

(define-key notmuch-show-mode-map "j"
						(lambda ()
							"toggle the spam (junk) tag for message"
							(interactive)
							(if (member "spam" (notmuch-show-get-tags))
								(notmuch-show-tag-message "-spam")
								(notmuch-show-tag-message "+spam" "-ham" "-inbox" "-unread"))))

(define-key notmuch-search-mode-map "H"
						(lambda ()
							"toggle the ham tag for thread"
							(interactive)
							(if (member "ham" (notmuch-search-get-tags))
								(notmuch-search-tag-thread "-ham")
								(notmuch-search-tag-thread "+ham" "-spam"))))

(define-key notmuch-show-mode-map "H"
						(lambda ()
							"toggle the ham tag for message"
							(interactive)
							(if (member "ham" (notmuch-show-get-tags))
								(notmuch-show-tag-message "-ham")
								(notmuch-show-tag-message "+ham" "-ham"))))

(define-key notmuch-search-mode-map "f"
						(lambda ()
							"toggle the flagged tag for thread"
							(interactive)
							(if (member "flagged" (notmuch-search-get-tags))
								(notmuch-search-tag-thread "-flagged")
								(notmuch-search-tag-thread "+flagged"))))

(define-key notmuch-show-mode-map "f"
						(lambda ()
							"toggle the flagged tag for message"
							(interactive)
							(if (member "flagged" (notmuch-show-get-tags))
								(notmuch-show-tag-message "-flagged")
								(notmuch-show-tag-message "+flagged"))))

(define-key notmuch-search-mode-map "i"
						(lambda ()
							"toggle the ignore tag for thread"
							(interactive)
							(if (member "ignore" (notmuch-search-get-tags))
								(notmuch-search-tag-thread "-ignore")
								(notmuch-search-tag-thread "+ignore" "-inbox" "-unread"))))

(define-key notmuch-show-mode-map "i"
						(lambda ()
							"toggle the ignore tag for message"
							(interactive)
							(if (member "ignore" (notmuch-show-get-tags))
								(notmuch-show-tag-message "-ignore")
								(notmuch-show-tag-message "+ignore" "-inbox" "-unread"))))

