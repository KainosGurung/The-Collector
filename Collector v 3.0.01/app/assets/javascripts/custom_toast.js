/**
 * Created by gurung on 3/29/15.
 */

function toast(type, message) {

    if (type == 'error') {
        var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all ui-icon ui-btn-icon-left ui-icon-alert"><h3>' + message + '</h3></div>');
        $toast.css({
            display: 'block',
            background: '#D11919',
            opacity: 0.75,
            position: 'fixed',
            padding: '7px',
            'text-align': 'center',
            width: '270px',
            left: $(window).width() - 300,
            top: 20
        });
    } else if  (type == 'info') {
        var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all ui-icon ui-btn-icon-left ui-icon-info"><h3>' + message + '</h3></div>');
        $toast.css({
            display: 'block',
            background: 'blue',
            opacity: 0.90,
            position: 'fixed',
            padding: '7px',
            'text-align': 'center',
            width: '270px',
            left: $(window).width() - 300,
            top: 20
        });
    } else if  (type == 'success') {
        var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all ui-icon ui-btn-icon-left ui-icon-check"><h3>' + message + '</h3></div>');
        $toast.css({
            display: 'block',
            background: '#33FF33',
            opacity: 0.75,
            position: 'fixed',
            padding: '7px',
            'text-align': 'center',
            width: '270px',
            'max-width': '90%',
            left: $(window).width() - 300,
            top: 20
        });
    }


    var removeToast = function(){
        $(this).remove();
    };

    $toast.click(removeToast);

    $toast.appendTo($.mobile.pageContainer).delay(3000);
    $toast.fadeOut(400, removeToast);
}
