;;; Compiled snippets and support files for `makefile-gmake-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'makefile-gmake-mode
		     '(("fn" "$($0)" "function" nil nil nil nil "direct-keybinding" nil)
		       ("mc" "${1:YOUR_IDENTIFIER$(c-macroify-string yas-text)}$0" "mc" nil nil nil nil "direct-keybinding" nil)
		       ("var" "$(${1:VAR$(replace-regexp-in-string \" \" \"_\" (upcase yas-text))})" "var" nil nil nil nil "direct-keybinding" nil)))


;;; Do not edit! File generated at Fri Aug 26 12:22:26 2016
