package com.project.user_country_service.domain;

public class Usuario {

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

    public Usuario() {
    }

    public Usuario(String nome, String email, String genero, int idade, String telefone,
                   String nacionalidade, String cidade, String estado, String pais, String fotoUrl) {
        this.nome = nome;
        this.email = email;
        this.genero = genero;
        this.idade = idade;
        this.telefone = telefone;
        this.nacionalidade = nacionalidade;
        this.cidade = cidade;
        this.estado = estado;
        this.pais = pais;
        this.fotoUrl = fotoUrl;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public int getIdade() {
        return idade;
    }

    public void setIdade(int idade) {
        this.idade = idade;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getNacionalidade() {
        return nacionalidade;
    }

    public void setNacionalidade(String nacionalidade) {
        this.nacionalidade = nacionalidade;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public String getFotoUrl() {
        return fotoUrl;
    }

    public void setFotoUrl(String fotoUrl) {
        this.fotoUrl = fotoUrl;
    }
}
