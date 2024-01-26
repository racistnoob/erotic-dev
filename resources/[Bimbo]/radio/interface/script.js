let CurrentRadioSound = 99;

$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case "open":
                initResolution()
                SlideUp()
                break;
            case "channel":

                $("#radio-freq").val(event.data.data)
                $('.status').html(event.data.data > 0 ? 'ACTIVE' : 'DISCON.').css("color", event.data.data > 0 ? '#00FF66' : "#ff0039");

                break;

            case "enabled":

                if (event.data.data) {
                    $('#radio-freq').show()
                    $('.ui-fix').show()
                    $('.rad-screen').css('background', '#10101D')
                } else {
                    $('#radio-freq').hide()
                    $('.ui-fix').hide()
                    $('.rad-screen').css('background', '#000')
                }

                break;

            case "volume":

                CurrentRadioSound = event.data.data
                $(`.soundBar`).hide();
                for (var i = 9; i <= Math.round(CurrentRadioSound / 9) * 9; i += 9) {
                    $(`.soundBar-${i}`).show();
                }
                break;

            case "close":
                SlideDown()
                break
            default:
                break;
        }
    });

    document.onkeyup = function(data) {
        if (data.which == 27) { // Escape key
            SlideDown()
        } else if (data.which == 13) { // Enter key
            $.post(`https://${GetParentResourceName()}/joinradio`, JSON.stringify({
                channel: $("#radio-freq").val()
            }));
        }
    };
});


function SlideUp() {

    $('.radioCont').css('top', '13%');

}

function SlideDown() {
    $('.radioCont').css('top', '95%');
    $.post(`https://${GetParentResourceName()}/closeradio`);
}

$('.power-btn').click(function(e) {
    $.post(`https://${GetParentResourceName()}/togglePower`)
});

$('.disconnect-btn').click(function(e) {
    $.post(`https://${GetParentResourceName()}/leaveradio`, JSON.stringify({
        channel: $("#radio-freq").val()
    }));
});

$('.connect-btn').click(function(e) {
    $.post(`https://${GetParentResourceName()}/joinradio`, JSON.stringify({
        channel: $("#radio-freq").val()
    }));
});

$('.volup-btn').click(function(e) {
    if ((CurrentRadioSound + 9) <= 99) {
        $.post(`https://${GetParentResourceName()}/updatevolume`, JSON.stringify({
            vol: Math.min(CurrentRadioSound + 9, 99)
        }));
    }
});

$('.voldown-btn').click(function(e) {
    if ((CurrentRadioSound - 9) >= 9) {
        $.post(`https://${GetParentResourceName()}/updatevolume`, JSON.stringify({
            vol: Math.max(CurrentRadioSound - 9, 9)
        }))
    }
});


function initResolution() {
    var $window = $(window);
    var $radioCont = $('.radioCont');

    function adjustRadioContPosition() {
        var windowWidth = $window.width();
        var windowHeight = $window.height();

        if (windowWidth >= 1280 && windowHeight >= 1024) {
            $radioCont.css('top', '35%');
        }

        if (windowWidth >= 1920 && windowHeight >= 1080) {
            $radioCont.css('top', '10%');
        }

        if (windowWidth >= 3440 && windowHeight >= 1440) {
            $radioCont.css('top', '-20%');
        }

        if (windowWidth >= 3840 && windowHeight >= 2160) {
            $radioCont.css('top', '10%');
        }

        if (windowWidth >= 5120 && windowHeight >= 1440) {
            $radioCont.css({
                'transform': 'scale(0.85)',
                'top': '-35%'
            });
        }
    }

    function throttle(fn, delay) {
        var timer = null;
        return function() {
            var context = this;
            var args = arguments;

            if (!timer) {
                timer = setTimeout(function() {
                    fn.apply(context, args);
                    timer = null;
                }, delay);
            }
        };
    }

    function debounce(fn, delay) {
        var timer = null;
        return function() {
            var context = this;
            var args = arguments;

            clearTimeout(timer);
            timer = setTimeout(function() {
                fn.apply(context, args);
            }, delay);
        };
    }

    var throttledResize = throttle(adjustRadioContPosition, 250);
    var debouncedResize = debounce(adjustRadioContPosition, 250);

    adjustRadioContPosition();
    $window.on('resize', throttledResize);
    $window.on('resize', debouncedResize);
}