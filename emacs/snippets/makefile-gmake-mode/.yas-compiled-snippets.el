;;; Compiled snippets and support files for `makefile-gmake-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'makefile-gmake-mode
		     '(("fn" "$($0)" "function" nil nil nil nil "direct-keybinding" nil)
		       ("uc" "${1:YOUR_IDENTIFIER$(replace-regexp-in-string \" \" \"_\" (upcase yas-text))}$0" "uc" nil nil nil nil "direct-keybinding" nil)
		       ("var" "$(${1:VAR$(replace-regexp-in-string \" \" \"_\" (upcase yas-text))})" "var" nil nil nil nil "direct-keybinding" nil)))


;;; Do not edit! File generated at Sun May 22 16:31:32 2016
