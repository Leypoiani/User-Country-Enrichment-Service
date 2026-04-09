package com.project.user_country_service.dto.randomuser;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class RandomUserName {

    private String title;
    private String first;
    private String last;
}
