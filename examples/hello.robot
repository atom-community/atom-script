*** Settings ***
Library		String

*** Test cases ***
Hello
    ${left}    Left string    Robot Framework    5
    ${right}    Right string    Robot Framework    9
    ${robot}    Set Variable    ${left} ${right}
    Should Be Equal    Robot Framework    ${robot}

*** Keywords ***
Left string
    [Arguments]	${input}	${noChars}
    ${left}		Get Substring		${input}		0		${noChars}
    [Return]	 ${left}

Right string
    [Arguments]	${input}	${noChars}
    ${len}		Get Length		${input}
    ${start}		Evaluate		${len}-${noChars}
    ${left}		Get Substring		${input}		${start}
    [Return]	 ${left}
