package com.project.user_country_service.exception;

import com.project.user_country_service.dto.ErroResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ParametroInvalidoException.class)
    public ResponseEntity<ErroResponse> handleParametroInvalido(ParametroInvalidoException ex) {
        log.warn("Parâmetro inválido: {}", ex.getMessage());
        ErroResponse erro = ErroResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .mensagem(ex.getMessage())
                .build();
        return ResponseEntity.badRequest().body(erro);
    }

    @ExceptionHandler(ApiExternaException.class)
    public ResponseEntity<ErroResponse> handleApiExterna(ApiExternaException ex) {
        log.error("Erro na API externa: {}", ex.getMessage());
        ErroResponse erro = ErroResponse.builder()
                .status(HttpStatus.BAD_GATEWAY.value())
                .mensagem(ex.getMessage())
                .build();
        return ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(erro);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErroResponse> handleGeneral(Exception ex) {
        log.error("Erro interno inesperado", ex);
        ErroResponse erro = ErroResponse.builder()
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .mensagem("Erro interno do servidor. Tente novamente mais tarde.")
                .build();
        return ResponseEntity.internalServerError().body(erro);
    }
}
