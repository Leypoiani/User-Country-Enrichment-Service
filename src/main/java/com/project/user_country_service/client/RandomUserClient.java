package com.project.user_country_service.client;

import com.project.user_country_service.dto.randomuser.RandomUserApiResponse;
import com.project.user_country_service.exception.ApiExternaException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;

@Component
public class RandomUserClient {

    private static final Logger log = LoggerFactory.getLogger(RandomUserClient.class);

    private final RestTemplate restTemplate;
    private final String baseUrl;

    public RandomUserClient(
            RestTemplate restTemplate,
            @Value("${randomuser.api.url}") String baseUrl) {
        this.restTemplate = restTemplate;
        this.baseUrl = baseUrl;
    }

    public RandomUserApiResponse buscarUsuarios(int quantidade) {
        String url = baseUrl + "?results=" + quantidade;
        log.info("Chamando RandomUser API: {}", url);

        try {
            ResponseEntity<RandomUserApiResponse> response =
                    restTemplate.getForEntity(url, RandomUserApiResponse.class);

            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new ApiExternaException(
                        "RandomUser API retornou status inesperado: " + response.getStatusCode());
            }

            RandomUserApiResponse body = response.getBody();

            if (body == null || body.getResults() == null || body.getResults().isEmpty()) {
                throw new ApiExternaException("RandomUser API retornou resposta vazia ou inválida");
            }

            log.info("RandomUser API retornou {} usuário(s)", body.getResults().size());
            return body;

        } catch (ResourceAccessException ex) {
            log.error("Falha de comunicação com a RandomUser API: {}", ex.getMessage());
            throw new ApiExternaException(
                    "Não foi possível conectar à API externa. Tente novamente mais tarde.", ex);

        } catch (RestClientResponseException ex) {
            log.error("RandomUser API retornou erro HTTP {}: {}",
                    ex.getStatusCode(), ex.getResponseBodyAsString());
            throw new ApiExternaException(
                    "API externa retornou erro: " + ex.getStatusCode(), ex);

        } catch (ApiExternaException ex) {
            throw ex;

        } catch (Exception ex) {
            log.error("Erro inesperado ao chamar RandomUser API: {}", ex.getMessage());
            throw new ApiExternaException(
                    "Erro inesperado ao buscar usuários na API externa.", ex);
        }
    }
}
