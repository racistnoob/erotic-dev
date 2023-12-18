let ButtonsData = [];
let Buttons = [];
let Button = [];

const OpenMenu = (data) => {
    DrawButtons(data)
}

const CloseMenu = () => {
    for (let i = 0; i < ButtonsData.length; i++) {
        let id = ButtonsData[i].id
        $(".button").remove();
    }
    ButtonsData = [];
    Buttons = [];
    Button = [];
};

const DrawButtons = (data) => {
    ButtonsData = data
    for (let i = 0; i < ButtonsData.length; i++) {
        let header = ButtonsData[i].header || ""
        let message = ButtonsData[i].txt || ""
        let id = ButtonsData[i].id
        let element = `<div class="button" id=${id}><div class="menuitem-left" id=${id}>`

        if (header != "") {
            element = element + `<div class="title" id=${id}>${header}</div>`
        }

        if (message != "") {
            element = element + `<div class="description" id=${id}>${message}</div></div>`
        } else {
            element = element + `</div></div>`
        }

        if (ButtonsData[i].params) {
            if (ButtonsData[i].params.arrow) {
                element = element + `<div class="menuitem-right" id=${id}><i class="fa-duotone fa-chevrons-right" id=${id}></i></div>`  
            }
        }

        element = element + `</div>`

        $('#menu').append(element);
        Buttons[id] = element
        if (ButtonsData[i].params) {
            Button[id] = ButtonsData[i].params
        }
        
    }
};

$(document).click(function(event){
    let $target = $(event.target);
    if ($target.closest('.button').length && $('.button').is(":visible")) {
        let id = event.target.id;
        if (!Button[id]) return
        PostData(id)
    }
})

const PostData = (id) => {
    $.post(`https://erp-context/dataPost`, JSON.stringify(Button[id]))
    return CloseMenu();
}

const CancelMenu = () => {
    $.post(`https://erp-context/cancel`)
    return CloseMenu();
}

window.addEventListener("message", (evt) => {
    const data = evt.data
    const info = data.data
    const action = data.action
    switch (action) {
        case "OPEN_MENU":
            return OpenMenu(info);
        case "CLOSE_MENU":
            return CloseMenu();
        default:
            return;
    }
})


document.onkeyup = function (event) {
    event = event || window.event;
    var charCode = event.keyCode || event.which;
    if (charCode == 27) {
        CancelMenu();
    }
};