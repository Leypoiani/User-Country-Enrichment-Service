package com.project.user_country_service.service;

import com.project.user_country_service.client.RandomUserClient;
import com.project.user_country_service.dto.UsuarioDTO;
import com.project.user_country_service.dto.randomuser.RandomUserApiResponse;
import com.project.user_country_service.dto.randomuser.RandomUserResult;
import com.project.user_country_service.exception.ParametroInvalidoException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

    private final RandomUserClient randomUserClient;

    public UsuarioService(RandomUserClient randomUserClient) {
        this.randomUserClient = randomUserClient;
    }

    public List<UsuarioDTO> buscarUsuarios(int quantidade) {
        validarQuantidade(quantidade);

        RandomUserApiResponse response = randomUserClient.buscarUsuarios(quantidade);

        return response.getResults().stream()
                .map(this::converterParaDTO)
                .toList();
    }

    private void validarQuantidade(int quantidade) {
        if (quantidade <= 0) {
            throw new ParametroInvalidoException(
                    "A quantidade deve ser maior que zero. Valor informado: " + quantidade);
        }
        if (quantidade > 5000) {
            throw new ParametroInvalidoException(
                    "A quantidade máxima permitida é 5000. Valor informado: " + quantidade);
        }
    }

    private UsuarioDTO converterParaDTO(RandomUserResult result) {
        String nomeCompleto = String.format("%s %s %s",
                result.getName().getTitle(),
                result.getName().getFirst(),
                result.getName().getLast());

        return UsuarioDTO.builder()
                .nome(nomeCompleto)
                .email(result.getEmail())
                .genero(result.getGender())
                .idade(result.getDob().getAge())
                .telefone(result.getPhone())
                .nacionalidade(result.getNat())
                .cidade(result.getLocation().getCity())
                .estado(result.getLocation().getState())
                .pais(result.getLocation().getCountry())
                .fotoUrl(result.getPicture().getLarge())
                .build();
    }
}
