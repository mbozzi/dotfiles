;;; Compiled snippets and support files for `java-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
		     '(("class" "class ${1:Name} {\npublic:\n      $0\n};" "class" nil nil nil nil "direct-keybinding" nil)
		       ("cm" "/* $0 */" "comment" nil nil nil nil "direct-keybinding" nil)
		       ("doc" "/**\n * $0\n */" "documentation-comment" nil nil nil nil "direct-keybinding" nil)
		       ("for" "for (${1:int i = 0}; ${2:i < foo}; ${3:i ++}) {\n    $0\n}" "for" nil nil nil nil "direct-keybinding" nil)
		       ("header" "/*\n * CSCE 146 Section 005, University Of South Carolina.\n * Lab 0: Mine Counter.\n *\n * Copyright (C) 2016 Max Bozzi\n * Friday, August 19, 2016.\n */" "header-line" nil nil nil nil "direct-keybinding" nil)
		       ("header" "/* Copyright (C) 2016 Max Bozzi\n * Author: Max Bozzi\n * Date: `(calendar-date-string (calendar-current-date))`\n */" "header" nil nil nil nil "direct-keybinding" nil)
		       ("br" "break" "break" nil nil nil nil "direct-keybinding" nil)
		       ("c" "char" "char" nil nil nil nil "direct-keybinding" nil)
		       ("cont" "continue" "continue" nil nil nil nil "direct-keybinding" nil)
		       ("def" "default" "default" nil nil nil nil "direct-keybinding" nil)
		       ("dou" "double" "double" nil nil nil nil "direct-keybinding" nil)
		       ("e" "else" "else" nil nil nil nil "direct-keybinding" nil)
		       ("en" "enum ${1:name} {\n     ${2:NONE} = 0,\n     $0\n};" "enum" nil nil nil nil "direct-keybinding" nil)
		       ("fl" "float" "float" nil nil nil nil "direct-keybinding" nil)
		       ("f" "for ($1; $2; $3) {\n    $0\n}" "for" nil nil nil nil "direct-keybinding" nil)
		       ("pr" "private$0" "keyword-private" nil nil nil nil "direct-keybinding" nil)
		       ("pu" "public$0" "keyword-public" nil nil nil nil "direct-keybinding" nil)
		       ("ret" "return" "return" nil nil nil nil "direct-keybinding" nil)
		       ("sz" "sizeof" "sizeof" nil nil nil nil "direct-keybinding" nil)
		       ("st" "static" "static" nil nil nil nil "direct-keybinding" nil)
		       ("v" "void" "void" nil nil nil nil "direct-keybinding" nil)
		       ("wh" "while" "while" nil nil nil nil "direct-keybinding" nil)
		       ("main" "public static void main (String [] args) {\n     $0\n}" "main" nil nil nil nil "direct-keybinding" nil)
		       ("ln" "System.out.println (\"$0\");" "print-line" nil nil nil nil "direct-keybinding" nil)
		       ("sdoc" "/** $0 */" "short-documentation-string" nil nil nil nil "direct-keybinding" nil)))


;;; Do not edit! File generated at Fri Aug 26 12:22:25 2016
