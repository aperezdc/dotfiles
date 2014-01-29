(require 'notmuch)
(require 'notmuch-address)
(notmuch-address-message-insinuate)

(setq notmuch-address-command        "/home/aperez/.local/bin/notmuch-addrlookup")
(setq message-kill-buffer-on-exit    t)
(setq mail-specify-envelope-from     t)
(setq message-sendmail-envelope-from 'header)
(setq mail-envelope-from             'header)

(add-hook 'message-setup-hook
					'mml-secure-message-sign-pgpmime)

;;(add-hook 'message-setup-hook
;;					'(lambda () (footnote-mode t)))

(define-key notmuch-common-keymap "d"
						(lambda ()
							"Toggle deleted tag for thread/message"
							(interactive)
							(if (member "deleted" (notmuch-search-get-tags))
								(notmuch-search-tag '("-deleted"))
								(notmuch-search-tag '("+deleted" "-inbox" "-unread")))))

(define-key notmuch-common-keymap "j"
						(lambda ()
							"Toggle the spam (junk) tag for thread/message"
							(interactive)
							(if (member "spam" (notmuch-search-get-tags))
								(notmuch-search-tag '("-spam"))
								(notmuch-search-tag '("+spam" "-ham" "-inbox" "-unread")))))

(define-key notmuch-common-keymap "H"
						(lambda ()
							"Toggle the ham tag for thread/message"
							(interactive)
							(if (member "ham" (notmuch-search-get-tags))
								(notmuch-search-tag '("-ham"))
								(notmuch-search-tag '("+ham" "-spam")))))

(define-key notmuch-common-keymap "F"
						(lambda ()
							"Toggle the flagged tag for thread/message"
							(interactive)
							(if (member "flagged" (notmuch-search-get-tags))
								(notmuch-search-tag '("-flagged"))
								(notmuch-search-tag '("+flagged")))))

(define-key notmuch-common-keymap "i"
						(lambda ()
							"Toggle the ignore tag for thread/message"
							(interactive)
							(if (member "ignore" (notmuch-search-get-tags))
								(notmuch-search-tag '("-ignore"))
								(notmuch-search-tag '("+ignore" "-inbox" "-unread")))))

