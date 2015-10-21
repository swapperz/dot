au BufRead,BufNewFile */php-fpm.conf,*/fpm/*,/usr/local/etc/fpm.d/* set syntax=dosini
au BufRead,BufNewFile */nginx/*.conf,nginx.conf if &ft == '' | setfiletype nginx | endif 
au BufRead,BufNewFile */haproxy.conf,*/haproxy.cfg if &ft == '' | setfiletype haproxy | endif 
au BufRead,BufNewFile */exim/configure setfiletype exim
