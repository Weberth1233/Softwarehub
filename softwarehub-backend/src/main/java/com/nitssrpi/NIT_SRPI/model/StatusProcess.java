package com.nitssrpi.NIT_SRPI.model;

import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

public enum StatusProcess {
    PENDENTE_DISTRIBUICAO_COTAS("Aguardando distribuição de cotas"),
    COTAS_DISTRIBUIDAS("Cotas distribuídas"),
    CORRECAO("Em correção"),
    CORRIGIDO("Corrigido"),
    CLASSIFICADO("Classificado"),
    PENDENTE_DOCUMENTACAO("Documentação pendente"),
    FINALIZADO("Finalizado"),
    INATIVO("Inativo");

    private final String label;

    StatusProcess(String label) {
        this.label = label;
    }

    public String getLabel(){
        return  label;
    }



}