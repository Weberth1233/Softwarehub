package com.nitssrpi.NIT_SRPI.controller.dto;

public abstract class ExceptionTradingRule extends RuntimeException {
    public ExceptionTradingRule(String message){
        super(message);
    }
}


