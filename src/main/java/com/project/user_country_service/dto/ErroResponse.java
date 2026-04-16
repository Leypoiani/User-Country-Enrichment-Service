package com.project.user_country_service.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ErroResponse {

    private int status;
    private String mensagem;
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();
}
