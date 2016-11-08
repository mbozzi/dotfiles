;;; Compiled snippets and support files for `c-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'c-mode
		     '(("16" "uint16_t$0" "16" nil nil nil nil "direct-keybinding" nil)
		       ("32" "uint32_t$0" "32" nil nil nil nil "direct-keybinding" nil)
		       ("8" "uint8_t$0" "8" nil nil nil nil "direct-keybinding" nil)
		       ("cm" "/* $0 */\n" "comment" nil nil nil nil "direct-keybinding" nil)
		       ("doc" "/**\n * $0\n */" "doc-comment" nil nil nil nil "direct-keybinding" nil)
		       ("fp" "${1:int} ${2:function} (${3:params}) {\n         $0\n}\n" "function-prototype" nil nil nil nil "direct-keybinding" nil)
		       ("fp" "${1:int} ${2:function} (${3:params});$0" "function-prototype" nil nil nil nil nil nil)
		       ("gpl" "/* This file is a part of ${1:`(project-name-or-guess)`}.\n * Copyright (C) `(caddr (calendar-current-date))` Max Bozzi\n */\n\n/* $1 is free software: you can redistribute it and/or modify it under\n * the terms of the GNU General Public License as published by the Free Software\n * Foundation, either version 3 of the License, or (at your option) any later\n * version.\n *\n * $1 is distributed in the hope that it will be useful, but WITHOUT ANY\n * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR\n * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n *\n * You should have received a copy of the GNU General Public License along with\n * $1.  If not, see <http://www.gnu.org/licenses/>.\n */\n$0" "gpl-license-header" nil nil nil nil nil nil)
		       ("header-file" "/* This file is a part of ${1:`ad-hoc-project-name`}. */\n\n/* $1 is free software: you can redistribute it and/or modify it under\n * the terms of the GNU General Public License as published by the Free Software\n * Foundation, either version 3 of the License, or (at your option) any later\n * version.\n *\n * $1 is distributed in the hope that it will be useful, but WITHOUT ANY\n * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR\n * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n *\n * You should have received a copy of the GNU General Public License along with\n * $1.  If not, see <http://www.gnu.org/licenses/>.\n */\n\n# if ! defined ${1:$(c-macroify-string yas-text)}_HEADER_${2:`\n(c-macroify-string (file-name-nondirectory\n                    (file-name-sans-extension\n                      (if (buffer-file-name)\n                          (buffer-file-name)\n                        \"filename\"))))\n        `$(c-macroify-string yas-text)}_${3:`\n        file-extension\n        `$(c-macroify-string yas-text)}\n# define ${1:$(c-macroify-string yas-text)}_HEADER_$2_${3:$(c-macroify-string yas-text)}\n\n/**\n * \\file\n */\n\n$0\n\n# endif\n" "header-file" nil nil
			((file-extension
			  (c-macroify-string
			   (aif
			    (buffer-file-name)
			    (file-name-extension it)
			    "h")))
			 (ad-hoc-project-name
			  (project-name-or-guess)))
			nil "direct-keybinding" nil)
		       ("#\"" "# include \"$1\"$0\n" "include-system" nil nil nil nil "direct-keybinding" nil)
		       ("inc" "# include <$1>\n$0\n" "include-system" nil nil nil nil nil nil)
		       ("br" "break" "break" nil nil nil nil "direct-keybinding" nil)
		       ("c" "char" "char" nil nil nil nil "direct-keybinding" nil)
		       ("cs" "const" "const" nil nil nil nil "direct-keybinding" nil)
		       ("cont" "continue" "continue" nil nil nil nil "direct-keybinding" nil)
		       ("def" "default" "default" nil nil nil nil "direct-keybinding" nil)
		       ("do" "do {\n   $0\n} while (${1:condition});" "keyword-do" nil nil nil nil "direct-keybinding" nil)
		       ("dou" "double" "double" nil nil nil nil "direct-keybinding" nil)
		       ("e" "else" "else" nil nil nil nil "direct-keybinding" nil)
		       ("en" "enum ${1:name} {\n     ${2:NONE} = 0,\n     $0\n};" "enum" nil nil nil nil "direct-keybinding" nil)
		       ("ex" "extern" "extern" nil nil nil nil "direct-keybinding" nil)
		       ("fl" "float" "float" nil nil nil nil "direct-keybinding" nil)
		       ("f" "for ($1; $2; $3) {\n    $0\n}" "for" nil nil nil nil "direct-keybinding" nil)
		       ("g" "goto" "goto" nil nil nil nil "direct-keybinding" nil)
		       ("test"
			(progninclude)
			"include-system" nil nil nil nil "direct-keybinding" nil)
		       ("reg" "register" "register" nil nil nil nil "direct-keybinding" nil)
		       ("ret" "return" "return" nil nil nil nil "direct-keybinding" nil)
		       ("sh" "short" "short" nil nil nil nil "direct-keybinding" nil)
		       ("sz" "sizeof" "sizeof" nil nil nil nil "direct-keybinding" nil)
		       ("st" "static" "static" nil nil nil nil "direct-keybinding" nil)
		       ("str" "struct ${1:name} {\n       $0\n};" "struct" nil nil nil nil "direct-keybinding" nil)
		       ("sw" "switch ($1) {\ncase $2: {\n          $0\n          break;\n     }\n}" "switch" nil nil nil nil "direct-keybinding" nil)
		       ("td" "typedef ${1:original_type} ${2:new_name};$0" "typedef" nil nil nil nil "direct-keybinding" nil)
		       ("un" "union" "union" nil nil nil nil "direct-keybinding" nil)
		       ("us" "unsigned" "unsigned" nil nil nil nil "direct-keybinding" nil)
		       ("v" "void" "void" nil nil nil nil "direct-keybinding" nil)
		       ("vl" "volatile" "volatile" nil nil nil nil "direct-keybinding" nil)
		       ("wh" "while (${1:true}) {\n      $0\n}" "while" nil nil nil nil "direct-keybinding" nil)
		       ("main" "int main (int argc,\n    char ** argv) {\n    $0;\n    return 0;\n}" "main-function" nil nil nil nil "direct-keybinding" nil)
		       ("str" "typedef struct _tag_${1:name} {\n       $0\n} $1;" "struct" nil nil nil nil nil nil)))


;;; Do not edit! File generated at Mon Nov  7 00:45:05 2016
