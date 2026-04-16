package com.project.user_country_service.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.project.user_country_service.dto.HealthResponse;
import java.time.LocalDateTime;

@RestController
public class HealthController {

    @GetMapping("/health")
    public HealthResponse health() {
        return new HealthResponse("UP", LocalDateTime.now());
    }
}