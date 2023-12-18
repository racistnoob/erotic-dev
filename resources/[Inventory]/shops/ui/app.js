let currentInfo

$(document).keyup(function(e) {
    if (e.keyCode === 27)  {
        submitForm({value: 0})
    }
});

$(document).keypress(function(e) {
    if (e.keyCode == 13) {
        submitForm({value: $(".PINbox").val()})
        e.preventDefault();
    }
});

$(function () {    

    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.show == true) {
            currentInfo = data.data
            $("#PINcode").fadeTo("fast", 1, function () {
                $( "#PINcode" ).html(
                    "<form action='' method='' name='PINform' id='PINform' autocomplete='off' draggable='true'>" +
                        "<input class='PINbox' id='PINbox' type='password' value='' name='PINbox' />" +
                        "<br/>" +
                        "<input type='button' class='PINbutton' name='1' value='1' id='1' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton' name='2' value='2' id='2' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton' name='3' value='3' id='3' onClick=addNumber(this); />" +
                        "<br>" +
                        "<input type='button' class='PINbutton' name='4' value='4' id='4' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton' name='5' value='5' id='5' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton' name='6' value='6' id='6' onClick=addNumber(this); />" +
                        "<br>" +
                        "<input type='button' class='PINbutton' name='7' value='7' id='7' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton' name='8' value='8' id='8' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton' name='9' value='9' id='9' onClick=addNumber(this); />" +
                        "<br>" +
                        "<input type='button' class='PINbutton clear' name='-' value='clear' id='-' onClick=clearForm(this); />" +
                        "<input type='button' class='PINbutton' name='0' value='0' id='0' onClick=addNumber(this); />" +
                        "<input type='button' class='PINbutton enter' name='+' value='enter' id='+' onClick=submitForm(PINbox); />" +
                    "</form>"
                );
            });
        } else {
            $("#PINcode").fadeOut('fast', function() { 
                $('#PINcode').empty();
            });
        }
    });
});

$(function() {
	$( "#PINform" ).draggable();
});

function addNumber(e){
	var v = $( "#PINbox" ).val();
	$( "#PINbox" ).val( v + e.value );
}

function clearForm(e){
	$( "#PINbox" ).val( "" );
}

function submitForm(e) {
        fetch(`http://shops/getCodeResult`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ code: e.value, data: currentInfo })
        }).then(resp => resp.json()).then(resp => console.log(resp));
		$( "#PINbox" ).val( "" );
};