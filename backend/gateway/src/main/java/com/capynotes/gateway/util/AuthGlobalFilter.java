package com.capynotes.gateway.util;

import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import org.springframework.beans.factory.annotation.Autowired;

@Component
public class AuthGlobalFilter implements GlobalFilter {

    @Autowired
    private final JwtUtils jwtUtils; // Assume JwtUtils is similar to the one in your Auth Service and it's autowired here

    public AuthGlobalFilter(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String token = exchange.getRequest().getHeaders().getFirst("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            Long userId = jwtUtils.extractId(token); // Assumes JwtUtils has a similar method as in Auth Service
            ServerHttpRequest modifiedRequest = exchange.getRequest().mutate()
                    .header("X-USER-ID", userId.toString())
                    .build();
            return chain.filter(exchange.mutate().request(modifiedRequest).build());
        } else if (exchange.getRequest().getURI().getPath().equals("/api/auth/id") || exchange.getRequest().getURI().getPath().equals("/api/auth/email")) {
            return chain.filter(exchange);
        } else if (jwtUtils.isTokenExpired(token)) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            DataBuffer buffer = exchange.getResponse().bufferFactory().wrap("Token expired".getBytes());
            return exchange.getResponse().writeWith(Mono.just(buffer));
        } else {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            DataBuffer buffer = exchange.getResponse().bufferFactory().wrap("Unauthorized".getBytes());
            return exchange.getResponse().writeWith(Mono.just(buffer));
        }
    }
}
