
/* ! 19nov2020 dballaelliott@gmail.com */

program define coef_store, rclass

syntax anything(name=var), /// 
    [fmt(string)] /// /* optional argument to modify the format */
    [STARs] /// /* dummy to include stars */
    [notex] /* pull out LaTeX formatting */  

    if "`tex'" != "notex"{
        local l = "^{"
        local r = "}"
    }

    if missing("`fmt'") local fmt "%10.3fc"

    lincom `var'
    local b = string(r(estimate), "`fmt'") 
    local se = "(" + string(r(se), "`fmt'") + ")"
    local p = r(p)

    local star=""
        if `p' >.05 & `p' <=.10 {   
            local star = "`l'*`r'"
        }
        if `p' >.01 & `p' <=.05 {   
            local star = "`l'**`r'"
        }
        if `p' <=.01 {  
            local star = "`l'***`r'" 
        }

    local p_val= string(`p', "`fmt'")
    tokenize "`fmt'", parse(".fgc")
    local digits = `3'

    if `p' < (10^-`digits')  local p_val= "$<$" + string(10^-`digits', "`fmt'")

    if `se' == `b' & `se' == 0 { 
        local b "\multicolumn{1}{c}{--}" 
        local se "" 
    }

    if !missing("`star'") local star "$`star'$"
    if "`stars'" != "stars" local star "" 


    return local beta = "`b'`star'"
    return local se = "`se'"
    return local p = "`p_val'"


end
