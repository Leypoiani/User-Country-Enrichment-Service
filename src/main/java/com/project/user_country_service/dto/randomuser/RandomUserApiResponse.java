package com.project.user_country_service.dto.randomuser;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class RandomUserApiResponse {

    private List<RandomUserResult> results;
}
