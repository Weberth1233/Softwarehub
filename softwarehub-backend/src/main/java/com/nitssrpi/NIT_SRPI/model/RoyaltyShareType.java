package com.nitssrpi.NIT_SRPI.model;

/*
ALTER TABLE public.royalty_shares
DROP CONSTRAINT IF EXISTS royalty_shares_type_check;

ALTER TABLE public.royalty_shares
ADD CONSTRAINT royalty_shares_type_check
CHECK (type IN ('UNIVERSITY', 'CREATOR', 'MEMBER', 'MEMBER_EXTERNAL'));
*/
public enum RoyaltyShareType {
    UNIVERSITY,
    CREATOR,
    MEMBER,
    MEMBER_EXTERNAL
}
