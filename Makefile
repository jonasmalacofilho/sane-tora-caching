NGINX=nginx -c ./doc/nginx/nginx.conf -p ''

default: phony
	@echo 'No default target set up, be specific.'

start-nginx: phony
	$(NGINX)
stop-nginx: phony
	$(NGINX) -s quit
reload-nginx: phony
	$(NGINX) -s reload

start-tora: phony
	cd tora && haxe tora.hxml
	cp tora/tora_admin.n runtime/www/admin.n
	neko tora/tora.n -fcgi -h localhost -p 6666 > runtime/tora/tora.log 2>&1 & echo $$! > runtime/tora/tora.pid
stop-tora: phony
	kill -9 -- $$(cat runtime/tora/tora.pid)
restart-tora: stop-tora start-tora

stop-all: phony
	make stop-nginx ; make stop-tora

test: phony
	curl localhost:8080

.PHONY: phony
