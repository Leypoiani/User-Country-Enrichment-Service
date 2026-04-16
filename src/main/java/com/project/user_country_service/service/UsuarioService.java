package com.project.user_country_service.service;

import com.project.user_country_service.client.RandomUserClient;
import com.project.user_country_service.domain.Usuario;
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

    public List<Usuario> buscarUsuarios(int quantidade) {
        validarQuantidade(quantidade);

        RandomUserApiResponse response = randomUserClient.buscarUsuarios(quantidade);

        return response.getResults().stream()
                .map(this::converterParaDominio)
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

    private Usuario converterParaDominio(RandomUserResult result) {
        String nomeCompleto = String.format("%s %s %s",
                result.getName().getTitle(),
                result.getName().getFirst(),
                result.getName().getLast());

        Usuario usuario = new Usuario();
        usuario.setNome(nomeCompleto);
        usuario.setEmail(result.getEmail());
        usuario.setGenero(result.getGender());
        usuario.setIdade(result.getDob().getAge());
        usuario.setTelefone(result.getPhone());
        usuario.setNacionalidade(result.getNat());
        usuario.setCidade(result.getLocation().getCity());
        usuario.setEstado(result.getLocation().getState());
        usuario.setPais(result.getLocation().getCountry());
        usuario.setFotoUrl(result.getPicture().getLarge());
        return usuario;
    }
}
