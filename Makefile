docker-build:
	@docker-compose build --force-rm backup

test: docker-build
	@docker-compose start mysql && sleep 5 && docker-compose up
