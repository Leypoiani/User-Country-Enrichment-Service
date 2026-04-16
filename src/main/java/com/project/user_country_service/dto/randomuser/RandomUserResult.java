package com.project.user_country_service.dto.randomuser;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class RandomUserResult {

    private String gender;
    private RandomUserName name;
    private RandomUserLocation location;
    private String email;
    private String phone;
    private RandomUserDob dob;
    private RandomUserPicture picture;
    private String nat;
}
