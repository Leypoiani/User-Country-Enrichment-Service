package com.project.user_country_service.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UsuarioDTO {

    private String nome;
    private String email;
    private String genero;
    private int idade;
    private String telefone;
    private String nacionalidade;
    private String cidade;
    private String estado;
    private String pais;
    private String fotoUrl;
}
