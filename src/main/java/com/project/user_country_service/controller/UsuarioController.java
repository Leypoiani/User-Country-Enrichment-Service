package com.project.user_country_service.controller;

import com.project.user_country_service.dto.UsuarioDTO;
import com.project.user_country_service.service.UsuarioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping
    public ResponseEntity<List<UsuarioDTO>> buscarUsuarios(
            @RequestParam(defaultValue = "1") int quantidade) {
        List<UsuarioDTO> usuarios = usuarioService.buscarUsuarios(quantidade);
        return ResponseEntity.ok(usuarios);
    }
}
