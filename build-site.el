;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      ;; Enable HTML5
      org-html-html5-fancy t
      org-html-doctype     "html5"
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\"/>")

;; Define the publishing project
(setq org-publish-project-alist
      `(("org-site:main"
             :recursive t
             :base-directory "./content"
             :publishing-function org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil)
	("org-static"
	     :base-directory "./content"
	     :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	     :publishing-directory "./public"
	     :recursive t
	     :publishing-function org-publish-attachment)
	("blog"
	     :base-directory "./content/blog/"
	     :base-extension "org"
	     :recursive t
	     :publishing-directory "./public/blog/"
	     :publishing-function org-html-publish-to-html
	     :auto-sitemap t
	     :sitemap-title "Manices"
	     :sitemap-filename "index.org"
	     :sitemap-sort-files anti-chronologically)
       ))    ;; Don't include time stamp in file

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
