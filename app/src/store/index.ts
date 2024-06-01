import { readable } from "svelte/store";

export var contract = readable("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512");
export var token = readable("0x5FbDB2315678afecb367f032d93F642f64180aa3");
export var tokenName = readable("BRD");

/*  fix doer
    cancel task
    submit task
        video link input
      
    NAVBARS
        COMBINE

    ASKER
        Modularize

        Add BORD Tokens to the Create TASK thingy

        Drop doer
            Add datetime accepted to TASK struct
            Check if currentDatetime > datetimeAccepted+timeLimit
                true
                    DOER is droppable
                false
                    DOER is not droppable
            approve TASK

    
    //hover ghroup ihghlight htinhy

    BORD Token
        Make Buy Token Modal



*/
