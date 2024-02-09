package com.capynotes.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class GatewayApplication {

	public static void main(String[] args) {
		SpringApplication.run(GatewayApplication.class, args);
	}

	@Bean
	public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
		return builder.routes()
				.route(r -> r.path("/person/**")
						.filters(f -> f
							.prefixPath("/api")
						)
						.uri("http://auth-service-spring-app:8082")
				).route(r -> r.path("/mail/**")
						.filters(f -> f
							.prefixPath("/api")
						)
						.uri("http://notification-service-spring-app:8081")
				).route(r -> r.path("/audio/**")
						.filters(f -> f
							.prefixPath("/api")
						)
						.uri("http://note-service-spring-app:8083")
				)
				.build();
	}

}